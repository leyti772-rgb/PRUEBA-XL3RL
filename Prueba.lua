-- ⚡ Speed Hack Menu (Experimental para Roba Brainroot)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local humanoid = nil

-- Espera al cargar personaje
player.CharacterAdded:Connect(function(char)
    humanoid = char:WaitForChild("Humanoid")
end)
if player.Character then
    humanoid = player.Character:WaitForChild("Humanoid")
end

-- ================== GUI ==================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedHackGui"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Botón flotante (icono)
local openButton = Instance.new("ImageButton")
openButton.Size = UDim2.new(0, 50, 0, 50)
openButton.Position = UDim2.new(0, 20, 0.5, -25)
openButton.BackgroundTransparency = 1
openButton.Image = "rbxassetid://3926305904" -- icono
openButton.ImageColor3 = Color3.fromRGB(0, 255, 255)
openButton.Parent = screenGui

-- Panel
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 200, 0, 100)
panel.Position = UDim2.new(0, 80, 0.5, -50)
panel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
panel.Visible = false
panel.Parent = screenGui

local corner = Instance.new("UICorner", panel)
corner.CornerRadius = UDim.new(0, 6)

local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "⚡ Speed Hack"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.Code
title.BackgroundTransparency = 1
title.TextSize = 16

-- Toggle botón
local toggle = Instance.new("TextButton", panel)
toggle.Size = UDim2.new(0, 120, 0, 30)
toggle.Position = UDim2.new(0.5, -60, 0.5, -15)
toggle.Text = "Activar Speed"
toggle.TextColor3 = Color3.new(1,1,1)
toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
toggle.Font = Enum.Font.Code
toggle.TextSize = 14
Instance.new("UICorner", toggle)

-- Abrir/cerrar panel
openButton.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)

-- ================== SPEED HACK ==================
local speedMultiplier = 3 -- x3 más rápido
local running = false
local enabled = false

toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    toggle.Text = enabled and "Speed Activado" or "Activar Speed"
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.LeftShift and enabled then
        running = true
    end
end)

UIS.InputEnded:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        running = false
    end
end)

RunService.RenderStepped:Connect(function()
    if humanoid and running then
        local moveDir = humanoid.MoveDirection
        if moveDir.Magnitude > 0 then
            humanoid:Move(moveDir * speedMultiplier, true)
        end
    end
end)

print("⚡ Menú Speed cargado. Presiona el icono, activa, y corre con Shift.")
