--========================================================
-- AUTO BRAINROOT + CICLO E ~1.2s + MOVIMIENTO HUMANO ANTI-BAN
--========================================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local vim = game:GetService('VirtualInputManager')
local simulate = false

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

-- Presionar E ~1.2 s con micro-delay aleatorio
local function pressE()
    vim:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
    task.wait(math.random(11,12)/10) -- 1.1 a 1.2 s
    vim:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
    task.wait(math.random(0.1,0.3)) -- micro delay para parecer humano
end

-- Detectar Brainroot en inventario o Character
local function brainrootDetected()
    local backpack = LP:FindFirstChild("Backpack")
    if backpack and backpack:FindFirstChild("Brainroot") then
        return true
    end
    local char = LP.Character
    if char and char:FindFirstChild("Brainroot") then
        return true
    end
    return false
end

-- Movimiento humano natural anti-ban
local function moveHuman(steps)
    if not LP.Character then return end
    local HRP = LP.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = LP.Character:FindFirstChild("Humanoid")
    if not HRP or not humanoid then return end

    for i = 1, steps do
        local dir = Vector3.new(math.random(-4,4),0,math.random(-4,4)) -- distancia aleatoria
        local target = HRP.Position + dir
        humanoid:MoveTo(target)
        humanoid.MoveToFinished:Wait()
        task.wait(math.random(0.1,0.4)) -- pausa corta aleatoria
    end
end

-- Loop principal
task.spawn(function()
    while true do
        if simulate then
            pressE()
            if brainrootDetected() then
                moveHuman(math.random(3,5)) -- pasos aleatorios 3–5
            end
        else
            task.wait(0.05)
        end
    end
end)
