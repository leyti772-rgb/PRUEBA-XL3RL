--[[
    SCRIPT: XL3RL - Edición Modular Refactorizada
    AUTOR: Gemini & XL3RL
    VERSIÓN: 3.0
    DESCRIPCIÓN: Una versión completamente reescrita del script original, enfocada en la 
                 legibilidad, mantenibilidad y una experiencia de usuario mejorada.
                 Incluye una interfaz de usuario rediseñada y un código más limpio.
]]

-- =========================================================================================
--                                   CONFIGURACIÓN GLOBAL
-- =========================================================================================

local CONFIG = {
    ScriptNombre = "XL3RL",
    ColorPrincipal = Color3.fromRGB(255, 0, 80), -- Un rosa neón vibrante.
    ColorSecundario = Color3.fromRGB(45, 47, 54),
    ColorTerciario = Color3.fromRGB(30, 32, 38),
    ColorTexto = Color3.fromRGB(255, 255, 255),
    FuenteUI = Enum.Font.Code,
    IconoFlotante = "⊕",
    AnimacionVelocidad = 0.2
}

-- =========================================================================================
--                                    SERVICIOS DE ROBLOX
-- =========================================================================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- =========================================================================================
--                                    VARIABLES LOCALES
-- =========================================================================================

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local noClipConnection = nil

-- Limpieza de versiones anteriores de la GUI.
pcall(function()
    playerGui.XL3RL_GUI:Destroy()
end)

-- =========================================================================================
--                                   GUI PRINCIPAL
-- =========================================================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XL3RL_GUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- =========================================================================================
--                                    FUNCIONES DE AYUDA
-- =========================================================================================

--[[
    Función: hacerArrastrable
    Propósito: Permite que un objeto de la GUI sea arrastrado por el usuario.
    Parámetros:
        - frame: El objeto de la GUI que se hará arrastrable.
        - trigger: El objeto de la GUI que activará el arrastre (ej. una barra de título).
]]
local function hacerArrastrable(frame, trigger)
    local dragging = false
    local dragInput, startPos, dragStart

    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = frame.Position
            dragStart = input.Position
            
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    connection:Disconnect()
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
            local newPos = startPos + UDim2.fromOffset(input.Position.X - dragStart.X, input.Position.Y - dragStart.Y)
            frame.Position = newPos
        end
    end)
end

--[[
    Función: crearEfectoHover
    Propósito: Añade un efecto visual cuando el ratón pasa sobre un botón.
    Parámetros:
        - button: El botón al que se le aplicará el efecto.
        - hoverColor: El color que tomará el botón al pasar el ratón por encima.
        - defaultColor: El color original del botón.
]]
local function crearEfectoHover(button, hoverColor, defaultColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(CONFIG.AnimacionVelocidad), {BackgroundColor3 = hoverColor}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(CONFIG.AnimacionVelocidad), {BackgroundColor3 = defaultColor}):Play()
    end)
end

-- =========================================================================================
--                                  CREACIÓN DE LA INTERFAZ
-- =========================================================================================

-- Contenedor principal de la ventana.
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 320)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -160)
mainFrame.BackgroundColor3 = CONFIG.ColorTerciario
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = CONFIG.ColorPrincipal
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.4

-- Barra de título
local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(40, 42, 48)
header.BorderSizePixel = 0
local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -10, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "// " .. CONFIG.ScriptNombre
title.Font = CONFIG.FuenteUI
title.TextSize = 20
title.TextColor3 = CONFIG.ColorPrincipal
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

hacerArrastrable(mainFrame, header)

-- Contenedor para los botones y opciones.
local optionsContainer = Instance.new("ScrollingFrame", mainFrame)
optionsContainer.Size = UDim2.new(1, 0, 1, -50)
optionsContainer.Position = UDim2.new(0, 0, 0, 40)
optionsContainer.BackgroundTransparency = 1
optionsContainer.BorderSizePixel = 0
optionsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
optionsContainer.ScrollBarImageColor3 = CONFIG.ColorPrincipal
optionsContainer.ScrollBarThickness = 4

local uiLayout = Instance.new("UIListLayout", optionsContainer)
uiLayout.Padding = UDim.new(0, 10)
uiLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiLayout.FillDirection = Enum.FillDirection.Vertical

-- Barra de estado inferior.
local statusBar = Instance.new("Frame", mainFrame)
statusBar.Size = UDim2.new(1, 0, 0, 25)
statusBar.Position = UDim2.new(0, 0, 1, 0)
statusBar.BackgroundColor3 = header.BackgroundColor3
statusBar.BorderSizePixel = 0
statusBar.ZIndex = 2
local statusCorner = Instance.new("UICorner", statusBar)
statusCorner.CornerRadius = UDim.new(0, 8)

local statusText = Instance.new("TextLabel", statusBar)
statusText.Size = UDim2.new(1, -20, 1, 0)
statusText.Position = UDim2.new(0.5, -((280-20)/2), 0, 0)
statusText.Text = "Inicializado."
statusText.Font = CONFIG.FuenteUI
statusText.TextSize = 14
statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
statusText.BackgroundTransparency = 1

-- Función para mostrar notificaciones en la barra de estado.
local function notify(message, duration)
    statusText.Text = tostring(message)
    if duration then
        wait(duration)
        statusText.Text = "Esperando acción..."
    end
end

-- Botón flotante para abrir/cerrar el menú.
local openButton = Instance.new("TextButton", screenGui)
openButton.Size = UDim2.new(0, 50, 0, 50)
openButton.Position = UDim2.new(0, 15, 1, -65)
openButton.BackgroundColor3 = CONFIG.ColorPrincipal
openButton.BorderSizePixel = 0
openButton.Text = CONFIG.IconoFlotante
openButton.Font = Enum.Font.SourceSansBold
openButton.TextColor3 = CONFIG.ColorTerciario
openButton.TextSize = 32
Instance.new("UICorner", openButton).CornerRadius = UDim.new(1, 0)

hacerArrastrable(openButton, openButton)

openButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then
        notify("Menú abierto.", 2)
    end
end)

-- =========================================================================================
--                                  CREADORES DE ELEMENTOS UI
-- =========================================================================================

--[[
    Función: crearBotonAccion
    Propósito: Crea un botón estándar para el menú.
    Parámetros:
        - text: El texto que se mostrará en el botón.
        - callback: La función que se ejecutará al hacer clic.
    Retorna:
        - El objeto TextButton creado.
]]
local function crearBotonAccion(text, callback)
    local button = Instance.new("TextButton", optionsContainer)
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Text = text
    button.Font = Enum.Font.SourceSansSemibold
    button.TextSize = 16
    button.TextColor3 = CONFIG.ColorTexto
    button.BackgroundColor3 = CONFIG.ColorSecundario
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
    
    crearEfectoHover(button, CONFIG.ColorPrincipal, CONFIG.ColorSecundario)
    
    button.MouseButton1Click:Connect(function()
        callback(button)
    end)
    
    return button
end

--[[
    Función: crearInterruptor
    Propósito: Crea un interruptor (toggle switch).
    Parámetros:
        - parent: El objeto de la GUI donde se creará el interruptor.
        - text: La etiqueta de texto para el interruptor.
        - callback: La función que se ejecutará cuando cambie el estado.
]]
local function crearInterruptor(parent, text, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.BackgroundColor3 = CONFIG.ColorSecundario
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = text
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextColor3 = CONFIG.ColorTexto
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    local switch = Instance.new("TextButton", frame)
    switch.Size = UDim2.new(0, 50, 0, 24)
    switch.Position = UDim2.new(1, -60, 0.5, -12)
    switch.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    switch.Text = ""
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", switch)
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = UDim2.new(0, 2, 0.5, -10)
    knob.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local state = false
    switch.MouseButton1Click:Connect(function()
        state = not state
        local goalPos = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        local goalColor = state and CONFIG.ColorPrincipal or Color3.fromRGB(70, 70, 70)
        
        TweenService:Create(knob, TweenInfo.new(CONFIG.AnimacionVelocidad), {Position = goalPos}):Play()
        TweenService:Create(switch, TweenInfo.new(CONFIG.AnimacionVelocidad), {BackgroundColor3 = goalColor}):Play()
        
        callback(state)
    end)
end

--[[
    Función: crearVentanaEmergente
    Propósito: Crea una nueva ventana que puede ser arrastrada.
    Parámetros:
        - titleText: El texto para la barra de título de la ventana.
    Retorna:
        - El frame principal de la ventana y el contenedor de contenido.
]]
local function crearVentanaEmergente(titleText)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 240, 0, 120)
    frame.Position = UDim2.new(0.5, -120, 0.2, 0)
    frame.BackgroundColor3 = CONFIG.ColorTerciario
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.Parent = screenGui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = CONFIG.ColorPrincipal
    stroke.Thickness = 1

    local header = Instance.new("Frame", frame)
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundColor3 = Color3.fromRGB(40, 42, 48)
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, 0, 1, 0)
    title.Text = titleText
    title.Font = CONFIG.FuenteUI
    title.TextSize = 16
    title.TextColor3 = CONFIG.ColorTexto
    title.BackgroundTransparency = 1

    local closeButton = Instance.new("TextButton", header)
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -25, 0.5, -10)
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.TextColor3 = CONFIG.ColorTexto
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    Instance.new("UICorner", closeButton).CornerRadius = UDim.new(1, 0)
    closeButton.MouseButton1Click:Connect(function()
        frame.Visible = false
    end)
    
    hacerArrastrable(frame, header)
    
    local content = Instance.new("Frame", frame)
    content.Size = UDim2.new(1, 0, 1, -30)
    content.Position = UDim2.new(0, 0, 0, 30)
    content.BackgroundTransparency = 1
    
    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    return frame, content
end

-- =========================================================================================
--                                  LÓGICA DE LAS FUNCIONES
-- =========================================================================================

-- Lógica para No-Clip
local noClipFrame, noClipContent = crearVentanaEmergente("NO-CLIP")
crearInterruptor(noClipContent, "Activar No-Clip", function(activado)
    if activado then
        notify("NO-CLIP: ACTIVADO", 2)
        noClipConnection = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in ipairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        notify("NO-CLIP: DESACTIVADO", 2)
        if noClipConnection then
            noClipConnection:Disconnect()
            noClipConnection = nil
        end
    end
end)

-- Lógica para ejecutar scripts desde URLs.
local function executeScript(button, urls)
    spawn(function()
        local originalText = button.Text
        local urlList = (type(urls) == "table") and urls or {urls}
        local totalScripts = #urlList

        for i, url in ipairs(urlList) do
            notify(string.format("Ejecutando script %d/%d...", i, totalScripts))
            local success, result = pcall(function()
                loadstring(game:HttpGet(url))()
            end)
            if not success then
                notify("¡Error en script " .. i .. "!", 3)
                warn(string.format("ERROR en %s (URL %d): %s", originalText, i, tostring(result)))
                break -- Detiene la ejecución si un script falla.
            end
        end
        notify("Secuencia completada.", 2)
    end)
end

-- =========================================================================================
--                                  DEFINICIÓN DE BOTONES
-- =========================================================================================

crearBotonAccion("No-Clip", function()
    noClipFrame.Visible = not noClipFrame.Visible
    notify("Ventana de No-Clip.", 2)
end)

crearBotonAccion("Combo Script", function(btn)
    executeScript(btn, {
        "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua",
        "https://gist.githubusercontent.com/UCT-hub/5b11d10386f1b8ce08feb803861e0b79/raw/b2917b398d4b0cc80fb2aca73a3137ba494ebcf0/gistfile1.txt"
    })
end)

crearBotonAccion("Servidores", function(btn)
    executeScript(btn, "https://raw.githubusercontent.com/Gato-bytes/GatoHubOnTop/refs/heads/main/AutoJoin.lua")
end)

notify("XL3RL Cargado. ¡Disfruta!", 3)
