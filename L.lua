--[[
    Script: XL3RL - V4.1 (Versión de Máxima Compatibilidad)
    Descripción: Un diseño ultra robusto con un botón de texto para reabrir,
                 garantizando que todos los elementos sean visibles.
]]

-- ================== SERVICIOS Y JUGADOR ==================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ================== CREACIÓN DE LA GUI ==================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XL3RL_GUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- FRAME PRINCIPAL
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(200, 0, 0)
MainFrame.Parent = ScreenGui

-- BARRA SUPERIOR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

-- TÍTULO
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "XL3RL"
Title.Font = Enum.Font.SourceSansBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Parent = TopBar

-- BOTONES DE CIERRE Y MINIMIZAR
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 1, 0); CloseButton.Position = UDim2.new(1, -30, 0, 0); CloseButton.Text = "X"; CloseButton.Font = Enum.Font.SourceSansBold; CloseButton.TextSize = 20; CloseButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0); CloseButton.TextColor3 = Color3.new(1, 1, 1); CloseButton.Parent = TopBar

local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.new(0, 30, 1, 0); MinButton.Position = UDim2.new(1, -60, 0, 0); MinButton.Text = "-"; MinButton.Font = Enum.Font.SourceSansBold; MinButton.TextSize = 24; MinButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0); MinButton.TextColor3 = Color3.new(1, 1, 1); MinButton.Parent = TopBar

-- ✨ CAMBIO FINAL: BOTÓN DE TEXTO PARA REABRIR (a prueba de fallos) ✨
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 50, 0, 50)
OpenButton.Position = UDim2.new(0, 15, 1, -65)
OpenButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
OpenButton.BorderSizePixel = 0
OpenButton.Text = "▶"
OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.TextColor3 = Color3.new(1, 1, 1)
OpenButton.TextSize = 24
OpenButton.Visible = false
OpenButton.Parent = ScreenGui
local OpenCorner = Instance.new("UICorner", OpenButton); OpenCorner.CornerRadius = UDim.new(1,0) -- Lo hace redondo

-- ================== CREACIÓN DE BOTONES DE FUNCIÓN ==================
local ObligatorioBoton = Instance.new("TextButton"); ObligatorioBoton.Size = UDim2.new(0, 280, 0, 40); ObligatorioBoton.Position = UDim2.new(0.5, -140, 0, 40); ObligatorioBoton.Text = "OBLIGATORIO: OFF"; ObligatorioBoton.Parent = MainFrame
local ChilliButton = Instance.new("TextButton"); ChilliButton.Size = UDim2.new(0, 280, 0, 40); ChilliButton.Position = UDim2.new(0.5, -140, 0, 90); ChilliButton.Text = "SCRIPT SALTO INIFITO"; ChilliButton.Parent = MainFrame
local ServidoresButton = Instance.new("TextButton"); ServidoresButton.Size = UDim2.new(0, 280, 0, 40); ServidoresButton.Position = UDim2.new(0.5, -140, 0, 140); ServidoresButton.Text = "SERVIDORES"; ServidoresButton.Parent = MainFrame
local AutoBaseButton = Instance.new("TextButton"); AutoBaseButton.Size = UDim2.new(0, 280, 0, 40); AutoBaseButton.Position = UDim2.new(0.5, -140, 0, 190); AutoBaseButton.Text = "AUTO BASE"; AutoBaseButton.Parent = MainFrame

-- APLICAR ESTILOS COMUNES
for _, btn in pairs({ObligatorioBoton, ChilliButton, ServidoresButton, AutoBaseButton}) do
    btn.Font = Enum.Font.SourceSans; btn.TextSize = 18; btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60); btn.TextColor3 = Color3.new(1, 1, 1)
end

-- ================== LÓGICA ==================
local dragging = false; local dragStart; local startPos
TopBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = MainFrame.Position end end)
TopBar.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

MinButton.MouseButton1Click:Connect(function() MainFrame.Visible = false; OpenButton.Visible = true end)
OpenButton.MouseButton1Click:Connect(function() MainFrame.Visible = true; OpenButton.Visible = false end)
CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local noClipEnabled = false; local noClipConnection = nil
ObligatorioBoton.MouseButton1Click:Connect(function()
    noClipEnabled = not noClipEnabled
    ObligatorioBoton.Text = noClipEnabled and "OBLIGATORIO: ON" or "OBLIGATORIO: OFF"
    ObligatorioBoton.BackgroundColor3 = noClipEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    if noClipEnabled then noClipConnection = RunService.Stepped:Connect(function() local char = player.Character; if char then for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end end end end) else if noClipConnection then noClipConnection:Disconnect(); noClipConnection = nil end end
end)

local function executeScript(button, url)
    spawn(function()
        local originalText = button.Text
        button.Text = "Cargando..."; button.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
        local success, result = pcall(function() loadstring(game:HttpGet(url))() end)
        if success then button.Text = "¡Ejecutado!"; button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        else button.Text = "¡Error!"; button.BackgroundColor3 = Color3.fromRGB(200, 0, 0); warn("Error ejecutando script: " .. tostring(result)) end
        wait(2); button.Text = originalText; button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)
end

ChilliButton.MouseButton1Click:Connect(function() executeScript(ChilliButton, "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua") end)
ServidoresButton.MouseButton1Click:Connect(function() executeScript(ServidoresButton, "https://api.luarmor.net/files/v3/loaders/f927290098f4333a9d217cbecbe6e988.lua") end)
AutoBaseButton.MouseButton1Click:Connect(function() executeScript(AutoBaseButton, "https://gist.githubusercontent.com/UCT-hub/5b11d1_b2917b398d4b0cc80fb2aca73a3137ba494ebcf0/gistfile1.txt") end)

