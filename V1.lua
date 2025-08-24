--[[
    SCRIPT: XL3RL HUB - FUSIÓN FINAL (Bloqueo Fuerte de Tools + Auto-Laser Mejorado)
    AUTOR: Gemini
    DESCRIPCIÓN:
        - Auto-Laser equipa automáticamente la capa "Laser Cape".
        - Al desactivar Auto-Laser, desequipa y vuelve a Backpack.
        - Re-equipamiento tras respawn si Auto-Laser sigue activo.
        - 🚫 Bloqueo FUERTE: mientras Auto-Laser esté activo, cualquier Tool que no sea "Laser Cape"
          se devuelve automáticamente al Backpack.
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
    local isDragging, dragStart, startPos
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart, startPos = input.Position, frame.Position
            local conn; conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                    conn:Disconnect()
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
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
    Image = "rbxassetid://6034849723", ImageColor3 = Config.MainColor
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
    TextSize = 16, TextColor3 = Config.MainColor, BackgroundTransparency = 1
}, MainContent)

-- =========================================================================================
--                                   4. PANELES
-- =========================================================================================
-- Auto-Laser
local LaserPanel = make("Frame", {Size = UDim2.new(0, 160, 0, 100), BackgroundColor3 = Config.BackgroundColor, Visible = false}, Screen)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, LaserPanel)
make("UIStroke", {Color = Config.MainColor}, LaserPanel)
local laserTitle = make("TextLabel", {Size = UDim2.new(1,0,0,30), Text = "AUTO-LASER", Font = Enum.Font.Code, TextSize = 16, TextColor3 = Config.MainColor, BackgroundTransparency = 1}, LaserPanel)
local laserButton = make("TextButton", {Size = UDim2.new(1,-20,0,40), Position = UDim2.new(0,10,0,40), Text = "ACTIVAR", Font = Enum.Font.Code, TextSize = 14, TextColor3 = Config.TextColor, BackgroundColor3 = Color3.fromRGB(0,160,0)}, LaserPanel)
make("UICorner", {CornerRadius = UDim.new(0,6)}, laserButton)

-- =========================================================================================
--                                   5. LÓGICA AUTO-LASER
-- =========================================================================================
local LaserRemote = ReplicatedStorage:FindFirstChild("RE/UseItem", true)
local BuyRF = ReplicatedStorage:FindFirstChild("RF/CoinsShopService/RequestBuy", true)

local function getLaserTool()
    for _,t in ipairs(LP.Backpack:GetChildren()) do if t:IsA("Tool") and t.Name=="Laser Cape" then return t end end
    for _,t in ipairs(LP.Character:GetChildren()) do if t:IsA("Tool") and t.Name=="Laser Cape" then return t end end
    return nil
end

local function equipLaserCape()
    local t = getLaserTool()
    if t and LP.Character then t.Parent = LP.Character return true end
    if BuyRF then pcall(function() BuyRF:InvokeServer("Laser Cape") end) end
    return false
end

local function unequipLaserCape()
    local t = getLaserTool()
    if t and LP.Backpack then t.Parent = LP.Backpack end
end

local autoLaser = false

-- 🔒 Nuevo: Bloqueo FUERTE de Tools
RunService.Heartbeat:Connect(function()
    if autoLaser and LP.Character then
        for _, tool in ipairs(LP.Character:GetChildren()) do
            if tool:IsA("Tool") and tool.Name ~= "Laser Cape" then
                tool.Parent = LP.Backpack
            end
        end
    end
end)

laserButton.MouseButton1Click:Connect(function()
    autoLaser = not autoLaser
    if autoLaser then
        laserButton.Text, laserButton.BackgroundColor3 = "DESACTIVAR", Color3.fromRGB(170,20,20)
        equipLaserCape()
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

-- Loop de disparo Auto-Laser
task.spawn(function()
    while task.wait(0.2) do
        if autoLaser and LaserRemote and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local myHRP = LP.Character.HumanoidRootPart
            local closest, dist = nil, 150
            for _,pl in ipairs(Players:GetPlayers()) do
                if pl~=LP and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                    local d=(pl.Character.HumanoidRootPart.Position-myHRP.Position).Magnitude
                    if d<dist then closest,dist=pl.Character.HumanoidRootPart,d end
                end
            end
            if closest then pcall(function() LaserRemote:FireServer(closest.Position, closest) end) end
        end
    end
end)

-- =========================================================================================
--                                   6. BOTONES PRINCIPALES
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

makeMainButton("AUTO-LASER", 1, LaserPanel)

-- =========================================================================================
--                                   7. INICIALIZACIÓN
-- =========================================================================================
makeDraggable(Main, Title)
makeDraggable(FloatIcon, FloatIcon)
makeDraggable(LaserPanel, laserTitle)

FloatIcon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
UserInputService.InputBegan:Connect(function(inp,gpe) if not gpe and inp.KeyCode==Config.Keybind then Main.Visible=not Main.Visible end end)
