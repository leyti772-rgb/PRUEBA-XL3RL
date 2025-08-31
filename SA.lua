--========================================================
-- AUTO COMPRADOR con MENÚ ON/OFF
--========================================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
ScreenGui.Name = "AutoBuyGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,200,0,100)
Frame.Position = UDim2.new(0.5,-100,0.5,-50)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true

local Btn = Instance.new("TextButton", Frame)
Btn.Size = UDim2.new(1,-20,0,40)
Btn.Position = UDim2.new(0,10,0.5,-20)
Btn.Text = "Auto Comprar: OFF"
Btn.BackgroundColor3 = Color3.fromRGB(170,0,0)
Btn.TextColor3 = Color3.new(1,1,1)
Btn.Font = Enum.Font.SourceSansBold
Btn.TextSize = 16

-- Estado
local autoBuy = false

-- Función activar un ProximityPrompt
local function activarPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return end

    if fireproximityprompt then
        fireproximityprompt(prompt, 1.2) -- muchos exploits soportan esto
    else
        task.spawn(function()
            prompt:InputHoldBegin()
            task.wait(1.2)
            prompt:InputHoldEnd()
        end)
    end
end

-- Buscar prompt más cercano
local function getClosestPrompt()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
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

-- Loop automático
task.spawn(function()
    while task.wait(0.5) do
        if autoBuy then
            local prompt = getClosestPrompt()
            if prompt then
                activarPrompt(prompt)
            end
        end
    end
end)

-- Botón ON/OFF
Btn.MouseButton1Click:Connect(function()
    autoBuy = not autoBuy
    if autoBuy then
        Btn.Text = "Auto Comprar: ON"
        Btn.BackgroundColor3 = Color3.fromRGB(0,170,0)
    else
        Btn.Text = "Auto Comprar: OFF"
        Btn.BackgroundColor3 = Color3.fromRGB(170,0,0)
    end
end)
