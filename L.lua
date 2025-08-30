local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local LP = Players.LocalPlayer

-- GUI simple
local ScreenGui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
ScreenGui.Name = "ServerSwitcherGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,200,0,100)
Frame.Position = UDim2.new(0.5,-100,0.5,-50)
Frame.BackgroundColor3 = Color3.fromRGB(40,40,40)

local Btn = Instance.new("TextButton", Frame)
Btn.Size = UDim2.new(1,-20,0,40)
Btn.Position = UDim2.new(0,10,0.5,-20)
Btn.Text = "Ir al juego"
Btn.BackgroundColor3 = Color3.fromRGB(0,170,0)
Btn.TextColor3 = Color3.new(1,1,1)
Btn.Font = Enum.Font.Code
Btn.TextSize = 16

-- Cada click hace un teleport general al juego
Btn.MouseButton1Click:Connect(function()
    pcall(function()
        TeleportService:Teleport(109983668079237, LP)
    end)
end)
