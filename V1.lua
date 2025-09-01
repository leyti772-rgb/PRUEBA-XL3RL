--[[
    SCRIPT: XL3RL HUB - FUSIÓN FINAL
    AUTOR: Gemini + ChatGPT
    CAMBIOS:
      * Auto-Laser apaga INMEDIATAMENTE al agarrar un Brainroot (hook directo a FireServer).
      * Mantiene auto-equipar capa Laser, auto-desequipar al desactivar.
      * Loop constante para limpiar otros ítems y evitar mezclas.
      * Todas las funciones previas (No-Clip, Combo Scripts, Server) intactas.
]]

-- =========================================================================================
--                                   SERVICIOS Y JUGADOR
-- =========================================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

-- =========================================================================================
--                                   CONFIG
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
--                                   DRAG SYSTEM
-- =========================================================================================
local function makeDraggable(frame, trigger)
    local dragging, dragStart, startPos
    trigger.InputBegan:Connect(function(input)
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
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- =========================================================================================
--                                   GUI BASE
-- =========================================================================================
pcall(function() if LP.PlayerGui:FindFirstChild("XL3RL_FUSION_GUI") then LP.PlayerGui.XL3RL_FUSION_GUI:Destroy() end end)

local Screen = make("ScreenGui", {Name="XL3RL_FUSION_GUI", ResetOnSpawn=false}, LP:WaitForChild("PlayerGui"))

local FloatIcon = make("ImageButton", {
    Size = UDim2.new(0,50,0,50), Position = UDim2.new(0,20,0.5,-25),
    BackgroundColor3 = Config.BackgroundColor, BackgroundTransparency=0.2,
    Image="rbxassetid://6034849723", ImageColor3=Config.MainColor
}, Screen)
make("UICorner",{CornerRadius=UDim.new(1,0)},FloatIcon)
make("UIStroke",{Color=Config.MainColor},FloatIcon)

local Main = make("Frame", {
    Size = UDim2.new(0,160,0,200), Position = UDim2.new(0.5,-80,0.5,-100),
    BackgroundColor3=Config.BackgroundColor, Visible=false
}, Screen)
make("UICorner",{CornerRadius=UDim.new(0,8)},Main)
make("UIStroke",{Thickness=2, Color=Config.MainColor},Main)

local MainContent = make("Frame",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1},Main)
make("UIPadding",{PaddingTop=UDim.new(0,8), PaddingBottom=UDim.new(0,8), PaddingLeft=UDim.new(0,10), PaddingRight=UDim.new(0,10)},MainContent)
make("UIListLayout",{Padding=UDim.new(0,8), SortOrder=Enum.SortOrder.LayoutOrder},MainContent)

local Title = make("TextLabel",{
    Size=UDim2.new(1,0,0,24), Text="XL3RL FUSIÓN", Font=Enum.Font.Code,
    TextSize=16, TextColor3=Config.MainColor, BackgroundTransparency=1
},MainContent)

-- =========================================================================================
--                                   PANELES
-- =========================================================================================
-- NoClip
local NCPanel = make("Frame",{Size=UDim2.new(0,160,0,100), Visible=false, BackgroundColor3=Config.BackgroundColor},Screen)
make("UICorner",{CornerRadius=UDim.new(0,8)},NCPanel)
make("UIStroke",{Color=Config.MainColor},NCPanel)
local ncTitle = make("TextLabel",{Size=UDim2.new(1,0,0,30), Text="NO-CLIP", Font=Enum.Font.Code, TextSize=16, TextColor3=Config.MainColor, BackgroundTransparency=1},NCPanel)
local ncButton = make("TextButton",{Size=UDim2.new(1,-20,0,40), Position=UDim2.new(0,10,0,40), Text="ACTIVAR", BackgroundColor3=Color3.fromRGB(0,160,0), TextColor3=Config.TextColor},NCPanel)
make("UICorner",{CornerRadius=UDim.new(0,6)},ncButton)

-- AutoLaser
local LaserPanel = make("Frame",{Size=UDim2.new(0,160,0,100),Position = UDim2.new(1, -180, 0, 20), Visible=false, BackgroundColor3=Config.BackgroundColor},Screen)
make("UICorner",{CornerRadius=UDim.new(0,8)},LaserPanel)
make("UIStroke",{Color=Config.MainColor},LaserPanel)
local laserTitle = make("TextLabel",{Size=UDim2.new(1,0,0,30), Text="AUTO-LASER", Font=Enum.Font.Code, TextSize=16, TextColor3=Config.MainColor, BackgroundTransparency=1},LaserPanel)
local laserButton = make("TextButton",{Size=UDim2.new(1,-20,0,40), Position=UDim2.new(0,10,0,40), Text="ACTIVAR", BackgroundColor3=Color3.fromRGB(0,160,0), TextColor3=Config.TextColor},LaserPanel)
make("UICorner",{CornerRadius=UDim.new(0,6)},laserButton)

-- =========================================================================================
--                                   FUNCIONES
-- =========================================================================================
-- NoClip
local noClip=false; local conn
ncButton.MouseButton1Click:Connect(function()
    noClip=not noClip
    if noClip then
        conn=RunService.Stepped:Connect(function()
            if LP.Character then for _,p in ipairs(LP.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
        end)
        ncButton.Text, ncButton.BackgroundColor3="DESACTIVAR",Color3.fromRGB(170,20,20)
    else
        if conn then conn:Disconnect() conn=nil end
        ncButton.Text, ncButton.BackgroundColor3="ACTIVAR",Color3.fromRGB(0,160,0)
    end
end)

-- AutoLaser Vars
local LaserRemote = ReplicatedStorage:FindFirstChild("RE/UseItem",true)
local BuyRF = ReplicatedStorage:FindFirstChild("RF/CoinsShopService/RequestBuy",true)
local autoLaser=false; local laserLoop

local function getLaserTool()
    if LP.Backpack then for _,t in ipairs(LP.Backpack:GetChildren()) do if t:IsA("Tool") and t.Name=="Laser Cape" then return t end end end
    if LP.Character then for _,t in ipairs(LP.Character:GetChildren()) do if t:IsA("Tool") and t.Name=="Laser Cape" then return t end end end
    return nil
end

local function equipLaserCape()
    local t=getLaserTool()
    if t then t.Parent=LP.Character return true end
    if BuyRF then pcall(function() BuyRF:InvokeServer("Laser Cape") end) end
    return false
end

local function unequipLaserCape()
    local t=getLaserTool()
    if t then t.Parent=LP.Backpack end
end

-- limpiar otros items
local function clearOtherTools()
    if LP.Character then
        for _,tool in ipairs(LP.Character:GetChildren()) do
            if tool:IsA("Tool") and tool.Name~="Laser Cape" then
                tool.Parent=LP.Backpack
            end
        end
    end
end

-- AutoLaser Toggle
laserButton.MouseButton1Click:Connect(function()
    autoLaser=not autoLaser
    if autoLaser then
        laserButton.Text,laserButton.BackgroundColor3="DESACTIVAR",Color3.fromRGB(170,20,20)
        equipLaserCape()
        if laserLoop then laserLoop:Disconnect() end
        laserLoop=RunService.Heartbeat:Connect(function()
            equipLaserCape()
            clearOtherTools()
        end)
    else
        laserButton.Text,laserButton.BackgroundColor3="ACTIVAR",Color3.fromRGB(0,160,0)
        if laserLoop then laserLoop:Disconnect() laserLoop=nil end
        unequipLaserCape()
    end
end)

-- apagar autoLaser al tomar BRAINROOT
local old; old=hookmetamethod(game,"__namecall",function(self,...)
    local m=getnamecallmethod()
    if tostring(self):find("RE/280b459b") and m=="FireServer" then
        if autoLaser then
            autoLaser=false
            if laserLoop then laserLoop:Disconnect() laserLoop=nil end
            laserButton.Text,laserButton.BackgroundColor3="ACTIVAR",Color3.fromRGB(0,160,0)
            unequipLaserCape()
        end
    end
    return old(self,...)
end)

-- Disparo AutoLaser mejorado: SIEMPRE al jugador más cercano
task.spawn(function()
    while task.wait(0.1) do
        if autoLaser and LaserRemote and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local myHRP = LP.Character.HumanoidRootPart
            local closest, dist = nil, 80 -- rango "infinito", ajustable
            for _,pl in ipairs(Players:GetPlayers()) do
                if pl ~= LP and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (pl.Character.HumanoidRootPart.Position - myHRP.Position).Magnitude
                    if d < dist then
                        closest, dist = pl.Character.HumanoidRootPart, d
                    end
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


-- =========================================================================================
--                                   MENÚ PRINCIPAL
-- =========================================================================================
local function makeMainButton(text,order,panel)
    local b=make("TextButton",{Size=UDim2.new(1,0,0,32),Text=text,Font=Enum.Font.Code,TextSize=14,
    TextColor3=Config.TextColor,BackgroundColor3=Config.MutedColor,LayoutOrder=order},MainContent)
    make("UICorner",{CornerRadius=UDim.new(0,6)},b)
    if panel then b.MouseButton1Click:Connect(function() panel.Visible=not panel.Visible end) end
    return b
end

makeMainButton("NO-CLIP",2,NCPanel)
makeMainButton("AUTO-LASER",3,LaserPanel)
local btnCombo=makeMainButton("COMBO SCRIPTS",4)
local btnServer=makeMainButton("CAMBIAR SERVIDOR",5)

btnCombo.MouseButton1Click:Connect(function()
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))() end)
    pcall(function() loadstring(game:HttpGet("https://pastefy.app/9YIyWc7E/rawxxxx"))() end)
end)
btnServer.MouseButton1Click:Connect(function()
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/murilolol/nslx-autojoiner/refs/heads/main/free.lua"))() end)
end)

-- =========================================================================================
--                                   INIT
-- =========================================================================================
makeDraggable(Main,Title)
makeDraggable(FloatIcon,FloatIcon)
makeDraggable(NCPanel,ncTitle)
makeDraggable(LaserPanel,laserTitle)

FloatIcon.MouseButton1Click:Connect(function() Main.Visible=not Main.Visible end)
UserInputService.InputBegan:Connect(function(inp,gpe) if not gpe and inp.KeyCode==Config.Keybind then Main.Visible=not Main.Visible end end)
