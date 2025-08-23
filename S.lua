-- MiniSpy Lite - Roblox Remote Logger (optimizado para móvil)
-- Hecho para pruebas, NO reemplaza a SimpleSpy completo

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

-- Crear GUI básica
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name = "MiniSpyGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local text = Instance.new("TextLabel", frame)
text.Size = UDim2.new(1,0,1,0)
text.BackgroundTransparency = 1
text.TextColor3 = Color3.fromRGB(0,255,0)
text.Font = Enum.Font.Code
text.TextSize = 14
text.TextXAlignment = Enum.TextXAlignment.Left
text.TextYAlignment = Enum.TextYAlignment.Top
text.Text = "Esperando eventos..."

-- Función para loggear
local function log(remote, args)
    local dump = "Remote: "..remote.Name.."\n"
    for i,v in ipairs(args) do
        dump = dump.."["..i.."] = "..tostring(v).."\n"
    end
    text.Text = dump
    print("[MiniSpy] ->", remote, args)
end

-- Hookear todos los remotes en ReplicatedStorage.Packages.Net
for _,obj in pairs(RS:GetDescendants()) do
    if obj:IsA("RemoteEvent") then
        obj.OnClientEvent:Connect(function(...)
            log(obj, {...})
        end)
    elseif obj:IsA("RemoteFunction") then
        obj.OnClientInvoke = function(...)
            log(obj, {...})
        end
    end
end
