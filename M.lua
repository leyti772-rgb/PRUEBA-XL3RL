-- ⚡ Auto-Laser Menu (Beta para Roba Brainroot)
-- Nota: Debes cambiar "LaserRemote" por el nombre real del Remote del juego

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- ⚠️ Cambiar este nombre cuando sepas el Remote exacto
local LaserRemote = ReplicatedStorage:WaitForChild("LaserRemote", 10)

-- Config
local autoLaser = false
local range = 200 -- distancia máxima

-- ================= GUI =================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoLaserGUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Icono flotante
local icon = Instance.new("ImageButton")
icon.Size = UDim2.new(0, 50, 0, 50)
icon.Position = UDim2.new(0, 20, 0.5, -25)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://3926305904"
icon.ImageColor3 = Color3.fromRGB(255, 50, 50)
icon.Parent = screenGui

-- Hacer el icono arrastrable
do
    local dragging = false
    local dragStart, startPos

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
panel.Size = UDim2.new(0, 200, 0, 100)
panel.Position = UDim2.new(0, 80, 0.5, -50)
panel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
panel.Visible = false
panel.Parent = screenGui

Instance.new("UICorner", panel)

local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🔴 Auto-Laser"
title.TextColor3 = Color3.fromRGB(255, 50, 50)
title.Font = Enum.Font.Code
title.BackgroundTransparency = 1
title.TextSize = 16

local toggle = Instance.new("TextButton", panel)
toggle.Size = UDim2.new(0, 120, 0, 30)
toggle.Position = UDim2.new(0.5, -60, 0.5, -15)
toggle.Text = "Activar AutoLaser"
toggle.TextColor3 = Color3.new(1,1,1)
toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
toggle.Font = Enum.Font.Code
toggle.TextSize = 14
Instance.new("UICorner", toggle)

-- Abrir/Cerrar panel
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
                        -- ⚡ Disparo láser automático
                        -- ⚠️ Aquí ajusta parámetros según el Remote real
                        LaserRemote:FireServer(hrp.Position)
                    end
                end
            end
        end
    end
end)

print("🔴 AutoLaser cargado (Beta). Abre con el icono y activa desde el panel.")
