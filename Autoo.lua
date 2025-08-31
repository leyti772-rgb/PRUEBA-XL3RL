--========================================================
-- AUTO BRAINROOT + SIMULACIÓN E + MOVIMIENTO
--========================================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local vim = game:GetService('VirtualInputManager')
local RunService = game:GetService("RunService")
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

local simulate = false

-- Función para presionar E usando VirtualInputManager
local function pressE()
    vim:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
    task.wait(3.5)
    vim:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
end

-- Función para disparar RemoteEvent del Brainroot
local function buyBrainroot(args)
    local remote = game:GetService("ReplicatedStorage").Packages.Net:FindFirstChild("RE/33094f22-ae31-46fd-88a7-27cb2c124c68")
    if remote then
        remote:FireServer(unpack(args))
    end
end

-- Lista de args de compra (tomados de SimpleSpy)
local brainrootsArgs = {
    {
        {1756609775.861301, "064f9995-3c29-4b3d-bf62-9d93de6836ae", "581c4e65-c26d-4519-8204-021948389e43"},
        {1756609775.861369, "e7b56b5c-a11a-4dfd-997d-d16b81dd3fed", "581c4e65-c26d-4519-8204-021948389e43"}
    },
    {
        {1756609763.631944, "064f9995-3c29-4b3d-bf62-9d93de6836ae", "5c947893-3f0e-4822-b5de-f1a698d742f8"},
        {1756609763.631986, "e7b56b5c-a11a-4dfd-997d-d16b81dd3fed", "5c947893-3f0e-4822-b5de-f1a698d742f8"}
    }
}

-- Función para mover el personaje 9 pasos a la derecha o izquierda
local function moveSteps(steps)
    if not LP.Character then return end
    HRP = LP.Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return end
    local dir = math.random(0,1) == 0 and Vector3.new(1,0,0) or Vector3.new(-1,0,0) -- derecha o izquierda
    for i = 1, steps do
        HRP.CFrame = HRP.CFrame + dir
        task.wait(0.1) -- tiempo entre pasos
    end
end

-- Loop automático
task.spawn(function()
    local idx = 1
    while true do
        if simulate then
            -- 1. Presionar E
            pressE()

            -- 2. Comprar Brainroot
            for _, argsPair in ipairs(brainrootsArgs[idx]) do
                buyBrainroot(argsPair)
            end

            -- 3. Mover 9 pasos aleatorios
            moveSteps(45)

            -- 4. Volver a esperar y repetir
            idx = idx >= #brainrootsArgs and 1 or idx + 1
        else
            task.wait(0.1)
        end
    end
end)

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
