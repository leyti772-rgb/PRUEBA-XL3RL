--[[
    SCRIPT: XL3RL - Design Evolution Edition
    AUTOR: Gemini & XL3RL
    DESCRIPCIÓN: Interfaz de usuario rediseñada con enfoque moderno,
                 visualmente atractiva y altamente funcional.
]]

-- =========================================================================================
--                                   CONFIGURACIÓN MEJORADA
-- =========================================================================================
local Config = {
    Nombre = "XL3RL EVOLUTION",
    ColorPrincipal = Color3.fromRGB(0, 180, 255),          -- Azul neón moderno
    ColorSecundario = Color3.fromRGB(45, 45, 55),          -- Gris oscuro
    ColorFondo = Color3.fromRGB(25, 27, 33),               -- Fondo oscuro
    ColorTexto = Color3.fromRGB(240, 240, 240),            -- Texto blanco
    ColorTextoSecundario = Color3.fromRGB(170, 170, 180),  -- Texto gris claro
    ColorAcento = Color3.fromRGB(255, 110, 80),            -- Naranja-rojo para acentos
    IconoFlotante = "⚙️",                                  -- Icono moderno
    RadioEsquinas = 12,                                    -- Esquinas más redondeadas
    Transparencia = 0.05,                                  -- Ligera transparencia
    SombraIntensidad = 0.3                                 -- Intensidad de sombras
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
--                                  FUNCIONES UTILITARIAS MEJORADAS
-- =========================================================================================

-- Función mejorada para crear elementos UI con diseño consistente
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

-- Función para crear efectos de sombra (simulados con Frames)
local function crearSombra(elemento, intensidad)
    local sombra = crearElemento("Frame", {
        Size = UDim2.new(1, 10, 1, 10),
        Position = UDim2.new(0, -5, 0, -5),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 1 - intensidad,
        BorderSizePixel = 0,
        ZIndex = elemento.ZIndex - 1
    }, elemento.Parent)
    
    crearElemento("UICorner", {
        CornerRadius = elemento:FindFirstChildOfClass("UICorner") and 
                      elemento:FindFirstChildOfClass("UICorner").CornerRadius or UDim.new(0, 0)
    }, sombra)
    
    return sombra
end

-- Función de arrastre optimizada con feedback visual
local function hacerArrastrable(frame, trigger)
    local dragging = false
    local dragInput, startPos, dragStart

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = frame.Position
            dragStart = input.Position
            
            -- Feedback visual al comenzar arrastre
            TweenService:Create(frame, TweenInfo.new(0.1), {
                BackgroundTransparency = Config.Transparencia + 0.1
            }:Play()
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    -- Restaurar transparencia
                    TweenService:Create(frame, TweenInfo.new(0.2), {
                        BackgroundTransparency = Config.Transparencia
                    }:Play()
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

-- Limpieza inicial mejorada
pcall(function() 
    local guiExistente = player.PlayerGui:FindFirstChild("XL3RL_GUI")
    if guiExistente then
        guiExistente:Destroy()
    end
end)

-- Crear GUI principal con propiedades mejoradas
local ScreenGui = crearElemento("ScreenGui", {
    Name = "XL3RL_GUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, player.PlayerGui)

-- =========================================================================================
--                                  COMPONENTES PRINCIPALES REDISEÑADOS
-- =========================================================================================

-- Crear marco principal con diseño de cristal (glassmorphism)
local MainFrame = crearElemento("Frame", {
    Size = UDim2.new(0, 320, 0, 450),
    Position = UDim2.new(0.5, -160, 0.5, -225),
    BackgroundColor3 = Config.ColorFondo,
    BackgroundTransparency = Config.Transparencia,
    BorderSizePixel = 0,
    Visible = false,
    ClipsDescendants = true,
    ZIndex = 10
}, ScreenGui)

-- Aplicar efectos visuales modernos al marco principal
crearElemento("UICorner", {
    CornerRadius = UDim.new(0, Config.RadioEsquinas)
}, MainFrame)

local mainStroke = crearElemento("UIStroke", {
    Color = Config.ColorPrincipal,
    Thickness = 2,
    Transparency = 0.7
}, MainFrame)

-- Efecto de gradiente para el borde
crearElemento("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Config.ColorPrincipal),
        ColorSequenceKeypoint.new(1, Config.ColorAcento)
    }),
    Rotation = 90
}, mainStroke)

-- Efecto de brillo interior
local innerGlow = crearElemento("Frame", {
    Size = UDim2.new(1, -10, 1, -10),
    Position = UDim2.new(0, 5, 0, 5),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ZIndex = 11
}, MainFrame)

crearElemento("UIStroke", {
    Color = Config.ColorPrincipal,
    Thickness = 1,
    Transparency = 0.8
}, innerGlow)

-- Crear barra de encabezado con diseño moderno
local Header = crearElemento("Frame", {
    Size = UDim2.new(1, 0, 0, 45),
    BackgroundColor3 = Config.ColorSecundario,
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    ZIndex = 12
}, MainFrame)

crearElemento("UICorner", {
    CornerRadius = UDim.new(0, Config.RadioEsquinas)
}, Header)

-- Título con icono
local TitleContainer = crearElemento("Frame", {
    Size = UDim2.new(1, -50, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    ZIndex = 13
}, Header)

local Title = crearElemento("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    Text = "  " .. Config.Nombre,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = Config.ColorTexto,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1
}, TitleContainer)

-- Icono del título
crearElemento("TextLabel", {
    Size = UDim2.new(0, 20, 0, 20),
    Position = UDim2.new(0, 0, 0.5, -10),
    Text = "✨",
    Font = Enum.Font.Code,
    TextSize = 16,
    TextColor3 = Config.ColorPrincipal,
    BackgroundTransparency = 1,
    ZIndex = 14
}, TitleContainer)

-- Botón de cerrar moderno
local CloseButton = crearElemento("TextButton", {
    Size = UDim2.new(0, 32, 0, 32),
    Position = UDim2.new(1, -37, 0.5, -16),
    Text = "",
    BackgroundColor3 = Config.ColorAcento,
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
    ZIndex = 13
}, Header)

crearElemento("UICorner", {
    CornerRadius = UDim.new(1, 0)
}, CloseButton)

-- Icono de cerrar (X)
crearElemento("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    Text = "×",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = Config.ColorTexto,
    BackgroundTransparency = 1
}, CloseButton)

-- Aplicar funcionalidad de arrastre al encabezado
hacerArrastrable(MainFrame, Header)

-- Barra de búsqueda con diseño moderno
local SearchContainer = crearElemento("Frame", {
    Size = UDim2.new(1, -20, 0, 40),
    Position = UDim2.new(0, 10, 0, 50),
    BackgroundColor3 = Config.ColorSecundario,
    BackgroundTransparency = 0.5,
    BorderSizePixel = 0,
    ZIndex = 11
}, MainFrame)

crearElemento("UICorner", {
    CornerRadius = UDim.new(0, Config.RadioEsquinas)
}, SearchContainer)

local SearchIcon = crearElemento("TextLabel", {
    Size = UDim2.new(0, 30, 1, 0),
    Position = UDim2.new(0, 5, 0, 0),
    Text = "🔍",
    Font = Enum.Font.Code,
    TextSize = 16,
    TextColor3 = Config.ColorTextoSecundario,
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 12
}, SearchContainer)

local SearchBox = crearElemento("TextBox", {
    Size = UDim2.new(1, -40, 1, 0),
    Position = UDim2.new(0, 35, 0, 0),
    PlaceholderText = "Buscar funciones...",
    PlaceholderColor3 = Config.ColorTextoSecundario,
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = Config.ColorTexto,
    BackgroundTransparency = 1,
    ClearTextOnFocus = false,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 12
}, SearchContainer)

-- Contenedor de opciones con scroll mejorado
local OptionsContainer = crearElemento("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, -130),
    Position = UDim2.new(0, 0, 0, 95),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarImageColor3 = Config.ColorPrincipal,
    ScrollBarImageTransparency = 0.7,
    ScrollBarThickness = 4,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    VerticalScrollBarInset = Enum.ScrollBarInset.Always,
    ZIndex = 11
}, MainFrame)

local UILayout = crearElemento("UIListLayout", {
    Padding = UDim.new(0, 15),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
}, OptionsContainer)

-- Barra de estado rediseñada
local StatusBar = crearElemento("Frame", {
    Size = UDim2.new(1, -20, 0, 30),
    Position = UDim2.new(0, 10, 1, -35),
    BackgroundColor3 = Config.ColorSecundario,
    BackgroundTransparency = 0.6,
    BorderSizePixel = 0,
    ZIndex = 12
}, MainFrame)

crearElemento("UICorner", {
    CornerRadius = UDim.new(0, Config.RadioEsquinas)
}, StatusBar)

local StatusIcon = crearElemento("TextLabel", {
    Size = UDim2.new(0, 20, 0, 20),
    Position = UDim2.new(0, 8, 0.5, -10),
    Text = "💬",
    Font = Enum.Font.Code,
    TextSize = 14,
    TextColor3 = Config.ColorPrincipal,
    BackgroundTransparency = 1,
    ZIndex = 13
}, StatusBar)

local StatusText = crearElemento("TextLabel", {
    Size = UDim2.new(1, -35, 1, 0),
    Position = UDim2.new(0, 30, 0, 0),
    Text = "Sistema iniciado correctamente. Presiona F para alternar visibilidad",
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = Config.ColorTextoSecundario,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    ZIndex = 13
}, StatusBar)

-- Función de notificación mejorada con iconos
local function notificar(mensaje, duracion, tipo)
    local iconos = {
        info = "💡",
        exito = "✅",
        error = "❌",
        advertencia = "⚠️",
        carga = "⏳"
    }
    
    local icono = iconos[tipo] or "💡"
    StatusIcon.Text = icono
    
    StatusText.Text = tostring(mensaje)
    
    -- Animación de notificación
    StatusBar.Size = UDim2.new(1, -20, 0, 30)
    TweenService:Create(StatusBar, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, -20, 0, 35)
    }):Play()
    
    task.wait(duracion or 3)
    
    TweenService:Create(StatusBar, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, -20, 0, 30)
    }):Play()
    
    task.wait(0.3)
    StatusText.Text = "Esperando acción..."
    StatusIcon.Text = "💬"
end

-- Botón flotante rediseñado con animaciones
local OpenButton = crearElemento("TextButton", {
    Size = UDim2.new(0, 60, 0, 60),
    Position = UDim2.new(0, 20, 0.5, -30),
    BackgroundColor3 = Config.ColorPrincipal,
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
    Text = "",
    ZIndex = 20
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

-- Icono del botón flotante
crearElemento("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    Text = Config.IconoFlotante,
    Font = Enum.Font.Code,
    TextSize = 28,
    TextColor3 = Config.ColorTexto,
    BackgroundTransparency = 1,
    ZIndex = 21
}, OpenButton)

-- Sombra del botón
local buttonShadow = crearSombra(OpenButton, Config.SombraIntensidad)

-- Efecto de partículas (simulado) para el botón
local particleEffect = crearElemento("Frame", {
    Size = UDim2.new(1, 20, 1, 20),
    Position = UDim2.new(0, -10, 0, -10),
    BackgroundTransparency = 1,
    ZIndex = 19
}, OpenButton)

crearElemento("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Config.ColorPrincipal),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    }),
    Rotation = 45,
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.7),
        NumberSequenceKeypoint.new(1, 1)
    })
}, particleEffect)

-- Aplicar funcionalidad de arrastre al botón
hacerArrastrable(OpenButton, OpenButton)

-- =========================================================================================
--                                  MÓDULO NO-CLIP REDISEÑADO
-- =========================================================================================
local NoClipFrame = crearElemento("Frame", {
    Size = UDim2.new(0, 280, 0, 180),
    Position = UDim2.new(0.5, -140, 0.5, -90),
    BackgroundColor3 = Config.ColorFondo,
    BackgroundTransparency = Config.Transparencia,
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 30
}, ScreenGui)

-- Diseño visual del módulo No-Clip
crearElemento("UICorner", {
    CornerRadius = UDim.new(0, Config.RadioEsquinas)
}, NoClipFrame)

local ncStroke = crearElemento("UIStroke", {
    Color = Config.ColorAcento,
    Thickness = 2,
    Transparency = 0.7
}, NoClipFrame)

crearElemento("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Config.ColorAcento),
        ColorSequenceKeypoint.new(1, Config.ColorPrincipal)
    }),
    Rotation = 90
}, ncStroke)

local NC_Header = crearElemento("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Config.ColorSecundario,
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    ZIndex = 31
}, NoClipFrame)

crearElemento("UICorner", {
    CornerRadius = UDim.new(0, Config.RadioEsquinas)
}, NC_Header)

local NC_Title = crearElemento("TextLabel", {
    Size = UDim2.new(1, -50, 1, 0),
    Position = UDim2.new(0, 15, 0, 0),
    Text = "🚀 CONFIGURACIÓN NO-CLIP",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = Config.ColorTexto,
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 32
}, NC_Header)

local NC_Close = crearElemento("TextButton", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -35, 0.5, -15),
    Text = "",
    BackgroundColor3 = Config.ColorAcento,
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
    ZIndex = 32
}, NC_Header)

crearElemento("UICorner", {
    CornerRadius = UDim.new(1, 0)
}, NC_Close)

crearElemento("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    Text = "×",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = Config.ColorTexto,
    BackgroundTransparency = 1
}, NC_Close)

-- Aplicar funcionalidad de arrastre
hacerArrastrable(NoClipFrame, NC_Header)

-- Contenido del módulo No-Clip
local NC_Content = crearElemento("Frame", {
    Size = UDim2.new(1, -20, 1, -50),
    Position = UDim2.new(0, 10, 0, 45),
    BackgroundTransparency = 1,
    ZIndex = 31
}, NoClipFrame)

-- =========================================================================================
--                                  SISTEMA DE OPCIONES REDISEÑADO
-- =========================================================================================

-- Función para crear tarjetas de opciones con diseño moderno
local function crearTarjetaOpcion(parent, texto, descripcion, icono, color)
    local tarjeta = crearElemento("Frame", {
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundColor3 = color or Config.ColorSecundario,
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0
    }, parent)
    
    crearElemento("UICorner", {
        CornerRadius = UDim.new(0, Config.RadioEsquinas)
    }, tarjeta)
    
    -- Icono de la tarjeta
    crearElemento("TextLabel", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 15, 0.5, -20),
        Text = icono or "⚙️",
        Font = Enum.Font.Code,
        TextSize = 20,
        TextColor3 = Config.ColorPrincipal,
        BackgroundTransparency = 1,
        ZIndex = 12
    }, tarjeta)
    
    -- Título de la tarjeta
    crearElemento("TextLabel", {
        Size = UDim2.new(0.7, -50, 0, 20),
        Position = UDim2.new(0, 60, 0, 15),
        Text = texto,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextColor3 = Config.ColorTexto,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 12
    }, tarjeta)
    
    -- Descripción de la tarjeta
    crearElemento("TextLabel", {
        Size = UDim2.new(0.7, -50, 0, 15),
        Position = UDim2.new(0, 60, 0, 35),
        Text = descripcion or "",
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = Config.ColorTextoSecundario,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 12
    }, tarjeta)
    
    -- Efectos de hover
    tarjeta.MouseEnter:Connect(function()
        TweenService:Create(tarjeta, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.4
        }:Play()
    end)
    
    tarjeta.MouseLeave:Connect(function()
        TweenService:Create(tarjeta, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.6
        }:Play()
    end)
    
    return tarjeta
end

-- Función para crear interruptores modernos
local function crearInterruptorModerno(parent, texto, callback, estadoInicial, tooltip)
    local tarjeta = crearTarjetaOpcion(parent, texto, tooltip, "🔘", Config.ColorSecundario)
    
    local interruptor = crearElemento("TextButton", {
        Size = UDim2.new(0, 50, 0, 25),
        Position = UDim2.new(1, -60, 0.5, -12.5),
        BackgroundColor3 = estadoInicial and Config.ColorPrincipal or Color3.fromRGB(80, 80, 80),
        BackgroundTransparency = 0.3,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 13
    }, tarjeta)
    
    crearElemento("UICorner", {
        CornerRadius = UDim.new(1, 0)
    }, interruptor)
    
    local knob = crearElemento("Frame", {
        Size = UDim2.new(0, 21, 0, 21),
        Position = estadoInicial and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5),
  
