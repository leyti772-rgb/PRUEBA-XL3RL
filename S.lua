--[[ 🔎 XL Advanced MiniSpy (Android Pro)
     • Captura FireServer/InvokeServer por hookfunction + __namecall
     • UI móvil flotante, copiar al tocar, filtros y autolimpieza
]]--

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

-- ====== util entorno seguro ======
local gmtt = getrawmetatable or debug.getmetatable
local sro  = setreadonly or make_writeable or function() end
local hm   = hookmetamethod
local hf   = hookfunction
local gnm  = getnamecallmethod
local ncc  = newcclosure or function(f) return function(...) return f(...) end end

-- limpia anteriores
pcall(function() local g=PG:FindFirstChild("XL_MINISPY_PRO"); if g then g:Destroy() end end)

-- ====== helpers ======
local function r(n) return tonumber(("%.4f"):format(n)) end

local svcNames = {
  Workspace="Workspace", ReplicatedStorage="ReplicatedStorage", Players="Players",
  StarterGui="StarterGui", Lighting="Lighting", SoundService="SoundService", HttpService="HttpService"
}

local function pathOf(inst)
  if not inst or not inst.Parent then return "nil" end
  local chain = {}
  local cur = inst
  while cur and cur~=game do table.insert(chain,1,cur); cur=cur.Parent end
  local head = chain[1] and chain[1].Name or "Workspace"
  local base = ('game:GetService("%s")'):format(svcNames[head] or head)
  for i=2,#chain do
    local nm = chain[i].Name
    if nm:match("[^%w_]") then base = base..(':WaitForChild(%q)'):format(nm) else base = base.."."..nm end
  end
  return base
end

local function serialize(v, depth, seen)
  depth=depth or 0; seen=seen or {}
  if depth>2 then return '"<max depth>"' end
  local t = typeof(v)
  if t=="string" then
    if #v>160 then v=v:sub(1,160).."...(+"..(#v-160)..")" end
    return ("%q"):format(v)
  elseif t=="number" or t=="boolean" or v==nil then
    return tostring(v)
  elseif t=="Vector3" then
    return ("Vector3.new(%s,%s,%s)"):format(r(v.X),r(v.Y),r(v.Z))
  elseif t=="CFrame" then
    local c={v:components()} for i=1,#c do c[i]=r(c[i]) end
    return "CFrame.new("..table.concat(c,",")..")"
  elseif t=="Instance" then
    return pathOf(v)
  elseif t=="table" then
    if seen[v] then return '"<cycle>"' end
    seen[v]=true
    local items={}
    local isArray=true; local i=1
    for k,_ in pairs(v) do if k~=i then isArray=false break end i=i+1 end
    if isArray then
      for j=1,#v do table.insert(items, serialize(v[j], depth+1, seen)) end
      return "{"..table.concat(items,", ").."}"
    else
      for k,val in pairs(v) do
        local kk=(type(k)=="string" and k:match("^%a[%w_]*$")) and k or "["..serialize(k, depth+1, seen).."]"
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
  local argStrs={} for i=1,#args do argStrs[i]=serialize(args[i]) end
  local luaArgs = #argStrs>0 and ("{\n    "..table.concat(argStrs,",\n    ").."\n}") or "{}"
  local call = ("%s:%s(%s)"):format(pathOf(remote), method, (#argStrs>0 and "unpack(args)" or ""))
  return ("-- MiniSpy Pro capture\nlocal args = %s\n%s"):format(luaArgs, call)
end

-- ====== UI ======
local gui=Instance.new("ScreenGui")
gui.Name="XL_MINISPY_PRO"; gui.ResetOnSpawn=false; gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
gui.Parent=PG

local icon=Instance.new("Frame")
icon.Size=UDim2.new(0,56,0,56); icon.Position=UDim2.new(0.11,0,0.24,0)
icon.BackgroundColor3=Color3.fromRGB(30,30,30); icon.Active=true; icon.Draggable=true; icon.Parent=gui
Instance.new("UICorner",icon).CornerRadius=UDim.new(1,0)
local st=Instance.new("UIStroke",icon); st.Thickness=2; st.Color=Color3.fromRGB(0,255,170)
local ib=Instance.new("TextButton",icon)
ib.BackgroundTransparency=1; ib.Size=UDim2.fromScale(1,1); ib.Font=Enum.Font.GothamBlack; ib.Text="SPY+"; ib.TextSize=21; ib.TextColor3=Color3.new(1,1,1)

local panel=Instance.new("Frame")
panel.Size=UDim2.new(0,362,0,246); panel.Position=UDim2.new(0.5,-181,0.62,-123)
panel.BackgroundColor3=Color3.fromRGB(22,22,22); panel.Visible=false; panel.Active=true; panel.Draggable=true; panel.Parent=gui
Instance.new("UICorner",panel).CornerRadius=UDim.new(0,14)
local pst=Instance.new("UIStroke",panel); pst.Color=Color3.fromRGB(0,255,170); pst.Thickness=2

local top=Instance.new("Frame",panel) top.BackgroundTransparency=1; top.Size=UDim2.new(1,-16,0,32); top.Position=UDim2.new(0,8,0,8)
local title=Instance.new("TextLabel",top)
title.BackgroundTransparency=1; title.Size=UDim2.new(1,0,1,0)
title.Font=Enum.Font.GothamBold; title.TextSize=16; title.TextColor3=Color3.fromRGB(0,255,200)
title.Text="XL MiniSpy Pro (Android)"

local btnOn=Instance.new("TextButton",panel)
btnOn.Size=UDim2.new(0.33,-12,0,28); btnOn.Position=UDim2.new(0,8,0,42)
btnOn.Font=Enum.Font.GothamBold; btnOn.TextSize=14; btnOn.TextColor3=Color3.new(1,1,1); btnOn.AutoButtonColor=false
btnOn.BackgroundColor3=Color3.fromRGB(0,160,0); btnOn.Text="CAPTURAR: ON"; Instance.new("UICorner",btnOn).CornerRadius=UDim.new(0,10)

local btnMute=Instance.new("TextButton",panel)
btnMute.Size=UDim2.new(0.33,-8,0,28); btnMute.Position=UDim2.new(0.33,0,0,42)
btnMute.Font=Enum.Font.GothamBold; btnMute.TextSize=14; btnMute.TextColor3=Color3.new(1,1,1); btnMute.AutoButtonColor=false
btnMute.BackgroundColor3=Color3.fromRGB(45,45,45); btnMute.Text="MUTED: Cooldown ✓"; Instance.new("UICorner",btnMute).CornerRadius=UDim.new(0,10)

local btnClear=Instance.new("TextButton",panel)
btnClear.Size=UDim2.new(0.34,-12,0,28); btnClear.Position=UDim2.new(0.66,0,0,42)
btnClear.Font=Enum.Font.GothamBold; btnClear.TextSize=14; btnClear.TextColor3=Color3.new(1,1,1); btnClear.AutoButtonColor=false
btnClear.BackgroundColor3=Color3.fromRGB(80,20,20); btnClear.Text="LIMPIAR"; Instance.new("UICorner",btnClear).CornerRadius=UDim.new(0,10)

local list=Instance.new("ScrollingFrame",panel)
list.BackgroundColor3=Color3.fromRGB(15,15,15); list.Position=UDim2.new(0,8,0,78)
list.Size=UDim2.new(1,-16,1,-86); list.ScrollBarThickness=6; list.CanvasSize=UDim2.new(0,0,0,0)
Instance.new("UICorner",list).CornerRadius=UDim.new(0,10)
local layout=Instance.new("UIListLayout",list) layout.Padding=UDim.new(0,6); layout.SortOrder=Enum.SortOrder.LayoutOrder
local pad=Instance.new("UIPadding",list) pad.PaddingTop=UDim.new(0,8); pad.PaddingLeft=UDim.new(0,8); pad.PaddingRight=UDim.new(0,8); pad.PaddingBottom=UDim.new(0,8)
local function refresh() list.CanvasSize=UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+16) end
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(refresh)

ib.MouseButton1Click:Connect(function() panel.Visible=not panel.Visible end)

local capturing=true; local muteCooldown=true
btnOn.MouseButton1Click:Connect(function()
  capturing=not capturing
  btnOn.Text=capturing and "CAPTURAR: ON" or "CAPTURAR: OFF"
  btnOn.BackgroundColor3=capturing and Color3.fromRGB(0,160,0) or Color3.fromRGB(170,20,20)
end)
btnMute.MouseButton1Click:Connect(function()
  muteCooldown=not muteCooldown
  btnMute.Text=muteCooldown and "MUTED: Cooldown ✓" or "MUTED: Cooldown ✗"
end)
btnClear.MouseButton1Click:Connect(function()
  for _,c in ipairs(list:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
  refresh()
end)

-- ====== logger ======
local MAX_LOGS = 150
local logCount = 0
local function clampLogs()
  while logCount>MAX_LOGS do
    for _,c in ipairs(list:GetChildren()) do
      if c:IsA("Frame") then c:Destroy(); logCount=logCount-1; break end
    end
  end
end

local function addLog(remote, method, args)
  if not capturing then return end
  if not remote or not remote.Parent then return end
  local fullname = remote:GetFullName()
  if muteCooldown and fullname:find("RE/Tools/Cooldown") then return end

  local row=Instance.new("Frame")
  row.BackgroundColor3=Color3.fromRGB(28,28,28); row.Size=UDim2.new(1,0,0,0)
  Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)

  local txt=("[%s] %s  (%d arg%s)"):format(method, fullname, #args, #args==1 and "" or "s")
  local label=Instance.new("TextLabel",row)
  label.BackgroundTransparency=1; label.TextWrapped=true; label.TextXAlignment=Enum.TextXAlignment.Left
  label.Font=Enum.Font.Code; label.TextSize=14; label.TextColor3=Color3.fromRGB(230,230,230)
  label.Text=txt; label.Size=UDim2.new(1,-12,1,-10); label.Position=UDim2.new(0,6,0,5)

  row.Parent=list
  row.Size = UDim2.new(1,0,0, math.clamp(label.TextBounds.Y+12, 28, 110))
  logCount += 1; clampLogs(); refresh()

  local snippet = buildSnippet(remote, method, args)
  row.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseButton1 then
      pcall(function() if setclipboard then setclipboard(snippet) end end)
      label.TextColor3=Color3.fromRGB(0,255,170); task.delay(0.6,function() label.TextColor3=Color3.fromRGB(230,230,230) end)
    end
  end)
end

-- ====== HOOKS ======
-- 1) Hook directo a métodos (suele funcionar incluso si __namecall está protegido)
pcall(function()
  if hf then
    local dummyRE = Instance.new("RemoteEvent")
    local dummyRF = Instance.new("RemoteFunction")

    local oldFS, oldIV
    oldFS = hf(dummyRE.FireServer, ncc(function(self, ...)
      local a={...}; addLog(self, "FireServer", a)
      return oldFS(self, ...)
    end))
    oldIV = hf(dummyRF.InvokeServer, ncc(function(self, ...)
      local a={...}; addLog(self, "InvokeServer", a)
      return oldIV(self, ...)
    end))

    dummyRE:Destroy(); dummyRF:Destroy()
  end
end)

-- 2) Hook a __namecall (por si el ejecutor lo permite)
pcall(function()
  if hm then
    local old = hm(game, "__namecall", ncc(function(self, ...)
      local method = gnm and gnm() or ""
      if (method=="FireServer" or method=="InvokeServer") then
        addLog(self, method, {...})
      end
      return old(self, ...)
    end))
  else
    local mt = gmtt and gmtt(game)
    if mt and mt.__namecall then
      local old = mt.__namecall
      sro(mt,false)
      mt.__namecall = ncc(function(self, ...)
        local method = gnm and gnm() or ""
        if (method=="FireServer" or method=="InvokeServer") then
          addLog(self, method, {...})
        end
        return old(self, ...)
      end)
      sro(mt,true)
    end
  end
end)

-- Mensaje de ayuda
do
  local tip=Instance.new("TextLabel",panel)
  tip.BackgroundTransparency=1; tip.Size=UDim2.new(1,-16,0,18); tip.Position=UDim2.new(0,8,1,-22)
  tip.Font=Enum.Font.Gotham; tip.TextSize=12; tip.TextColor3=Color3.fromRGB(170,255,200)
  tip.Text="Activa tu script; aquí saldrán los FireServer/InvokeServer. Toca para copiar."
  task.delay(7,function() if tip then tip:Destroy() end end)
end
