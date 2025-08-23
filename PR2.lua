-- 🪝 XL Speed Test – LOOP 2 (Cooldown reset + UseItem)
-- Icono flotante + toggle. Resetea cooldown (Grapple Hook) y spamea UseItem.

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- ======== Ajustes ========
local TOOL_NAME        = "Grapple Hook" -- si el juego usa otro nombre, cámbialo
local COOLDOWN_VALUE   = 0              -- forzamos 0
local CD_INTERVAL      = 0.20           -- cada cuánto resetear cooldown
local SPEED_VALUE      = 5              -- fuerza de velocidad
local USEITEM_INTERVAL = 0.10           -- intervalo de UseItem
-- =========================

-- util
local function make(c,p,par) local i=Instance.new(c) for k,v in pairs(p or {})do i[k]=v end if par then i.Parent=par end return i end
local function getRemote(path)
    local node = RS
    for seg in string.gmatch(path,"[^/]+") do node = node and node:FindFirstChild(seg) end
    return node
end
pcall(function() LP:WaitForChild("PlayerGui"):FindFirstChild("XL_L2_GUI"):Destroy() end)

local Screen = make("ScreenGui",{Name="XL_L2_GUI",ResetOnSpawn=false},LP:WaitForChild("PlayerGui"))

-- Icono flotante
local Icon = make("Frame",{Size=UDim2.new(0,52,0,52),Position=UDim2.new(0.18,0,0.2,0),BackgroundColor3=Color3.fromRGB(35,35,35)},Screen)
make("UICorner",{CornerRadius=UDim.new(1,0)},Icon)
make("UIStroke",{Thickness=2,Color=Color3.fromRGB(0,255,150)},Icon)
local IconBtn = make("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="🪝L2",Font=Enum.Font.GothamBlack,TextSize=22,TextColor3=Color3.new(1,1,1)},Icon)

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
local Menu = make("Frame",{Size=UDim2.new(0,170,0,110),Position=UDim2.new(0.34,0,0.26,0),BackgroundColor3=Color3.fromRGB(25,25,25),Visible=false},Screen)
make("UICorner",{CornerRadius=UDim.new(0,12)},Menu)
make("UIStroke",{Thickness=2,Color=Color3.fromRGB(0,255,150)},Menu)
local Title = make("TextLabel",{Size=UDim2.new(1,0,0,22),Text="LOOP 2 – Cooldown+Speed",Font=Enum.Font.GothamBold,TextSize=14,TextColor3=Color3.fromRGB(0,255,170),BackgroundTransparency=1},Menu)
local Toggle = make("TextButton",{Size=UDim2.new(1,-20,0,40),Position=UDim2.new(0,10,0,30),BackgroundColor3=Color3.fromRGB(0,160,0),Text="ACTIVAR",Font=Enum.Font.GothamBold,TextSize=14,TextColor3=Color3.new(1,1,1)},Menu)
make("UICorner",{CornerRadius=UDim.new(0,10)},Toggle)
local Info = make("TextLabel",{Size=UDim2.new(1,-20,0,18),Position=UDim2.new(0,10,0,78),BackgroundTransparency=1,Text="Resetea CD + UseItem",Font=Enum.Font.Gotham,TextSize=12,TextColor3=Color3.fromRGB(200,200,200)},Menu)

-- Lógica
local running=false
local t1, t2  -- hilos

local function resetCooldown()
    local Cool = getRemote("Packages/Net/RE/Tools/Cooldown")
    -- intentos con distintas firmas (algunos juegos piden string, otros instancia/índice)
    if Cool then
        local ok = pcall(function() Cool:FireServer(TOOL_NAME, COOLDOWN_VALUE) end)
        if not ok then pcall(function() Cool:FireServer(COOLDOWN_VALUE) end) end
    end
end

local function fireUseItem()
    local UseItem = getRemote("Packages/Net/RE/UseItem")
    if UseItem then pcall(function() UseItem:FireServer(SPEED_VALUE) end) end
end

IconBtn.MouseButton1Click:Connect(function() Menu.Visible = not Menu.Visible end)

Toggle.MouseButton1Click:Connect(function()
    running = not running
    if running then
        Toggle.Text="DESACTIVAR"; Toggle.BackgroundColor3=Color3.fromRGB(170,20,20)

        t1 = task.spawn(function()
            while running do
                resetCooldown()
                task.wait(CD_INTERVAL)
            end
        end)

        t2 = task.spawn(function()
            while running do
                fireUseItem()
                task.wait(USEITEM_INTERVAL)
            end
        end)
    else
        Toggle.Text="ACTIVAR"; Toggle.BackgroundColor3=Color3.fromRGB(0,160,0)
        running=false
    end
end)
