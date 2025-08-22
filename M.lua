-- ⚡ AutoLaser para Roba Brainroot (Beta)
-- Requiere el Remote: ReplicatedStorage.Packages.Net["RE/UseItem"]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LaserRemote = ReplicatedStorage.Packages.Net:FindFirstChild("RE/UseItem")
local autoLaser = false
local range = 200 -- distancia máxima

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoLaserGUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Icono flotante
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

-- Hacer el icono arrastrable
local UserInputService = game:GetService("UserInputService")
do
    local dragging, dragStart, startPos
    icon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = icon.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            icon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Panel
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

-- Abrir/cerrar panel
icon.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)

-- Toggle
toggle.MouseButton1Click:Connect(function()
    autoLaser = not autoLaser
    toggle.Text = autoLaser and "✅ AutoLaser ON" or "Activar AutoLaser"
end)

-- ================= AUTO LASER LOOP =================
task.spawn(function()
    while task.wait(0.2) do
        if autoLaser and LaserRemote then
            for _, enemy in ipairs(Players:GetPlayers()) do
                if enemy ~= LocalPlayer and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = enemy.Character.HumanoidRootPart
                    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if myHRP and (hrp.Position - myHRP.Position).Magnitude <= range then
                        -- Disparo hacia el jugador
                        LaserRemote:FireServer(hrp.Position, hrp)
                    end
                end
            end
        end
    end
end)

print("🔴 AutoLaser listo. Abre el menú con el icono rojo y activa el disparo automático.")
