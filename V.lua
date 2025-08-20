--[[========================================================
   XL3RL HUB – PREMIUM UI (Compact Version)
   - Menú principal y No-Clip "casi a la mitad"
   - Icono flotante arrastrable
   - Menú No-Clip estilo “ATIVAR TELEGUIADO”
   - Combo Scripts + Cambiar Servidor
==========================================================]]

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local LP                = Players.LocalPlayer

-- Limpieza previa
pcall(function()
    local g = LP:WaitForChild("PlayerGui"):FindFirstChild("XL3RL_GUI")
    if g then g:Destroy() end
end)

--==================== Helpers ====================--
local function make(instance, props, parent)
    local i = Instance.new(instance)
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
    TweenService:Create(ui, TweenInfo.new(0.18, Enum.EasingStyle.Sine), {Size = goalSize}):Play()
    task.delay(0.18, function()
        TweenService:Create(ui, TweenInfo.new(0.18, Enum.EasingStyle.Sine), {Size = s}):Play()
    end)
end

local function makeButton(text, parent, gradA, gradB, height)
    local h = height or 32
    local btn = make("TextButton", {
        Size = UDim2.new(0.9, 0, 0, h),
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = Color3.fromRGB(255,255,255),
        BackgroundColor3 = Color3.fromRGB(40,40,40),
        AutoButtonColor = false
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
        pulse(btn, UDim2.new(0.92,0,0,h+2))
    end)
    return btn
end

--==================== GUI base ====================--
local Screen = make("ScreenGui", {
    Name = "XL3RL_GUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, LP:WaitForChild("PlayerGui"))

-- Icono flotante (mantengo tamaño normal)
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
makeDraggable(FloatIcon)
FloatText.MouseEnter:Connect(function()
    TweenService:Create(FloatIcon, TweenInfo.new(0.2), {Size = UDim2.new(0,62,0,62)}):Play()
end)
FloatText.MouseLeave:Connect(function()
    TweenService:Create(FloatIcon, TweenInfo.new(0.2), {Size = UDim2.new(0,56,0,56)}):Play()
end)

--==================== Menú principal (compacto) ====================--
local Main = make("Frame", {
    Size = UDim2.new(0, 160, 0, 150),            -- antes 280x260
    Position = UDim2.new(0.5, -80, 0.5, -75),    -- centrado a su nuevo tamaño
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

local Title = make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 28),               -- antes 42
    Text = "XL3RL HUB",
    Font = Enum.Font.GothamBlack,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(0,255,200),
    BackgroundTransparency = 1
}, Main)

local Sub = make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 14),               -- antes 18
    Text = "",
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = Color3.fromRGB(200, 200, 200),
    BackgroundTransparency = 1
}, Main)

local MainLayout = make("UIListLayout", {
    Padding = UDim.new(0, 8),
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Top,
    SortOrder = Enum.SortOrder.LayoutOrder
}, Main)

--==================== Panel NO-CLIP (compacto tipo “ATIVAR”) ====================--
local NCPanel = make("Frame", {
    Size = UDim2.new(0, 150, 0, 96),             -- antes 260x140
    Position = UDim2.new(0.78, -75, 0.25, 0),    -- ajustado por nuevo ancho
    BackgroundColor3 = Color3.fromRGB(22,22,22),
    Visible = false
}, Screen)
makeDraggable(NCPanel)
make("UICorner", {CornerRadius = UDim.new(0, 14)}, NCPanel)
make("UIStroke", {Thickness = 3, Color = Color3.fromRGB(0,255,120)}, NCPanel)

local NCHeader = make("TextLabel", {
    Size = UDim2.new(1, -14, 0, 24),             -- antes 30
    Position = UDim2.new(0, 7, 0, 6),
    BackgroundTransparency = 1,
    Text = "NO-CLIP",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(0,255,170),
    TextXAlignment = Enum.TextXAlignment.Left
}, NCPanel)

local NCButton = make("TextButton", {
    Size = UDim2.new(1, -20, 0, 40),             -- antes 50
    Position = UDim2.new(0, 10, 0, 48),
    Text = "ACTIVAR NO-CLIP",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(255,255,255),
    AutoButtonColor = false,
    BackgroundColor3 = Color3.fromRGB(0, 160, 0)
}, NCPanel)
make("UICorner", {CornerRadius = UDim.new(0, 10)}, NCButton)
make("UIStroke", {Thickness = 2, Color = Color3.fromRGB(0,255,120)}, NCButton)

-- lógica No-Clip
local noClipConn
local noClipOn = false
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
        noClipConn = nil
        noClipOn = false
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
NCButton.MouseButton1Click:Connect(function()
    setNoClip(not noClipOn)
end)

--==================== Botones del HUB ====================--
local btnNoClip = makeButton("NO-CLIP MENU", Main, Color3.fromRGB(0,200,255), Color3.fromRGB(0,255,150), 32)
btnNoClip.MouseButton1Click:Connect(function()
    NCPanel.Visible = not NCPanel.Visible
end)

local btnCombo = makeButton("COMBO SCRIPTS", Main, Color3.fromRGB(160,60,255), Color3.fromRGB(60,0,160), 32)
btnCombo.MouseButton1Click:Connect(function()
    pulse(btnCombo, UDim2.new(0.92,0,0,34))
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))()
    end)
    pcall(function()
        loadstring(game:HttpGet("https://gist.githubusercontent.com/UCT-hub/5b11d10386f1b8ce08feb803861e0b79/raw/b2917b398d4b0cc80fb2aca73a3137ba494ebcf0/gistfile1.txt"))()
    end)
end)

local btnServer = makeButton("CAMBIAR SERVIDOR", Main, Color3.fromRGB(40,150,255), Color3.fromRGB(0,90,200), 32)
btnServer.MouseButton1Click:Connect(function()
    pulse(btnServer, UDim2.new(0.92,0,0,34))
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Gato-bytes/GatoHubOnTop/refs/heads/main/AutoJoin.lua"))()
    end)
end)

-- Toggle menú con el icono flotante
FloatText.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Toggle con tecla (PC)
UserInputService.InputBegan:Connect(function(inp, gpe)
    if not gpe and inp.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)
