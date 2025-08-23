-- XLSpy v6 - Android Fix PRO
-- Optimizado para exploits móviles

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XLSpyV6"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 330, 0, 300)
Frame.Position = UDim2.new(0.25, 0, 0.25, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true -- 🔑 mover con dedo en Android
Frame.ZIndex = 10
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "⚡ XLSpy v6 (Android Fix PRO)"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.ZIndex = 11

local ScrollingFrame = Instance.new("ScrollingFrame", Frame)
ScrollingFrame.Size = UDim2.new(1, 0, 1, -60)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 30)
ScrollingFrame.CanvasSize = UDim2.new(0,0,0,0)
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.ZIndex = 10

local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local BtnClear = Instance.new("TextButton", Frame)
BtnClear.Size = UDim2.new(0.5, 0, 0, 30)
BtnClear.Position = UDim2.new(0, 0, 1, -30)
BtnClear.Text = "🗑️ Clear"
BtnClear.BackgroundColor3 = Color3.fromRGB(200,50,50)
BtnClear.TextColor3 = Color3.new(1,1,1)
BtnClear.ZIndex = 11

local BtnCopy = Instance.new("TextButton", Frame)
BtnCopy.Size = UDim2.new(0.5, 0, 0, 30)
BtnCopy.Position = UDim2.new(0.5, 0, 1, -30)
BtnCopy.Text = "📋 Copy Selected"
BtnCopy.BackgroundColor3 = Color3.fromRGB(50,150,250)
BtnCopy.TextColor3 = Color3.new(1,1,1)
BtnCopy.ZIndex = 11

-- Data
local logged = {}
local selectedRemote = nil

-- Safe tostring
local function safeValue(v)
    local t = typeof(v)
    if t == "string" then
        return '"'..v..'"'
    elseif t == "number" or t == "boolean" then
        return tostring(v)
    elseif t == "Instance" then
        return 'game.'..v:GetFullName()
    else
        return "["..t.."]"
    end
end

-- Export args
local function exportRemote(remote, args)
    local str = "-- XLSpy v6 export\n"
    if remote:IsA("RemoteEvent") then
        str = str .. remote:GetFullName()..':FireServer('
    elseif remote:IsA("RemoteFunction") then
        str = str .. remote:GetFullName()..':InvokeServer('
    end
    for i,a in ipairs(args) do
        str = str .. safeValue(a)
        if i < #args then str = str .. ", " end
    end
    str = str .. ")"
    return str
end

-- Registrar
local function logRemote(remote, args)
    if not logged[remote] then
        logged[remote] = {count = 0, args = args}
        local btn = Instance.new("TextButton", ScrollingFrame)
        btn.Size = UDim2.new(1, -5, 0, 28)
        btn.Text = remote.Name.." (1x)"
        btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.ZIndex = 10
        btn.MouseButton1Click:Connect(function()
            selectedRemote = {remote=remote, args=args}
            btn.BackgroundColor3 = Color3.fromRGB(100,150,100) -- highlight
        end)
        logged[remote].btn = btn
    end
    logged[remote].count += 1
    logged[remote].args = args
    logged[remote].btn.Text = remote.Name.." ("..logged[remote].count.."x)"
end

-- Hook
local function hookRemote(v)
    if v:IsA("RemoteEvent") then
        v.OnClientEvent:Connect(function(...)
            logRemote(v, {...})
        end)
    elseif v:IsA("RemoteFunction") then
        v.OnClientInvoke = function(...)
            logRemote(v, {...})
        end
    end
end

for _,v in ipairs(ReplicatedStorage:GetDescendants()) do
    hookRemote(v)
end
ReplicatedStorage.DescendantAdded:Connect(hookRemote)

-- Botones
BtnClear.MouseButton1Click:Connect(function()
    logged = {}
    selectedRemote = nil
    for _,c in pairs(ScrollingFrame:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
end)

BtnCopy.MouseButton1Click:Connect(function()
    if selectedRemote then
        local str = exportRemote(selectedRemote.remote, selectedRemote.args)
        if setclipboard then
            setclipboard(str)
        end
        print(str)
    else
        print("[XLSpy] Nada seleccionado")
    end
end)
