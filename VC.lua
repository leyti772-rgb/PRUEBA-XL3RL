--========================================================
-- SIMULADOR DE TECLA E para Delta con MENÚ ON/OFF
--========================================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
ScreenGui.Name = "DeltaEKeySimulator"

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

-- Función para simular tecla E presionada 3.5s en Delta
local function pressE()
    if not simulateE then return end
    if firekeydown and firekeyup then
        firekeydown(LP, Enum.KeyCode.E)   -- presiona E
        task.wait(3.5)                    -- mantener presionado 3.5s
        firekeyup(LP, Enum.KeyCode.E)     -- soltar E
    end
end

-- Loop automático
task.spawn(function()
    while task.wait(0.1) do
        if simulateE then
            pressE()
            task.wait(3.5) -- espera entre simulaciones
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
