-- === Menu simple para probar "mantener E" (compatible móvil/PC) ===
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TestPromptGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LP:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 110)
Frame.Position = UDim2.new(0.5, -110, 0.5, -55)
Frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Btn = Instance.new("TextButton")
Btn.Size = UDim2.new(1, -20, 0, 44)
Btn.Position = UDim2.new(0, 10, 0, 33)
Btn.BackgroundColor3 = Color3.fromRGB(0,170,0)
Btn.TextColor3 = Color3.new(1,1,1)
Btn.Font = Enum.Font.Code
Btn.TextSize = 16
Btn.Text = "Probar compra (mantener E)"
Btn.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 24)
Title.Position = UDim2.new(0,10,0,6)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.Code
Title.TextSize = 16
Title.Text = "Tester ProximityPrompt"
Title.Parent = Frame

-- Utilidad: obtener HRP siempre actualizado (por si respawneas)
local function getHRP()
    local char = LP.Character or LP.CharacterAdded:Wait()
    return char:FindFirstChild("HumanoidRootPart")
end

-- Calcula posición del prompt (usa Adornee si existe)
local function promptWorldPos(prompt)
    local adornee = prompt.Adornee
    if adornee and adornee:IsA("BasePart") then
        return adornee.Position
    end
    local parent = prompt.Parent
    if parent and parent:IsA("BasePart") then
        return parent.Position
    end
    return nil
end

-- Busca el ProximityPrompt válido más cercano, dentro de su rango
local function findClosestPrompt(maxExtraRange)
    local hrp = getHRP()
    if not hrp then return nil end

    local closest, bestDist = nil, math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled then
            local pos = promptWorldPos(obj)
            if pos then
                local dist = (hrp.Position - pos).Magnitude
                local allowed = (obj.MaxActivationDistance or 12) + (maxExtraRange or 2)
                if dist <= allowed and dist < bestDist then
                    closest, bestDist = obj, dist
                end
            end
        end
    end
    return closest
end

-- Dispara el prompt: preferir fireproximityprompt (mejor en Android/Delta)
local function triggerPrompt(prompt)
    if not (prompt and prompt:IsA("ProximityPrompt")) then return false end

    -- 1) Intento con fireproximityprompt (exploits)
    local fpp = rawget(getfenv() or _G, "fireproximityprompt") or _G.fireproximityprompt or (getgenv and getgenv().fireproximityprompt)
    if typeof(fpp) == "function" then
        local ok = pcall(function()
            -- algunos executors aceptan 2do parámetro (duración)
            fpp(prompt, prompt.HoldDuration or 3)
        end)
        if ok then return true end
    end

    -- 2) Fallback: InputHoldBegin/End
    local ok2 = pcall(function()
        -- truco: bajar hold a 0 localmente para que sea instantáneo si el juego lo permite
        local old = prompt.HoldDuration
        if old and old > 0 then
            prompt.HoldDuration = 0
        end
        prompt:InputHoldBegin()
        task.wait((old and old > 0) and 0.1 or 0.05)
        prompt:InputHoldEnd()
        if old and old > 0 then
            prompt.HoldDuration = old
        end
    end)
    if ok2 then return true end

    return false
end

-- Un toque = un intento
Btn.MouseButton1Click:Connect(function()
    -- Busca un prompt cercano (usa +2 studs de tolerancia)
    local prompt = findClosestPrompt(2)
    if not prompt then
        warn("No hay ProximityPrompt cercano (acércate un poco más).")
        return
    end

    -- Intenta activarlo
    local ok = triggerPrompt(prompt)
    if not ok then
        warn("No se pudo activar el ProximityPrompt. (Prueba más cerca o revisa permisos del executor)")
    end
end)
