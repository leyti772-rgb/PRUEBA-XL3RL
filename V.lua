--[[
    SCRIPT: XL3RL - V4.1 (EDICIÓN COMPACTA)
    AUTOR: Gemini
    DESCRIPCIÓN: Versión optimizada para ser más pequeña y con máxima visibilidad.
                 - Tamaño de todos los menús reducido.
                 - Panel No-Clip con fondo más opaco y texto blanco puro para visibilidad total.
                 - Interfaz ajustada para el nuevo tamaño compacto.
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Library = {}
Library.__index = Library

Library.Config = {
    Name = "XL3RL",
    MainColor = Color3.fromRGB(0, 255, 255),      -- Cian Neón Brillante
    BackgroundColor = Color3.fromRGB(10, 12, 18), -- Negro Futurista
    MutedColor = Color3.fromRGB(30, 35, 45),      -- Gris Oscuro Tecnológico
    TextColor = Color3.fromRGB(230, 255, 255),    -- Texto Cian Claro
    BrightTextColor = Color3.fromRGB(255, 255, 255), -- BLANCO PURO para máxima visibilidad
    Keybind = Enum.KeyCode.RightShift
}

Library.Functions = {}

function Library.Functions.CreateElement(className, properties, parent)
    local element = Instance.new(className)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    if parent then
        element.Parent = parent
    end
    return element
end

function Library.Functions.MakeDraggable(frame, trigger)
    local isDragging = false
    local startPosition, dragStartPosition

    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            startPosition = frame.Position
            dragStartPosition = input.Position
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
            local delta = input.Position - dragStartPosition
            frame.Position = UDim2.fromOffset(startPosition.X.Offset + delta.X, startPosition.Y.Offset + delta.Y)
        end
    end)
end

function Library:Notify(message, duration)
    local notificationFrame = self.UI.NotificationFrame
    local notificationLabel = notificationFrame:FindFirstChild("NotificationLabel")
    
    notificationLabel.Text = message
    notificationFrame.Visible = true
    
    TweenService:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -125, 0, 20)}):Play()
    
    task.wait(duration or 2)
    
    local tweenOut = TweenService:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -125, 0, -50)})
    tweenOut:Play()
    tweenOut.Completed:Wait()
    notificationFrame.Visible = false
end

Library.UI = {}

function Library.UI:CreateActionButton(text, callback)
    local button = Library.Functions.CreateElement("TextButton", {
        Size = UDim2.new(1, -16, 0, 35), -- Más pequeño
        Text = "",
        BackgroundColor3 = Library.Config.BackgroundColor,
        AutoButtonColor = false
    }, Library.UI.OptionsContainer)
    
    Library.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 4) }, button)
    local stroke = Library.Functions.CreateElement("UIStroke", {
        Color = Library.Config.MainColor,
        Thickness = 1.5,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, button)
    
    local label = Library.Functions.CreateElement("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        Text = " " .. text,
        Font = Enum.Font.Code,
        TextSize = 14, -- Más pequeño
        TextColor3 = Library.Config.TextColor,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    }, button)
    
    Library.Functions.CreateElement("TextLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 25, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        Text = ">",
        Font = Enum.Font.Code,
        TextSize = 14, -- Más pequeño
        TextColor3 = Library.Config.MainColor,
        BackgroundTransparency = 1
    }, label)

    button.MouseEnter:Connect(function()
        TweenService:Create(stroke, TweenInfo.new(0.2), { Color = Color3.new(1,1,1) }):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(stroke, TweenInfo.new(0.2), { Color = Library.Config.MainColor }):Play()
    end)

    button.MouseButton1Click:Connect(function()
        callback(button)
    end)

    return button
end

function Library.UI:CreateToggle(parent, text, callback)
    local frame = Library.Functions.CreateElement("Frame", {
        Size = UDim2.new(1, -16, 0, 40),
        BackgroundColor3 = Library.Config.MutedColor,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0
    }, parent)
    Library.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 4) }, frame)

    Library.Functions.CreateElement("TextLabel", {
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        Text = text,
        Font = Enum.Font.Code,
        TextSize = 14, -- Más pequeño
        TextColor3 = Library.Config.BrightTextColor, -- MÁXIMO BRILLO
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    }, frame)

    local toggleButton = Library.Functions.CreateElement("TextButton", {
        Size = UDim2.new(0, 45, 0, 22),
        Position = UDim2.new(1, -60, 0.5, -11),
        BackgroundColor3 = Library.Config.BackgroundColor,
        Text = "",
        AutoButtonColor = false
    }, frame)
    Library.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 4) }, toggleButton)
    local stroke = Library.Functions.CreateElement("UIStroke", { Color = Library.Config.MainColor, Thickness = 1.5 }, toggleButton)

    local knob = Library.Functions.CreateElement("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 3, 0.5, -8),
        BackgroundColor3 = Library.Config.MainColor
    }, toggleButton)
    Library.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 2) }, knob)

    local isEnabled = false
    toggleButton.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        local knobPosition = isEnabled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        TweenService:Create(knob, TweenInfo.new(0.2), { Position = knobPosition }):Play()
        callback(isEnabled)
    end)
end

Library.Features = {}

function Library.Features:NoClip(isEnabled)
    if isEnabled then
        Library:Notify("No-Clip: [ACTIVADO]", 2)
        Library.Connections.NoClip = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        Library:Notify("No-Clip: [DESACTIVADO]", 2)
        if Library.Connections.NoClip then
            Library.Connections.NoClip:Disconnect()
            Library.Connections.NoClip = nil
        end
    end
end

function Library.Features:ExecuteScript(button, urls)
    task.spawn(function()
        local label = button:FindFirstChildOfClass("TextLabel")
        local originalText = label.Text
        local urlList = (type(urls) == "table") and urls or {urls}
        
        label.Text = " > EJECUTANDO..."
        for i, url in ipairs(urlList) do
            Library:Notify("Cargando Script " .. i .. "/" .. #urlList, 1)
            local success, result = pcall(function()
                loadstring(game:HttpGet(url))()
            end)
            if not success then
                Library:Notify("ERROR: Script " .. i .. " falló", 2)
                warn("XL3RL ERROR DE SCRIPT: " .. tostring(result))
                break 
            end
        end
        label.Text = originalText
        Library:Notify("Ejecución completada", 2)
    end)
end

function Library:Initialize()
    pcall(function()
        if LocalPlayer and LocalPlayer.PlayerGui:FindFirstChild("XL3RL_GUI") then
            LocalPlayer.PlayerGui.XL3RL_GUI:Destroy()
        end
    end)
    
    self.Connections = {}
    
    local screenGui = self.Functions.CreateElement("ScreenGui", {
        Name = "XL3RL_GUI",
        Parent = LocalPlayer.PlayerGui,
        ResetOnSpawn = false
    })
    self.UI.ScreenGui = screenGui

    -- CAMBIO: Menú principal más pequeño
    local mainFrame = self.Functions.CreateElement("Frame", {
        Size = UDim2.new(0, 240, 0, 320),
        Position = UDim2.new(0.5, -120, 0.5, -160),
        BackgroundColor3 = self.Config.BackgroundColor,
        BackgroundTransparency = 0.15,
        Visible = false
    }, screenGui)
    self.UI.MainFrame = mainFrame
    
    self.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 6) }, mainFrame)
    self.Functions.CreateElement("UIStroke", { Color = self.Config.MainColor, Thickness = 1.5, Transparency = 0.2 }, mainFrame)

    local titleLabel = self.Functions.CreateElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 40),
        Text = self.Config.Name,
        Font = Enum.Font.Code,
        TextSize = 22, -- Ajustado
        TextColor3 = self.Config.TextColor,
        BackgroundTransparency = 1
    }, mainFrame)
    self.Functions.CreateElement("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, self.Config.MainColor),
            ColorSequenceKeypoint.new(1, self.Config.BrightTextColor)
        })
    }, titleLabel)

    self.UI.OptionsContainer = self.Functions.CreateElement("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -50),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundTransparency = 1,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarImageColor3 = self.Config.MainColor,
        ScrollBarThickness = 4
    }, mainFrame)
    
    local uiLayout = self.Functions.CreateElement("UIListLayout", {
        Padding = UDim.new(0, 8),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = self.UI.OptionsContainer
    })
    
    local openButton = self.Functions.CreateElement("Frame", {
        Name = "OpenButtonContainer",
        Size = UDim2.new(0, 45, 0, 45), -- Más pequeño
        Position = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = self.Config.BackgroundColor,
        BackgroundTransparency = 0.2,
        ZIndex = 10
    }, screenGui)
    self.UI.OpenButton = openButton
    self.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 6) }, openButton)
    self.Functions.CreateElement("UIStroke", { Color = self.Config.MainColor, Thickness = 1, Transparency = 0.3 }, openButton)
    self.Functions.CreateElement("ImageLabel", {
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0.5, -0.5 * (45-10), 0.5, -0.5 * (45-10)),
        Image = "rbxassetid://3926305904",
        ImageColor3 = self.Config.MainColor,
        BackgroundTransparency = 1,
        ScaleType = Enum.ScaleType.Fit
    }, openButton)
    
    local openButtonTrigger = self.Functions.CreateElement("TextButton", {
        Size = UDim2.new(1,0,1,0), Text = "", BackgroundTransparency = 1, Parent = openButton
    })
    
    self.Functions.MakeDraggable(mainFrame, titleLabel)
    self.Functions.MakeDraggable(openButton, openButton)

    openButtonTrigger.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)

    self.UI.NotificationFrame = self.Functions.CreateElement("Frame", {
        Name = "NotificationFrame",
        Size = UDim2.new(0, 250, 0, 40),
        Position = UDim2.new(0.5, -125, 0, -50),
        BackgroundColor3 = self.Config.BackgroundColor,
        BackgroundTransparency = 0.1,
        Visible = false,
        ZIndex = 100
    }, screenGui)
    self.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 6) }, self.UI.NotificationFrame)
    self.Functions.CreateElement("UIStroke", { Color = self.Config.MainColor, Thickness = 1.5 }, self.UI.NotificationFrame)
    self.Functions.CreateElement("TextLabel", {
        Name = "NotificationLabel", Size = UDim2.new(1, 0, 1, 0),
        Text = "", Font = Enum.Font.Code, TextSize = 14,
        TextColor3 = self.Config.TextColor, BackgroundTransparency = 1
    }, self.UI.NotificationFrame)

    -- CAMBIO: Panel No-Clip más pequeño y visible
    local noClipFrame = self.Functions.CreateElement("Frame", {
        Name = "NoClipFrame",
        Size = UDim2.new(0, 220, 0, 120),
        Position = UDim2.new(0.5, -110, 0.5, -60),
        BackgroundColor3 = self.Config.BackgroundColor,
        BackgroundTransparency = 0.0, -- MÁS OPACO
        Visible = false,
        ZIndex = 20
    }, screenGui)
    
    self.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 6) }, noClipFrame)
    self.Functions.CreateElement("UIStroke", { Color = self.Config.MainColor, Thickness = 2 }, noClipFrame)

    self.Functions.CreateElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 40), Text = "PANEL NO-CLIP",
        Font = Enum.Font.Code, TextSize = 16, TextColor3 = self.Config.MainColor,
        BackgroundTransparency = 1
    }, noClipFrame)

    local ncClose = self.Functions.CreateElement("TextButton", {
        Size = UDim2.new(0, 25, 0, 25), Position = UDim2.new(1, -30, 0, 8),
        Text = "X", Font = Enum.Font.Code, TextColor3 = self.Config.BrightTextColor,
        TextSize=18, BackgroundTransparency = 1
    }, noClipFrame)
    
    self.Functions.MakeDraggable(noClipFrame, noClipFrame)
    ncClose.MouseButton1Click:Connect(function() noClipFrame.Visible = false end)
    
    local ncContent = self.Functions.CreateElement("Frame", {
        Size = UDim2.new(1, 0, 1, -45), Position = UDim2.new(0, 0, 0, 45),
        BackgroundTransparency = 1
    }, noClipFrame)

    self.Functions.CreateElement("UIListLayout", {
        Padding = UDim.new(0, 10), HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = ncContent
    })
    
    self.UI:CreateToggle(ncContent, "ACTIVAR NO-CLIP", function(state) self.Features:NoClip(state) end)

    self.UI:CreateActionButton("PANEL NO-CLIP", function() noClipFrame.Visible = true end)
    self.UI:CreateActionButton("COMBO SCRIPTS", function(b) self.Features:ExecuteScript(b, {"https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua", "https://gist.githubusercontent.com/UCT-hub/5b11d10386f1b8ce08feb803861e0b79/raw/b2917b398d4b0cc80fb2aca73a3137ba494ebcf0/gistfile1.txt"}) end)
    self.UI:CreateActionButton("CAMBIAR SERVIDOR", function(b) self.Features:ExecuteScript(b, "https://raw.githubusercontent.com/Gato-bytes/GatoHubOnTop/refs/heads/main/AutoJoin.lua") end)
    self.UI:CreateActionButton("REINICIAR PERSONAJE", function()
        if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
        self:Notify("Personaje Reiniciado", 1.5)
    end)

    uiLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.UI.OptionsContainer.CanvasSize = UDim2.new(0, 0, 0, uiLayout.AbsoluteContentSize.Y + 10)
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == self.Config.Keybind then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)

    self:Notify("XL3RL V4.1 [COMPACTO] CARGADO", 3)
end

Library:Initialize()
