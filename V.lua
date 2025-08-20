--// =========================
--// HUB XL3RL + NOCLIP SUBMENÚ
--// =========================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- GUI principal
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "XL3RL_GUI"
screenGui.ResetOnSpawn = false

-- Botón flotante (ninja para abrir/cerrar menú principal)
local toggleIcon = Instance.new("ImageButton", screenGui)
toggleIcon.Size = UDim2.new(0, 50, 0, 50)
toggleIcon.Position = UDim2.new(0.85, 0, 0.15, 0)
toggleIcon.BackgroundTransparency = 1
toggleIcon.Image = "rbxassetid://7072724538"

-- Frame principal
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 240, 0, 230)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -115)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- Título
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "⚡ XL3RL HUB ⚡"
title.Font = Enum.Font.FredokaOne
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(0, 255, 200)
title.BackgroundTransparency = 1

-- Layout
local layout = Instance.new("UIListLayout", mainFrame)
layout.Padding = UDim.new(0, 8)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Función crear botones
local function createButton(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

-- =============================
-- NOCLIP SUBMENÚ
-- =============================
local noclipEnabled = false
local connection

local function enableNoClip()
    connection = RunService.Stepped:Connect(function()
        if player.Character then
            for _,v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end)
end

local function disableNoClip()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    if player.Character then
        for _,v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
    end
end

-- Submenú estilo "activar teleguiado"
local noclipMenu = Instance.new("Frame", screenGui)
noclipMenu.Size = UDim2.new(0, 200, 0, 120)
noclipMenu.Position = UDim2.new(0.7, 0, 0.4, 0)
noclipMenu.BackgroundColor3 = Color3.fromRGB(0,40,0)
noclipMenu.BorderSizePixel = 0
noclipMenu.Visible = false
Instance.new("UICorner", noclipMenu).CornerRadius = UDim.new(0, 12)

local noclipLabel = Instance.new("TextLabel", noclipMenu)
noclipLabel.Size = UDim2.new(1, 0, 0, 30)
noclipLabel.Text = "⚡ NO-CLIP ⚡"
noclipLabel.Font = Enum.Font.GothamBold
noclipLabel.TextSize = 16
noclipLabel.TextColor3 = Color3.fromRGB(0,255,0)
noclipLabel.BackgroundTransparency = 1

local subLayout = Instance.new("UIListLayout", noclipMenu)
subLayout.Padding = UDim.new(0, 6)
subLayout.FillDirection = Enum.FillDirection.Vertical
subLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
subLayout.VerticalAlignment = Enum.VerticalAlignment.Top
subLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Botones dentro del submenú
local onBtn = createButton("ACTIVAR NOCLIP")
onBtn.Parent = noclipMenu
onBtn.BackgroundColor3 = Color3.fromRGB(0,150,0)
onBtn.MouseButton1Click:Connect(function()
    enableNoClip()
    noclipEnabled = true
end)

local offBtn = createButton("DESACTIVAR NOCLIP")
offBtn.Parent = noclipMenu
offBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
offBtn.MouseButton1Click:Connect(function()
    disableNoClip()
    noclipEnabled = false
end)

local closeBtn = createButton("❌ CERRAR")
closeBtn.Parent = noclipMenu
closeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
closeBtn.MouseButton1Click:Connect(function()
    noclipMenu.Visible = false
end)

-- =============================
-- BOTONES DEL HUB
-- =============================
local noclipBtn = createButton("NO-CLIP MENU")
noclipBtn.Parent = mainFrame
noclipBtn.MouseButton1Click:Connect(function()
    noclipMenu.Visible = not noclipMenu.Visible
end)

local comboBtn = createButton("COMBO SCRIPTS")
comboBtn.Parent = mainFrame
comboBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))()
    loadstring(game:HttpGet("https://gist.githubusercontent.com/UCT-hub/5b11d10386f1b8ce08feb803861e0b79/raw/b2917b398d4b0cc80fb2aca73a3137ba494ebcf0/gistfile1.txt"))()
end)

local serverBtn = createButton("CAMBIAR SERVIDOR")
serverBtn.Parent = mainFrame
serverBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Gato-bytes/GatoHubOnTop/refs/heads/main/AutoJoin.lua"))()
end)

-- =============================
-- MOSTRAR/OCULTAR HUB
-- =============================
toggleIcon.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)
