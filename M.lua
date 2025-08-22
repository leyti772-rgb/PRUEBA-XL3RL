-- ⚡ AutoLaser Optimizado (dispara siempre al jugador más cercano dentro de rango)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LaserRemote = ReplicatedStorage.Packages.Net:FindFirstChild("RE/UseItem")
local autoLaser = false
local range = 150 -- rango máximo en studs

-- GUI (igual que antes)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoLaserGUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 50, 0, 50)
icon.Position = UDim2.new(0, 20, 0.5, -25)
icon.Text = "🔫"
icon.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
icon.TextColor3 = Color3.new(1,1,1)
icon.Font = Enum.Font.SourceSansBold
icon.TextSize = 24
icon.Parent = screenGui
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)

local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 180, 0, 80)
panel.Position = UDim2.new(0, 80, 0.5, -40)
panel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
panel.Visible = false
panel.Parent = screenGui
Instance.new("UICorner", panel)

local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🔴 Auto-Laser"
title.TextColor3 = Color3.new(1,0,0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16

local toggle = Instance.new("TextButton", panel)
toggle.Size = UDim2.new(0, 120, 0, 30)
toggle.Position = UDim2.new(0.5, -60, 0.5, -15)
toggle.Text = "Activar AutoLaser"
toggle.TextColor3 = Color3.new(1,1,1)
toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
toggle.Font = Enum.Font.SourceSansBold
toggle.TextSize = 14
Instance.new("UICorner", toggle)

-- Toggle
toggle.MouseButton1Click:Connect(function()
    autoLaser = not autoLaser
    toggle.Text = autoLaser and "✅ AutoLaser ON" or "Activar AutoLaser"
end)

-- Abrir panel
icon.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)

-- Función: encontrar enemigo más cercano
local function getClosestEnemy()
    local closest, distance = nil, range
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end

    for _, enemy in ipairs(Players:GetPlayers()) do
        if enemy ~= LocalPlayer and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = enemy.Character.HumanoidRootPart
            local mag = (hrp.Position - myHRP.Position).Magnitude
            if mag < distance then
                closest = hrp
                distance = mag
            end
        end
    end
    return closest
end

-- Loop
task.spawn(function()
    while task.wait(0.2) do
        if autoLaser and LaserRemote then
            local target = getClosestEnemy()
            if target then
                LaserRemote:FireServer(target.Position, target)
            end
        end
    end
end)
