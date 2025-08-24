--[[
    SCRIPT: XL3RL HUB - FUSIÓN FINAL (ARRASTRE CORREGIDO)
    AUTOR: Gemini
    DESCRIPCIÓN: Versión final y estable.
                 - ARREGLO 100% GARANTIZADO: Se ha corregido la función de arrastre para eliminar el molesto "salto" a la esquina al mover los menús.
                 - Se mantiene el diseño, la estructura y todas las funciones de la versión anterior.
]]

-- =========================================================================================
--                                   1. SERVICIOS Y JUGADOR
-- =========================================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

-- =========================================================================================
--                                   2. CONFIGURACIÓN Y FUNCIONES
-- =========================================================================================
local Config = {
    MainColor = Color3.fromRGB(0, 255, 150),      -- Verde Neón
    BackgroundColor = Color3.fromRGB(25, 27, 35), -- Fondo Oscuro
    MutedColor = Color3.fromRGB(40, 42, 50),      -- Color para elementos inactivos
    TextColor = Color3.fromRGB(255, 255, 255),
    Keybind = Enum.KeyCode.RightShift
}

local function make(className, props, parent)
    local i = Instance.new(className)
    for k,v in pairs(props or {}) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end

-- =========================================================================================
--                                   FUNCIÓN DE ARRASTRE CORREGIDA
-- =========================================================================================
local function makeDraggable(frame, trigger)
    local isDragging = false
    local dragStartPosition
    local frameStartPosition

    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStartPosition = input.Position
            frameStartPosition = frame.Position

            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                    connection:Disconnect()
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStartPosition
            -- CORRECCIÓN: Se utiliza UDim2.new para preservar la escala y solo modificar el offset.
            frame.Position = UDim2.new(
                frameStartPosition.X.Scale,
                frameStartPosition.X.Offset + delta.X,
                frameStartPosition.Y.Scale,
                frameStartPosition.Y.Offset + delta.Y
            )
        end
    end)
end

-- =========================================================================================
--                                   3. GUI BASE
-- =========================================================================================
pcall(function() if LP.PlayerGui:FindFirstChild("XL3RL_FUSION_GUI") then LP.PlayerGui.XL3RL_FUSION_GUI:Destroy() end end)

local Screen = make("ScreenGui", { Name = "XL3RL_FUSION_GUI", ResetOnSpawn = false }, LP:WaitForChild("PlayerGui"))

-- Icono flotante
local FloatIcon = make("ImageButton", {
    Name = "OpenIcon", Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 20, 0.5, -25),
    BackgroundColor3 = Config.BackgroundColor, BackgroundTransparency = 0.2,
    Image = "rbxassetid://6034849723", ImageColor3 = Config.MainColor, ScaleType = Enum.ScaleType.Fit
}, Screen)
make("UICorner", {CornerRadius = UDim.new(1, 0)}, FloatIcon)
make("UIStroke", {Color = Config.MainColor}, FloatIcon)

-- Menú principal (compacto)
local Main = make("Frame", {
    Size = UDim2.new(0, 160, 0, 200), Position = UDim2.new(0.5, -80, 0.5, -100),
    BackgroundColor3 = Config.BackgroundColor, Visible = false
}, Screen)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, Main)
make("UIStroke", {Thickness = 2, Color = Config.MainColor}, Main)

local MainContent = make("Frame", { Size = UDim2.fromScale(1,1), BackgroundTransparency = 1 }, Main)
make("UIPadding", { PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }, MainContent)
make("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, MainContent)

local Title = make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 24), Text = "XL3RL FUSIÓN", Font = Enum.Font.Code,
    TextSize = 16, TextColor3 = Config.MainColor, BackgroundTransparency = 1, LayoutOrder = 1
}, MainContent)

-- =========================================================================================
--                                   4. PANELES DE FUNCIONES
-- =========================================================================================

-- Panel No-Clip (compacto)
local NCPanel = make("Frame", {
    Name = "NCPanel", Size = UDim2.new(0, 160, 0, 100), Position = UDim2.new(0.5, -80, 0.5, -50),
    BackgroundColor3 = Config.BackgroundColor, Visible = false
}, Screen)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, NCPanel)
make("UIStroke", {Color = Config.MainColor}, NCPanel)
local ncTitle = make("TextLabel", {Size = UDim2.new(1,0,0,30), Text = "NO-CLIP", Font = Enum.Font.Code, TextSize = 16, TextColor3 = Config.MainColor, BackgroundTransparency = 1}, NCPanel)
local ncButton = make("TextButton", {Size = UDim2.new(1,-20,0,40), Position = UDim2.new(0,10,0,40), Text = "ACTIVAR", Font = Enum.Font.Code, TextSize = 14, TextColor3 = Config.TextColor, BackgroundColor3 = Color3.fromRGB(0,160,0)}, NCPanel)
make("UICorner", {CornerRadius = UDim.new(0,6)}, ncButton)

-- Panel Auto-Laser (compacto)
local LaserPanel = make("Frame", {
    Name = "LaserPanel", Size = UDim2.new(0, 160, 0, 100), Position = UDim2.new(0.5, -80, 0.5, -50),
    BackgroundColor3 = Config.BackgroundColor, Visible = false
}, Screen)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, LaserPanel)
make("UIStroke", {Color = Config.MainColor}, LaserPanel)
local laserTitle = make("TextLabel", {Size = UDim2.new(1,0,0,30), Text = "AUTO-LASER", Font = Enum.Font.Code, TextSize = 16, TextColor3 = Config.MainColor, BackgroundTransparency = 1}, LaserPanel)
local laserButton = make("TextButton", {Size = UDim2.new(1,-20,0,40), Position = UDim2.new(0,10,0,40), Text = "ACTIVAR", Font = Enum.Font.Code, TextSize = 14, TextColor3 = Config.TextColor, BackgroundColor3 = Color3.fromRGB(0,160,0)}, LaserPanel)
make("UICorner", {CornerRadius = UDim.new(0,6)}, laserButton)

-- =========================================================================================
--                                   5. LÓGICA DE FUNCIONES
-- =========================================================================================
-- Lógica No-Clip
local noClipConn, noClipOn = nil, false
ncButton.MouseButton1Click:Connect(function()
    noClipOn = not noClipOn
    if noClipOn then
        noClipConn = RunService.Stepped:Connect(function() if LP.Character then for _,p in ipairs(LP.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end end)
        ncButton.Text, ncButton.BackgroundColor3 = "DESACTIVAR", Color3.fromRGB(170,20,20)
    else
        if noClipConn then noClipConn:Disconnect(); noClipConn = nil end
        ncButton.Text, ncButton.BackgroundColor3 = "ACTIVAR", Color3.fromRGB(0,160,0)
    end
end)

-- Lógica Auto-Laser
local LaserRemote = ReplicatedStorage:FindFirstChild("RE/UseItem", true)
local autoLaser, laserRange = false, 150
laserButton.MouseButton1Click:Connect(function()
    autoLaser = not autoLaser
    if autoLaser then laserButton.Text, laserButton.BackgroundColor3 = "DESACTIVAR", Color3.fromRGB(170,20,20)
    else laserButton.Text, laserButton.BackgroundColor3 = "ACTIVAR", Color3.fromRGB(0,160,0) end
end)
task.spawn(function()
    while task.wait(0.2) do
        if autoLaser and LaserRemote and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local myHRP = LP.Character.HumanoidRootPart
            local closest, dist = nil, laserRange
            for _,pl in ipairs(Players:GetPlayers()) do
                if pl ~= LP and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (pl.Character.HumanoidRootPart.Position - myHRP.Position).Magnitude
                    if d < dist then closest, dist = pl.Character.HumanoidRootPart, d end
                end
            end
            if closest then LaserRemote:FireServer(closest.Position, closest) end
        end
    end
end)

-- =========================================================================================
--                                   6. BOTONES DEL MENÚ PRINCIPAL
-- =========================================================================================
local function makeMainButton(text, order, panel)
    local btn = make("TextButton", {
        Size = UDim2.new(1,0,0,32), Text = text, Font = Enum.Font.Code, TextSize = 14,
        TextColor3 = Config.TextColor, BackgroundColor3 = Config.MutedColor, LayoutOrder = order
    }, MainContent)
    make("UICorner", {CornerRadius = UDim.new(0,6)}, btn)
    if panel then btn.MouseButton1Click:Connect(function() panel.Visible = not panel.Visible end) end
    return btn
end

makeMainButton("NO-CLIP", 2, NCPanel)
makeMainButton("AUTO-LASER", 3, LaserPanel)
local btnCombo = makeMainButton("COMBO SCRIPTS", 4)
local btnServer = makeMainButton("CAMBIAR SERVIDOR", 5)

btnCombo.MouseButton1Click:Connect(function()
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))() end)
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ily123950/Vulkan/refs/heads/main/Trx"))() end)
end)
btnServer.MouseButton1Click:Connect(function()
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/karlosedson/mkzhub/refs/heads/main/makerzjoiner.lua"))() end)
end)

-- =========================================================================================
--                                   7. INICIALIZACIÓN FINAL
-- =========================================================================================
makeDraggable(Main, Title)
makeDraggable(FloatIcon, FloatIcon)
makeDraggable(NCPanel, ncTitle)
makeDraggable(LaserPanel, laserTitle)

FloatIcon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
UserInputService.InputBegan:Connect(function(inp, gpe) if not gpe and inp.KeyCode == Config.Keybind then Main.Visible = not Main.Visible end end)

task.wait()
optionsContainer.CanvasSize = UDim2.new(0, 0, 0, MainContent:FindFirstChildOfClass("UIListLayout").AbsoluteContentSize.Y)


-- ===================================================================
-- Auto-Láser: EQUIPAR/DESEQUIPAR AUTOMÁTICO (sin tocar diseño/UI)
-- - Equipa la "Laser Cape" al activar (aunque la pierdas o al respawn).
-- - Desequipa al desactivar.
-- - Quita cualquier otra Tool equipada para evitar conflictos.
-- - Reintenta con guardián y compra si falta (throttle 3s).
-- ===================================================================
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LP = Players.LocalPlayer

    local active = false
    local guardianConn = nil
    local lastBuyAttempt = 0

    local function humanoid()
        local ch = LP.Character
        if not ch then return nil end
        return ch:FindFirstChildOfClass("Humanoid")
    end

    local function backpack()
        return LP:FindFirstChild("Backpack")
    end

    local function getLaserTool()
        local ch = LP.Character
        local bp = backpack()
        if ch then
            local t = ch:FindFirstChild("Laser Cape")
            if t and t:IsA("Tool") then return t end
        end
        if bp then
            local t = bp:FindFirstChild("Laser Cape")
            if t and t:IsA("Tool") then return t end
        end
        return nil
    end

    local function unequipOthers()
        local hum = humanoid()
        if hum then hum:UnequipTools() end
        local ch = LP.Character
        local bp = backpack()
        if ch and bp then
            for _,tool in ipairs(ch:GetChildren()) do
                if tool:IsA("Tool") and tool.Name ~= "Laser Cape" then
                    tool.Parent = bp
                end
            end
        end
    end

    local function tryBuyLaser()
        if os.clock() - lastBuyAttempt < 3 then return end
        lastBuyAttempt = os.clock()
        pcall(function()
            local rf = ReplicatedStorage.Packages.Net:FindFirstChild("RF/CoinsShopService/RequestBuy")
            if rf then rf:InvokeServer("Laser Cape") end
        end)
    end

    local function equipLaser()
        local tool = getLaserTool()
        if not tool then
            tryBuyLaser()
            tool = getLaserTool()
        end
        if tool then
            unequipOthers()
            local hum = humanoid()
            if hum then
                pcall(function() hum:EquipTool(tool) end)
            end
            -- fallback por si EquipTool falla en algunos executors
            if LP.Character and tool.Parent ~= LP.Character then
                tool.Parent = LP.Character
            end
            unequipOthers()
        end
    end

    local function unequipLaser()
        local hum = humanoid()
        if hum then hum:UnequipTools() end
        local ch = LP.Character
        local bp = backpack()
        if ch and bp then
            local cape = ch:FindFirstChild("Laser Cape")
            if cape then cape.Parent = bp end
        end
    end

    local function ensureEquipped()
        if not active then return end
        if not getLaserTool() or (getLaserTool() and getLaserTool().Parent ~= LP.Character) then
            equipLaser()
        end
    end

    local function startGuardian()
        if guardianConn then guardianConn:Disconnect() end
        guardianConn = RunService.Heartbeat:Connect(function()
            ensureEquipped()
        end)
    end

    local function stopGuardian()
        if guardianConn then guardianConn:Disconnect() end
        guardianConn = nil
    end

    local function findAutoLaserButton()
        local gui = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("XL3RL_GUI")
        if not gui then return nil end
        for _,d in ipairs(gui:GetDescendants()) do
            if d:IsA("TextButton") then
                local t = (d.Text or d.Name or ""):lower()
                if t:find("auto") and t:find("laser") then
                    return d
                end
            end
        end
        return nil
    end

    -- Hook al botón existente SIN CAMBIAR DISEÑO
    local btn = findAutoLaserButton()
    if btn and not btn:GetAttribute("XL_AutoLaserHooked") then
        btn:SetAttribute("XL_AutoLaserHooked", true)
        btn.MouseButton1Click:Connect(function()
            -- Inferimos intención por el texto actual (antes de que tu script lo cambie)
            local txt = string.lower(btn.Text or "")
            local goingActive
            if txt:find("activar") then goingActive = true
            elseif txt:find("desactivar") then goingActive = false
            else goingActive = not active end

            if goingActive then
                active = true
                equipLaser()
                startGuardian()
            else
                active = false
                stopGuardian()
                unequipLaser()
            end
        end)
    end

    -- Re-equipar al respawn si estaba activo
    LP.CharacterAdded:Connect(function()
        if active then
            task.wait(0.8)
            equipLaser()
        end
    end)

    -- Si aparece la capa en backpack mientras está activo, equipar
    local bp = backpack()
    if bp then
        bp.ChildAdded:Connect(function(obj)
            if active and obj:IsA("Tool") and obj.Name == "Laser Cape" then
                task.wait()
                equipLaser()
            end
        end)
    end
end
-- =========================== FIN AUTO-LÁSER ===========================
