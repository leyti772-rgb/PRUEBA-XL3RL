--========================================================
-- AUTO BRAINROOT + MOVIMIENTO POST-COMPRA (HOOK FireServer)
--========================================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vim = game:GetService('VirtualInputManager')

-- Variables
local simulate = false
local HRP = nil

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

-- Función para presionar E 1.5 s
local function pressE()
    vim:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
    task.wait(1.5)
    vim:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
end

-- Función para mover pasos
local function moveSteps(steps)
    if not LP.Character then return end
    HRP = LP.Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return end
    local dir = math.random(0,1) == 0 and Vector3.new(1,0,0) or Vector3.new(-1,0,0)
    for i = 1, steps do
        HRP.CFrame = HRP.CFrame + dir
        task.wait(0.1)
    end
end

-- Hook a FireServer del RemoteEvent de compra
local remote = ReplicatedStorage.Packages.Net:FindFirstChild("RE/33094f22-ae31-46fd-88a7-27cb2c124c68")
if remote then
    local oldFire = remote.FireServer
    remote.FireServer = newcclosure(function(self, ...)
        local args = {...}

        -- Solo actúa si simulate está activo
        if simulate then
            -- Presionar E
            pressE()

            -- Mover pasos
            moveSteps(40)
        end

        -- Llamar al FireServer original
        return oldFire(self, ...)
    end)
end

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
