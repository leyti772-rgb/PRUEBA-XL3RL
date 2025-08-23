-- XLSpy v7.1 (Android Ready, Fix Args Export)
-- Mejor serialización de argumentos + botón Clear
-- by ChatGPT

if getgenv().XLSpy then
    warn("XLSpy ya está cargado")
    return
end
getgenv().XLSpy = true

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- ===== Helpers =====
local function deepToString(val, depth)
    depth = depth or 0
    local t = typeof(val)
    if t == "string" then
        return '"'..val..'"'
    elseif t == "number" or t == "boolean" then
        return tostring(val)
    elseif t == "Vector3" then
        return string.format("Vector3.new(%s,%s,%s)", val.X, val.Y, val.Z)
    elseif t == "CFrame" then
        return "CFrame.new("..table.concat({val:GetComponents()}, ",")..")"
    elseif t == "Instance" then
        return "game."..val:GetFullName()
    elseif t == "table" then
        if depth > 1 then return "{...}" end -- evita loops
        local parts = {}
        for k,v in pairs(val) do
            table.insert(parts, "["..deepToString(k, depth+1).."] = "..deepToString(v, depth+1))
        end
        return "{"..table.concat(parts,", ").."}"
    else
        return "["..t.."]"
    end
end

-- ===== UI =====
local ScreenGui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

-- Botón flotante 👁️
local FloatBtn = Instance.new("TextButton", ScreenGui)
FloatBtn.Size = UDim2.new(0,50,0,50)
FloatBtn.Position = UDim2.new(0.05,0,0.3,0)
FloatBtn.Text = "👁️"
FloatBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
FloatBtn.TextColor3 = Color3.fromRGB(255,255,255)
FloatBtn.Active = true
FloatBtn.Draggable = true

-- Panel principal
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,300,0,260)
Main.Position = UDim2.new(0.25,0,0.25,0)
Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Main.Visible = false

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,28)
Title.BackgroundColor3 = Color3.fromRGB(45,45,45)
Title.Text = "⚡ XLSpy v7.1 (Android)"
Title.TextColor3 = Color3.fromRGB(0,255,127)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local ClearBtn = Instance.new("TextButton", Main)
ClearBtn.Size = UDim2.new(0,60,0,24)
ClearBtn.Position = UDim2.new(1,-65,0,2)
ClearBtn.Text = "Clear"
ClearBtn.TextColor3 = Color3.fromRGB(255,255,255)
ClearBtn.BackgroundColor3 = Color3.fromRGB(180,50,50)
ClearBtn.Font = Enum.Font.SourceSansBold
ClearBtn.TextSize = 14

local Logs = Instance.new("ScrollingFrame", Main)
Logs.Size = UDim2.new(1,0,1,-30)
Logs.Position = UDim2.new(0,0,0,30)
Logs.CanvasSize = UDim2.new(0,0,0,0)
Logs.ScrollBarThickness = 4
Logs.BackgroundTransparency = 1

FloatBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

ClearBtn.MouseButton1Click:Connect(function()
    for _,c in ipairs(Logs:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    Logs.CanvasSize = UDim2.new(0,0,0,0)
end)

-- ===== Logs =====
local function addLog(remote, args)
    local argStrs = {}
    for i,a in ipairs(args) do
        table.insert(argStrs, deepToString(a))
    end
    
    local logBtn = Instance.new("TextButton", Logs)
    logBtn.Size = UDim2.new(1,-6,0,28)
    logBtn.Position = UDim2.new(0,3,0,#Logs:GetChildren()*28)
    logBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    logBtn.TextColor3 = Color3.fromRGB(255,255,255)
    logBtn.Font = Enum.Font.SourceSans
    logBtn.TextSize = 14
    logBtn.TextXAlignment = Enum.TextXAlignment.Left
    logBtn.Text = remote.Name.." ("..#args.." args)"
    
    logBtn.MouseButton1Click:Connect(function()
        local code = "game."..remote:GetFullName()..":FireServer("..table.concat(argStrs,", ")..")"
        setclipboard(code)
    end)

    Logs.CanvasSize = UDim2.new(0,0,0, #Logs:GetChildren()*28)
end

-- ===== Hook =====
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt,false)
mt.__namecall = function(self,...)
    local method = getnamecallmethod()
    if method == "FireServer" then
        local args = {...}
        pcall(function()
            addLog(self,args)
        end)
    end
    return old(self,...)
end
setreadonly(mt,true)
