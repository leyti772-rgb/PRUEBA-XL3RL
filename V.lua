--[[
    SCRIPT: XL3RL - Enhanced Edition
    AUTHOR: Gemini
    DESCRIPTION: A stable, high-performance, and user-friendly UI script for Roblox.
    NOTES: This script is designed for maintainability and includes UI/UX enhancements.
]]

-- =========================================================================================
--                                   CONFIGURATION
-- =========================================================================================
local Config = {
    Name = "XL3RL",
    PrimaryColor = Color3.fromRGB(0, 122, 255),  -- A modern blue for a fresh look
    Icon = "💠", -- A more modern icon
    Keybind = Enum.KeyCode.RightShift -- Key to toggle the menu
}

-- =========================================================================================
--                                     SERVICES
-- =========================================================================================
-- Pre-load services for efficiency
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- =========================================================================================
--                                  UTILITY FUNCTIONS
-- =========================================================================================

-- A robust function to create and property-set UI elements
local function createElement(elementType, properties, parent)
    local element = Instance.new(elementType)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    if parent then
        element.Parent = parent
    end
    return element
end

-- An optimized drag function that's smooth and responsive
local function makeDraggable(frame, trigger)
    local isDragging = false
    local dragInput, startPosition, dragStart

    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            startPosition = frame.Position
            dragStart = input.Position

            -- A single, clean connection to handle the end of dragging
            local connection
            connection = input.Changed:Connect(function()
                if not isDragging or input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                    connection:Disconnect()
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            -- Use a tween for a smoother drag effect
            local goalPosition = UDim2.fromOffset(startPosition.X.Offset + delta.X, startPosition.Y.Offset + delta.Y)
            TweenService:Create(frame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), { Position = goalPosition }):Play()
        end
    end)
end

-- =========================================================================================
--                                  UI INITIALIZATION
-- =========================================================================================

-- Clean up any previous instances of the UI to prevent stacking
pcall(function()
    if LocalPlayer and LocalPlayer.PlayerGui:FindFirstChild("XL3RL_Enhanced_GUI") then
        LocalPlayer.PlayerGui.XL3RL_Enhanced_GUI:Destroy()
    end
end)

-- Main GUI container
local ScreenGui = createElement("ScreenGui", {
    Name = "XL3RL_Enhanced_GUI",
    Parent = LocalPlayer.PlayerGui,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Global
})

-- Forward declare UI components
local MainFrame, NoClipFrame, OpenButton
local StatusText

-- =========================================================================================
--                                    MAIN INTERFACE
-- =========================================================================================

-- Create the main window frame
MainFrame = createElement("Frame", {
    Size = UDim2.new(0, 320, 0, 420),
    Position = UDim2.new(0.5, -160, 0.5, -210),
    BackgroundColor3 = Color3.fromRGB(28, 28, 32), -- Darker, modern theme
    BorderSizePixel = 0,
    Visible = false
}, ScreenGui)

createElement("UICorner", { CornerRadius = UDim.new(0, 12) }, MainFrame)
createElement("UIStroke", {
    Color = Config.PrimaryColor,
    Thickness = 1.5,
    Transparency = 0.4
}, MainFrame)

-- Header bar for title and dragging
local Header = createElement("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Color3.fromRGB(35, 35, 40),
    BorderSizePixel = 0
}, MainFrame)
createElement("UICorner", { CornerRadius = UDim.new(0, 12) }, Header)

createElement("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    Text = "// " .. Config.Name,
    Font = Enum.Font.Code,
    TextSize = 18,
    TextColor3 = Config.PrimaryColor,
    BackgroundTransparency = 1
}, Header)

-- Status bar at the bottom for notifications
local StatusBar = createElement("Frame", {
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0, 0, 1, -30),
    BackgroundColor3 = Color3.fromRGB(35, 35, 40),
    BorderSizePixel = 0
}, MainFrame)
createElement("UICorner", { CornerRadius = UDim.new(0, 12) }, StatusBar)

StatusText = createElement("TextLabel", {
    Size = UDim2.new(1, -10, 1, 0),
    Position = UDim2.new(0, 5, 0, 0),
    Text = "Initialized successfully.",
    Font = Enum.Font.Code,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(160, 160, 160),
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left
}, StatusBar)

-- Notification function with a fade-out effect
local notificationTask = nil
local function notify(message, duration)
    if notificationTask then task.cancel(notificationTask) end
    notificationTask = task.delay(duration or 2, function()
        StatusText.Text = "Waiting for action..."
    end)
    StatusText.Text = tostring(message)
end

-- Container for all options and buttons
local OptionsContainer = createElement("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, -70), -- Adjusted for Header and StatusBar
    Position = UDim2.new(0, 0, 0, 40),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarImageColor3 = Config.PrimaryColor,
    ScrollBarThickness = 5
}, MainFrame)

local UILayout = createElement("UIListLayout", {
    Padding = UDim.new(0, 10),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder,
    FillDirection = Enum.FillDirection.Vertical
}, OptionsContainer)

-- Floating button to open/close the main UI
OpenButton = createElement("TextButton", {
    Size = UDim2.new(0, 60, 0, 60),
    Position = UDim2.new(0, 20, 0, 20),
    BackgroundColor3 = Config.PrimaryColor,
    BorderSizePixel = 0,
    Text = Config.Icon,
    Font = Enum.Font.SourceSansBold,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 30,
    ZIndex = 10
}, ScreenGui)
createElement("UICorner", { CornerRadius = UDim.new(1, 0) }, OpenButton)

-- Apply drag functionality
makeDraggable(MainFrame, Header)
makeDraggable(OpenButton, OpenButton)

-- Main menu toggle function
local function toggleMenu()
    MainFrame.Visible = not MainFrame.Visible
    local notificationMessage = MainFrame.Visible and "Menu Opened" or "Menu Closed"
    notify(notificationMessage, 1)
end

OpenButton.MouseButton1Click:Connect(toggleMenu)

-- =========================================================================================
--                                  NO-CLIP MODULE
-- =========================================================================================
NoClipFrame = createElement("Frame", {
    Size = UDim2.new(0, 280, 0, 120), -- A more compact size
    Position = UDim2.new(0.5, -140, 0.5, -60),
    BackgroundColor3 = Color3.fromRGB(28, 28, 32),
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 20
}, ScreenGui)

createElement("UICorner", { CornerRadius = UDim.new(0, 12) }, NoClipFrame)
createElement("UIStroke", { Color = Config.PrimaryColor, Thickness = 1.5, Transparency = 0.4 }, NoClipFrame)

local NC_Header = createElement("Frame", {
    Size = UDim2.new(1, 0, 0, 35),
    BackgroundColor3 = Color3.fromRGB(35, 35, 40)
}, NoClipFrame)
createElement("UICorner", { CornerRadius = UDim.new(0, 12) }, NC_Header)

createElement("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    Text = "NO-CLIP",
    Font = Enum.Font.Code,
    TextSize = 16,
    TextColor3 = Color3.new(1, 1, 1),
    BackgroundTransparency = 1
}, NC_Header)

local NC_Close = createElement("TextButton", {
    Size = UDim2.new(0, 25, 0, 25),
    Position = UDim2.new(1, -35, 0.5, -12.5),
    Text = "X",
    Font = Enum.Font.SourceSansBold,
    TextColor3 = Color3.new(1, 1, 1),
    BackgroundColor3 = Color3.fromRGB(200, 50, 50)
}, NC_Header)
createElement("UICorner", { CornerRadius = UDim.new(1, 0) }, NC_Close)

-- Apply functionality to the No-Clip window
makeDraggable(NoClipFrame, NC_Header)
NC_Close.MouseButton1Click:Connect(function()
    NoClipFrame.Visible = false
    notify("No-Clip panel closed", 1)
end)

-- =========================================================================================
--                                 UI WIDGET SYSTEM
-- =========================================================================================
-- Creates a reusable, animated toggle switch
local function createSwitch(parent, text, callback)
    local frame = createElement("Frame", {
        Size = UDim2.new(1, -20, 0, 45),
        BackgroundColor3 = Color3.fromRGB(45, 47, 54),
        Position = UDim2.new(0, 10, 0, 0) -- Position managed by UIListLayout
    }, parent)
    createElement("UICorner", { CornerRadius = UDim.new(0, 8) }, frame)

    createElement("TextLabel", {
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        Text = text,
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    }, frame)

    local switchButton = createElement("TextButton", {
        Size = UDim2.new(0, 50, 0, 26),
        Position = UDim2.new(1, -65, 0.5, -13),
        BackgroundColor3 = Color3.fromRGB(70, 70, 70),
        Text = "",
        AutoButtonColor = false
    }, frame)
    createElement("UICorner", { CornerRadius = UDim.new(1, 0) }, switchButton)

    local knob = createElement("Frame", {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(0, 2, 0.5, -11),
        BackgroundColor3 = Color3.fromRGB(220, 220, 220),
        BorderSizePixel = 0
    }, switchButton)
    createElement("UICorner", { CornerRadius = UDim.new(1, 0) }, knob)

    local state = false
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)

    switchButton.MouseButton1Click:Connect(function()
        state = not state
        local knobPosition = state and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
        local switchColor = state and Config.PrimaryColor or Color3.fromRGB(70, 70, 70)

        TweenService:Create(knob, tweenInfo, { Position = knobPosition }):Play()
        TweenService:Create(switchButton, tweenInfo, { BackgroundColor3 = switchColor }):Play()

        -- Safely call the callback function
        pcall(callback, state)
    end)
end

-- Creates a reusable, animated action button
local function createActionButton(text, callback)
    local button = createElement("TextButton", {
        Size = UDim2.new(1, -20, 0, 45),
        Text = text,
        Font = Enum.Font.SourceSansSemibold,
        TextSize = 16,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundColor3 = Color3.fromRGB(45, 47, 54),
        AutoButtonColor = false
    }, OptionsContainer)
    createElement("UICorner", { CornerRadius = UDim.new(0, 8) }, button)

    local tweenInfo = TweenInfo.new(0.2)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, tweenInfo, { BackgroundColor3 = Config.PrimaryColor }):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, tweenInfo, { BackgroundColor3 = Color3.fromRGB(45, 47, 54) }):Play()
    end)
    button.MouseButton1Click:Connect(function()
        pcall(callback, button)
    end)

    return button
end

-- =========================================================================================
--                             FEATURE-SPECIFIC LOGIC
-- =========================================================================================

-- No-Clip System
local noClipConnection = nil
createSwitch(NoClipFrame, "Enable No-Clip", function(isEnabled)
    if isEnabled then
        notify("NO-CLIP: ENABLED", 2)
        noClipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        notify("NO-CLIP: DISABLED", 2)
        if noClipConnection then
            noClipConnection:Disconnect()
            noClipConnection = nil
        end
        -- Note: This doesn't reset collisions to their original state, which is typical for No-Clip.
        -- A full implementation would require storing and restoring original CanCollide values.
    end
end)

-- Script Execution System
local function executeScript(button, urls)
    task.spawn(function()
        local originalText = button.Text
        local urlList = (type(urls) == "table") and urls or {urls}
        local totalScripts = #urlList

        button.Text = "Loading..."
        button.Active = false -- Disable button during execution
        TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(60, 60, 70) }):Play()

        for i, url in ipairs(urlList) do
            notify(string.format("Executing script %d of %d...", i, totalScripts), 1)
            local success, result = pcall(function()
                loadstring(game:HttpGet(url))()
            end)

            if not success then
                notify(string.format("Error in script %d. Check console.", i), 3)
                warn("XL3RL SCRIPT ERROR: " .. tostring(result))
                break -- Stop execution on error
            end
        end

        button.Text = originalText
        button.Active = true -- Re-enable button
        TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(45, 47, 54) }):Play()
        notify("Execution complete.", 2)
    end)
end

-- =========================================================================================
--                                  MAIN BUTTONS
-- =========================================================================================

createActionButton("No-Clip", function()
    NoClipFrame.Visible = true
    notify("No-Clip panel opened", 1)
end)

createActionButton("Combo Script", function(button)
    executeScript(button, {
        "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua",
        "https://gist.githubusercontent.com/UCT-hub/5b11d10386f1b8ce08feb803861e0b79/raw/b2917b398d4b0cc80fb2aca73a3137ba494ebcf0/gistfile1.txt"
    })
end)

createActionButton("Server Hop", function(button)
    executeScript(button, "https://raw.githubusercontent.com/Gato-bytes/GatoHubOnTop/refs/heads/main/AutoJoin.lua")
end)

createActionButton("Reset Character", function()
    notify("Resetting character...", 1)
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end)

-- =========================================================================================
--                                   FINALIZATION
-- =========================================================================================

-- Dynamically adjust canvas size of the scrolling frame to fit content
UILayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    OptionsContainer.CanvasSize = UDim2.new(0, 0, 0, UILayout.AbsoluteContentSize.Y + 20)
end)

-- Initial welcome notification
notify(Config.Name .. " loaded successfully.", 3)

-- Keyboard shortcut to toggle the menu
UserInputService.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    if input.KeyCode == Config.Keybind then
        toggleMenu()
    end
end)

