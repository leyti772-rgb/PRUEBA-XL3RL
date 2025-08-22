-- XL3RL HUB + AutoLaser integrado (compacto + flotante)
-- Autor: Gemini & ChatGPT

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

-- Limpieza previa
pcall(function()
    local g = LP:WaitForChild("PlayerGui"):FindFirstChild("XL3RL_GUI")
    if g then g:Destroy() end
end)

-- Helpers
local function make(className, props, parent)
    local i = Instance.new(className)
    for k,v in pairs(props or {}) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end
local function makeDraggable(frame) frame.Active = true; frame.Draggable = true end
local function pulse(ui, goalSize)
    local s = ui.Size
    TweenService:Create(ui, TweenInfo.new(0.18), {Size = goalSize}):Play()
    task.delay(0.18,function()
        TweenService:Create(ui, TweenInfo.new(0.18), {Size = s}):Play()
    end)
end
local function makeButton(text, parent, gradA, gradB, height)
    local h = height or 28
    local btn = make("TextButton", {
        Size = UDim2.new(1, 0, 0, h),
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(255,255,255),
        BackgroundColor3 = Color3.fromRGB(40,40,40),
        AutoButtonColor = false,
    }, parent)
    make("UICorner",{CornerRadius=UDim.new(0,8)},btn)
    make("UIStroke",{Thickness=1.5,Color=Color3.fromRGB(255,255,255)},btn)
    make("UIGradient",{
        Color=ColorSequence.new{
            ColorSequenceKeypoint.new(0,gradA or Color3.fromRGB(55,55,55)),
            ColorSequenceKeypoint.new(1,gradB or Color3.fromRGB(35,35,35))
        }
    },btn)
    btn.MouseButton1Click:Connect(function()
        pulse(btn,UDim2.new(1,0,0,h+2))
    end)
    return btn
end

-- GUI base
local Screen = make("ScreenGui",{Name="XL3RL_GUI",ResetOnSpawn=false},LP:WaitForChild("PlayerGui"))

-- Icono flotante
local FloatIcon = make("Frame",{Size=UDim2.new(0,50,0,50),Position=UDim2.new(0.1,0,0.2,0),BackgroundColor3=Color3.fromRGB(30,30,30)},Screen)
make("UICorner",{CornerRadius=UDim.new(1,0)},FloatIcon)
make("UIStroke",{Thickness=2,Color=Color3.fromRGB(0,255,150)},FloatIcon)
local FloatText = make("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="XL",Font=Enum.Font.GothamBlack,TextSize=20,TextColor3=Color3.new(1,1,1)},FloatIcon)
makeDraggable(FloatIcon)

-- Menú principal
local Main = make("Frame",{Size=UDim2.new(0,140,0,130),Position=UDim2.new(0.5,-70,0.5,-65),BackgroundColor3=Color3.fromRGB(25,25,25),Visible=false},Screen)
make("UICorner",{CornerRadius=UDim.new(0,10)},Main)
make("UIStroke",{Thickness=2,Color=Color3.fromRGB(0,255,150)},Main)
makeDraggable(Main)

local MainContent = make("Frame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1},Main)
local MainLayout = make("UIListLayout",{Padding=UDim.new(0,6),FillDirection=Enum.FillDirection.Vertical,SortOrder=Enum.SortOrder.LayoutOrder},MainContent)
make("UIPadding",{PaddingTop=UDim.new(0,6),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8)},MainContent)

make("TextLabel",{Size=UDim2.new(1,0,0,20),Text="XL3RL HUB",Font=Enum.Font.GothamBlack,TextSize=14,TextColor3=Color3.fromRGB(0,255,200),BackgroundTransparency=1},MainContent)

local btnNoClip = makeButton("NO-CLIP MENU",MainContent,Color3.fromRGB(0,200,255),Color3.fromRGB(0,255,150),28)
local btnLaser  = makeButton("AUTO-LASER MENU",MainContent,Color3.fromRGB(255,80,80),Color3.fromRGB(200,20,20),28)
local btnCombo  = makeButton("COMBO SCRIPTS",MainContent,Color3.fromRGB(160,60,255),Color3.fromRGB(60,0,160),28)

-- Panel NO-CLIP
local NCPanel = make("Frame",{Size=UDim2.new(0,130,0,90),Position=UDim2.new(0.7,-65,0.3,-45),BackgroundColor3=Color3.fromRGB(22,22,22),Visible=false},Screen)
make("UICorner",{CornerRadius=UDim.new(0,10)},NCPanel)
make("UIStroke",{Thickness=2,Color=Color3.fromRGB(0,255,120)},NCPanel)
makeDraggable(NCPanel)
local NCButton = makeButton("ACTIVAR NO-CLIP",NCPanel,Color3.fromRGB(0,180,0),Color3.fromRGB(0,120,0),32)

local noClipConn,noClipOn
local function setNoClip(on)
    if on and not noClipOn then
        noClipConn=RunService.Stepped:Connect(function()
            local ch=LP.Character
            if ch then
                for _,p in ipairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
            end
        end)
        NCButton.Text="DESACTIVAR NO-CLIP"
        noClipOn=true
    elseif not on and noClipOn then
        if noClipConn then noClipConn:Disconnect() end
        noClipOn=false
        local ch=LP.Character
        if ch then for _,p in ipairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end
        NCButton.Text="ACTIVAR NO-CLIP"
    end
end
NCButton.MouseButton1Click:Connect(function() setNoClip(not noClipOn) end)

-- Panel AUTO-LASER
local LaserPanel = make("Frame",{Size=UDim2.new(0,130,0,90),Position=UDim2.new(0.7,-65,0.55,-45),BackgroundColor3=Color3.fromRGB(22,22,22),Visible=false},Screen)
make("UICorner",{CornerRadius=UDim.new(0,10)},LaserPanel)
make("UIStroke",{Thickness=2,Color=Color3.fromRGB(255,80,80)},LaserPanel)
makeDraggable(LaserPanel)

local LaserButton = makeButton("ACTIVAR AUTO-LASER",LaserPanel,Color3.fromRGB(200,40,40),Color3.fromRGB(120,20,20),32)

local LaserRemote = ReplicatedStorage.Packages.Net:FindFirstChild("RE/UseItem")
local autoLaser=false
LaserButton.MouseButton1Click:Connect(function()
    autoLaser = not autoLaser
    LaserButton.Text = autoLaser and "DESACTIVAR AUTO-LASER" or "ACTIVAR AUTO-LASER"
end)

local function getClosestEnemy(range)
    local closest,dist=nil,range
    local myHRP=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl~=LP and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            local d=(pl.Character.HumanoidRootPart.Position-myHRP.Position).Magnitude
            if d<dist then closest,dist=pl.Character.HumanoidRootPart,d end
        end
    end
    return closest
end
task.spawn(function()
    while task.wait(0.2) do
        if autoLaser and LaserRemote then
            local target=getClosestEnemy(150)
            if target then
                LaserRemote:FireServer(target.Position,target)
            end
        end
    end
end)

-- Botones HUB
btnNoClip.MouseButton1Click:Connect(function() NCPanel.Visible = not NCPanel.Visible end)
btnLaser.MouseButton1Click:Connect(function() LaserPanel.Visible = not LaserPanel.Visible end)
btnCombo.MouseButton1Click:Connect(function()
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))() end)
    pcall(function() loadstring(game:HttpGet("https://gist.githubusercontent.com/UCT-hub/5b11d10386f1b8ce08feb803861e0b79/raw/b2917b398d4b0cc80fb2aca73a3137ba494ebcf0/gistfile1.txt"))() end)
end)

-- Toggle menú
FloatText.MouseButton1Click:Connect(function() Main.Visible=not Main.Visible end)
UserInputService.InputBegan:Connect(function(inp,gpe) if not gpe and inp.KeyCode==Enum.KeyCode.RightShift then Main.Visible=not Main.Visible end end)
