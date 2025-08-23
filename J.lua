--[[
    SCRIPT: Speed Hub Sencillo
    AUTOR: Gemini
    DESCRIPCIÓN: Un script de velocidad simple y efectivo con una interfaz limpia,
                 ideal para ejecutores en Android como Delta.
                 - Icono y menú arrastrables.
                 - Deslizador para ajustar la velocidad.
                 - Botón para activar/desactivar.
]]

-- =========================================================================================
--                                   1. SERVICIOS Y JUGADOR
-- =========================================================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- =========================================================================================
--                                   2. CONFIGURACIÓN Y VARIABLES
-- =========================================================================================
local Config = {
    MainColor = Color3.fromRGB(0, 255, 150),      -- Verde Neón
    BackgroundColor = Color3.fromRGB(25, 27, 35), -- Fondo Oscuro
    TextColor = Color3.fromRGB(255, 255, 255),
    DefaultSpeed = 16, -- Velocidad normal de Roblox
    MaxSpeed = 300     -- Velocidad máxima en el deslizador
}

local speedEnabled = false
local currentSpeed = Config.DefaultSpeed
local speedConnection = nil

-- =========================================================================================
--                                   3. FUNCIONES PRINCIPALES
-- =========================================================================================

-- Función para aplicar la velocidad
local function applySpeed()
    if speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = currentSpeed
    end
end

-- Función para activar el modificador de velocidad
local function enableSpeedModifier()
    if speedConnection then speedConnection:Disconnect() end
    speedConnection = RunService.RenderStepped:Connect(applySpeed)
end

-- Función para desactivar el modificador de velocidad
local function disableSpeedModifier()
    if speedConnection then
        speedConnection:Disconnect()
        speedConnection = nil
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.DefaultSpeed
    end
end

-- Función para hacer un elemento arrastrable
local function makeDraggable(frame, trigger)
    local isDragging = false
    local startPos, dragStart
    
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            startPos = frame.Position
            dragStart = input.Position
            
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                    connection:Disconnect()
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.fromOffset(startPos.X.Offset + delta.X, startPos.Y.Offset + delta.Y)
        end
    end)
end


-- =========================================================================================
--                                   4. CREACIÓN DE LA INTERFAZ
-- =========================================================================================
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("SpeedGUI") then
        LocalPlayer.PlayerGui.SpeedGUI:Destroy()
    end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedGUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Icono para abrir el menú
local openIcon = Instance.new("ImageButton")
openIcon.Name = "OpenIcon"
openIcon.Size = UDim2.new(0, 50, 0, 50)
openIcon.Position = UDim2.new(0, 20, 0.5, -25)
openIcon.BackgroundColor3 = Config.BackgroundColor
openIcon.BackgroundTransparency = 0.2
openIcon.Image = "rbxassetid://6034849723" -- Icono de correr
openIcon.ImageColor3 = Config.MainColor
openIcon.ScaleType = Enum.ScaleType.Fit
openIcon.Parent = screenGui
Instance.new("UICorner", openIcon).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", openIcon).Color = Config.MainColor

-- Menú principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 150)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
mainFrame.BackgroundColor3 = Config.BackgroundColor
mainFrame.Visible = false
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", mainFrame).Color = Config.MainColor

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "Menú de Velocidad"
title.Font = Enum.Font.Code
title.TextSize = 18
title.TextColor3 = Config.TextColor
title.BackgroundTransparency = 1

local speedLabel = Instance.new("TextLabel", mainFrame)
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 40)
speedLabel.Font = Enum.Font.Code
speedLabel.Text = "Velocidad: " .. currentSpeed
speedLabel.TextSize = 14
speedLabel.TextColor3 = Config.TextColor
speedLabel.BackgroundTransparency = 1
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Deslizador (Slider)
local sliderFrame = Instance.new("Frame", mainFrame)
sliderFrame.Size = UDim2.new(1, -20, 0, 10)
sliderFrame.Position = UDim2.new(0, 10, 0, 70)
sliderFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", sliderFrame)

local sliderBar = Instance.new("Frame", sliderFrame)
sliderBar.Size = UDim2.new(0, 0, 1, 0) -- Inicia en 0
sliderBar.BackgroundColor3 = Config.MainColor
Instance.new("UICorner", sliderBar)

local sliderHandle = Instance.new("TextButton", sliderFrame)
sliderHandle.Size = UDim2.new(0, 20, 0, 20)
sliderHandle.Position = UDim2.new(0, -10, 0.5, -10) -- Inicia a la izquierda
sliderHandle.BackgroundColor3 = Config.TextColor
sliderHandle.Text = ""
sliderHandle.Draggable = true
Instance.new("UICorner", sliderHandle).CornerRadius = UDim.new(1, 0)

-- Botón de activar/desactivar
local toggleButton = Instance.new("TextButton", mainFrame)
toggleButton.Size = UDim2.new(1, -20, 0, 35)
toggleButton.Position = UDim2.new(0, 10, 0, 100)
toggleButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
toggleButton.Text = "Desactivado"
toggleButton.Font = Enum.Font.Code
toggleButton.TextSize = 16
toggleButton.TextColor3 = Config.TextColor
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 6)

-- =========================================================================================
--                                   5. LÓGICA DE LA INTERFAZ
-- =========================================================================================
makeDraggable(openIcon, openIcon)
makeDraggable(mainFrame, title)

openIcon.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

toggleButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        toggleButton.Text = "Activado"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        enableSpeedModifier()
    else
        toggleButton.Text = "Desactivado"
        toggleButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        disableSpeedModifier()
    end
end)

-- Lógica del deslizador
local function updateSlider(input)
    local frameWidth = sliderFrame.AbsoluteSize.X
    local mouseX = input.Position.X - sliderFrame.AbsolutePosition.X
    local percentage = math.clamp(mouseX / frameWidth, 0, 1)
    
    currentSpeed = math.floor(Config.DefaultSpeed + (Config.MaxSpeed - Config.DefaultSpeed) * percentage)
    speedLabel.Text = "Velocidad: " .. currentSpeed
    
    sliderHandle.Position = UDim2.new(percentage, -sliderHandle.AbsoluteSize.X / 2, 0.5, -10)
    sliderBar.Size = UDim2.new(percentage, 0, 1, 0)
    
    applySpeed()
end

sliderHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        updateSlider(input)
        local moveConn, releaseConn
        moveConn = UserInputService.InputChanged:Connect(function(moveInput)
            if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then
                updateSlider(moveInput)
            end
        end)
        releaseConn = UserInputService.InputEnded:Connect(function(endInput)
            if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
                moveConn:Disconnect()
                releaseConn:Disconnect()
            end
        end)
    end
end)

-- Asegurarse de que la velocidad se aplique al reaparecer
LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.5) -- Espera a que el humanoide cargue
    applySpeed()
end)
