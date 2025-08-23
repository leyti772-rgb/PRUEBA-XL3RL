-- XL Auto-Learn Replayer (icono + menú) – por ChatGPT
-- Graba el Remote real (UseItem/Cooldown) y lo reenvía en loop con los mismos args.
-- Pensado para Delta/Android. Ligero y solo hookea cuando “Aprender” está ON.

local Players = game:GetService("Players")
local RS      = game:GetService("ReplicatedStorage")
local UIS     = game:GetService("UserInputService")
local LP      = Players.LocalPlayer

-- Limpieza previa
pcall(function()
    local g = LP:WaitForChild("PlayerGui"):FindFirstChild("XL_LEARN_GUI")
    if g then g:Destroy() end
end)

-- Utils UI
local function make(c,p,par) local i=Instance.new(c) for k,v in pairs(p or {}) do i[k]=v end if par then i.Parent=par end return i end
local function draggable(f)
    local dragging, dragInput, dragStart, startPos
    local function update(i) local d=i.Position-dragStart; f.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end
    f.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=i.Position; startPos=f.Position
            i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    f.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then dragInput=i end end)
    UIS.InputChanged:Connect(function(i) if dragging and i==dragInput then update(i) end end)
end

-- Copia “segura” de argumentos (simple: números, strings, bool, Vector/CFrame, Instance, tablas poco profundas)
local function shallowCopy(v)
    local t=typeof(v)
    if t=="table" then
        local n={} for k,val in pairs(v) do n[k]=shallowCopy(val) end; return n
    else
        return v -- number, string, boolean, Instance, Vector3, CFrame, etc. OK
    end
end

-- Estado
local learnedUseItem = {remote=nil, args=nil}
local learnedCooldown = {remote=nil, args=nil}
local learnUseItemOn = false
local learnCooldownOn = false
local loopUseItemOn = false
local loopCooldownOn = false
local useItemInterval = 0.10
local cooldownInterval = 0.20

-- GUI
local Screen = make("ScreenGui",{Name="XL_LEARN_GUI",ResetOnSpawn=false}, LP:WaitForChild("PlayerGui"))

-- Icono flotante
local Icon = make("Frame",{Size=UDim2.new(0,54,0,54),Position=UDim2.new(0.14,0,0.22,0),BackgroundColor3=Color3.fromRGB(32,32,32)}, Screen)
make("UICorner",{CornerRadius=UDim.new(1,0)}, Icon)
make("UIStroke",{Thickness=2, Color=Color3.fromRGB(0,220,180)}, Icon)
local IconBtn = make("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="🔍",Font=Enum.Font.GothamBlack,TextSize=22,TextColor3=Color3.new(1,1,1)}, Icon)
draggable(Icon)

-- Menú
local Menu = make("Frame",{Size=UDim2.new(0,220,0,190),Position=UDim2.new(0.28,0,0.26,0),BackgroundColor3=Color3.fromRGB(24,24,24),Visible=false}, Screen)
make("UICorner",{CornerRadius=UDim.new(0,12)}, Menu)
make("UIStroke",{Thickness=2, Color=Color3.fromRGB(0,220,180)}, Menu)
draggable(Menu)

local Title = make("TextLabel",{Size=UDim2.new(1,0,0,22),Text="XL Auto-Learn",Font=Enum.Font.GothamBold,TextSize=14,TextColor3=Color3.fromRGB(0,255,210),BackgroundTransparency=1}, Menu)

local Col = make("Frame",{Size=UDim2.new(1,-16,1,-30),Position=UDim2.new(0,8,0,26),BackgroundTransparency=1}, Menu)
local layout = make("UIListLayout",{Padding=UDim.new(0,6),FillDirection=Enum.FillDirection.Vertical,HorizontalAlignment=Enum.HorizontalAlignment.Center,VerticalAlignment=Enum.VerticalAlignment.Top,SortOrder=Enum.SortOrder.LayoutOrder}, Col)

local function mkBtn(text,color)
    local b = make("TextButton",{Size=UDim2.new(1,0,0,30),Text=text,Font=Enum.Font.GothamBold,TextSize=13,BackgroundColor3=color or Color3.fromRGB(45,45,45),TextColor3=Color3.new(1,1,1),AutoButtonColor=false}, Col)
    make("UICorner",{CornerRadius=UDim.new(0,10)}, b); make("UIStroke",{Thickness=1.5, Color=Color3.fromRGB(255,255,255)}, b)
    return b
end
local function setOn(btn,on) btn.BackgroundColor3 = on and Color3.fromRGB(0,160,0) or Color3.fromRGB(170,20,20) end

local B_LearnUse = mkBtn("Aprender UseItem (OFF)")
local B_LearnCD  = mkBtn("Aprender Cooldown (OFF)")
local B_LoopUse  = mkBtn("Loop UseItem: OFF", Color3.fromRGB(0,160,0))
local B_LoopCD   = mkBtn("Loop Cooldown: OFF", Color3.fromRGB(0,160,0))

local Info = make("TextLabel",{Size=UDim2.new(1,0,0,34),TextWrapped=true,Text="1) Pulsa Aprender\n2) Usa el item 1 vez\n3) Enciende Loops",Font=Enum.Font.Gotham,TextSize=12,TextColor3=Color3.fromRGB(200,200,200),BackgroundTransparency=1}, Col)

local Row = make("Frame",{Size=UDim2.new(1,0,0,28),BackgroundTransparency=1}, Col)
local L1 = make("TextLabel",{Size=UDim2.new(0.5,-4,1,0),Text="UseItem(ms):",Font=Enum.Font.Gotham,TextSize=12,TextColor3=Color3.fromRGB(200,200,200),BackgroundTransparency=1,TextXAlignment=Enum.TextXAlignment.Left}, Row)
local I1 = make("TextBox",{Size=UDim2.new(0.5,-4,1,0),Position=UDim2.new(0.5,4,0,0),Text=tostring(useItemInterval),Font=Enum.Font.GothamBold,TextSize=12,TextColor3=Color3.fromRGB(0,255,210),BackgroundColor3=Color3.fromRGB(36,36,36),ClearTextOnFocus=false}, Row)
make("UICorner",{CornerRadius=UDim.new(0,8)}, I1)

local Row2 = make("Frame",{Size=UDim2.new(1,0,0,28),BackgroundTransparency=1}, Col)
local L2 = make("TextLabel",{Size=UDim2.new(0.5,-4,1,0),Text="Cooldown(ms):",Font=Enum.Font.Gotham,TextSize=12,TextColor3=Color3.fromRGB(200,200,200),BackgroundTransparency=1,TextXAlignment=Enum.TextXAlignment.Left}, Row2)
local I2 = make("TextBox",{Size=UDim2.new(0.5,-4,1,0),Position=UDim2.new(0.5,4,0,0),Text=tostring(cooldownInterval),Font=Enum.Font.GothamBold,TextSize=12,TextColor3=Color3.fromRGB(0,255,210),BackgroundColor3=Color3.fromRGB(36,36,36),ClearTextOnFocus=false}, Row2)
make("UICorner",{CornerRadius=UDim.new(0,8)}, I2)

IconBtn.MouseButton1Click:Connect(function() Menu.Visible = not Menu.Visible end)
I1.FocusLost:Connect(function() local v=tonumber(I1.Text); if v and v>0.01 and v<2 then useItemInterval=v else I1.Text=tostring(useItemInterval) end end)
I2.FocusLost:Connect(function() local v=tonumber(I2.Text); if v and v>0.01 and v<3 then cooldownInterval=v else I2.Text=tostring(cooldownInterval) end end)

-- Hook __namecall (sólo cuando se aprende)
local raw = getrawmetatable and getrawmetatable(game)
local old; if raw then
    setreadonly(raw,false)
    old = raw.__namecall
    raw.__namecall = newcclosure(function(self,...)
        local method = getnamecallmethod and getnamecallmethod() or ""
        if method=="FireServer" then
            -- Aprender UseItem
            if learnUseItemOn and self:IsA("RemoteEvent") and tostring(self):lower():find("useitem") then
                local args = {...}
                learnedUseItem.remote = self
                learnedUseItem.args = {}
                for i=1,#args do learnedUseItem.args[i] = shallowCopy(args[i]) end
                learnUseItemOn=false; B_LearnUse.Text="Aprender UseItem (OK)"
            end
            -- Aprender Cooldown
            if learnCooldownOn and self:IsA("RemoteEvent") and tostring(self):lower():find("cooldown") then
                local args = {...}
                learnedCooldown.remote = self
                learnedCooldown.args = {}
                for i=1,#args do learnedCooldown.args[i] = shallowCopy(args[i]) end
                learnCooldownOn=false; B_LearnCD.Text="Aprender Cooldown (OK)"
            end
        end
        return old(self,...)
    end)
    setreadonly(raw,true)
else
    warn("No hay permisos para hookear metatable en este ejecutor.")
end

-- Loops
local runLoops=true -- por si deseas apagar todo al destruir
task.spawn(function()
    while runLoops do
        if loopUseItemOn and learnedUseItem.remote and learnedUseItem.args then
            pcall(function() learnedUseItem.remote:FireServer(unpack(learnedUseItem.args)) end)
        end
        task.wait(useItemInterval)
    end
end)

task.spawn(function()
    while runLoops do
        if loopCooldownOn and learnedCooldown.remote and learnedCooldown.args then
            pcall(function() learnedCooldown.remote:FireServer(unpack(learnedCooldown.args)) end)
        end
        task.wait(cooldownInterval)
    end
end)

-- Botones
B_LearnUse.MouseButton1Click:Connect(function()
    learnUseItemOn = not learnUseItemOn
    B_LearnUse.Text = learnUseItemOn and "Aprender UseItem (ON)" or "Aprender UseItem (OFF)"
    B_LearnUse.BackgroundColor3 = learnUseItemOn and Color3.fromRGB(0,160,0) or Color3.fromRGB(45,45,45)
end)

B_LearnCD.MouseButton1Click:Connect(function()
    learnCooldownOn = not learnCooldownOn
    B_LearnCD.Text = learnCooldownOn and "Aprender Cooldown (ON)" or "Aprender Cooldown (OFF)"
    B_LearnCD.BackgroundColor3 = learnCooldownOn and Color3.fromRGB(0,160,0) or Color3.fromRGB(45,45,45)
end)

B_LoopUse.MouseButton1Click:Connect(function()
    loopUseItemOn = not loopUseItemOn
    B_LoopUse.Text = loopUseItemOn and "Loop UseItem: ON" or "Loop UseItem: OFF"
    B_LoopUse.BackgroundColor3 = loopUseItemOn and Color3.fromRGB(0,160,0) or Color3.fromRGB(170,20,20)
end)

B_LoopCD.MouseButton1Click:Connect(function()
    loopCooldownOn = not loopCooldownOn
    B_LoopCD.Text = loopCooldownOn and "Loop Cooldown: ON" or "Loop Cooldown: OFF"
    B_LoopCD.BackgroundColor3 = loopCooldownOn and Color3.fromRGB(0,160,0) or Color3.fromRGB(170,20,20)
end)
