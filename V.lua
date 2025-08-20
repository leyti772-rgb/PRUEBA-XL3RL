-- =========================================================================================
--                                   MAIN SCRIPT
-- =========================================================================================
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local UI = {
    Config = {
        MainColor = Color3.fromRGB(0, 170, 255),
        BackgroundColor = Color3.fromRGB(25, 25, 25),
        SolidBackgroundColor = Color3.fromRGB(40, 40, 40),
        BrightTextColor = Color3.fromRGB(255, 255, 255)
    },
    Functions = {},
    Features = {}
}

-- =========================================================================================
--                                   CREATE ELEMENT
-- =========================================================================================
function UI.Functions.CreateElement(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props) do obj[k] = v end
    if parent then obj.Parent = parent end
    return obj
end

-- =========================================================================================
--                                   MAKE DRAGGABLE
-- =========================================================================================
function UI.Functions.MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- =========================================================================================
--                                   MAIN GUI
-- =========================================================================================
local screenGui = UI.Functions.CreateElement("ScreenGui", { Name = "XL3RL", ResetOnSpawn = false }, player:WaitForChild("PlayerGui"))

-- Panel principal
local mainFrame = UI.Functions.CreateElement("Frame", {
    Name = "MainFrame", Size = UDim2.new(0, 200, 0, 150), Position = UDim2.new(0.8, 0, 0.4, 0),
    BackgroundColor3 = UI.Config.BackgroundColor, Visible = true
}, screenGui)
UI.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 4) }, mainFrame)
UI.Functions.CreateElement("UIStroke", { Color = UI.Config.MainColor, Thickness = 1.5 }, mainFrame)

-- Título
UI.Functions.CreateElement("TextLabel", {
    Size = UDim2.new(1, 0, 0, 30), Text = "XL3RL", Font = Enum.Font.Code,
    TextSize = 18, TextColor3 = UI.Config.MainColor, BackgroundTransparency = 1
}, mainFrame)

-- Lista
local list = UI.Functions.CreateElement("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, mainFrame)

-- Botones del menú
local function createMenuButton(text, callback)
    local btn = UI.Functions.CreateElement("TextButton", {
        Size = UDim2.new(1, -20, 0, 28), Text = ">"..text, Font = Enum.Font.Code,
        TextSize = 14, TextColor3 = UI.Config.BrightTextColor, BackgroundColor3 = UI.Config.SolidBackgroundColor,
        Parent = mainFrame
    })
    UI.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 4) }, btn)
    btn.MouseButton1Click:Connect(callback)
end

-- =========================================================================================
--                                   NOCLIP FEATURE
-- =========================================================================================
function UI.Features:NoClip(enable)
    if enable then
        self.ncConnection = game:GetService("RunService").Stepped:Connect(function()
            for _,v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
            end
        end)
    else
        if self.ncConnection then self.ncConnection:Disconnect() self.ncConnection = nil end
    end
end

-- =========================================================================================
--                                   NOCLIP PANEL (FIX)
-- =========================================================================================
local noClipFrame = UI.Functions.CreateElement("Frame", {
    Name = "NoClipFrame", Size = UDim2.new(0, 200, 0, 120), Position = UDim2.new(0.5, -100, 0.5, -60),
    BackgroundColor3 = UI.Config.SolidBackgroundColor, BackgroundTransparency = 0, Visible = false, ZIndex = 50
}, screenGui)
UI.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 4) }, noClipFrame)
UI.Functions.CreateElement("UIStroke", { Color = UI.Config.MainColor, Thickness = 1 }, noClipFrame)

-- Titulo
UI.Functions.CreateElement("TextLabel", {
    Size = UDim2.new(1, 0, 0, 30), Text = "NO-CLIP", Font = Enum.Font.Code,
    TextSize = 16, TextColor3 = UI.Config.MainColor, BackgroundTransparency = 1
}, noClipFrame)

-- Boton cerrar
local ncClose = UI.Functions.CreateElement("TextButton", {
    Size = UDim2.new(0, 25, 0, 25), Position = UDim2.new(1, -28, 0, 3), Text = "X",
    Font = Enum.Font.Code, TextColor3 = UI.Config.BrightTextColor, TextSize=16, BackgroundTransparency = 1
}, noClipFrame)
UI.Functions.MakeDraggable(noClipFrame, noClipFrame)
ncClose.MouseButton1Click:Connect(function() noClipFrame.Visible = false end)

-- Contenedor scrollable
local ncContent = UI.Functions.CreateElement("ScrollingFrame", {
    Name = "ncContent", Size = UDim2.new(1, -10, 1, -40), Position = UDim2.new(0, 5, 0, 35),
    BackgroundTransparency = 1, ScrollBarThickness = 4, Parent = noClipFrame
})
local ncLayout = UI.Functions.CreateElement("UIListLayout", {
    Padding = UDim.new(0, 5), HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
}, ncContent)
ncLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ncContent.CanvasSize = UDim2.new(0, 0, 0, ncLayout.AbsoluteContentSize.Y)
end)

-- Boton activar/desactivar
local toggleFrame = UI.Functions.CreateElement("Frame", {
    Size = UDim2.new(1, -10, 0, 40), BackgroundTransparency = 1, Parent = ncContent
})
UI.Functions.CreateElement("TextLabel", {
    Size = UDim2.new(0.6, 0, 1, 0), Position = UDim2.new(0, 5, 0, 0), Text = "ACTIVAR",
    Font = Enum.Font.Code, TextSize = 14, TextColor3 = UI.Config.BrightTextColor,
    BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = toggleFrame
})
local toggleButton = UI.Functions.CreateElement("TextButton", {
    Size = UDim2.new(0, 45, 0, 22), Position = UDim2.new(1, -55, 0.5, -11),
    BackgroundColor3 = UI.Config.BackgroundColor, Text = "", AutoButtonColor = false, Parent = toggleFrame
})
UI.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 4) }, toggleButton)
UI.Functions.CreateElement("UIStroke", { Color = UI.Config.MainColor, Thickness = 1.5 }, toggleButton)
local knob = UI.Functions.CreateElement("Frame", {
    Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 3, 0.5, -8),
    BackgroundColor3 = UI.Config.MainColor, Parent = toggleButton
})
UI.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 2) }, knob)

-- Estado del toggle
local isEnabled = false
toggleButton.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    local knobPosition = isEnabled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    TweenService:Create(knob, TweenInfo.new(0.2), { Position = knobPosition }):Play()
    UI.Features:NoClip(isEnabled)
end)

-- =========================================================================================
--                                   MENU BUTTONS
-- =========================================================================================
createMenuButton("PANEL NO-CLIP", function() noClipFrame.Visible = not noClipFrame.Visible end)
createMenuButton("COMBO SCRIPTS", function() print("Abrir combo") end)
createMenuButton("CAMBIAR SERVIDOR", function() print("Cambiar server") end)
