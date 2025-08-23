-- MiniSpy Visual – Solo RE/UseItem
-- Captura y muestra en un menú el último Remote detectado

local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- Referencia al Remote
local remote = RS:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE"):WaitForChild("UseItem")

-- Guardamos los últimos argumentos
local lastArgs = nil

-- Función UI helper
local function make(class, props, parent)
    local i = Instance.new(class)
    for k,v in pairs(props) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end

-- ScreenGui
local Screen = make("ScreenGui", {Name="MiniSpyUI", ResetOnSpawn=false}, LP:WaitForChild("PlayerGui"))

-- Icono flotante
local Float = make("TextButton", {
    Size = UDim2.new(0,50,0,50),
    Position = UDim2.new(0.12,0,0.18,0),
    BackgroundColor3 = Color3.fromRGB(30,30,30),
    Text = "👁",
    TextColor3 = Color3.fromRGB(0,255,200),
    Font = Enum.Font.GothamBlack,
    TextSize = 20
}, Screen)
make("UICorner", {CornerRadius=UDim.new(1,0)}, Float)

-- Panel menú
local Menu = make("Frame", {
    Size = UDim2.new(0,200,0,120),
    Position = UDim2.new(0.5,-100,0.5,-60),
    BackgroundColor3 = Color3.fromRGB(25,25,25),
    Visible = false
}, Screen)
make("UICorner", {CornerRadius=UDim.new(0,10)}, Menu)

local Title = make("TextLabel", {
    Size = UDim2.new(1,0,0,24),
    BackgroundTransparency = 1,
    Text = "MiniSpy Logs",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(0,255,200)
}, Menu)

local LogLabel = make("TextLabel", {
    Size = UDim2.new(1,-10,0,40),
    Position = UDim2.new(0,5,0,28),
    BackgroundTransparency = 1,
    Text = "Esperando Remote...",
    TextWrapped = true,
    Font = Enum.Font.Code,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(255,255,255)
}, Menu)

local BtnUse = make("TextButton", {
    Size = UDim2.new(1,-20,0,30),
    Position = UDim2.new(0,10,1,-40),
    BackgroundColor3 = Color3.fromRGB(0,150,0),
    Text = "▶ Usar Último Remote",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(255,255,255)
}, Menu)
make("UICorner", {CornerRadius=UDim.new(0,6)}, BtnUse)

-- Toggle menú
Float.MouseButton1Click:Connect(function()
    Menu.Visible = not Menu.Visible
end)

-- Botón de reenvío
BtnUse.MouseButton1Click:Connect(function()
    if lastArgs then
        remote:FireServer(unpack(lastArgs))
        LogLabel.Text = "🚀 Remote reenviado!"
    else
        LogLabel.Text = "❌ No hay remote capturado aún."
    end
end)

-- Hook para capturar Remote
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    if self == remote and getnamecallmethod() == "FireServer" then
        lastArgs = args
        local display = {}
        for i,v in ipairs(args) do
            table.insert(display, tostring(v))
        end
        LogLabel.Text = "⚡ Capturado:\n{".. table.concat(display,", ").."}"
    end
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)
