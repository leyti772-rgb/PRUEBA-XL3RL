--========================================================
-- AUTO COMPRADOR BRAINROOTS SEGURO con MENÚ ON/OFF
--========================================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- GUI
local ScreenGui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
ScreenGui.Name = "SafeAutoBuyGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,200,0,100)
Frame.Position = UDim2.new(0.5,-100,0.5,-50)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true

local Btn = Instance.new("TextButton", Frame)
Btn.Size = UDim2.new(1,-20,0,40)
Btn.Position = UDim2.new(0,10,0.5,-20)
Btn.Text = "Auto Comprar Brainroots: OFF"
Btn.BackgroundColor3 = Color3.fromRGB(170,0,0)
Btn.TextColor3 = Color3.new(1,1,1)
Btn.Font = Enum.Font.SourceSansBold
Btn.TextSize = 16

-- Estado
local autoBuy = false

-- Función para obtener el ProximityPrompt más cercano de Brainroots
local function getClosestBrainrootPrompt()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local closestPrompt = nil
    local minDist = math.huge

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled and obj.Parent:FindFirstChild("Name") then
            if obj.Parent.Name:lower():find("brainroot") then
                local part = obj.Adornee or obj.Parent:FindFirstChildWhichIsA("BasePart")
                if part then
                    local dist = (hrp.Position - part.Position).Magnitude
                    if dist < minDist and dist <= obj.MaxActivationDistance + 2 then
                        closestPrompt = obj
                        minDist = dist
                    end
                end
            end
        end
    end

    return closestPrompt
end

-- Función para activar el ProximityPrompt de forma segura
local function activatePrompt(prompt)
    if not prompt then return end
    if fireproximityprompt then
        fireproximityprompt(prompt, 1.5) -- Exploits que soportan fireproximityprompt
    else
        -- Simula mantener presionado el prompt durante 1.5s
        task.spawn(function()
            prompt:InputHoldBegin()
            task.wait(1.5)
            prompt:InputHoldEnd()
        end)
    end
end

-- Loop automático
task.spawn(function()
    while task.wait(0.5) do
        if autoBuy then
            local prompt = getClosestBrainrootPrompt()
            if prompt then
                activatePrompt(prompt)
            end
        end
    end
end)

-- Botón ON/OFF
Btn.MouseButton1Click:Connect(function()
    autoBuy = not autoBuy
    if autoBuy then
        Btn.Text = "Auto Comprar Brainroots: ON"
        Btn.BackgroundColor3 = Color3.fromRGB(0,170,0)
    else
        Btn.Text = "Auto Comprar Brainroots: OFF"
        Btn.BackgroundColor3 = Color3.fromRGB(170,0,0)
    end
end)
