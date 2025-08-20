--[[
    SCRIPT: XL3RL - Functional Edition
    AUTOR: Gemini & XL3RL
    DESCRIPCIÓN: Interfaz de usuario funcional con todas las correcciones necesarias
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

-- Función de arrastre corregida
local function hacerArrastrable(frame, trigger)
    local dragging = false
    local dragInput, startPos, dragStart

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = frame.Position
            dragStart = input.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end

    local function onInputChanged(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = startPos + UDim2.fromOffset(delta.X, delta.Y)
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
    if player.PlayerGui:FindFirstChild("XL3RL_GUI") then
        player.PlayerGui.XL3RL_GUI:Destroy()
    end
end)

-- Creación de GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XL3RL_GUI"
ScreenGui.Parent = player.PlayerGui
ScreenGui.ResetOnSpawn = false

-- Componentes de la interfaz
local MainFrame, NoClipFrame, OpenButton
local StatusText

-- =========================================================================================
--                                  INTERFAZ PRINCIPAL
-- =========================================================================================

-- Creación del marco principal
MainFrame = crearElemento("Frame", {
    Size = UDim2.new(0, 300, 0, 400),
    Position = UDim2.new(0.5, -150, 0.5, -200),
    BackgroundColor3 = Color3.fromRGB(30, 32, 38),
    BorderSizePixel = 0,
    Visible = false
}, ScreenGui)

-- Configuración de esquinas y bordes
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Config.ColorPrincipal
UIStroke.Thickness = 2
UIStroke.Transparency = 0.5

-- Creación de la barra de encabezado
local Header = crearElemento("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Color3.fromRGB(40, 42, 48),
    BorderSizePixel = 0
}, MainFrame)

Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local Title = crearElemento("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    Text = "// " .. Config.Nombre,
    Font = Enum.Font.Code,
    TextSize = 18,
    TextColor3 = Config.ColorPrincipal,
    BackgroundTransparency = 1
}, Header)

-- Barra de estado
local StatusBar = crearElemento("Frame", {
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0, 0, 1, -30),
    BackgroundColor3 = Color3.fromRGB(40, 42, 48),
    BorderSizePixel = 0
}, MainFrame)

Instance.new("UICorner", StatusBar).CornerRadius = UDim.new(0, 8)

StatusText = crearElemento("TextLabel", {
    Size = UDim2.new(1, -10, 1, 0),
    Position = UDim2.new(0, 5, 0, 0),
    Text = "Iniciado correctamente.",
    Font = Enum.Font.Code,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(150, 150, 150),
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left
}, StatusBar)

-- Función de notificación
local function notificar(mensaje, duracion)
    StatusText.Text = tostring(mensaje)
    task.wait(duracion or 2)
    StatusText.Text = "Esperando acción..."
end

-- Contenedor de opciones
local OptionsContainer = crearElemento("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, -70),
    Position = UDim2.new(0, 0, 0, 40),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarImageColor3 = Config.ColorPrincipal,
    ScrollBarThickness = 4
}, MainFrame)

local UILayout = Instance.new("UIListLayout", OptionsContainer)
UILayout.Padding = UDim.new(0, 10)
UILayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UILayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Botón de apertura
OpenButton = crearElemento("TextButton", {
    Size = UDim2.new(0, 60, 0, 60),
    Position = UDim2.new(0, 20, 0, 20),
    BackgroundColor3 = Config.ColorPrincipal,
    BorderSizePixel = 0,
    Text = Config.IconoFlotante,
    Font = Enum.Font.SourceSansBold,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 24,
    ZIndex = 10
}, ScreenGui)

Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(1, 0)

-- Aplicar funcionalidad de arrastre
hacerArrastrable(MainFrame, Header)
hacerArrastrable(OpenButton, OpenButton)

-- Función para abrir/cerrar el menú
local function toggleMenu()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        notificar("Menú abierto", 1)
    else
        notificar("Menú cerrado", 1)
    end
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

-- Configuración visual del marco No-Clip
local NC_Corner = Instance.new("UICorner", NoClipFrame)
NC_Corner.CornerRadius = UDim.new(0, 8)

local NC_Stroke = Instance.new("UIStroke", NoClipFrame)
NC_Stroke.Color = Config.ColorPrincipal
NC_Stroke.Thickness = 2

local NC_Header = crearElemento("Frame", {
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = Color3.fromRGB(40, 42, 48)
}, NoClipFrame)

Instance.new("UICorner", NC_Header).CornerRadius = UDim.new(0, 8)

crearElemento("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    Text = "NO-CLIP",
    Font = Enum.Font.Code,
    TextSize = 16,
    TextColor3 = Color3.new(1, 1, 1),
    BackgroundTransparency = 1
}, NC_Header)

local NC_Close = crearElemento("TextButton", {
    Size = UDim2.new(0, 25, 0, 25),
    Position = UDim2.new(1, -30, 0.5, -12.5),
    Text = "X",
    Font = Enum.Font.SourceSansBold,
    TextColor3 = Color3.new(1, 1, 1),
    BackgroundColor3 = Color3.fromRGB(200, 50, 50)
}, NC_Header)

Instance.new("UICorner", NC_Close).CornerRadius = UDim.new(1, 0)

-- Aplicar funcionalidades
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
    
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    crearElemento("TextLabel", {
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Text = texto,
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    }, frame)

    local interruptor = crearElemento("TextButton", {
        Size = UDim2.new(0, 50, 0, 25),
        Position = UDim2.new(1, -60, 0.5, -12.5),
        BackgroundColor3 = Color3.fromRGB(70, 70, 70),
        Text = "",
        AutoButtonColor = false
    }, frame)
    
    Instance.new("UICorner", interruptor).CornerRadius = UDim.new(1, 0)

    local knob = crearElemento("Frame", {
        Size = UDim2.new(0, 21, 0, 21),
        Position = UDim2.new(0, 2, 0.5, -10.5),
        BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    }, interruptor)
    
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local estado = false
    
    interruptor.MouseButton1Click:Connect(function()
        estado = not estado
        
        local nuevaPosicion = estado and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
        local nuevoColor = estado and Config.ColorPrincipal or Color3.fromRGB(70, 70, 70)
        
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = nuevaPosicion}):Play()
        TweenService:Create(interruptor, TweenInfo.new(0.2), {BackgroundColor3 = nuevoColor}):Play()
        
        callback(estado)
    end)
end

local function crearBotonAccion(texto, callback)
    local boton = crearElemento("TextButton", {
        Size = UDim2.new(1, -20, 0, 45),
        Text = texto,
        Font = Enum.Font.SourceSansSemibold,
        TextSize = 16,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundColor3 = Color3.fromRGB(45, 47, 54),
        AutoButtonColor = false
    }, OptionsContainer)
    
    Instance.new("UICorner", boton).CornerRadius = UDim.new(0, 6)

    boton.MouseEnter:Connect(function()
        TweenService:Create(boton, TweenInfo.new(0.2), {BackgroundColor3 = Config.ColorPrincipal}):Play()
    end)

    boton.MouseLeave:Connect(function()
        TweenService:Create(boton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 47, 54)}):Play()
    end)

    boton.MouseButton1Click:Connect(function()
        callback(boton)
    end)
    
    return boton
end

-- =========================================================================================
--                                  LÓGICA DE FUNCIONALIDADES
-- =========================================================================================

-- Sistema No-Clip
local conexionNoClip = nil

crearInterruptor(NoClipFrame, "Activar No-Clip", function(activado)
    if activado then
        notificar("NO-CLIP: ACTIVADO", 2)
        conexionNoClip = RunService.Stepped:Connect(function()
            if player.Character then
                for _, parte in ipairs(player.Character:GetDescendants()) do
                    if parte:IsA("BasePart") and parte.CanCollide then
                        parte.CanCollide = false
                    end
                end
            end
        end)
    else
        notificar("NO-CLIP: DESACTIVADO", 2)
        if conexionNoClip then
            conexionNoClip:Disconnect()
            conexionNoClip = nil
        end
    end
end)

-- Sistema de ejecución de scripts
local function ejecutarScript(boton, urls)
    task.spawn(function()
        local textoOriginal = boton.Text
        local listaURLs = type(urls) == "table" and urls or {urls}
        local totalScripts = #listaURLs
        
        boton.Text = "Cargando..."
        TweenService:Create(boton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        }):Play()
        
        for i, url in ipairs(listaURLs) do
            notificar("Ejecutando script " .. i .. " de " .. totalScripts, 1)
            
            local exito, resultado = pcall(function()
                loadstring(game:HttpGet(url))()
            end)
            
            if not exito then
                notificar("Error en script " .. i, 2)
                warn("ERROR: " .. tostring(resultado))
                break
            end
        end
        
        boton.Text = textoOriginal
        TweenService:Create(boton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(45, 47, 54)
        }):Play()
        
        notificar("Ejecución completada", 2)
    end)
end

-- =========================================================================================
--                                  BOTONES PRINCIPALES
-- =========================================================================================

crearBotonAccion("NO-CLIP", function(boton)
    NoClipFrame.Visible = true
    notificar("Panel No-Clip abierto", 1)
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

crearBotonAccion("REINICIAR PERSONAJE", function(boton)
    notificar("Reiniciando personaje...", 1)
    if player.Character then
        player.Character:BreakJoints()
    end
end)

-- =========================================================================================
--                                  INICIALIZACIÓN FINAL
-- =========================================================================================

-- Ajustar el tamaño del canvas
UILayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    OptionsContainer.CanvasSize = UDim2.new(0, 0, 0, UILayout.AbsoluteContentSize.Y + 20)
end)

-- Notificación inicial
notificar("XL3RL cargado correctamente", 3)

-- Atajo de teclado para abrir/cerrar
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        toggleMenu()
    end
end)
