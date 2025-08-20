--[[
    SCRIPT: XL3RL - Modular Edition V2
    AUTOR: Gemini & XL3RL
    DESCRIPCIÓN: Interfaz de usuario modular con funcionalidades varias
                 y sistema de arrastre corregido.
]]

-- =========================================================================================
--                                   CONFIGURACIÓN
-- =========================================================================================
local Config = {
    Nombre = "XL3RL",
    ColorPrincipal = Color3.fromRGB(255, 0, 80),
    IconoFlotante = "⊕",
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
--                                  FUNCIONES UTilitarias
-- =========================================================================================
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
--                                  INTERFAZ DE USUARIO
-- =========================================================================================
-- Limpieza inicial
pcall(function() 
    player.PlayerGui.XL3RL_GUI:Destroy() 
end)

-- Creación de GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XL3RL_GUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Componentes de la interfaz
local MainFrame, NoClipFrame, OpenButton
local StatusText -- Para referencias futuras

-- Función para crear elementos con propiedades comunes
local function crearElemento(tipo, propiedades)
    local elemento = Instance.new(tipo)
    for propiedad, valor in pairs(propiedades) do
        elemento[propiedad] = valor
    end
    return elemento
end

-- Creación del marco principal
MainFrame = crearElemento("Frame", {
    Size = UDim2.new(0, 260, 0, 300),
    Position = UDim2.new(0.5, -130, 0.5, -150),
    BackgroundColor3 = Color3.fromRGB(30, 32, 38),
    BorderSizePixel = 0,
    Visible = false,
    Parent = ScreenGui
})

-- Configuración de esquinas y bordes
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Config.ColorPrincipal
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.5

-- Creación de la barra de encabezado
local Header = crearElemento("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Color3.fromRGB(40, 42, 48),
    BorderSizePixel = 0,
    Parent = MainFrame
})

Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local Title = crearElemento("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    Text = "// " .. Config.Nombre,
    Font = Enum.Font.Code,
    TextSize = 20,
    TextColor3 = Config.ColorPrincipal,
    BackgroundTransparency = 1,
    Parent = Header
})

-- Barra de estado
local StatusBar = crearElemento("Frame", {
    Size = UDim2.new(1, 0, 0, 25),
    Position = UDim2.new(0, 0, 1, -25),
    BackgroundColor3 = Color3.fromRGB(40, 42, 48),
    BorderSizePixel = 0,
    Parent = MainFrame
})

Instance.new("UICorner", StatusBar).CornerRadius = UDim.new(0, 8)

StatusText = crearElemento("TextLabel", {
    Size = UDim2.new(1, -10, 1, 0),
    Position = UDim2.new(0.5, -((260-10)/2), 0, 0),
    Text = "Iniciado correctamente.",
    Font = Enum.Font.Code,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(150, 150, 150),
    BackgroundTransparency = 1,
    Parent = StatusBar
})

-- Contenedor de opciones
local OptionsContainer = crearElemento("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, -75),
    Position = UDim2.new(0, 0, 0, 40),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarImageColor3 = Config.ColorPrincipal,
    ScrollBarThickness = 4,
    Parent = MainFrame
})

local UILayout = Instance.new("UIListLayout", OptionsContainer)
UILayout.Padding = UDim.new(0, 10)
UILayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UILayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Botón de apertura
OpenButton = crearElemento("TextButton", {
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0, 15, 1, -65),
    BackgroundColor3 = Config.ColorPrincipal,
    BorderSizePixel = 0,
    Text = Config.IconoFlotante,
    Font = Enum.Font.SourceSansBold,
    TextColor3 = Color3.fromRGB(30, 32, 38),
    TextSize = 32,
    Parent = ScreenGui
})

Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(1, 0)

-- Aplicar funcionalidad de arrastre
hacerArrastrable(MainFrame, Header)
hacerArrastrable(OpenButton, OpenButton)

-- Función de notificación
local function notificar(mensaje, duracion)
    StatusText.Text = tostring(mensaje)
    task.wait(duracion or 2)
    StatusText.Text = "Esperando acción..."
end

-- =========================================================================================
--                                  MÓDULO NO-CLIP
-- =========================================================================================
NoClipFrame = crearElemento("Frame", {
    Size = UDim2.new(0, 220, 0, 100),
    Position = UDim2.new(0.5, -110, 0.2, 0),
    BackgroundColor3 = Color3.fromRGB(30, 32, 38),
    BorderSizePixel = 0,
    Visible = false,
    Parent = ScreenGui
})

-- Configuración visual del marco No-Clip
local NC_Corner = Instance.new("UICorner", NoClipFrame)
NC_Corner.CornerRadius = UDim.new(0, 8)

local NC_Stroke = Instance.new("UIStroke", NoClipFrame)
NC_Stroke.Color = Config.ColorPrincipal
NC_Stroke.Thickness = 1

local NC_Header = crearElemento("Frame", {
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = Color3.fromRGB(40, 42, 48),
    Parent = NoClipFrame
})

Instance.new("UICorner", NC_Header).CornerRadius = UDim.new(0, 8)

crearElemento("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    Text = "NO-CLIP",
    Font = Enum.Font.Code,
    TextSize = 16,
    TextColor3 = Color3.new(1, 1, 1),
    BackgroundTransparency = 1,
    Parent = NC_Header
})

local NC_Close = crearElemento("TextButton", {
    Size = UDim2.new(0, 20, 0, 20),
    Position = UDim2.new(1, -25, 0.5, -10),
    Text = "X",
    Font = Enum.Font.SourceSansBold,
    TextColor3 = Color3.new(1, 1, 1),
    BackgroundColor3 = Color3.fromRGB(200, 50, 50),
    Parent = NC_Header
})

Instance.new("UICorner", NC_Close).CornerRadius = UDim.new(1, 0)

-- Aplicar funcionalidades
hacerArrastrable(NoClipFrame, NC_Header)

NC_Close.MouseButton1Click:Connect(function()
    NoClipFrame.Visible = false
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- =========================================================================================
--                                  SISTEMA DE OPCIONES
-- =========================================================================================
local function crearInterruptor(parent, texto, callback)
    local frame = crearElemento("Frame", {
        Size = UDim2.new(1, -20, 0, 40),
        BackgroundColor3 = Color3.fromRGB(45, 47, 54),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -((220-20)/2), 0, 45),
        Parent = parent
    })
    
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    crearElemento("TextLabel", {
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Text = texto,
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })

    local interruptor = crearElemento("TextButton", {
        Size = UDim2.new(0.3, 0, 0, 24),
        Position = UDim2.new(1, -10 - (frame.AbsoluteSize.X * 0.3), 0.5, -12),
        BackgroundColor3 = Color3.fromRGB(70, 70, 70),
        Text = "",
        Parent = frame
    })
    
    Instance.new("UICorner", interruptor).CornerRadius = UDim.new(1, 0)

    local knob = crearElemento("Frame", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 2, 0.5, -10),
        BackgroundColor3 = Color3.fromRGB(150, 150, 150),
        Parent = interruptor
    })
    
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local estado = false
    
    interruptor.MouseButton1Click:Connect(function()
        estado = not estado
        
        local nuevaPosicion = estado and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        local nuevoColor = estado and Config.ColorPrincipal or Color3.fromRGB(70, 70, 70)
        
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = nuevaPosicion}):Play()
        TweenService:Create(interruptor, TweenInfo.new(0.2), {BackgroundColor3 = nuevoColor}):Play()
        
        callback(estado)
    end)
end

local function crearBotonAccion(texto, callback)
    local boton = crearElemento("TextButton", {
        Size = UDim2.new(1, -20, 0, 40),
        Text = texto,
        Font = Enum.Font.SourceSansSemibold,
        TextSize = 16,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundColor3 = Color3.fromRGB(45, 47, 54),
        Parent = OptionsContainer
    })
    
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
end

-- =========================================================================================
--                                  LÓGICA DE FUNCIONALIDADES
-- =========================================================================================
-- Sistema No-Clip
local conexionNoClip = nil

crearInterruptor(NoClipFrame, "NO-CLIP", function(activado)
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
end)

-- Sistema de ejecución de scripts
local function ejecutarScript(boton, urls)
    task.spawn(function()
        local textoOriginal = boton.Text
        local listaURLs = type(urls) == "table" and urls or {urls}
        local totalScripts = #listaURLs
        
        for i, url in ipairs(listaURLs) do
            notificar(string.format("Ejecutando script %d de %d...", i, totalScripts))
            
            local exito, resultado = pcall(function()
                loadstring(game:HttpGet(url))()
            end)
            
            if not exito then
                notificar("¡Error en script " .. i .. "!")
                warn("ERROR EN " .. textoOriginal .. " (URL " .. i .. "): " .. tostring(resultado))
                break
            end
        end
        
        notificar("Secuencia de scripts completada.")
    end)
end

-- =========================================================================================
--                                  BOTONES PRINCIPALES
-- =========================================================================================
crearBotonAccion("NO-CLIP", function()
    NoClipFrame.Visible = true
    notificar("Abriendo menú NO-CLIP")
end)

crearBotonAccion("COMBO SCRIPT", function(boton)
    ejecutarScript(boton, {
        "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua",
        "https://gist.githubusercontent.com/UCT-hub/5b11d10386f1b8ce08feb803861e0b79/raw/b2917b398d4b0cc80fb2aca73a3137ba494ebcf0/gistfile1.txt"
    })
end)

crearBotonAccion("SERVIDORES", function(boton)
    ejecutarScript(boton, "https://raw.githubusercontent.com/Gato-bytes/GatoHubOnTop/refs/heads/main/AutoJoin.lua")
end)--- @param urls string|table URL(s) del script
local function executeScript(button, urls)
    spawn(function()
        local originalText = button.Text
        local urlList = type(urls) == "table" and urls or {urls}
        local totalScripts = #urlList
        
        for i, url in ipairs(urlList) do
            notify(string.format("Ejecutando script %d de %d...", i, totalScripts))
            
            local success, result = pcall(function()
                loadstring(game:HttpGet(url))()
            end)
            
            if not success then
                notify("¡Error en script "..i.."!")
                warn("ERROR EN "..originalText.." (URL "..i.."): " .. tostring(result))
                break
            end
        end
        
        notify("Secuencia de scripts completada.")
    end)
end

-- =========================================================================================
--                                  INTERFAZ PRINCIPAL
-- =========================================================================================

-- FRAME PRINCIPAL
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 300)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 38)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Esquinas y borde del frame principal
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Config.ColorPrincipal
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.5

-- BARRA SUPERIOR
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(40, 42, 48)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "// "..Config.Nombre
Title.Font = Enum.Font.Code
Title.TextSize = 20
Title.TextColor3 = Config.ColorPrincipal
Title.BackgroundTransparency = 1
Title.Parent = Header

-- Hacer la ventana arrastrable
hacerArrastrable(MainFrame, Header)

-- BARRA DE ESTADO
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, 0, 0, 25)
StatusBar.Position = UDim2.new(0, 0, 1, -25)
StatusBar.BackgroundColor3 = Color3.fromRGB(40, 42, 48)
StatusBar.BorderSizePixel = 0
StatusBar.Parent = MainFrame

local StatusCorner = Instance.new("UICorner", StatusBar)
StatusCorner.CornerRadius = UDim.new(0, 8)

StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, -10, 1, 0)
StatusText.Position = UDim2.new(0.5, -((260-10)/2), 0, 0)
StatusText.Text = "Iniciado correctamente."
StatusText.Font = Enum.Font.Code
StatusText.TextSize = 14
StatusText.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusText.BackgroundTransparency = 1
StatusText.Parent = StatusBar

-- CONTENEDOR DE OPCIONES
local OptionsContainer = Instance.new("ScrollingFrame")
OptionsContainer.Size = UDim2.new(1, 0, 1, -75)
OptionsContainer.Position = UDim2.new(0, 0, 0, 40)
OptionsContainer.BackgroundTransparency = 1
OptionsContainer.BorderSizePixel = 0
OptionsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
OptionsContainer.ScrollBarImageColor3 = Config.ColorPrincipal
OptionsContainer.ScrollBarThickness = 4
OptionsContainer.Parent = MainFrame

local UILayout = Instance.new("UIListLayout", OptionsContainer)
UILayout.Padding = UDim.new(0, 10)
UILayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UILayout.SortOrder = Enum.SortOrder.LayoutOrder

-- BOTÓN DE APERTURA
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 50, 0, 50)
OpenButton.Position = UDim2.new(0, 15, 1, -65)
OpenButton.BackgroundColor3 = Config.ColorPrincipal
OpenButton.BorderSizePixel = 0
OpenButton.Text = Config.IconoFlotante
OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.TextColor3 = Color3.fromRGB(30, 32, 38)
OpenButton.TextSize = 32
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner", OpenButton)
OpenCorner.CornerRadius = UDim.new(1, 0)

-- Hacer el botón arrastrable
hacerArrastrable(OpenButton, OpenButton)

-- Alternar visibilidad del menú principal
OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- =========================================================================================
--                             VENTANA DE UTILIDAD NO-CLIP
-- =========================================================================================

local NoClipFrame = Instance.new("Frame")
NoClipFrame.Size = UDim2.new(0, 220, 0, 100)
NoClipFrame.Position = UDim2.new(0.5, -110, 0.2, 0)
NoClipFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 38)
NoClipFrame.BorderSizePixel = 0
NoClipFrame.Visible = false
NoClipFrame.Parent = ScreenGui

-- Esquinas y borde de la ventana No-Clip
local NC_Corner = Instance.new("UICorner", NoClipFrame)
NC_Corner.CornerRadius = UDim.new(0, 8)

local NC_Stroke = Instance.new("UIStroke", NoClipFrame)
NC_Stroke.Color = Config.ColorPrincipal
NC_Stroke.Thickness = 1

-- Encabezado de la ventana No-Clip
local NC_Header = Instance.new("Frame", NoClipFrame)
NC_Header.Size = UDim2.new(1, 0, 0, 30)
NC_Header.BackgroundColor3 = Color3.fromRGB(40, 42, 48)

local NC_HCorner = Instance.new("UICorner", NC_Header)
NC_HCorner.CornerRadius = UDim.new(0, 8)

local NC_Title = Instance.new("TextLabel", NC_Header)
NC_Title.Size = UDim2.new(1, 0, 1, 0)
NC_Title.Text = "NO-CLIP"
NC_Title.Font = Enum.Font.Code
NC_Title.TextSize = 16
NC_Title.TextColor3 = Color3.new(1, 1, 1)
NC_Title.BackgroundTransparency = 1

-- Botón de cierre
local NC_Close = Instance.new("TextButton", NC_Header)
NC_Close.Size = UDim2.new(0, 20, 0, 20)
NC_Close.Position = UDim2.new(1, -25, 0.5, -10)
NC_Close.Text = "X"
NC_Close.Font = Enum.Font.SourceSansBold
NC_Close.TextColor3 = Color3.new(1, 1, 1)
NC_Close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

local NC_CCorner = Instance.new("UICorner", NC_Close)
NC_CCorner.CornerRadius = UDim.new(1, 0)

-- Hacer la ventana No-Clip arrastrable
hacerArrastrable(NoClipFrame, NC_Header)

-- Cerrar la ventana No-Clip
NC_Close.MouseButton1Click:Connect(function()
    NoClipFrame.Visible = false
end)

-- =========================================================================================
--                          COMPONENTES DE INTERFAZ REUTILIZABLES
-- =========================================================================================

--- Crea un interruptor (toggle switch) en la interfaz
--- @param parent Instance Contenedor padre
--- @param text string Texto descriptivo
--- @param callback function Función a ejecutar al cambiar estado
--- @return table Información del interruptor creado
local function crearInterruptor(parent, text, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(45, 47, 54)
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0.5, -((220-20)/2), 0, 45)
    
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 6)

    -- Etiqueta del interruptor
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = text
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    -- Base del interruptor
    local switch = Instance.new("TextButton", frame)
    switch.Size = UDim2.new(0.3, 0, 0, 24)
    switch.Position = UDim2.new(1, -10 - (frame.AbsoluteSize.X * 0.3), 0.5, -12)
    switch.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    switch.Text = ""
    
    local switchCorner = Instance.new("UICorner", switch)
    switchCorner.CornerRadius = UDim.new(1, 0)

    -- Control deslizante del interruptor
    local knob = Instance.new("Frame", switch)
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = UDim2.new(0, 2, 0.5, -10)
    knob.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    
    local knobCorner = Instance.new("UICorner", knob)
    knobCorner.CornerRadius = UDim.new(1, 0)

    -- Estado y lógica del interruptor
    local state = false
    
    switch.MouseButton1Click:Connect(function()
        state = not state
        
        -- Animación del interruptor
        local goalPos = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        local goalColor = state and Config.ColorPrincipal or Color3.fromRGB(70, 70, 70)
        
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = goalPos}):Play()
        TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = goalColor}):Play()
        
        -- Ejecutar callback
        callback(state)
    end)
    
    return {
        Frame = frame,
        Label = label,
        Switch = switch,
        Knob = knob,
        State = state
    }
end

--- Crea un botón de acción en el menú principal
--- @param text string Texto del botón
--- @param callback function Función a ejecutar al hacer clic
--- @return Instance Botón creado
local function crearBotonAccion(text, callback)
    local button = Instance.new("TextButton", OptionsContainer)
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Text = text
    button.Font = Enum.Font.SourceSansSemibold
    button.TextSize = 16
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BackgroundColor3 = Color3.fromRGB(45, 47, 54)
    
    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0, 6)

    -- Efectos hover
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Config.ColorPrincipal
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(45, 47, 54)
        }):Play()
    end)
    
    -- Acción al hacer clic
    button.MouseButton1Click:Connect(function()
        callback(button)
    end)
    
    return button
end

-- =========================================================================================
--                          LÓGICA DE FUNCIONALIDADES
-- =========================================================================================

-- LÓGICA NO-CLIP
local noClipConnection = nil

crearInterruptor(NoClipFrame, "NO-CLIP", function(activado)
    if activado then
        notify("NO-CLIP: ACTIVADO")
        
        -- Conectar para desactivar colisiones continuamente
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
        notify("NO-CLIP: DESACTIVADO")
        
        -- Desconectar la función de no-clip
        if noClipConnection then
            noClipConnection:Disconnect()
            noClipConnection = nil
        end
    end
end)

-- =========================================================================================
--                          BOTONES DEL MENÚ PRINCIPAL
-- =========================================================================================

-- Botón para abrir el menú No-Clip
crearBotonAccion("NO-CLIP", function()
    NoClipFrame.Visible = true
    notify("Abriendo menú NO-CLIP")
end)

-- Botón para ejecutar script combo
crearBotonAccion("COMBO SCRIPT", function(button)
    executeScript(button, {
        "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua",
        "https://gist.githubusercontent.com/UCT-hub/5b11d10386f1b8ce08feb803861e0b79/raw/b2917b398d4b0cc80fb2aca73a3137ba494ebcf0/gistfile1.txt"
    })
end)

-- Botón para unirse a servidores
crearBotonAccion("SERVIDORES", function(button)
    executeScript(button, "https://raw.githubusercontent.com/Gato-bytes/GatoHubOnTop/refs/heads/main/AutoJoin.lua")
end)

-- =========================================================================================
--                          INICIALIZACIÓN FINAL
-- =========================================================================================

-- Ajustar el tamaño del canvas según los elementos añadidos
UILayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    OptionsContainer.CanvasSize = UDim2.new(0, 0, 0, UILayout.AbsoluteContentSize.Y)
end)

-- Notificación de inicio
notify("Interfaz cargada correctamente", 2)
