--========================================================
-- SIMULADOR DE INPUTOBJECT para tecla E
--========================================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- GUI simple
local ScreenGui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
ScreenGui.Name = "InputObjectGui"

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

-- Función para crear InputObject simulado
local function pressE()
    if not simulateE then return end

    local UIS = game:GetService("UserInputService")
    local inputObject = Instance.new("InputObject") -- algunos exploits permiten esto
    inputObject.UserInputType = Enum.UserInputType.Keyboard
    inputObject.KeyCode = Enum.KeyCode.E
    inputObject.UserInputState = Enum.UserInputState.Begin

    -- Disparar el evento de InputObject
    if UIS.InputBegan then
        UIS.InputBegan:Fire(inputObject, false)
    end

    task.wait(1.5) -- mantener presionado 1.5 s

    inputObject.UserInputState = Enum.UserInputState.End
    if UIS.InputEnded then
        UIS.InputEnded:Fire(inputObject, false)
    end
end

-- Loop
task.spawn(function()
    while task.wait(0.1) do
        if simulateE then
            pressE()
            task.wait(1.5)
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
