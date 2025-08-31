--========================================================
-- SIMULADOR DE TECLA E usando la función de Whoman#3561
--========================================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local vim = game:GetService('VirtualInputManager')

-- Usamos la función hold de Whoman
local input = {
    hold = function(key, time)
        vim:SendKeyEvent(true, key, false, nil)
        task.wait(time)
        vim:SendKeyEvent(false, key, false, nil)
    end
}

-- GUI
local ScreenGui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
ScreenGui.Name = "VirtualEKeySimulator"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,220,0,120)
Frame.Position = UDim2.new(0.5,-110,0.5,-60)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true

local Btn = Instance.new("TextButton", Frame)
Btn.Size = UDim2.new(1,-20,0,40)
Btn.Position = UDim2.new(0,10,0,20)
Btn.Text = "Simular E: OFF"
Btn.BackgroundColor3 = Color3.fromRGB(170,0,0)
Btn.TextColor3 = Color3.new(1,1,1)
Btn.Font = Enum.Font.SourceSansBold
Btn.TextSize = 16

local simulateE = false

-- Función que mantiene E 3.5s usando input.hold
local function pressE()
    input.hold(Enum.KeyCode.E, 1.5)
end

-- Loop automático que repite cada 3.5 segundos
task.spawn(function()
    while true do
        if simulateE then
            pressE()
            task.wait(1.5)
        else
            task.wait(0.1)
        end
    end
end)

-- Botón ON/OFF
Btn.MouseButton1Click:Connect(function()
    simulateE = not simulateE
    if simulateE then
        Btn.Text = "Simular E: ON"
        Btn.BackgroundColor3 = Color3.fromRGB(0,170,0)
    else
        Btn.Text = "Simular E: OFF"
        Btn.BackgroundColor3 = Color3.fromRGB(170,0,0)
    end
end)
