-- ⚡ Velocidad Fusionada con Spawneo de RE/UseItem + Slider de Velocidad
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local Remote = RS.Packages.Net:FindFirstChild("RE/UseItem")

-- GUI flotante
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SpeedUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 110)
Frame.Position = UDim2.new(0.7, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Active, Frame.Draggable = true, true
Frame.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Text = "⚡ Speed Hack XL"
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(0,255,180)

local Toggle = Instance.new("TextButton", Frame)
Toggle.Size = UDim2.new(0.9, 0, 0, 30)
Toggle.Position = UDim2.new(0.05, 0, 0, 30)
Toggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Toggle.Text = "Activar Velocidad"
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.Font = Enum.Font.GothamBold
Toggle.TextScaled = true

-- Slider
local SliderFrame = Instance.new("Frame", Frame)
SliderFrame.Size = UDim2.new(0.9, 0, 0, 20)
SliderFrame.Position = UDim2.new(0.05, 0, 0, 70)
SliderFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
SliderFrame.BorderSizePixel = 0

local Fill = Instance.new("Frame", SliderFrame)
Fill.Size = UDim2.new(0.3, 0, 1, 0) -- default 30%
Fill.BackgroundColor3 = Color3.fromRGB(0,200,100)
Fill.BorderSizePixel = 0

local SpeedText = Instance.new("TextLabel", Frame)
SpeedText.Size = UDim2.new(1, 0, 0, 20)
SpeedText.Position = UDim2.new(0, 0, 0, 90)
SpeedText.BackgroundTransparency = 1
SpeedText.Text = "Velocidad: 36"
SpeedText.Font = Enum.Font.Gotham
SpeedText.TextSize = 14
SpeedText.TextColor3 = Color3.new(1,1,1)

-- Vars
local activo = false
local loop
local speed = 36 -- default

-- Slider input
local UserInputService = game:GetService("UserInputService")
SliderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local moveConn, releaseConn
        moveConn = UserInputService.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                local rel = math.clamp((i.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
                Fill.Size = UDim2.new(rel, 0, 1, 0)
                speed = math.floor(16 + rel * (100-16)) -- rango 16–100
                SpeedText.Text = "Velocidad: "..speed
            end
        end)
        releaseConn = UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                moveConn:Disconnect()
                releaseConn:Disconnect()
            end
        end)
    end
end)

-- Toggle ON/OFF
Toggle.MouseButton1Click:Connect(function()
    activo = not activo
    if activo then
        Toggle.Text = "Velocidad ON"
        Toggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)

        loop = task.spawn(function()
            while activo do
                -- 1. Spawneo remoto (simula ítem legítimo)
                pcall(function()
                    Remote:FireServer(1.983)
                end)

                -- 2. Booster de velocidad real
                local char = LP.Character or LP.CharacterAdded:Wait()
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.WalkSpeed = speed
                end

                task.wait(0.1)
            end
        end)
    else
        Toggle.Text = "Activar Velocidad"
        Toggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        if loop then loop = nil end
        local char = LP.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end
end)
