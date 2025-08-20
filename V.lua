--// =========================
--// HUB XL3RL + NOCLIP + COMBOS + SERVIDORES
--// =========================

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- GUI principal
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "XL3RL_GUI"
screenGui.ResetOnSpawn = false

-- Botón flotante (icono ninja para abrir/cerrar el menú)
local toggleIcon = Instance.new("ImageButton", screenGui)
toggleIcon.Size = UDim2.new(0, 50, 0, 50)
toggleIcon.Position = UDim2.new(0.85, 0, 0.15, 0)
toggleIcon.BackgroundTransparency = 1
toggleIcon.Image = "rbxassetid://7072724538" -- icono ninja

-- Frame del menú
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 240, 0, 230)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -115)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.BorderSizePixel = 0
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

-- =============================
-- FUNCIONES NOCLIP
-- =============================
local noclipEnabled = false
local connection

local function enableNoClip()
    connection = RunService.Stepped:Connect(function()
        if player.Character then
            for _,v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide == true then
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

-- =============================
-- BOTONES
-- =============================
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

-- Botón NoClip
local noclipBtn = createButton("NO-CLIP: OFF")
noclipBtn.Parent = mainFrame
noclipBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        noclipBtn.Text = "NO-CLIP: ON"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
        enableNoClip()
    else
        noclipBtn.Text = "NO-CLIP: OFF"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
        disableNoClip()
    end
end)

-- Botón Combo Scripts
local comboBtn = createButton("COMBO SCRIPTS")
comboBtn.Parent = mainFrame
comboBtn.MouseButton1Click:Connect(function()
    -- Ejecuta los 2 scripts del combo 🔥
    loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))()
    loadstring(game:HttpGet("https://gist.githubusercontent.com/UCT-hub/5b11d10386f1b8ce08feb803861e0b79/raw/b2917b398d4b0cc80fb2aca73a3137ba494ebcf0/gistfile1.txt"))()
end)

-- Botón Cambiar Servidor
local serverBtn = createButton("CAMBIAR SERVIDOR")
serverBtn.Parent = mainFrame
serverBtn.MouseButton1Click:Connect(function()
    -- Ejecuta el script de GatoHub 🔥
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Gato-bytes/GatoHubOnTop/refs/heads/main/AutoJoin.lua"))()
end)

-- =============================
-- MOSTRAR/OCULTAR MENU
-- =============================
toggleIcon.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)
