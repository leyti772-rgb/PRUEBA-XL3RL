-- Script: Cambiar de servidor público
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local PlaceId = game.PlaceId

-- Función para buscar servidores públicos disponibles
local function getServers(cursor)
    local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    if cursor then url = url .. "&cursor=" .. cursor end

    local success, response = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)

    if success and response and response.data then
        return response
    end
    return nil
end

-- Teleportar a un nuevo servidor
local function teleportToNewServer()
    local cursor = nil
    local tried = {}
    while true do
        local servers = getServers(cursor)
        if not servers then break end

        for _, server in ipairs(servers.data) do
            if server.playing < server.maxPlayers and not tried[server.id] then
                tried[server.id] = true
                TeleportService:TeleportToPlaceInstance(PlaceId, server.id, Players.LocalPlayer)
                return
            end
        end

        if servers.nextPageCursor then
            cursor = servers.nextPageCursor
        else
            break
        end
    end
    warn("No se encontró un servidor distinto.")
end

-- Botón de ejemplo
local ScreenGui = Instance.new("ScreenGui", Players.LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false
local Button = Instance.new("TextButton", ScreenGui)
Button.Size = UDim2.new(0, 200, 0, 50)
Button.Position = UDim2.new(0.5, -100, 0.8, 0)
Button.Text = "Cambiar de Servidor"

Button.MouseButton1Click:Connect(teleportToNewServer)
