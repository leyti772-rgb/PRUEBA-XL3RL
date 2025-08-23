--==================== ICONO FLOTANTE GARANTIZADO (Android/Delta) ====================--
-- Crea SIEMPRE un icono visible y un menú pequeño. No usa hooks. Arrastrable.

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- 1) Limpieza en TODOS los posibles parents (PlayerGui / CoreGui / gethui)
local function safeFindCoreGui()
    local ok,cg = pcall(function() return game:GetService("CoreGui") end)
    return ok and cg or nil
end
local function safeGetHui()
    local ok,h = pcall(function() return gethui and gethui() end)
    return ok and h or nil
end
local function nukeOld(name)
    pcall(function()
        local pg = LP:WaitForChild("PlayerGui")
        local old = pg:FindFirstChild(name); if old then old:Destroy() end
    end)
    local cg = safeFindCoreGui(); if cg then local old = cg:FindFirstChild(name); if old then old:Destroy() end end
    local hui = safeGetHui(); if hui then local old = hui:FindFirstChild(name); if old then old:Destroy() end end
end

nukeOld("XL_ICON_TEST")

-- 2) Elegir el mejor parent posible (prioridad: gethui > CoreGui > PlayerGui)
local function bestParent()
    local hui = safeGetHui()
    if hui then return hui end
    local cg = safeFindCoreGui()
    if cg then return cg end
    return LP:WaitForChild("PlayerGui")
end

-- 3) Crear ScreenGui protegido si el executor lo permite
local Screen = Instance.new("ScreenGui")
Screen.Name = "XL_ICON_TEST"
Screen.ResetOnSpawn = false
Screen.IgnoreGuiInset = false
Screen.DisplayOrder = 9999
local parent = bestParent()

-- Si hay protect_gui disponible, úsalo
pcall(function()
    if syn and syn.protect_gui then syn.protect_gui(Screen) end
end)

Screen.Parent = parent

-- 4) Helpers UI
local TweenService = game:GetService("TweenService")
local function make(class, props, parent)
    local i = Instance.new(class)
    for k,v in pairs(props or {}) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end
local function makeDraggable(f)
    -- Draggable clásico (compatible móvil)
    f.Active = true
    f.Draggable = true
end

-- 5) ICONO FLOTANTE (GRANDE Y VISIBLE)
local Float = make("Frame", {
    Name = "XL_Float",
    Size = UDim2.new(0, 64, 0, 64),
    Position = UDim2.new(0.12, 0, 0.25, 0), -- a la vista, lejos del notch
    BackgroundColor3 = Color3.fromRGB(30,30,30)
}, Screen)
make("UICorner", {CornerRadius = UDim.new(1,0)}, Float)
make("UIStroke", {Thickness = 3, Color = Color3.fromRGB(0,255,150)}, Float)
make("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0,200,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,255,150))
    },
    Rotation = 90
}, Float)

local FloatBtn = make("TextButton", {
    Size = UDim2.fromScale(1,1),
    BackgroundTransparency = 1,
    Text = "👁",
    Font = Enum.Font.GothamBlack,
    TextSize = 28,
    TextColor3 = Color3.fromRGB(255,255,255)
}, Float)

makeDraggable(Float)

-- Animación hover (también en móvil se nota al presionar)
FloatBtn.MouseButton1Down:Connect(function()
    TweenService:Create(Float, TweenInfo.new(0.12), {Size = UDim2.new(0, 70, 0, 70)}):Play()
end)
FloatBtn.MouseButton1Up:Connect(function()
    TweenService:Create(Float, TweenInfo.new(0.12), {Size = UDim2.new(0, 64, 0, 64)}):Play()
end)

-- 6) MENÚ MINI (SIEMPRE VISIBLE AL TOCAR EL ICONO)
local Menu = make("Frame", {
    Name = "XL_MiniMenu",
    Size = UDim2.new(0, 230, 0, 120),
    Position = UDim2.new(0.5, -115, 0.6, -60),
    BackgroundColor3 = Color3.fromRGB(25,25,25),
    Visible = false
}, Screen)
make("UICorner", {CornerRadius = UDim.new(0,12)}, Menu)
make("UIStroke", {Thickness = 2, Color = Color3.fromRGB(0,255,150)}, Menu)
makeDraggable(Menu)

local Pad = make("UIPadding", {
    PaddingTop = UDim.new(0, 8),
    PaddingBottom = UDim.new(0, 8),
    PaddingLeft = UDim.new(0, 10),
    PaddingRight = UDim.new(0, 10)
}, Menu)

local Title = make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 22),
    Text = "Mini Panel XL",
    Font = Enum.Font.GothamBlack,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(0,255,200),
    BackgroundTransparency = 1
}, Menu)

local Info = make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 40),
    Position = UDim2.new(0,0,0,26),
    Text = "Icono OK ✅\nSi ves este menú, el GUI está funcionando.",
    Font = Enum.Font.Gotham,
    TextWrapped = true,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(230,230,230),
    BackgroundTransparency = 1
}, Menu)

local CloseBtn = make("TextButton", {
    Size = UDim2.new(0, 28, 0, 28),
    Position = UDim2.new(1, -32, 0, 4),
    BackgroundColor3 = Color3.fromRGB(45,45,45),
    Text = "×",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = Color3.fromRGB(255,255,255)
}, Menu)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, CloseBtn)

CloseBtn.MouseButton1Click:Connect(function() Menu.Visible = false end)
FloatBtn.MouseButton1Click:Connect(function() Menu.Visible = not Menu.Visible end)

-- 7) MENSAJE DE PRUEBA VISUAL (breve highlight del icono)
task.spawn(function()
    local orig = Float.Position
    TweenService:Create(Float, TweenInfo.new(0.15), {Position = orig + UDim2.new(0,0,0,6)}):Play()
    task.wait(0.18)
    TweenService:Create(Float, TweenInfo.new(0.15), {Position = orig}):Play()
end)

-- FIN: Si corrió sin errores, DEBE verse el icono 👁 sí o sí.
