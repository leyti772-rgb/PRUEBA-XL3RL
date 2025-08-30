--========================================================
-- SERVIDOR SWITCHER DE MULTIPLES INTENTOS
--========================================================
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

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

-- Función para buscar un servidor disponible
local function findServer()
    local PlaceId = game.PlaceId
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

-- Acción del botón (cada click independiente)
Btn.MouseButton1Click:Connect(function()
    -- Cada click lanza su propia búsqueda
    task.spawn(function()
        Btn.Text = "Buscando..."
        local serverId = findServer()

        if serverId then
            Btn.Text = "Teleportando..."
            local success, err = pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, LP)
            end)

            if not success then
                Btn.Text = "Error!"
                warn("Error al teletransportar:", err)
                task.wait(2)
                Btn.Text = "Cambiar Servidor"
            end
        else
            Btn.Text = "No encontrado"
            task.wait(2)
            Btn.Text = "Cambiar Servidor"
        end
    end)
end)
