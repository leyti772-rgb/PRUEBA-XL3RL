local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Character = LP.Character or LP.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

-- GUI
local ScreenGui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
ScreenGui.Name = "TestGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,200,0,100)
Frame.Position = UDim2.new(0.5,-100,0.5,-50)
Frame.BackgroundColor3 = Color3.fromRGB(40,40,40)

local Btn = Instance.new("TextButton", Frame)
Btn.Size = UDim2.new(1,-20,0,40)
Btn.Position = UDim2.new(0,10,0.5,-20)
Btn.Text = "Probar E Automático"
Btn.BackgroundColor3 = Color3.fromRGB(0,170,0)
Btn.TextColor3 = Color3.new(1,1,1)
Btn.Font = Enum.Font.Code
Btn.TextSize = 16

-- Función mantener presionado E
local function mantenerE(prompt)
    if prompt and prompt:IsA("ProximityPrompt") then
        prompt:InputHoldBegin()
        task.wait(prompt.HoldDuration or 3)
        prompt:InputHoldEnd()
        print("✅ Se simuló mantener presionado E")
    else
        warn("⚠️ No se encontró un ProximityPrompt válido")
    end
end

-- Buscar el ProximityPrompt más cercano
local function findClosestPrompt()
    local closestPrompt = nil
    local shortestDist = math.huge

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            local parent = obj.Parent
            if parent and parent:IsA("BasePart") then
                local dist = (HRP.Position - parent.Position).Magnitude
                if dist < shortestDist and dist < 15 then -- rango 15 studs
                    shortestDist = dist
                    closestPrompt = obj
                end
            end
        end
    end

    return closestPrompt
end

-- Acción del botón
Btn.MouseButton1Click:Connect(function()
    local prompt = findClosestPrompt()
    if prompt then
        mantenerE(prompt)
    else
        warn("❌ No hay ProximityPrompt cercano")
    end
end)
