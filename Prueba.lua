--[[========================================================
  XL3RL HUB – PREMIUM UI + SPEED RUN (Roba Brainroot)
  - Icono flotante arrastrable
  - Menú principal / No-Clip / Speed compactos (sin espacios arriba)
  - Combo Scripts + Cambiar Servidor (links provistos)
==========================================================]]

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LP               = Players.LocalPlayer

--== Limpieza previa
pcall(function()
    local g = LP:WaitForChild("PlayerGui"):FindFirstChild("XL3RL_GUI")
    if g then g:Destroy() end
end)

--== Helpers
local function make(className, props, parent)
    local i = Instance.new(className)
    for k,v in pairs(props or {}) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end

local function makeDraggable(frame)
    frame.Active = true
    frame.Draggable = true
end

local function pulse(ui, goalSize)
    local s = ui.Size
    TweenService:Create(ui, TweenInfo.new(0.16, Enum.EasingStyle.Sine), {Size = goalSize}):Play()
    task.delay(0.16, function()
        TweenService:Create(ui, TweenInfo.new(0.16, Enum.EasingStyle.Sine), {Size = s}):Play()
    end)
end

local function makeButton(text, parent, gradA, gradB, height)
    local h = height or 30
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

--== GUI base
local Screen = make("ScreenGui", {
    Name = "XL3RL_GUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, LP:WaitForChild("PlayerGui"))

-- Icono flotante (arrastrable)
local FloatIcon = make("Frame", {
    Size = UDim2.new(0, 56, 0, 56),
    Position = UDim2.new(0.12, 0, 0.18, 0),
    BackgroundColor3 = Color3.fromRGB(30,30,30),
    ZIndex = 50
}, Screen)
make("UICorner", {CornerRadius = UDim.new(1, 0)}, FloatIcon)
make("UIStroke", {Thickness = 2, Color = Color3.fromRGB(0,255,150)}, FloatIcon)
make("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0,200,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,255,150))
    },
    Rotation = 90
}, FloatIcon)
local FloatText = make("TextButton", {
    Size = UDim2.fromScale(1,1),
    BackgroundTransparency = 1,
    Text = "XL",
    Font = Enum.Font.GothamBlack,
    TextSize = 22,
    TextColor3 = Color3.fromRGB(255,255,255)
}, FloatIcon)
makeDraggable(FloatIcon)
FloatText.MouseEnter:Connect(function()
    TweenService:Create(FloatIcon, TweenInfo.new(0.15), {Size = UDim2.new(0,62,0,62)}):Play()
end)
FloatText.MouseLeave:Connect(function()
    TweenService:Create(FloatIcon, TweenInfo.new(0.15), {Size = UDim2.new(0,56,0,56)}):Play()
end)

--== Menú principal (compacto, sin hueco)
local Main = make("Frame", {
    Size = UDim2.new(0, 170, 0, 150),
    Position = UDim2.new(0.5, -85, 0.5, -75),
    BackgroundColor3 = Color3.fromRGB(25,25,25),
    Visible = false
}, Screen)
makeDraggable(Main)
make("UICorner", {CornerRadius = UDim.new(0, 14)}, Main)
make("UIStroke", {Thickness = 2, Color = Color3.fromRGB(0,255,150)}, Main)
make("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0,200,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,255,150))
    },
    Rotation = 45
}, Main)

local MainContent = make("Frame", {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1}, Main)
make("UIPadding", {
    PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8),
    PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)
}, MainContent)
make("UIListLayout", {
    Padding = UDim.new(0, 8),
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Top,
    SortOrder = Enum.SortOrder.LayoutOrder
}, MainContent)

make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 24),
    Text = "XL3RL HUB",
    Font = Enum.Font.GothamBlack,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(0,255,200),
    BackgroundTransparency = 1,
    LayoutOrder = 1
}, MainContent)

local btnNoClip = makeButton("NO-CLIP MENU", MainContent,
    Color3.fromRGB(0,200,255), Color3.fromRGB(0,255,150), 30)  btnNoClip.LayoutOrder = 2
local btnSpeed  = makeButton("SPEED RUN", MainContent,
    Color3.fromRGB(0,255,170), Color3.fromRGB(0,180,120), 30)  btnSpeed.LayoutOrder  = 3
local btnCombo  = makeButton("COMBO SCRIPTS", MainContent,
    Color3.fromRGB(160,60,255), Color3.fromRGB(60,0,160), 30)  btnCombo.LayoutOrder  = 4
local btnServer = makeButton("CAMBIAR SERVIDOR", MainContent,
    Color3.fromRGB(40,150,255), Color3.fromRGB(0,90,200), 30)  btnServer.LayoutOrder = 5

--== Panel NO-CLIP (estilo “teleguiado”)
local NCPanel = make("Frame", {
    Size = UDim2.new(0, 215, 0, 115),
    Position = UDim2.new(0.78, -75, 0.25, 0),
    BackgroundColor3 = Color3.fromRGB(22,22,22),
    Visible = false, ZIndex = 30
}, Screen)
makeDraggable(NCPanel)
make("UICorner", {CornerRadius = UDim.new(0, 16)}, NCPanel)
make("UIStroke", {Thickness = 3, Color = Color3.fromRGB(0,255,120)}, NCPanel)

local NCContent = make("Frame", {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1}, NCPanel)
make("UIPadding", {
    PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
    PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)
}, NCContent)
make("UIListLayout", {
    Padding = UDim.new(0, 8),
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Top,
    SortOrder = Enum.SortOrder.LayoutOrder
}, NCContent)

make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = "NO-CLIP",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(0,255,170),
    TextXAlignment = Enum.TextXAlignment.Left,
    LayoutOrder = 1
}, NCContent)

local NCButton = make("TextButton", {
    Size = UDim2.new(1, 0, 0, 42),
    Text = "ACTIVAR NO-CLIP",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(255,255,255),
    AutoButtonColor = false,
    BackgroundColor3 = Color3.fromRGB(0, 160, 0),
    LayoutOrder = 2
}, NCContent)
make("UICorner", {CornerRadius = UDim.new(0, 12)}, NCButton)
make("UIStroke", {Thickness = 2, Color = Color3.fromRGB(0,255,120)}, NCButton)

local noClipConn, noClipOn = nil, false
local function setNoClip(on)
    if on and not noClipOn then
        noClipConn = RunService.Stepped:Connect(function()
            local ch = LP.Character
            if ch then
                for _,p in ipairs(ch:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
        noClipOn = true
        NCButton.Text = "DESACTIVAR NO-CLIP"
        TweenService:Create(NCButton, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(170, 20, 20)}):Play()
    elseif (not on) and noClipOn then
        if noClipConn then noClipConn:Disconnect() end
        noClipConn, noClipOn = nil, false
        local ch = LP.Character
        if ch then
            for _,p in ipairs(ch:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
        NCButton.Text = "ACTIVAR NO-CLIP"
        TweenService:Create(NCButton, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(0, 160, 0)}):Play()
    end
end
NCButton.MouseButton1Click:Connect(function() setNoClip(not noClipOn) end)

--== PANEL SPEED RUN (para Roba Brainroot)
local SPDPanel = make("Frame", {
    Size = UDim2.new(0, 235, 0, 140),
    Position = UDim2.new(0.78, -75, 0.45, 0),
    BackgroundColor3 = Color3.fromRGB(22,22,22),
    Visible = false, ZIndex = 30
}, Screen)
makeDraggable(SPDPanel)
make("UICorner", {CornerRadius = UDim.new(0, 16)}, SPDPanel)
make("UIStroke", {Thickness = 3, Color = Color3.fromRGB(0,255,170)}, SPDPanel)

local SPDContent = make("Frame", {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1}, SPDPanel)
make("UIPadding", {
    PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 8),
    PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)
}, SPDContent)
make("UIListLayout", {
    Padding = UDim.new(0, 8),
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Top
}, SPDContent)

make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = "SPEED",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(0,255,170),
    TextXAlignment = Enum.TextXAlignment.Left
}, SPDContent)

-- Barra de ajuste +/-
local AdjustRow = make("Frame", {Size = UDim2.new(1,0,0,28), BackgroundTransparency = 1}, SPDContent)
make("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0, 8)
}, AdjustRow)

local minus = make("TextButton", {
    Size = UDim2.new(0, 36, 1, 0), Text = "–",
    Font = Enum.Font.GothamBlack, TextSize = 20, TextColor3 = Color3.new(1,1,1),
    BackgroundColor3 = Color3.fromRGB(40,40,40), AutoButtonColor = false
}, AdjustRow)
make("UICorner", {CornerRadius = UDim.new(0, 10)}, minus)

local speedLabel = make("TextLabel", {
    Size = UDim2.new(1, -96, 1, 0), Text = "VELOCIDAD: 32",
    Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.new(1,1,1),
    BackgroundTransparency = 1
}, AdjustRow)

local plus = make("TextButton", {
    Size = UDim2.new(0, 36, 1, 0), Text = "+",
    Font = Enum.Font.GothamBlack, TextSize = 20, TextColor3 = Color3.new(1,1,1),
    BackgroundColor3 = Color3.fromRGB(40,40,40), AutoButtonColor = false
}, AdjustRow)
make("UICorner", {CornerRadius = UDim.new(0, 10)}, plus)

local SPDButton = make("TextButton", {
    Size = UDim2.new(1, 0, 0, 48),
    Text = "ACTIVAR VELOCIDAD",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(255,255,255),
    AutoButtonColor = false,
    BackgroundColor3 = Color3.fromRGB(0, 160, 0)
}, SPDContent)
make("UICorner", {CornerRadius = UDim.new(0, 12)}, SPDButton)
make("UIStroke", {Thickness = 2, Color = Color3.fromRGB(0,255,170)}, SPDButton)

-- Lógica SPEED
local DesiredSpeed, SpeedEnabled = 32, false
local hbConn, propConn

local function getHumanoid()
    local ch = LP.Character
    if not ch then return nil end
    return ch:FindFirstChildOfClass("Humanoid")
end

local function applySpeed()
    if not SpeedEnabled then return end
    local hum = getHumanoid()
    if hum and hum.WalkSpeed ~= DesiredSpeed then
        hum.WalkSpeed = DesiredSpeed
    end
end

local function bindSpeed()
    if hbConn then hbConn:Disconnect() end
    hbConn = RunService.Heartbeat:Connect(applySpeed)

    -- Reaplicar si el juego intenta cambiarlo
    local hum = getHumanoid()
    if propConn then propConn:Disconnect() end
    if hum then
        propConn = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if SpeedEnabled and hum.WalkSpeed ~= DesiredSpeed then
                hum.WalkSpeed = DesiredSpeed
            end
        end)
    end

    -- Reenganchar en respawn
    LP.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid")
        task.wait(0.2)
        applySpeed()
        bindSpeed()
    end)
end

local function setSpeedEnabled(on)
    SpeedEnabled = on
    if on then
        SPDButton.Text = "DESACTIVAR VELOCIDAD"
        TweenService:Create(SPDButton, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(170, 20, 20)}):Play()
        bindSpeed()
        applySpeed()
    else
        if hbConn then hbConn:Disconnect() end; hbConn = nil
        if propConn then propConn:Disconnect() end; propConn = nil
        local hum = getHumanoid()
        if hum then hum.WalkSpeed = 16 end
        SPDButton.Text = "ACTIVAR VELOCIDAD"
        TweenService:Create(SPDButton, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(0, 160, 0)}):Play()
    end
end

plus.MouseButton1Click:Connect(function()
    DesiredSpeed = math.clamp(DesiredSpeed + 4, 16, 120)
    speedLabel.Text = "VELOCIDAD: " .. tostring(DesiredSpeed)
    applySpeed()
end)
minus.MouseButton1Click:Connect(function()
    DesiredSpeed = math.clamp(DesiredSpeed - 4, 16, 120)
    speedLabel.Text = "VELOCIDAD: " .. tostring(DesiredSpeed)
    applySpeed()
end)
SPDButton.MouseButton1Click:Connect(function() setSpeedEnabled(not SpeedEnabled) end)

--== Acciones de botones HUB
btnNoClip.MouseButton1Click:Connect(function()
    NCPanel.Visible = not NCPanel.Visible
end)
btnSpeed.MouseButton1Click:Connect(function()
    SPDPanel.Visible = not SPDPanel.Visible
end)

btnCombo.MouseButton1Click:Connect(function()
    pulse(btnCombo, UDim2.new(1,0,0,32))
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))()
    end)
    pcall(function()
        loadstring(game:HttpGet("https://gist.githubusercontent.com/UCT-hub/5b11d10386f1b8ce08feb803861e0b79/raw/b2917b398d4b0cc80fb2aca73a3137ba494ebcf0/gistfile1.txt"))()
    end)
end)

btnServer.MouseButton1Click:Connect(function()
    pulse(btnServer, UDim2.new(1,0,0,32))
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Gato-bytes/GatoHubOnTop/refs/heads/main/AutoJoin.lua"))()
    end)
end)

--== Toggle del menú con icono flotante + tecla
FloatText.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)
UserInputService.InputBegan:Connect(function(inp, gpe)
    if not gpe and inp.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)
