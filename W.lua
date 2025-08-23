-- ⚠️ USO EN TUS PROPIOS JUEGOS / SERVIDORES PRIVADOS CON PERMISO
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- Limpia GUIs previos
pcall(function()
    local g = (LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui")):FindFirstChild("SpeedTrainerUI")
    if g then g:Destroy() end
end)

local pg = LP:WaitForChild("PlayerGui")
local gui = Instance.new("ScreenGui")
gui.Name = "SpeedTrainerUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = pg

-- Botón flotante
local btn = Instance.new("Frame")
btn.Size = UDim2.new(0, 54, 0, 54)
btn.Position = UDim2.new(0.07, 0, 0.2, 0)
btn.BackgroundColor3 = Color3.fromRGB(25,25,25)
btn.Parent = gui
btn.Active = true; btn.Draggable = true
Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
local t = Instance.new("TextButton")
t.Parent = btn
t.BackgroundTransparency = 1
t.Size = UDim2.fromScale(1,1)
t.Font = Enum.Font.GothamBlack
t.Text = "XL"
t.TextScaled = true
t.TextColor3 = Color3.fromRGB(255,255,255)

-- Ventana
local win = Instance.new("Frame")
win.Size = UDim2.new(0, 240, 0, 130)
win.Position = UDim2.new(0.5, -120, 0.45, -65)
win.BackgroundColor3 = Color3.fromRGB(20,20,20)
win.Visible = false
win.Active = true; win.Draggable = true
win.Parent = gui
Instance.new("UICorner", win).CornerRadius = UDim.new(0,12)
local title = Instance.new("TextLabel", win)
title.Size = UDim2.new(1, -16, 0, 26)
title.Position = UDim2.new(0, 8, 0, 6)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBlack
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "Speed Trainer"
title.TextColor3 = Color3.fromRGB(0,255,180)

-- Toggle
local toggle = Instance.new("TextButton", win)
toggle.Size = UDim2.new(1, -16, 0, 34)
toggle.Position = UDim2.new(0, 8, 0, 36)
toggle.Font = Enum.Font.GothamBold
toggle.TextColor3 = Color3.fromRGB(255,255,255)
toggle.TextScaled = true
toggle.BackgroundColor3 = Color3.fromRGB(150,0,0)
toggle.Text = "Activar"
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,10)

-- Slider (16–100)
local slider = Instance.new("Frame", win)
slider.Size = UDim2.new(1, -16, 0, 18)
slider.Position = UDim2.new(0, 8, 0, 78)
slider.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", slider).CornerRadius = UDim.new(0,8)
local fill = Instance.new("Frame", slider)
fill.Size = UDim2.new(0.25, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(0,200,100)
Instance.new("UICorner", fill).CornerRadius = UDim.new(0,8)

local label = Instance.new("TextLabel", win)
label.Size = UDim2.new(1, -16, 0, 18)
label.Position = UDim2.new(0, 8, 0, 100)
label.BackgroundTransparency = 1
label.Font = Enum.Font.Gotham
label.TextSize = 14
label.Text = "Velocidad: 36"
label.TextColor3 = Color3.fromRGB(255,255,255)

local enabled = false
local speed = 36

local function setSpeed(v)
    speed = math.clamp(math.floor(v), 16, 100)
    label.Text = "Velocidad: "..speed
    if enabled then
        local ch = LP.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = speed end
    end
end

-- Slider input (toque o mouse)
slider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local moveConn; local upConn
        local function update(i)
            local rel = math.clamp((i.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            setSpeed(16 + rel*(100-16))
        end
        moveConn = UIS.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                update(i)
            end
        end)
        upConn = UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                if moveConn then moveConn:Disconnect() end
                if upConn then upConn:Disconnect() end
            end
        end)
        update(input)
    end
end)

-- Toggle logic
local function apply(on)
    enabled = on
    if on then
        toggle.Text = "ON"
        toggle.BackgroundColor3 = Color3.fromRGB(0,200,0)
        local ch = LP.Character or LP.CharacterAdded:Wait()
        local hum = ch:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = speed end
    else
        toggle.Text = "Activar"
        toggle.BackgroundColor3 = Color3.fromRGB(150,0,0)
        local ch = LP.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end
toggle.MouseButton1Click:Connect(function() apply(not enabled) end)

-- Mostrar/ocultar con el botón flotante
t.MouseButton1Click:Connect(function() win.Visible = not win.Visible end)
