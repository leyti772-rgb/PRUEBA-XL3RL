--[[
    SCRIPT: XL3RL HUB - FUSIÓN FINAL
    AUTOR: Gemini + Leyto
    FUNCIONES:
      * No-Clip
      * Auto-Laser con equip/desequip automático
      * Prevención de mezcla de ítems
      * Auto-off al agarrar Brainroot
      * Combo Scripts
      * Cambiar Servidor
      * Arrastre corregido
]]

-- =========================================================================================
-- SERVICIOS
-- =========================================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

-- =========================================================================================
-- CONFIG VISUAL
-- =========================================================================================
local Config = {
    MainColor = Color3.fromRGB(0, 255, 150),
    BackgroundColor = Color3.fromRGB(25, 27, 35),
    MutedColor = Color3.fromRGB(40, 42, 50),
    TextColor = Color3.fromRGB(255, 255, 255),
    Keybind = Enum.KeyCode.RightShift
}

local function make(class, props, parent)
    local inst = Instance.new(class)
    for k,v in pairs(props) do inst[k] = v end
    if parent then inst.Parent = parent end
    return inst
end

-- =========================================================================================
-- FUNCIÓN ARRASTRE
-- =========================================================================================
local function makeDraggable(frame, trigger)
    local isDragging = false
    local dragStart, startPos
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart, startPos = input.Position, frame.Position
            local conn
            conn = input.Changed:Connect(function()
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
-- GUI BASE
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
-- PANELES
-- =========================================================================================

-- No-Clip
local NCPanel = make("Frame", { Size = UDim2.new(0, 160, 0, 100), BackgroundColor3 = Config.BackgroundColor, Visible = false }, Screen)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, NCPanel)
make("UIStroke", {Color = Config.MainColor}, NCPanel)
local ncTitle = make("TextLabel", {Size = UDim2.new(1,0,0,30), Text = "NO-CLIP", Font = Enum.Font.Code, TextSize = 16, TextColor3 = Config.MainColor, BackgroundTransparency = 1}, NCPanel)
local ncButton = make("TextButton", {Size = UDim2.new(1,-20,0,40), Position = UDim2.new(0,10,0,40), Text = "ACTIVAR", Font = Enum.Font.Code, TextSize = 14, TextColor3 = Config.TextColor, BackgroundColor3 = Color3.fromRGB(0,160,0)}, NCPanel)
make("UICorner", {CornerRadius = UDim.new(0,6)}, ncButton)

-- Auto-Laser
local LaserPanel = make("Frame", { Size = UDim2.new(0, 160, 0, 100), BackgroundColor3 = Config.BackgroundColor, Visible = false }, Screen)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, LaserPanel)
make("UIStroke", {Color = Config.MainColor}, LaserPanel)
local laserTitle = make("TextLabel", {Size = UDim2.new(1,0,0,30), Text = "AUTO-LASER", Font = Enum.Font.Code, TextSize = 16, TextColor3 = Config.MainColor, BackgroundTransparency = 1}, LaserPanel)
local laserButton = make("TextButton", {Size = UDim2.new(1,-20,0,40), Position = UDim2.new(0,10,0,40), Text = "ACTIVAR", Font = Enum.Font.Code, TextSize = 14, TextColor3 = Config.TextColor, BackgroundColor3 = Color3.fromRGB(0,160,0)}, LaserPanel)
make("UICorner", {CornerRadius = UDim.new(0,6)}, laserButton)

-- =========================================================================================
-- LÓGICA: NO-CLIP
-- =========================================================================================
local noClipOn, noClipConn = false, nil
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
        if noClipConn then noClipConn:Disconnect() end
        ncButton.Text, ncButton.BackgroundColor3 = "ACTIVAR", Color3.fromRGB(0,160,0)
    end
end)

-- =========================================================================================
-- LÓGICA: AUTO-LASER
-- =========================================================================================
local LaserRemote = ReplicatedStorage:FindFirstChild("RE/UseItem", true)
local BuyRF = ReplicatedStorage:FindFirstChild("RF/CoinsShopService/RequestBuy", true)
local autoLaser = false

local function getLaserTool()
    for _,container in ipairs({LP.Backpack, LP.Character}) do
        if container then
            for _,t in ipairs(container:GetChildren()) do
                if t:IsA("Tool") and t.Name:lower():find("laser") then return t end
            end
        end
    end
    return nil
end

local function equipLaserCape()
    local tool = getLaserTool()
    if tool and LP.Character and tool.Parent ~= LP.Character then
        tool.Parent = LP.Character
    elseif not tool and BuyRF then
        pcall(function() BuyRF:InvokeServer("Laser Cape") end)
    end
end

local function unequipLaserCape()
    local tool = getLaserTool()
    if tool and LP.Backpack then tool.Parent = LP.Backpack end
end

local function clearOtherTools()
    if LP.Character then
        for _,t in ipairs(LP.Character:GetChildren()) do
            if t:IsA("Tool") and not t.Name:lower():find("laser") then
                t.Parent = LP.Backpack
            end
        end
    end
end

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
    if autoLaser then task.wait(0.5) equipLaserCape() end
end)

task.spawn(function()
    while task.wait(0.2) do
        if autoLaser then
            equipLaserCape()
            clearOtherTools()
            if LaserRemote and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                local myHRP = LP.Character.HumanoidRootPart
                local closest, dist = nil, 150
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
    end
end)

-- AUTO-OFF al agarrar Brainroot
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" and typeof(self) == "Instance" then
        if self.Name == "RE/280b459b-b3c8-424e-9b0b-821d4a4dec11" then
            if autoLaser then
                autoLaser = false
                laserButton.Text, laserButton.BackgroundColor3 = "ACTIVAR", Color3.fromRGB(0,160,0)
                unequipLaserCape()
            end
        end
    end
    return oldNamecall(self, ...)
end)

-- =========================================================================================
-- BOTONES DEL MENÚ PRINCIPAL
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
-- INICIALIZACIÓN FINAL
-- =========================================================================================
makeDraggable(Main, Title)
makeDraggable(FloatIcon, FloatIcon)
makeDraggable(NCPanel, ncTitle)
makeDraggable(LaserPanel, laserTitle)

FloatIcon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
UserInputService.InputBegan:Connect(function(inp, gpe) if not gpe and inp.KeyCode == Config.Keybind then Main.Visible = not Main.Visible end end)
