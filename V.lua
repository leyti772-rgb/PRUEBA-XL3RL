--[[
    SCRIPT: XL3RL - V4.3 (VERSIÓN CORREGIDA)
    AUTOR: Gemini
    DESCRIPCIÓN: Corrección final de errores de visibilidad y diseño.
                 - Solucionado el error que causaba que el panel No-Clip apareciera vacío.
                 - Eliminado el espacio sobrante en la parte inferior del menú principal.
                 - Mantiene el diseño ultra-compacto y 100% visible.
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
    MainColor = Color3.fromRGB(0, 255, 255),
    BackgroundColor = Color3.fromRGB(10, 12, 18),
    SolidBackgroundColor = Color3.fromRGB(25, 27, 35),
    TextColor = Color3.fromRGB(230, 255, 255),
    BrightTextColor = Color3.fromRGB(255, 255, 255),
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
    TweenService:Create(notificationFrame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -125, 0, 20)}):Play()
    task.wait(duration or 2)
    local tweenOut = TweenService:Create(notificationFrame, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -125, 0, -50)})
    tweenOut:Play()
    tweenOut.Completed:Wait()
    notificationFrame.Visible = false
end

Library.UI = {}

function Library.UI:CreateActionButton(text, callback)
    local button = Library.Functions.CreateElement("TextButton", {
        Size = UDim2.new(1, -16, 0, 32),
        Text = "",
        BackgroundColor3 = Library.Config.BackgroundColor,
        AutoButtonColor = false
    }, Library.UI.OptionsContainer)
    Library.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 4) }, button)
    local stroke = Library.Functions.CreateElement("UIStroke", { Color = Library.Config.MainColor, Thickness = 1 }, button)
    local label = Library.Functions.CreateElement("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        Text = " " .. text,
        Font = Enum.Font.Code,
        TextSize = 13,
        TextColor3 = Library.Config.TextColor,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 5, 0, 0)
    }, button)
    Library.Functions.CreateElement("TextLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        Text = ">",
        Font = Enum.Font.Code,
        TextSize = 13,
        TextColor3 = Library.Config.MainColor,
        BackgroundTransparency = 1
    }, label)
    button.MouseEnter:Connect(function() TweenService:Create(stroke, TweenInfo.new(0.2), { Color = Color3.new(1,1,1) }):Play() end)
    button.MouseLeave:Connect(function() TweenService:Create(stroke, TweenInfo.new(0.2), { Color = Library.Config.MainColor }):Play() end)
    button.MouseButton1Click:Connect(function() callback(button) end)
    return button
end

-- CORRECCIÓN: La función ahora está autocontenida y funciona correctamente
function Library.UI:CreateToggleForNoClip(parent, text, callback)
    local frame = Library.Functions.CreateElement("Frame", {
        Size = UDim2.new(1, -16, 0, 40),
        Position = UDim2.new(0.5, -((parent.AbsoluteSize.X-16)/2), 0, 10),
        BackgroundTransparency = 1,
        Parent = parent
    })
    Library.Functions.CreateElement("TextLabel", {
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        Text = text,
        Font = Enum.Font.Code,
        TextSize = 14,
        TextColor3 = Library.Config.BrightTextColor,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    }, frame)
    local toggleButton = Library.Functions.CreateElement("TextButton", {
        Size = UDim2.new(0, 45, 0, 22),
        Position = UDim2.new(1, -50, 0.5, -11),
        BackgroundColor3 = Library.Config.BackgroundColor,
        Text = "",
        AutoButtonColor = false,
        Parent = frame
    })
    Library.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 4) }, toggleButton)
    Library.Functions.CreateElement("UIStroke", { Color = Library.Config.MainColor, Thickness = 1.5 }, toggleButton)
    local knob = Library.Functions.CreateElement("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 3, 0.5, -8),
        BackgroundColor3 = Library.Config.MainColor,
        Parent = toggleButton
    })
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
        label.Text = " > EJECUTANDO..."
        for i, url in ipairs((type(urls) == "table") and urls or {urls}) do
            Library:Notify("Cargando Script " .. i, 1)
            local s, r = pcall(function() loadstring(game:HttpGet(url))() end)
            if not s then Library:Notify("ERROR: Script " .. i .. " falló", 2); warn("XL3RL: "..tostring(r)); break end
        end
        label.Text = originalText
        Library:Notify("Ejecución completada", 2)
    end)
end

function Library:Initialize()
    pcall(function() if LocalPlayer.PlayerGui:FindFirstChild("XL3RL_GUI") then LocalPlayer.PlayerGui.XL3RL_GUI:Destroy() end end)
    
    self.Connections = {}
    local screenGui = self.Functions.CreateElement("ScreenGui", { Name = "XL3RL_GUI", Parent = LocalPlayer.PlayerGui, ResetOnSpawn = false })
    self.UI.ScreenGui = screenGui

    -- CORRECCIÓN: Tamaño ajustado para eliminar espacio
    local mainFrame = self.Functions.CreateElement("Frame", {
        Size = UDim2.new(0, 220, 0, 190),
        Position = UDim2.new(0.5, -110, 0.5, -95),
        BackgroundColor3 = self.Config.BackgroundColor,
        BackgroundTransparency = 0.1,
        Visible = false
    }, screenGui)
    self.UI.MainFrame = mainFrame
    self.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 6) }, mainFrame)
    self.Functions.CreateElement("UIStroke", { Color = self.Config.MainColor, Thickness = 1, Transparency = 0.2 }, mainFrame)

    local titleLabel = self.Functions.CreateElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 35),
        Text = self.Config.Name,
        Font = Enum.Font.Code,
        TextSize = 20,
        TextColor3 = self.Config.TextColor,
        BackgroundTransparency = 1
    }, mainFrame)

    self.UI.OptionsContainer = self.Functions.CreateElement("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -45),
        Position = UDim2.new(0, 0, 0, 35),
        BackgroundTransparency = 1,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarImageColor3 = self.Config.MainColor,
        ScrollBarThickness = 3
    }, mainFrame)
    
    local uiLayout = self.Functions.CreateElement("UIListLayout", {
        Padding = UDim.new(0, 6),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = self.UI.OptionsContainer,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    local openButton = self.Functions.CreateElement("Frame", {
        Size = UDim2.new(0, 42, 0, 42),
        Position = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = self.Config.BackgroundColor,
        BackgroundTransparency = 0.2, ZIndex = 10
    }, screenGui)
    self.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 6) }, openButton)
    self.Functions.CreateElement("UIStroke", { Color = self.Config.MainColor, Thickness = 1, Transparency = 0.3 }, openButton)
    self.Functions.CreateElement("ImageLabel", {
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
        Image = "rbxassetid://3926305904", ImageColor3 = self.Config.MainColor,
        BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Fit
    }, openButton)
    
    local openButtonTrigger = self.Functions.CreateElement("TextButton", { Size = UDim2.fromScale(1,1), Text = "", BackgroundTransparency = 1, Parent = openButton })
    
    self.Functions.MakeDraggable(mainFrame, titleLabel)
    self.Functions.MakeDraggable(openButton, openButton)
    openButtonTrigger.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)

    self.UI.NotificationFrame = self.Functions.CreateElement("Frame", {
        Size = UDim2.new(0, 250, 0, 40), Position = UDim2.new(0.5, -125, 0, -50),
        BackgroundColor3 = self.Config.BackgroundColor, BackgroundTransparency = 0.1,
        Visible = false, ZIndex = 100
    }, screenGui)
    self.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 6) }, self.UI.NotificationFrame)
    self.Functions.CreateElement("UIStroke", { Color = self.Config.MainColor, Thickness = 1.5 }, self.UI.NotificationFrame)
    self.Functions.CreateElement("TextLabel", {
        Name = "NotificationLabel", Size = UDim2.fromScale(1,1),
        Text = "", Font = Enum.Font.Code, TextSize = 14,
        TextColor3 = self.Config.TextColor, BackgroundTransparency = 1
    }, self.UI.NotificationFrame)

    local noClipFrame = self.Functions.CreateElement("Frame", {
        Name = "NoClipFrame",
        Size = UDim2.new(0, 200, 0, 100),
        Position = UDim2.new(0.5, -100, 0.5, -50),
        BackgroundColor3 = self.Config.SolidBackgroundColor,
        BackgroundTransparency = 0,
        Visible = false,
        ZIndex = 50
    }, screenGui)
    self.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 4) }, noClipFrame)
    self.Functions.CreateElement("UIStroke", { Color = self.Config.MainColor, Thickness = 1 }, noClipFrame)
    self.Functions.CreateElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30), Text = "NO-CLIP",
        Font = Enum.Font.Code, TextSize = 16, TextColor3 = self.Config.MainColor,
        BackgroundTransparency = 1
    }, noClipFrame)
    local ncClose = self.Functions.CreateElement("TextButton", {
        Size = UDim2.new(0, 25, 0, 25), Position = UDim2.new(1, -28, 0, 3),
        Text = "X", Font = Enum.Font.Code, TextColor3 = self.Config.BrightTextColor,
        TextSize=16, BackgroundTransparency = 1
    }, noClipFrame)
    self.Functions.MakeDraggable(noClipFrame, noClipFrame)
    ncClose.MouseButton1Click:Connect(function() noClipFrame.Visible = false end)
    
    local ncContent = self.Functions.CreateElement("Frame", {
        Size = UDim2.new(1, 0, 1, -30), Position = UDim2.new(0, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = noClipFrame
    })
    
    -- CORRECCIÓN: Llamando a la función corregida para crear el toggle
    self.UI:CreateToggleForNoClip(ncContent, "ACTIVAR", function(state) self.Features:NoClip(state) end)

    -- Creación de botones
    self.UI:CreateActionButton("PANEL NO-CLIP", function() noClipFrame.Visible = true end)
    self.UI:CreateActionButton("COMBO SCRIPTS", function(b) self.Features:ExecuteScript(b, {"https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua", "https://gist.githubusercontent.com/UCT-hub/5b11d1b8ce08feb803861e0b79/raw/b2917b398d4b0cc80fb2aca73a3137ba494ebcf0/gistfile1.txt"}) end)
    self.UI:CreateActionButton("CAMBIAR SERVIDOR", function(b) self.Features:ExecuteScript(b, "https://raw.githubusercontent.com/Gato-bytes/GatoHubOnTop/refs/heads/main/AutoJoin.lua") end)

    -- CORRECCIÓN: Cálculo del CanvasSize para eliminar espacio
    uiLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.UI.OptionsContainer.CanvasSize = UDim2.new(0, 0, 0, uiLayout.AbsoluteContentSize.Y)
    end)
    self.UI.OptionsContainer.CanvasSize = UDim2.new(0, 0, 0, uiLayout.AbsoluteContentSize.Y)

    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == self.Config.Keybind then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)

    self:Notify("XL3RL V4.3 [CORREGIDO] CARGADO", 3)
end

Library:Initialize()
