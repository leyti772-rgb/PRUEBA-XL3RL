-- =========================================================================================
--                                   SCRIPT BASE
-- =========================================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- ScreenGui principal
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "XL3RL_GUI"
screenGui.ResetOnSpawn = false

-- Fondo del menú principal
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 200, 0, 150)
mainFrame.Position = UDim2.new(0.75, -100, 0.4, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- Titulo del hub
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "XL3RL"
title.Font = Enum.Font.Code
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(0,200,255)
title.BackgroundTransparency = 1

-- Botón de abrir NoClip
local openNoClip = Instance.new("TextButton", mainFrame)
openNoClip.Size = UDim2.new(1, -20, 0, 30)
openNoClip.Position = UDim2.new(0, 10, 0, 40)
openNoClip.Text = "PANEL NO-CLIP"
openNoClip.Font = Enum.Font.Code
openNoClip.TextSize = 14
openNoClip.TextColor3 = Color3.fromRGB(255,255,255)
openNoClip.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", openNoClip).CornerRadius = UDim.new(0, 4)

-- =========================================================================================
--                                   PANEL NO-CLIP
-- =========================================================================================
local noclipFrame = Instance.new("Frame", screenGui)
noclipFrame.Size = UDim2.new(0, 200, 0, 100)
noclipFrame.Position = UDim2.new(0.4, 0, 0.3, 0)
noclipFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
noclipFrame.Visible = false
noclipFrame.Active = true
noclipFrame.Draggable = true
noclipFrame.ZIndex = 50
Instance.new("UICorner", noclipFrame).CornerRadius = UDim.new(0, 6)

local noclipTitle = Instance.new("TextLabel", noclipFrame)
noclipTitle.Size = UDim2.new(1, 0, 0, 30)
noclipTitle.Text = "NO-CLIP"
noclipTitle.Font = Enum.Font.Code
noclipTitle.TextSize = 16
noclipTitle.TextColor3 = Color3.fromRGB(0,200,255)
noclipTitle.BackgroundTransparency = 1

local closeBtn = Instance.new("TextButton", noclipFrame)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 3)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.Code
closeBtn.BackgroundTransparency = 1
closeBtn.ZIndex = 51

-- Botón ON/OFF
local toggleBtn = Instance.new("TextButton", noclipFrame)
toggleBtn.Size = UDim2.new(0, 80, 0, 30)
toggleBtn.Position = UDim2.new(0.5, -40, 0.5, -15)
toggleBtn.Text = "OFF"
toggleBtn.Font = Enum.Font.Code
toggleBtn.TextSize = 14
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
toggleBtn.ZIndex = 51
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 4)

-- =========================================================================================
--                                FUNCIONES NO-CLIP
-- =========================================================================================
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

-- =========================================================================================
--                                EVENTOS DE BOTONES
-- =========================================================================================
openNoClip.MouseButton1Click:Connect(function()
    noclipFrame.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
    noclipFrame.Visible = false
end)

toggleBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        toggleBtn.Text = "ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
        enableNoClip()
    else
        toggleBtn.Text = "OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
        disableNoClip()
    end
end)
