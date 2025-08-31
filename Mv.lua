--========================================================
-- SIMULADOR DE TECLA E con MENÚ ON/OFF
--========================================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
ScreenGui.Name = "EKeySimulatorGui"

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

-- Estado
local simulateE = false

-- Función para simular E presionada 1.5 s
local function pressE()
    if not simulateE then return end
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        -- Algunos exploits permiten simular la tecla con firekey o fireinput
        if firekeydown then
            firekeydown(LP, Enum.KeyCode.E)
            task.wait(1.5)
            firekeyup(LP, Enum.KeyCode.E)
        elseif fireproximityprompt then
            -- Alternativa, algunos exploits reconocen fireproximityprompt como input real
            -- Este ejemplo no activa ningún objeto, solo sirve como placeholder
            task.wait(1.5)
        end
    end
end

-- Loop automático
task.spawn(function()
    while task.wait(0.1) do
        if simulateE then
            pressE()
            task.wait(1.5) -- esperar entre simulaciones
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
