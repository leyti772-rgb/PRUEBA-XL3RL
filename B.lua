-- shuts down the previous instance of SimpleSpy if
_G.SimpleSpyExecuted = false
if type(_G.SimpleSpyShutdown) == "function" then 
    pcall(_G.SimpleSpyShutdown) 
end

local Players        = game:GetService("Players")
local CoreGui        = game:GetService("CoreGui")
local Highlight      = loadstring(game:HttpGet("https://github.com/exxtremestuffs/SimpleSpySource/raw/master/highlight.lua"))()
---- GENERATED (kinda sorta mostly) BY GUI to LUA ----
-- Instances:
local SimpleSpy2      = Instance.new("ScreenGui")
local Background      = Instance.new("Frame")
local LeftPanel       = Instance.new("Frame")
local LogList         = Instance.new("ScrollingFrame")
local UIListLayout    = Instance.new("UIListLayout")
local RemoteTemplate  = Instance.new("Frame")
local ColorBar        = Instance.new("Frame")
local Text            = Instance.new("TextLabel")
local Button          = Instance.new("TextButton")
local RightPanel      = Instance.new("Frame")
local CodeBox         = Instance.new("Frame")
local ScrollingFrame  = Instance.new("ScrollingFrame")
local UIGridLayout    = Instance.new("UIGridLayout")
local FunctionTemplate= Instance.new("Frame")
local ColorBar_2      = Instance.new("Frame")
local Text_2          = Instance.new("TextLabel")
local Button_2        = Instance.new("TextButton")
local TopBar          = Instance.new("Frame")
local Simple          = Instance.new("TextButton")
local CloseButton     = Instance.new("TextButton")
local ImageLabel      = Instance.new("ImageLabel")
local MaximizeButton  = Instance.new("TextButton")
local ImageLabel_2    = Instance.new("ImageLabel")
local MinimizeButton  = Instance.new("TextButton")
local ImageLabel_3    = Instance.new("ImageLabel")
local ToolTip         = Instance.new("Frame")
local TextLabel       = Instance.new("TextLabel")
local gui = Instance.new("ScreenGui", Background)
local nextb = Instance.new("ImageButton", gui)
local guiCorner = Instance.new("UICorner", nextb)

--Properties:
SimpleSpy2.Name = "SimpleSpy2"
SimpleSpy2.ResetOnSpawn = false
-- Destroy existing if any
local existing = CoreGui:FindFirstChild(SimpleSpy2.Name)
if existing then existing:Destroy() end

Background.Name = "Background"
Background.Parent = SimpleSpy2
Background.BackgroundColor3 = Color3.new(1, 1, 1)
Background.BackgroundTransparency = 1
Background.Position = UDim2.new(0, 160, 0, 100)
Background.Size = UDim2.new(0, 450, 0, 268)
Background.Active = true
Background.Draggable = true

nextb.Position = UDim2.new(0,100,0,60)
nextb.Size = UDim2.new(0,40,0,40)
nextb.BackgroundColor3 = Color3.fromRGB(53, 52, 55)
nextb.Image = "rbxassetid://7072720870"
nextb.Active = true
nextb.Draggable = true
nextb.MouseButton1Down:connect(function()
    nextb.Image = (Background.Visible and "rbxassetid://7072720870") or "rbxassetid://7072719338"
    Background.Visible = not Background.Visible
end)

LeftPanel.Name = "LeftPanel"
LeftPanel.Parent = Background
LeftPanel.BackgroundColor3 = Color3.fromRGB(53, 52, 55)
LeftPanel.BorderSizePixel = 0
LeftPanel.Position = UDim2.new(0, 0, 0, 19)
LeftPanel.Size = UDim2.new(0, 131, 0, 249)

LogList.Name = "LogList"
LogList.Parent = LeftPanel
LogList.Active = true
LogList.BackgroundColor3 = Color3.new(1, 1, 1)
LogList.BackgroundTransparency = 1
LogList.BorderSizePixel = 0
LogList.Position = UDim2.new(0, 0, 0, 9)
LogList.Size = UDim2.new(0, 131, 0, 232)
LogList.CanvasSize = UDim2.new(0, 0, 0, 0)
LogList.ScrollBarThickness = 4

UIListLayout.Parent = LogList
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

RemoteTemplate.Name = "RemoteTemplate"
RemoteTemplate.Parent = LogList
RemoteTemplate.BackgroundColor3 = Color3.new(1, 1, 1)
RemoteTemplate.BackgroundTransparency = 1
RemoteTemplate.Size = UDim2.new(0, 117, 0, 27)

ColorBar.Name = "ColorBar"
ColorBar.Parent = RemoteTemplate
ColorBar.BackgroundColor3 = Color3.fromRGB(255, 242, 0)  -- Amarillo por defecto
ColorBar.BorderSizePixel = 0
ColorBar.Position = UDim2.new(0, 0, 0, 1)
ColorBar.Size = UDim2.new(0, 7, 0, 18)
ColorBar.ZIndex = 2

Text.Name = "Text"
Text.Parent = RemoteTemplate
Text.BackgroundColor3 = Color3.new(1, 1, 1)
Text.BackgroundTransparency = 1
Text.Position = UDim2.new(0, 12, 0, 1)
Text.Size = UDim2.new(0, 105, 0, 18)
Text.ZIndex = 2
Text.Font = Enum.Font.SourceSans
Text.Text = "TEXT"
Text.TextColor3 = Color3.new(1, 1, 1)
Text.TextSize = 14
Text.TextXAlignment = Enum.TextXAlignment.Left
Text.TextWrapped = true

Button.Name = "Button"
Button.Parent = RemoteTemplate
Button.BackgroundColor3 = Color3.new(0, 0, 0)
Button.BackgroundTransparency = 0.75
Button.BorderColor3 = Color3.new(1, 1, 1)
Button.Position = UDim2.new(0, 0, 0, 1)
Button.Size = UDim2.new(0, 117, 0, 18)
Button.AutoButtonColor = false
Button.Font = Enum.Font.SourceSans
Button.Text = ""
Button.TextColor3 = Color3.new(0, 0, 0)
Button.TextSize = 14

RightPanel.Name = "RightPanel"
RightPanel.Parent = Background
RightPanel.BackgroundColor3 = Color3.fromRGB(37, 36, 38)
RightPanel.BorderSizePixel = 0
RightPanel.Position = UDim2.new(0, 131, 0, 19)
RightPanel.Size = UDim2.new(0, 319, 0, 249)

CodeBox.Name = "CodeBox"
CodeBox.Parent = RightPanel
CodeBox.BackgroundColor3 = Color3.new(0.0823529, 0.0745098, 0.0784314)
CodeBox.BorderSizePixel = 0
CodeBox.Size = UDim2.new(0, 319, 0, 119)

ScrollingFrame.Parent = RightPanel
ScrollingFrame.Active = true
ScrollingFrame.BackgroundColor3 = Color3.new(1, 1, 1)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.Position = UDim2.new(0, 0.5, 0, 0)
ScrollingFrame.Size = UDim2.new(1, 0, 0.5, -9)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 4

UIGridLayout.Parent = ScrollingFrame
UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.CellPadding = UDim2.new(0, 0, 0, 0)
UIGridLayout.CellSize = UDim2.new(0, 94, 0, 27)

FunctionTemplate.Name = "FunctionTemplate"
FunctionTemplate.Parent = ScrollingFrame
FunctionTemplate.BackgroundColor3 = Color3.new(1, 1, 1)
FunctionTemplate.BackgroundTransparency = 1
FunctionTemplate.Size = UDim2.new(0, 117, 0, 23)

ColorBar_2.Name = "ColorBar"
ColorBar_2.Parent = FunctionTemplate
ColorBar_2.BackgroundColor3 = Color3.new(1, 1, 1)
ColorBar_2.BorderSizePixel = 0
ColorBar_2.Position = UDim2.new(0, 7, 0, 10)
ColorBar_2.Size = UDim2.new(0, 7, 0, 18)
ColorBar_2.ZIndex = 3

Text_2.Name = "Text"
Text_2.Parent = FunctionTemplate
Text_2.BackgroundColor3 = Color3.new(1, 1, 1)
Text_2.BackgroundTransparency = 1
Text_2.Position = UDim2.new(0, 19, 0, 10)
Text_2.Size = UDim2.new(0, 69, 0, 18)
Text_2.ZIndex = 2
Text_2.Font = Enum.Font.SourceSans
Text_2.Text = "TEXT"
Text_2.TextColor3 = Color3.new(1, 1, 1)
Text_2.TextSize = 14
Text_2.TextStrokeColor3 = Color3.new(0.145098, 0.141176, 0.14902)
Text_2.TextXAlignment = Enum.TextXAlignment.Left
Text_2.TextWrapped = true

Button_2.Name = "Button"
Button_2.Parent = FunctionTemplate
Button_2.BackgroundColor3 = Color3.new(0, 0, 0)
Button_2.BackgroundTransparency = 0.7
Button_2.BorderColor3 = Color3.new(1, 1, 1)
Button_2.Position = UDim2.new(0, 7, 0, 10)
Button_2.Size = UDim2.new(0, 80, 0, 18)
Button_2.AutoButtonColor = false
Button_2.Font = Enum.Font.SourceSans
Button_2.Text = ""
Button_2.TextColor3 = Color3.new(0, 0, 0)
Button_2.TextSize = 14

TopBar.Name = "TopBar"
TopBar.Parent = Background
TopBar.BackgroundColor3 = Color3.fromRGB(37, 35, 38)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(0, 450, 0, 19)

Simple.Name = "Simple"
Simple.Parent = TopBar
Simple.BackgroundColor3 = Color3.new(1, 1, 1)
Simple.AutoButtonColor = false
Simple.BackgroundTransparency = 1
Simple.Position = UDim2.new(0, 5, 0, 0)
Simple.Size = UDim2.new(0, 57, 0, 18)
Simple.Font = Enum.Font.SourceSansBold
Simple.Text = "SimpleSpy For Mobile"
Simple.TextColor3 = Color3.new(0, 0, 1)
Simple.TextSize = 14
Simple.TextXAlignment = Enum.TextXAlignment.Left

CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundColor3 = Color3.new(0.145098, 0.141176, 0.14902)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -19, 0, 0)
CloseButton.Size = UDim2.new(0, 19, 0, 19)
CloseButton.Font = Enum.Font.SourceSans
CloseButton.Text = ""
CloseButton.TextColor3 = Color3.new(0, 0, 0)
CloseButton.TextSize = 14

ImageLabel.Parent = CloseButton
ImageLabel.BackgroundColor3 = Color3.new(1, 1, 1)
ImageLabel.BackgroundTransparency = 1
ImageLabel.Position = UDim2.new(0, 5, 0, 5)
ImageLabel.Size = UDim2.new(0, 9, 0, 9)
ImageLabel.Image = "http://www.roblox.com/asset/?id=5597086202"

MaximizeButton.Name = "MaximizeButton"
MaximizeButton.Parent = TopBar
MaximizeButton.BackgroundColor3 = Color3.new(0.145098, 0.141176, 0.14902)
MaximizeButton.BorderSizePixel = 0
MaximizeButton.Position = UDim2.new(1, -38, 0, 0)
MaximizeButton.Size = UDim2.new(0, 19, 0, 19)
MaximizeButton.Font = Enum.Font.SourceSans
MaximizeButton.Text = ""
MaximizeButton.TextColor3 = Color3.new(0, 0, 0)
MaximizeButton.TextSize = 14

ImageLabel_2.Parent = MaximizeButton
ImageLabel_2.BackgroundColor3 = Color3.new(1, 1, 1)
ImageLabel_2.BackgroundTransparency = 1
ImageLabel_2.Position = UDim2.new(0, 5, 0, 5)
ImageLabel_2.Size = UDim2.new(0, 9, 0, 9)
ImageLabel_2.Image = "http://www.roblox.com/asset/?id=5597108117"

MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TopBar
MinimizeButton.BackgroundColor3 = Color3.new(0.145098, 0.141176, 0.14902)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(1, -57, 0, 0)
MinimizeButton.Size = UDim2.new(0, 19, 0, 19)
MinimizeButton.Font = Enum.Font.SourceSans
MinimizeButton.Text = ""
MinimizeButton.TextColor3 = Color3.new(0, 0, 0)
MinimizeButton.TextSize = 14

ImageLabel_3.Parent = MinimizeButton
ImageLabel_3.BackgroundColor3 = Color3.new(1, 1, 1)
ImageLabel_3.BackgroundTransparency = 1
ImageLabel_3.Position = UDim2.new(0, 5, 0, 5)
ImageLabel_3.Size = UDim2.new(0, 9, 0, 9)
ImageLabel_3.Image = "http://www.roblox.com/asset/?id=5597105827"

ToolTip.Name = "ToolTip"
ToolTip.Parent = SimpleSpy2
ToolTip.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
ToolTip.BackgroundTransparency = 0.1
ToolTip.BorderColor3 = Color3.new(1, 1, 1)
ToolTip.Size = UDim2.new(0, 200, 0, 50)
ToolTip.ZIndex = 3
ToolTip.Visible = false

TextLabel.Parent = ToolTip
TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0, 2, 0, 2)
TextLabel.Size = UDim2.new(0, 196, 0, 46)
TextLabel.ZIndex = 3
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "This is some slightly longer text."
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.TextSize = 14
TextLabel.TextWrapped = true
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.TextYAlignment = Enum.TextYAlignment.Top

-------------------------------------------------------------------------------
-- init
local RunService        = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local ContentProvider  = game:GetService("ContentProvider")
local TextService      = game:GetService("TextService")
local Mouse
local selectedColor    = Color3.new(0.321569, 0.333333, 1)
local deselectedColor  = Color3.new(0.8, 0.8, 0.8)
--- So things are descending
local layoutOrderNum = 999999999
--- Estado de la GUI
local mainClosing  = false  -- se está cerrando (minimizar)
local closed       = false  -- si la GUI está colapsada
local sideClosing  = false  -- se está cerrando barra lateral
local sideClosed   = false  -- panel lateral cerrado (oculto)
local maximized    = false  -- código expandido

--- Logs y configuraciones
local logs         = {}      -- registros de eventos
local blacklist    = {}      -- remotos excluidos
local blocklist    = {}      -- remotos bloqueados (no listarlos)
local getNil       = false   -- incluir función getNil si hace falta
local connectedRemotes = {}
local prevTables   = {}      -- para de-serialización
local remoteLogs   = {}
_G.SIMPLESPYCONFIG_MaxRemotes = 500  -- máximo registros
local indent      = 4
local scheduled   = {}
local schedulerconnect

local SimpleSpy   = {}
--- Funciones utilitarias de generación de código de SimpleSpy (value-to-string, etc.)
function SimpleSpy:ArgsToString(method, args)
    assert(typeof(method) == "string", "string expected")
    assert(typeof(args) == "table", "table expected")
    return v2v({ args = args }) .. "\n\n" .. method .. "(unpack(args))"
end
function SimpleSpy:TableToVars(t)
    assert(typeof(t) == "table", "table expected")
    return v2v(t)
end
function SimpleSpy:ValueToVar(value, variablename)
    assert(variablename == nil or typeof(variablename) == "string", "string expected")
    if not variablename then variablename = 1 end
    return v2v({ [variablename] = value })
end
function SimpleSpy:ValueToString(value)
    return v2s(value)
end
function SimpleSpy:GetFunctionInfo(func)
    assert(typeof(func) == "function", "Instance expected")
    warn("Function info not implemented (may crash in Synapse X).")
    return v2v({ functionInfo = { info = debug.getinfo(func), constants = debug.getconstants(func) } })
end

-- Signal internals (para eventos de remoto)
function newSignal()
    local connected = {}
    return {
        Connect = function(self, f)
            assert(connected, "Signal closed")
            connected[tostring(f)] = f
            return { Connected = true, Disconnect = function(self)
                if not connected then warn("Signal is already closed") end
                self.Connected = false
                connected[tostring(f)] = nil
            end}
        end,
        Wait = function(self)
            local thread = coroutine.running()
            local connection
            connection = self:Connect(function()
                connection:Disconnect()
                if coroutine.status(thread) == "suspended" then
                    coroutine.resume(thread)
                end
            end)
            coroutine.yield()
        end,
        Fire = function(self, ...)
            for _, f in pairs(connected) do
                coroutine.wrap(f)(...)
            end
        end,
    }
end

local remoteSignals = {}
local remoteHooks   = {}
_G.SimpleSpy = SimpleSpy
_G.getNil = function(name, class)
    for _, v in pairs(getnilinstances()) do
        if v.ClassName == class and v.Name == name then
            return v
        end
    end
end

-- Limpia registros antiguos para evitar lag
function clean()
    local max = _G.SIMPLESPYCONFIG_MaxRemotes
    if not (typeof(max) == "number" and math.floor(max) == max) then
        max = 500
    end
    if #remoteLogs > max then
        for i = 100, #remoteLogs do
            local v = remoteLogs[i]
            if typeof(v[1]) == "RBXScriptConnection" then
                v[1]:Disconnect()
            end
            if typeof(v[2]) == "Instance" then
                v[2]:Destroy()
            end
        end
        local newLogs = {}
        for i = 1, 100 do
            table.insert(newLogs, remoteLogs[i])
        end
        remoteLogs = newLogs
    end
end

-- Ajusta tamaño de ToolTip según texto
function scaleToolTip()
    local size = TextService:GetTextSize(TextLabel.Text, TextLabel.TextSize, TextLabel.Font, Vector2.new(196, math.huge))
    TextLabel.Size = UDim2.new(0, size.X, 0, size.Y)
    ToolTip.Size   = UDim2.new(0, size.X + 4, 0, size.Y + 4)
end

-- Eventos del menú
function onToggleButtonHover()
    if not toggle then
        TweenService:Create(Simple, TweenInfo.new(0.5), {TextColor3 = Color3.fromRGB(252, 51, 51)}):Play()
    else
        TweenService:Create(Simple, TweenInfo.new(0.5), {TextColor3 = Color3.fromRGB(68, 206, 91)}):Play()
    end
end
function onToggleButtonUnhover()
    TweenService:Create(Simple, TweenInfo.new(0.5), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end
function onXButtonHover()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 60, 60)}):Play()
end
function onXButtonUnhover()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(37, 36, 38)}):Play()
end

-- Alterna el método de espionaje (hookmetamethod vs hookfunction)
local toggle = false
function toggleSpyMethod()
    toggleSpy()
    toggle = not toggle
end

-- Tarea de planificador (para generar código sin trabar)
function schedule(f, ...)
    table.insert(scheduled, {f, ...})
end
function scheduleWait()
    local thread = coroutine.running()
    schedule(function() coroutine.resume(thread) end)
    coroutine.yield()
end
function taskscheduler()
    if not toggle then scheduled = {} return end
    if #scheduled > 1000 then table.remove(scheduled, #scheduled) end
    if #scheduled > 0 then
        local current = scheduled[1]
        table.remove(scheduled, 1)
        if type(current) == "table" and type(current[1]) == "function" then
            pcall(unpack(current))
        end
    end
end

-- Maneja el evento remoto capturado (hookfunction)
function remoteHandler(hookfunction, methodName, remote, args, funcInfo, calling, returnValue)
    local ok, isRemote = pcall(function() 
        return remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") 
    end)
    if not ok or not isRemote then return end

    -- Dispara señal interna
    if remoteSignals[remote] then
        remoteSignals[remote]:Fire(args)
    end

    -- Construye texto para genScript (posponer por performance)
    local remoteType = (methodName:lower():find("fireserver") and "event") or "function"
    local functionInfoStr = ""
    local src = nil
    if funcInfo.func and islclosure(funcInfo.func) then
        local functionInfo = {}
        functionInfo.info = funcInfo
        pcall(function() functionInfo.constants = debug.getconstants(funcInfo.func) end)
        pcall(function() functionInfoStr = v2v({functionInfo = functionInfo}) end)
        if type(calling) == "userdata" then
            src = calling
        end
    end

    -- Agrega nuevo log
    local newLog = {Name = remote.Name, Function = functionInfoStr, Remote = setmetatable({remote = remote}, {__mode = "v"}), Log = nil, Blocked = (blocklist[remote] or blocklist[remote.Name]), Source = src, GenScript = "-- Generating...", ReturnValue = returnValue}
    logs[#logs+1] = newLog
    schedule(function()
        newLog.GenScript = genScript(remote, args)
        if newLog.Blocked then
            newLog.GenScript = "-- THIS REMOTE WAS PREVENTED FROM FIRING BY SIMPLESPY\n\n" .. newLog.GenScript
        end
    end)

    -- Crea GUI entry
    local remoteFrame = RemoteTemplate:Clone()
    remoteFrame.Text.Text = string.sub(remote.Name,1,50)
    remoteFrame.ColorBar.BackgroundColor3 = (remote:IsA("RemoteEvent") and Color3.fromRGB(255,242,0)) or Color3.fromRGB(99,86,245)
    local id = Instance.new("IntValue", remoteFrame)
    id.Name = "ID"
    id.Value = #logs
    remoteFrame.Parent = LogList
    remoteFrame.LayoutOrder = layoutOrderNum
    layoutOrderNum = layoutOrderNum - 1

    table.insert(remoteLogs, 1, {connect, remoteFrame})
    clean()
    ScrollingFrame.CanvasSize = UDim2.fromOffset(UIGridLayout.AbsoluteContentSize.X, UIGridLayout.AbsoluteContentSize.Y)
    LogList.CanvasSize       = UDim2.fromOffset(UIListLayout.AbsoluteContentSize.X, UIListLayout.AbsoluteContentSize.Y)

    -- Clic en remota: muestra código
    remoteFrame.Button.MouseButton1Click:Connect(function()
        if selected and selected.Log then
            TweenService:Create(selected.Log.Button, TweenInfo.new(0.5), {BackgroundColor3 = Color3.fromRGB(0,0,0)}):Play()
            selected = nil
        end
        for _, v in pairs(logs) do
            if remoteFrame == v.Log then
                selected = v
                break
            end
        end
        if selected and selected.Log then
            TweenService:Create(remoteFrame.Button, TweenInfo.new(0.5), {BackgroundColor3 = Color3.fromRGB(92,126,229)}):Play()
            codebox:setRaw(selected.GenScript)
        end
        if sideClosed then toggleSideTray() end
    end)
end

-- Genera el código Lua para reproducir la llamada remota
function genScript(remote, args)
    prevTables = {}
    local gen = ""
    if #args > 0 then
        local ok1, res1 = pcall(function() gen = v2v({args=args}).."\n" end)
        if not ok1 then
            gen = gen.."-- TableToString failure! using legacy\nlocal args = {" 
            local ok2 = pcall(function()
                for i,v in pairs(args) do
                    gen = gen..(type(i)~="Instance" and type(i)~="userdata" and "[object] = " or "")
                    if type(i)=="string" then
                        gen = gen..'["'..i..'"] = '
                    elseif type(i)=="userdata" and typeof(i)~="Instance" then
                        gen = gen..string.format("nil --[[%s]]", typeof(v)).." = "
                    elseif typeof(i)=="Instance" then
                        gen = gen.."[game."..i:GetFullName().."] = "
                    end
                    if type(v)~="Instance" and type(v)~="userdata" then
                        gen = gen.."object"
                    elseif type(v)=="string" then
                        gen = gen..'"'..v..'"'
                    elseif type(v)=="userdata" and typeof(v)~="Instance" then
                        gen = gen..string.format("nil --[[%s]]", typeof(v))
                    elseif typeof(v)=="Instance" then
                        gen = gen.."game."..v:GetFullName()
                    end
                    gen = gen..";"
                end
                gen = gen.."\n}"
            end)
            if not ok2 then
                gen = gen.."}\n-- Unable to serialize args."
            end
        end
        if not remote:IsDescendantOf(game) then
            gen = "function getNil(name,class) for _,v in pairs(getnilinstances()) do if v.ClassName==class and v.Name==name then return v end end end\n\n"..gen
        end
        if remote:IsA("RemoteEvent") then
            gen = gen .. v2s(remote) .. ":FireServer(unpack(args))"
        elseif remote:IsA("RemoteFunction") then
            gen = gen .. v2s(remote) .. ":InvokeServer(unpack(args))"
        end
    else
        if remote:IsA("RemoteEvent") then
            gen = gen .. v2s(remote) .. ":FireServer()"
        elseif remote:IsA("RemoteFunction") then
            gen = gen .. v2s(remote) .. ":InvokeServer()"
        end
    end
    prevTables = {}
    return gen
end

-- (Funciones auxiliares v2s, v2v, etc. se asumen aquí tal cual en código original...)
-- Por brevedad no se repiten todas las funciones de serialización interna (v2s, t2s, i2p, etc.)

-- Función para registrar la llamada __namecall o InvokeServer
local function hookRemoteCall(remoteType, remote, ...)
    if typeof(remote) == "Instance" then
        local args = {...}
        local name = (remoteType == "RemoteEvent" and "FireServer") or "InvokeServer"
        remoteHandler(false, name, remote, args, debug.getinfo(3) or {}, (useGetCallingScript and getcallingscript()) or nil, nil)
        if (remoteType=="RemoteFunction") then
            return original(remote, unpack(args))
        else
            return original(remote, unpack(args))
        end
    end
end

-- Hook de __namecall para capturar invocaciones sin usar hookfunction
local originalNamecall
local function newNamecall(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" or method == "InvokeServer" then
        return hookRemoteCall((method:lower()=="fireserver" and "RemoteEvent") or "RemoteFunction", self, ...)
    end
    return original(self, ...)
end

-- Habilita/deshabilita espionaje
function toggleSpy()
    if not toggle then
        -- Activar hooking
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        original = original or mt.__namecall
        mt.__namecall = newNamecall
        setreadonly(mt, true)
    else
        -- Restaurar original
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        mt.__namecall = original
        setreadonly(mt, true)
    end
end

-- Finaliza el spy, limpia conexiones
function shutdown()
    if schedulerconnect then schedulerconnect:Disconnect() end
    for _, connection in pairs(connections) do
        pcall(function() connection:Disconnect() end)
    end
    SimpleSpy2:Destroy()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    mt.__namecall = original
    setreadonly(mt, true)
    _G.SimpleSpyExecuted = false
end

-- *Main*
if not _G.SimpleSpyExecuted then
    local ok, err = pcall(function()
        if not RunService:IsClient() then
            error("SimpleSpy no puede correr en el servidor.")
        end
        if not getrawmetatable or not getrawmetatable(game).__namecall or not setreadonly then
            shutdown()
            error("Tu executor no soporta los hooks necesarios para SimpleSpy.")
        end

        _G.SimpleSpyShutdown = shutdown
        ContentProvider:PreloadAsync({ImageLabel, ImageLabel_2, ImageLabel_3})
        onToggleButtonClick()
        RemoteTemplate.Parent = nil
        FunctionTemplate.Parent = nil
        codebox = Highlight.new(CodeBox)
        codebox:setRaw("")
        _G.SimpleSpy = SimpleSpy

        Mouse = Players.LocalPlayer:GetMouse()
        table.insert(connections, Mouse.Move:Connect(function() end))
        table.insert(connections, UserInputService.InputBegan:Connect(backgroundUserInput))

        RunService.Heartbeat:Connect(taskscheduler)
        SimpleSpy2.Parent = CoreGui
        _G.SimpleSpyExecuted = true
    end)
    if not ok then
        warn("SimpleSpy no pudo iniciarse:\n"..tostring(err))
        SimpleSpy2:Destroy()
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        mt.__namecall = original
        setreadonly(mt, true)
    end
else
    SimpleSpy2:Destroy()
end
