local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

-- request según exploit
local req = http_request or request or (syn and syn.request)

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
Btn.Text = "Cambiar Servidor"
Btn.BackgroundColor3 = Color3.fromRGB(0,170,0)
Btn.TextColor3 = Color3.new(1,1,1)
Btn.Font = Enum.Font.Code
Btn.TextSize = 16

-- Función para encontrar un servidor público diferente
local function findServer()
    local PlaceId = 109983668079237 -- tu juego
    local cursor = ""
    
    local success, response = pcall(function()
        return req({
            Url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        })
    end)

    if not success or not response or not response.Body then
        return nil
    end

    local data = HttpService:JSONDecode(response.Body)
    for _, s in ipairs(data.data) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            return s.id
        end
    end

    return nil
end

-- Cada click ejecuta su intento independiente
Btn.MouseButton1Click:Connect(function()
    task.spawn(function()
        local serverId = findServer()
        if serverId then
            local success, err = pcall(function()
                TeleportService:TeleportToPlaceInstance(109983668079237, serverId, LP)
            end)

            if not success then
                warn("No se pudo cambiar de servidor:", err)
            end
        else
            warn("No se encontró otro servidor disponible.")
        end
    end)
end)
