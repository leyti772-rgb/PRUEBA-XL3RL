--[[
    SCRIPT: Speed Hub (Versión Robusta y Compatible)
    AUTOR: Gemini
    DESCRIPCIÓN: Un script de velocidad reconstruido desde cero para máxima compatibilidad,
                 especialmente en ejecutores de Android como Delta.
                 - Lógica de velocidad persistente y a prueba de fallos.
                 - Interfaz simplificada con botones +/- para evitar errores táctiles.
                 - Icono y menú arrastrables.
]]

-- =========================================================================================
--                                   1. CONFIGURACIÓN
-- =========================================================================================
local Config = {
    DefaultSpeed = 16,  -- Velocidad normal de Roblox
    MaxSpeed = 500,     -- Velocidad máxima que puedes alcanzar
    SpeedIncrement = 10 -- Cuánto aumenta/disminuye la velocidad con cada clic
}

local speedEnabled = false
local currentSpeed = 60 -- Empezar con una velocidad decente
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- =========================================================================================
--                                   2. MOTOR DE VELOCIDAD
-- =========================================================================================
local function getHumanoid()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        return humanoid
    end
    return nil
end

-- Este bucle es el corazón del script. Se asegura de que la velocidad siempre esté aplicada.
task.spawn(function()
    while task.wait(0.5) do
        if speedEnabled then
            local humanoid = getHumanoid()
            if humanoid and humanoid.WalkSpeed ~= currentSpeed then
                humanoid.WalkSpeed = currentSpeed
            end
        end
    end
end)

local function setSpeed(speed)
    currentSpeed = math.clamp(speed, Config.DefaultSpeed, Config.MaxSpeed)
    local humanoid = getHumanoid()
    if humanoid and speedEnabled then
        humanoid.WalkSpeed = currentSpeed
    end
end

local function resetSpeed()
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.WalkSpeed = Config.DefaultSpeed
    end
end

-- =========================================================================================
--                                   3. CREACIÓN DE LA INTERFAZ
-- =========================================================================================
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("SpeedHubGemini") then
        LocalPlayer.PlayerGui.SpeedHubGemini:Destroy()
    end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedHubGemini"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Función para hacer elementos arrastrables
local function makeDraggable(frame, trigger)
    local isDragging = false
    local startPos, dragStart
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging, startPos, dragStart = true, frame.Position, input.Position
            local conn
            conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then isDragging, conn = false, conn:Disconnect() end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            frame.Position = UDim2.fromOffset(startPos.X.Offset + (input.Position.X - dragStart.X), startPos.Y.Offset + (input.Position.Y - dragStart.Y))
        end
    end)
end

-- Icono para abrir el menú
local openIcon = Instance.new("ImageButton", screenGui)
openIcon.Size = UDim2.new(0, 50, 0, 50)
openIcon.Position = UDim2.new(0, 20, 0.5, -25)
openIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
openIcon.Image = "rbxassetid://6034849723"
openIcon.ImageColor3 = Color3.fromRGB(0, 255, 0)
Instance.new("UICorner", openIcon).CornerRadius = UDim.new(1, 0)

-- Menú principal
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 220, 0, 130)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -65)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
mainFrame.BorderSizePixel = 1
mainFrame.Visible = false
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Control de Velocidad"
title.Font = Enum.Font.Code
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1

local speedDisplay = Instance.new("TextLabel", mainFrame)
speedDisplay.Size = UDim2.new(0.5, 0, 0, 40)
speedDisplay.Position = UDim2.new(0.25, 0, 0, 35)
speedDisplay.Font = Enum.Font.Code
speedDisplay.TextSize = 24
speedDisplay.TextColor3 = Color3.fromRGB(0, 255, 0)
speedDisplay.Text = tostring(currentSpeed)
speedDisplay.BackgroundTransparency = 1

local plusButton = Instance.new("TextButton", mainFrame)
plusButton.Size = UDim2.new(0, 40, 0, 40)
plusButton.Position = UDim2.new(0.75, -20, 0, 35)
plusButton.Text = "+"
plusButton.Font = Enum.Font.Code
plusButton.TextSize = 30
plusButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
plusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", plusButton).CornerRadius = UDim.new(0, 6)

local minusButton = Instance.new("TextButton", mainFrame)
minusButton.Size = UDim2.new(0, 40, 0, 40)
minusButton.Position = UDim2.new(0.25, -20, 0, 35)
minusButton.Text = "-"
minusButton.Font = Enum.Font.Code
minusButton.TextSize = 30
minusButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
minusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", minusButton).CornerRadius = UDim.new(0, 6)

local toggleButton = Instance.new("TextButton", mainFrame)
toggleButton.Size = UDim2.new(1, -20, 0, 35)
toggleButton.Position = UDim2.new(0, 10, 0, 85)
toggleButton.Text = "Desactivado"
toggleButton.Font = Enum.Font.Code
toggleButton.TextSize = 16
toggleButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 6)

-- =========================================================================================
--                                   4. EVENTOS DE LA INTERFAZ
-- =========================================================================================
makeDraggable(openIcon, openIcon)
makeDraggable(mainFrame, title)

openIcon.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

plusButton.MouseButton1Click:Connect(function()
    setSpeed(currentSpeed + Config.SpeedIncrement)
    speedDisplay.Text = tostring(currentSpeed)
end)

minusButton.MouseButton1Click:Connect(function()
    setSpeed(currentSpeed - Config.SpeedIncrement)
    speedDisplay.Text = tostring(currentSpeed)
end)

toggleButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        toggleButton.Text = "Activado"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        setSpeed(currentSpeed) -- Aplicar velocidad al activar
    else
        toggleButton.Text = "Desactivado"
        toggleButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        resetSpeed() -- Resetear velocidad al desactivar
    end
end)

-- Asegurarse de que la velocidad se aplique al reaparecer
LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    if speedEnabled then
        humanoid.WalkSpeed = currentSpeed
    end
end)
