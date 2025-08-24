--[[
    SCRIPT: XL3RL HUB - FUSIÓN FINAL (Auto-Laser repetición constante)
    AUTOR: Gemini
    DESCRIPCIÓN: Versión final con:
                 - Arrastre corregido (no salta a la esquina).
                 - Auto-Laser:
                     * Repite constantemente EQUIPAR capa y ELIMINAR otros ítems.
                     * Dispara automáticamente al jugador más cercano.
                     * Desequipa al desactivar.
                     * Re-equipar tras respawn si sigue activo.
]]

-- =========================================================================================
--                                   1. SERVICIOS Y JUGADOR
-- =========================================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

-- =========================================================================================
--                                   2. CONFIGURACIÓN Y FUNCIONES
-- =========================================================================================
local Config = {
    MainColor = Color3.fromRGB(0, 255, 150),      -- Verde Neón
    BackgroundColor = Color3.fromRGB(25, 27, 35), -- Fondo Oscuro
    MutedColor = Color3.fromRGB(40, 42, 50),      -- Color inactivo
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
--                                   3. DRAGGABLE FIX
-- =========================================================================================
local function makeDraggable(frame, trigger)
    local dragToggle, dragStart, startPos
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- =========================================================================================
--                                   4. GUI BASE
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
--                                   5. PANELES
-- =========================================================================================
-- NO-CLIP
local NCPanel = make("Frame", { Name = "NCPanel", Size = UDim2.new(0, 160, 0, 100), BackgroundColor3 = Config.BackgroundColor, Visible = false }, Screen)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, NCPanel)
make("UIStroke", {Color = Config.MainColor}, NCPanel)
local ncTitle = make("TextLabel", {Size = UDim2.new(1,0,0,30), Text = "NO-CLIP", Font = Enum.Font.Code, TextSize = 16, TextColor3 = Config.MainColor, BackgroundTransparency = 1}, NCPanel)
local ncButton = make("TextButton", {Size = UDim2.new(1,-20,0,40), Position = UDim2.new(0,10,0,40), Text = "ACTIVAR", Font = Enum.Font.Code, TextSize = 14, TextColor3 = Config.TextColor, BackgroundColor3 = Color3.fromRGB(0,160,0)}, NCPanel)
make("UICorner", {CornerRadius = UDim.new(0,6)}, ncButton)

-- AUTO-LASER
local LaserPanel = make("Frame", { Name = "LaserPanel", Size = UDim2.new(0, 160, 0, 100), BackgroundColor3 = Config.BackgroundColor, Visible = false }, Screen)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, LaserPanel)
make("UIStroke", {Color = Config.MainColor}, LaserPanel)
local laserTitle = make("TextLabel", {Size = UDim2.new(1,0,0,30), Text = "AUTO-LASER", Font = Enum.Font.Code, TextSize = 16, TextColor3 = Config.MainColor, BackgroundTransparency = 1}, LaserPanel)
local laserButton = make("TextButton", {Size = UDim2.new(1,-20,0,40), Position = UDim2.new(0,10,0,40), Text = "ACTIVAR", Font = Enum.Font.Code, TextSize = 14, TextColor3 = Config.TextColor, BackgroundColor3 = Color3.fromRGB(0,160,0)}, LaserPanel)
make("UICorner", {CornerRadius = UDim.new(0,6)}, laserButton)

-- =========================================================================================
--                                   6. LÓGICA NO-CLIP
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
--                                   7. AUTO-LASER
-- =========================================================================================
local LaserRemote = ReplicatedStorage:FindFirstChild("RE/UseItem", true)
local BuyRF = ReplicatedStorage:FindFirstChild("RF/CoinsShopService/RequestBuy", true)
local autoLaser = false

local function getLaserTool()
    for _,loc in ipairs({LP.Backpack, LP.Character}) do
        if loc then
            for _,t in ipairs(loc:GetChildren()) do
                if t:IsA("Tool") and (t.Name=="Laser Cape" or string.find(t.Name:lower(),"laser")) then return t end
            end
        end
    end
    return nil
end

local function equipLaserCape()
    local tool = getLaserTool()
    if tool and LP.Character and tool.Parent~=LP.Character then tool.Parent = LP.Character end
    if not tool and BuyRF then pcall(function() BuyRF:InvokeServer("Laser Cape") end) end
end

local function unequipLaserCape()
    local tool = getLaserTool()
    if tool and LP.Backpack then tool.Parent = LP.Backpack end
end

local function removeOtherTools()
    if LP.Character then
        for _,t in ipairs(LP.Character:GetChildren()) do
            if t:IsA("Tool") and not string.find(t.Name:lower(),"laser") then
                t.Parent = LP.Backpack
            end
        end
    end
end

-- Loop
task.spawn(function()
    while task.wait(0.05) do
        if autoLaser then
            equipLaserCape()
            removeOtherTools()
            if LaserRemote and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                local myHRP = LP.Character.HumanoidRootPart
                local closest,dist=nil,150
                for _,pl in ipairs(Players:GetPlayers()) do
                    if pl~=LP and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                        local d=(pl.Character.HumanoidRootPart.Position-myHRP.Position).Magnitude
                        if d<dist then closest,dist=pl.Character.HumanoidRootPart,d end
                    end
                end
                if closest then pcall(function() LaserRemote:FireServer(closest.Position, closest) end) end
            end
        end
    end
end)

laserButton.MouseButton1Click:Connect(function()
    autoLaser = not autoLaser
    if autoLaser then
        laserButton.Text, laserButton.BackgroundColor3 = "DESACTIVAR", Color3.fromRGB(170,20,20)
    else
        laserButton.Text, laserButton.BackgroundColor3 = "ACTIVAR", Color3.fromRGB(0,160,0)
        unequipLaserCape()
    end
end)

LP.CharacterAdded:Connect(function() if autoLaser then task.wait(0.5) equipLaserCape() end end)

-- =========================================================================================
--                                   8. MENÚ PRINCIPAL
-- =========================================================================================
local function makeMainButton(text, order, panel)
    local btn = make("TextButton", {
        Size=UDim2.new(1,0,0,32), Text=text, Font=Enum.Font.Code, TextSize=14,
        TextColor3=Config.TextColor, BackgroundColor3=Config.MutedColor, LayoutOrder=order
    }, MainContent)
    make("UICorner",{CornerRadius=UDim.new(0,6)},btn)
    if panel then btn.MouseButton1Click:Connect(function() panel.Visible = not panel.Visible end) end
    return btn
end

makeMainButton("NO-CLIP", 2, NCPanel)
makeMainButton("AUTO-LASER", 3, LaserPanel)

makeDraggable(Main, Title)
makeDraggable(FloatIcon, FloatIcon)
makeDraggable(NCPanel, ncTitle)
makeDraggable(LaserPanel, laserTitle)

FloatIcon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
UserInputService.InputBegan:Connect(function(inp, gpe) if not gpe and inp.KeyCode == Config.Keybind then Main.Visible = not Main.Visible end end)
