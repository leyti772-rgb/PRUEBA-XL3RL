-- XLSpy v5 - Optimizado Anti-Lag + Copy/Clear
-- by ChatGPT

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "XLSpyV5"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 250)
Frame.Position = UDim2.new(0.5, -150, 0.5, -125)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "⚡ XLSpy v5"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local ScrollingFrame = Instance.new("ScrollingFrame", Frame)
ScrollingFrame.Size = UDim2.new(1, 0, 1, -60)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 30)
ScrollingFrame.CanvasSize = UDim2.new(0,0,0,0)
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local BtnClear = Instance.new("TextButton", Frame)
BtnClear.Size = UDim2.new(0.5, 0, 0, 30)
BtnClear.Position = UDim2.new(0, 0, 1, -30)
BtnClear.Text = "🗑️ Clear"
BtnClear.BackgroundColor3 = Color3.fromRGB(200,50,50)
BtnClear.TextColor3 = Color3.new(1,1,1)

local BtnCopy = Instance.new("TextButton", Frame)
BtnCopy.Size = UDim2.new(0.5, 0, 0, 30)
BtnCopy.Position = UDim2.new(0.5, 0, 1, -30)
BtnCopy.Text = "📋 Copy"
BtnCopy.BackgroundColor3 = Color3.fromRGB(50,150,250)
BtnCopy.TextColor3 = Color3.new(1,1,1)

-- Data
local logged = {} -- evita duplicados
local selectedRemote = nil

-- Hook Remotes
local function logRemote(remote, args)
    if logged[remote] then return end
    logged[remote] = args

    local btn = Instance.new("TextButton", ScrollingFrame)
    btn.Size = UDim2.new(1, -5, 0, 25)
    btn.Text = remote.Name .. " (" .. #args .. " args)"
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(function()
        selectedRemote = {remote=remote, args=args}
    end)
end

local function hook(remote)
    if remote:IsA("RemoteEvent") then
        local old; old = hookfunction(remote.FireServer, function(self,...)
            local args = {...}
            logRemote(self, args)
            return old(self,...)
        end)
    elseif remote:IsA("RemoteFunction") then
        local old; old = hookfunction(remote.InvokeServer, function(self,...)
            local args = {...}
            logRemote(self, args)
            return old(self,...)
        end)
    end
end

-- Hook todos
for _,v in ipairs(getdescendants(ReplicatedStorage)) do
    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
        hook(v)
    end
end

ReplicatedStorage.DescendantAdded:Connect(function(v)
    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
        hook(v)
    end
end)

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
        local remote = selectedRemote.remote
        local args = selectedRemote.args
        local str = "-- XLSpy v5 export\n"
        str = str .. 'game:GetService("ReplicatedStorage").'..remote:GetFullName()..':FireServer('
        for i,a in ipairs(args) do
            str = str .. tostring(a)
            if i < #args then str = str .. "," end
        end
        str = str .. ")"
        setclipboard(str)
    end
end)
