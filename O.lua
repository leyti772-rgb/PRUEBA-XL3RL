-- XLSpy v7.3 (Android)
-- Fix argumentos nil y ocultos
-- by ChatGPT

if getgenv().XLSpy then
    warn("XLSpy ya cargado")
    return
end
getgenv().XLSpy = true

local LP = game:GetService("Players").LocalPlayer

-- ===== Serializador avanzado =====
local function deepToString(val, depth)
    depth = depth or 0
    local t = typeof(val)
    if t == "nil" then
        return "nil"
    elseif t == "string" then
        return '"'..val..'"'
    elseif t == "number" or t == "boolean" then
        return tostring(val)
    elseif t == "Vector3" then
        return string.format("Vector3.new(%s,%s,%s)", val.X, val.Y, val.Z)
    elseif t == "CFrame" then
        return "CFrame.new("..table.concat({val:GetComponents()}, ",")..")"
    elseif t == "Instance" then
        return val:GetFullName()
    elseif t == "Color3" then
        return string.format("Color3.fromRGB(%d,%d,%d)", val.R*255, val.G*255, val.B*255)
    elseif t == "EnumItem" then
        return tostring(val)
    elseif t == "table" then
        if depth > 1 then return "{...}" end
        local parts = {}
        for k,v in pairs(val) do
            table.insert(parts, "["..deepToString(k, depth+1).."] = "..deepToString(v, depth+1))
        end
        return "{"..table.concat(parts,", ").."}"
    else
        return "<"..t..">"
    end
end

-- ===== UI =====
local SG = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
SG.ResetOnSpawn = false

local Btn = Instance.new("TextButton", SG)
Btn.Size = UDim2.new(0,50,0,50)
Btn.Position = UDim2.new(0.05,0,0.3,0)
Btn.Text = "👁️"
Btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
Btn.TextColor3 = Color3.fromRGB(255,255,255)
Btn.Draggable = true

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0,340,0,300)
Main.Position = UDim2.new(0.25,0,0.25,0)
Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Main.Visible = false

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,28)
Title.BackgroundColor3 = Color3.fromRGB(45,45,45)
Title.Text = "⚡ XLSpy v7.3 (Android)"
Title.TextColor3 = Color3.fromRGB(0,255,127)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local ClearBtn = Instance.new("TextButton", Main)
ClearBtn.Size = UDim2.new(0,60,0,24)
ClearBtn.Position = UDim2.new(1,-65,0,2)
ClearBtn.Text = "Clear"
ClearBtn.TextColor3 = Color3.fromRGB(255,255,255)
ClearBtn.BackgroundColor3 = Color3.fromRGB(180,50,50)

local Logs = Instance.new("ScrollingFrame", Main)
Logs.Size = UDim2.new(1,0,1,-30)
Logs.Position = UDim2.new(0,0,0,30)
Logs.CanvasSize = UDim2.new(0,0,0,0)
Logs.ScrollBarThickness = 4
Logs.BackgroundTransparency = 1

Btn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

ClearBtn.MouseButton1Click:Connect(function()
    for _,c in ipairs(Logs:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    Logs.CanvasSize = UDim2.new(0,0,0,0)
end)

-- ===== Logs con args reales =====
local function addLog(remote, args, argc)
    local argStrs = {}
    for i=1,argc do
        table.insert(argStrs, deepToString(args[i]))
    end
    local disp = remote.Name.." ("..argc.." args)"

    local logBtn = Instance.new("TextButton", Logs)
    logBtn.Size = UDim2.new(1,-6,0,28)
    logBtn.Position = UDim2.new(0,3,0,#Logs:GetChildren()*28)
    logBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    logBtn.TextColor3 = Color3.fromRGB(255,255,255)
    logBtn.TextXAlignment = Enum.TextXAlignment.Left
    logBtn.Text = disp

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
    if method == "FireServer" or method == "InvokeServer" then
        local argc = select("#", ...)
        local packed = table.pack(...)
        pcall(function()
            addLog(self, packed, argc)
        end)
    end
    return old(self,...)
end
setreadonly(mt,true)
