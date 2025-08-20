--[[
    SCRIPT: XL3RL - V3.1 (Mejora Visual y Traducción)
    AUTOR: Gemini
    DESCRIPCIÓN: Versión modificada para mejorar la estética y la experiencia de usuario.
                 - Paleta de colores más brillante y con mayor contraste.
                 - Interfaz de usuario completamente en español.
                 - Código limpiado de comentarios innecesarios.
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
    MainColor = Color3.fromRGB(170, 120, 255),   -- Púrpura más brillante
    BackgroundColor = Color3.fromRGB(35, 36, 42), -- Fondo oscuro ligeramente más claro
    MutedColor = Color3.fromRGB(60, 62, 70),      -- Color para elementos inactivos
    TextColor = Color3.fromRGB(250, 250, 250),    -- Texto casi blanco para máximo contraste
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
    self.UI.StatusText.Text = tostring(message)
    task.wait(duration or 2)
    self.UI.StatusText.Text = ""
end

Library.UI = {}

function Library.UI:CreateActionButton(text, callback)
    local button = Library.Functions.CreateElement("TextButton", {
        Size = UDim2.new(1, -20, 0, 40),
        Text = "",
        BackgroundColor3 = Library.Config.MainColor,
        BackgroundTransparency = 1,
        AutoButtonColor = false
    }, Library.UI.OptionsContainer)
    
    Library.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 6) }, button)
    Library.Functions.CreateElement("UIStroke", {
        Color = Library.Config.MainColor,
        Thickness = 1.5,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, button)
    local label = Library.Functions.CreateElement("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        Text = text,
        Font = Enum.Font.GothamSemibold,
        TextSize = 15,
        TextColor3 = Library.Config.TextColor,
        BackgroundTransparency = 1
    }, button)

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), { BackgroundTransparency = 0.85 }):Play()
        TweenService:Create(label, TweenInfo.new(0.2), { TextColor3 = Color3.new(1,1,1) }):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(label, TweenInfo.new(0.2), { TextColor3 = Library.Config.TextColor }):Play()
    end)

    button.MouseButton1Click:Connect(function()
        callback(button)
    end)

    return button
end

function Library.UI:CreateToggle(parent, text, callback)
    local frame = Library.Functions.CreateElement("Frame", {
        Size = UDim2.new(1, -20, 0, 40),
        BackgroundColor3 = Library.Config.MutedColor,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0
    }, parent)
    Library.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 6) }, frame)

    Library.Functions.CreateElement("TextLabel", {
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        Text = text,
        Font = Enum.Font.Gotham,
        TextSize = 15,
        TextColor3 = Library.Config.TextColor,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    }, frame)

    local toggleButton = Library.Functions.CreateElement("TextButton", {
        Size = UDim2.new(0, 50, 0, 25),
        Position = UDim2.new(1, -65, 0.5, -12.5),
        BackgroundColor3 = Library.Config.MutedColor,
        Text = "",
        AutoButtonColor = false
    }, frame)
    Library.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(1, 0) }, toggleButton)

    local knob = Library.Functions.CreateElement("Frame", {
        Size = UDim2.new(0, 21, 0, 21),
        Position = UDim2.new(0, 2, 0.5, -10.5),
        BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    }, toggleButton)
    Library.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(1, 0) }, knob)

    local isEnabled = false
    toggleButton.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        local knobPosition = isEnabled and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
        local bgColor = isEnabled and Library.Config.MainColor or Library.Config.MutedColor

        TweenService:Create(knob, TweenInfo.new(0.2), { Position = knobPosition }):Play()
        TweenService:Create(toggleButton, TweenInfo.new(0.2), { BackgroundColor3 = bgColor }):Play()
        
        callback(isEnabled)
    end)
end

Library.Features = {}

function Library.Features:NoClip(isEnabled)
    if isEnabled then
        Library:Notify("No-Clip: Activado", 2)
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
        Library:Notify("No-Clip: Desactivado", 2)
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
        
        label.Text = "Cargando..."
        button.BackgroundTransparency = 0.7

        for i, url in ipairs(urlList) do
            Library:Notify("Ejecutando " .. i .. "/" .. #urlList, 1)
            local success, result = pcall(function()
                loadstring(game:HttpGet(url))()
            end)

            if not success then
                Library:Notify("Error en script " .. i, 2)
                warn("XL3RL ERROR DE SCRIPT: " .. tostring(result))
                break 
            end
        end

        label.Text = originalText
        TweenService:Create(button, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
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

    local mainFrame = self.Functions.CreateElement("Frame", {
        Size = UDim2.new(0, 280, 0, 360),
        Position = UDim2.new(0.5, -140, 0.5, -180),
        BackgroundColor3 = self.Config.BackgroundColor,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Visible = false
    }, screenGui)
    self.UI.MainFrame = mainFrame
    
    self.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 8) }, mainFrame)
    self.Functions.CreateElement("UIStroke", { Color = self.Config.MainColor, Thickness = 1.2, Transparency = 0.4 }, mainFrame)
    self.Functions.CreateElement("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, self.Config.BackgroundColor),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 40, 55))
        }),
        Rotation = 90
    }, mainFrame)

    self.Functions.CreateElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 40),
        Text = self.Config.Name,
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = self.Config.TextColor,
        BackgroundTransparency = 1
    }, mainFrame)

    self.Functions.CreateElement("Frame", {
        Size = UDim2.new(0.8, 0, 0, 1),
        Position = UDim2.new(0.1, 0, 0, 40),
        BackgroundColor3 = self.Config.MainColor,
        BorderSizePixel = 0,
        BackgroundTransparency = 0.5
    }, mainFrame)
    
    self.UI.StatusText = self.Functions.CreateElement("TextLabel", {
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 1, -25),
        Text = "",
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = self.Config.MutedColor,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    }, mainFrame)

    self.UI.OptionsContainer = self.Functions.CreateElement("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -75),
        Position = UDim2.new(0, 0, 0, 45),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarImageColor3 = self.Config.MainColor,
        ScrollBarThickness = 4
    }, mainFrame)
    
    local uiLayout = self.Functions.CreateElement("UIListLayout", {
        Padding = UDim.new(0, 8),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.UI.OptionsContainer
    })
    
    local openButton = self.Functions.CreateElement("Frame", {
        Name = "OpenButtonContainer",
        Size = UDim2.new(0, 48, 0, 48),
        Position = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = self.Config.BackgroundColor,
        BackgroundTransparency = 0.2,
        ZIndex = 10
    })
    self.UI.OpenButton = openButton
    self.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 8) }, openButton)
    self.Functions.CreateElement("UIStroke", { Color = self.Config.MainColor, Thickness = 1, Transparency = 0.5 }, openButton)
    
    for i = 1, 3 do
        self.Functions.CreateElement("Frame", {
            Size = UDim2.new(0.5, 0, 0, 2),
            Position = UDim2.new(0.25, 0, 0.2 + (i * 0.15), 0),
            BackgroundColor3 = self.Config.TextColor,
            BorderSizePixel = 0,
            ZIndex = 11
        }, openButton)
    end
    
    local openButtonTrigger = self.Functions.CreateElement("TextButton", {
        Size = UDim2.new(1,0,1,0),
        Text = "",
        BackgroundTransparency = 1,
        Parent = openButton
    })
    openButton.Parent = screenGui
    
    self.Functions.MakeDraggable(mainFrame, mainFrame)
    self.Functions.MakeDraggable(openButton, openButton)

    local function toggleMenu()
        mainFrame.Visible = not mainFrame.Visible
        if mainFrame.Visible then self:Notify("Menú Abierto", 1) else self:Notify("Menú Cerrado", 1) end
    end
    openButtonTrigger.MouseButton1Click:Connect(toggleMenu)

    local noClipFrame = self.Functions.CreateElement("Frame", {
        Name = "NoClipFrame",
        Size = UDim2.new(0, 260, 0, 140),
        Position = UDim2.new(0.5, -130, 0.5, -70),
        BackgroundColor3 = self.Config.BackgroundColor,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 20
    }, screenGui)
    
    self.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 8) }, noClipFrame)
    self.Functions.CreateElement("UIStroke", { Color = self.Config.MainColor, Thickness = 1, Transparency = 0.5 }, noClipFrame)
    self.Functions.CreateElement("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, self.Config.BackgroundColor),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 40, 55))
        }), Rotation = 90
    }, noClipFrame)

    self.Functions.CreateElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 40), Text = "Menú No-Clip",
        Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = self.Config.TextColor,
        BackgroundTransparency = 1
    }, noClipFrame)

    self.Functions.CreateElement("Frame", {
        Size = UDim2.new(0.8, 0, 0, 1), Position = UDim2.new(0.1, 0, 0, 40),
        BackgroundColor3 = self.Config.MainColor, BorderSizePixel = 0, BackgroundTransparency = 0.5
    }, noClipFrame)
    
    local ncClose = self.Functions.CreateElement("TextButton", {
        Size = UDim2.new(0, 25, 0, 25), Position = UDim2.new(1, -35, 0, 8),
        Text = "X", Font = Enum.Font.GothamBold, TextColor3 = self.Config.TextColor,
        TextSize=16, BackgroundTransparency = 1
    }, noClipFrame)
    
    self.Functions.MakeDraggable(noClipFrame, noClipFrame)
    ncClose.MouseButton1Click:Connect(function()
        noClipFrame.Visible = false
        self:Notify("Panel de No-Clip cerrado", 1)
    end)
    
    local ncContent = self.Functions.CreateElement("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -45), Position = UDim2.new(0, 0, 0, 45),
        BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(0,0,0,0),
        ScrollBarThickness = 0
    }, noClipFrame)

    self.Functions.CreateElement("UIListLayout", {
        Padding = UDim.new(0, 10), HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = ncContent
    })
    
    self.UI:CreateToggle(ncContent, "Activar No-Clip", function(state) self.Features:NoClip(state) end)

    self.UI:CreateActionButton("NO-CLIP", function()
        noClipFrame.Visible = true
        self:Notify("Panel de No-Clip abierto", 1)
    end)
    
    self.UI:CreateActionButton("SCRIPT COMBO", function(button)
        self.Features:ExecuteScript(button, {
            "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua",
            "https://gist.githubusercontent.com/UCT-hub/5b11d10386f1b8ce08feb803861e0b79/raw/b2917b398d4b0cc80fb2aca73a3137ba494ebcf0/gistfile1.txt"
        })
    end)
    
    self.UI:CreateActionButton("CAMBIAR SERVIDOR", function(button)
        self.Features:ExecuteScript(button, "https://raw.githubusercontent.com/Gato-bytes/GatoHubOnTop/refs/heads/main/AutoJoin.lua")
    end)
    
    self.UI:CreateActionButton("REINICIAR PERSONAJE", function()
        self:Notify("Reiniciando personaje...", 1)
        if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
    end)

    uiLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.UI.OptionsContainer.CanvasSize = UDim2.new(0, 0, 0, uiLayout.AbsoluteContentSize.Y + 10)
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == self.Config.Keybind then
            toggleMenu()
        end
    end)

    self:Notify("XL3RL V3.1 Cargado", 3)
end

Library:Initialize()
