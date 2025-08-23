-- ⚡ XL Speed Hack (Loop controlado)
-- Icono + menú compacto para activar/desactivar velocidad en Roba Brainroot

local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local LP = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

-- Helper
local function make(class, props, parent)
    local i = Instance.new(class)
    for k,v in pairs(props) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end

-- GUI
pcall(function() LP.PlayerGui:FindFirstChild("SpeedGUI"):Destroy() end)
local Screen = make("ScreenGui", {Name="SpeedGUI", ResetOnSpawn=false}, LP.PlayerGui)

-- Icono flotante
local Icon = make("Frame", {
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0.1,0,0.2,0),
    BackgroundColor3 = Color3.fromRGB(40,40,40)
}, Screen)
make("UICorner",{CornerRadius=UDim.new(1,0)},Icon)
make("UIStroke",{Thickness=2,Color=Color3.fromRGB(0,200,255)},Icon)
local BtnIcon = make("TextButton",{
    Size = UDim2.fromScale(1,1),
    BackgroundTransparency=1,
    Text="⚡",
    Font=Enum.Font.GothamBlack,
    TextSize=28,
    TextColor3=Color3.fromRGB(255,255,255)
},Icon)

-- Draggable
local dragging,dragInput,dragStart,startPos
local function update(input)
    local delta = input.Position - dragStart
    Icon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
Icon.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true; dragStart=input.Position; startPos=Icon.Position
        input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end)
    end
end)
Icon.InputChanged:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end end)
UIS.InputChanged:Connect(function(input) if input==dragInput and dragging then update(input) end end)

-- Menú
local Menu = make("Frame",{
    Size=UDim2.new(0,150,0,90),
    Position=UDim2.new(0.25,0,0.25,0),
    BackgroundColor3=Color3.fromRGB(25,25,25),
    Visible=false
},Screen)
make("UICorner",{CornerRadius=UDim.new(0,12)},Menu)
make("UIStroke",{Thickness=2,Color=Color3.fromRGB(0,200,255)},Menu)

local Title = make("TextLabel",{
    Size=UDim2.new(1,0,0,24),
    Text="Speed Hack",
    Font=Enum.Font.GothamBold,
    TextSize=16,
    TextColor3=Color3.fromRGB(0,255,200),
    BackgroundTransparency=1
},Menu)

local SpeedBtn = make("TextButton",{
    Size=UDim2.new(1,-20,0,40),
    Position=UDim2.new(0,10,0,35),
    BackgroundColor3=Color3.fromRGB(0,160,0),
    Text="ACTIVAR",
    Font=Enum.Font.GothamBold,
    TextSize=14,
    TextColor3=Color3.fromRGB(255,255,255)
},Menu)
make("UICorner",{CornerRadius=UDim.new(0,10)},SpeedBtn)

-- Toggle + Loop
local SpeedOn=false
local SpeedLoop=nil

local function setSpeed(state)
    if state then
        SpeedBtn.Text="DESACTIVAR"
        SpeedBtn.BackgroundColor3=Color3.fromRGB(170,20,20)
        -- iniciar loop
        SpeedLoop = RunService.Heartbeat:Connect(function()
            RS.Packages.Net:FindFirstChild("RE/UseItem"):FireServer(5) -- valor alto = más velocidad
        end)
    else
        SpeedBtn.Text="ACTIVAR"
        SpeedBtn.BackgroundColor3=Color3.fromRGB(0,160,0)
        if SpeedLoop then SpeedLoop:Disconnect() SpeedLoop=nil end
        -- opcional: volver a normal
        RS.Packages.Net:FindFirstChild("RE/UseItem"):FireServer(1.983)
    end
end

SpeedBtn.MouseButton1Click:Connect(function()
    SpeedOn = not SpeedOn
    setSpeed(SpeedOn)
end)

-- Toggle menú con el icono
BtnIcon.MouseButton1Click:Connect(function()
    Menu.Visible = not Menu.Visible
end)
