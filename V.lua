--// ============================
--// HUB XL3RL - DISEÑO PREMIUM
--// ============================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- GUI principal
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "XL3RL_HUB"
screenGui.ResetOnSpawn = false

-- ============================
-- ICONO FLOTANTE
-- ============================
local iconBtn = Instance.new("ImageButton", screenGui)
iconBtn.Size = UDim2.new(0,60,0,60)
iconBtn.Position = UDim2.new(0, 50, 0.5, -30)
iconBtn.BackgroundTransparency = 1
iconBtn.Image = "rbxassetid://7743878855" -- icono ninja (puedes cambiar)
iconBtn.Active = true
iconBtn.Draggable = true

-- animación al pasar mouse
iconBtn.MouseEnter:Connect(function()
    TweenService:Create(iconBtn, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Size = UDim2.new(0,65,0,65)}):Play()
end)
iconBtn.MouseLeave:Connect(function()
    TweenService:Create(iconBtn, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Size = UDim2.new(0,60,0,60)}):Play()
end)

-- ============================
-- MENÚ PRINCIPAL
-- ============================
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 260, 0, 280)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true

-- bordes y estilo
local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 15)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0,255,128)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local gradient = Instance.new("UIGradient", mainFrame)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,200,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,255,150))
}
gradient.Rotation = 45

-- título
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "⚡ XL3RL HUB ⚡"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1

-- layout botones
local layout = Instance.new("UIListLayout", mainFrame)
layout.Padding = UDim.new(0,10)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- función para crear botones premium
local function createButton(text,color1,color2)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(255,255,255)

    local gradient = Instance.new("UIGradient", btn)
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    }

    -- animación click
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Size = UDim2.new(0.92,0,0,42)}):Play()
        task.wait(0.2)
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Size = UDim2.new(0.9,0,0,40)}):Play()
    end)

    btn.Parent = mainFrame
    return btn
end

-- ============================
-- SUBMENÚ NOCLIP
-- ============================
local noclipFrame = Instance.new("Frame", screenGui)
noclipFrame.Size = UDim2.new(0, 220, 0, 150)
noclipFrame.Position = UDim2.new(0.7, -100, 0.4, 0)
noclipFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
noclipFrame.Visible = false
noclipFrame.Active = true
noclipFrame.Draggable = true

Instance.new("UICorner", noclipFrame).CornerRadius = UDim.new(0, 12)
local stroke2 = Instance.new("UIStroke", noclipFrame)
stroke2.Thickness = 2
stroke2.Color = Color3.fromRGB(0,200,255)

local subLayout = Instance.new("UIListLayout", noclipFrame)
subLayout.Padding = UDim.new(0,8)
subLayout.FillDirection = Enum.FillDirection.Vertical
subLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
subLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local subTitle = Instance.new("TextLabel", noclipFrame)
subTitle.Size = UDim2.new(1,0,0,35)
subTitle.Text = "🌀 NO-CLIP MENU 🌀"
subTitle.Font = Enum.Font.GothamBold
subTitle.TextSize = 16
subTitle.TextColor3 = Color3.fromRGB(0,255,200)
subTitle.BackgroundTransparency = 1

-- lógica noclip
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

local btnOn = createButton("✅ Activar NoClip", Color3.fromRGB(0,200,100), Color3.fromRGB(0,255,150))
btnOn.Parent = noclipFrame
btnOn.MouseButton1Click:Connect(enableNoClip)

local btnOff = createButton("❌ Desactivar NoClip", Color3.fromRGB(200,0,0), Color3.fromRGB(255,80,80))
btnOff.Parent = noclipFrame
btnOff.MouseButton1Click:Connect(disableNoClip)

local btnClose = createButton("🔙 Cerrar", Color3.fromRGB(100,100,100), Color3.fromRGB(60,60,60))
btnClose.Parent = noclipFrame
btnClose.MouseButton1Click:Connect(function()
    noclipFrame.Visible = false
end)

-- ============================
-- BOTONES HUB PRINCIPAL
-- ============================
local noclipBtn = createButton("🌀 No-Clip Menu", Color3.fromRGB(0,200,255), Color3.fromRGB(0,255,150))
noclipBtn.MouseButton1Click:Connect(function()
    noclipFrame.Visible = not noclipFrame.Visible
end)

local comboBtn = createButton("⚡ Combo Scripts", Color3.fromRGB(255,128,0), Color3.fromRGB(255,200,0))
comboBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))()
    loadstring(game:HttpGet("https://gist.githubusercontent.com/UCT-hub/5b11d10386f1b8ce08feb803861e0b79/raw/b2917b398d4b0cc80fb2aca73a3137ba494ebcf0/gistfile1.txt"))()
end)

local serverBtn = createButton("🌍 Cambiar Servidor", Color3.fromRGB(0,150,255), Color3.fromRGB(0,200,200))
serverBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Gato-bytes/GatoHubOnTop/refs/heads/main/AutoJoin.lua"))()
end)

-- toggle menú con icono flotante
iconBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)
