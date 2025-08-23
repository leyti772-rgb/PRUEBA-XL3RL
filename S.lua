-- 🔎 MiniSpy filtrado para Android (muestra en el chat)
local RS = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local seen = {}

local function notify(msg)
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[MiniSpy] "..msg,
        Color = Color3.fromRGB(0, 255, 200),
        Font = Enum.Font.SourceSansBold,
        FontSize = Enum.FontSize.Size24
    })
end

local function hookRemote(remote)
    if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
        if not seen[remote:GetFullName()] then
            seen[remote:GetFullName()] = true
            notify("Remote detectado: " .. remote:GetFullName())
        end
        if remote:IsA("RemoteEvent") then
            remote.OnClientEvent:Connect(function(...)
                notify("Args en "..remote.Name.." = "..table.concat({...}, ", "))
            end)
        elseif remote:IsA("RemoteFunction") then
            local old = remote.OnClientInvoke
            remote.OnClientInvoke = function(...)
                notify("Function "..remote.Name.." llamada con args")
                return old and old(...)
            end
        end
    end
end

for _,v in ipairs(RS:GetDescendants()) do
    hookRemote(v)
end

RS.DescendantAdded:Connect(function(v)
    hookRemote(v)
end)

notify("✅ MiniSpy filtrado cargado, activa el correr rápido y revisa el chat")
