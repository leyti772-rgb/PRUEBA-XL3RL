--[[========================================================
XL3RL HUB – Auto-Láser con Auto-Equip + Compact UI

• Icono flotante arrastrable (abre/cierra menú principal)
• Menú principal y menús (No-Clip / Auto-Láser) compactos y arrastrables
• Auto-Láser: al ACTIVAR intenta auto-equipar "Laser Cape" desde el Backpack
• Combo Scripts / Cambiar Servidor (links pedidos)

Tecla toggle: RightShift
==========================================================]]

--== Servicios ==--
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP                = Players.LocalPlayer

--== Limpieza previa ==--
pcall(function()
    local g = LP:WaitForChild("PlayerGui"):FindFirstChild("XL3RL_GUI")
    if g then g:Destroy() end
end)

--== Helpers ==--
local function make(className, props, parent)
    local i = Instance.new(className)
    for k,v in pairs(props or {}) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end

-- Arrastre estable (sin saltos)
local function makeDraggable(frame, trigger)
    trigger = trigger or frame
    local dragging = false
    local dragStart, startPos
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos  = frame.Position
            local con; con = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    con:Disconnect()
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function pulse(ui, goalSize)
    local s = ui.Size
    TweenService:Create(ui, TweenInfo.new(0.16, Enum.EasingStyle.Sine), {Size = goalSize}):Play()
    task.delay(0.16, function()
        if ui and ui.Parent then
            TweenService:Create(ui, TweenInfo.new(0.16, Enum.EasingStyle.Sine), {Size = s}):Play()
        end
    end)
end

--== Toast / Notificación simple ==--
local function makeToastLayer(screen)
    local f = make("Frame", {
        Size = UDim2.new(1,0,0,40),
        Position = UDim2.new(0,0,0,-40),
        BackgroundTransparency = 1,
        ZIndex = 1000
    }, screen)
    local label = make("TextLabel", {
        AnchorPoint = Vector2.new(0.5,0),
        Position = UDim2.new(0.5,0,0,6),
        Size = UDim2.new(0,260,0,28),
        BackgroundColor3 = Color3.fromRGB(25,25,25),
        TextColor3 = Color3.fromRGB(255,255,255),
        Text = "",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Visible = false
    }, f)
    make("UICorner", {CornerRadius = UDim.new(0,10)}, label)
    make("UIStroke", {Thickness = 1.5, Color = Color3.fromRGB(0,255,150)}, label)
    return function(msg, t)
        label.Text = msg
        label.Visible = true
        TweenService:Create(f, TweenInfo.new(0.22), {Position = UDim2.new(0,0,0,0)}):Play()
        task.delay(t or 1.6, function()
            TweenService:Create(f, TweenInfo.new(0.22), {Position = UDim2.new(0,0,0,-40)}):Play()
            task.wait(0.22)
            label.Visible = false
        end)
    end
end

--== GUI base ==--
local Screen = make("ScreenGui", {
    Name = "XL3RL_GUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, LP:WaitForChild("PlayerGui"))

local toast = makeToastLayer(Screen)

-- Icono flotante (abre/cierra menú)
local FloatIcon = make("ImageButton", {
    Size = UDim2.new(0, 56, 0, 56),
    Position = UDim2.new(0.12, 0, 0.18, 0),
    BackgroundColor3 = Color3.fromRGB(30,30,30),
    Image = "rbxassetid://6035047409", -- Ícono (bolt)
    ImageColor3 = Color3.fromRGB(0,255,150)
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
makeDraggable(FloatIcon, FloatIcon)

-- Menú principal (compacto)
local Main = make("Frame", {
    Size = UDim2.new(0, 160, 0, 150),
    Position = UDim2.new(0.5, -80, 0.5, -75),
    BackgroundColor3 = Color3.fromRGB(25,25,25),
    Visible = false
}, Screen)
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
    PaddingTop = UDim.new(0, 8),
    PaddingBottom = UDim.new(0, 8),
    PaddingLeft = UDim.new(0, 10),
    PaddingRight = UDim.new(0, 10)
}, MainContent)
local MainLayout = make("UIListLayout", {
    Padding = UDim.new(0, 8),
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Top,
    SortOrder = Enum.SortOrder.LayoutOrder
}, MainContent)

local Title = make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 24),
    Text = "XL3RL HUB",
    Font = Enum.Font.GothamBlack,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(0,255,200),
    BackgroundTransparency = 1,
    LayoutOrder = 1
}, MainContent)

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

-- Botones menú principal
local btnNoClip = makeButton("NO-CLIP", MainContent, Color3.fromRGB(0,200,255), Color3.fromRGB(0,255,150), 32)
btnNoClip.LayoutOrder = 2
local btnLaser  = makeButton("AUTO-LÁSER", MainContent, Color3.fromRGB(255,120,60), Color3.fromRGB(255,60,120), 32)
btnLaser.LayoutOrder = 3
local btnCombo  = makeButton("COMBO SCRIPTS", MainContent, Color3.fromRGB(160,60,255), Color3.fromRGB(60,0,160), 32)
btnCombo.LayoutOrder = 4
local btnServer = makeButton("CAMBIAR SERVIDOR", MainContent, Color3.fromRGB(40,150,255), Color3.fromRGB(0,90,200), 32)
btnServer.LayoutOrder = 5

-- Panel NO-CLIP
local NCPanel = make("Frame", {
    Size = UDim2.new(0, 150, 0, 96),
    Position = UDim2.new(0.78, -75, 0.25, 0),
    BackgroundColor3 = Color3.fromRGB(22,22,22),
    Visible = false
}, Screen)
make("UICorner", {CornerRadius = UDim.new(0, 14)}, NCPanel)
make("UIStroke", {Thickness = 3, Color = Color3.fromRGB(0,255,120)}, NCPanel)
makeDraggable(NCPanel, NCPanel)

local NCContent = make("Frame", {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1}, NCPanel)
make("UIPadding", {
    PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
    PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)
}, NCContent)
make("UIListLayout", {
    Padding = UDim.new(0, 6),
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Top,
    SortOrder = Enum.SortOrder.LayoutOrder
}, NCContent)

local NCHeader = make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = "NO-CLIP",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(0,255,170),
    TextXAlignment = Enum.TextXAlignment.Left,
    LayoutOrder = 1
}, NCContent)

local ncButton = make("TextButton", {
    Size = UDim2.new(1, 0, 0, 40),
    Text = "ACTIVAR",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(255,255,255),
    AutoButtonColor = false,
    BackgroundColor3 = Color3.fromRGB(0, 160, 0),
    LayoutOrder = 2
}, NCContent)
make("UICorner", {CornerRadius = UDim.new(0, 10)}, ncButton)
make("UIStroke", {Thickness = 2, Color = Color3.fromRGB(0,255,120)}, ncButton)

-- Panel AUTO-LÁSER (con auto-equip)
local LaserPanel = make("Frame", {
    Size = UDim2.new(0, 150, 0, 96),
    Position = UDim2.new(0.78, -75, 0.45, 0),
    BackgroundColor3 = Color3.fromRGB(22,22,22),
    Visible = false
}, Screen)
make("UICorner", {CornerRadius = UDim.new(0, 14)}, LaserPanel)
make("UIStroke", {Thickness = 3, Color = Color3.fromRGB(255,90,160)}, LaserPanel)
makeDraggable(LaserPanel, LaserPanel)

local LContent = make("Frame", {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1}, LaserPanel)
make("UIPadding", {
    PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
    PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)
}, LContent)
make("UIListLayout", {
    Padding = UDim.new(0, 6),
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Top,
    SortOrder = Enum.SortOrder.LayoutOrder
}, LContent)

local LHeader = make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = "AUTO-LÁSER",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(255,140,200),
    TextXAlignment = Enum.TextXAlignment.Left,
    LayoutOrder = 1
}, LContent)

local laserBtn = make("TextButton", {
    Size = UDim2.new(1, 0, 0, 40),
    Text = "ACTIVAR",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(255,255,255),
    AutoButtonColor = false,
    BackgroundColor3 = Color3.fromRGB(0, 160, 0), -- Verde = inactivo (Activar)
    LayoutOrder = 2
}, LContent)
make("UICorner", {CornerRadius = UDim.new(0, 10)}, laserBtn)
make("UIStroke", {Thickness = 2, Color = Color3.fromRGB(255,140,200)}, laserBtn)

--== Lógica NO-CLIP ==--
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
        ncButton.Text = "DESACTIVAR"
        ncButton.BackgroundColor3 = Color3.fromRGB(170, 20, 20) -- Rojo = activo (Desactivar)
        toast("No-Clip ACTIVADO", 1.2)
    elseif (not on) and noClipOn then
        if noClipConn then noClipConn:Disconnect() end
        noClipConn = nil
        noClipOn = false
        local ch = LP.Character
        if ch then
            for _,p in ipairs(ch:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
        ncButton.Text = "ACTIVAR"
        ncButton.BackgroundColor3 = Color3.fromRGB(0, 160, 0)
        toast("No-Clip DESACTIVADO", 1.2)
    end
end
ncButton.MouseButton1Click:Connect(function() setNoClip(not noClipOn) end)

--== Lógica AUTO-LÁSER + Auto-Equip de "Laser Cape" ==--
local LaserRemote = ReplicatedStorage:FindFirstChild("RE/UseItem", true)
local autoLaser = false
local LASER_ITEM_NAME = "Laser Cape"
local LASER_RANGE = 150
local autoEquipThread -- para reintentos suaves mientras esté activo

local function hasEquippedLaserCape()
    local ch = LP.Character
    if not ch then return false end
    -- Si es Tool, aparece en Character
    for _,inst in ipairs(ch:GetChildren()) do
        if inst:IsA("Tool") and (inst.Name == LASER_ITEM_NAME or inst.Name:lower():find("laser")) then
            return true
        end
    end
    -- Por si el juego lo maneja como Accessory nombrado similar
    for _,acc in ipairs(ch:GetChildren()) do
        if acc:IsA("Accessory") and acc.Name:lower():find("laser") then
            return true
        end
    end
    return false
end

local function equipLaserCape()
    local bp = LP:FindFirstChildOfClass("PlayerGui") and LP.Backpack
    if not bp then return false end
    -- Buscar Tool con nombre exacto o similar
    local tool = bp:FindFirstChild(LASER_ITEM_NAME)
                or (function()
                        for _,t in ipairs(bp:GetChildren()) do
                            if t:IsA("Tool") and t.Name:lower():find("laser") then
                                return t
                            end
                        end
                    end)()
    if tool then
        local ch = LP.Character or LP.CharacterAdded:Wait()
        tool.Parent = ch
        return true
    end
    return false
end

local function startAutoEquipMaintainer()
    if autoEquipThread then return end
    autoEquipThread = task.spawn(function()
        while autoLaser do
            if not hasEquippedLaserCape() then
                if equipLaserCape() then
                    toast("Capa Láser equipada", 1.1)
                end
            end
            task.wait(1.2)
        end
        autoEquipThread = nil
    end)
end

local function fireLaserAtClosest()
    if not (autoLaser and LaserRemote) then return end
    local ch = LP.Character
    if not (ch and ch:FindFirstChild("HumanoidRootPart")) then return end
    local myHRP = ch.HumanoidRootPart

    local closestHRP, dist = nil, LASER_RANGE
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl ~= LP and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            local d = (pl.Character.HumanoidRootPart.Position - myHRP.Position).Magnitude
            if d < dist then closestHRP, dist = pl.Character.HumanoidRootPart, d end
        end
    end

    if closestHRP then
        -- Algunos juegos requieren [2] = un Part del mapa; intentamos buscar uno genérico
        local mapPart = workspace:FindFirstChild("Map")
        if mapPart and mapPart:IsA("Model") then
            local anyBase = mapPart:FindFirstChildWhichIsA("BasePart", true)
            if anyBase then
                LaserRemote:FireServer(closestHRP.Position, anyBase)
                return
            end
        end
        -- Fallback: enviar solo el Vector3 + HRP (si el servidor lo acepta)
        LaserRemote:FireServer(closestHRP.Position, closestHRP)
    end
end

laserBtn.MouseButton1Click:Connect(function()
    autoLaser = not autoLaser
    if autoLaser then
        laserBtn.Text = "DESACTIVAR"
        laserBtn.BackgroundColor3 = Color3.fromRGB(170, 20, 20) -- Rojo = activo (Desactivar)
        if not hasEquippedLaserCape() then
            if equipLaserCape() then
                toast("Capa Láser equipada", 1.1)
            else
                toast("No se encontró '"..LASER_ITEM_NAME.."' en Backpack", 1.8)
            end
        end
        startAutoEquipMaintainer()
        toast("Auto-Láser ACTIVADO", 1.2)
    else
        laserBtn.Text = "ACTIVAR"
        laserBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 0)
        autoLaser = false
        toast("Auto-Láser DESACTIVADO", 1.2)
    end
end)

-- Loop de disparo (suave)
task.spawn(function()
    while true do
        if autoLaser then
            fireLaserAtClosest()
        end
        task.wait(0.22)
    end
end)

--== Acciones HUB ==--
btnNoClip.MouseButton1Click:Connect(function()
    NCPanel.Visible = not NCPanel.Visible
end)

btnLaser.MouseButton1Click:Connect(function()
    LaserPanel.Visible = not LaserPanel.Visible
end)

-- Links pedidos por ti
btnCombo.MouseButton1Click:Connect(function()
    pulse(btnCombo, UDim2.new(1,0,0,34))
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))()
    end)
    pcall(function()
        loadstring(game:HttpGet("https://pastefy.app/NCRcbLWe/raw"))()
    end)
end)

btnServer.MouseButton1Click:Connect(function()
    pulse(btnServer, UDim2.new(1,0,0,34))
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/karlosedson/mkzhub/refs/heads/main/makerzjoiner.lua"))()
    end)
end)

-- Toggle menú con icono y con tecla
FloatIcon.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)
makeDraggable(Main, Main)
UserInputService.InputBegan:Connect(function(inp, gpe)
    if not gpe and inp.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)
