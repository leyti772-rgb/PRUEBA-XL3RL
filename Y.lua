-- XLSpy v7 (Android Ready)
-- Mejorado para mostrar contenido de tablas (ya no [table])
-- by ChatGPT

if getgenv().XLSpy then
    warn("XLSpy ya está cargado")
    return
end
getgenv().XLSpy = true

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

-- Función para convertir valores a string
local function deepToString(val, depth)
    depth = depth or 0
    local t = typeof(val)
    if t == "string" then
        return '"'..val..'"'
    elseif t == "number" or t == "boolean" then
        return tostring(val)
    elseif t == "Instance" then
        return 'game.'..val:GetFullName()
    elseif t == "table" then
        if depth > 2 then return "{...}" end -- evita loop infinito
        local parts = {}
        for k,v in pairs(val) do
            table.insert(parts, "["..deepToString(k, depth+1).."] = "..deepToString(v, depth+1))
        end
        return "{"..table.concat(parts, ", ").."}"
    else
        return "["..t.."]"
    end
end

-- UI flotante
local ScreenGui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

local FloatBtn = Instance.new("TextButton", ScreenGui)
FloatBtn.Size = UDim2.new(0,50,0,50)
FloatBtn.Position = UDim2.new(0.05,0,0.3,0)
FloatBtn.Text = "👁️"
FloatBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
FloatBtn.TextColor3 = Color3.fromRGB(255,255,255)
FloatBtn.AutoButtonColor = true
FloatBtn.Active = true
FloatBtn.Draggable = true

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,280,0,250)
Main.Position = UDim2.new(0.25,0,0.25,0)
Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Main.Visible = false

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundColor3 = Color3.fromRGB(45,45,45)
Title.Text = "⚡ XLSpy v7 (Android)"
Title.TextColor3 = Color3.fromRGB(0,255,127)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

local Logs = Instance.new("ScrollingFrame", Main)
Logs.Size = UDim2.new(1,0,1,-30)
Logs.Position = UDim2.new(0,0,0,30)
Logs.CanvasSize = UDim2.new(0,0,0,0)
Logs.ScrollBarThickness = 4
Logs.BackgroundTransparency = 1

FloatBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Función para agregar logs
local function addLog(remote, args)
    local logBtn = Instance.new("TextButton", Logs)
    logBtn.Size = UDim2.new(1,-6,0,28)
    logBtn.Position = UDim2.new(0,3,0,#Logs:GetChildren()*28)
    logBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    logBtn.TextColor3 = Color3.fromRGB(255,255,255)
    logBtn.Font = Enum.Font.SourceSans
    logBtn.TextSize = 14
    logBtn.TextXAlignment = Enum.TextXAlignment.Left
    
    local argStrs = {}
    for i,a in ipairs(args) do
        table.insert(argStrs, deepToString(a))
    end
    
    logBtn.Text = remote.Name.." ("..#args.." args)"
    
    logBtn.MouseButton1Click:Connect(function()
        setclipboard(remote:GetFullName()..":FireServer("..table.concat(argStrs,", ")..")")
    end)

    Logs.CanvasSize = UDim2.new(0,0,0, #Logs:GetChildren()*28)
end

-- Hook para detectar remotes
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
