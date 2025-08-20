--[[
    SCRIPT: XL3RL - Modular Edition V2 (Versión Mejorada)
    AUTOR: Gemini & XL3RL
    DESCRIPCIÓN: Interfaz de usuario moderna con funcionalidades mejoradas
                 y sistema de arrastre optimizado.
]]

-- =========================================================================================
--                                   CONFIGURACIÓN
-- =========================================================================================
local Config = {
    Nombre = "XL3RL",
    ColorPrincipal = Color3.fromRGB(255, 0, 80), -- Rosa Neón
    ColorSecundario = Color3.fromRGB(40, 42, 48),
    ColorFondo = Color3.fromRGB(30, 32, 38),
    ColorTexto = Color3.fromRGB(255, 255, 255),
    ColorTextoSecundario = Color3.fromRGB(150, 150, 150),
    IconoFlotante = "⊕",
    RadioEsquinas = 8,
    Transparencia = 0.95
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

-- Función para crear elementos de UI de forma consistente
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

-- Función de arrastre optimizada
local function hacerArrastrable(frame, trigger)
    local dragging = false
    local dragInput, startPos, dragStart

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
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
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch) then
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

-- Limpiar GUI existente
pcall(function() 
    if player.PlayerGui:FindFirstChild("XL3RL_GUI") then
        player.PlayerGui.XL3RL_GUI:Destroy()
    end
end)

-- Crear GUI principal
local ScreenGui = crearElemento("ScreenGui", {
    Name = "XL3RL_GUI",
    ResetOnSpawn = false
}, player.PlayerGui)

-- =========================================================================================
--                                  COMPONENTES PRINCIPALES
-- =========================================================================================

-- Crear marco principal con diseño moderno
local MainFrame = crearElemento("Frame", {
    Size = UDim2.new(0, 300, 0, 400),
    Position = UDim2.new(0.5, -150, 0.5, -200),
    BackgroundColor3 = Config.ColorFondo,
    BackgroundTransparency = 0.1,
    BorderSizePixel = 0,
    Visible = false,
    ClipsDescendants = true
}, ScreenGui)

-- Aplicar efectos visuales al marco principal
crearElemento("UICorner", {
    CornerRadius = UDim.new(0, Config.RadioEsquinas)
}, MainFrame)

crearElemento("UIStroke", {
    Color = Config.ColorPrincipal,
    Thickness = 2,
    Transparency = 0.3
}, MainFrame)

crearElemento("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Config.ColorPrincipal),
        ColorSequenceKeypoint.new(1, Config.ColorSecundario)
    }),
    Rotation = 90,
    Transparency = NumberSequence.new(0.8)
}, MainFrame)

-- Crear barra de encabezado
local Header = crearElemento("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Config.ColorSecundario,
    BorderSizePixel = 0,
    ZIndex = 2
}, MainFrame)

crearElemento("UICorner", {
    CornerRadius = UDim.new(0, Config.RadioEsquinas)
}, Header)

local Title = crearElemento("TextLabel", {
    Size = UDim2.new(1, -40, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    Text = "// " .. Config.Nombre,
    Font = Enum.Font.Code,
    TextSize = 18,
    TextColor3 = Config.ColorPrincipal,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1
}, Header)

-- Botón de cerrar en el encabezado
local CloseButton = crearElemento("TextButton", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -35, 0.5, -15),
    Text = "×",
    Font = Enum.Font.SourceSansBold,
    TextSize = 24,
    TextColor3 = Config.ColorTexto,
    BackgroundColor3 = Color3.fromRGB(200, 50, 50),
    BorderSizePixel = 0
}, Header)

crearElemento("UICorner", {
    CornerRadius = UDim.new(1, 0)
}, CloseButton)

-- Aplicar funcionalidad de arrastre
hacerArrastrable(MainFrame, Header)

-- Barra de búsqueda (nueva característica)
local SearchBox = crearElemento("TextBox", {
    Size = UDim2.new(1, -20, 0, 35),
    Position = UDim2.new(0, 10, 0, 45),
    PlaceholderText = "Buscar función...",
    Font = Enum.Font.SourceSans,
    TextSize = 16,
    TextColor3 = Config.ColorTexto,
    BackgroundColor3 = Config.ColorSecundario,
    BorderSizePixel = 0,
    ClearTextOnFocus = false
}, MainFrame)

crearElemento("UICorner", {
    CornerRadius = UDim.new(0, 6)
}, SearchBox)

crearElemento("UIPadding", {
    PaddingLeft = UDim.new(0, 10)
}, SearchBox)

-- Contenedor de opciones con scroll
local OptionsContainer = crearElemento("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, -120),
    Position = UDim2.new(0, 0, 0, 85),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarImageColor3 = Config.ColorPrincipal,
    ScrollBarThickness = 4,
    ScrollBarImageTransparency = 0.7
}, MainFrame)

local UILayout = crearElemento("UIListLayout", {
    Padding = UDim.new(0, 12),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
}, OptionsContainer)

-- Barra de estado
local StatusBar = crearElemento("Frame", {
    Size = UDim2.new(1, 0, 0, 25),
    Position = UDim2.new(0, 0, 1, -25),
    BackgroundColor3 = Config.ColorSecundario,
    BorderSizePixel = 0,
    ZIndex = 2
}, MainFrame)

crearElemento("UICorner", {
    CornerRadius = UDim.new(0, Config.RadioEsquinas)
}, StatusBar)

local StatusText = crearElemento("TextLabel", {
    Size = UDim2.new(1, -10, 1, 0),
    Position = UDim2.new(0, 5, 0, 0),
    Text = "Iniciado correctamente.",
    Font = Enum.Font.Code,
    TextSize = 14,
    TextColor3 = Config.ColorTextoSecundario,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1
}, StatusBar)

-- Función de notificación mejorada
local function notificar(mensaje, duracion)
    StatusText.Text = tostring(mensaje)
    task.wait(duracion or 2)
    StatusText.Text = "Esperando acción..."
end

-- Botón flotante de apertura con diseño moderno
local OpenButton = crearElemento("TextButton", {
    Size = UDim2.new(0, 60, 0, 60),
    Position = UDim2.new(0, 20, 1, -80),
    BackgroundColor3 = Config.ColorPrincipal,
    BorderSizePixel = 0,
    Text = Config.IconoFlotante,
    Font = Enum.Font.SourceSansBold,
    TextColor3 = Config.ColorTexto,
    TextSize = 32,
    ZIndex = 10
}, ScreenGui)

-- Aplicar efectos al botón flotante
crearElemento("UICorner", {
    CornerRadius = UDim.new(1, 0)
}, OpenButton)

crearElemento("UIStroke", {
    Color = Config.ColorTexto,
    Thickness = 2,
    Transparency = 0.5
}, OpenButton)

-- Sombra del botón (simulada con Frame)
local ButtonShadow = crearElemento("Frame", {
    Size = UDim2.new(1, 4, 1, 4),
    Position = UDim2.new(0, -2, 0, -2),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.8,
    BorderSizePixel = 0,
    ZIndex = 9
}, OpenButton)

crearElemento("UICorner", {
    CornerRadius = UDim.new(1, 0)
}, ButtonShadow)

-- Aplicar funcionalidad de arrastre al botón
hacerArrastrable(OpenButton, OpenButton)

-- =========================================================================================
--                                  MÓDULO NO-CLIP MEJORADO
-- =========================================================================================
local NoClipFrame = crearElemento("Frame", {
    Size = UDim2.new(0, 250, 0, 150),
    Position = UDim2.new(0.5, -125, 0.2, 0),
    BackgroundColor3 = Config.ColorFondo,
    BackgroundTransparency = 0.1,
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 20
}, ScreenGui)

-- Diseño visual del módulo No-Clip
crearElemento("UICorner", {
    CornerRadius = UDim.new(0, Config.RadioEsquinas)
}, NoClipFrame)

crearElemento("UIStroke", {
    Color = Config.ColorPrincipal,
    Thickness = 2
}, NoClipFrame)

local NC_Header = crearElemento("Frame", {
    Size = UDim2.new(1, 0, 0, 35),
    BackgroundColor3 = Config.ColorSecundario,
    BorderSizePixel = 0,
    ZIndex = 21
}, NoClipFrame)

crearElemento("UICorner", {
    CornerRadius = UDim.new(0, Config.RadioEsquinas)
}, NC_Header)

local NC_Title = crearElemento("TextLabel", {
    Size = UDim2.new(1, -40, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    Text = "CONTROL NO-CLIP",
    Font = Enum.Font.Code,
    TextSize = 16,
    TextColor3 = Config.ColorTexto,
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left
}, NC_Header)

local NC_Close = crearElemento("TextButton", {
    Size = UDim2.new(0, 25, 0, 25),
    Position = UDim2.new(1, -30, 0.5, -12.5),
    Text = "×",
    Font = Enum.Font.SourceSansBold,
    TextSize = 20,
    TextColor3 = Config.ColorTexto,
    BackgroundColor3 = Color3.fromRGB(200, 50, 50),
    BorderSizePixel = 0
}, NC_Header)

crearElemento("UICorner", {
    CornerRadius = UDim.new(1, 0)
}, NC_Close)

-- Aplicar funcionalidad de arrastre
hacerArrastrable(NoClipFrame, NC_Header)

-- Contenido del módulo No-Clip
local NC_Content = crearElemento("Frame", {
    Size = UDim2.new(1, -20, 1, -45),
    Position = UDim2.new(0, 10, 0, 40),
    BackgroundTransparency = 1
}, NoClipFrame)

-- =========================================================================================
--                                  SISTEMA DE OPCIONES
-- =========================================================================================

-- Función para crear interruptores con diseño moderno
local function crearInterruptor(parent, texto, callback, tooltip)
    local frame = crearElemento("Frame", {
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = Config.ColorSecundario,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0
    }, parent)
    
    crearElemento("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, frame)
    
    local label = crearElemento("TextLabel", {
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        Text = texto,
        Font = Enum.Font.SourceSansSemibold,
        TextSize = 16,
        TextColor3 = Config.ColorTexto,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    }, frame)
    
    -- Tooltip (nueva característica)
    if tooltip then
        frame.MouseEnter:Connect(function()
            notificar(tooltip, 0)
        end)
    end
    
    local switch = crearElemento("TextButton", {
        Size = UDim2.new(0, 50, 0, 25),
        Position = UDim2.new(1, -60, 0.5, -12.5),
        BackgroundColor3 = Color3.fromRGB(70, 70, 70),
        Text = "",
        AutoButtonColor = false
    }, frame)
    
    crearElemento("UICorner", {
        CornerRadius = UDim.new(1, 0)
    }, switch)
    
    local knob = crearElemento("Frame", {
        Size = UDim2.new(0, 21, 0, 21),
        Position = UDim2.new(0, 2, 0.5, -10.5),
        BackgroundColor3 = Config.ColorTexto,
        BorderSizePixel = 0
    }, switch)
    
    crearElemento("UICorner", {
        CornerRadius = UDim.new(1, 0)
    }, knob)
    
    local estado = false
    
    switch.MouseButton1Click:Connect(function()
        estado = not estado
        
        local nuevaPosicion = estado and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
        local nuevoColor = estado and Config.ColorPrincipal or Color3.fromRGB(70, 70, 70)
        
        TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = nuevaPosicion
        }):Play()
        
        TweenService:Create(switch, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = nuevoColor
        }):Play()
        
        callback(estado)
    end)
    
    return frame
end

-- Función para crear botones de acción con diseño moderno
local function crearBotonAccion(texto, callback, tooltip, colorPersonalizado)
    local boton = crearElemento("TextButton", {
        Size = UDim2.new(1, -20, 0, 45),
        Text = texto,
        Font = Enum.Font.SourceSansSemibold,
        TextSize = 16,
        TextColor3 = Config.ColorTexto,
        BackgroundColor3 = colorPersonalizado or Config.ColorSecundario,
        BackgroundTransparency = 0.5,
        AutoButtonColor = false,
        BorderSizePixel = 0
    }, OptionsContainer)
    
    crearElemento("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, boton)
    
    -- Efectos de hover
    boton.MouseEnter:Connect(function()
        TweenService:Create(boton, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.2,
            BackgroundColor3 = colorPersonalizado or Config.ColorPrincipal
        }):Play()
        
        if tooltip then
            notificar(tooltip, 0)
        end
    end)
    
    boton.MouseLeave:Connect(function()
        TweenService:Create(boton, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.5,
            BackgroundColor3 = colorPersonalizado or Config.ColorSecundario
        }):Play()
    end)
    
    -- Efecto de clic
    boton.MouseButton1Down:Connect(function()
        TweenService:Create(boton, TweenInfo.new(0.1), {
            Size = UDim2.new(1, -25, 0, 40)
        }):Play()
    end)
    
    boton.MouseButton1Up:Connect(function()
        TweenService:Create(boton, TweenInfo.new(0.1), {
            Size = UDim2.new(1, -20, 0, 45)
        }):Play()
    end)
    
    boton.MouseButton1Click:Connect(function()
        callback(boton)
    end)
    
    return boton
end

-- =========================================================================================
--                                  LÓGICA DE FUNCIONALIDADES
-- =========================================================================================

-- Sistema No-Clip mejorado
local conexionNoClip = nil
local velocidadNoClip = 1

crearInterruptor(NC_Content, "Activar No-Clip", function(activado)
    if activado then
        notificar("NO-CLIP: ACTIVADO")
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
        notificar("NO-CLIP: DESACTIVADO")
        if conexionNoClip then
            conexionNoClip:Disconnect()
            conexionNoClip = nil
        end
    end
end, "Activa/Desactiva la colisión con objetos")

-- Control de velocidad para No-Clip (nueva característica)
local velocidadLabel = crearElemento("TextLabel", {
    Size = UDim2.new(1, 0, 0, 25),
    Position = UDim2.new(0, 0, 0, 50),
    Text = "Velocidad: " .. velocidadNoClip,
    Font = Enum.Font.SourceSans,
    TextSize = 14,
    TextColor3 = Config.ColorTexto,
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left
}, NC_Content)

local masBtn = crearElemento("TextButton", {
    Size = UDim2.new(0, 25, 0, 25),
    Position = UDim2.new(1, -25, 0, 50),
    Text = "+",
    Font = Enum.Font.SourceSansBold,
    TextSize = 16,
    TextColor3 = Config.ColorTexto,
    BackgroundColor3 = Config.ColorPrincipal,
    BorderSizePixel = 0
}, NC_Content)

crearElemento("UICorner", {
    CornerRadius = UDim.new(0, 4)
}, masBtn)

local menosBtn = crearElemento("TextButton", {
    Size = UDim2.new(0, 25, 0, 25),
    Position = UDim2.new(1, -55, 0, 50),
    Text = "-",
    Font = Enum.Font.SourceSansBold,
    TextSize = 16,
    TextColor3 = Config.ColorTexto,
    BackgroundColor3 = Config.ColorPrincipal,
    BorderSizePixel = 0
}, NC_Content)

crearElemento("UICorner", {
    CornerRadius = UDim.new(0, 4)
}, menosBtn)

masBtn.MouseButton1Click:Connect(function()
    if velocidadNoClip < 5 then
        velocidadNoClip = velocidadNoClip + 0.5
        velocidadLabel.Text = "Velocidad: " .. velocidadNoClip
        notificar("Velocidad aumentada: " .. velocidadNoClip)
    end
end)

menosBtn.MouseButton1Click:Connect(function()
    if velocidadNoClip > 0.5 then
        velocidadNoClip = velocidadNoClip - 0.5
        velocidadLabel.Text = "Velocidad: " .. velocidadNoClip
        notificar("Velocidad disminuida: " .. velocidadNoClip)
    end
end)

-- Sistema de ejecución de scripts mejorado
local function ejecutarScript(boton, urls, nombreScript)
    task.spawn(function()
        local textoOriginal = boton.Text
        local listaURLs = type(urls) == "table" and urls or {urls}
        local totalScripts = #listaURLs
        
        boton.Text = "Cargando..."
        TweenService:Create(boton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        }):Play()
        
        for i, url in ipairs(listaURLs) do
            notificar(string.format("Ejecutando %s (%d/%d)...", nombreScript or "script", i, totalScripts))
            
            local exito, resultado = pcall(function()
                loadstring(game:HttpGet(url))()
            end)
            
            if not exito then
                notificar("¡Error en " .. (nombreScript or "script") .. " " .. i .. "!")
                warn("ERROR EN " .. textoOriginal .. " (URL " .. i .. "): " .. tostring(resultado))
                break
            end
        end
        
        boton.Text = textoOriginal
        TweenService:Create(boton, TweenInfo.new(0.2), {
            BackgroundColor3 = Config.ColorSecundario
        }):Play()
        
        notificar("Ejecución completada: " .. (nombreScript or "script"))
    end)
end

-- =========================================================================================
--                                  INTERACTIVIDAD PRINCIPAL
-- =========================================================================================

-- Funcionalidad del botón de apertura
OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    CloseButton.Visible = MainFrame.Visible
    
    -- Efecto de animación al abrir/cerrar
    if MainFrame.Visible then
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
