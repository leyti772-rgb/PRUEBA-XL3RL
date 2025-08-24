-- =========================================================================================
--    SCRIPT: XL3RL HUB - AUTO-LASER + AUTO-OFF BRAINROOT
-- =========================================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

-- === Configuración ===
local Config = {
    MainColor = Color3.fromRGB(0, 255, 150),
    BackgroundColor = Color3.fromRGB(25, 27, 35),
    TextColor = Color3.fromRGB(255, 255, 255),
    Keybind = Enum.KeyCode.RightShift
}

-- === Helpers ===
local function make(class, props, parent)
    local inst = Instance.new(class)
    for k,v in pairs(props) do inst[k] = v end
    if parent then inst.Parent = parent end
    return inst
end

-- === GUI principal ===
pcall(function() if LP.PlayerGui:FindFirstChild("XL3RL_FUSION_GUI") then LP.PlayerGui.XL3RL_FUSION_GUI:Destroy() end end)
local Screen = make("ScreenGui", { Name = "XL3RL_FUSION_GUI", ResetOnSpawn = false }, LP:WaitForChild("PlayerGui"))

-- Icono flotante
local FloatIcon = make("ImageButton", {
    Name = "OpenIcon", Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 20, 0.5, -25),
    BackgroundColor3 = Config.BackgroundColor, Image = "rbxassetid://6034849723", ImageColor3 = Config.MainColor
}, Screen)
make("UICorner", {CornerRadius = UDim.new(1, 0)}, FloatIcon)

-- Menú principal
local Main = make("Frame", {
    Size = UDim2.new(0, 160, 0, 200), Position = UDim2.new(0.5, -80, 0.5, -100),
    BackgroundColor3 = Config.BackgroundColor, Visible = false
}, Screen)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, Main)
local MainContent = make("Frame", { Size = UDim2.fromScale(1,1), BackgroundTransparency = 1 }, Main)
make("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, MainContent)

local Title = make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 24), Text = "XL3RL HUB", Font = Enum.Font.Code,
    TextSize = 16, TextColor3 = Config.MainColor, BackgroundTransparency = 1
}, MainContent)

-- === Panel Auto-Laser ===
local LaserPanel = make("Frame", {
    Size = UDim2.new(0, 160, 0, 100), BackgroundColor3 = Config.BackgroundColor, Visible = false
}, Screen)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, LaserPanel)
local laserTitle = make("TextLabel", {
    Size = UDim2.new(1,0,0,30), Text = "AUTO-LASER", Font = Enum.Font.Code,
    TextSize = 16, TextColor3 = Config.MainColor, BackgroundTransparency = 1
}, LaserPanel)
local laserButton = make("TextButton", {
    Size = UDim2.new(1,-20,0,40), Position = UDim2.new(0,10,0,40), Text = "ACTIVAR",
    Font = Enum.Font.Code, TextSize = 14, TextColor3 = Config.TextColor,
    BackgroundColor3 = Color3.fromRGB(0,160,0)
}, LaserPanel)
make("UICorner", {CornerRadius = UDim.new(0,6)}, laserButton)

-- === Funciones Auto-Laser ===
local LaserRemote = ReplicatedStorage:FindFirstChild("RE/UseItem", true)
local BuyRF = ReplicatedStorage:FindFirstChild("RF/CoinsShopService/RequestBuy", true)
local autoLaser = false

local function getLaserTool()
    if LP.Backpack then
        for _,t in ipairs(LP.Backpack:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():find("laser") then return t end
        end
    end
    if LP.Character then
        for _,t in ipairs(LP.Character:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():find("laser") then return t end
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
    if tool and LP.Backpack then
        tool.Parent = LP.Backpack
    end
end

-- Toggle Auto-Laser
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

-- Auto equip tras respawn
LP.CharacterAdded:Connect(function()
    if autoLaser then
        task.wait(0.5)
        equipLaserCape()
    end
end)

-- Auto-Laser disparo loop
task.spawn(function()
    while task.wait(0.2) do
        if autoLaser and LaserRemote and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local myHRP = LP.Character.HumanoidRootPart
            local closest, dist = nil, 150
            for _,pl in ipairs(Players:GetPlayers()) do
                if pl ~= LP and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (pl.Character.HumanoidRootPart.Position - myHRP.Position).Magnitude
                    if d < dist then closest, dist = pl.Character.HumanoidRootPart, d end
                end
            end
            if closest then
                pcall(function()
                    LaserRemote:FireServer(closest.Position, closest)
                end)
            end
        end
    end
end)

-- === Hook para auto-apagar al agarrar BRAINROOT ===
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

-- === Botón principal ===
local function makeMainButton(text, panel)
    local btn = make("TextButton", {
        Size = UDim2.new(1,0,0,32), Text = text, Font = Enum.Font.Code,
        TextSize = 14, TextColor3 = Config.TextColor, BackgroundColor3 = Color3.fromRGB(40,40,40)
    }, MainContent)
    make("UICorner", {CornerRadius = UDim.new(0,6)}, btn)
    if panel then btn.MouseButton1Click:Connect(function() panel.Visible = not panel.Visible end) end
    return btn
end

makeMainButton("AUTO-LASER", LaserPanel)

-- === Control menú ===
FloatIcon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
UserInputService.InputBegan:Connect(function(inp, gpe) if not gpe and inp.KeyCode == Config.Keybind then Main.Visible = not Main.Visible end end)
