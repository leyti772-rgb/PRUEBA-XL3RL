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

-- Buscar servidor
local function findServer()
    local PlaceId = game.PlaceId
    local cursor = ""
    local attempts = 0

    while attempts < 20 do
        attempts += 1
        local success, response = pcall(function()
            return req({
                Url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"..(cursor ~= "" and "&cursor="..cursor or "")
            })
        end)

        if not success or not response or not response.Body then
            task.wait(1)
            continue
        end

        local data = HttpService:JSONDecode(response.Body)
        for _,s in ipairs(data.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                return s.id
            end
        end

        if data.nextPageCursor then
            cursor = data.nextPageCursor
        else
            break
        end
        task.wait(0.5)
    end
    return nil
end

-- Acción botón con reintentos automáticos
local isSearching = false
Btn.MouseButton1Click:Connect(function()
    if isSearching then return end
    isSearching = true

    Btn.Text = "Buscando..."
    task.spawn(function()
        local serverId = nil
        local tries = 0

        while not serverId and tries < 20 do
            tries += 1
            serverId = findServer()
            if not serverId then
                Btn.Text = "Reintentando..."
                task.wait(2)
            end
        end

        if serverId then
            Btn.Text = "Teleportando..."
            TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, LP)
        else
            Btn.Text = "No encontrado"
            task.wait(2)
            Btn.Text = "Cambiar Servidor"
        end
        isSearching = false
    end)
end)
