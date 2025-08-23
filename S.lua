-- ⚡ MiniSpy Integrado con Hub – Solo RE/UseItem
-- Guarda último remote y permite dispararlo desde un botón

local RS = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- Referencia al Remote
local remote = RS:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE"):WaitForChild("UseItem")

-- Últimos argumentos capturados
local lastArgs = nil

-- Mensajes al chat (para debug)
local function notify(msg)
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[MiniSpy] " .. msg,
        Color = Color3.fromRGB(0,255,200),
        Font = Enum.Font.SourceSansBold,
        FontSize = Enum.FontSize.Size24
    })
end

-- Hook FireServer para capturar args
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    if self == remote and getnamecallmethod() == "FireServer" then
        lastArgs = args
        notify("⚡ Capturado Remote con args: {"..table.concat(args, ", ").."}")
    end
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

notify("✅ MiniSpy (solo UseItem) activado, prueba correr rápido y luego usa el botón en el hub.")

-- ================= UI ================= --
local function make(class, props, parent)
    local i = Instance.new(class)
    for k,v in pairs(props) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end

-- ScreenGui base
local Screen = make("ScreenGui", {Name="MiniSpyHub", ResetOnSpawn=false}, LP:WaitForChild("PlayerGui"))

-- Botón flotante
local Float = make("TextButton", {
    Size = UDim2.new(0,50,0,50),
    Position = UDim2.new(0.1,0,0.2,0),
    BackgroundColor3 = Color3.fromRGB(30,30,30),
    Text = "⚡",
    TextColor3 = Color3.fromRGB(0,255,200),
    Font = Enum.Font.GothamBlack,
    TextSize = 22
}, Screen)
make("UICorner", {CornerRadius=UDim.new(1,0)}, Float)

-- Menú
local Menu = make("Frame", {
    Size = UDim2.new(0,160,0,100),
    Position = UDim2.new(0.5,-80,0.5,-50),
    BackgroundColor3 = Color3.fromRGB(25,25,25),
    Visible = false
}, Screen)
make("UICorner", {CornerRadius=UDim.new(0,12)}, Menu)

local BtnUse = make("TextButton", {
    Size = UDim2.new(1,0,0,40),
    Position = UDim2.new(0,0,0,10),
    Text = "▶ Usar Último Remote",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(255,255,255),
    BackgroundColor3 = Color3.fromRGB(0,150,0)
}, Menu)
make("UICorner", {CornerRadius=UDim.new(0,8)}, BtnUse)

-- Lógica del botón
BtnUse.MouseButton1Click:Connect(function()
    if lastArgs then
        remote:FireServer(unpack(lastArgs))
        notify("🚀 Último Remote reenviado.")
    else
        notify("❌ No hay remote capturado todavía.")
    end
end)

-- Toggle menú
Float.MouseButton1Click:Connect(function()
    Menu.Visible = not Menu.Visible
end)
