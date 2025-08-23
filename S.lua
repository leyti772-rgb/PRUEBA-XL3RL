-- 🔎 MiniSpy Filtrado – solo muestra remotes únicos
-- Hecho para encontrar el remote del correr rápido sin tanto spam

local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- Guardamos remotes ya vistos para no repetirlos
local seen = {}

-- Función para espiar remotes
local function hookRemote(remote)
    if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
        remote.OnClientEvent:Connect(function(...)
            local args = {...}
            if not seen[remote.Name] then
                seen[remote.Name] = true
                print("📡 [MiniSpy] Remote detectado:", remote:GetFullName())
                print("  → Args:", ...)
            end
        end)
        if remote:IsA("RemoteFunction") then
            local old = remote.OnClientInvoke
            remote.OnClientInvoke = function(...)
                if not seen[remote.Name] then
                    seen[remote.Name] = true
                    print("📡 [MiniSpy] RemoteFunction detectado:", remote:GetFullName())
                    print("  → Args:", ...)
                end
                return old and old(...)
            end
        end
    end
end

-- Escanear todos los remotes existentes
for _,v in ipairs(RS:GetDescendants()) do
    hookRemote(v)
end

-- Detectar si aparecen nuevos remotes en el futuro
RS.DescendantAdded:Connect(function(v)
    hookRemote(v)
end)

print("✅ MiniSpy Filtrado cargado – Activa tu script de correr y revisa la consola (F9)")
