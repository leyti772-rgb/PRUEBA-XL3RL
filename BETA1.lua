--========================================================
-- COMBAT SYSTEM + MENÚ CONFIGURABLE (GUI)
--========================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer

-- Configuración inicial
local CONFIG = {
    speed = 34,
    jumpPower = 117,
    maxHealth = 239,
    respawnTime = 5,
    debugMode = false
}

-- Eventos
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local damageEvent = remotes:WaitForChild("DamageEvent")
local healEvent = remotes:WaitForChild("HealEvent")
local respawnEvent = remotes:WaitForChild("RespawnEvent")

-- Armas
local weapons = {
    { name = "Sword", damage = 15, cooldown = 0.8, range = 4 },
    { name = "Bow", damage = 10, cooldown = 1.2, range = 30 },
    { name = "Staff", damage = 25, cooldown = 2.5, range = 15 }
}

--========================================================
-- GUI
--========================================================
local ScreenGui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
ScreenGui.Name = "CombatGui"

-- Botón/icono para abrir menú
local IconBtn = Instance.new("TextButton", ScreenGui)
IconBtn.Size = UDim2.new(0,50,0,50)
IconBtn.Position = UDim2.new(0,20,0,200)
IconBtn.Text = "⚔️"
IconBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
IconBtn.TextColor3 = Color3.new(1,1,1)
IconBtn.TextSize = 26
IconBtn.Font = Enum.Font.SourceSansBold
IconBtn.AutoButtonColor = true

-- Frame menú
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,300,0,350)
Frame.Position = UDim2.new(0,80,0,150)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.Visible = false
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "⚔️ CONFIG MENU"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20

-- Toggle menú con icono
IconBtn.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

--========================================================
-- Helpers para crear sliders / toggles
--========================================================
local function createInput(name, default, posY, onChange)
    local label = Instance.new("TextLabel", Frame)
    label.Size = UDim2.new(0.5,0,0,30)
    label.Position = UDim2.new(0,10,0,posY)
    label.BackgroundTransparency = 1
    label.Text = name..":"
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16

    local box = Instance.new("TextBox", Frame)
    box.Size = UDim2.new(0.3,0,0,25)
    box.Position = UDim2.new(0.6,0,0,posY+2)
    box.BackgroundColor3 = Color3.fromRGB(40,40,40)
    box.Text = tostring(default)
    box.TextColor3 = Color3.new(1,1,1)
    box.Font = Enum.Font.SourceSans
    box.TextSize = 16

    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then
            onChange(val)
        else
            box.Text = tostring(default)
        end
    end)
end

local function createToggle(name, default, posY, onChange)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(0.8,0,0,30)
    btn.Position = UDim2.new(0.1,0,0,posY)
    btn.BackgroundColor3 = default and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
    btn.Text = name..": "..(default and "ON" or "OFF")
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16

    btn.MouseButton1Click:Connect(function()
        default = not default
        btn.Text = name..": "..(default and "ON" or "OFF")
        btn.BackgroundColor3 = default and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
        onChange(default)
    end)
end

--========================================================
-- Crear controles
--========================================================
createInput("Speed", CONFIG.speed, 50, function(val)
    CONFIG.speed = val
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = val
    end
end)

createInput("JumpPower", CONFIG.jumpPower, 90, function(val)
    CONFIG.jumpPower = val
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.JumpPower = val
    end
end)

createInput("MaxHealth", CONFIG.maxHealth, 130, function(val)
    CONFIG.maxHealth = val
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.MaxHealth = val
        LP.Character.Humanoid.Health = val
    end
end)

createInput("RespawnTime", CONFIG.respawnTime, 170, function(val)
    CONFIG.respawnTime = val
end)

createToggle("Debug Mode", CONFIG.debugMode, 210, function(val)
    CONFIG.debugMode = val
end)

--========================================================
-- FUNCIONES DE COMBATE (igual al script de servidor)
--========================================================
local function calculateDamage(baseDamage, distance, player)
    local character = player.Character
    if not character then return 0 end
    
    local modifier = 1
    if distance > 10 then
        modifier = modifier * (1 - (distance - 10) * 0.02)
    end
    modifier = modifier * (math.random() * 0.2 + 0.9)
    return math.floor(baseDamage * modifier)
end

local function setupPlayer(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = CONFIG.speed
    humanoid.JumpPower = CONFIG.jumpPower
    humanoid.MaxHealth = CONFIG.maxHealth
    humanoid.Health = CONFIG.maxHealth
end

for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end
Players.PlayerAdded:Connect(setupPlayer)

-- Loop de respawn
RunService.Heartbeat:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            local humanoid = character.Humanoid
            if humanoid.Health <= 0 and not character:FindFirstChild("Respawning") then
                local respawning = Instance.new("BoolValue")
                respawning.Name = "Respawning"
                respawning.Parent = character
                task.delay(CONFIG.respawnTime, function()
                    respawnEvent:FireClient(player)
                end)
            end
        end
    end
end)
