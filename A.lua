-- ⚡ SpeedHack con RE/UseItem (para Android / Delta)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote = ReplicatedStorage.Packages.Net:FindFirstChild("RE/UseItem")

-- GUI básica flotante
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local Toggle = Instance.new("TextButton", Frame)

Frame.Size = UDim2.new(0, 180, 0, 60)
Frame.Position = UDim2.new(0.7, 0, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Active, Frame.Draggable = true, true
Frame.BorderSizePixel = 0
Frame.BackgroundTransparency = 0.2

Toggle.Size = UDim2.new(1, -10, 1, -10)
Toggle.Position = UDim2.new(0, 5, 0, 5)
Toggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Toggle.Text = "Activar Velocidad"
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.Font = Enum.Font.GothamBold
Toggle.TextScaled = true

-- Vars
local activo = false
local loop

Toggle.MouseButton1Click:Connect(function()
    activo = not activo
    if activo then
        Toggle.Text = "Velocidad ON"
        Toggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)

        loop = task.spawn(function()
            while activo do
                pcall(function()
                    Remote:FireServer(1.983) -- el argumento clave
                end)
                task.wait(0.05) -- ajusta velocidad de spam (más bajo = más rápido)
            end
        end)
    else
        Toggle.Text = "Activar Velocidad"
        Toggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        activo = false
    end
end)
