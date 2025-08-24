--[[
    SCRIPT: XL3RL HUB - AUTO-LASER + ANTI-BRAINROOT (Namecall Hook)
    - Mantiene UI/diseño y lógica tal cual tu versión estable.
    - Auto-Laser equipa/desequipa automáticamente "Laser Cape" como antes.
    - Se apaga automáticamente al hacer Grab (RE/StealService/Grab:FireServer(...))
      usando hook de __namecall / hookmetamethod, SIN interrumpir el grab.
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
--                                   2. CONFIGURACIÓN
-- =========================================================================================
local Config = {
    MainColor = Color3.fromRGB(0, 255, 150),
    BackgroundColor = Color3.fromRGB(25, 27, 35),
    MutedColor = Color3.fromRGB(40, 42, 50),
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
--                                   FUNCIÓN DE ARRASTRE
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

-- Menú principal
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
--                                   4. PANELES
-- =========================================================================================
-- No-Clip
local NCPanel = make("Frame", {Name = "NCPanel", Size = UDim2.new(0, 160, 0, 100), Position = UDim2.new(0.5, -80, 0.5, -50),
    BackgroundColor3 = Config.BackgroundColor, Visible = false}, Screen)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, NCPanel)
make("UIStroke", {Color = Config.MainColor}, NCPanel)
local ncTitle = make("TextLabel", {Size = UDim2.new(1,0,0,30), Text = "NO-CLIP", Font = Enum.Font.Code, TextSize = 16, TextColor3 = Config.MainColor, BackgroundTransparency = 1}, NCPanel)
local ncButton = make("TextButton", {Size = UDim2.new(1,-20,0,40), Position = UDim2.new(0,10,0,40), Text = "ACTIVAR", Font = Enum.Font.Code, TextSize = 14, TextColor3 = Config.TextColor, BackgroundColor3 = Color3.fromRGB(0,160,0)}, NCPanel)
make("UICorner", {CornerRadius = UDim.new(0,6)}, ncButton)

-- Auto-Laser
local LaserPanel = make("Frame", {Name = "LaserPanel", Size = UDim2.new(0, 160, 0, 100), Position = UDim2.new(0.5, -80, 0.5, -50),
    BackgroundColor3 = Config.BackgroundColor, Visible = false}, Screen)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, LaserPanel)
make("UIStroke", {Color = Config.MainColor}, LaserPanel)
local laserTitle = make("TextLabel", {Size = UDim2.new(1,0,0,30), Text = "AUTO-LASER", Font = Enum.Font.Code, TextSize = 16, TextColor3 = Config.MainColor, BackgroundTransparency = 1}, LaserPanel)
local laserButton = make("TextButton", {Size = UDim2.new(1,-20,0,40), Position = UDim2.new(0,10,0,40), Text = "ACTIVAR", Font = Enum.Font.Code, TextSize = 14, TextColor3 = Config.TextColor, BackgroundColor3 = Color3.fromRGB(0,160,0)}, LaserPanel)
make("UICorner", {CornerRadius = UDim.new(0,6)}, laserButton)

-- =========================================================================================
--                                   5. LÓGICA NO-CLIP
-- =========================================================================================
local noClipConn, noClipOn = nil, false
ncButton.MouseButton1Click:Connect(function()
    noClipOn = not noClipOn
    if noClipOn then
        noClipConn = RunService.Stepped:Connect(function()
            if LP.Character then
                for _,p in ipairs(LP.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
        ncButton.Text, ncButton.BackgroundColor3 = "DESACTIVAR", Color3.fromRGB(170,20,20)
    else
        if noClipConn then noClipConn:Disconnect(); noClipConn = nil end
        ncButton.Text, ncButton.BackgroundColor3 = "ACTIVAR", Color3.fromRGB(0,160,0)
    end
end)

-- =========================================================================================
--                        6. LÓGICA AUTO-LASER + EQUIP / DESEQUIP
-- =========================================================================================
local LaserRemote = ReplicatedStorage:FindFirstChild("RE/UseItem", true)
local BuyRF = ReplicatedStorage:FindFirstChild("RF/CoinsShopService/RequestBuy", true)

local function getLaserTool()
    if LP.Backpack then
        for _, t in ipairs(LP.Backpack:GetChildren()) do
            if t:IsA("Tool") and (t.Name == "Laser Cape" or string.find(t.Name:lower(), "laser")) then
                return t
            end
        end
    end
    if LP.Character then
        for _, t in ipairs(LP.Character:GetChildren()) do
            if t:IsA("Tool") and (t.Name == "Laser Cape" or string.find(t.Name:lower(), "laser")) then
                return t
            end
        end
    end
    return nil
end

local function equipLaserCape()
    local tool = getLaserTool()
    if tool and LP.Character and tool.Parent ~= LP.Character then
        tool.Parent = LP.Character
        return true
    elseif not tool and BuyRF then
        pcall(function() BuyRF:InvokeServer("Laser Cape") end)
        task.wait(0.5)
        tool = getLaserTool()
        if tool and LP.Character then tool.Parent = LP.Character return true end
    end
    return false
end

local function unequipLaserCape()
    local tool = getLaserTool()
    if tool then tool.Parent = LP.Backpack end
end

local autoLaser, laserRange = false, 150
laserButton.MouseButton1Click:Connect(function()
    autoLaser = not autoLaser
    if autoLaser then
        laserButton.Text, laserButton.BackgroundColor3 = "DESACTIVAR", Color3.fromRGB(170,20,20)
        task.spawn(function()
            while autoLaser do
                equipLaserCape()
                task.wait(1)
            end
        end)
    else
        laserButton.Text, laserButton.BackgroundColor3 = "ACTIVAR", Color3.fromRGB(0,160,0)
        unequipLaserCape()
    end
end)

LP.CharacterAdded:Connect(function()
    if autoLaser then
        task.wait(0.5)
        equipLaserCape()
    end
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
            if closest then
                pcall(function() LaserRemote:FireServer(closest.Position, closest) end)
            end
        end
    end
end)

-- =========================================================================================
--                7. APAGADO AUTOMÁTICO EN GRAB (Hook __namecall / hookmetamethod)
-- =========================================================================================
local function turnOffAutoLaserFromGrab()
    if autoLaser then
        autoLaser = false
        -- NO hacemos unequip aquí para no interferir con el grab.
        -- Solo actualizamos botón a estado "ACTIVAR" (verde)
        if laserButton then
            laserButton.Text = "ACTIVAR"
            laserButton.BackgroundColor3 = Color3.fromRGB(0,160,0)
        end
    end
end

do
    local success = false

    -- Preferente: hookmetamethod (si el ejecutor lo soporta)
    if hookmetamethod then
        local old; old = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod and getnamecallmethod() or ""
            if method == "FireServer" then
                local path = tostring(self)
                -- Detecta: ReplicatedStorage.Packages.Net.RE/StealService/Grab
                if path:find("RE/StealService/Grab") then
                    turnOffAutoLaserFromGrab()
                end
            end
            return old(self, ...)
        end)
        success = true
    end

    if not success then
        -- Fallback: getrawmetatable
        local mt = getrawmetatable and getrawmetatable(game)
        if mt and setreadonly and getnamecallmethod then
            local old = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method == "FireServer" then
                    local path = tostring(self)
                    if path:find("RE/StealService/Grab") then
                        turnOffAutoLaserFromGrab()
                    end
                end
                return old(self, ...)
            end)
            setreadonly(mt, true)
        end
    end
end

-- =========================================================================================
--                                   8. BOTONES DEL MENÚ PRINCIPAL
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
--                                   9. INICIALIZACIÓN FINAL
-- =========================================================================================
makeDraggable(Main, Title)
makeDraggable(FloatIcon, FloatIcon)
makeDraggable(NCPanel, ncTitle)
makeDraggable(LaserPanel, laserTitle)

FloatIcon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
UserInputService.InputBegan:Connect(function(inp, gpe) if not gpe and inp.KeyCode == Config.Keybind then Main.Visible = not Main.Visible end end)
