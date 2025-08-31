--========================================================
-- AUTO BRAINROOT + MOVIMIENTO POST-COMPRA (FUNCIONAL)
--========================================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local vim = game:GetService('VirtualInputManager')
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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

-- Lista de args de los 4 RemoteEvents de compra
local brainrootsArgs = {
    {1756610742.916985, "e7b56b5c-a11a-4dfd-997d-d16b81dd3fed", "accd3888-4d33-4191-8b96-eaa8279700b6"},
    {1756610734.042006, "e7b56b5c-a11a-4dfd-997d-d16b81dd3fed", "e80bb004-8ab7-492c-be0f-46d819d111e4"},
    {1756610728.0661,   "e7b56b5c-a11a-4dfd-997d-d16b81dd3fed", "e9d30dc4-b596-4688-9367-67b2ee794d54"},
    {1756610716.011005, "e7b56b5c-a11a-4dfd-997d-d16b81dd3fed", "b0cfb98f-8f81-48dd-8e62-d093e2eeb38c"}
}

-- Loop principal
task.spawn(function()
    local remote = ReplicatedStorage.Packages.Net:FindFirstChild("RE/33094f22-ae31-46fd-88a7-27cb2c124c68")
    if not remote then return end

    while true do
        if simulate then
            -- 1. Presionar E 1.5 s
            pressE()

            -- 2. Disparar los 4 RemoteEvents de compra
            for _, args in ipairs(brainrootsArgs) do
                remote:FireServer(unpack(args))
                task.wait(0.05) -- pequeño delay entre cada FireServer
            end

            -- 3. Mover 40 pasos después de la compra
            moveSteps(40)

            task.wait(0.1) -- delay pequeño antes del siguiente ciclo
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
