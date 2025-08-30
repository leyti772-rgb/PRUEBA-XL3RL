-- Crear UI básica (ScreenGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportMenu"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Crear frame del menú
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = screenGui

-- Botón de teleport
local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(0, 180, 0, 50)
TeleportButton.Position = UDim2.new(0, 10, 0, 25)
TeleportButton.Text = "Teleportar"
TeleportButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.Parent = frame

-- Variables de control
local buscando = false
local destino = Vector3.new(0, 10, 0) -- reemplaza con tu destino real

-- Función de teleport
local function TeleportPlayer(destination)
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(destination)
    end
end

-- Función con reintentos
local function intentarTeleport(destination)
    if buscando then return end
    buscando = true
    TeleportButton.Text = "Buscando..."

    task.spawn(function()
        while buscando do
            local success = pcall(function()
                TeleportPlayer(destination)
            end)

            if success then
                TeleportButton.Text = "Teleportado!"
                buscando = false
            else
                TeleportButton.Text = "Reintentando..."
                task.wait(2)
            end
        end
    end)
end

-- Conectar botón
TeleportButton.MouseButton1Click:Connect(function()
    intentarTeleport(destino)
end)
