--========================================================
-- AUTO COMPRADOR BRAINROOTS INTELIGENTE con MENÚ ON/OFF
--========================================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
ScreenGui.Name = "AutoBuyBrainrootsGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,200,0,100)
Frame.Position = UDim2.new(0.5,-100,0.5,-50)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true

local Btn = Instance.new("TextButton", Frame)
Btn.Size = UDim2.new(1,-20,0,40)
Btn.Position = UDim2.new(0,10,0.5,-20)
Btn.Text = "Auto Comprar Brainroots: OFF"
Btn.BackgroundColor3 = Color3.fromRGB(170,0,0)
Btn.TextColor3 = Color3.new(1,1,1)
Btn.Font = Enum.Font.SourceSansBold
Btn.TextSize = 16

-- Estado
local autoBuy = false

-- Función para buscar RemoteEvents relevantes
local function getBrainrootREs()
    local netFolder = game:GetService("ReplicatedStorage").Packages.Net
    local buyREs = {}
    local confirmREs = {}

    for _, v in ipairs(netFolder:GetChildren()) do
        if v:IsA("RemoteEvent") then
            local name = v.Name:lower()
            if name:find("66c7b24d") or name:find("prompt") then
                table.insert(buyREs, v)
            elseif name:find("33094f22") or name:find("confirm") then
                table.insert(confirmREs, v)
            end
        end
    end

    return buyREs, confirmREs
end

-- Función para disparar RemoteEvents con IDs dinámicos
local function autoBuyBrainroot()
    local buyREs, confirmREs = getBrainrootREs()
    if #buyREs == 0 or #confirmREs == 0 then return end

    for _, buyRE in ipairs(buyREs) do
        -- Generar ID dinámico aproximado (puedes ajustarlo si el juego requiere)
        local args1 = {os.time(),"dummy-arg-1"}
        local args2 = {os.time(),"dummy-arg-2"}
        pcall(function()
            buyRE:FireServer(unpack(args1))
            buyRE:FireServer(unpack(args2))
        end)
    end

    task.wait(0.1)

    for _, confirmRE in ipairs(confirmREs) do
        local args1 = {os.time(),"dummy-confirm-1","dummy-confirm-2"}
        local args2 = {os.time(),"dummy-confirm-3","dummy-confirm-4"}
        pcall(function()
            confirmRE:FireServer(unpack(args1))
            confirmRE:FireServer(unpack(args2))
        end)
    end
end

-- Loop automático cada 1.5 segundos
task.spawn(function()
    while task.wait(1.5) do
        if autoBuy then
            autoBuyBrainroot()
        end
    end
end)

-- Botón ON/OFF
Btn.MouseButton1Click:Connect(function()
    autoBuy = not autoBuy
    if autoBuy then
        Btn.Text = "Auto Comprar Brainroots: ON"
        Btn.BackgroundColor3 = Color3.fromRGB(0,170,0)
    else
        Btn.Text = "Auto Comprar Brainroots: OFF"
        Btn.BackgroundColor3 = Color3.fromRGB(170,0,0)
    end
end)
