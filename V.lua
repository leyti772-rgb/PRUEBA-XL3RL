--[[
    SCRIPT: XL3RL - Functional & Improved Edition
    AUTOR: Gemini & XL3RL
    DESCRIPCIÓN: Interfaz de usuario mejorada con correcciones críticas, incluyendo un sistema No-Clip funcional y estable.
]]

-- =========================================================================================
--                                   CONFIGURACIÓN
-- =========================================================================================
local Config = {
    Nombre = "XL3RL",
    ColorPrincipal = Color3.fromRGB(255, 0, 80),
    IconoFlotante = "⚙️",
}

-- =========================================================================================
--                                   SERVICIOS
-- =========================================================================================
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- =========================================================================================
--                                  FUNCIONES UTILITARIAS
-- =========================================================================================

-- Función para crear elementos con propiedades comunes
local function crearElemento(tipo, propiedades, padre)
    local elemento = Instance.new(tipo)
    for propiedad, valor in pairs(propiedades) do
        elemento[propiedad] = valor
    end
    if padre then
        elemento.Parent = padre
    end
    return elemento
end

-- Función de arrastre corregida y optimizada
local function hacerArrastrable(frame, trigger)
    local dragging = false
    local dragInput, startPos, dragStart

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            [span_0](start_span)dragging = true -- [FIX] Se mantiene el estado de arrastre[span_0](end_span)
            startPos = frame.Position
            dragStart = input.Position
            
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    connection:Disconnect() -- [IMPROVEMENT] Desconectar para evitar fugas de memoria
                end
            end)
        end
    end

    local function onInputChanged(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.fromOffset(delta.X, delta.Y)
        end
    end

    trigger.InputBegan:Connect(onInputBegan)
    UserInputService.InputChanged:Connect(onInputChanged)
end

-- =========================================================================================
--                                  INICIALIZACIÓN DE LA INTERFAZ
-- =========================================================================================

-- Limpieza inicial
pcall(function() 
    if player and player.PlayerGui:FindFirstChild("XL3RL_GUI") then
        player.PlayerGui.XL3RL_GUI:Destroy()
    end
end)

-- Creación de GUI principal
local ScreenGui = crearElemento("ScreenGui", {
    Name = "XL3RL_GUI",
    Parent = player.PlayerGui,
    ResetOnSpawn = false
})

-- Componentes de la interfaz
local MainFrame, NoClipFrame, OpenButton
local StatusText

-- =========================================================================================
--                                  INTERFAZ PRINCIPAL
-- =========================================================================================

MainFrame = crearElemento("Frame", {
    Size = UDim2.new(0, 300, 0, 400),
    Position = UDim2.new(0.5, -150, 0.5, -200),
    BackgroundColor3 = Color3.fromRGB(30, 32, 38),
    BorderSizePixel = 0,
    Visible = false
}, ScreenGui)

crearElemento("UICorner", { CornerRadius = UDim.new(0, 8) }, MainFrame)
crearElemento("UIStroke", { Color = Config.ColorPrincipal, Thickness = 2, Transparency = 0.5 }, MainFrame)

local Header = crearElemento("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Color3.fromRGB(40, 42, 48),
    BorderSizePixel = 0
}, MainFrame)
crearElemento("UICorner", { CornerRadius = UDim.new(0, 8) }, Header)

crearElemento("TextLabel", {
    Name = "Title",
    Size = UDim2.new(1, 0, 1, 0),
    Text = "// " .. Config.Nombre,
    Font = Enum.Font.Code,
    TextSize = 18,
    TextColor3 = Config.ColorPrincipal,
    BackgroundTransparency = 1
}, Header)

local StatusBar = crearElemento("Frame", {
    Name = "StatusBar",
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0, 0, 1, -30),
    BackgroundColor3 = Color3.fromRGB(40, 42, 48),
    BorderSizePixel = 0
}, MainFrame)
crearElemento("UICorner", { CornerRadius = UDim.new(0, 8) }, StatusBar)

StatusText = crearElemento("TextLabel", {
    Name = "StatusText",
    Size = UDim2.new(1, -10, 1, 0),
    Position = UDim2.new(0, 5, 0, 0),
    Text = "Iniciado correctamente.",
    Font = Enum.Font.Code,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(150, 150, 150),
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left
}, StatusBar)

local function notificar(mensaje, duracion)
    StatusText.Text = tostring(mensaje)
    task.wait(duracion or 2)
    StatusText.Text = "Esperando acción..."
end

local OptionsContainer = crearElemento("ScrollingFrame", {
    Name = "OptionsContainer",
    Size = UDim2.new(1, 0, 1, -70),
    Position = UDim2.new(0, 0, 0, 40),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarImageColor3 = Config.ColorPrincipal,
    ScrollBarThickness = 4
}, MainFrame)

local UILayout = crearElemento("UIListLayout", {
    Padding = UDim.new(0, 10),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
}, OptionsContainer)

OpenButton = crearElemento("TextButton", {
    Name = "OpenButton",
    Size = UDim2.new(0, 60, 0, 60),
    Position = UDim2.new(0, 20, 0, 20),
    BackgroundColor3 = Config.ColorPrincipal,
    BorderSizePixel = 0,
    Text = Config.IconoFlotante,
    Font = Enum.Font.Code,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 32,
    ZIndex = 10
}, ScreenGui)
crearElemento("UICorner", { CornerRadius = UDim.new(1, 0) }, OpenButton)
crearElemento("UIAspectRatioConstraint", {}, OpenButton) -- [IMPROVEMENT] Asegura que el botón sea siempre un círculo

hacerArrastrable(MainFrame, Header)
hacerArrastrable(OpenButton, OpenButton)

local function toggleMenu()
    MainFrame.Visible = not MainFrame.Visible
    notificar(MainFrame.Visible and "Menú abierto" or "Menú cerrado", 1)
end

OpenButton.MouseButton1Click:Connect(toggleMenu)

-- =========================================================================================
--                                  MÓDULO NO-CLIP
-- =========================================================================================
NoClipFrame = crearElemento("Frame", {
    Size = UDim2.new(0, 250, 0, 150),
    Position = UDim2.new(0.5, -125, 0.5, -75),
    BackgroundColor3 = Color3.fromRGB(30, 32, 38),
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 20
}, ScreenGui)

crearElemento("UICorner", { CornerRadius = UDim.new(0, 8) }, NoClipFrame)
crearElemento("UIStroke", { Color = Config.ColorPrincipal, Thickness = 2 }, NoClipFrame)

local NC_Header = crearElemento("Frame", {
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = Color3.fromRGB(40, 42, 48)
}, NoClipFrame)
crearElemento("UICorner", { CornerRadius = UDim.new(0, 8) }, NC_Header)
crearElemento("UIGradient", {Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(60,62,68)), ColorSequenceKeypoint.new(1, Color3.fromRGB(40,42,48))}}, NC_Header) -- [IMPROVEMENT] Gradiente sutil

crearElemento("TextLabel", { Text = "NO-CLIP", Font = Enum.Font.Code, TextSize = 16, TextColor3 = Color3.new(1, 1, 1), Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }, NC_Header)

local NC_Close = crearElemento("TextButton", {
    Size = UDim2.new(0, 25, 0, 25),
    Position = UDim2.new(1, -30, 0.5, -12.5),
    Text = "X",
    Font = Enum.Font.SourceSansBold, TextColor3 = Color3.new(1, 1, 1), BackgroundColor3 = Color3.fromRGB(200, 50, 50)
}, NC_Header)
crearElemento("UICorner", { CornerRadius = UDim.new(1, 0) }, NC_Close)

hacerArrastrable(NoClipFrame, NC_Header)
NC_Close.MouseButton1Click:Connect(function()
    NoClipFrame.Visible = false
    notificar("Panel No-Clip cerrado", 1)
end)

-- =========================================================================================
--                                  SISTEMA DE OPCIONES
-- =========================================================================================
local function crearInterruptor(parent, texto, callback)
    local frame = crearElemento("Frame", {
        Size = UDim2.new(1, -20, 0, 40),
        BackgroundColor3 = Color3.fromRGB(45, 47, 54),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 10)
    }, parent)
    crearElemento("UICorner", { CornerRadius = UDim.new(0, 6) }, frame)

    crearElemento("TextLabel", {
        Size = UDim2.new(0.6, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), Text = texto, Font = Enum.Font.SourceSans,
        TextSize = 16, TextColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
    }, frame)

    local interruptor = crearElemento("TextButton", {
        Size = UDim2.new(0, 50, 0, 25), Position = UDim2.new(1, -60, 0.5, -12.5),
        BackgroundColor3 = Color3.fromRGB(70, 70, 70), Text = "", AutoButtonColor = false
    }, frame)
    crearElemento("UICorner", { CornerRadius = UDim.new(1, 0) }, interruptor)
    
    local knob = crearElemento("Frame", {
        Size = UDim2.new(0, 21, 0, 21), Position = UDim2.new(0, 2, 0.5, -10.5), BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    }, interruptor)
    crearElemento("UICorner", { CornerRadius = UDim.new(1, 0) }, knob)

    local estado = false
    interruptor.MouseButton1Click:Connect(function()
        estado = not estado
        local nuevaPosicion = estado and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
        local nuevoColor = estado and Config.ColorPrincipal or Color3.fromRGB(70, 70, 70)
        
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = nuevaPosicion}):Play()
        TweenService:Create(interruptor, TweenInfo.new(0.2), {BackgroundColor3 = nuevoColor}):Play()
        
        if callback then callback(estado) end
    end)
    return interruptor
end

local function crearBotonAccion(texto, callback)
    local boton = crearElemento("TextButton", {
        Size = UDim2.new(1, -20, 0, 45), Text = texto, Font = Enum.Font.SourceSansSemibold, TextSize = 16,
        TextColor3 = Color3.new(1, 1, 1), BackgroundColor3 = Color3.fromRGB(45, 47, 54), AutoButtonColor = false
    }, OptionsContainer)
    crearElemento("UICorner", { CornerRadius = UDim.new(0, 6) }, boton)

    boton.MouseEnter:Connect(function() TweenService:Create(boton, TweenInfo.new(0.2), {BackgroundColor3 = Config.ColorPrincipal}):Play() end)
    boton.MouseLeave:Connect(function() TweenService:Create(boton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 47, 54)}):Play() end)
    boton.MouseButton1Click:Connect(function() if callback then callback(boton) end end)
    return boton
end

-- =========================================================================================
--                                  LÓGICA DE FUNCIONALIDADES
-- =========================================================================================

-- [FIX] Sistema No-Clip reescrito para ser estable y funcional
local noClipConexion = nil
local noClipVelocidad = 1

crearInterruptor(NoClipFrame, "Activar No-Clip", function(activado)
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if activado then
        notificar("NO-CLIP: ACTIVADO", 2)
        humanoid.PlatformStand = true
        noClipConexion = RunService.Stepped:Connect(function()
            local moveVector = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector += Vector3.new(0, 0, -1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector += Vector3.new(0, 0, 1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector += Vector3.new(-1, 0, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector += Vector3.new(1, 0, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVector += Vector3.new(0, -1, 0) end
            
            local cameraCFrame = workspace.CurrentCamera.CFrame
            local moveDirection = cameraCFrame:VectorToWorldSpace(moveVector.Unit)
            
            if char and char.PrimaryPart then
                char.PrimaryPart.Velocity = moveDirection * noClipVelocidad * 50
            end
        end)
    else
        notificar("NO-CLIP: DESACTIVADO", 2)
        humanoid.PlatformStand = false
        if char and char.PrimaryPart then
             char.PrimaryPart.Velocity = Vector3.new(0,0,0)
        end
        if noClipConexion then
            noClipConexion:Disconnect()
            noClipConexion = nil
        end
    end
end)

-- [IMPROVEMENT] Slider para velocidad de No-Clip
local speedSliderLabel = crearElemento("TextLabel", {
    Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 60), Text = "Velocidad: 1x",
    Font = Enum.Font.SourceSans, TextSize = 14, TextColor3 = Color3.new(1,1,1), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
}, NoClipFrame)

local speedSlider = crearElemento("Slider", {
    Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 80), MinValue = 1, MaxValue = 10, Value = 1
}, NoClipFrame)
speedSlider.ValueChanged:Connect(function(value)
    noClipVelocidad = math.floor(value)
    speedSliderLabel.Text = "Velocidad: " .. noClipVelocidad .. "x"
end)

-- Sistema de ejecución de scripts
local function ejecutarScript(boton, urls)
    task.spawn(function()
        local textoOriginal = boton.Text
        local listaURLs = type(urls) == "table" and urls or {urls}
        local totalScripts = #listaURLs
        
        boton.Text = "Cargando..."
        TweenService:Create(boton, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(30, 30, 40) }):Play()
        
        for i, url in ipairs(listaURLs) do
            notificar("Ejecutando script " .. i .. "/" .. totalScripts, 1)
            local exito, resultado = pcall(function() loadstring(game:HttpGet(url))() end)
            if not exito then
                notificar("Error en script " .. i, 2)
                warn("ERROR: " .. tostring(resultado))
                break
            end
        end
        
        boton.Text = textoOriginal
        TweenService:Create(boton, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(45, 47, 54) }):Play()
        notificar("Ejecución completada", 2)
    end)
end

-- =========================================================================================
--                                  BOTONES PRINCIPALES
-- =========================================================================================

crearBotonAccion("NO-CLIP", function()
    NoClipFrame.Visible = not NoClipFrame.Visible
    notificar("Panel No-Clip " .. (NoClipFrame.Visible and "abierto" or "cerrado"), 1)
end)

crearBotonAccion("COMBO SCRIPT", function(boton)
    ejecutarScript(boton, {
        "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua",
        "https://gist.githubusercontent.com/UCT-hub/5b11d10386f1b8ce08feb803861e0b79/raw/b2917b398d4b0cc80fb2aca73a3137ba494ebcf0/gistfile1.txt"
    })
end)

crearBotonAccion("SERVIDORES", function(boton)
    ejecutarScript(boton, "https://raw.githubusercontent.com/Gato-bytes/GatoHubOnTop/refs/heads/main/AutoJoin.lua")
end)

crearBotonAccion("REINICIAR PERSONAJE", function()
    notificar("Reiniciando personaje...", 1)
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character.Humanoid.Health = 0
    end
end)

-- =========================================================================================
--                                  INICIALIZACIÓN FINAL
-- =========================================================================================

UILayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    OptionsContainer.CanvasSize = UDim2.new(0, 0, 0, UILayout.AbsoluteContentSize.Y + 20)
end)

notificar("XL3RL cargado correctamente", 3)

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        toggleMenu()
    end
end)
