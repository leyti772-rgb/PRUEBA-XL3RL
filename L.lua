--[[ SCRIPT: XL3RL HUB - FUSIÓN FINAL (con AUTO-WEB exclusión mutua) AUTOR: Gemini + ChatGPT CAMBIOS: * Auto-Laser y Auto-Web se desactivan mutuamente al activarse uno. * Mantiene diseño original, NO-CLIP, COMBO SCRIPTS y CAMBIAR SERVIDOR. ]]

-- Servicios y jugador local Players = game:GetService("Players") local RunService = game:GetService("RunService") local UserInputService = game:GetService("UserInputService") local ReplicatedStorage = game:GetService("ReplicatedStorage") local LP = Players.LocalPlayer

-- Config local Config = { MainColor = Color3.fromRGB(0, 255, 150), BackgroundColor = Color3.fromRGB(25, 27, 35), MutedColor = Color3.fromRGB(40, 42, 50), TextColor = Color3.fromRGB(255, 255, 255), Keybind = Enum.KeyCode.RightShift }

local function make(className, props, parent) local i = Instance.new(className) for k,v in pairs(props or {}) do i[k] = v end if parent then i.Parent = parent end return i end

local function makeDraggable(frame, trigger) local dragging, dragStart, startPos trigger.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = input.Position startPos = frame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end) UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end) end

-- GUI Base pcall(function() if LP.PlayerGui:FindFirstChild("XL3RL_FUSION_GUI") then LP.PlayerGui.XL3RL_FUSION_GUI:Destroy() end end) local Screen = make("ScreenGui", {Name="XL3RL_FUSION_GUI", ResetOnSpawn=false}, LP:WaitForChild("PlayerGui"))

local FloatIcon = make("ImageButton", { Size = UDim2.new(0,50,0,50), Position = UDim2.new(0,20,0.5,-25), BackgroundColor3 = Config.BackgroundColor, BackgroundTransparency=0.2, Image="rbxassetid://6034849723", ImageColor3=Config.MainColor }, Screen) make("UICorner",{CornerRadius=UDim.new(1,0)},FloatIcon) make("UIStroke",{Color=Config.MainColor},FloatIcon)

local Main = make("Frame", { Size = UDim2.new(0,160,0,200), Position = UDim2.new(0.5,-80,0.5,-100), BackgroundColor3=Config.BackgroundColor, Visible=false }, Screen) make("UICorner",{CornerRadius=UDim.new(0,8)},Main) make("UIStroke",{Thickness=2, Color=Config.MainColor},Main)

local MainContent = make("Frame",{Size=UDim2.fromScale(1,1), BackgroundTransparency=1},Main) make("UIPadding",{PaddingTop=UDim.new(0,8), PaddingBottom=UDim.new(0,8), PaddingLeft=UDim.new(0,10), PaddingRight=UDim.new(0,10)},MainContent) make("UIListLayout",{Padding=UDim.new(0,8), SortOrder=Enum.SortOrder.LayoutOrder},MainContent)

local Title = make("TextLabel",{ Size=UDim2.new(1,0,0,24), Text="XL3RL FUSIÓN", Font=Enum.Font.Code, TextSize=16, TextColor3=Config.MainColor, BackgroundTransparency=1 },MainContent)

-- Paneles local NCPanel = make("Frame",{Size=UDim2.new(0,160,0,100), Visible=false, BackgroundColor3=Config.BackgroundColor},Screen) make("UICorner",{CornerRadius=UDim.new(0,8)},NCPanel) make("UIStroke",{Color=Config.MainColor},NCPanel) local ncTitle = make("TextLabel",{Size=UDim2.new(1,0,0,30), Text="NO-CLIP", Font=Enum.Font.Code, TextSize=16, TextColor3=Config.MainColor, BackgroundTransparency=1},NCPanel) local ncButton = make("TextButton",{Size=UDim2.new(1,-20,0,40), Position=UDim2.new(0,10,0,40), Text="ACTIVAR", BackgroundColor3=Color3.fromRGB(0,160,0), TextColor3=Config.TextColor},NCPanel) make("UICorner",{CornerRadius=UDim.new(0,6)},ncButton)

local LaserPanel = make("Frame",{Size=UDim2.new(0,160,0,100),Position = UDim2.new(1, -180, 0, 20), Visible=false, BackgroundColor3=Config.BackgroundColor},Screen) make("UICorner",{CornerRadius=UDim.new(0,8)},LaserPanel) make("UIStroke",{Color=Config.MainColor},LaserPanel) local laserTitle = make("TextLabel",{Size=UDim2.new(1,0,0,30), Text="AUTO-LASER", Font=Enum.Font.Code, TextSize=16, TextColor3=Config.MainColor, BackgroundTransparency=1},LaserPanel) local laserButton = make("TextButton",{Size=UDim2.new(1,-20,0,40), Position=UDim2.new(0,10,0,40), Text="ACTIVAR", BackgroundColor3=Color3.fromRGB(0,160,0), TextColor3=Config.TextColor},LaserPanel) make("UICorner",{CornerRadius=UDim.new(0,6)},laserButton)

local WebPanel = make("Frame",{Size=UDim2.new(0,160,0,100),Position = UDim2.new(1, -180, 0, 140), Visible=false, BackgroundColor3=Config.BackgroundColor},Screen) make("UICorner",{CornerRadius=UDim.new(0,8)},WebPanel) make("UIStroke",{Color=Config.MainColor},WebPanel) local webTitle = make("TextLabel",{Size=UDim2.new(1,0,0,30), Text="AUTO-WEB", Font=Enum.Font.Code, TextSize=16, TextColor3=Config.MainColor, BackgroundTransparency=1},WebPanel) local webButton = make("TextButton",{Size=UDim2.new(1,-20,0,40), Position=UDim2.new(0,10,0,40), Text="ACTIVAR", BackgroundColor3=Color3.fromRGB(0,160,0), TextColor3=Config.TextColor},WebPanel) make("UICorner",{CornerRadius=UDim.new(0,6)},webButton)

-- Funciones local noClip=false; local conn ncButton.MouseButton1Click:Connect(function() noClip=not noClip if noClip then conn=RunService.Stepped:Connect(function() if LP.Character then for _,p in ipairs(LP.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end end) ncButton.Text, ncButton.BackgroundColor3="DESACTIVAR",Color3.fromRGB(170,20,20) else if conn then conn:Disconnect() conn=nil end ncButton.Text, ncButton.BackgroundColor3="ACTIVAR",Color3.fromRGB(0,160,0) end end)

-- Auto-Laser local LaserRemote = ReplicatedStorage:FindFirstChild("RE/UseItem",true) local BuyRF = ReplicatedStorage:FindFirstChild("RF/CoinsShopService/RequestBuy",true) local autoLaser=false; local laserLoop local autoWeb=false; local webLoop

-- Funciones auxiliares para herramientas (Laser y Web) local function getLaserTool() if LP.Backpack then for _,t in ipairs(LP.Backpack:GetChildren()) do if t:IsA("Tool") and t.Name=="Laser Cape" then return t end end end if LP.Character then for _,t in ipairs(LP.Character:GetChildren()) do if t:IsA("Tool") and t.Name=="Laser Cape" then return t end end end return nil end local function equipLaserCape() local t=getLaserTool() if t then t.Parent=

