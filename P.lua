--// XLSpy UI – Visor rápido, anti-lag y compacto (Mobile Friendly)
--// No hookea remotos. Solo muestra lo que tú le envíes con XLSpy.Push(...)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

--==================================================
-- Helpers UI
--==================================================
local function Make(class, props, parent)
    local i = Instance.new(class)
    if props then for k,v in pairs(props) do i[k] = v end end
    if parent then i.Parent = parent end
    return i
end

local function Round(parent, r)
    Make("UICorner", {CornerRadius = UDim.new(0, r or 10)}, parent)
end

local function Stroke(parent, th, col, tr)
    Make("UIStroke", {Thickness = th or 1, Color = col or Color3.new(1,1,1), Transparency = tr or 0}, parent)
end

local function Draggable(frame)
    frame.Active = true; frame.Draggable = true
end

--==================================================
-- Estado interno
--==================================================
local XLSpy = {
    _gui = nil,
    _open = true,
    _paused = false,
    _rowH = 28,
    _maxItems = 2000,        -- máximo grupos visibles
    _pruneStep = 25,         -- limpieza incremental
    _flushRate = 0.06,       -- segundos entre lotes
    _flushChunk = 120,       -- items por lote
    _pool = {},              -- pool de rows
    _rows = {},              -- idx -> Frame
    _items = {},             -- lista de grupos {sig,name,path,count,lastArgs,time,gen,cache}
    _sigMap = {},            -- firma -> index en _items
    _incoming = {},          -- cola sin procesar
    _dirty = true,
}

-- Firma por ruta + tipos (no serializa valores)
local function signature(remotePath, args)
    local t = table.create(#args)
    for i=1,#args do t[i] = typeof(args[i]) end
    return remotePath .. ":" .. table.concat(t, ",")
end

local function typesStr(args)
    local t = table.create(#args)
    for i=1,#args do t[i] = typeof(args[i]) end
    return table.concat(t, ", ")
end

--==================================================
-- GUI
--==================================================
local gui = Make("ScreenGui", {
    Name = "XLSpy_UI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, LP:WaitForChild("PlayerGui"))
XLSpy._gui = gui

-- HUD flotante
local hud = Make("Frame", {
    Size = UDim2.new(0, 54, 0, 54),
    Position = UDim2.new(0.13, 0, 0.20, 0),
    BackgroundColor3 = Color3.fromRGB(26,26,26)
}, gui)
Round(hud, 27)
Stroke(hud, 2, Color3.fromRGB(0,255,160))
Draggable(hud)

local hudBtn = Make("TextButton", {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1,1),
    Text = "XL",
    Font = Enum.Font.GothamBlack,
    TextSize = 22,
    TextColor3 = Color3.fromRGB(255,255,255)
}, hud)

local hudBadge = Make("TextLabel", {
    AnchorPoint = Vector2.new(1,0),
    Position = UDim2.new(1,-4,0,4),
    Size = UDim2.new(0, 24, 0, 18),
    BackgroundColor3 = Color3.fromRGB(0,180,120),
    Text = "0",
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextColor3 = Color3.new(1,1,1)
}, hud)
Round(hudBadge, 9)

-- Ventana principal (compacta)
local win = Make("Frame", {
    Size = UDim2.new(0, 560, 0, 290),
    Position = UDim2.new(0.5, -280, 0.5, -145),
    BackgroundColor3 = Color3.fromRGB(22,22,22),
    Visible = true
}, gui)
XLSpy._window = win
Round(win, 16)
Stroke(win, 2, Color3.fromRGB(0,255,160))

Draggable(win)

-- Header
local header = Make("Frame", {
    Size = UDim2.new(1,0,0,34),
    BackgroundTransparency = 1
}, win)
local title = Make("TextLabel", {
    Size = UDim2.new(1,-140,1,0),
    BackgroundTransparency = 1,
    Text = "XL Spy – Compact",
    Font = Enum.Font.GothamBlack,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = Color3.fromRGB(0,255,200)
}, header)

local btnPause = Make("TextButton", {
    Position = UDim2.new(1,-136,0,4),
    Size = UDim2.new(0, 72, 0, 26),
    Text = "Pausar",
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    BackgroundColor3 = Color3.fromRGB(40,40,40),
    TextColor3 = Color3.fromRGB(255,255,255),
    AutoButtonColor = true
}, header)
Round(btnPause, 8)

local btnClear = Make("TextButton", {
    Position = UDim2.new(1,-60,0,4),
    Size = UDim2.new(0, 56, 0, 26),
    Text = "Limpiar",
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    BackgroundColor3 = Color3.fromRGB(60,40,40),
    TextColor3 = Color3.fromRGB(255,255,255),
    AutoButtonColor = true
}, header)
Round(btnClear, 8)

-- Split: Lista izquierda + Detalle derecha
local left = Make("Frame", {
    Position = UDim2.new(0, 8, 0, 38),
    Size = UDim2.new(0.54, -12, 1, -46),
    BackgroundTransparency = 1
}, win)

local search = Make("TextBox", {
    Size = UDim2.new(1,0,0,26),
    PlaceholderText = "Buscar (nombre o ruta)",
    Text = "",
    Font = Enum.Font.Gotham,
    TextSize = 13,
    TextColor3 = Color3.new(1,1,1),
    BackgroundColor3 = Color3.fromRGB(32,32,32),
    ClearTextOnFocus = false
}, left)
Round(search, 8)

local list = Make("ScrollingFrame", {
    Position = UDim2.new(0, 0, 0, 32),
    Size = UDim2.new(1,0,1,-32),
    ScrollBarThickness = 6,
    CanvasSize = UDim2.new(),
    BackgroundColor3 = Color3.fromRGB(18,18,18)
}, left)
Round(list, 10)

-- Panel derecho (detalle)
local right = Make("Frame", {
    Position = UDim2.new(0.54, 8, 0, 38),
    Size = UDim2.new(0.46, -16, 1, -46),
    BackgroundColor3 = Color3.fromRGB(18,18,18)
}, win)
Round(right, 10)

local codeBox = Make("TextLabel", {
    Position = UDim2.new(0,8,0,8),
    Size = UDim2.new(1,-16,1,-48),
    BackgroundColor3 = Color3.fromRGB(8,8,8),
    Text = "-- Selecciona un log para generar el script…",
    Font = Enum.Font.Code,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(230,230,230),
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    RichText = false
}, right)
Round(codeBox, 8)

local btnGen = Make("TextButton", {
    Position = UDim2.new(0,8,1,-36),
    Size = UDim2.new(0, 110, 0, 28),
    Text = "Generar",
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    BackgroundColor3 = Color3.fromRGB(36,36,36),
    TextColor3 = Color3.new(1,1,1)
}, right)
Round(btnGen, 8)

local btnCopy = Make("TextButton", {
    Position = UDim2.new(0,128,1,-36),
    Size = UDim2.new(0, 90, 0, 28),
    Text = "Copiar",
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    BackgroundColor3 = Color3.fromRGB(36,36,36),
    TextColor3 = Color3.new(1,1,1)
}, right)
Round(btnCopy, 8)

local status = Make("TextLabel", {
    Position = UDim2.new(0, 230, 1, -36),
    Size = UDim2.new(1,-238,0,28),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = Color3.fromRGB(180,180,180),
    TextXAlignment = Enum.TextXAlignment.Right,
    Text = "Items: 0 • Cola: 0"
}, right)

--==================================================
-- Pool de filas
--==================================================
local function acquireRow()
    local row = table.remove(XLSpy._pool)
    if row then return row end
    row = Make("TextButton", {
        Size = UDim2.new(1,-8,0,XLSpy._rowH-2),
        BackgroundColor3 = Color3.fromRGB(28,28,28),
        Text = "",
        AutoButtonColor = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = Color3.new(1,1,1)
    })
    Round(row, 8)
    Stroke(row, 1, Color3.fromRGB(60,60,60), 0.5)

    local nameL = Make("TextLabel", {
        Name = "Name",
        BackgroundTransparency = 1,
        Position = UDim2.new(0,10,0,0),
        Size = UDim2.new(1,-120,1,0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = Color3.new(1,1,1),
        Text = ""
    }, row)

    local countL = Make("TextLabel", {
        Name = "Count",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1,0),
        Position = UDim2.new(1,-10,0,0),
        Size = UDim2.new(0, 90, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Right,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(0,255,160),
        Text = "x1"
    }, row)

    return row
end

local function releaseRow(row)
    row.Parent = nil
    table.insert(XLSpy._pool, row)
end

--==================================================
-- Pintado virtualizado
--==================================================
XLSpy._firstIndex = 1
XLSpy._lastIndex  = 0
XLSpy._selected   = nil

local function updateStatus()
    status.Text = string.format("Items: %d • Cola: %d", #XLSpy._items, #XLSpy._incoming)
end

local function rowSet(row, idx, item)
    row.Name = "row_"..idx
    row.Position = UDim2.new(0, 4, 0, (idx-1)*XLSpy._rowH)
    row.Text = ""
    row.Name.Text = string.format("%s  [%s]", item.name, item.types)
    row.Count.Text = "x"..item.count
    row.MouseButton1Click:Connect(function()
        XLSpy._selected = idx
        codeBox.Text = "-- Generando…"
    end)
end

local function repaint()
    if not XLSpy._dirty then return end
    XLSpy._dirty = false

    -- actualizar Canvas
    list.CanvasSize = UDim2.new(0,0,0,#XLSpy._items * XLSpy._rowH)

    -- calcular rango visible
    local top = math.max(1, math.floor(list.CanvasPosition.Y / XLSpy._rowH) - 2)
    local vis = math.ceil(list.AbsoluteWindowSize.Y / XLSpy._rowH) + 4
    local bottom = math.min(#XLSpy._items, top + vis)

    -- liberar filas previas
    for i = XLSpy._firstIndex, XLSpy._lastIndex do
        local r = XLSpy._rows[i]
        if r then releaseRow(r); XLSpy._rows[i] = nil end
    end

    -- crear filas visibles
    for i = top, bottom do
        local item = XLSpy._items[i]
        local row = acquireRow()
        row.Parent = list
        rowSet(row, i, item)
        XLSpy._rows[i] = row
    end

    XLSpy._firstIndex = top
    XLSpy._lastIndex = bottom
    updateStatus()
end

list:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    XLSpy._dirty = true
    repaint()
end)

search:GetPropertyChangedSignal("Text"):Connect(function()
    XLSpy._dirty = true
    repaint()
end)

--==================================================
-- Flujo: push -> cola -> grupos -> pinta
--==================================================
local flushing = false
local function flushLoop()
    if flushing or XLSpy._paused then return end
    flushing = true
    while #XLSpy._incoming > 0 and not XLSpy._paused do
        local take = math.min(XLSpy._flushChunk, #XLSpy._incoming)
        for i=1,take do
            local it = table.remove(XLSpy._incoming, 1)
            -- filtro por búsqueda
            local q = string.lower(search.Text or "")
            if q == "" or string.find(string.lower(it.name..it.path), q, 1, true) then
                -- agrupa por firma
                local idx = XLSpy._sigMap[it.sig]
                if idx then
                    local g = XLSpy._items[idx]
                    g.count += 1
                    g.time = it.time
                    g.lastArgs = it.args
                else
                    local rec = {
                        sig = it.sig, name = it.name, path = it.path,
                        types = typesStr(it.args),
                        count = 1, lastArgs = it.args, time = it.time,
                        gen = it.gen, cache = nil
                    }
                    table.insert(XLSpy._items, rec)
                    XLSpy._sigMap[it.sig] = #XLSpy._items
                end
            end
        end

        -- poda incremental
        if #XLSpy._items > XLSpy._maxItems then
            for j=1,XLSpy._pruneStep do
                local drop = table.remove(XLSpy._items, 1)
                if not drop then break end
            end
            -- recomputa mapa
            XLSpy._sigMap = {}
            for k=1,#XLSpy._items do XLSpy._sigMap[XLSpy._items[k].sig] = k end
        end

        XLSpy._dirty = true
        repaint()
        task.wait(XLSpy._flushRate)
    end
    flushing = false
end

--==================================================
-- API pública
--==================================================
function XLSpy.Push(name, remotePath, args, genScriptFn)
    -- name: "RE/UseItem"  | remotePath: "ReplicatedStorage.Packages.Net.RE/UseItem"
    -- args: array de argumentos (tal cual los recibes)
    -- genScriptFn: function() -> string  // genera y devuelve el script, SOLO cuando se llame
    local rec = {
        name = name or "Remote",
        path = remotePath or "?",
        args = args or {},
        time = os.clock(),
        sig = signature(remotePath or "?", args or {}),
        gen = genScriptFn
    }
    table.insert(XLSpy._incoming, rec)
    hudBadge.Text = tostring(#XLSpy._incoming)
    flushLoop()
end

function XLSpy.Toggle()
    win.Visible = not win.Visible
end

hudBtn.MouseButton1Click:Connect(function()
    XLSpy.Toggle()
end)

btnPause.MouseButton1Click:Connect(function()
    XLSpy._paused = not XLSpy._paused
    btnPause.Text = XLSpy._paused and "Reanudar" or "Pausar"
    if not XLSpy._paused then flushLoop() end
end)

btnClear.MouseButton1Click:Connect(function()
    -- limpieza suave
    XLSpy._incoming = {}
    for i=XLSpy._firstIndex,XLSpy._lastIndex do
        local r = XLSpy._rows[i]; if r then releaseRow(r); XLSpy._rows[i]=nil end
    end
    XLSpy._items = {}; XLSpy._sigMap = {}
    XLSpy._dirty = true; repaint()
    hudBadge.Text = "0"
end)

btnGen.MouseButton1Click:Connect(function()
    local idx = XLSpy._selected
    if not idx then return end
    local item = XLSpy._items[idx]
    if not item then return end
    if not item.cache and item.gen then
        -- genera una sola vez
        local ok, res = pcall(item.gen)
        item.cache = ok and res or ("-- Error al generar: "..tostring(res))
    end
    codeBox.Text = item.cache or "-- Sin generador provisto"
end)

btnCopy.MouseButton1Click:Connect(function()
    local idx = XLSpy._selected
    if not idx then return end
    local item = XLSpy._items[idx]
    if item and item.cache then
        -- intenta copiar (algunos ejecutores soportan setclipboard)
        if setclipboard then
            pcall(setclipboard, item.cache)
        end
        codeBox.Text = item.cache .. "\n-- (Copiado)"
    end
end)

-- Tecla rápida (RightShift)
UserInputService.InputBegan:Connect(function(inp, gpe)
    if not gpe and inp.KeyCode == Enum.KeyCode.RightShift then
        XLSpy.Toggle()
    end
end)

-- Re-pinta inicial
XLSpy._dirty = true
repaint()

_G.XLSpy = XLSpy  -- por si quieres acceder globalmente
--==================================================
-- FIN DEL MÓDULO XLSpy UI
--==================================================


--[[ ============================================================
Cómo alimentarlo desde TU código (adaptador simple):
Llama a XLSpy.Push(nombre, rutaCompleta, args, function() return "--tu script--" end)

Ejemplo mínimo de integración con tu logger/spy actual:
(Este ejemplo NO hookea; asume que ya recibes name, path y args)
================================================================ ]]

--[[
local function onRemoteCaptured(name, fullPath, args)
    XLSpy.Push(
        name,
        fullPath,
        args,
        function()
            -- Generación perezosa: solo se corre al pulsar "Generar"
            -- Devuelve el script “bonito” como lo quieras ver:
            local ts = {}
            table.insert(ts, "-- Script generado (XLSpy)")
            table.insert(ts, "local args = {")
            for i,v in ipairs(args) do
                local s
                local t = typeof(v)
                if t == "Vector3" then
                    s = ("    [%d] = Vector3.new(%s,%s,%s),"):format(i, tostring(v.X), tostring(v.Y), tostring(v.Z))
                elseif t == "CFrame" then
                    local cf = {v:GetComponents()}
                    s = ("    [%d] = CFrame.new(%s),"):format(i, table.concat(cf, ","))
                elseif t == "Instance" then
                    s = ("    [%d] = workspace:FindFirstChild(%q) or %s,"):format(i, v.Name, v:GetFullName())
                elseif t == "string" then
                    s = ("    [%d] = %q,"):format(i, v)
                else
                    s = ("    [%d] = %s,"):format(i, tostring(v))
                end
                table.insert(ts, s)
            end
            table.insert(ts, "}")
            table.insert(ts, ("game:GetService(%q):WaitForChild(%q) -- ruta: %s")
                :format("ReplicatedStorage", name, fullPath))
            return table.concat(ts, "\n")
        end
    )
end

-- Llama onRemoteCaptured(...) donde ya produzcas tus logs
]]
