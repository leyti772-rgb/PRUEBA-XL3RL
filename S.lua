--[[  🔎 XL MiniSpy (Android) – captura FireServer/InvokeServer
      • UI flotante: botón “SPY” (arrastrable) abre/cierra logs
      • Mutea spam: "RE/Tools/Cooldown" (puedes desmutear)
      • Toca un log para copiar el script (pcall setclipboard)
      • No usa F9 ni Chat; todo va a un ScrollingFrame
]]--

local Players=game:GetService("Players")
local LP=Players.LocalPlayer
local PG=LP:WaitForChild("PlayerGui")

-- Limpia instancias previas
pcall(function() local g=PG:FindFirstChild("XL_MINISPY"); if g then g:Destroy() end end)

-- ======== helpers ========
local function round(n) return tonumber(("%.4f"):format(n)) end

local function instancePath(inst)
    local chain={}
    local cur=inst
    while cur and cur~=game do
        table.insert(chain,1,cur)
        cur=cur.Parent
    end
    if #chain==0 then return "nil" end
    local top=chain[1]
    local svcName = top.Name
    local known = {
        Workspace="Workspace", ReplicatedStorage="ReplicatedStorage",
        Players="Players", StarterGui="StarterGui", Lighting="Lighting",
        StarterPlayer="StarterPlayer", SoundService="SoundService"
    }
    local head = known[svcName] and ('game:GetService("%s")'):format(known[svcName]) or ('game:GetService("%s")'):format(svcName)
    local path=head
    for i=2,#chain do
        local name=chain[i].Name
        if name:match("[^%w_]") then
            path=path..(':WaitForChild(%q)'):format(name)
        else
            path=path..("."..name)
        end
    end
    return path
end

local function serialize(v, depth, seen)
    depth=depth or 0; seen=seen or {}
    if depth>2 then return '"<max depth>"' end
    local t=typeof(v)
    if t=="string" then
        if #v>120 then v=v:sub(1,120).."...(+"..(#v-120)..")" end
        return string.format("%q",v)
    elseif t=="number" or t=="boolean" or v==nil then
        return tostring(v)
    elseif t=="Vector3" then
        return ("Vector3.new(%s,%s,%s)"):format(round(v.X),round(v.Y),round(v.Z))
    elseif t=="CFrame" then
        local comp={v:components()}
        for i=1,#comp do comp[i]=round(comp[i]) end
        return "CFrame.new("..table.concat(comp,",")..")"
    elseif t=="Instance" then
        return instancePath(v)
    elseif t=="table" then
        if seen[v] then return '"<cycle>"' end
        seen[v]=true
        local items={}
        local isArray=true; local idx=1
        for k,_ in pairs(v) do if k~=idx then isArray=false break end idx=idx+1 end
        if isArray then
            for i=1,#v do table.insert(items, serialize(v[i], depth+1, seen)) end
            return "{"..table.concat(items,", ").."}"
        else
            for k,val in pairs(v) do
                local kk = (type(k)=="string" and k:match("^%a[%w_]*$")) and k or ("["..serialize(k, depth+1, seen).."]")
                table.insert(items, kk.."="..serialize(val, depth+1, seen))
            end
            table.sort(items)
            return "{"..table.concat(items,", ").."}"
        end
    else
        return ('"<%s>"'):format(t)
    end
end

local function buildSnippet(remote, method, args)
    local argStrs={}
    for i=1,#args do argStrs[i]=serialize(args[i]) end
    local luaArgs = #argStrs>0 and ("{\n    "..table.concat(argStrs,",\n    ").."\n}") or "{}"
    local path = instancePath(remote)
    local call = ("%s:%s(%s)"):format(path, method, (#argStrs>0 and "unpack(args)" or ""))
    return ("-- MiniSpy capture\nlocal args = %s\n%s"):format(luaArgs, call)
end

-- ======== UI ========
local gui=Instance.new("ScreenGui")
gui.Name="XL_MINISPY"; gui.ResetOnSpawn=false; gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
gui.Parent=PG

local icon=Instance.new("Frame")
icon.Size=UDim2.new(0,58,0,58)
icon.Position=UDim2.new(0.12,0,0.22,0)
icon.BackgroundColor3=Color3.fromRGB(30,30,30)
icon.Active=true; icon.Draggable=true
icon.Parent=gui
Instance.new("UICorner",icon).CornerRadius=UDim.new(1,0)
local st=Instance.new("UIStroke",icon); st.Thickness=2; st.Color=Color3.fromRGB(0,255,170)
local ib=Instance.new("TextButton",icon)
ib.BackgroundTransparency=1; ib.Size=UDim2.fromScale(1,1)
ib.Font=Enum.Font.GothamBlack; ib.Text="SPY"; ib.TextSize=22; ib.TextColor3=Color3.new(1,1,1)

local panel=Instance.new("Frame")
panel.Size=UDim2.new(0,360,0,240)
panel.Position=UDim2.new(0.5,-180,0.6,-120)
panel.BackgroundColor3=Color3.fromRGB(22,22,22)
panel.Visible=false; panel.Active=true; panel.Draggable=true; panel.Parent=gui
local pc=Instance.new("UICorner",panel); pc.CornerRadius=UDim.new(0,14)
local pst=Instance.new("UIStroke",panel); pst.Color=Color3.fromRGB(0,255,170); pst.Thickness=2

local top=Instance.new("Frame",panel)
top.BackgroundTransparency=1; top.Size=UDim2.new(1, -16, 0, 34); top.Position=UDim2.new(0,8,0,8)
local title=Instance.new("TextLabel",top)
title.BackgroundTransparency=1; title.Size=UDim2.new(1,0,1,0)
title.Font=Enum.Font.GothamBold; title.Text="XL MiniSpy (Android)"; title.TextSize=16; title.TextColor3=Color3.fromRGB(0,255,200)

local btnOn=Instance.new("TextButton",panel)
btnOn.Size=UDim2.new(0.33,-12,0,30); btnOn.Position=UDim2.new(0,8,0,46)
btnOn.Font=Enum.Font.GothamBold; btnOn.TextSize=14; btnOn.TextColor3=Color3.new(1,1,1); btnOn.AutoButtonColor=false
btnOn.BackgroundColor3=Color3.fromRGB(0,160,0); btnOn.Text="CAPTURAR: ON"
Instance.new("UICorner",btnOn).CornerRadius=UDim.new(0,10)

local btnMute=Instance.new("TextButton",panel)
btnMute.Size=UDim2.new(0.33,-8,0,30); btnMute.Position=UDim2.new(0.33,0,0,46)
btnMute.Font=Enum.Font.GothamBold; btnMute.TextSize=14; btnMute.TextColor3=Color3.new(1,1,1); btnMute.AutoButtonColor=false
btnMute.BackgroundColor3=Color3.fromRGB(45,45,45); btnMute.Text="MUTED: Cooldown ✓"
Instance.new("UICorner",btnMute).CornerRadius=UDim.new(0,10)

local btnClear=Instance.new("TextButton",panel)
btnClear.Size=UDim2.new(0.34,-12,0,30); btnClear.Position=UDim2.new(0.66,0,0,46)
btnClear.Font=Enum.Font.GothamBold; btnClear.TextSize=14; btnClear.TextColor3=Color3.new(1,1,1); btnClear.AutoButtonColor=false
btnClear.BackgroundColor3=Color3.fromRGB(80,20,20); btnClear.Text="LIMPIAR"
Instance.new("UICorner",btnClear).CornerRadius=UDim.new(0,10)

local list=Instance.new("ScrollingFrame",panel)
list.BackgroundColor3=Color3.fromRGB(15,15,15); list.Position=UDim2.new(0,8,0,84)
list.Size=UDim2.new(1,-16,1,-92); list.ScrollBarThickness=6; list.CanvasSize=UDim2.new(0,0,0,0)
Instance.new("UICorner",list).CornerRadius=UDim.new(0,10)
local layout=Instance.new("UIListLayout",list); layout.Padding=UDim.new(0,6); layout.SortOrder=Enum.SortOrder.LayoutOrder
local pad=Instance.new("UIPadding",list); pad.PaddingTop=UDim.new(0,8); pad.PaddingLeft=UDim.new(0,8); pad.PaddingRight=UDim.new(0,8); pad.PaddingBottom=UDim.new(0,8)

local capturing=true
local muteCooldown=true
local function refreshCanvas() list.CanvasSize=UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+16) end
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refreshCanvas)

ib.MouseButton1Click:Connect(function() panel.Visible=not panel.Visible end)
btnOn.MouseButton1Click:Connect(function()
    capturing=not capturing
    btnOn.Text = capturing and "CAPTURAR: ON" or "CAPTURAR: OFF"
    btnOn.BackgroundColor3 = capturing and Color3.fromRGB(0,160,0) or Color3.fromRGB(170,20,20)
end)
btnMute.MouseButton1Click:Connect(function()
    muteCooldown=not muteCooldown
    btnMute.Text = muteCooldown and "MUTED: Cooldown ✓" or "MUTED: Cooldown ✗"
end)
btnClear.MouseButton1Click:Connect(function() for _,c in ipairs(list:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end; refreshCanvas() end)

local function addLog(remote, method, args)
    if not panel then return end
    local name = remote.Name
    if muteCooldown and tostring(name):find("RE/Tools/Cooldown") then return end

    local row=Instance.new("Frame")
    row.BackgroundColor3=Color3.fromRGB(28,28,28); row.Size=UDim2.new(1,0,0,0)
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)
    local lbl=Instance.new("TextLabel",row)
    lbl.BackgroundTransparency=1; lbl.TextWrapped=true; lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.Font=Enum.Font.Code; lbl.TextSize=14; lbl.TextColor3=Color3.fromRGB(230,230,230)
    lbl.Size=UDim2.new(1,-12,1,-10); lbl.Position=UDim2.new(0,6,0,5)

    local pathShort = instancePath(remote):gsub("game:GetService%(",""):gsub("%)",""):gsub(":WaitForChild",""):gsub('"%w+"','')
    local snippet = buildSnippet(remote, method, args)
    lbl.Text = string.format("[%s] %s  (%d arg%s)", method, remote:GetFullName(), #args, #args==1 and "" or "s")
    row.Parent=list
    row.Size = UDim2.new(1,0,0, math.clamp(lbl.TextBounds.Y+12, 28, 120))

    -- copiar al tocar
    local copied=false
    row.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseButton1 then
            copied=true
            pcall(function() if setclipboard then setclipboard(snippet) end end)
            lbl.TextColor3 = Color3.fromRGB(0,255,170)
            task.delay(0.6, function() if copied then lbl.TextColor3 = Color3.fromRGB(230,230,230) end end)
        end
    end)
end

-- ======== hook __namecall (salientes) ========
local ok, mt = pcall(getrawmetatable, game)
if not ok or not mt then
    -- fallback simple: nada que hacer
else
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if capturing and (method=="FireServer" or method=="InvokeServer") then
            local args = {...}
            -- log
            addLog(self, method, args)
        end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end

-- mensaje inicial
do
    local bl=Instance.new("TextLabel",panel)
    bl.BackgroundTransparency=1; bl.Size=UDim2.new(1,-16,0,18); bl.Position=UDim2.new(0,8,1,-22)
    bl.Font=Enum.Font.Gotham; bl.TextSize=12; bl.TextColor3=Color3.fromRGB(170,255,200)
    bl.Text="Carga tu script de correr/gancho y mira aquí. Toca un log para copiar el snippet."
    task.delay(6,function() if bl then bl:Destroy() end end)
end
