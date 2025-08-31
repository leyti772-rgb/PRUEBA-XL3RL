-- === Tester robusto para ProximityPrompt (móvil/PC) ===
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PromptTester"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LP:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,260,0,120)
Frame.Position = UDim2.new(0.5,-130,0.5,-60)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Btn = Instance.new("TextButton")
Btn.Size = UDim2.new(1,-20,0,44)
Btn.Position = UDim2.new(0,10,0,40)
Btn.BackgroundColor3 = Color3.fromRGB(0,170,0)
Btn.TextColor3 = Color3.new(1,1,1)
Btn.Font = Enum.Font.Code
Btn.TextSize = 15
Btn.Text = "Probar activar prompt (robusto)"
Btn.Parent = Frame

local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1,-20,0,28)
Info.Position = UDim2.new(0,10,0,6)
Info.BackgroundTransparency = 1
Info.TextColor3 = Color3.new(1,1,1)
Info.Font = Enum.Font.Code
Info.TextSize = 14
Info.Text = "Acércate al objeto y presiona el botón"
Info.Parent = Frame

-- Util: obtener HRP (espera si respawneas)
local function getHRP()
    local char = LP.Character or LP.CharacterAdded:Wait()
    return char:FindFirstChild("HumanoidRootPart")
end

-- Posición "mundo" del prompt (Adornee o parent)
local function promptWorldPos(prompt)
    if not prompt then return nil end
    if prompt.Adornee and prompt.Adornee:IsA("BasePart") then
        return prompt.Adornee.Position
    end
    local p = prompt.Parent
    if p and p:IsA("BasePart") then
        return p.Position
    end
    return nil
end

-- Encontrar prompt más cercano dentro de su MaxActivationDistance (+tolerancia)
local function findClosestPrompt(tolerance)
    tolerance = tolerance or 2
    local hrp = getHRP()
    if not hrp then return nil end

    local best, bestDist = nil, math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled then
            local pos = promptWorldPos(obj)
            if pos then
                local dist = (hrp.Position - pos).Magnitude
                local allowed = (obj.MaxActivationDistance or 12) + tolerance
                if dist <= allowed and dist < bestDist then
                    bestDist = dist
                    best = obj
                end
            end
        end
    end
    return best
end

-- Mueve jugador cerca del prompt (mantiene previous CFrame)
local function movePlayerNear(pos)
    local hrp = getHRP()
    if not hrp or not pos then return false, nil end
    local prev = hrp.CFrame
    local ok, err = pcall(function()
        -- colócalo 3 studs arriba y mirando al objeto
        hrp.CFrame = CFrame.new(pos + Vector3.new(0,3,0), pos)
    end)
    if not ok then
        warn("No se pudo mover al jugador:", err)
        return false, prev
    end
    task.wait(0.12) -- dejar que la física actualice
    return true, prev
end

-- Busca fireproximityprompt en varios espacios
local function findFPP()
    local candidates = {}
    if _G and _G.fireproximityprompt then table.insert(candidates, _G.fireproximityprompt) end
    if getgenv and getgenv().fireproximityprompt then table.insert(candidates, getgenv().fireproximityprompt) end
    if shared and shared.fireproximityprompt then table.insert(candidates, shared.fireproximityprompt) end
    if rawget and rawget(_G, "fireproximityprompt") then table.insert(candidates, rawget(_G, "fireproximityprompt")) end
    for _,fn in ipairs(candidates) do
        if type(fn) == "function" then return fn end
    end
    return nil
end

-- Intenta activar el prompt con varios métodos
local function triggerPromptRobust(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return false, "Prompt inválido" end
    local errors = {}

    -- 1) fireproximityprompt (exploits)
    local fpp = findFPP()
    if fpp then
        local ok, e = pcall(function()
            -- algunos FPP aceptan duración como 2do parámetro
            fpp(prompt, prompt.HoldDuration or 3)
        end)
        if ok then return true, "Usado fireproximityprompt" else table.insert(errors, "fpp:"..tostring(e)) end
    end

    -- 2) InputHoldBegin/End respetando HoldDuration
    local ok2, e2 = pcall(function()
        local hold = prompt.HoldDuration or 3
        prompt:InputHoldBegin()
        task.wait(hold)
        prompt:InputHoldEnd()
    end)
    if ok2 then return true, "Usado InputHoldBegin/End (normal)" else table.insert(errors, "inputHold:"..tostring(e2)) end

    -- 3) Forzar HoldDuration = 0 (fallback)
    local ok3, e3 = pcall(function()
        local old = nil
        pcall(function() old = prompt.HoldDuration end)
        pcall(function() prompt.HoldDuration = 0 end)
        prompt:InputHoldBegin()
        task.wait(0.06)
        prompt:InputHoldEnd()
        if old ~= nil then
            pcall(function() prompt.HoldDuration = old end)
        end
    end)
    if ok3 then return true, "Forzado HoldDuration=0" else table.insert(errors, "force0:"..tostring(e3)) end

    return false, table.concat(errors, " | ")
end

-- CLICK: intenta todo el flujo
Btn.MouseButton1Click:Connect(function()
    task.spawn(function()
        local prompt = findClosestPrompt(2)
        if not prompt then
            warn("No se encontró ProximityPrompt cercano. Acércate y prueba de nuevo.")
            return
        end

        local pos = promptWorldPos(prompt)
        if not pos then
            warn("No se pudo determinar la posición del prompt.")
            return
        end

        local moved, prev = movePlayerNear(pos)
        if not moved then
            warn("No se pudo posicionar cerca del prompt; aun así intentaré activarlo.")
        end

        local ok, msg = triggerPromptRobust(prompt)
        if ok then
            print("✅ Prompt activado correctamente:", msg)
        else
            warn("❌ No se pudo activar el prompt. Detalles:", msg)
            warn("Consejos: acércate más, mira hacia el objeto, comprueba si el executor soporta fireproximityprompt.")
        end

        -- restaurar posición previa (si se movió)
        if moved and prev then
            pcall(function()
                local hrp = getHRP()
                if hrp then hrp.CFrame = prev end
            end)
        end
    end)
end)
