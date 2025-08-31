-- Activa cualquier ProximityPrompt al que estés cerca
local function activarPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return end

    -- método 1: usando fireproximityprompt (si tu executor lo soporta)
    if fireproximityprompt then
        fireproximityprompt(prompt, 1.2) -- simula mantener presionado 1.2s
        return
    end

    -- método 2: manual InputHoldBegin/End
    task.spawn(function()
        prompt:InputHoldBegin()
        task.wait(1.2) -- el tiempo que tarda en comprar
        prompt:InputHoldEnd()
    end)
end

-- Ejemplo: buscar el prompt más cercano y activarlo
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local function getClosestPrompt()
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local closest, dist = nil, math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled then
            local adornee = obj.Adornee or obj.Parent
            if adornee and adornee:IsA("BasePart") then
                local d = (hrp.Position - adornee.Position).Magnitude
                if d < dist and d <= obj.MaxActivationDistance + 2 then
                    closest, dist = obj, d
                end
            end
        end
    end
    return closest
end

-- Llamada de prueba: activa el prompt más cercano
local prompt = getClosestPrompt()
if prompt then
    activarPrompt(prompt)
else
    warn("No encontré ningún prompt cerca, acércate al objeto.")
end
