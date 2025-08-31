--========================================================
-- AUTO COMPRADOR BRAINROOTS con MENÚ ON/OFF
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

-- RemoteEvents
local buyPromptRE = game:GetService("ReplicatedStorage").Packages.Net:FindFirstChild("RE/66c7b24d-afa4-4e21-bc48-9c829967a853")
local confirmBuyRE = game:GetService("ReplicatedStorage").Packages.Net:FindFirstChild("RE/33094f22-ae31-46fd-88a7-27cb2c124c68")

-- Función auto-compra
local function autoBuyBrainroot()
    if buyPromptRE and confirmBuyRE then
        -- Reemplaza los IDs si cambian en el juego
        local promptArgs1 = {1756602775.803311,"2f50452e-560d-46c0-9bba-85e82addf934"}
        local promptArgs2 = {1756602775.803271,"1ae60adf-47e4-4395-b011-8e092ab239eb"}

        local confirmArgs1 = {1756602697.388041,"064f9995-3c29-4b3d-bf62-9d93de6836ae","539ed3e2-8cc0-41b8-9ad0-1bce37c76a8d"}
        local confirmArgs2 = {1756602697.388098,"e7b56b5c-a11a-4dfd-997d-d16b81dd3fed","539ed3e2-8cc0-41b8-9ad0-1bce37c76a8d"}

        -- Disparar los RemoteEvents
        buyPromptRE:FireServer(unpack(promptArgs1))
        buyPromptRE:FireServer(unpack(promptArgs2))

        task.wait(0.1) -- pequeño delay para que el juego procese

        confirmBuyRE:FireServer(unpack(confirmArgs1))
        confirmBuyRE:FireServer(unpack(confirmArgs2))
    end
end

-- Loop automático
task.spawn(function()
    while task.wait(1) do -- cada 1 segundo intenta comprar
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
