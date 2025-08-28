-- =========================================================================================
--        SCRIPT: XL3RL HUB - AUTO-LASER (con delay para Brainroot)
-- =========================================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- Config
local Config = {
    Keybind = Enum.KeyCode.RightShift
}

-- Función rápida para instanciar
local function make(className, props, parent)
    local i = Instance.new(className)
    for k,v in pairs(props or {}) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end

-- GUI
pcall(function() if LP.PlayerGui:FindFirstChild("XL3RL_GUI") then LP.PlayerGui.XL3RL_GUI:Destroy() end end)
local Screen = make("ScreenGui", {Name="XL3RL_GUI", ResetOnSpawn=false}, LP:WaitForChild("PlayerGui"))

local FloatIcon = make("TextButton", {
    Size=UDim2.new(0,50,0,50), Position=UDim2.new(0,20,0.5,-25),
    Text="☢", TextSize=22, BackgroundColor3=Color3.fromRGB(30,30,30)
}, Screen)
make("UICorner",{CornerRadius=UDim.new(1,0)},FloatIcon)

local Main = make("Frame", {
    Size=UDim2.new(0,160,0,200), Position=UDim2.new(0.5,-80,0.5,-100),
    BackgroundColor3=Color3.fromRGB(20,20,20), Visible=false
}, Screen)
make("UICorner",{CornerRadius=UDim.new(0,8)},Main)

local Title = make("TextLabel", {
    Size=UDim2.new(1,0,0,24), Text="XL3RL HUB", Font=Enum.Font.Code,
    TextSize=16, TextColor3=Color3.fromRGB(0,255,150), BackgroundTransparency=1
}, Main)

-- Panel Auto-Laser
local LaserPanel = make("Frame", {
    Name="LaserPanel", Size=UDim2.new(0,160,0,100), Position=UDim2.new(1,-180,0,20),
    BackgroundColor3=Color3.fromRGB(25,25,25), Visible=false
}, Screen)
make("UICorner",{CornerRadius=UDim.new(0,8)},LaserPanel)
local laserTitle = make("TextLabel", {
    Size=UDim2.new(1,0,0,30), Text="AUTO-LASER", Font=Enum.Font.Code,
    TextSize=16, TextColor3=Color3.fromRGB(0,255,150), BackgroundTransparency=1
}, LaserPanel)
local laserButton = make("TextButton", {
    Size=UDim2.new(1,-20,0,40), Position=UDim2.new(0,10,0,40),
    Text="ACTIVAR", Font=Enum.Font.Code, TextSize=14, TextColor3=Color3.fromRGB(255,255,255),
    BackgroundColor3=Color3.fromRGB(0,160,0)
}, LaserPanel)
make("UICorner",{CornerRadius=UDim.new(0,6)},laserButton)

-- Servicios Remotos
local LaserRemote = ReplicatedStorage:FindFirstChild("RE/UseItem", true)
local BuyRF = ReplicatedStorage:FindFirstChild("RF/CoinsShopService/RequestBuy", true)

-- Helpers Laser Cape
local function getLaserTool()
    for _,t in ipairs(LP.Backpack:GetChildren()) do
        if t:IsA("Tool") and string.find(t.Name:lower(),"laser") then return t end
    end
    for _,t in ipairs(LP.Character:GetChildren()) do
        if t:IsA("Tool") and string.find(t.Name:lower(),"laser") then return t end
    end
end

local function equipLaserCape()
    local tool = getLaserTool()
    if not tool and BuyRF then
        pcall(function() BuyRF:InvokeServer("Laser Cape") end)
        task.wait(0.5)
        tool = getLaserTool()
    end
    if tool and LP.Character then
        tool.Parent = LP.Character
    end
end

local function unequipLaserCape()
    local tool = getLaserTool()
    if tool and LP.Backpack then
        tool.Parent = LP.Backpack
    end
end

-- Auto-Laser Logic
local autoLaser, laserRange = false, 150
laserButton.MouseButton1Click:Connect(function()
    autoLaser = not autoLaser
    if autoLaser then
        laserButton.Text, laserButton.BackgroundColor3 = "DESACTIVAR", Color3.fromRGB(170,20,20)
        task.spawn(function()
            equipLaserCape()
        end)
    else
        laserButton.Text, laserButton.BackgroundColor3 = "ACTIVAR", Color3.fromRGB(0,160,0)
        unequipLaserCape()
    end
end)

-- Re-equip tras respawn
LP.CharacterAdded:Connect(function()
    if autoLaser then
        task.wait(0.5)
        equipLaserCape()
    end
end)

-- Loop Auto Laser
task.spawn(function()
    while task.wait(0.2) do
        if autoLaser and LaserRemote and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local myHRP = LP.Character.HumanoidRootPart
            local closest, dist = nil, laserRange
            for _,pl in ipairs(Players:GetPlayers()) do
                if pl~=LP and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
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

-- Detectar Brainroot (por Remote)
local function isBrainrootRemote(remoteName)
    return string.match(remoteName:lower(), "stealservice") or string.match(remoteName, "280b459b")
end

for _,obj in ipairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("RemoteEvent") and isBrainrootRemote(obj.Name) then
        obj.OnClientEvent:Connect(function(...)
            if autoLaser then
                -- 🔹 Delay para no interferir con tu otro script
                task.delay(0.5,function()
                    autoLaser = false
                    laserButton.Text, laserButton.BackgroundColor3 = "ACTIVAR", Color3.fromRGB(0,160,0)
                    unequipLaserCape()
                end)
            end
        end)
    end
end

-- Toggle GUI
FloatIcon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
UserInputService.InputBegan:Connect(function(inp,gpe) if not gpe and inp.KeyCode==Config.Keybind then Main.Visible=not Main.Visible end end)
