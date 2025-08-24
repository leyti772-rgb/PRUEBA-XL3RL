-- XL3RL HUB + Auto-Laser con equipar/desequipar Laser Cape
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

--==================== Helpers ====================--
local function make(className, props, parent)
    local i = Instance.new(className)
    for k,v in pairs(props or {}) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end

local function makeDraggable(frame) frame.Active = true; frame.Draggable = true end

local function pulse(ui, goalSize)
    local s = ui.Size
    TweenService:Create(ui, TweenInfo.new(0.18, Enum.EasingStyle.Sine), {Size = goalSize}):Play()
    task.delay(0.18, function()
        TweenService:Create(ui, TweenInfo.new(0.18, Enum.EasingStyle.Sine), {Size = s}):Play()
    end)
end

local function makeButton(text, parent, gradA, gradB, height)
    local h = height or 32
    local btn = make("TextButton", {
        Size = UDim2.new(1, 0, 0, h),
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Color3.fromRGB(255,255,255),
        BackgroundColor3 = Color3.fromRGB(40,40,40),
        AutoButtonColor = false,
        LayoutOrder = 100
    }, parent)
    make("UICorner", {CornerRadius = UDim.new(0, 10)}, btn)
    make("UIStroke", {Thickness = 1.5, Color = Color3.fromRGB(255,255,255)}, btn)
    make("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, gradA or Color3.fromRGB(55,55,55)),
            ColorSequenceKeypoint.new(1, gradB or Color3.fromRGB(35,35,35))
        }
    }, btn)
    btn.MouseButton1Click:Connect(function()
        pulse(btn, UDim2.new(1,0,0,h+2))
    end)
    return btn
end

--==================== GUI base ====================--
local Screen = make("ScreenGui", {
    Name = "XL3RL_GUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, LP:WaitForChild("PlayerGui"))

-- Icono flotante
local FloatIcon = make("Frame", {
    Size = UDim2.new(0, 56, 0, 56),
    Position = UDim2.new(0.12, 0, 0.18, 0),
    BackgroundColor3 = Color3.fromRGB(30,30,30)
}, Screen)
make("UICorner", {CornerRadius = UDim.new(1, 0)}, FloatIcon)
make("UIStroke", {Thickness = 2, Color = Color3.fromRGB(0,255,150)}, FloatIcon)
local FloatText = make("TextButton", {
    Size = UDim2.fromScale(1,1),
    BackgroundTransparency = 1,
    Text = "XL",
    Font = Enum.Font.GothamBlack,
    TextSize = 22,
    TextColor3 = Color3.fromRGB(255,255,255)
}, FloatIcon)
makeDraggable(FloatIcon)

--==================== Menú principal ====================--
local Main = make("Frame", {
    Size = UDim2.new(0, 160, 0, 170),
    Position = UDim2.new(0.5, -80, 0.5, -85),
    BackgroundColor3 = Color3.fromRGB(25,25,25),
    Visible = false
}, Screen)
makeDraggable(Main)
make("UICorner", {CornerRadius = UDim.new(0, 14)}, Main)
make("UIStroke", {Thickness = 2, Color = Color3.fromRGB(0,255,150)}, Main)

local MainContent = make("Frame", {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1}, Main)
make("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}, MainContent)
local MainLayout = make("UIListLayout", {
    Padding = UDim.new(0, 8), FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Top,
    SortOrder = Enum.SortOrder.LayoutOrder
}, MainContent)

make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 24), Text = "XL3RL HUB",
    Font = Enum.Font.GothamBlack, TextSize = 16, TextColor3 = Color3.fromRGB(0,255,200),
    BackgroundTransparency = 1, LayoutOrder = 1
}, MainContent)

local btnNoClip = makeButton("NO-CLIP MENU", MainContent, Color3.fromRGB(0,200,255), Color3.fromRGB(0,255,150), 32)
btnNoClip.LayoutOrder = 2
local btnAutoLaser = makeButton("AUTO-LASER", MainContent, Color3.fromRGB(255,60,60), Color3.fromRGB(150,0,0), 32)
btnAutoLaser.LayoutOrder = 3

--==================== Panel AUTO-LASER ====================--
local ALPanel = make("Frame", {
    Size = UDim2.new(0, 150, 0, 96),
    Position = UDim2.new(0.78, -75, 0.45, 0),
    BackgroundColor3 = Color3.fromRGB(22,22,22),
    Visible = false
}, Screen)
makeDraggable(ALPanel)
make("UICorner", {CornerRadius = UDim.new(0, 14)}, ALPanel)
make("UIStroke", {Thickness = 3, Color = Color3.fromRGB(255,50,50)}, ALPanel)

local ALContent = make("Frame", {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1}, ALPanel)
make("UIPadding", {PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}, ALContent)
local ALLayout = make("UIListLayout", {
    Padding = UDim.new(0, 6), FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Top,
    SortOrder = Enum.SortOrder.LayoutOrder
}, ALContent)

make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1, Text = "AUTO-LASER",
    Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(255,80,80),
    TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 1
}, ALContent)

local ALButton = make("TextButton", {
    Size = UDim2.new(1, 0, 0, 40),
    Text = "ACTIVAR AUTO-LASER",
    Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(255,255,255),
    AutoButtonColor = false, BackgroundColor3 = Color3.fromRGB(0,160,0),
    LayoutOrder = 2
}, ALContent)
make("UICorner", {CornerRadius = UDim.new(0, 10)}, ALButton)
make("UIStroke", {Thickness = 2, Color = Color3.fromRGB(255,50,50)}, ALButton)

--==================== Funciones Auto-Laser ====================--
local autoLaserConn, autoLaserOn = nil, false

local function equipLaserCape()
    pcall(function()
        ReplicatedStorage.Packages.Net:FindFirstChild("RF/CoinsShopService/RequestBuy"):InvokeServer("Laser Cape")
    end)
end

local function unequipLaserCape()
    local ch = LP.Character
    local bp = LP:FindFirstChild("Backpack")
    if ch and bp then
        local cape = ch:FindFirstChild("Laser Cape")
        if cape then
            cape.Parent = bp
        end
    end
end

local function setAutoLaser(on)
    if on and not autoLaserOn then
        equipLaserCape()
        autoLaserConn = RunService.Heartbeat:Connect(function()
            for _,plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = plr.Character.HumanoidRootPart
                    local args = {[1] = hrp.Position, [2] = workspace:FindFirstChildWhichIsA("BasePart")}
                    ReplicatedStorage.Packages.Net:FindFirstChild("RE/UseItem"):FireServer(unpack(args))
                end
            end
        end)
        autoLaserOn = true
        ALButton.Text = "DESACTIVAR AUTO-LASER"
        TweenService:Create(ALButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(170,20,20)}):Play()
    elseif (not on) and autoLaserOn then
        if autoLaserConn then autoLaserConn:Disconnect() end
        autoLaserConn = nil
        autoLaserOn = false
        unequipLaserCape()
        ALButton.Text = "ACTIVAR AUTO-LASER"
        TweenService:Create(ALButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0,160,0)}):Play()
    end
end

ALButton.MouseButton1Click:Connect(function() setAutoLaser(not autoLaserOn) end)
btnAutoLaser.MouseButton1Click:Connect(function() ALPanel.Visible = not ALPanel.Visible end)

--==================== Toggle Menú ====================--
FloatText.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)
UserInputService.InputBegan:Connect(function(inp, gpe)
    if not gpe and inp.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)
