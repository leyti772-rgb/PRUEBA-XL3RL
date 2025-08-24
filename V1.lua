
--[[========================================================
XL3RL HUB – PREMIUM UI (Compact+Fix Top Gap)
Integración Auto-Láser con auto-equipar/desequipar + anti-conflicto de tools
==========================================================]]

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP                = Players.LocalPlayer

--========================================================
-- Limpieza previa
pcall(function()
    local g = LP:WaitForChild("PlayerGui"):FindFirstChild("XL3RL_GUI")
    if g then g:Destroy() end
end)

--==================== Helpers ====================--
local function make(className, props, parent)
    local i = Instance.new(className)
    for k,v in pairs(props or {}) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end

-- Drag robusto (funciona en móvil/PC)
local function makeDraggable(frame, dragHandle)
    dragHandle = dragHandle or frame
    local dragging, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.fromOffset(startPos.X.Offset + delta.X, startPos.Y.Offset + delta.Y)
    end
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

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
makeDraggable(FloatIcon, FloatText)
FloatText.MouseEnter:Connect(function()
    TweenService:Create(FloatIcon, TweenInfo.new(0.2), {Size = UDim2.new(0,62,0,62)}):Play()
end)
FloatText.MouseLeave:Connect(function()
    TweenService:Create(FloatIcon, TweenInfo.new(0.2), {Size = UDim2.new(0,56,0,56)}):Play()
end)

--==================== Menú principal (compacto + sin hueco) ====================--
local Main = make("Frame", {
    Size = UDim2.new(0, 170, 0, 204),
    Position = UDim2.new(0.5, -85, 0.5, -102),
    BackgroundColor3 = Color3.fromRGB(25,25,25),
    Visible = false
}, Screen)
makeDraggable(Main, Main)
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
make("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}, MainContent)
make("UIListLayout", {Padding = UDim.new(0, 8), FillDirection = Enum.FillDirection.Vertical, HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Top, SortOrder = Enum.SortOrder.LayoutOrder}, MainContent)

local Title = make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 24),
    Text = "XL3RL HUB",
    Font = Enum.Font.GothamBlack,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(0,255,200),
    BackgroundTransparency = 1,
    LayoutOrder = 1
}, MainContent)

local btnNoClip = makeButton("NO-CLIP MENU", MainContent, Color3.fromRGB(0,200,255), Color3.fromRGB(0,255,150), 32); btnNoClip.LayoutOrder = 2
local btnAutoLaser = makeButton("AUTO-LASER MENU", MainContent, Color3.fromRGB(255,90,90), Color3.fromRGB(180,0,0), 32); btnAutoLaser.LayoutOrder = 3
local btnCombo = makeButton("COMBO SCRIPTS", MainContent, Color3.fromRGB(160,60,255), Color3.fromRGB(60,0,160), 32); btnCombo.LayoutOrder = 4
local btnServer = makeButton("CAMBIAR SERVIDOR", MainContent, Color3.fromRGB(40,150,255), Color3.fromRGB(0,90,200), 32); btnServer.LayoutOrder = 5

--==================== Panel NO-CLIP ====================--
local NCPanel = make("Frame", {
    Size = UDim2.new(0, 150, 0, 96),
    Position = UDim2.new(0.78, -75, 0.25, 0),
    BackgroundColor3 = Color3.fromRGB(22,22,22),
    Visible = false
}, Screen)
makeDraggable(NCPanel, NCPanel)
make("UICorner", {CornerRadius = UDim.new(0, 14)}, NCPanel)
make("UIStroke", {Thickness = 3, Color = Color3.fromRGB(0,255,120)}, NCPanel)

local NCContent = make("Frame", {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1}, NCPanel)
make("UIPadding", {PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}, NCContent)
make("UIListLayout", {Padding = UDim.new(0, 6), FillDirection = Enum.FillDirection.Vertical, HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Top, SortOrder = Enum.SortOrder.LayoutOrder}, NCContent)

local NCHeader = make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = "NO-CLIP",
    Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(0,255,170),
    TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 1
}, NCContent)

local NCButton = make("TextButton", {
    Size = UDim2.new(1, 0, 0, 40), Text = "ACTIVAR NO-CLIP",
    Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(255,255,255),
    AutoButtonColor = false, BackgroundColor3 = Color3.fromRGB(0, 160, 0), LayoutOrder = 2
}, NCContent)
make("UICorner", {CornerRadius = UDim.new(0, 10)}, NCButton)
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
        TweenService:Create(NCButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(170, 20, 20)}):Play()
    elseif (not on) and noClipOn then
        if noClipConn then noClipConn:Disconnect() end
        noClipConn = nil; noClipOn = false
        local ch = LP.Character
        if ch then
            for _,p in ipairs(ch:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
        NCButton.Text = "ACTIVAR NO-CLIP"
        TweenService:Create(NCButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 160, 0)}):Play()
    end
end
NCButton.MouseButton1Click:Connect(function() setNoClip(not noClipOn) end)

--==================== Panel AUTO-LASER ====================--
local ALPanel = make("Frame", {
    Size = UDim2.new(0, 170, 0, 96),
    Position = UDim2.new(0.78, -85, 0.45, 0),
    BackgroundColor3 = Color3.fromRGB(22,22,22),
    Visible = false
}, Screen)
makeDraggable(ALPanel, ALPanel)
make("UICorner", {CornerRadius = UDim.new(0, 14)}, ALPanel)
make("UIStroke", {Thickness = 3, Color = Color3.fromRGB(255,120,120)}, ALPanel)

local ALContent = make("Frame", {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1}, ALPanel)
make("UIPadding", {PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}, ALContent)
make("UIListLayout", {Padding = UDim.new(0, 6), FillDirection = Enum.FillDirection.Vertical, HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Top, SortOrder = Enum.SortOrder.LayoutOrder}, ALContent)

local ALHeader = make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = "AUTO-LASER",
    Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(255,170,170),
    TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 1
}, ALContent)

local ALButton = make("TextButton", {
    Size = UDim2.new(1, 0, 0, 40), Text = "ACTIVAR AUTO-LASER",
    Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(255,255,255),
    AutoButtonColor = false, BackgroundColor3 = Color3.fromRGB(160, 0, 0), LayoutOrder = 2
}, ALContent)
make("UICorner", {CornerRadius = UDim.new(0, 10)}, ALButton)
make("UIStroke", {Thickness = 2, Color = Color3.fromRGB(255,120,120)}, ALButton)

--==== Auto-Láser lógica (equip/unequip + guardian) ====--
local NetFolder = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Net")
local RE_UseItem = NetFolder and NetFolder:FindFirstChild("RE/UseItem")
local RF_Buy     = NetFolder and NetFolder:FindFirstChild("RF/CoinsShopService/RequestBuy")

local autoLaserOn = false
local shootConn, guardConn
local lastBuy = 0

local function getBackpack() return LP:FindFirstChild("Backpack") or LP:WaitForChild("Backpack") end
local function char() return LP.Character or LP.CharacterAdded:Wait() end

local function unequipAllTools()
    local c = char()
    for _,tool in ipairs(c:GetChildren()) do
        if tool:IsA("Tool") then tool.Parent = getBackpack() end
    end
end

local function hasLaserEquipped()
    local c = LP.Character
    if not c then return false end
    return c:FindFirstChild("Laser Cape") ~= nil
end
local function hasLaserInBackpack()
    local bp = getBackpack()
    return bp:FindFirstChild("Laser Cape") ~= nil
end

local function safeBuyLaser()
    if not RF_Buy then return end
    local now = os.clock()
    if now - lastBuy < 5 then return end -- anti-spam compra
    lastBuy = now
    pcall(function()
        RF_Buy:InvokeServer("Laser Cape")
    end)
end

local function equipLaserCape()
    -- quitar cualquier otro tool para evitar conflicto
    unequipAllTools()
    -- equipar desde mochila si existe
    local bp = getBackpack()
    local tool = bp:FindFirstChild("Laser Cape")
    if tool then
        tool.Parent = char()
        return
    end
    -- si no está, intentar comprar y reintentar equipar
    safeBuyLaser()
    task.delay(0.4, function()
        local t2 = bp:FindFirstChild("Laser Cape")
        if t2 then t2.Parent = char() end
    end)
end

local function removeLaserCape()
    local c = LP.Character
    if not c then return end
    local tool = c:FindFirstChild("Laser Cape")
    if tool then tool.Parent = getBackpack() end
end

local function findAnyPartNear(pos)
    -- intenta map parts, si no, usa Terrain
    local closest, minD = nil, math.huge
    for _,inst in ipairs(workspace:GetDescendants()) do
        if inst:IsA("BasePart") and inst.CanCollide then
            local d = (inst.Position - pos).Magnitude
            if d < minD then
                minD = d; closest = inst
            end
        end
    end
    return closest or workspace.Terrain
end

local function shootAtPlayers()
    if not RE_UseItem then return end
    local me = LP
    local myC = me.Character
    local myHRP = myC and myC:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    local nearest, nd = nil, math.huge
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl ~= me and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            local p = pl.Character.HumanoidRootPart.Position
            local d = (p - myHRP.Position).Magnitude
            if d < nd then nd = d; nearest = p end
        end
    end
    if nearest then
        local targetPos = nearest
        local part = findAnyPartNear(targetPos)
        pcall(function()
            RE_UseItem:FireServer(targetPos, part)
        end)
    end
end

local function setAutoLaser(state)
    autoLaserOn = state
    if state then
        -- UI ON
        ALButton.Text = "DESACTIVAR AUTO-LASER"
        TweenService:Create(ALButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 160, 0)}):Play()

        -- Equipar inmediatamente
        equipLaserCape()

        -- Guardian: re-equipar si se cae o respawnea, y compra con cooldown si falta
        if guardConn then guardConn:Disconnect() end
        guardConn = RunService.Heartbeat:Connect(function()
            if not autoLaserOn then return end
            if not hasLaserEquipped() then
                if hasLaserInBackpack() then
                    equipLaserCape()
                else
                    safeBuyLaser()
                end
            end
        end)

        -- Disparo periódico (throttle)
        if shootConn then shootConn:Disconnect() end
        local lastShot = 0
        shootConn = RunService.RenderStepped:Connect(function()
            if not autoLaserOn then return end
            local now = os.clock()
            if now - lastShot > 0.18 then
                lastShot = now
                shootAtPlayers()
            end
        end)

    else
        -- UI OFF
        ALButton.Text = "ACTIVAR AUTO-LASER"
        TweenService:Create(ALButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(160, 0, 0)}):Play()

        if shootConn then shootConn:Disconnect() end
        shootConn = nil
        if guardConn then guardConn:Disconnect() end
        guardConn = nil

        removeLaserCape()
    end
end

ALButton.MouseButton1Click:Connect(function()
    setAutoLaser(not autoLaserOn)
end)

--==================== Acciones de botones HUB ====================--
btnNoClip.MouseButton1Click:Connect(function()
    NCPanel.Visible = not NCPanel.Visible
end)

btnAutoLaser.MouseButton1Click:Connect(function()
    ALPanel.Visible = not ALPanel.Visible
end)

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

-- Toggle menú con icono flotante y con tecla
FloatText.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)
UserInputService.InputBegan:Connect(function(inp, gpe)
    if not gpe and inp.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)

-- Auto re-equipar si respawnea y estaba ON
LP.CharacterAdded:Connect(function()
    if autoLaserOn then
        task.wait(1)
        equipLaserCape()
    end
end)
