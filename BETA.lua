-- ================================
-- PRUEBA AUTO-LASER (solo botón + lógica)
-- ================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

-- GUI rápida
pcall(function() if LP.PlayerGui:FindFirstChild("PRUEBA_GUI") then LP.PlayerGui.PRUEBA_GUI:Destroy() end end)
local Screen = Instance.new("ScreenGui", LP.PlayerGui)
Screen.Name = "PRUEBA_GUI"

local Btn = Instance.new("TextButton", Screen)
Btn.Size = UDim2.new(0,200,0,50)
Btn.Position = UDim2.new(0.5,-100,0,50)
Btn.Text = "ACTIVAR AUTO-LASER"
Btn.BackgroundColor3 = Color3.fromRGB(0,160,0)

-- Variables
local autoLaser, laserRange = false, 150
local LaserRemote = ReplicatedStorage:FindFirstChild("RE/UseItem", true)
local BuyRF = ReplicatedStorage:FindFirstChild("RF/CoinsShopService/RequestBuy", true)

-- Funciones Laser Cape
local function getLaserTool()
    for _,t in ipairs(LP.Backpack:GetChildren()) do
        if t:IsA("Tool") and string.find(t.Name:lower(),"laser") then return t end
    end
    for _,t in ipairs(LP.Character:GetChildren()) do
        if t:IsA("Tool") and string.find(t.Name:lower(),"laser") then return t end
    end
end

local function equipLaserCape()
    local tool = getLaserTool()
    if not tool and BuyRF then
        pcall(function() BuyRF:InvokeServer("Laser Cape") end)
        task.wait(0.1)
        tool = getLaserTool()
    end
    if tool and LP.Character then
        tool.Parent = LP.Character
    end
end

local function unequipLaserCape()
    local tool = getLaserTool()
    if tool and LP.Backpack then
        tool.Parent = LP.Backpack
    end
end

-- ====== Loop para mantener Laser Cape y eliminar ítems extra ======
task.spawn(function()
    while task.wait(0.05) do -- SUPER RÁPIDO
        if autoLaser then
            equipLaserCape()
            -- Eliminar otros ítems
            if LP.Backpack then
                for _,t in ipairs(LP.Backpack:GetChildren()) do
                    if t:IsA("Tool") and not string.find(t.Name:lower(),"laser") then
                        t:Destroy()
                    end
                end
            end
        end
    end
end)

-- ====== Loop de disparo ======
task.spawn(function()
    while task.wait(0.2) do
        if autoLaser and LaserRemote and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local myHRP = LP.Character.HumanoidRootPart
            local closest, dist = nil, laserRange
            for _,pl in ipairs(Players:GetPlayers()) do
                if pl~=LP and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (pl.Character.HumanoidRootPart.Position - myHRP.Position).Magnitude
                    if d < dist then closest, dist = pl.Character.HumanoidRootPart, d end
                end
            end
            if closest then
                pcall(function()
                    LaserRemote:FireServer(closest.Position, closest)
                end)
            end
        end
    end
end)

-- ====== Detectar Brainroot (apagar Auto-Laser con delay) ======
local function isBrainrootRemote(remoteName)
    return string.match(remoteName:lower(),"stealservice") or string.match(remoteName,"280b459b")
end

for _,obj in ipairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("RemoteEvent") and isBrainrootRemote(obj.Name) then
        obj.OnClientEvent:Connect(function(...)
            if autoLaser then
                task.delay(0.5,function()
                    autoLaser = false
                    Btn.Text, Btn.BackgroundColor3 = "ACTIVAR AUTO-LASER", Color3.fromRGB(0,160,0)
                    unequipLaserCape()
                end)
            end
        end)
    end
end

-- Botón
Btn.MouseButton1Click:Connect(function()
    autoLaser = not autoLaser
    if autoLaser then
        Btn.Text, Btn.BackgroundColor3 = "DESACTIVAR AUTO-LASER", Color3.fromRGB(170,20,20)
        equipLaserCape()
    else
        Btn.Text, Btn.BackgroundColor3 = "ACTIVAR AUTO-LASER", Color3.fromRGB(0,160,0)
        unequipLaserCape()
    end
end)
