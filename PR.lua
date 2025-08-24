--[[
    SCRIPT: XL3RL HUB - AUTO-LASER ULTRA SPLIT
    - Disparo estable (cada 0.2s).
    - Equipar capa y remover tools lo más rápido posible (Heartbeat).
]]

-- =========================================================================================
--                                   1. SERVICIOS Y JUGADOR
-- =========================================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

-- =========================================================================================
--                                   2. CONFIG Y HELPERS
-- =========================================================================================
local Config = {
    MainColor = Color3.fromRGB(0, 255, 150),
    BackgroundColor = Color3.fromRGB(25, 27, 35),
    MutedColor = Color3.fromRGB(40, 42, 50),
    TextColor = Color3.fromRGB(255, 255, 255),
    Keybind = Enum.KeyCode.RightShift
}

local function make(className, props, parent)
    local i = Instance.new(className)
    for k,v in pairs(props or {}) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end

-- =========================================================================================
--                                   3. GUI BASE
-- =========================================================================================
pcall(function() if LP.PlayerGui:FindFirstChild("XL3RL_FUSION_GUI") then LP.PlayerGui.XL3RL_FUSION_GUI:Destroy() end end)
local Screen = make("ScreenGui", { Name = "XL3RL_FUSION_GUI", ResetOnSpawn = false }, LP:WaitForChild("PlayerGui"))

local FloatIcon = make("ImageButton", {
    Size = UDim2.new(0,50,0,50), Position = UDim2.new(0,20,0.5,-25),
    BackgroundColor3 = Config.BackgroundColor, Image = "rbxassetid://6034849723",
    ImageColor3 = Config.MainColor
}, Screen)
make("UICorner",{CornerRadius = UDim.new(1,0)},FloatIcon)

local Main = make("Frame", {Size = UDim2.new(0,160,0,200),Position = UDim2.new(0.5,-80,0.5,-100),BackgroundColor3 = Config.BackgroundColor,Visible = false}, Screen)
make("UICorner",{CornerRadius = UDim.new(0,8)},Main)

local MainContent = make("Frame",{Size = UDim2.fromScale(1,1),BackgroundTransparency=1},Main)
make("UIListLayout",{Padding=UDim.new(0,8)},MainContent)

local Title = make("TextLabel",{Size=UDim2.new(1,0,0,24),Text="XL3RL FUSIÓN",TextSize=16,Font=Enum.Font.Code,TextColor3=Config.MainColor,BackgroundTransparency=1},MainContent)

-- Panel Auto-Laser
local LaserPanel = make("Frame",{Size=UDim2.new(0,160,0,100),BackgroundColor3=Config.BackgroundColor,Visible=false},Screen)
make("UICorner",{CornerRadius=UDim.new(0,8)},LaserPanel)
local laserTitle = make("TextLabel",{Size=UDim2.new(1,0,0,30),Text="AUTO-LASER",Font=Enum.Font.Code,TextSize=16,TextColor3=Config.MainColor,BackgroundTransparency=1},LaserPanel)
local laserButton = make("TextButton",{Size=UDim2.new(1,-20,0,40),Position=UDim2.new(0,10,0,40),Text="ACTIVAR",Font=Enum.Font.Code,TextSize=14,TextColor3=Config.TextColor,BackgroundColor3=Color3.fromRGB(0,160,0)},LaserPanel)
make("UICorner",{CornerRadius=UDim.new(0,6)},laserButton)

-- =========================================================================================
--                                   4. AUTO-LASER LOGIC
-- =========================================================================================
local LaserRemote = ReplicatedStorage:FindFirstChild("RE/UseItem", true)
local BuyRF = ReplicatedStorage:FindFirstChild("RF/CoinsShopService/RequestBuy", true)

-- Helpers
local function getLaserTool()
    if LP.Backpack then
        for _,t in ipairs(LP.Backpack:GetChildren()) do
            if t:IsA("Tool") and string.find(t.Name:lower(),"laser") then return t end
        end
    end
    if LP.Character then
        for _,t in ipairs(LP.Character:GetChildren()) do
            if t:IsA("Tool") and string.find(t.Name:lower(),"laser") then return t end
        end
    end
    return nil
end

local function equipLaserCape()
    local tool = getLaserTool()
    if not tool and BuyRF then pcall(function() BuyRF:InvokeServer("Laser Cape") end) tool = getLaserTool() end
    if tool and LP.Character then tool.Parent = LP.Character end
end

local function removeOtherTools()
    if LP.Character then
        for _,t in ipairs(LP.Character:GetChildren()) do
            if t:IsA("Tool") and not string.find(t.Name:lower(),"laser") then t.Parent = LP.Backpack end
        end
    end
end

-- Auto-Laser
local autoLaser, hbConn, shootLoop = false, nil, nil
laserButton.MouseButton1Click:Connect(function()
    autoLaser = not autoLaser
    if autoLaser then
        laserButton.Text, laserButton.BackgroundColor3 = "DESACTIVAR", Color3.fromRGB(170,20,20)
        
        -- Ultra rápido: equipar capa + limpiar otras tools
        hbConn = RunService.Heartbeat:Connect(function()
            if autoLaser then
                equipLaserCape()
                removeOtherTools()
            end
        end)

        -- Disparo estable
        shootLoop = task.spawn(function()
            while autoLaser do
                task.wait(0.2)
                if LaserRemote and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                    local myHRP = LP.Character.HumanoidRootPart
                    local closest, dist = nil, 150
                    for _,pl in ipairs(Players:GetPlayers()) do
                        if pl~=LP and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                            local d = (pl.Character.HumanoidRootPart.Position - myHRP.Position).Magnitude
                            if d < dist then closest, dist = pl.Character.HumanoidRootPart, d end
                        end
                    end
                    if closest then
                        pcall(function() LaserRemote:FireServer(closest.Position, closest) end)
                    end
                end
            end
        end)
    else
        if hbConn then hbConn:Disconnect() hbConn=nil end
        laserButton.Text, laserButton.BackgroundColor3 = "ACTIVAR", Color3.fromRGB(0,160,0)
    end
end)

-- =========================================================================================
--                                   5. BOTONES MENÚ
-- =========================================================================================
local function makeMainButton(text, order, panel)
    local btn = make("TextButton",{Size=UDim2.new(1,0,0,32),Text=text,Font=Enum.Font.Code,TextSize=14,TextColor3=Config.TextColor,BackgroundColor3=Config.MutedColor,LayoutOrder=order},MainContent)
    make("UICorner",{CornerRadius=UDim.new(0,6)},btn)
    if panel then btn.MouseButton1Click:Connect(function() panel.Visible = not panel.Visible end) end
    return btn
end

makeMainButton("AUTO-LASER",2,LaserPanel)

-- =========================================================================================
--                                   6. INIT
-- =========================================================================================
FloatIcon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
UserInputService.InputBegan:Connect(function(inp,gpe) if not gpe and inp.KeyCode==Config.Keybind then Main.Visible=not Main.Visible end end)
