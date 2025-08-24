--[[
    SCRIPT: XL3RL HUB - FUSIÓN FINAL (AutoLaser + Brainroot integración PRO)
    - Detección robusta de Brainroot (Character/Backpack, DescendantAdded + escaneo)
    - Auto-Láser equipa/desequipa Laser Cape; bloquea otras tools; re-equip tras respawn.
    - Al detectar Brainroot -> Auto-Láser se desactiva inmediatamente.
]]

-- ========= Servicios / Player =========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

-- ========= Config / helper UI =========
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

-- ========= Drag corregido =========
local function makeDraggable(frame, trigger)
    local isDragging, dragStartPosition, frameStartPosition = false
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStartPosition = input.Position
            frameStartPosition = frame.Position
            local conn; conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then isDragging=false; conn:Disconnect() end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStartPosition
            frame.Position = UDim2.new(frameStartPosition.X.Scale, frameStartPosition.X.Offset + d.X, frameStartPosition.Y.Scale, frameStartPosition.Y.Offset + d.Y)
        end
    end)
end

-- ========= GUI base =========
pcall(function() if LP.PlayerGui:FindFirstChild("XL3RL_FUSION_GUI") then LP.PlayerGui.XL3RL_FUSION_GUI:Destroy() end end)
local Screen = make("ScreenGui", { Name = "XL3RL_FUSION_GUI", ResetOnSpawn = false }, LP:WaitForChild("PlayerGui"))

-- Icono flotante
local FloatIcon = make("ImageButton", {
    Name = "OpenIcon", Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 20, 0.5, -25),
    BackgroundColor3 = Config.BackgroundColor, BackgroundTransparency = 0.2,
    Image = "rbxassetid://6034849723", ImageColor3 = Config.MainColor, ScaleType = Enum.ScaleType.Fit
}, Screen)
make("UICorner", {CornerRadius = UDim.new(1, 0)}, FloatIcon)
make("UIStroke", {Color = Config.MainColor}, FloatIcon)

-- Menú principal
local Main = make("Frame", {
    Size = UDim2.new(0, 160, 0, 200), Position = UDim2.new(0.5, -80, 0.5, -100),
    BackgroundColor3 = Config.BackgroundColor, Visible = false
}, Screen)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, Main)
make("UIStroke", {Thickness = 2, Color = Config.MainColor}, Main)

local MainContent = make("Frame", { Size = UDim2.fromScale(1,1), BackgroundTransparency = 1 }, Main)
make("UIPadding", { PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }, MainContent)
make("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, MainContent)

local Title = make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 24), Text = "XL3RL FUSIÓN", Font = Enum.Font.Code,
    TextSize = 16, TextColor3 = Config.MainColor, BackgroundTransparency = 1, LayoutOrder = 1
}, MainContent)

-- ========= Paneles =========
-- No-Clip
local NCPanel = make("Frame", {
    Name = "NCPanel", Size = UDim2.new(0, 160, 0, 100), Position = UDim2.new(0.5, -80, 0.5, -50),
    BackgroundColor3 = Config.BackgroundColor, Visible = false
}, Screen)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, NCPanel)
make("UIStroke", {Color = Config.MainColor}, NCPanel)
local ncTitle = make("TextLabel", {Size = UDim2.new(1,0,0,30), Text = "NO-CLIP", Font = Enum.Font.Code, TextSize = 16, TextColor3 = Config.MainColor, BackgroundTransparency = 1}, NCPanel)
local ncButton = make("TextButton", {Size = UDim2.new(1,-20,0,40), Position = UDim2.new(0,10,0,40), Text = "ACTIVAR", Font = Enum.Font.Code, TextSize = 14, TextColor3 = Config.TextColor, BackgroundColor3 = Color3.fromRGB(0,160,0)}, NCPanel)
make("UICorner", {CornerRadius = UDim.new(0,6)}, ncButton)

-- Auto-Láser
local LaserPanel = make("Frame", {
    Name = "LaserPanel", Size = UDim2.new(0, 160, 0, 100), Position = UDim2.new(0.5, -80, 0.5, -50),
    BackgroundColor3 = Config.BackgroundColor, Visible = false
}, Screen)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, LaserPanel)
make("UIStroke", {Color = Config.MainColor}, LaserPanel)
local laserTitle = make("TextLabel", {Size = UDim2.new(1,0,0,30), Text = "AUTO-LASER", Font = Enum.Font.Code, TextSize = 16, TextColor3 = Config.MainColor, BackgroundTransparency = 1}, LaserPanel)
local laserButton = make("TextButton", {Size = UDim2.new(1,-20,0,40), Position = UDim2.new(0,10,0,40), Text = "ACTIVAR", Font = Enum.Font.Code, TextSize = 14, TextColor3 = Config.TextColor, BackgroundColor3 = Color3.fromRGB(0,160,0)}, LaserPanel)
make("UICorner", {CornerRadius = UDim.new(0,6)}, laserButton)

-- ========= Lógica No-Clip =========
local noClipConn, noClipOn = nil, false
ncButton.MouseButton1Click:Connect(function()
    noClipOn = not noClipOn
    if noClipOn then
        noClipConn = RunService.Stepped:Connect(function()
            if LP.Character then
                for _,p in ipairs(LP.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
        ncButton.Text, ncButton.BackgroundColor3 = "DESACTIVAR", Color3.fromRGB(170,20,20)
    else
        if noClipConn then noClipConn:Disconnect(); noClipConn = nil end
        ncButton.Text, ncButton.BackgroundColor3 = "ACTIVAR", Color3.fromRGB(0,160,0)
    end
end)

-- ========= Auto-Láser (equip/unequip + bloqueo herramientas) =========
local LaserRemote = ReplicatedStorage:FindFirstChild("RE/UseItem", true)
local BuyRF = ReplicatedStorage:FindFirstChild("RF/CoinsShopService/RequestBuy", true)

local function getLaserTool()
    if LP.Backpack then
        for _,t in ipairs(LP.Backpack:GetChildren()) do
            if t:IsA("Tool") and (t.Name == "Laser Cape" or t.Name:lower():find("laser")) then return t end
        end
    end
    if LP.Character then
        for _,t in ipairs(LP.Character:GetChildren()) do
            if t:IsA("Tool") and (t.Name == "Laser Cape" or t.Name:lower():find("laser")) then return t end
        end
    end
end

local function equipLaserCape()
    local t = getLaserTool()
    if not t and BuyRF then pcall(function() BuyRF:InvokeServer("Laser Cape") end) end
    task.wait(0.2)
    t = getLaserTool()
    if t and LP.Character then t.Parent = LP.Character end
end

local function unequipLaserCape()
    local t = getLaserTool()
    if t and LP.Backpack then t.Parent = LP.Backpack end
end

-- ===== Detección robusta de Brainroot =====
local autoLaser, laserRange = false, 150
local brainrootConns = {}

local function isBrainroot(inst)
    local n = (inst and inst.Name or ""):lower()
    if n:find("brain") or n:find("root") then return true end
    if inst:IsA("Tool") or inst:IsA("Accessory") or inst:IsA("Model") then
        if inst:FindFirstChild("Brainroot") or inst:FindFirstChild("BrainRoot") then return true end
        -- más heurísticas se pueden añadir aquí si el juego usa otros nombres
    end
    return false
end

local function disableAutoLaserNow()
    if autoLaser then
        autoLaser = false
        laserButton.Text, laserButton.BackgroundColor3 = "ACTIVAR", Color3.fromRGB(0,160,0)
        unequipLaserCape()
    end
end

local function scanForBrainroot()
    local ch = LP.Character
    if ch then
        for _,d in ipairs(ch:GetDescendants()) do
            if isBrainroot(d) then return true end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _,d in ipairs(bp:GetDescendants()) do
            if isBrainroot(d) then return true end
        end
    end
    return false
end

local function clearBrainrootConns()
    for _,c in ipairs(brainrootConns) do pcall(function() c:Disconnect() end) end
    brainrootConns = {}
end

local function attachBrainrootWatchers()
    clearBrainrootConns()
    local ch = LP.Character
    if ch then
        table.insert(brainrootConns, ch.DescendantAdded:Connect(function(inst)
            if autoLaser and isBrainroot(inst) then disableAutoLaserNow() end
        end))
        table.insert(brainrootConns, ch.ChildAdded:Connect(function(inst)
            if autoLaser and isBrainroot(inst) then disableAutoLaserNow() end
        end))
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        table.insert(brainrootConns, bp.DescendantAdded:Connect(function(inst)
            if autoLaser and isBrainroot(inst) then disableAutoLaserNow() end
        end))
        table.insert(brainrootConns, bp.ChildAdded:Connect(function(inst)
            if autoLaser and isBrainroot(inst) then disableAutoLaserNow() end
        end))
    end
end

-- ===== Botón Auto-Láser =====
laserButton.MouseButton1Click:Connect(function()
    autoLaser = not autoLaser
    if autoLaser then
        laserButton.Text, laserButton.BackgroundColor3 = "DESACTIVAR", Color3.fromRGB(170,20,20)

        -- escaneo inmediato por si ya traes Brainroot encima
        if scanForBrainroot() then
            disableAutoLaserNow()
            return
        end

        attachBrainrootWatchers()

        task.spawn(function()
            while autoLaser do
                -- Si aparece Brainroot en mitad del loop, salimos
                if scanForBrainroot() then
                    disableAutoLaserNow()
                    break
                end

                equipLaserCape()

                -- expulsar otras tools (pero si vemos Brainroot, desactivamos en vez de expulsar)
                if LP.Character then
                    for _,tool in ipairs(LP.Character:GetChildren()) do
                        if tool:IsA("Tool") and not (tool.Name == "Laser Cape" or tool.Name:lower():find("laser")) then
                            if isBrainroot(tool) then
                                disableAutoLaserNow()
                                break
                            else
                                tool.Parent = LP.Backpack
                            end
                        end
                    end
                end
                task.wait(0.35)
            end
        end)
    else
        laserButton.Text, laserButton.BackgroundColor3 = "ACTIVAR", Color3.fromRGB(0,160,0)
        unequipLaserCape()
        clearBrainrootConns()
    end
end)

-- re-equip tras respawn y re-enganchar watchers
LP.CharacterAdded:Connect(function()
    if autoLaser then task.wait(0.5) equipLaserCape() end
    attachBrainrootWatchers()
end)

-- ===== Auto-disparo =====
task.spawn(function()
    while task.wait(0.2) do
        if autoLaser and LaserRemote and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local myHRP = LP.Character.HumanoidRootPart
            local closest, dist = nil, laserRange
            for _,pl in ipairs(Players:GetPlayers()) do
                if pl ~= LP and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (pl.Character.HumanoidRootPart.Position - myHRP.Position).Magnitude
                    if d < dist then closest, dist = pl.Character.HumanoidRootPart, d end
                end
            end
            if closest then pcall(function() LaserRemote:FireServer(closest.Position, closest) end) end
        end
    end
end)

-- ========= Botones menú principal =========
local function makeMainButton(text, order, panel)
    local btn = make("TextButton", {
        Size = UDim2.new(1,0,0,32), Text = text, Font = Enum.Font.Code, TextSize = 14,
        TextColor3 = Config.TextColor, BackgroundColor3 = Config.MutedColor, LayoutOrder = order
    }, MainContent)
    make("UICorner", {CornerRadius = UDim.new(0,6)}, btn)
    if panel then btn.MouseButton1Click:Connect(function() panel.Visible = not panel.Visible end) end
    return btn
end

makeMainButton("NO-CLIP", 2, NCPanel)
makeMainButton("AUTO-LASER", 3, LaserPanel)
local btnCombo = makeMainButton("COMBO SCRIPTS", 4)
local btnServer = makeMainButton("CAMBIAR SERVIDOR", 5)

btnCombo.MouseButton1Click:Connect(function()
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))() end)
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ily123950/Vulkan/refs/heads/main/Trx"))() end)
end)
btnServer.MouseButton1Click:Connect(function()
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/karlosedson/mkzhub/refs/heads/main/makerzjoiner.lua"))() end)
end)

-- ========= Inicialización =========
makeDraggable(Main, Title)
makeDraggable(FloatIcon, FloatIcon)
makeDraggable(NCPanel, ncTitle)
makeDraggable(LaserPanel, laserTitle)

FloatIcon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
UserInputService.InputBegan:Connect(function(inp, gpe) if not gpe and inp.KeyCode == Config.Keybind then Main.Visible = not Main.Visible end end)

-- Arrancar watchers por si ya hay Character/Backpack
attachBrainrootWatchers()
