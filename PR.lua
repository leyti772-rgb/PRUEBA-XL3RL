-- Variables de control
local buscando = false
local destino = Vector3.new(0, 10, 0) -- reemplaza con tu destino real

-- Función para teletransportar al jugador
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
            local success, err = pcall(function()
                TeleportPlayer(destination)
            end)

            if success then
                print("Teletransportado correctamente!")
                TeleportButton.Text = "Teleportar"
                buscando = false
            else
                print("Fallo al teletransportar, reintentando...")
                TeleportButton.Text = "Reintentando..."
                task.wait(2) -- espera 2 segundos antes de volver a intentar
            end
        end
    end)
end

-- Conectar el botón
TeleportButton.MouseButton1Click:Connect(function()
    intentarTeleport(destino)
end)
