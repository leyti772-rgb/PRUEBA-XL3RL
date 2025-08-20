--[[
    SCRIPT: XL3RL - V2 (Redesigned)
    AUTHOR: Gemini
    DESCRIPTION: Second version with a complete UI redesign based on user feedback.
                 Fixes the empty No-Clip panel bug and introduces a modern blue theme.
]]

-- =========================================================================================
--                                   SERVICES
-- =========================================================================================
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- =========================================================================================
--                                   MAIN LIBRARY
-- =========================================================================================
local Library = {}
Library.__index = Library

-- =========================================================================================
--                                   CONFIGURATION
-- =========================================================================================
Library.Config = {
    Name = "XL3RL",
    MainColor = Color3.fromRGB(0, 120, 255), -- New: Electric Blue theme
    FloatingIcon = "💠", -- New: Modern icon
    Keybind = Enum.KeyCode.RightShift
}

-- =========================================================================================
--                                   UTILITY FUNCTIONS
-- =========================================================================================
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
    local dragInput, startPosition, dragStartPosition

    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            startPosition = frame.Position
            dragStartPosition = input.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
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
    self.UI.StatusText.Text = "Status: Idle"
end

-- =========================================================================================
--                                   UI CREATION
-- =========================================================================================
Library.UI = {}

function Library.UI:CreateActionButton(text, callback)
    local button = Library.Functions.CreateElement("TextButton", {
        Size = UDim2.new(1, -20, 0, 45),
        Text = text,
        Font = Enum.Font.SourceSansSemibold,
        TextSize = 16,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundColor3 = Color3.fromRGB(45, 47, 54),
        AutoButtonColor = false
    }, Library.UI.OptionsContainer)
    Library.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 6) }, button)

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = Library.Config.MainColor }):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(45, 47, 54) }):Play()
    end)

    button.MouseButton1Click:Connect(function()
        callback(button)
    end)

    return button
end

function Library.UI:CreateToggle(parent, text, callback)
    local frame = Library.Functions.CreateElement("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(45, 47, 54),
        BorderSizePixel = 0
    }, parent)
    Library.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 6) }, frame)

    Library.Functions.CreateElement("TextLabel", {
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Text = text,
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    }, frame)

    local toggleButton = Library.Functions.CreateElement("TextButton", {
        Size = UDim2.new(0, 50, 0, 25),
        Position = UDim2.new(1, -60, 0.5, -12.5),
        BackgroundColor3 = Color3.fromRGB(70, 70, 70),
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
        local bgColor = isEnabled and Library.Config.MainColor or Color3.fromRGB(70, 70, 70)

        TweenService:Create(knob, TweenInfo.new(0.2), { Position = knobPosition }):Play()
        TweenService:Create(toggleButton, TweenInfo.new(0.2), { BackgroundColor3 = bgColor }):Play()
        
        callback(isEnabled)
    end)
end

-- =========================================================================================
--                                   FEATURE LOGIC
-- =========================================================================================
Library.Features = {}

function Library.Features:NoClip(isEnabled)
    if isEnabled then
        Library:Notify("No-Clip: Enabled", 2)
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
        Library:Notify("No-Clip: Disabled", 2)
        if Library.Connections.NoClip then
            Library.Connections.NoClip:Disconnect()
            Library.Connections.NoClip = nil
        end
    end
end

function Library.Features:ExecuteScript(button, urls)
    task.spawn(function()
        local originalText = button.Text
        local urlList = (type(urls) == "table") and urls or {urls}
        
        button.Text = "Loading..."
        TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(30, 30, 40) }):Play()

        for i, url in ipairs(urlList) do
            Library:Notify("Executing script " .. i .. "/" .. #urlList, 1)
            local success, result = pcall(function()
                loadstring(game:HttpGet(url))()
            end)

            if not success then
                Library:Notify("Error in script " .. i, 2)
                warn("XL3RL SCRIPT ERROR: " .. tostring(result))
                break 
            end
        end

        button.Text = originalText
        TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(45, 47, 54) }):Play()
        Library:Notify("Execution complete", 2)
    end)
end

-- =========================================================================================
--                                   INITIALIZATION
-- =========================================================================================

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
        Size = UDim2.new(0, 300, 0, 400),
        Position = UDim2.new(0.5, -150, 0.5, -200),
        BackgroundColor3 = Color3.fromRGB(28, 29, 34), -- New color
        BorderSizePixel = 0,
        Visible = false
    }, screenGui)
    self.UI.MainFrame = mainFrame
    
    self.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 8) }, mainFrame)
    self.Functions.CreateElement("UIStroke", { Color = self.Config.MainColor, Thickness = 1.5 }, mainFrame)

    local header = self.Functions.CreateElement("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(35, 36, 42), -- New color
        BorderSizePixel = 0
    }, mainFrame)
    self.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 8) }, header)
    
    self.Functions.CreateElement("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        Text = self.Config.Name,
        Font = Enum.Font.GothamSemibold, -- New font
        TextSize = 18,
        TextColor3 = self.Config.MainColor,
        BackgroundTransparency = 1
    }, header)

    local statusBar = self.Functions.CreateElement("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 1, -30),
        BackgroundColor3 = Color3.fromRGB(35, 36, 42), -- New color
        BorderSizePixel = 0
    }, mainFrame)
    self.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 8) }, statusBar)
    
    self.UI.StatusText = self.Functions.CreateElement("TextLabel", {
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        Text = "Initialized successfully.",
        Font = Enum.Font.SourceSans,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(150, 150, 150),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    }, statusBar)

    self.UI.OptionsContainer = self.Functions.CreateElement("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -70),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarImageColor3 = self.Config.MainColor,
        ScrollBarThickness = 4
    }, mainFrame)
    
    local uiLayout = self.Functions.CreateElement("UIListLayout", {
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.UI.OptionsContainer
    })
    self.Functions.CreateElement("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        Parent = self.UI.OptionsContainer
    })

    local openButton = self.Functions.CreateElement("TextButton", {
        Size = UDim2.new(0, 60, 0, 60),
        Position = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = self.Config.MainColor,
        BorderSizePixel = 0,
        Text = self.Config.FloatingIcon,
        Font = Enum.Font.SourceSansBold,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 30,
        ZIndex = 10
    }, screenGui)
    self.UI.OpenButton = openButton

    self.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(1, 0) }, openButton)
    self.Functions.CreateElement("UIAspectRatioConstraint", {}, openButton)

    self.Functions.MakeDraggable(mainFrame, header)
    self.Functions.MakeDraggable(openButton, openButton)

    local function toggleMenu()
        mainFrame.Visible = not mainFrame.Visible
        if mainFrame.Visible then self:Notify("Menu Opened", 1) else self:Notify("Menu Closed", 1) end
    end
    openButton.MouseButton1Click:Connect(toggleMenu)

    -- No-Clip Window (FIXED & REDESIGNED)
    local noClipFrame = self.Functions.CreateElement("Frame", {
        Name = "NoClipFrame",
        Size = UDim2.new(0, 280, 0, 150), -- Slightly larger
        Position = UDim2.new(0.5, -140, 0.5, -75),
        BackgroundColor3 = Color3.fromRGB(28, 29, 34),
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 20
    }, screenGui)
    
    self.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 8) }, noClipFrame)
    self.Functions.CreateElement("UIStroke", { Color = self.Config.MainColor, Thickness = 1.5 }, noClipFrame)

    local ncHeader = self.Functions.CreateElement("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(35, 36, 42)
    }, noClipFrame)
    self.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(0, 8) }, ncHeader)

    self.Functions.CreateElement("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        Text = "NO-CLIP", Font = Enum.Font.GothamSemibold, TextSize = 16,
        TextColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1
    }, ncHeader)
    
    local ncClose = self.Functions.CreateElement("TextButton", {
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -30, 0.5, -12.5),
        Text = "X", Font = Enum.Font.SourceSansBold,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    }, ncHeader)
    self.Functions.CreateElement("UICorner", { CornerRadius = UDim.new(1, 0) }, ncClose)
    
    self.Functions.MakeDraggable(noClipFrame, ncHeader)
    ncClose.MouseButton1Click:Connect(function()
        noClipFrame.Visible = false
        self:Notify("No-Clip panel closed", 1)
    end)
    
    -- FIX: Container for No-Clip content with a layout
    local ncContent = self.Functions.CreateElement("Frame", {
        Size = UDim2.new(1, 0, 1, -30),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundTransparency = 1
    }, noClipFrame)

    self.Functions.CreateElement("UIListLayout", {
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = ncContent
    })
    self.Functions.CreateElement("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = ncContent
    })
    
    self.UI:CreateToggle(ncContent, "Enable No-Clip", function(state) self.Features:NoClip(state) end)

    -- Create Main Buttons
    self.UI:CreateActionButton("NO-CLIP", function()
        noClipFrame.Visible = true
        self:Notify("No-Clip panel opened", 1)
    end)
    
    self.UI:CreateActionButton("COMBO SCRIPT", function(button)
        self.Features:ExecuteScript(button, {
            "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua",
            "https://gist.githubusercontent.com/UCT-hub/5b11d10386f1b8ce08feb803861e0b79/raw/b2917b398d4b0cc80fb2aca73a3137ba494ebcf0/gistfile1.txt"
        })
    end)
    
    self.UI:CreateActionButton("SERVER HOP", function(button)
        self.Features:ExecuteScript(button, "https://raw.githubusercontent.com/Gato-bytes/GatoHubOnTop/refs/heads/main/AutoJoin.lua")
    end)
    
    self.UI:CreateActionButton("RESET CHARACTER", function()
        self:Notify("Resetting character...", 1)
        if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
    end)

    -- Final setup
    uiLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.UI.OptionsContainer.CanvasSize = UDim2.new(0, 0, 0, uiLayout.AbsoluteContentSize.Y + 10)
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == self.Config.Keybind then
            toggleMenu()
        end
    end)

    self:Notify("XL3RL V2 Loaded", 3)
end

-- Run the script
Library:Initialize()

