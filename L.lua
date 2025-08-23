--========================================================
-- XLSpy v4 - Mejorado (Optimizado para Android)
-- UI + Hook universal de RemoteEvent/Function
-- Evita spam (colapsa iguales), botón "Generar" script listo
--========================================================

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")

-- Limpieza previa
pcall(function()
    local g = LP:WaitForChild("PlayerGui"):FindFirstChild("XLSpy_UI")
    if g then g:Destroy() end
end)

--==================== GUI ====================--
local Screen = Instance.new("ScreenGui")
Screen.Name = "XLSpy_UI"
Screen.Parent = LP:WaitForChild("PlayerGui")
Screen.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 280, 0, 220)
Main.Position = UDim2.new(0.5, -140, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Parent = Screen
Main.Active = true
Main.Draggable = true

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Thickness = 2

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 24)
Title.Text = "XLSpy v4"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.BackgroundTransparency = 1
Title.Parent = Main

local LogFrame = Instance.new("ScrollingFrame")
LogFrame.Size = UDim2.new(1, -10, 1, -30)
LogFrame.Position = UDim2.new(0, 5, 0, 26)
LogFrame.CanvasSize = UDim2.new(0,0,0,0)
LogFrame.ScrollBarThickness = 6
LogFrame.BackgroundTransparency = 1
LogFrame.Parent = Main

local Layout = Instance.new("UIListLayout", LogFrame)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 4)

--==================== Logger Función ====================--
local logs = {}

function AddLog(remote, args)
    local key = remote.Name .. ":" .. tostring(#args)

    -- evitar spam de repetidos
    if logs[key] then return end
    logs[key] = true

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -4, 0, 30)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Btn.TextColor3 = Color3.fromRGB(255,255,255)
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 12
    Btn.Text = remote.Name .. " ("..#args.." args)"
    Btn.Parent = LogFrame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,6)

    Btn.MouseButton1Click:Connect(function()
        local ts = {}
        table.insert(ts, ("-- Remote: %s"):format(remote:GetFullName()))
        table.insert(ts, "local args = {")
        for i,v in ipairs(args) do
            local t = typeof(v)
            if t == "Vector3" then
                table.insert(ts, ("    [%d] = Vector3.new(%s,%s,%s),"):format(i,v.X,v.Y,v.Z))
            elseif t == "CFrame" then
                table.insert(ts, ("    [%d] = CFrame.new(%s),"):format(i, table.concat({v:GetComponents()}, ",")))
            elseif t == "Instance" then
                table.insert(ts, ("    [%d] = game:GetService('Workspace'):FindFirstChild(%q),"):format(i,v.Name))
            elseif t == "string" then
                table.insert(ts, ("    [%d] = %q,"):format(i,v))
            else
                table.insert(ts, ("    [%d] = %s,"):format(i,tostring(v)))
            end
        end
        table.insert(ts, "}")
        if remote:IsA("RemoteEvent") then
            table.insert(ts, ("game:GetService('ReplicatedStorage').%s:FireServer(unpack(args))"):format(remote.Name))
        else
            table.insert(ts, ("local result = game:GetService('ReplicatedStorage').%s:InvokeServer(unpack(args))"):format(remote.Name))
            table.insert(ts, "print(result)")
        end

        setclipboard(table.concat(ts,"\n"))
        Btn.Text = "[COPIADO] "..remote.Name
        task.delay(1.5, function() Btn.Text = remote.Name .. " ("..#args.." args)" end)
    end)

    LogFrame.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y+10)
end

--==================== HOOK Remotes ====================--
local oldFire = hookfunction(Instance.new("RemoteEvent").FireServer, function(self,...)
    local args = {...}
    AddLog(self, args)
    return oldFire(self,...)
end)

local oldInvoke = hookfunction(Instance.new("RemoteFunction").InvokeServer, function(self,...)
    local args = {...}
    AddLog(self, args)
    return oldInvoke(self,...)
end)

print("[XLSpy] v4 cargado correctamente!")
