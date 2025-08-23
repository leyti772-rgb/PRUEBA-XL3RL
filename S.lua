-- 📡 MiniSpy Ultra-Light (solo RE/UseItem) – Android friendly
-- Mostrará las llamadas en el chat del juego

local RS = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

-- Remote que queremos espiar
local remote = RS:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE"):WaitForChild("UseItem")

local function notify(msg)
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[MiniSpy] " .. msg,
        Color = Color3.fromRGB(0,255,200),
        Font = Enum.Font.SourceSansBold,
        FontSize = Enum.FontSize.Size24
    })
end

-- Hook del Remote
remote.OnClientEvent:Connect(function(...)
    local args = {...}
    local out = {}
    for i,v in ipairs(args) do
        table.insert(out, tostring(v))
    end
    notify("OnClientEvent → {".. table.concat(out, ", ") .."}")
end)

-- Para RemoteEvent:FireServer
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    if self == remote and getnamecallmethod() == "FireServer" then
        local out = {}
        for i,v in ipairs(args) do
            table.insert(out, tostring(v))
        end
        notify("FireServer → {".. table.concat(out, ", ") .."}")
    end
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

notify("✅ MiniSpy (solo RE/UseItem) activado. Activa el correr rápido y revisa el chat.")
