-- XL Spammer Controlado – RE/UseItem
-- Por ChatGPT

local RS = game:GetService("ReplicatedStorage")
local LP = game:GetService("Players").LocalPlayer
local remote = RS.Packages.Net:FindFirstChild("RE/UseItem")

local arg = 1.983 -- ⚡ aquí va el número que te mostró SimpleSpy
local spamOn = false
local interval = 0.01 -- segundos entre cada Fire (0.01 = ~100 veces/seg)

-- UI simple flotante
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0,160,0,50)
btn.Position = UDim2.new(0.4,0,0.2,0)
btn.BackgroundColor3 = Color3.fromRGB(170,20,20)
btn.Text = "SPAM OFF"
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 20

btn.MouseButton1Click:Connect(function()
    spamOn = not spamOn
    if spamOn then
        btn.Text = "SPAM ON"
        btn.BackgroundColor3 = Color3.fromRGB(0,160,0)
    else
        btn.Text = "SPAM OFF"
        btn.BackgroundColor3 = Color3.fromRGB(170,20,20)
    end
end)

-- Loop
task.spawn(function()
    while task.wait(interval) do
        if spamOn and remote then
            pcall(function()
                remote:FireServer(arg)
            end)
        end
    end
end)
