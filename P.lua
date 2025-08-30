--========================================================
-- SERVIDOR SWITCHER DEFINITIVO (REINTENTOS TELEPORT)
--========================================================
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

-- request según exploit
local req = http_request or request or syn and syn.request

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

-- Buscar y teletransportar
local function trySwitch()
    local PlaceId = game.PlaceId
    local cursor = ""
    local attempts = 0
    local maxAttempts = 20

    while attempts < maxAttempts do
        attempts += 1
        local response = req({
            Url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"..(cursor ~= "" and "&cursor="..cursor or "")
        })
        if not response or not response.Body then return false end
        local data = HttpService:JSONDecode(response.Body)

        for _,s in ipairs(data.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                local success,err = pcall(function()
                    TeleportService:TeleportToPlaceInstance(PlaceId, s.id, LP)
                end)
                if success then
                    return true -- si inicia teleport, salimos
                else
                    warn("Falló teleport, probando otro... ", err)
                end
            end
        end

        if data.nextPageCursor then
            cursor = data.nextPageCursor
        else
            break
        end
    end

    return false
end

-- Acción botón
local isSearching = false
Btn.MouseButton1Click:Connect(function()
    if isSearching then return end
    isSearching = true
    Btn.Text = "Buscando..."
    local ok = trySwitch()
    if not ok then
        Btn.Text = "No encontrado"
        task.wait(2)
        Btn.Text = "Cambiar Servidor"
    end
    isSearching = false
end)
