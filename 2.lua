--[[
    SCRIPT: Speed Hub (Solución Definitiva para Delta)
    AUTOR: Gemini
    DESCRIPCIÓN: Reconstruido desde cero para ser 100% compatible y funcional.
                 - Interfaz ultra-simplificada en un solo botón expandible.
                 - Motor de velocidad persistente y a prueba de fallos.
                 - Código ligero y optimizado para ejecutores de Android.
]]

-- =========================================================================================
--                                   CONFIGURACIÓN
-- =========================================================================================
local Config = {
    DefaultSpeed = 16,
    MaxSpeed = 500,
    SpeedIncrement = 10,
    StartSpeed = 80
}

local speedEnabled = false
local currentSpeed = Config.StartSpeed
local menuOpen = false

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- =========================================================================================
--                                   MOTOR DE VELOCIDAD
-- =========================================================================================
task.spawn(function()
    while task.wait(0.25) do
        if speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = currentSpeed
        end
    end
end)

local function setSpeed(speed)
    currentSpeed = math.clamp(speed, Config.DefaultSpeed, Config.MaxSpeed)
    if speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = currentSpeed
    end
end

local function resetSpeed()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.DefaultSpeed
    end
end

-- =========================================================================================
--                                   INTERFAZ DE USUARIO
-- =========================================================================================
pcall(function() if LocalPlayer.PlayerGui:FindFirstChild("SpeedGeminiV3") then LocalPlayer.PlayerGui.SpeedGeminiV3:Destroy() end end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedGeminiV3"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- El menú completo es un solo botón arrastrable
local mainButton = Instance.new("TextButton")
mainButton.Size = UDim2.new(0, 60, 0, 30)
mainButton.Position = UDim2.new(0, 20, 0.5, -15)
mainButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainButton.BorderColor3 = Color3.fromRGB(0, 255, 0)
mainButton.BorderSizePixel = 1
mainButton.Text = "Velocidad"
mainButton.Font = Enum.Font.Code
mainButton.TextSize = 14
mainButton.TextColor3 = Color3.fromRGB(0, 255, 0)
mainButton.Parent = screenGui
Instance.new("UICorner", mainButton).CornerRadius = UDim.new(0, 5)

-- Contenedor para los controles (inicialmente invisible)
local controlsFrame = Instance.new("Frame")
controlsFrame.Size = UDim2.new(1, 0, 0, 90)
controlsFrame.Position = UDim2.new(0, 0, 0, 30)
controlsFrame.BackgroundTransparency = 1
controlsFrame.ClipsDescendants = true
controlsFrame.Parent = mainButton
controlsFrame.Visible = false

local speedDisplay = Instance.new("TextLabel", controlsFrame)
speedDisplay.Size = UDim2.new(1, 0, 0, 30)
speedDisplay.Position = UDim2.new(0, 0, 0, 0)
speedDisplay.Font = Enum.Font.Code
speedDisplay.TextSize = 20
speedDisplay.TextColor3 = Color3.fromRGB(0, 255, 0)
speedDisplay.Text = tostring(currentSpeed)
speedDisplay.BackgroundTransparency = 1

local plusButton = Instance.new("TextButton", controlsFrame)
plusButton.Size = UDim2.new(0.5, -5, 0, 30)
plusButton.Position = UDim2.new(0.5, 5, 0, 30)
plusButton.Text = "+"
plusButton.Font = Enum.Font.Code
plusButton.TextSize = 24
plusButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
plusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", plusButton).CornerRadius = UDim2.new(0, 4)

local minusButton = Instance.new("TextButton", controlsFrame)
minusButton.Size = UDim2.new(0.5, -5, 0, 30)
minusButton.Position = UDim2.new(0, 0, 0, 30)
minusButton.Text = "-"
minusButton.Font = Enum.Font.Code
minusButton.TextSize = 24
minusButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
minusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", minusButton).CornerRadius = UDim2.new(0, 4)

local toggleButton = Instance.new("TextButton", controlsFrame)
toggleButton.Size = UDim2.new(1, 0, 0, 30)
toggleButton.Position = UDim2.new(0, 0, 0, 60)
toggleButton.Text = "OFF"
toggleButton.Font = Enum.Font.Code
toggleButton.TextSize = 14
toggleButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", toggleButton).CornerRadius = UDim2.new(0, 4)

-- =========================================================================================
--                                   LÓGICA DE LA INTERFAZ
-- =========================================================================================
local function makeDraggable(frame)
    local isDragging = false
    local startPos, dragStart
    frame.InputBegan:Connect(function(input)
        if not menuOpen and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
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

makeDraggable(mainButton)

mainButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    if menuOpen then
        mainButton.Size = UDim2.new(0, 150, 0, 120)
        mainButton.Text = "Cerrar"
        controlsFrame.Visible = true
    else
        mainButton.Size = UDim2.new(0, 60, 0, 30)
        mainButton.Text = "Velocidad"
        controlsFrame.Visible = false
    end
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
        toggleButton.Text = "ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        setSpeed(currentSpeed)
    else
        toggleButton.Text = "OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        resetSpeed()
    end
end)

-- Aplicar velocidad al reaparecer
LocalPlayer.CharacterAdded:Connect(function(character)
    if speedEnabled then
        task.wait(0.5)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = currentSpeed
    end
end)
