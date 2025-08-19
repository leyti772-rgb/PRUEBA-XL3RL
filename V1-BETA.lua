--[[
    SCRIPT: XL3RL Overdrive - Phoenix Edition
    AUTOR: Gemini
    DESCRIPCIÓN: El diseño final que renace de los problemas de renderizado.
                 Combina la estética Overdrive con la solución del icono de texto.
]]

-- =========================================================================================
--                                   CONFIGURACIÓN RÁPIDA
-- =========================================================================================

local Config = {
    Nombre = "XL3RL",
    ColorPrincipal = Color3.fromRGB(0, 255, 255), -- Cian Neón
    --ColorPrincipal = Color3.fromRGB(255, 0, 80), -- Rosa Neón
    --ColorPrincipal = Color3.fromRGB(0, 255, 0), -- Verde Lima
}

-- =========================================================================================
--                                    INICIALIZACIÓN
-- =========================================================================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

pcall(function() player.PlayerGui.XL3RL_GUI:Destroy() end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XL3RL_GUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- =========================================================================================
--                                  CREACIÓN DE LA INTERFAZ
-- =========================================================================================

-- FRAME PRINCIPAL (El contenedor de todo)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 300)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 38)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false -- Inicia oculto
MainFrame.Parent = ScreenGui
local UICorner = Instance.new("UICorner", MainFrame); UICorner.CornerRadius = UDim.new(0, 8)
local UIStroke = Instance.new("UIStroke", MainFrame); UIStroke.Color = Config.ColorPrincipal; UIStroke.Thickness = 1.5; UIStroke.Transparency = 0.5

-- BARRA SUPERIOR (Para arrastrar y título)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(40, 42, 48)
Header.BorderSizePixel = 0
Header.Parent = MainFrame
local HeaderCorner = Instance.new("UICorner", Header); HeaderCorner.CornerRadius = UDim.new(0, 8)

-- TÍTULO / LOGO DE TEXTO
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "// "..Config.Nombre
Title.Font = Enum.Font.Code
Title.TextSize = 20
Title.TextColor3 = Config.ColorPrincipal
Title.BackgroundTransparency = 1
Title.Parent = Header

-- BARRA DE ESTADO (Para notificaciones)
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, 0, 0, 25)
StatusBar.Position = UDim2.new(0, 0, 1, -25)
StatusBar.BackgroundColor3 = Color3.fromRGB(40, 42, 48)
StatusBar.BorderSizePixel = 0
StatusBar.Parent = MainFrame
local StatusCorner = Instance.new("UICorner", StatusBar); StatusCorner.CornerRadius = UDim.new(0, 8)
local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, -10, 1, 0); StatusText.Position = UDim2.new(0.5, -((260-10)/2), 0, 0); StatusText.Text = "Iniciado correctamente."; StatusText.Font = Enum.Font.Code; StatusText.TextSize = 14; StatusText.TextColor3 = Color3.fromRGB(150, 150, 150); StatusText.BackgroundTransparency = 1; StatusText.Parent = StatusBar

-- CONTENEDOR DE OPCIONES
local OptionsContainer = Instance.new("ScrollingFrame")
OptionsContainer.Size = UDim2.new(1, 0, 1, -75); OptionsContainer.Position = UDim2.new(0, 0, 0, 40); OptionsContainer.BackgroundTransparency = 1; OptionsContainer.BorderSizePixel = 0; OptionsContainer.CanvasSize = UDim2.new(0, 0, 0, 0); OptionsContainer.ScrollBarImageColor3 = Config.ColorPrincipal; OptionsContainer.ScrollBarThickness = 4; OptionsContainer.Parent = MainFrame
local UILayout = Instance.new("UIListLayout", OptionsContainer); UILayout.Padding = UDim.new(0, 10); UILayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; UILayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ✨ BOTÓN DE APERTURA (El icono que SÍ se ve) ✨
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 50, 0, 50)
OpenButton.Position = UDim2.new(0, 15, 1, -65)
OpenButton.BackgroundColor3 = Config.ColorPrincipal
OpenButton.BorderSizePixel = 0
OpenButton.Text = "✧" -- Un ícono de estrella / destello
OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.TextColor3 = Color3.fromRGB(30, 32, 38)
OpenButton.TextSize = 32
OpenButton.Parent = ScreenGui
local OpenCorner = Instance.new("UICorner", OpenButton); OpenCorner.CornerRadius = UDim.new(1,0)

-- =========================================================================================
--                          FUNCIONES AUXILIARES Y ANIMACIONES
-- =========================================================================================

local function notify(message, duration)
    StatusText.Text = tostring(message)
    wait(duration or 2)
    StatusText.Text = "Esperando acción..."
end

local dragging = false; local dragStart; local startPos
Header.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = MainFrame.Position end end)
Header.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

-- LÓGICA DE ABRIR Y CERRAR
OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- =========================================================================================
--                          DEFINICIÓN DE OPCIONES Y LÓGICA
-- =========================================================================================

local function crearInterruptor(text, callback)
    local frame = Instance.new("Frame"); frame.Size = UDim2.new(1, -20, 0, 40); frame.BackgroundColor3 = Color3.fromRGB(45, 47, 54); frame.BorderSizePixel = 0; frame.Parent = OptionsContainer; local corner = Instance.new("UICorner", frame); corner.CornerRadius = UDim.new(0, 6)
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(0.6, 0, 1, 0); label.Position = UDim2.new(0, 10, 0, 0); label.Text = text; label.Font = Enum.Font.SourceSans; label.TextSize = 16; label.TextColor3 = Color3.new(1,1,1); label.BackgroundTransparency = 1; label.TextXAlignment = Enum.TextXAlignment.Left
    local switch = Instance.new("TextButton"); switch.Size = UDim2.new(0.3, 0, 0, 24); switch.Position = UDim2.new(1, -10 - (frame.AbsoluteSize.X * 0.3), 0.5, -12); switch.BackgroundColor3 = Color3.fromRGB(70, 70, 70); switch.Text = ""; switch.Parent = frame; local switchCorner = Instance.new("UICorner", switch); switchCorner.CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame", switch); knob.Size = UDim2.new(0, 20, 0, 20); knob.Position = UDim2.new(0, 2, 0.5, -10); knob.BackgroundColor3 = Color3.fromRGB(150, 150, 150); local knobCorner = Instance.new("UICorner", knob); knobCorner.CornerRadius = UDim.new(1, 0)
    local state = false
    switch.MouseButton1Click:Connect(function()
        state = not state
        local goalPos = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        local goalColor = state and Config.ColorPrincipal or Color3.fromRGB(70, 70, 70)
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = goalPos}):Play()
        TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = goalColor}):Play()
        callback(state)
    end)
end

local function crearBotonAccion(text, callback)
    local button = Instance.new("TextButton"); button.Size = UDim2.new(1, -20, 0, 40); button.Text = text; button.Font = Enum.Font.SourceSansSemibold; button.TextSize = 16; button.TextColor3 = Color3.new(1,1,1); button.BackgroundColor3 = Color3.fromRGB(45, 47, 54); button.Parent = OptionsContainer; local corner = Instance.new("UICorner", button); corner.CornerRadius = UDim.new(0, 6)
    button.MouseEnter:Connect(function() TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Config.ColorPrincipal}):Play() end)
    button.MouseLeave:Connect(function() TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 47, 54)}):Play() end)
    button.MouseButton1Click:Connect(function() callback(button) end)
end

local noClipConnection = nil
crearInterruptor("Obligatorio (No-Clip)", function(activado)
    if activado then notify("No-Clip: ACTIVADO"); noClipConnection = RunService.Stepped:Connect(function() if player.Character then for _, part in ipairs(player.Character:GetDescendants()) do if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end end end end)
    else notify("No-Clip: DESACTIVADO"); if noClipConnection then noClipConnection:Disconnect(); noClipConnection = nil end end
end)

local function executeScript(button, url)
    spawn(function()
        local originalText = button.Text; notify("Ejecutando '"..originalText.."'..."); local success, result = pcall(function() loadstring(game:HttpGet(url))() end)
        if success then notify("'"..originalText.."' ejecutado.") else notify("Error al ejecutar script."); warn("ERROR EN "..originalText..": " .. tostring(result)) end
    end)
end

crearBotonAccion("Ejecutar 'Salto Infinito'", function(b) executeScript(b, "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua") end)
crearBotonAccion("Ejecutar 'Servidores'", function(b) executeScript(b, "https://api.luarmor.net/files/v3/loaders/f927290098f4333a9d217cbecbe6e988.lua") end)
crearBotonAccion("Ejecutar 'Auto Base'", function(b) executeScript(b, "https://gist.githubusercontent.com/UCT-hub/5b11d10386f1b8ce08feb803861e0b79/raw/b2917b398d4b0cc80fb2aca73a3137ba494ebcf0/gistfile1.txt") end)

