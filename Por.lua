--========================================================
-- AUTO BRAINROOT + CICLO E 3.5s + MOVIMIENTO REAL POST-COMPRA
--========================================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vim = game:GetService('VirtualInputManager')
local simulate = false

-- Función para presionar E 3.5 s
local function pressE()
    vim:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
    task.wait(3.5)  -- mantener presionada E
    vim:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
end

-- Función para mover el personaje caminando realmente
local function moveStepsReal(steps)
    if not LP.Character then return end
    local HRP = LP.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = LP.Character:FindFirstChild("Humanoid")
    if not HRP or not humanoid then return end

    -- Elegir dirección aleatoria en X-Z
    local dir = math.random(0,1) == 0 and Vector3.new(10,0,0) or Vector3.new(-10,0,0)
    local targetPos = HRP.Position + dir

    for i = 1, steps do
        if humanoid and HRP then
            humanoid:MoveTo(targetPos)
            humanoid.MoveToFinished:Wait() -- espera a llegar al objetivo
            targetPos = targetPos + dir -- siguiente paso
        end
    end
end

-- GUI
local ScreenGui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
ScreenGui.Name = "AutoBrainrootGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,250,0,150)
Frame.Position = UDim2.new(0.5,-125,0.5,-75)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true

local Btn = Instance.new("TextButton", Frame)
Btn.Size = UDim2.new(1,-20,0,50)
Btn.Position = UDim2.new(0,10,0,20)
Btn.Text = "AUTO BRAINROOT: OFF"
Btn.BackgroundColor3 = Color3.fromRGB(170,0,0)
Btn.TextColor3 = Color3.new(1,1,1)
Btn.Font = Enum.Font.SourceSansBold
Btn.TextSize = 16

-- Botón ON/OFF
Btn.MouseButton1Click:Connect(function()
    simulate = not simulate
    if simulate then
        Btn.Text = "AUTO BRAINROOT: ON"
        Btn.BackgroundColor3 = Color3.fromRGB(0,170,0)
    else
        Btn.Text = "AUTO BRAINROOT: OFF"
        Btn.BackgroundColor3 = Color3.fromRGB(170,0,0)
    end
end)

-- Hook de __namecall para detectar FireServer de RemoteEvent específico
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    
    if method == "FireServer" and simulate then
        -- Detectamos si el RemoteEvent es el correcto
        if self.Name == "RE/33094f22-ae31-46fd-88a7-27cb2c124c68" then
            moveStepsReal(4) -- número de pasos caminando, puedes ajustar
        end
    end

    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- Loop principal de presionar E continuamente
task.spawn(function()
    while true do
        if simulate then
            pressE()
        else
            task.wait(0.05)
        end
    end
end)
