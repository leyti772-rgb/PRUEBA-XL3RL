-- MiniSpy con icono garantizado (Android Friendly)
-- Se asegura de parentar el GUI al PlayerGui

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local remote = RS:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE"):WaitForChild("UseItem")

-- Limpieza previa
pcall(function()
    local g = LP:WaitForChild("PlayerGui"):FindFirstChild("MiniSpyUI")
    if g then g:Destroy() end
end)

-- Helper
local function make(class, props, parent)
    local i = Instance.new(class)
    for k,v in pairs(props) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end

-- ScreenGui (forzamos a esperar PlayerGui y a parentar allí)
local Screen = make("ScreenGui", {
    Name = "MiniSpyUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, LP:WaitForChild("PlayerGui"))

-- Icono flotante 👁
local Float = make("TextButton", {
    Size = UDim2.new(0,56,0,56),
    Position = UDim2.new(0.15,0,0.25,0),
    BackgroundColor3 = Color3.fromRGB(30,30,30),
    Text = "👁",
    TextColor3 = Color3.fromRGB(0,255,200),
    Font = Enum.Font.GothamBlack,
    TextSize = 24
}, Screen)
make("UICorner", {CornerRadius=UDim.new(1,0)}, Float)

-- Menú panel
local Menu = make("Frame", {
    Size = UDim2.new(0,240,0,140),
    Position = UDim2.new(0.5,-120,0.5,-70),
    BackgroundColor3 = Color3.fromRGB(25,25,25),
    Visible = false
}, Screen)
make("UICorner", {CornerRadius=UDim.new(0,10)}, Menu)

local Title = make("TextLabel", {
    Size = UDim2.new(1,0,0,28),
    BackgroundTransparency = 1,
    Text = "MiniSpy Logs",
    Font = Enum.Font.GothamBlack,
    TextSize = 18,
    TextColor3 = Color3.fromRGB(0,255,200)
}, Menu)

local LogLabel = make("TextLabel", {
    Size = UDim2.new(1,-10,0,60),
    Position = UDim2.new(0,5,0,32),
    BackgroundTransparency = 1,
    Text = "Esperando Remote...",
    TextWrapped = true,
    Font = Enum.Font.Code,
    TextSize = 13,
    TextColor3 = Color3.fromRGB(255,255,255)
}, Menu)

local BtnUse = make("TextButton", {
    Size = UDim2.new(1,-20,0,34),
    Position = UDim2.new(0,10,1,-40),
    BackgroundColor3 = Color3.fromRGB(0,150,0),
    Text = "▶ Reusar Último Remote",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(255,255,255)
}, Menu)
make("UICorner", {CornerRadius=UDim.new(0,6)}, BtnUse)

-- Toggle menú con el icono
Float.MouseButton1Click:Connect(function()
    Menu.Visible = not Menu.Visible
end)

-- Captura simple de Remote (listener directo)
local lastArgs = nil
remote.OnClientEvent:Connect(function(...)
    local args = {...}
    lastArgs = args
    local display = {}
    for i,v in ipairs(args) do
        table.insert(display, tostring(v))
    end
    LogLabel.Text = "⚡ Capturado:\n".. table.concat(display,", ")
end)

-- Botón para reenviar
BtnUse.MouseButton1Click:Connect(function()
    if lastArgs then
        remote:FireServer(unpack(lastArgs))
        LogLabel.Text = "🚀 Remote reenviado!"
    else
        LogLabel.Text = "❌ Nada capturado aún"
    end
end)
