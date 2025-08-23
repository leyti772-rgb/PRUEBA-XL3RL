-- ⚡ XL Speed Test – LOOP 1 (solo UseItem)
-- Icono flotante + toggle. Spamea RE/UseItem con valor alto.

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- ======== Ajustes ========
local SPEED_VALUE   = 5        -- fuerza de velocidad (prueba 3–10)
local SPAM_INTERVAL = 0.10     -- cada cuántos segundos mandar el Remote
-- =========================

-- util
local function make(c,p,par) local i=Instance.new(c) for k,v in pairs(p or {})do i[k]=v end if par then i.Parent=par end return i end
local function getRemote(path)
    local node = RS
    for seg in string.gmatch(path,"[^/]+") do node = node and node:FindFirstChild(seg) end
    return node
end
pcall(function() LP:WaitForChild("PlayerGui"):FindFirstChild("XL_L1_GUI"):Destroy() end)

local Screen = make("ScreenGui",{Name="XL_L1_GUI",ResetOnSpawn=false},LP:WaitForChild("PlayerGui"))

-- Icono flotante
local Icon = make("Frame",{Size=UDim2.new(0,52,0,52),Position=UDim2.new(0.12,0,0.2,0),BackgroundColor3=Color3.fromRGB(35,35,35)},Screen)
make("UICorner",{CornerRadius=UDim.new(1,0)},Icon)
make("UIStroke",{Thickness=2,Color=Color3.fromRGB(0,200,255)},Icon)
local IconBtn = make("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="⚡L1",Font=Enum.Font.GothamBlack,TextSize=22,TextColor3=Color3.new(1,1,1)},Icon)

-- Drag
do
    local dragging,dragInput,dragStart,startPos
    local function update(input) local d=input.Position-dragStart; Icon.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end
    Icon.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=i.Position; startPos=Icon.Position
            i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    Icon.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then dragInput=i end end)
    UIS.InputChanged:Connect(function(i) if dragging and i==dragInput then update(i) end end)
end

-- Menú
local Menu = make("Frame",{Size=UDim2.new(0,160,0,90),Position=UDim2.new(0.28,0,0.26,0),BackgroundColor3=Color3.fromRGB(25,25,25),Visible=false},Screen)
make("UICorner",{CornerRadius=UDim.new(0,12)},Menu)
make("UIStroke",{Thickness=2,Color=Color3.fromRGB(0,200,255)},Menu)
local Title = make("TextLabel",{Size=UDim2.new(1,0,0,22),Text="LOOP 1 – UseItem",Font=Enum.Font.GothamBold,TextSize=14,TextColor3=Color3.fromRGB(0,255,200),BackgroundTransparency=1},Menu)
local Toggle = make("TextButton",{Size=UDim2.new(1,-20,0,40),Position=UDim2.new(0,10,0,40),BackgroundColor3=Color3.fromRGB(0,160,0),Text="ACTIVAR",Font=Enum.Font.GothamBold,TextSize=14,TextColor3=Color3.new(1,1,1)},Menu)
make("UICorner",{CornerRadius=UDim.new(0,10)},Toggle)

-- Lógica
local running=false
local thread
local function runLoop()
    local UseItem = getRemote("Packages/Net/RE/UseItem")
    while running do
        UseItem = UseItem or getRemote("Packages/Net/RE/UseItem")
        if UseItem then pcall(function() UseItem:FireServer(SPEED_VALUE) end) end
        task.wait(SPAM_INTERVAL)
    end
end

IconBtn.MouseButton1Click:Connect(function() Menu.Visible = not Menu.Visible end)
Toggle.MouseButton1Click:Connect(function()
    running = not running
    if running then
        Toggle.Text="DESACTIVAR"; Toggle.BackgroundColor3=Color3.fromRGB(170,20,20)
        thread = task.spawn(runLoop)
    else
        Toggle.Text="ACTIVAR"; Toggle.BackgroundColor3=Color3.fromRGB(0,160,0)
        -- apaga loop
        running=false
    end
end)
