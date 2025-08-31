local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local simulate = false

-- Detectar "compra" observando inventario u objeto de Brainroot
local function brainrootDetected()
    -- Por ejemplo: revisar si un objeto específico aparece en el Character o inventario
    local inv = LP:FindFirstChild("Backpack") or LP:FindFirstChild("PlayerGui")
    if not inv then return false end

    -- Aquí poner la lógica de detección real del Brainroot
    -- Esto depende de cómo Delta añade el Brainroot al jugador
    -- Por ahora usamos ejemplo: un objeto llamado "Brainroot"
    return LP.Backpack:FindFirstChild("Brainroot") ~= nil
end

-- Presionar E 3.5 s con pequeños delays
local function pressE()
    vim:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
    task.wait(3.5)
    vim:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
    task.wait(math.random(0.1,0.3)) -- pequeño delay aleatorio
end

-- Mover humanoid de forma más natural
local function moveHuman(steps)
    if not LP.Character then return end
    local HRP = LP.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = LP.Character:FindFirstChild("Humanoid")
    if not HRP or not humanoid then return end

    for i=1,steps do
        local dir = Vector3.new(math.random(-5,5),0,math.random(-5,5))
        local target = HRP.Position + dir
        humanoid:MoveTo(target)
        humanoid.MoveToFinished:Wait()
        task.wait(math.random(0.1,0.3)) -- pausas cortas
    end
end

-- Loop principal
task.spawn(function()
    while true do
        if simulate then
            pressE()
            if brainrootDetected() then
                moveHuman(4) -- pasos naturales
            end
        else
            task.wait(0.05)
        end
    end
end)
