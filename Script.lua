local Players, RunService, TweenService, UserInputService,
      ReplicatedStorage, GuiService, TeleportService, VirtualUser, Lighting
Players           = game:GetService("Players")
RunService        = game:GetService("RunService")
TweenService      = game:GetService("TweenService")
UserInputService  = game:GetService("UserInputService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
GuiService        = game:GetService("GuiService")
TeleportService   = game:GetService("TeleportService")
VirtualUser       = game:GetService("VirtualUser")
Lighting          = game:GetService("Lighting")
local origLight         = { Lighting.Brightness, Lighting.ClockTime, Lighting.FogEnd, Lighting.GlobalShadows, Lighting.OutdoorAmbient }
local sendWebhook, _searchServers
;(function()
local WEBHOOK_URL      = "https://webhooksqw.mohammadahmadqazplm.workers.dev"
local _webhookReady    = true
local _httpReq = (typeof(request)        == "function" and request)
              or (typeof(http_request)   == "function" and http_request)
              or (typeof(http)           == "table" and typeof(http.request)   == "function" and http.request)
              or (typeof(syn)            == "table" and typeof(syn.request)    == "function" and syn.request)
              or (typeof(fluxus)         == "table" and typeof(fluxus.request) == "function" and fluxus.request)
              or nil
local function getServerLink()
    local pid = tostring(game.PlaceId)
    local jid = tostring(game.JobId)
    return "https://www.roblox.com/games/start?placeId=" .. pid
        .. "&gameInstanceId=" .. jid
        .. "&startPlaceId="   .. pid
end
local function getMobileDeepLink()
    local pid = tostring(game.PlaceId)
    local jid = tostring(game.JobId)
    return "roblox://experiences/start?placeId=" .. pid .. "&gameInstanceId=" .. jid
end
local function getServerPlayerCount()
    local ok, n = pcall(function() return #game:GetService("Players"):GetPlayers() end)
    return (ok and type(n) == "number") and n or 0
end
local _webhookSent, _webhookHistory = {}, {}
local ROLE_PINGS = {
    { key = "celest", id = "1484573463598469242" },
    { key = "godly",  id = "1484573408443236472" },
    { key = "volcan", id = "1484575858529403112" },
    { key = "frenzy", id = "1484573786505482260" },
    { key = "storm",  id = "1484573285671764139" },
    { key = "slime",  id = "1484573205317292042" },
    { key = "moon",   id = "1484573650697850890" },
    { key = "king",   id = "1484573892994531420" },
    { key = "coin",   id = "1484573143656955904" },
    { key = "luck",   id = "1484573521936912485" },
    { key = "x2",     id = "1484573521936912485" },
}
local function _getRoleId(title, tbl)
    local t = title:lower()
    for _, entry in ipairs(tbl or ROLE_PINGS) do
        if t:find(entry.key, 1, true) then return entry.id end
    end
    return nil
end
local function getWebhookCategory(title)
    local t = title:lower()
    if t:find("coin")       then return "Coin"
    elseif t:find("godly")  then return "Godly"
    elseif t:find("celest") then return "Celestial"
    else return "Event" end
end
local function buildOxyoEmbed(title, description, color)
    local serverLink  = getServerLink()
    local deepLink    = getMobileDeepLink()
    local playerCount = getServerPlayerCount()
    local maxPlayers  = game:GetService("Players").MaxPlayers
    local capturedAt  = os.date("%H:%M:%S UTC")
    local dateStr     = os.date("%Y-%m-%d")
    local jobShort    = tostring(game.JobId):sub(1, 8)
    local filled = math.floor((playerCount / math.max(maxPlayers, 1)) * 10)
    local bar    = string.rep("█", filled) .. string.rep("░", 10 - filled)
    local icon = "⚡"
    local t = title:lower()
    if     t:find("godly")  then icon = "👑"
    elseif t:find("celest") then icon = "🌌"
    elseif t:find("coin")   then icon = "🪙"
    elseif t:find("event")  then icon = "🎯"
    elseif t:find("rain")   then icon = "🌧️"
    elseif t:find("patric") then icon = "🍀"
    elseif t:find("volcan") then icon = "🌋"
    elseif t:find("aqua")   then icon = "🌊"
    elseif t:find("dream")  then icon = "💜"
    end
    local roleId = _getRoleId(title)
    local pingContent = roleId and ("<@&" .. roleId .. ">") or nil
    return {
        username         = "OXYO HUB",
        avatar_url       = "https://www.roblox.com/headshot-thumbnail/image?userId=1&width=420&height=420&format=png",
        content          = pingContent,
        allowed_mentions = roleId and { roles = { roleId } } or { parse = {} },
        embeds = {{
            color       = color or 0x7B2FBE,
            author      = {
                name     = icon .. "  " .. title .. "  " .. icon,
                icon_url = "https://www.roblox.com/headshot-thumbnail/image?userId=1&width=420&height=420&format=png",
            },
            description = "```ansi\n\27[1;35m" .. (description or "") .. "\27[0m\n```",
            fields = {
                {
                    name   = "╔══ 🖥️  JOIN — PC / WEB",
                    value  = "╚══▶  [**Click here to teleport**](" .. serverLink .. ")",
                    inline = false,
                },
                {
                    name   = "╔══ 📱  JOIN — MOBILE  (long-press & copy)",
                    value  = "`" .. deepLink .. "`",
                    inline = false,
                },
                {
                    name   = "👥  Players",
                    value  = "`" .. bar .. "`\n**" .. playerCount .. " / " .. maxPlayers .. "**",
                    inline = true,
                },
                {
                    name   = "🌐  Server",
                    value  = "```" .. jobShort .. "...```",
                    inline = true,
                },
                {
                    name   = "⏱️  Captured",
                    value  = "**" .. capturedAt .. "**",
                    inline = true,
                },
            },
            footer    = {
                text     = "✦ OXYO HUB  •  " .. dateStr .. "  •  Powered by Oxyo",
                icon_url = "https://www.roblox.com/headshot-thumbnail/image?userId=1&width=420&height=420&format=png",
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        }},
    }
end
local _HOOK_MIN_GAP = 5
local _queues = { oxyo = {} }
local _qBusy  = { oxyo = false }
local _qLast  = { oxyo = 0    }
local function _sendOnce(item)
    if not _httpReq then return false, "no_http" end
    if tick() - item.queuedAt > 300 then return false, "stale" end
    local ok, res = pcall(function()
        local HttpService = game:GetService("HttpService")

local function _jitter(base, range)
    task.wait(base + math.random(0, math.floor((range or base) * 10)) / 10)
end

local function _safeWFC(parent, name, timeout)
    if not parent then return nil end
    local ok, result = pcall(function() return parent:WaitForChild(name, timeout or 5) end)
    return ok and result or nil
end

local _wsDescCache = {}
local _wsDescCacheTime = 0
local function _getDescCached(timeout)
    timeout = timeout or 1.5
    local now = tick()
    if now - _wsDescCacheTime > math.max(timeout, 2.5) then
        _wsDescCache = workspace:GetDescendants()
        _wsDescCacheTime = now
    end
    return _wsDescCache
end

local function _getChar()
    local p = Players.LocalPlayer
    return p and p.Character
end
local function _getRoot()
    local c = _getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function _getHum()
    local c = _getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

        local body = HttpService:JSONEncode(item.payload)
        return _httpReq({
            Url     = item.url,
            Method  = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body    = body,
        })
    end)
    if not ok or not res then return false, "pcall_error" end
    local status = tonumber(res.StatusCode or res.status) or 0
    if status == 200 or status == 204 then return true, "ok" end
    if status == 429 then
        local retryAfter = _HOOK_MIN_GAP
        pcall(function()
            local decoded = game:GetService("HttpService"):JSONDecode(res.Body or "{}")
            local ra = tonumber(decoded.retry_after) or _HOOK_MIN_GAP
            retryAfter = ra < 1 and (ra * 1000) or ra
        end)
        retryAfter = math.clamp(retryAfter, _HOOK_MIN_GAP, 60)
        task.wait(retryAfter)
        return false, "rate_limited"
    end
    return false, "http_" .. tostring(status)
end
local function _processQueue(qkey)
    if _qBusy[qkey] then return end
    _qBusy[qkey] = true
    task.spawn(function()
        while #_queues[qkey] > 0 do
            local item = table.remove(_queues[qkey], 1)
            local gap  = _HOOK_MIN_GAP - (tick() - _qLast[qkey])
            if gap > 0 then task.wait(gap) end
            _qLast[qkey] = tick()
            local sent, reason = false, "unknown"
            for attempt = 1, 3 do
                sent, reason = _sendOnce(item)
                if sent then break end
                if reason == "stale" or reason == "no_http" then break end
                if attempt < 3 then
                    task.wait(reason == "rate_limited" and 0 or math.min(3 * 2^(attempt - 1), 12))
                end
            end
        end
        _qBusy[qkey] = false
    end)
end
local function _fireHook(url, payload, qkey)
    table.insert(_queues[qkey], {
        url      = url,
        payload  = payload,
        queuedAt = tick(),
    })
    _processQueue(qkey)
end
sendWebhook = function(title, description, color)
    if not game.JobId or game.JobId == "" then return end
    do
        local ok, isPriv = true, false
        if ok and isPriv then return end
    end
    local key = title .. "|" .. description
    if _webhookSent[key] then return end
    _webhookSent[key] = true
    task.delay(90, function() _webhookSent[key] = nil end)
    table.insert(_webhookHistory, 1, {
        time        = os.date("%H:%M:%S"),
        title       = title,
        description = description,
        color       = color or 0x7B2FBE,
        category    = getWebhookCategory(title),
        serverLink  = getServerLink(),
    })
    if #_webhookHistory > 50 then table.remove(_webhookHistory) end
    task.spawn(function()
        local waited = 0
        while not _webhookReady and waited < 5 do
            task.wait(0.25)
            waited = waited + 0.25
        end
        if not _webhookReady then return end
        if WEBHOOK_URL ~= "" then
            _fireHook(WEBHOOK_URL, buildOxyoEmbed(title, description, color), "oxyo")
        end
    end)
end
end)()
if not getgenv then getgenv = function() return _G end end
if getgenv().OxyoHopStopped == true then
    getgenv().OxyoHopStopped      = false
    getgenv().OxyoAutoHopCoin     = false
    getgenv().OxyoHopGodlyStopped = false
    getgenv().OxyoAutoHopGodly    = false
    getgenv().OxyoHopCelStopped   = false
    getgenv().OxyoAutoHopCel      = false
    getgenv().OxyoHopFragStopped  = false
    getgenv().OxyoAutoHopFrag     = false
    getgenv().OxyoHopAquaStopped  = false
    getgenv().OxyoAutoHopAqua     = false
end
local _CURRENT_VERSION, _versionKilled = "2", false
local _SB_VER_URL = "https://lywfxgkkpiyxaydwqyte.supabase.co/rest/v1/cfg?select=value&key=eq.version"
local _SB_VER_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx5d2Z4Z2trcGl5eGF5ZHdxeXRlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU2MDA3NzcsImV4cCI6MjA5MTE3Njc3N30.mSs9Vko1yDVWSS-7-CJJUBNm36udqyalNxg0q6ZOmxM"
pcall(function()
    local _req = (typeof(request)        == "function" and request)
              or (typeof(http_request)   == "function" and http_request)
              or (typeof(http)           == "table" and typeof(http.request)   == "function" and http.request)
              or (typeof(syn)            == "table" and typeof(syn.request)    == "function" and syn.request)
              or (typeof(fluxus)         == "table" and typeof(fluxus.request) == "function" and fluxus.request)
    if not _req then return end
    local res = _req({ Url = _SB_VER_URL, Method = "GET", Headers = { ["apikey"] = _SB_VER_KEY, ["Authorization"] = "Bearer " .. _SB_VER_KEY } })
    if not res or not res.Body then return end
    local ok, decoded = pcall(function()
        return game:GetService("HttpService"):JSONDecode(res.Body)
    end)
    if not ok then return end
    local serverVer = tostring((type(decoded)=="table" and decoded[1] and decoded[1].value) or "")
    if serverVer ~= "" and serverVer ~= _CURRENT_VERSION then
        _versionKilled = true
        pcall(function()
            local sGui = Instance.new("ScreenGui")
            sGui.Name = "OxyoUpdateGui"
            sGui.ResetOnSpawn = false
            sGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            pcall(function() sGui.Parent = game:GetService("CoreGui") end)
            local frame = Instance.new("Frame", sGui)
            frame.Size = UDim2.new(0, 400, 0, 110)
            frame.Position = UDim2.new(0.5, -200, 0, 24)
            frame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
            frame.BorderSizePixel = 0
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
            local accent = Instance.new("Frame", frame)
            accent.Size = UDim2.new(1, 0, 0, 3)
            accent.BackgroundColor3 = Color3.fromRGB(0, 210, 255)
            accent.BorderSizePixel = 0
            Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 12)
            local lbl = Instance.new("TextLabel", frame)
            lbl.Size = UDim2.new(1, -24, 1, 0)
            lbl.Position = UDim2.new(0, 12, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = "🔄  Oxyo Hub — Update Required\nA new version is available. Please re-execute the script."
            lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextSize = 14
            lbl.TextWrapped = true
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            task.delay(10, function() pcall(function() sGui:Destroy() end) end)
        end)
    end
end)
if _versionKilled then return end
if getgenv().OxyoHubLoaded then
    return
end
getgenv().OxyoHubLoaded = true
task.spawn(function()
    task.wait(10)
    while true do
        task.wait(60)
        pcall(function()
            if not _httpReq then return end
            local res = _httpReq({ Url = _SB_VER_URL, Method = "GET", Headers = { ["apikey"] = _SB_VER_KEY, ["Authorization"] = "Bearer " .. _SB_VER_KEY } })
            if not res or not res.Body then return end
            local ok, ver = pcall(function()
                return game:GetService("HttpService"):JSONDecode(res.Body)
            end)
            if not ok then return end
            local _verStr = tostring((type(ver)=="table" and ver[1] and ver[1].value) or "")
            if _verStr ~= "" and _verStr ~= _CURRENT_VERSION then
                pcall(function()
                    Rayfield:Notify({
                        Title    = "🔄 Update Available",
                        Content  = "A new version of Oxyo Hub is available.\nRe-execute after your current session.",
                        Duration = 10,
                        Image    = 4483362458,
                    })
                end)
            end
        end)
    end
end)
if not setclipboard then
    setclipboard = function() end
end
if not rconsoleprint then
    rconsoleprint = function() end
end
if not isreadonly then
    isreadonly = function() return false end
end
if not setreadonly then
    setreadonly = function() end
end
if not newcclosure then
    newcclosure = function(f) return f end
end
if not getnamecallmethod then
    getnamecallmethod = function() return "" end
end
if not getrawmetatable then
    getrawmetatable = function(o) return getmetatable(o) end
end
local _fireprox = (typeof(fireproximityprompt) == "function" and fireproximityprompt) or function(prompt)
    if not prompt or not prompt.Parent then return end
    local root = Players.LocalPlayer.Character
    root = root and root:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local part = prompt.Parent
    if not part:IsA("BasePart") then
        part = part:FindFirstChildWhichIsA("BasePart")
            or (part.Parent and part.Parent:FindFirstChildWhichIsA("BasePart"))
    end
    local targetPos
    if part and part:IsA("BasePart") then
        targetPos = part.Position + Vector3.new(0, 3, 0)
    elseif prompt.Parent:IsA("Attachment") then
        targetPos = prompt.Parent.WorldPosition + Vector3.new(0, 3, 0)
    else
        local wp = pcall(function() return prompt.Parent.Position end)
        if wp then targetPos = prompt.Parent.Position + Vector3.new(0, 3, 0)
        else return end
    end
    pcall(function() root.CFrame = CFrame.new(targetPos) end)
    task.wait(0.12)
    local fired = pcall(function()
        game:GetService("ProximityPromptService"):PromptTriggered(prompt, Players.LocalPlayer)
    end)
    if not fired then
        pcall(function()
            local ev = ReplicatedStorage:FindFirstChild("Events")
            local interact = ev and (
                ev:FindFirstChild("Interact") or
                ev:FindFirstChild("ProximityPrompt") or
                ev:FindFirstChild("Trigger") or
                ev:FindFirstChild("PickUp") or
                ev:FindFirstChild("Collect")
            )
            if interact then interact:FireServer(prompt) end
        end)
    end
    task.wait(0.08)
end
local _firetouchinterest = (typeof(firetouchinterest) == "function" and firetouchinterest) or function(part1, part2, touchType)
    if not part1 or not part2 then return end
    if touchType == 0 then
        local old = part1.CFrame
        local moved = false
        moved = pcall(function() part1.CFrame = CFrame.new(part2.Position + Vector3.new(0, 0.5, 0)) end)
        if not moved then
            pcall(function() part1.Position = part2.Position + Vector3.new(0, 0.5, 0) end)
        end
        task.wait(0.08)
        pcall(function() part1.CFrame = old end)
    elseif touchType == 1 then
        local old = part1.CFrame
        pcall(function() part1.CFrame = CFrame.new(part2.Position + Vector3.new(0, 100, 0)) end)
        task.wait(0.05)
        pcall(function() part1.CFrame = old end)
    end
end
local _hasAdvancedAPI = (typeof(getrawmetatable) == "function")
    and (typeof(setreadonly) == "function")
    and (typeof(newcclosure) == "function")
    and (typeof(getnamecallmethod) == "function")
    and (pcall(function() return getrawmetatable(game) end))
local AUTO_EXEC_URL = "https://raw.githubusercontent.com/idkidk123lolxd-source/probable-octo-doodlegay/refs/heads/main/Script.lua"
local HttpService = game:GetService("HttpService")
local _hopPlaceId = game.PlaceId
local _hopJobId   = game.JobId
local function isAnyHopStopped()
    if getgenv().OxyoAutoHopCoin  and getgenv().OxyoHopStopped      then return true end
    if getgenv().OxyoAutoHopGodly and getgenv().OxyoHopGodlyStopped then return true end
    if getgenv().OxyoAutoHopCel   and getgenv().OxyoHopCelStopped   then return true end
    if getgenv().OxyoAutoHopFrag  and getgenv().OxyoHopFragStopped  then return true end
    if getgenv().OxyoAutoHopAqua  and getgenv().OxyoHopAquaStopped  then return true end
    return false
end
local function isAnyHopActive()
    return getgenv().OxyoAutoHopCoin
        or getgenv().OxyoAutoHopGodly
        or getgenv().OxyoAutoHopCel
        or getgenv().OxyoAutoHopFrag
        or getgenv().OxyoAutoHopAqua
end
local function _hopGuard()
    if getgenv().OxyoManualHop == true then return false end
    return isAnyHopStopped() or not isAnyHopActive()
end
local function ServerHop()
    if _hopGuard() then return end
    local servers = {}
    local cursor  = ""
    for _ = 1, 8 do
        if _hopGuard() then return end
        local url = "https://games.roblox.com/v1/games/" .. tostring(_hopPlaceId)
                 .. "/servers/Public?sortOrder=Asc&limit=100"
        if cursor ~= "" then url = url .. "&cursor=" .. cursor end
        local ok, result = pcall(function() return game:HttpGet(url) end)
        if not ok then task.wait(3) break end
        local data
        ok, data = pcall(function() return HttpService:JSONDecode(result) end)
        if not ok or not data or not data.data then task.wait(2) break end
        for _, sv in pairs(data.data) do
            if sv.id ~= _hopJobId and sv.playing < sv.maxPlayers then
                local isDead  = getgenv().OxyoDeadServers and getgenv().OxyoDeadServers[sv.id]
                local fpsOk   = not sv.fps or sv.fps >= 10
                local notGhost = not sv.playing or sv.playing >= 0
                if not isDead and fpsOk and notGhost then
                    table.insert(servers, sv.id)
                end
            end
        end
        if #servers > 0 then break end
        if data.nextPageCursor then
            cursor = data.nextPageCursor
            task.wait(0.3)
        else
            break
        end
    end
    if _hopGuard() then return end
    if #servers == 0 then
        local waitTime = math.random(5, 10)
        for i = 1, waitTime * 4 do
            task.wait(0.25)
            if _hopGuard() then return end
        end
        task.spawn(ServerHop)
        return
    end
    local function queueExec()
        if not getgenv().OxyoExecQueued then
            getgenv().OxyoExecQueued = true
            local _qs = 'loadstring(game:HttpGet("' .. AUTO_EXEC_URL .. '"))()'
            pcall(function() if typeof(queue_on_teleport) == "function" then queue_on_teleport(_qs) end end)
            pcall(function() if typeof(syn) == "table" and typeof(syn.queue_on_teleport) == "function" then syn.queue_on_teleport(_qs) end end)
            pcall(function() if typeof(fluxus) == "table" and typeof(fluxus.queue_on_teleport) == "function" then fluxus.queue_on_teleport(_qs) end end)
        end
    end
    for _ = 1, math.min(#servers, 5) do
        if _hopGuard() then return end
        local idx    = math.random(1, #servers)
        local picked = servers[idx]
        table.remove(servers, idx)
        queueExec()
        pcall(function() getgenv().OxyoHubLoaded = false end)
        local tpOk = false
        for _attempt = 1, 3 do
            tpOk = pcall(function()
                TeleportService:TeleportToPlaceInstance(_hopPlaceId, picked, Players.LocalPlayer)
            end)
            if tpOk then
                task.delay(10, function() getgenv().OxyoExecQueued = false end)
                return
            end
            task.wait(1.5)
        end
        if getgenv().OxyoDeadServers then getgenv().OxyoDeadServers[picked] = true end
        for i = 1, math.random(2, 4) * 4 do
            task.wait(0.25)
            if _hopGuard() then return end
        end
    end
    if _hopGuard() or not isAnyHopActive() then return end
    local waitTime = math.random(5, 10)
    for i = 1, waitTime * 4 do
        task.wait(0.25)
        if _hopGuard() then return end
    end
    task.spawn(ServerHop)
end
local function smartHop()
    task.spawn(ServerHop)
end
local function smartHopGeneric(enabledKey, stoppedKey)
    if enabledKey and not getgenv()[enabledKey] then return end
    if stoppedKey and getgenv()[stoppedKey] then return end
    if _hopGuard() then return end
    task.spawn(ServerHop)
end
local function doTeleport(serverId)
    if _hopGuard() then return end
    if serverId and serverId ~= _hopJobId then
        if not getgenv().OxyoExecQueued then
            getgenv().OxyoExecQueued = true
            local _qs = 'loadstring(game:HttpGet("' .. AUTO_EXEC_URL .. '"))()'
            pcall(function() if typeof(queue_on_teleport) == "function" then queue_on_teleport(_qs) end end)
            pcall(function() if typeof(syn) == "table" and typeof(syn.queue_on_teleport) == "function" then syn.queue_on_teleport(_qs) end end)
            pcall(function() if typeof(fluxus) == "table" and typeof(fluxus.queue_on_teleport) == "function" then fluxus.queue_on_teleport(_qs) end end)
        end
        pcall(function() getgenv().OxyoHubLoaded = false end)
        local tpDone = pcall(function()
            TeleportService:TeleportToPlaceInstance(_hopPlaceId, serverId, Players.LocalPlayer)
        end)
        if tpDone then task.delay(10, function() getgenv().OxyoExecQueued = false end) end
    else
        task.spawn(ServerHop)
    end
end
getgenv().OxyoExecQueued     = false
getgenv().OxyoDeadServers    = getgenv().OxyoDeadServers    or {}
getgenv().OxyoVisitedServers = getgenv().OxyoVisitedServers or {}
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
    Name            = "Oxyo | Survive Lava for Brainrots",
    LoadingTitle    = "Loading Oxyo...",
    LoadingSubtitle = "by Mohammad",
    ConfigurationSaving = {
        Enabled    = true,
        FolderName = "OxyoHub",
        FileName   = "oxyoHub_v6",
    },
    Discord = {
        Enabled       = false,
        Invite        = "noinvitelink",
        RememberJoins = true,
    },
    KeySystem = false,
})
local player = Players.LocalPlayer
local character, humanoid, rootPart
character = player.Character or player.CharacterAdded:Wait()
humanoid  = character:WaitForChild("Humanoid")
rootPart  = character:WaitForChild("HumanoidRootPart")
local function getGameSpeed()
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    return hum and hum.WalkSpeed or 16
end
local function getGameJump()
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    return hum and hum.JumpPower or 50
end
local _cache = { GF=nil, Brainrots=nil, Plots=nil, LuckyBlocks=nil, CoinsFolder=nil }
local S = {
    flyEnabled=false, noclipEnabled=false, infinityJumpEnabled=false,
    currentSpeed=16, currentJumpPower=50, speedEnabled=false, jumpEnabled=false,
    originalSpeed=nil, originalJump=nil,
    nowe=false, speeds=1, tpwalking=false, upHeld=false, downHeld=false,
    instantGrabEnabled=false, instantGrabConnection=nil,
    OriginalHoldTimes={},
    collectorRunning=false, collectorThread=nil,
    selectedRarities={}, selectedMutations={}, selectedTraits={},
    grabLock=false, grabLockTime=0,
    maxCarry=1, farmByNameFilter="",
    autoNameEnabled=false, autoNameThread=nil,
    lavaRemoved=false, traitData={}, monitorThread=nil,
    autoCoinEnabled=false, autoHopCoinEnabled=false,
    autoHopGodlyEnabled=false, autoHopGodlyThread=nil,
    autoHopCelEnabled=false, autoHopCelThread=nil,
    coinEventDuration=60, collectedCount=0, countConn=nil,
    hitboxEnabled=false, hitboxSize=50, hitboxTransp=0.7,
    hitboxColor=BrickColor.new("Really blue"),
    volcanoEnabled=false, volcanoThread=nil,
    fullBrightEnabled=false, infiniteZoomEnabled=false,
    playerESPEnabled=false, espConnections={},
    celestialESPEnabled=false, celestialESPConnection=nil,
    selectedGear=nil, selectedGears={}, selectedLBs={},
    mutationAlertDropdown={},
    autoFragmentEnabled=false, autoFragmentConn=nil,
    autoHopFragEnabled=false, autoHopFragThread=nil,
    autoHopAquaEnabled=false, autoHopAquaThread=nil,
    preventAutoLava=false,
    antiBatEnabled=false, batStunConn=nil, batRemote=nil,
    godlyESPEnabled=false, godlyESPConn=nil,
    fullESPEnabled=false, fullESPConn=nil,
}

local _aquaRunning    = false
local _aquaThread     = nil
local _isAquaActive      = function() return false end
local _getAquaRemotes    = function() return false end
local _startAquaLoop     = function() end
local _stopAquaLoop      = function() end
local _getAquaQueuedTime = function() return nil end
local function getGF()
    if _cache.GF and _cache.GF.Parent then return _cache.GF end
    _cache.GF = workspace:FindFirstChild("GameFolder")
    return _cache.GF
end
local function getBrainrotsFolder()
    if _cache.Brainrots and _cache.Brainrots.Parent then return _cache.Brainrots end
    local gf = getGF()
    _cache.Brainrots = gf and gf:FindFirstChild("Brainrots")
    return _cache.Brainrots
end
local function getPlotsFolder()
    if _cache.Plots and _cache.Plots.Parent then return _cache.Plots end
    local gf = getGF()
    _cache.Plots = gf and gf:FindFirstChild("Plots")
    return _cache.Plots
end
local ALL_RARITIES = {"Common","Rare","Epic","Legendary","Mythic","Secret","Celestial","Godly","Forbidden"}
local ALL_TRAITS   = {"MoonGlow","Magma","Storm","Slime","Volcano","Shamrock","Ice","Forbidden","Arid","Dream","Fiesta"}
local RARITY_ORDER = {Godly=1,Celestial=2,Secret=3,Mythic=4,Legendary=5,Epic=6,Rare=7,Common=8}
local monitorData = {
    brainrots  = {},
    mutations  = {},
    totalCount = 0,
    lastScan   = 0,
    isRunning  = false,
}
local auto = {
    meteorEnabled  = false, meteorThread   = nil,
    luckyEnabled   = false, luckyConn      = nil, luckyType     = "All", luckyTraits = {},
    spinEnabled    = false, spinThread     = nil,
    moneyEnabled   = false, moneyThread    = nil,
    upgradeEnabled = false, upgradeThread  = nil,
    sellEnabled    = false, sellThread     = nil, sellThreshold = 50, sellTimer = 0,
    buyEnabled     = false, buyThread      = nil,
    buyLBEnabled   = false, buyLBThread    = nil,
    alertEnabled   = false, alertThread    = nil,
    rebirthEnabled = false, rebirthThread  = nil,
}
local GEAR_REGISTRY = {
    GrappleHook      = { displayName = "Grapple Hook",             coinPrice = 75,  serverKey = "GrappleHook"           },
    LavaBoots        = { displayName = "Lava Boots",               coinPrice = 125, serverKey = "Lava Boots"            },
    StopLava         = { displayName = "Stop Lava",                coinPrice = 250, serverKey = "Stop Lava"             },
    MagicCarpet      = { displayName = "Magic Carpet",             coinPrice = 475, serverKey = "MagicCarpet"           },
    LevelPotion      = { displayName = "Level Potion",             coinPrice = 550, serverKey = "Level Potion"          },
    PlungeGrapple    = { displayName = "Plunge Grapple",           coinPrice = 0,   serverKey = "PlungeGrapple"         },
    SubspaceTripmine = { displayName = "Subspace Tripmine",        coinPrice = 0,   serverKey = "SubspaceTripmine"      },
    Hammer           = { displayName = "Hammer",                   coinPrice = 0,   serverKey = "Hammer"                },
    SpikedBat        = { displayName = "Spiked Bat",               coinPrice = 0,   serverKey = "SpikedBat"             },
    Taser            = { displayName = "Taser",                    coinPrice = 0,   serverKey = "Taser"                 },
    Slapper          = { displayName = "Slapper",                  coinPrice = 0,   serverKey = "Slapper"               },
    DiscoBomb        = { displayName = "Disco Bomb",               coinPrice = 0,   serverKey = "DiscoBomb"             },
    Sledgehammer     = { displayName = "Sledgehammer",             coinPrice = 0,   serverKey = "Sledgehammer"          },
    HyperlaserGun    = { displayName = "Hyperlaser Gun",           coinPrice = 0,   serverKey = "HyperlaserGun"         },
    RocketLauncher   = { displayName = "Rocket Launcher",          coinPrice = 0,   serverKey = "RocketLauncher"        },
    BananaPeel       = { displayName = "Banana Peel",              coinPrice = 0,   serverKey = "BananaPeel"            },
    ChickenGear      = { displayName = "Chicken Friend",           coinPrice = 0,   serverKey = "ChickenGear"           },
    Drums            = { displayName = "Drums",                    coinPrice = 0,   serverKey = "Drums"                 },
    Harmonica        = { displayName = "Harmonica",                coinPrice = 0,   serverKey = "Harmonica"             },
    Trumpet          = { displayName = "Trumpet",                  coinPrice = 0,   serverKey = "Trumpet"               },
    Trombone         = { displayName = "Trombone",                 coinPrice = 0,   serverKey = "Trombone"              },
    Violin           = { displayName = "Violin",                   coinPrice = 0,   serverKey = "Violin"                },

    Glider           = { displayName = "Glider",                   coinPrice = 0,   serverKey = "Glider",               serverKeyVariants = {"Glider","GliderGear","Glider Gear","GliderTool","Glider Tool"} },
    LB_Common        = { displayName = "Common Lucky Block",       coinPrice = 0,   serverKey = "Common Lucky Block (World)"    },
    LB_Rare          = { displayName = "Rare Lucky Block",         coinPrice = 0,   serverKey = "Rare Lucky Block (World)"      },
    LB_Epic          = { displayName = "Epic Lucky Block",         coinPrice = 0,   serverKey = "Epic Lucky Block (World)"      },
    LB_Legendary     = { displayName = "Legendary Lucky Block",    coinPrice = 0,   serverKey = "Legendary Lucky Block (World)" },
    LB_Mythic        = { displayName = "Mythic Lucky Block",       coinPrice = 0,   serverKey = "Mythic Lucky Block (World)"    },
    LB_Secret        = { displayName = "Secret Lucky Block",       coinPrice = 0,   serverKey = "Secret Lucky Block (World)"    },
    LB_Celestial     = { displayName = "Celestial Lucky Block",    coinPrice = 0,   serverKey = "Celestial Lucky Block (World)" },
    LB_Godly         = { displayName = "Godly Lucky Block",        coinPrice = 0,   serverKey = "Godly Lucky Block (World)"     },
    LB_Magma         = { displayName = "Magma Lucky Block",        coinPrice = 0,   serverKey = "Magma Lucky Block"     },
    LB_Food          = { displayName = "Food Lucky Block",         coinPrice = 0,   serverKey = "Food Lucky Block"      },
    LB_Dino          = { displayName = "Dino Lucky Block",         coinPrice = 0,   serverKey = "Dino Lucky Block"      },
    LB_Aqua          = { displayName = "Aqua Lucky Block",         coinPrice = 0,   serverKey = "Aqua Lucky Block"      },
    LB_MoonMagma     = { displayName = "Moon Magma Lucky Block",   coinPrice = 0,   serverKey = "Moon Magma Lucky Block"},
    LB_MoonCelestial = { displayName = "Moon Celestial Lucky Block",coinPrice = 0,  serverKey = "Moon Celestial Lucky Block"},
    LB_MoonSecret    = { displayName = "Moon Secret Lucky Block",  coinPrice = 0,   serverKey = "Moon Secret Lucky Block"},
    LB_MoonMythic    = { displayName = "Moon Mythic Lucky Block",  coinPrice = 0,   serverKey = "Moon Mythic Lucky Block"},
    LB_Dream         = { displayName = "Dream Lucky Block",         coinPrice = 0,  serverKey = "Dream Lucky Block (World)",         serverKeyVariants = {"Dream Lucky Block (World)","Dream Lucky Block","DreamLuckyBlock"} },
    LB_PremDream     = { displayName = "Premium Dream Lucky Block", coinPrice = 0,  serverKey = "Premium Dream Lucky Block (World)", serverKeyVariants = {"Premium Dream Lucky Block (World)","Premium Dream Lucky Block","PremiumDreamLuckyBlock"} },
}
local LUCKY_TYPES = {
    "Common Lucky Block","Rare Lucky Block","Epic Lucky Block",
    "Legendary Lucky Block","Mythic Lucky Block","Celestial Lucky Block",
    "Secret Lucky Block","Godly Lucky Block","Magma Lucky Block",
    "Food Lucky Block","Moon Magma Lucky Block","Moon Celestial Lucky Block",
    "Moon Secret Lucky Block","Moon Mythic Lucky Block",
    "Dino Lucky Block",
    "Dream Lucky Block","Premium Dream Lucky Block",
}
local ALERT_MUTATIONS       = {"Gold","Emerald","Diamond","Bloodmoon","Rainbow","Aqua"}
local MainTab, CollectorTab, BrainrotListTab, BrainrotStatusTab, LuckyStatusTab,
      GearTab, HopTab, ForbiddenTab, BrainrotFinderTab,
      ZonesTab, HitboxTab, ExtraTab, DreamsTab, AquaTab
MainTab           = Window:CreateTab("Main",               4483362458)
CollectorTab      = Window:CreateTab("Auto",               4483362458)
BrainrotListTab   = Window:CreateTab("Brainrot List",      4483362458)
BrainrotStatusTab = Window:CreateTab("Brainrot Status",    4483362458)
LuckyStatusTab    = Window:CreateTab("Lucky Block Status", 4483362458)
GearTab           = Window:CreateTab("Shop",               4483362458)
HopTab            = Window:CreateTab("Hop",                4483362458)
ForbiddenTab      = Window:CreateTab("🚫 Forbidden",       4483362458)
BrainrotFinderTab = Window:CreateTab("🎯 Finder",          4483362458)
ZonesTab          = Window:CreateTab("Zones",              4483362458)
HitboxTab         = Window:CreateTab("Hitbox",             4483362458)
DreamsTab         = Window:CreateTab("💜 Dreams",          4483362458)
AquaTab           = Window:CreateTab("🎣 Aqua",            4483362458)
ExtraTab          = Window:CreateTab("Extra",              4483362458)
local function walkForward(studs, timeout)
    studs   = studs   or 5
    timeout = timeout or 3
    local hum  = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end
    local look   = root.CFrame.LookVector
    local target = root.Position + Vector3.new(look.X, 0, look.Z).Unit * studs
    hum:MoveTo(target)
    local deadline = tick() + timeout
    repeat RunService.Heartbeat:Wait() until (root.Position - target).Magnitude < 1.5 or tick() > deadline
    pcall(function() hum:MoveTo(root.Position) end)
end
local function safeTeleport(targetCFrame)
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local dist = (targetCFrame.Position - root.Position).Magnitude
    if dist > 1000 then
        local steps = math.ceil(dist / 500)
        for i = 1, steps - 1 do
            local alpha = i / steps
            local mid = CFrame.new(root.Position:Lerp(targetCFrame.Position, alpha)) + Vector3.new(0, 5, 0)
            pcall(function() root.CFrame = mid end)
            task.wait(0.1)
            root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not root then return false end
        end
    elseif dist > 500 then
        local mid = CFrame.new(root.Position:Lerp(targetCFrame.Position, 0.5)) + Vector3.new(0, 5, 0)
        pcall(function() root.CFrame = mid end)
        task.wait(0.08)
    end
    pcall(function() root.CFrame = targetCFrame end)
    return true
end
local _cachedMyPlot = nil
local function getPlayerPlot()
    if _cachedMyPlot and _cachedMyPlot.Parent then
        return _cachedMyPlot
    end
    local gf = workspace:FindFirstChild("GameFolder")
    local plots = gf and gf:FindFirstChild("Plots")
    if not plots then return _cachedMyPlot end
    for _, plotModel in pairs(plots:GetChildren()) do
        local brainrots = plotModel:FindFirstChild("Brainrots")
        if not brainrots then continue end
        for _, br in pairs(brainrots:GetChildren()) do
            local ok, ownerVal = pcall(function() return br:GetAttribute("Owner") end)
            if ok and ownerVal and tostring(ownerVal) == tostring(player.UserId) then
                _cachedMyPlot = plotModel
                return plotModel
            end
        end
    end
    return _cachedMyPlot
end
local function teleportToMyPlot()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local plotModel = getPlayerPlot()
    if not plotModel then return false end
    local att  = plotModel:FindFirstChild("YourBaseAtt")
    local base = plotModel:FindFirstChild("Base")
    local pos  = nil
    if att then
        pos = att.WorldPosition + Vector3.new(0, 6, 0)
    elseif base then
        local bp = (base:IsA("Model") and (base.PrimaryPart or base:FindFirstChildWhichIsA("BasePart")))
                 or (base:IsA("BasePart") and base)
        if bp then pos = bp.Position + Vector3.new(0, 6, 0) end
    end
    if pos then safeTeleport(CFrame.new(pos)) return true, plotModel end
    return false
end
local function isFishingLava(obj)
    local cur = obj.Parent
    while cur and cur ~= workspace and cur ~= game do
        if cur.Name == "AquaEvent" or cur.Name == "AquaMap" then
            return true
        end
        cur = cur.Parent
    end
    return false
end
local _hideLavaConn = nil
local function hideLava()
    if S.preventAutoLava then return end
    task.defer(function()
        pcall(function()
            if Rayfield and Rayfield.Flags and Rayfield.Flags["RemoveLava"] then
                if not Rayfield.Flags["RemoveLava"].CurrentValue then
                    Rayfield.Flags["RemoveLava"]:Set(true)
                end
            end
        end)
    end)
    if S.lavaRemoved then return end
    S.lavaRemoved = true
    for _, v in ipairs(workspace:GetDescendants()) do
        if (v.Name == "Lavas" or v.Name == "Lava") and not isFishingLava(v) then
            pcall(function()
                if v:IsA("BasePart") then
                    v.Transparency = 1
                    v.CanCollide   = false
                end
            end)
        end
    end
    if _hideLavaConn then _hideLavaConn:Disconnect() end
    _hideLavaConn = workspace.DescendantAdded:Connect(function(obj)
        if (obj.Name == "Lavas" or obj.Name == "Lava") and not isFishingLava(obj) then
            pcall(function()
                if obj:IsA("BasePart") then
                    obj.Transparency = 1
                    obj.CanCollide   = false
                end
            end)
        end
    end)
end
local restoreLava = function()
    if S.lavaRemoved and not S.autoFarmEnabled and not S.autoHopCoinEnabled
        and not S.autoHopGodlyEnabled and not S.autoHopCelEnabled and not S.autoHopFragEnabled then
        if _hideLavaConn then _hideLavaConn:Disconnect() _hideLavaConn = nil end
        for _, v in ipairs(workspace:GetDescendants()) do
            if (v.Name == "Lavas" or v.Name == "Lava") and not isFishingLava(v) then
                pcall(function()
                    if v:IsA("BasePart") then
                        v.Transparency = 0
                        v.CanCollide   = true
                    end
                end)
            end
        end
        S.lavaRemoved = false
    end
end
local _eventWatcherSent, GREEN_LINE_POS = {}, Vector3.new(-33.360527, 4.259904, -54.073788)
local _etcCached = nil

task.spawn(function()
    task.wait(1)
    pcall(function()
        _etcCached = require(game:GetService("ReplicatedStorage").Modules.EventTimerController)
    end)
end)
task.spawn(function()
    task.wait(5)
    while true do
        task.wait(8)
        pcall(function()
            if not _etcCached then
                _etcCached = require(game:GetService("ReplicatedStorage").Modules.EventTimerController)
            end
            local etc = _etcCached
            if not etc or not etc.OnGoingTimers then return end
            local function stripTags(s)
                return tostring(s):gsub("<[^>]+>", ""):gsub("&lt;", "<"):gsub("&gt;", ">")
            end
            for k, timer in pairs(etc.OnGoingTimers) do
                local ui = timer.UI
                if typeof(ui) ~= "Instance" then continue end
                local timeLeft = tonumber(timer.TimeRemaining) or 0
                local name = ""
                local nl = ui:FindFirstChild("NameLabel")
                local tl = ui:FindFirstChild("Title")
                if nl and nl:IsA("TextLabel") then name = stripTags(nl.Text)
                elseif tl and tl:IsA("TextLabel") then name = stripTags(tl.Text) end
                if name == "" then continue end
                local key = tostring(k) .. "_" .. name
                if not _eventWatcherSent[key] then
                    _eventWatcherSent[key] = true
                    local emoji = "🎉"
                    local col   = 3066993
                    if name:lower():find("coin") then emoji = "🪙" col = 16766720
                    elseif name:lower():find("volcano") then emoji = "🌋" col = 16711680
                    elseif name:lower():find("aqua")    then emoji = "🌊" col = 0x00BFFF
                    elseif name:lower():find("patric") or name:lower():find("shamrock") then emoji = "🍀" col = 3066993
                    elseif name:lower():find("moon")  then emoji = "🌙" col = 9699539
                    elseif name:lower():find("slime")  then emoji = "🟢" col = 3394764
                    elseif name:lower():find("dream")  then emoji = "💜" col = 0x9B59B6
                    end
                    sendWebhook(
                        emoji .. " Event Started: " .. name,
                        "Time Remaining: `" .. math.floor(timeLeft) .. "s`",
                        col
                    )
                end
            end
            local activeKeys = {}
            for k, timer in pairs(etc.OnGoingTimers) do
                local ui = timer.UI
                if typeof(ui) ~= "Instance" then continue end
                local nl = ui:FindFirstChild("NameLabel")
                local tl = ui:FindFirstChild("Title")
                local name = (nl and nl.Text) or (tl and tl.Text) or ""
                activeKeys[tostring(k) .. "_" .. name] = true
            end
            for key in pairs(_eventWatcherSent) do
                if not activeKeys[key] then _eventWatcherSent[key] = nil end
            end
        end)
    end
end)
local function getCoinRainStatus()
    if workspace:GetAttribute("CoinRain") == true then
        return "active", 60
    end
    local ok, etc = pcall(function()
        return require(game:GetService("ReplicatedStorage").Modules.EventTimerController)
    end)
    if not ok or not etc or not etc.OnGoingTimers then return nil end
    for _, timer in pairs(etc.OnGoingTimers) do
        local timeLeft = tonumber(timer.TimeRemaining) or 0
        if timer.RealName == "CoinRain" then
            return "active", timeLeft
        end
        local ui = timer.UI
        if typeof(ui) == "Instance" then
            local nl = ui:FindFirstChild("NameLabel")
            if nl and nl:IsA("TextLabel") then
                local txt = nl.Text:gsub("<[^>]+>", "")
                if txt:find("Coin Rain") then
                    return "active", timeLeft
                end
            end
        end
    end
    return nil
end
local function _detectCoinRainFallback()
    if workspace:GetAttribute("CoinRain") == true then return "active", 60 end
    local ok, tagged = pcall(function()
        return game:GetService("CollectionService"):GetTagged("COLLECTABLE_COIN")
    end)
    if ok and tagged and #tagged >= 1 then return "active", 60 end
    local coins = {}
    if _liveCoinParts then
        for part in pairs(_liveCoinParts) do
            if part and part.Parent then table.insert(coins, part) end
        end
    end
    if #coins >= 1 then return "active", 60 end
    return nil
end

local function _getCoinRainQueuedTime()

    local ok2, result2 = pcall(function()
        if not _etcCached then
            _etcCached = require(game:GetService("ReplicatedStorage").Modules.EventTimerController)
        end
        local etc = _etcCached
        if not etc or not etc.OnGoingTimers then return nil end
        for _, timer in pairs(etc.OnGoingTimers) do
            local rn   = tostring(timer.RealName or ""):lower()
            local trem = tonumber(timer.TimeRemaining) or 0
            local ui   = timer.UI
            local name = ""
            if typeof(ui) == "Instance" then
                local nl = ui:FindFirstChild("NameLabel")
                if nl and nl:IsA("TextLabel") then name = nl.Text:lower() end
            end

            if (rn:find("coin") or name:find("coin")) and trem >= 0 then
                local isActive = false
                pcall(function()
                    local json2 = workspace:GetAttribute("ActiveEvents")
                    if json2 and json2 ~= "" then
                        local d2 = game:GetService("HttpService"):JSONDecode(json2)
                        for k2 in pairs(d2) do
                            if tostring(k2):lower():find("coin") then isActive = true end
                        end
                    end
                end)

                if not isActive then return math.max(trem, 5) end
            end
        end
        return nil
    end)
    if ok2 and result2 then return result2 end

    local ok, result = pcall(function()
        local json = workspace:GetAttribute("QueuedEvents")
        if not json or json == "" then return nil end
        local d = game:GetService("HttpService"):JSONDecode(json)
        for key, entry in pairs(d) do
            if tostring(key):lower():find("coin", 1, true) then
                local t = tonumber(type(entry) == "table" and entry.EventTime) or 0
                if t > 0 then return math.min(t, 1200) end
            end
        end
        return nil
    end)
    return ok and result or nil
end
local function waitForCoinRainStatus(timeout)
    local deadline = tick() + (timeout or 15)
    while tick() < deadline do
        if getgenv().OxyoAutoHopCoin and getgenv().OxyoHopStopped then return nil end
        local s, t = getCoinRainStatus()
        if s then return s, t end
        local s2, t2 = _detectCoinRainFallback()
        if s2 then return s2, t2 end
        task.wait(1)
    end
    return nil
end
local _rarityFolderCache = {}
local function getBrainrotFolder(rarity)
    if rarity == "Godly" then
        local br = workspace:FindFirstChild("Brainrots")
        local f  = br and br:FindFirstChild("Godly")
        if f then return f end
    end
    local cached = _rarityFolderCache[rarity]
    if cached and cached.Parent then return cached end
    local gf = getGF()
    if not gf then return nil end
    local br = gf:FindFirstChild("Brainrots")
    local folder = br and br:FindFirstChild(rarity)
    if folder then _rarityFolderCache[rarity] = folder end
    return folder
end
local SUBMIT_ZONE_HINT, _cachedSubmitPart = Vector3.new(-30.419689, 4.307883, -54.771233), nil
local function findSubmitZone()
    if _cachedSubmitPart and _cachedSubmitPart.Parent then
        return _cachedSubmitPart.CFrame + Vector3.new(0, 3, 0)
    end
    _cachedSubmitPart = nil
    local gf = getGF()
    if gf then
        for _, d in pairs(gf:GetDescendants()) do
            if d:IsA("BasePart") and (d.Position - SUBMIT_ZONE_HINT).Magnitude < 12 then
                _cachedSubmitPart = d
                return d.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end
    for _, d in pairs(workspace:GetDescendants()) do
        if d:IsA("BasePart") and (d.Position - SUBMIT_ZONE_HINT).Magnitude < 12 then
            _cachedSubmitPart = d
            return d.CFrame + Vector3.new(0, 3, 0)
        end
    end
    return CFrame.new(SUBMIT_ZONE_HINT + Vector3.new(0, 3, 0))
end
local function getSafeBase()
    local spawn = workspace:FindFirstChildWhichIsA("SpawnLocation")
    if spawn then return CFrame.new(spawn.Position + Vector3.new(0, 5, 0)) end
    return CFrame.new(SUBMIT_ZONE_HINT + Vector3.new(5, 3, 0))
end
local function equipBest()
    pcall(function()
        local ev = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
        local remote = ev and ev:FindFirstChild("EquipBest")
        if remote then remote:FireServer() end
    end)
end
local function submitAndPlace()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then task.wait(0.5) return end
    local submitPos = findSubmitZone().Position
    root.CFrame = CFrame.new(submitPos + Vector3.new(0, 0, -3))
    task.wait(0.2)
    root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    root.CFrame = CFrame.new(submitPos + Vector3.new(0, 0, 5))
    task.wait(0.3)
    root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local plotModel = getPlayerPlot() or _cachedMyPlot
    if root and plotModel and plotModel.Parent then
        local att = plotModel:FindFirstChild("YourBaseAtt")
        if att then
            root.CFrame = CFrame.new(att.WorldPosition + Vector3.new(0, 3, 0))
            task.wait(0.3)
        end
    end
end
local function passesFarmFilters(obj)
    if #S.selectedMutations > 0 then
        local mutation = obj:GetAttribute("Mutation") or "Normal"
        local ok = false
        for _, m in ipairs(S.selectedMutations) do
            if mutation == m then ok = true break end
        end
        if not ok then return false end
    end
    if #S.selectedTraits > 0 then
        local td = S.traitData[obj]
        if not td or #td.traitNames == 0 then return false end
        local ok = false
        for _, want in ipairs(S.selectedTraits) do
            for _, have in ipairs(td.traitNames) do
                if want == have then ok = true break end
            end
            if ok then break end
        end
        if not ok then return false end
    end
    return true
end
local function passesByNameFilter(obj)
    if S.farmByNameFilter == "" then return false end
    local displayName = (obj:GetAttribute("DisplayName") or obj.Name):lower()
    return displayName:find(S.farmByNameFilter:lower(), 1, true) ~= nil
end
local function _isBrainrotTaken(obj)
    if not obj or not obj.Parent then return true end
    local taken = false
    pcall(function()
        local pp = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
        if pp and (not pp.Enabled or not pp.ActionEnabled) then taken = true return end
        local oa = obj:GetAttribute("Owner") or obj:GetAttribute("Carrying")
               or obj:GetAttribute("IsHeld") or obj:GetAttribute("HeldBy")
               or obj:GetAttribute("PickedUp")
        if oa and tostring(oa) ~= "" and tostring(oa) ~= "0" then taken = true return end
        local anc = obj.Parent
        while anc and anc ~= workspace do
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character == anc then taken = true return end
            end
            anc = anc.Parent
        end
    end)
    return taken
end
local function _isFragmentTaken(obj)
    if not obj or not obj.Parent then return true end
    local taken = false
    pcall(function()
        local oa = obj:GetAttribute("Owner") or obj:GetAttribute("Carrying")
               or obj:GetAttribute("IsHeld") or obj:GetAttribute("HeldBy")
        if oa and tostring(oa) ~= "" and tostring(oa) ~= "0" then taken = true return end
        local pp = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
        if pp and (not pp.Enabled or not pp.ActionEnabled) then taken = true return end
        local anc = obj.Parent
        while anc and anc ~= workspace do
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character == anc then taken = true return end
            end
            local n = anc.Name
            if n == "Plots" or n == "Plot" or n == "PlayerPlot"
            or n == "PlacedItems" or n == "Furniture" or n == "Chair"
            or n == "FuseMachine" or n == "ForbiddenFuse" or n == "FuseSlot"
            or n == "BrainrotSlot" or n == "Slot" or n == "InputSlot"
            or n == "MachinePart" or n == "SubmitArea" or n == "FragmentSlot"
            or n == "FragmentHolder" or n == "SubmitZone" or n == "Throne"
            or n == "ThroneSlot" or n == "ForbiddenThrone" then
                taken = true return
            end
            anc = anc.Parent
        end
    end)
    return taken
end
local function grabBrainrot(obj)
    if not obj or not obj.Parent then return false end
    if _isBrainrotTaken(obj) then return false end
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local part = obj:FindFirstChildWhichIsA("BasePart") or obj.PrimaryPart
    if not part then return false end
    safeTeleport(part.CFrame * CFrame.new(0, 4, 0))
    task.wait(0.1)
    pcall(function() root.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0)) end)
    task.wait(0.15)
    _firetouchinterest(root, part, 0)
    task.wait(0.05)
    local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt then
        local originalHold = prompt.HoldDuration
        pcall(function() prompt.HoldDuration = 0 end)
        pcall(function() prompt.MaxActivationDistance = 999 end)
        local fired = typeof(fireproximityprompt) == "function" and pcall(fireproximityprompt, prompt)
        if not fired then
            fired = pcall(function()
                game:GetService("ProximityPromptService"):PromptTriggered(prompt, player)
            end)
        end
        if not fired then
            pcall(function()
                local ev = ReplicatedStorage:FindFirstChild("Events")
                local interact = ev and (
                    ev:FindFirstChild("Interact") or
                    ev:FindFirstChild("ProximityPrompt") or
                    ev:FindFirstChild("Trigger") or
                    ev:FindFirstChild("PickUp") or
                    ev:FindFirstChild("Collect")
                )
                if interact then interact:FireServer(prompt) fired = true end
            end)
        end
        if not fired then
            for _ = 1, 5 do
                _firetouchinterest(root, part, 0)
                task.wait(0.05)
            end
        end
        task.wait(0.05)
        pcall(function() prompt.HoldDuration = originalHold end)
        pcall(function() prompt.MaxActivationDistance = 10 end)
    end
    task.wait(0.3)
    return true
end
local function pickFromFolder(folder)
    for _, obj in ipairs(folder:GetChildren()) do
        if passesFarmFilters(obj) then return obj end
    end
    return nil
end
local function collectOne(rarity, objOverride)
    local folder = getBrainrotFolder(rarity)
    if not folder then return end
    local obj = objOverride
    if not obj or not obj.Parent then obj = pickFromFolder(folder) end
    if not obj or not obj.Parent then return end
    if grabBrainrot(obj) then
        pcall(submitAndPlace)
    end
end
local function runRarityHopFarm(rarity, enabledKey, stoppedKey)
    local _noFolderTries = 0
    while getgenv()[enabledKey] and not getgenv()[stoppedKey] do
        local folder = getBrainrotFolder(rarity)
        if not folder then
            _noFolderTries = _noFolderTries + 1
            task.wait(2)
            if _noFolderTries >= 3 then
                _noFolderTries = 0
                if getgenv()[enabledKey] and not getgenv()[stoppedKey] then
                    task.wait(math.random(5, 10))
                    task.spawn(function() smartHopGeneric(enabledKey, stoppedKey) end)
                end
                return
            end
            continue
        end
        _noFolderTries = 0
        local objs = {}
        for _, obj in ipairs(folder:GetChildren()) do
            if obj and obj.Parent then table.insert(objs, obj) end
        end
        if #objs == 0 then
            if getgenv()[enabledKey] and not getgenv()[stoppedKey] then

                if rarity == "Celestial" then
                    local celTimer
                    pcall(function() celTimer = tonumber(workspace:GetAttribute("CelestialTimer")) end)
                    if celTimer and celTimer > 0 and celTimer <= 60 then
                        Rayfield:Notify({
                            Title   = "🌌 Celestial Spawning Soon!",
                            Content = string.format("CelestialTimer: %ds — waiting for spawn!", math.floor(celTimer)),
                            Duration = 5, Image = 4483362458,
                        })
                        local waited = 0
                        while waited < celTimer + 15
                            and getgenv()[enabledKey]
                            and not getgenv()[stoppedKey]
                        do
                            task.wait(2)
                            waited = waited + 2
                            local f2 = getBrainrotFolder("Celestial")
                            if f2 and #f2:GetChildren() > 0 then break end
                        end
                        continue
                    end
                end
                -- انتظر حتى 25 ثانية لو البراينروت لسا ما نزلت (round بدأ للتو)
                local spawnWait = 0
                while spawnWait < 25
                    and getgenv()[enabledKey]
                    and not getgenv()[stoppedKey]
                do
                    task.wait(2)
                    spawnWait = spawnWait + 2
                    local f2 = getBrainrotFolder(rarity)
                    if f2 and #f2:GetChildren() > 0 then
                        folder = f2
                        break
                    end
                end
                -- تحقق بعد الانتظار
                folder = getBrainrotFolder(rarity)
                if folder and #folder:GetChildren() > 0 then
                    continue  -- يعيد الـ while ليجمع
                end
                task.wait(3)
                task.spawn(function() smartHopGeneric(enabledKey, stoppedKey) end)
            end
            return
        end
        for _, obj in ipairs(objs) do
            if not getgenv()[enabledKey] or getgenv()[stoppedKey] then return end
            if obj and obj.Parent then

                local isTaken = false
                pcall(function()
                    local pp = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if pp and (not pp.Enabled or not pp.ActionEnabled) then
                        isTaken = true
                        return
                    end
                    local ownerAttr = obj:GetAttribute("Owner")
                                   or obj:GetAttribute("Carrying")
                                   or obj:GetAttribute("IsHeld")
                                   or obj:GetAttribute("HeldBy")
                                   or obj:GetAttribute("PickedUp")
                    if ownerAttr and tostring(ownerAttr) ~= "" and tostring(ownerAttr) ~= "0" then
                        isTaken = true
                        return
                    end
                    local anc = obj.Parent
                    while anc and anc ~= workspace do
                        for _, plr in pairs(Players:GetPlayers()) do
                            if plr.Character == anc then
                                isTaken = true
                                return
                            end
                        end
                        anc = anc.Parent
                    end
                end)
                if not isTaken then
                    pcall(grabBrainrot, obj)
                    pcall(submitAndPlace)
                end
                task.wait(0.3)
            end
        end
        if getgenv()[enabledKey] and not getgenv()[stoppedKey] then
            pcall(teleportToMyPlot)
            task.wait(3)
            task.spawn(function() smartHopGeneric(enabledKey, stoppedKey) end)
        end
        return
    end
end
local function runFragHopFarm(enabledKey, stoppedKey)
    while getgenv()[enabledKey] and not getgenv()[stoppedKey] do
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then task.wait(0.5) continue end
        local found, seen = {}, {}
        local _scanCharSet = {}
        pcall(function()
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character then _scanCharSet[plr.Character] = true end
            end
        end)
        for _, obj in ipairs(workspace:GetDescendants()) do
            if not (obj and obj.Parent) then continue end
            local n = obj.Name:lower()
            if not (n:find("fragment") or n == "frag") then continue end
            if not (obj:IsA("BasePart") or obj:IsA("Model")) then continue end
            local oa = obj:GetAttribute("Owner") or obj:GetAttribute("Carrying")
                   or obj:GetAttribute("IsHeld") or obj:GetAttribute("HeldBy")
            if oa and tostring(oa) ~= "" and tostring(oa) ~= "0" then continue end
            local skip = false
            local anc = obj.Parent
            while anc and anc ~= workspace do
                if seen[anc] then skip = true break end
                if _scanCharSet[anc] then skip = true break end
                local an = anc.Name
                if an == "Plots" or an == "Plot" or an == "PlayerPlot"
                or an == "PlacedItems" or an == "Furniture" or an == "Chair" then
                    skip = true break
                end
                anc = anc.Parent
            end
            if not skip then seen[obj] = true table.insert(found, obj) end
        end
        task.wait(0.1)
        if #found == 0 then
            if getgenv()[enabledKey] and not getgenv()[stoppedKey] then
                -- انتظر حتى 20 ثانية لو الـ fragments لسا ما نزلت
                local spawnWait = 0
                while spawnWait < 20
                    and getgenv()[enabledKey]
                    and not getgenv()[stoppedKey]
                do
                    task.wait(2)
                    spawnWait = spawnWait + 2
                    local tmpFound = {}
                    pcall(function()
                        for _, obj in ipairs(workspace:GetDescendants()) do
                            if not (obj and obj.Parent) then continue end
                            local n2 = obj.Name:lower()
                            if not (n2:find("fragment") or n2 == "frag") then continue end
                            if not (obj:IsA("BasePart") or obj:IsA("Model")) then continue end
                            table.insert(tmpFound, obj)
                        end
                    end)
                    if #tmpFound > 0 then break end
                end
                -- re-scan
                found = {}
                pcall(function()
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if not (obj and obj.Parent) then continue end
                        local n2 = obj.Name:lower()
                        if not (n2:find("fragment") or n2 == "frag") then continue end
                        if not (obj:IsA("BasePart") or obj:IsA("Model")) then continue end
                        table.insert(found, obj)
                    end
                end)
                if #found > 0 then continue end
                task.wait(3)
                task.spawn(function() smartHopGeneric(enabledKey, stoppedKey) end)
            end
            return
        end
        table.sort(found, function(a, b)
            local function getPos(o)
                if o:IsA("BasePart") then return o.Position end
                local ok, cf = pcall(function() return o:GetModelCFrame() end)
                return ok and cf.Position or Vector3.zero
            end
            return (getPos(a) - root.Position).Magnitude < (getPos(b) - root.Position).Magnitude
        end)

        local _charSet = {}
        pcall(function()
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character then _charSet[plr.Character] = true end
            end
        end)
        local _attempted = {}
        local grabbed = 0
        for _, frag in ipairs(found) do
            if not getgenv()[enabledKey] or getgenv()[stoppedKey] then return end
            if frag and frag.Parent and not _attempted[frag] then
                _attempted[frag] = true
                local fragTaken = false
                pcall(function()
                    local pp = frag:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if pp and (not pp.Enabled or not pp.ActionEnabled) then
                        fragTaken = true
                        return
                    end
                    local ownerAttr = frag:GetAttribute("Owner")
                                   or frag:GetAttribute("Carrying")
                                   or frag:GetAttribute("IsHeld")
                                   or frag:GetAttribute("HeldBy")
                    if ownerAttr and tostring(ownerAttr) ~= "" and tostring(ownerAttr) ~= "0" then
                        fragTaken = true
                        return
                    end
                    local anc = frag.Parent
                    while anc and anc ~= workspace do
                        if _charSet[anc] then fragTaken = true return end
                        anc = anc.Parent
                    end
                end)
                if fragTaken then continue end
                local part = (frag:IsA("BasePart") and frag)
                    or frag.PrimaryPart
                    or frag:FindFirstChildWhichIsA("BasePart")
                if not part then continue end
                root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if not root then break end
                safeTeleport(part.CFrame * CFrame.new(0, 4, 0))
                task.wait(0.15)
                root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    pcall(function() root.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0)) end)
                    task.wait(0.2)
                    _firetouchinterest(root, part, 0)
                    task.wait(0.05)
                    local allDesc = frag:IsA("Model") and frag:GetDescendants() or { frag }
                    for _, d in ipairs(allDesc) do
                        if d:IsA("ProximityPrompt") then
                            pcall(function() d.HoldDuration = 0 d.MaxActivationDistance = 999 end)
                            pcall(function() if typeof(fireproximityprompt) == "function" then fireproximityprompt(d) end end)
                        end
                    end
                end
                grabbed = grabbed + 1
                task.wait(0.3)
            end
        end
        if grabbed > 0 then
            pcall(function()
                local rs = game:GetService("ReplicatedStorage")
                local remote = rs:FindFirstChild("SubmitFragment")
                if remote then remote:FireServer() end
            end)
            pcall(submitAndPlace)
            pcall(teleportToMyPlot)
            if getgenv()[enabledKey] and not getgenv()[stoppedKey] then
                task.wait(3)
                task.spawn(function() smartHopGeneric(enabledKey, stoppedKey) end)
            end
            return
        end
        task.wait(math.random(1, 3))
        if getgenv()[enabledKey] and not getgenv()[stoppedKey] then
            task.spawn(function() smartHopGeneric(enabledKey, stoppedKey) end)
        end
        return
    end
end
local stopFarmLoop
local function startFarm(rarities)
    if S.collectorRunning then stopFarmLoop() task.wait(0.1) end
    S.collectorRunning = true
    local raritySet = {}
    for _, r in ipairs(rarities) do raritySet[r] = true end
    S.collectorThread = task.spawn(function()
        local _sortedCache   = {}
        local _lastScanSeen  = -1
        while S.collectorRunning do
            if S.grabLock then task.wait(0.2) continue end
            if monitorData.lastScan ~= _lastScanSeen then
                _lastScanSeen = monitorData.lastScan
                _sortedCache  = {}
                for _, entry in ipairs(monitorData.brainrots) do
                    if raritySet[entry.rarity] and entry.obj and entry.obj.Parent then
                        if passesFarmFilters(entry.obj) then
                            table.insert(_sortedCache, entry)
                        end
                    end
                end
                table.sort(_sortedCache, function(a, b)
                    return (RARITY_ORDER[a.rarity] or 99) < (RARITY_ORDER[b.rarity] or 99)
                end)
            end
            local targets = {}
            for _, entry in ipairs(_sortedCache) do
                if entry.obj and entry.obj.Parent then
                    table.insert(targets, entry)
                end
            end
            if #targets == 0 then task.wait(1) continue end
            local grabbed = 0
            for _, entry in ipairs(targets) do
                if not S.collectorRunning then break end
                if S.grabLock then break end
                if grabbed >= S.maxCarry then break end
                if entry.obj and entry.obj.Parent then
                    local ok, did = pcall(grabBrainrot, entry.obj)
                    if ok and did then
                        grabbed = grabbed + 1
                        if grabbed < S.maxCarry then
                            task.wait(0.3)
                        end
                    end
                end
            end
            if grabbed > 0 and S.collectorRunning then
                pcall(submitAndPlace)
            end
            task.wait(0.2)
        end
    end)
end
stopFarmLoop = function()
    S.collectorRunning = false
    if S.collectorThread then pcall(task.cancel, S.collectorThread) S.collectorThread = nil end
end
local function scanWorld()
    local found       = {}
    local mutationMap = {}
    for _, rarity in ipairs(ALL_RARITIES) do
        local folder = getBrainrotFolder(rarity)
        if folder then
            for _, obj in ipairs(folder:GetChildren()) do
                if obj and obj.Parent then
                    local mutation    = obj:GetAttribute("Mutation") or "Normal"
                    local displayName = obj:GetAttribute("DisplayName") or obj.Name
                    local entry = { rarity = rarity, name = displayName, mutation = mutation, obj = obj }
                    table.insert(found, entry)
                    if mutation ~= "Normal" then
                        table.insert(mutationMap, entry)
                    end
                end
            end
        end
    end
    monitorData.brainrots  = found
    monitorData.mutations  = mutationMap
    monitorData.totalCount = #found
    monitorData.lastScan   = tick()
    for obj in pairs(S.traitData) do
        if not obj or not obj.Parent then S.traitData[obj] = nil end
    end
end
local _webhookSeenBrainrots = {}
local function startMonitor()
    if monitorData.isRunning then return end
    monitorData.isRunning = true
    local _dirty = true
    local _dirtyConns = {}
    local function _markDirty() _dirty = true end
    local function _watchFolder(folder)
        if not folder then return end
        table.insert(_dirtyConns, folder.ChildAdded:Connect(_markDirty))
        table.insert(_dirtyConns, folder.ChildRemoved:Connect(_markDirty))
    end
    task.spawn(function()
        local gf = getGF()
        local br = gf and gf:FindFirstChild("Brainrots")
        if br then
            for _, rarity in ipairs(ALL_RARITIES) do
                _watchFolder(br:FindFirstChild(rarity))
            end
        end
        local wbr = workspace:FindFirstChild("Brainrots")
        if wbr then _watchFolder(wbr:FindFirstChild("Godly")) end
    end)
    S.monitorThread = task.spawn(function()
        while monitorData.isRunning do
            if _dirty then
                _dirty = false
                pcall(scanWorld)
                pcall(function()
                    for _, entry in ipairs(monitorData.brainrots) do
                        if entry.rarity == "Celestial" or entry.rarity == "Godly" then
                            local key = entry.name .. "_" .. entry.rarity .. "_" .. (entry.mutation or "Normal")
                            if not _webhookSeenBrainrots[key] then
                                _webhookSeenBrainrots[key] = true
                                local mut   = entry.mutation or "Normal"
                                local emoji = entry.rarity == "Godly" and "👑" or "🌌"
                                local col   = entry.rarity == "Godly" and 0xFFD700 or 0x9B59B6
                                local title = emoji .. " " .. entry.rarity .. " Spotted! " .. emoji
                                local desc  = "**" .. entry.name .. "**\nMutation: `" .. mut .. "`\nServer: `" .. tostring(game.JobId):sub(1,8) .. "...`"
                                local wkey  = title .. "|" .. desc
                                _webhookSent[wkey] = nil
                                sendWebhook(title, desc, col)
                            end
                        end
                    end
                    local alive = {}
                    for _, entry in ipairs(monitorData.brainrots) do
                        alive[entry.name .. "_" .. entry.rarity .. "_" .. (entry.mutation or "Normal")] = true
                    end
                    for k in pairs(_webhookSeenBrainrots) do
                        if not alive[k] then _webhookSeenBrainrots[k] = nil end
                    end
                end)
            end
            task.wait(1)
        end
        for _, c in ipairs(_dirtyConns) do pcall(function() c:Disconnect() end) end
    end)
end
local traitHookConn = nil
local function initTraitHook()
    local ok, traitEvent = pcall(function()
        return ReplicatedStorage.Registries.TraitsRegistry.SetupTraitVFX
    end)
    if not ok or not traitEvent then return end
    if traitHookConn then traitHookConn:Disconnect() end
    traitHookConn = traitEvent.OnClientEvent:Connect(function(brainrotModel, vfxModule)
        if not brainrotModel or not brainrotModel.Parent then return end
        local traitName = ""
        pcall(function() traitName = vfxModule.Name:gsub("VFX$", "") end)
        if traitName == "" then return end
        if not S.traitData[brainrotModel] then
            S.traitData[brainrotModel] = {
                obj        = brainrotModel,
                traitNames = {},
                name       = brainrotModel:GetAttribute("DisplayName") or brainrotModel.Name,
                rarity     = (brainrotModel.Parent and brainrotModel.Parent.Name) or "Unknown",
                mutation   = brainrotModel:GetAttribute("Mutation") or "Normal",
            }
        end
        local already = false
        for _, t in ipairs(S.traitData[brainrotModel].traitNames) do
            if t == traitName then already = true break end
        end
        if not already then
            table.insert(S.traitData[brainrotModel].traitNames, traitName)
        end
    end)
end
local allStates = {
    Enum.HumanoidStateType.Climbing,     Enum.HumanoidStateType.FallingDown,
    Enum.HumanoidStateType.Flying,       Enum.HumanoidStateType.Freefall,
    Enum.HumanoidStateType.GettingUp,
    Enum.HumanoidStateType.Landed,       Enum.HumanoidStateType.Physics,
    Enum.HumanoidStateType.PlatformStanding, Enum.HumanoidStateType.Ragdoll,
    Enum.HumanoidStateType.Running,      Enum.HumanoidStateType.RunningNoPhysics,
    Enum.HumanoidStateType.Seated,       Enum.HumanoidStateType.StrafingNoPhysics,
    Enum.HumanoidStateType.Swimming,
}
local function setHumanoidStates(enabled)
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    for _, state in ipairs(allStates) do hum:SetStateEnabled(state, enabled) end
    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
    if enabled then
        hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
    else
        hum:ChangeState(Enum.HumanoidStateType.Swimming)
    end
end
local startFlySystem, stopFlySystem
local flyInputConnections = {}
startFlySystem = function()
    local chr = player.Character
    if not chr then return end
    S.nowe      = true
    S.tpwalking = false
    S.tpwalking = true
    task.spawn(function()
        local c = player.Character
        local h = c and c:FindFirstChildWhichIsA("Humanoid")
        while S.tpwalking and RunService.Heartbeat:Wait() and c and h and h.Parent do
            if h.MoveDirection.Magnitude > 0 then c:TranslateBy(h.MoveDirection * S.speeds) end
        end
    end)
    pcall(function()
        chr.Animate.Disabled = true
        local hum2 = chr:FindFirstChildOfClass("Humanoid") or chr:FindFirstChildOfClass("AnimationController")
        if hum2 then
            for _, track in next, hum2:GetPlayingAnimationTracks() do track:AdjustSpeed(0) end
        end
    end)
    setHumanoidStates(false)
    local hum     = chr:FindFirstChildOfClass("Humanoid")
    local rigType = hum and hum.RigType
    local torso   = (rigType == Enum.HumanoidRigType.R6)
                    and chr:FindFirstChild("Torso")
                    or  chr:FindFirstChild("UpperTorso")
    if not torso then return end
    local bg = Instance.new("BodyGyro", torso)
    bg.P           = 9e4
    bg.maxTorque   = Vector3.new(9e9, 9e9, 9e9)
    bg.cframe      = torso.CFrame
    local bv = Instance.new("BodyVelocity", torso)
    bv.velocity  = Vector3.new(0, 0.1, 0)
    bv.maxForce  = Vector3.new(9e9, 9e9, 9e9)
    hum.PlatformStand = true
    local ctrl     = {f=0, b=0, l=0, r=0}
    local lastctrl = {f=0, b=0, l=0, r=0}
    local maxspeed = 50
    local spd      = 0
    task.spawn(function()
        while S.nowe do
            if rigType == Enum.HumanoidRigType.R6 then
                RunService.RenderStepped:Wait()
            else
                RunService.Heartbeat:Wait()
            end
            if ctrl.l+ctrl.r ~= 0 or ctrl.f+ctrl.b ~= 0 then
                spd = math.min(spd + 0.5 + (spd/maxspeed), maxspeed)
            elseif spd ~= 0 then
                spd = math.max(spd - 1, 0)
            end
            local cam = workspace.CurrentCamera.CoordinateFrame
            if (ctrl.l+ctrl.r) ~= 0 or (ctrl.f+ctrl.b) ~= 0 then
                bv.velocity = ((cam.lookVector*(ctrl.f+ctrl.b)) + ((cam*CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - cam.p)) * spd
                lastctrl = {f=ctrl.f, b=ctrl.b, l=ctrl.l, r=ctrl.r}
            elseif spd ~= 0 then
                bv.velocity = ((cam.lookVector*(lastctrl.f+lastctrl.b)) + ((cam*CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - cam.p)) * spd
            else
                bv.velocity = Vector3.new(0, 0, 0)
            end
            bg.cframe = workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*spd/maxspeed), 0, 0)
        end
        bg:Destroy()
        bv:Destroy()
        pcall(function()
            hum.PlatformStand    = false
            chr.Animate.Disabled = false
        end)
        S.tpwalking = false
    end)
    task.spawn(function()
        while S.nowe do
            RunService.Heartbeat:Wait()
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                if S.upHeld   then root.CFrame = root.CFrame * CFrame.new(0,  1, 0) end
                if S.downHeld then root.CFrame = root.CFrame * CFrame.new(0, -1, 0) end
            end
        end
    end)
    table.insert(flyInputConnections, UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.W then ctrl.f =  1 end
        if input.KeyCode == Enum.KeyCode.S then ctrl.b = -1 end
        if input.KeyCode == Enum.KeyCode.A then ctrl.l = -1 end
        if input.KeyCode == Enum.KeyCode.D then ctrl.r =  1 end
    end))
    table.insert(flyInputConnections, UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then ctrl.f = 0 end
        if input.KeyCode == Enum.KeyCode.S then ctrl.b = 0 end
        if input.KeyCode == Enum.KeyCode.A then ctrl.l = 0 end
        if input.KeyCode == Enum.KeyCode.D then ctrl.r = 0 end
    end))
end
stopFlySystem = function()
    S.nowe      = false
    S.tpwalking = false
    for _, c in ipairs(flyInputConnections) do c:Disconnect() end
    flyInputConnections = {}
    setHumanoidStates(true)
    pcall(function()
        if player.Character then player.Character.Animate.Disabled = false end
    end)
end
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Q then S.upHeld   = true  end
    if input.KeyCode == Enum.KeyCode.E then S.downHeld = true  end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if getgenv().OxyoAutoHopCoin or getgenv().OxyoAutoHopGodly or getgenv().OxyoAutoHopCel or getgenv().OxyoAutoHopFrag or getgenv().OxyoAutoHopAqua then
            nuclearStop()
        end
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Q then S.upHeld   = false end
    if input.KeyCode == Enum.KeyCode.E then S.downHeld = false end
end)
local function duplicateEquipped()
    local char = player.Character
    if not char then return false, "No character found." end
    local tool = nil
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Tool") then tool = obj break end
    end
    if not tool then return false, "No Brainrot equipped." end
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return false, "No backpack found." end
    local clone = tool:Clone()
    clone.Parent = backpack
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum:UnequipTools() end
    return true, "Duplicated: " .. tool.Name
end
local function getPlotBrainrotCount()
    local count = 0
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, v in pairs(backpack:GetChildren()) do
            if v:IsA("Tool") then count = count + 1 end
        end
    end
    local char = player.Character
    if char then
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("Tool") then count = count + 1 end
        end
    end
    return count
end
local function getSellRemote()
    local events = ReplicatedStorage:FindFirstChild("Events")
    if not events then return nil end
    local r = events:FindFirstChild("SellDialogue")
    if r then return r end
    for _, v in pairs(events:GetChildren()) do
        if v.Name:lower():find("sell") then return v end
    end
    return nil
end
local function doSell()
    local remote = getSellRemote()
    if not remote then
        warn("[AutoSell] Remote not found in ReplicatedStorage.Events!")
        return false
    end
    local ok, err = pcall(function()
        if remote:IsA("RemoteFunction") then
            remote:InvokeServer("SellAll")
        elseif remote:IsA("RemoteEvent") then
            remote:FireServer("SellAll")
        end
    end)
    if not ok then warn("[AutoSell] Fire failed:", tostring(err)) end
    return ok
end
local function attachPlotCounter(plot)
    if S.countConn then S.countConn:Disconnect() end
    playerPlot     = plot
    S.collectedCount = 0
    local br = plot:FindFirstChild("Brainrots")
    if not br then return end
    S.countConn = br.ChildAdded:Connect(function(child)
        if child:IsA("Model") then
            S.collectedCount = S.collectedCount + 1
        end
    end)
end
local function isValidPos(pos)
    return math.abs(pos.X) < 5000 and math.abs(pos.Y) < 5000 and math.abs(pos.Z) < 5000
end
local function getLuckyBlocks()
    local gf = workspace:FindFirstChild("GameFolder")
    local lb = gf and gf:FindFirstChild("LuckyBlocks")
    if not lb then return {} end
    local result = {}
    for _, block in ipairs(lb:GetChildren()) do
        local pp     = block:FindFirstChildWhichIsA("ProximityPrompt", true)
        local active = false
        local pos    = Vector3.new(0, 0, 0)
        if pp then
            pos    = pp.Parent.Position
            active = isValidPos(pos)
        end
        table.insert(result, { name = block.Name, active = active, pos = pos, block = block, pp = pp })
    end
    return result
end
local function shouldFireLucky(blockName)
    if auto.luckyType == "All" then return true end
    local bn = blockName:lower()
    local lt = auto.luckyType:lower()
    return bn == lt or bn:find(lt, 1, true) ~= nil or lt:find(bn, 1, true) ~= nil
end
local function luckyTraitPass(block)
    if not auto.luckyTraits or #auto.luckyTraits == 0 then return true end
    local td = S.traitData[block]
    if not td or #td.traitNames == 0 then return false end
    for _, want in ipairs(auto.luckyTraits) do
        for _, have in ipairs(td.traitNames) do
            if have == want then return true end
        end
    end
    return false
end
local function tryFireBlock(block)
    if not auto.luckyEnabled then return end
    if not shouldFireLucky(block.Name) then return end
    if not luckyTraitPass(block) then return end
    pcall(function()
        local pp = block:FindFirstChildWhichIsA("ProximityPrompt", true)
        if not pp then return end
        local pos = pp.Parent.Position
        if not isValidPos(pos) then return end
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        root.CFrame = CFrame.new(pos + Vector3.new(0, 3, 3))
        task.wait(0.3)
        _fireprox(pp)
        task.wait(0.5)
        root.CFrame = getSafeBase()
    end)
end
local BUY_RESULT = {
    SUCCESS      = "success",
    OUT_OF_STOCK = "out_of_stock",
    NO_COINS     = "no_coins",
    NOT_IN_SHOP  = "not_in_shop",
}
local _VP_REMOTE  = ReplicatedStorage:WaitForChild("Events", 10)
                and ReplicatedStorage.Events:WaitForChild("VendorPurchase", 10)
local function _getGearsAccess()
    local vendor = workspace:FindFirstChild("GameFolder")
        and workspace.GameFolder:FindFirstChild("Shops")
        and workspace.GameFolder.Shops:FindFirstChild("Vendor")
    return vendor and vendor:FindFirstChild("GearsAccess")
end
local _stockData = {}
local _lastRestockTick = 0
local function _normaliseKey(s)
    return tostring(s):lower():gsub("%s+",""):gsub("%d+$","")
end
local function _writeStock(rawName, inStock, stock, isManual)
    local key  = tostring(rawName):lower()
    local norm = _normaliseKey(rawName)
    _stockData[key] = { inStock=inStock, stock=stock or 0, manual=isManual or false, t=tick() }
    if inStock then
        local toErase = {}
        for k2, v2 in pairs(_stockData) do
            if k2 ~= key and not v2.inStock then
                if _normaliseKey(k2) == norm then
                    table.insert(toErase, k2)
                end
            end
        end
        for _, k in ipairs(toErase) do _stockData[k] = nil end
    end
end
local function _hookStockService()
    local ok, re = pcall(function()
        return ReplicatedStorage:WaitForChild("Remotes", 5)
            and ReplicatedStorage.Remotes:WaitForChild("StockGameService", 5)
            and ReplicatedStorage.Remotes.StockGameService:WaitForChild("ReplicateStockData", 5)
    end)
    if not ok or not re then return end
    re.OnClientEvent:Connect(function(data)
        if type(data) ~= "table" then return end
        local function parseEntry(k, v)
            if type(v) == "table" then
                for name, info in pairs(v) do
                    if type(info) == "table" then
                        local inStock = info.inStock ~= false and (tonumber(info.stock) or 0) > 0
                        _writeStock(name, inStock, tonumber(info.stock) or 0)
                    elseif type(info) == "boolean" or type(info) == "number" then
                        local inStock = info == true or (type(info) == "number" and info > 0)
                        local stock   = type(info) == "number" and info or (info and 1 or 0)
                        _writeStock(name, inStock, stock)
                    end
                end
            elseif type(v) == "boolean" or type(v) == "number" then
                local inStock = v == true or (type(v) == "number" and v > 0)
                local stock   = type(v) == "number" and v or (v and 1 or 0)
                _writeStock(k, inStock, stock)
            end
        end
        for k, v in pairs(data) do parseEntry(k, v) end
    end)
end
task.spawn(_hookStockService)
local _cachedVendorLbl = nil
local function _getVendorTimerSeconds()
    if _cachedVendorLbl and _cachedVendorLbl.Parent then
        local raw = _cachedVendorLbl.Text:gsub("<[^>]+>", "")
        local h, m, s = raw:match("(%d+):(%d+):(%d+)")
        if h then return tonumber(h)*3600 + tonumber(m)*60 + tonumber(s) end
        local m2, s2 = raw:match("(%d+):(%d+)")
        if m2 then return tonumber(m2)*60 + tonumber(s2) end
        return nil
    end
    local pg = Players.LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local function find(inst, depth)
        if depth > 5 then return nil end
        if inst.Name == "Vendor" and inst:IsA("Frame") then
            local main = inst:FindFirstChild("Main")
            local lbl  = main and main:FindFirstChild("Timer")
            if lbl and lbl:IsA("TextLabel") then
                _cachedVendorLbl = lbl
                local raw = lbl.Text:gsub("<[^>]+>", "")
                local h, m, s = raw:match("(%d+):(%d+):(%d+)")
                if h then return tonumber(h)*3600 + tonumber(m)*60 + tonumber(s) end
                local m2, s2 = raw:match("(%d+):(%d+)")
                if m2 then return tonumber(m2)*60 + tonumber(s2) end
            end
        end
        for _, c in ipairs(inst:GetChildren()) do
            local r = find(c, depth+1)
            if r then return r end
        end
    end
    for _, gui in ipairs(pg:GetChildren()) do
        local r = find(gui, 0)
        if r then return r end
    end
    return nil
end
task.spawn(function()
    local prevSeconds = nil
    while true do
        task.wait(10)
        local secs = _getVendorTimerSeconds()
        if secs then
            if prevSeconds and prevSeconds < 90 and secs > 1200 then
                _lastRestockTick = tick()
                local toErase = {}
                for k, v in pairs(_stockData) do
                    if v.manual and not v.inStock then
                        table.insert(toErase, k)
                    end
                end
                for _, k in ipairs(toErase) do _stockData[k] = nil end
                pcall(function()
                    Rayfield:Notify({
                        Title   = "🔄 Shop Restocked!",
                        Content = "Auto Buy resumed — stock flags cleared.",
                        Duration = 4,
                        Image   = 4483362458,
                    })
                end)
            end
            prevSeconds = secs
        end
    end
end)
local _resolvedKeys = {}
local function _hookVendorCapture()
    if not _hasAdvancedAPI or not _VP_REMOTE then return end
    pcall(function()
        local mt  = getrawmetatable(game)
        local old = rawget(mt, "__namecall")
        if not old then return end
        setreadonly(mt, false)
        local _orig = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local m = getnamecallmethod()
            if m == "FireServer" and self == _VP_REMOTE then
                local args = {...}
                if args[1] ~= nil then
                    local key = tostring(args[1])
                    _resolvedKeys[key:lower()] = key
                end
            end
            return _orig(self, ...)
        end)
        setreadonly(mt, true)
    end)
end
task.spawn(_hookVendorCapture)
local function parseCash(str)
    if type(str) == "number" then return str end
    str = tostring(str):gsub(",", ""):gsub("%s", "")
    local suffixes = {
        K=1e3, M=1e6, B=1e9, T=1e12,
        Qd=1e15, Qn=1e18, Sx=1e21, Sp=1e24,
        Oc=1e27, No=1e30, Dc=1e33,
    }
    local sorted = {}
    for s in pairs(suffixes) do table.insert(sorted, s) end
    table.sort(sorted, function(a,b) return #a > #b end)
    for _, s in ipairs(sorted) do
        local num = str:match("^(%-?%d+%.?%d*)" .. s .. "$")
        if num then return (tonumber(num) or 0) * suffixes[s] end
    end
    return tonumber(str) or 0
end
local function getCoins()
    local ls = player:FindFirstChild("leaderstats")
    if not ls then return math.huge end
    local coins = ls:FindFirstChild("Coins") or ls:FindFirstChild("Coin") or ls:FindFirstChild("Cash")
    if not coins then return math.huge end
    return parseCash(coins.Value)
end
local function _resolveServerKey(data)
    local dn     = data.displayName:lower()
    local normDN = _normaliseKey(data.displayName)
    if _resolvedKeys[dn] then return _resolvedKeys[dn] end
    for k, v in pairs(_resolvedKeys) do
        local normK = _normaliseKey(k)
        if normK == normDN or normK:find(normDN,1,true) or normDN:find(normK,1,true) then
            return v
        end
    end

    if data.serverKeyVariants then
        for _, variant in ipairs(data.serverKeyVariants) do
            local normV = _normaliseKey(variant)
            for k, v in pairs(_resolvedKeys) do
                if _normaliseKey(k) == normV then return v end
            end
        end
    end
    return data.serverKey
end
local function _isInStock(data)
    local normDN = _normaliseKey(data.displayName)
    local normSK = _normaliseKey(data.serverKey)
    if next(_stockData) == nil then return true end
    local anyFound   = false
    local anyInStock = false
    for k, v in pairs(_stockData) do
        local normK = _normaliseKey(k)
        if normK == normDN or normK == normSK
        or normK:find(normSK, 1, true) or normSK:find(normK, 1, true) then
            anyFound = true
            if v.inStock then anyInStock = true end
        end
    end
    if anyFound then return anyInStock end
    return true
end
local function getGearsInShop()
    local result = {}
    for k, v in pairs(_stockData) do
        result[k] = v.inStock
    end
    local ga = _getGearsAccess()
    if ga then
        for _, child in pairs(ga:GetChildren()) do
            local cn = child.Name:lower()
            if result[cn] == nil then result[cn] = true end
        end
    end
    return result
end
local function buyGear(gearKey)
    local data = GEAR_REGISTRY[gearKey]
    if not data then return BUY_RESULT.NOT_IN_SHOP end
    local remote = _VP_REMOTE
    if not remote then return BUY_RESULT.NOT_IN_SHOP end
    do
        local normDN = _normaliseKey(data.displayName)
        local normSK = _normaliseKey(data.serverKey)
        for k, v in pairs(_stockData) do
            if v.manual and not v.inStock then
                if (tick() - (v.t or 0)) > 90 then
                    _stockData[k] = nil
                else
                    local normK = _normaliseKey(k)
                    if normK == normDN or normK == normSK
                    or normK:find(normSK,1,true) or normSK:find(normK,1,true) then
                        return BUY_RESULT.OUT_OF_STOCK
                    end
                end
            end
        end
    end
    if data.coinPrice > 0 and getCoins() < data.coinPrice then
        return BUY_RESULT.NO_COINS
    end
    local serverKey  = _resolveServerKey(data)
    local coinBefore = getCoins()
    local existingTools = {}
    local function snapshotTools(container)
        if not container then return end
        for _, v in pairs(container:GetChildren()) do
            if v:IsA("Tool") then existingTools[v] = true end
        end
    end
    local backpack = player:FindFirstChild("Backpack")
    local char     = player.Character
    snapshotTools(backpack)
    snapshotTools(char)
    local received  = false
    local resultMsg = ""
    local conns     = {}
    local function onToolAdded(v)
        if not v:IsA("Tool") then return end
        if existingTools[v] then return end
        received = true
    end
    if backpack then table.insert(conns, backpack.ChildAdded:Connect(onToolAdded)) end
    if char     then table.insert(conns, char.ChildAdded:Connect(onToolAdded)) end
    local notifRE = ReplicatedStorage:FindFirstChild("Events")
        and ReplicatedStorage.Events:FindFirstChild("Notification")
    if notifRE then
        table.insert(conns, notifRE.OnClientEvent:Connect(function(msg)
            if type(msg) == "string" and msg ~= "" and resultMsg == "" then
                resultMsg = msg
            end
        end))
    end
    if gearKey:sub(1, 3) == "LB_" then
        local rarityName = data.displayName:match("^(.+) Lucky Block$") or ""
        local variants = {
            rarityName .. " Lucky Block (World)",
            rarityName .. " Lucky Block",
            rarityName .. " LuckyBlock",
            rarityName .. "LuckyBlock",
            rarityName .. " Lucky Block World",
            (rarityName .. " Lucky Block (World)"):lower(),
            (rarityName .. " Lucky Block"):lower(),
            (rarityName .. " LuckyBlock"):lower(),
            rarityName:lower() .. "_lucky_block",
            rarityName:lower() .. "luckyblock",
            "Purchase " .. rarityName .. " Lucky Block",
            "Buy " .. rarityName .. " Lucky Block",
            "Lucky Block " .. rarityName,
            ("Lucky Block " .. rarityName):lower(),
            data.serverKey,
            data.serverKey:lower(),
        }
        local fired = {}
        for _, v in ipairs(variants) do
            if v ~= "" and not fired[v] then
                fired[v] = true
                pcall(function() remote:FireServer(v) end)
                task.wait(0.05)
            end
        end
    else
        pcall(function() remote:FireServer(serverKey) end)
    end
    local waited = 0
    while waited < 5 and not received and resultMsg == "" do
        task.wait(0.2)
        waited = waited + 0.2
        local function scanNew(container)
            if not container then return end
            for _, v in pairs(container:GetChildren()) do
                if v:IsA("Tool") and not existingTools[v] then
                    received = true
                end
            end
        end
        scanNew(backpack)
        scanNew(char)
    end
    for _, c in pairs(conns) do pcall(function() c:Disconnect() end) end
    if received then
        _resolvedKeys[data.displayName:lower()] = serverKey
        Rayfield:Notify({ Title = "✅ Purchased!", Content = data.displayName, Duration = 3, Image = 4483362458 })
        return BUY_RESULT.SUCCESS
    end
    if data.coinPrice > 0 and getCoins() < coinBefore then
        _resolvedKeys[data.displayName:lower()] = serverKey
        Rayfield:Notify({ Title = "✅ Purchased!", Content = data.displayName, Duration = 3, Image = 4483362458 })
        return BUY_RESULT.SUCCESS
    end
    local m = resultMsg:lower()
    if m:find("out of stock") or m:find("sold out") or (m:find("out") and m:find("stock")) then
        _writeStock(data.displayName, false, 0, true)
        _writeStock(data.serverKey,   false, 0, true)
        return BUY_RESULT.OUT_OF_STOCK
    elseif m:find("not enough") or m:find("afford") or (m:find("coin") and not m:find("stock")) then
        return BUY_RESULT.NO_COINS
    elseif m:find("success") or m:find("purchas") or m:find("bought") then
        _resolvedKeys[data.displayName:lower()] = serverKey
        Rayfield:Notify({ Title = "✅ Purchased!", Content = data.displayName, Duration = 3, Image = 4483362458 })
        return BUY_RESULT.SUCCESS
    end
    if data.coinPrice == 0 and resultMsg == "" and gearKey:sub(1,3) ~= "LB_" then
        _resolvedKeys[data.displayName:lower()] = serverKey
        Rayfield:Notify({ Title = "✅ Purchased!", Content = data.displayName, Duration = 3, Image = 4483362458 })
        return BUY_RESULT.SUCCESS
    end
    return BUY_RESULT.NOT_IN_SHOP
end
local function applyJumpFix(hum)
    if not hum then return end
    local function enforce()
        if hum.Health <= 0 then return end
        hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        if not S.jumpEnabled and hum.JumpPower <= 0 then
            hum.JumpPower = 50
        end
    end
    enforce()
    hum:GetPropertyChangedSignal("JumpPower"):Connect(enforce)
end
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid  = char:WaitForChild("Humanoid")
    rootPart  = char:WaitForChild("HumanoidRootPart")
    S.grabLock          = false
    S.grabLockTime      = 0
    _cache.GF         = nil
    _cache.Brainrots  = nil
    _cache.Plots      = nil
    _cachedSubmitPart = nil
    pcall(function() getgenv().OxyoExecQueued = false end)
    task.wait(0.5)
    if humanoid then
        applyJumpFix(humanoid)
        if S.speedEnabled then humanoid.WalkSpeed = S.currentSpeed end
        if S.jumpEnabled  then humanoid.JumpPower  = S.currentJumpPower end
    end
    if S.flyEnabled then task.wait(0.3) startFlySystem() end
    if S.noclipEnabled then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    if S.lavaRemoved then
        S.lavaRemoved = false
        task.wait(0.5)
        hideLava()
    elseif isAnyHopActive() then
        task.wait(0.5)
        hideLava()
    end
    if getgenv().OxyoVolcanoAutoSubmitOnArrival then
        getgenv().OxyoVolcanoAutoSubmitOnArrival = false
        task.delay(3, function()
            pcall(function()
                if Rayfield then
                    Rayfield:Notify({
                        Title   = "🌋 Auto Submit",
                        Content = "Arrived! Activating Auto Volcano Submit...",
                        Duration = 3,
                        Image   = 4483362458,
                    })
                end
                S.volcanoEnabled = true
                local flag = Rayfield and Rayfield.Flags and Rayfield.Flags["AutoVolcano"]
                if flag then flag:Set(true) end
            end)
        end)
    end
    if S.collectorRunning and S.selectedRarities and #S.selectedRarities > 0 then
        task.wait(1)
        if S.collectorRunning then
            stopFarmLoop()
            task.wait(0.2)
            startFarm(S.selectedRarities)
        end
    end
    if S.autoNameEnabled and S.farmByNameFilter ~= "" then
        task.wait(1)
        if S.autoNameEnabled then
            if S.autoNameThread then pcall(task.cancel, S.autoNameThread) S.autoNameThread = nil end
            S.autoNameThread = task.spawn(function()
                while S.autoNameEnabled do
                    if S.grabLock then task.wait(0.2) continue end
                    local snapshot = monitorData.brainrots
                    local collected = false
                    for _, entry in ipairs(snapshot) do
                        if not S.autoNameEnabled then break end
                        if S.grabLock then break end
                        if entry.obj and entry.obj.Parent and passesByNameFilter(entry.obj) then
                            collected = true
                            local e = entry
                            pcall(function() collectOne(e.rarity, e.obj) end)
                            task.wait(0.5)
                            break
                        end
                    end
                    if not collected then task.wait(1) end
                end
            end)
        end
    end
    initTraitHook()
end)
pcall(function()
    if humanoid then applyJumpFix(humanoid) end
end)
UserInputService.JumpRequest:Connect(function()
    pcall(function()
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        if S.infinityJumpEnabled then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end)
startMonitor()
initTraitHook()
local _errorCount = 0
local _errorLog   = {}
task.spawn(function()
    task.wait(45)
    while true do
        task.wait(45)
        pcall(function()
            if not monitorData.isRunning then
                monitorData.isRunning = false
                startMonitor()
            end
            if S.collectorRunning and not S.collectorThread then
                if S.selectedRarities and #S.selectedRarities > 0 then
                    startFarm(S.selectedRarities)
                end
            end
            if S.autoCoinEnabled and not coinCollectThread and not coinEventActive then
                startCoinTracker()
            end
            if _aquaRunning and not _aquaThread then
                pcall(_startAquaLoop)
            end
        end)
    end
end)
task.spawn(function()
    while true do
        task.wait(600)
        pcall(function()
            _eventWatcherSent = {}
            _webhookSeenBrainrots = {}
            _cache.GF       = nil
            _cache.Brainrots = nil
            _cache.Plots    = nil
            _cachedSubmitPart = nil
        end)
    end
end)
if _hasAdvancedAPI then
    task.defer(function()
        pcall(function()
            local mt = getrawmetatable(game)
            local oldNC = rawget(mt, "__namecall")
            if not oldNC then return end
            setreadonly(mt, false)
            local _BAN_KEYS = {
                "kick","ban","anticheat","cheat","exploit","hack",
                "flag","suspend","report","detect","punish","terminate",
                "sanction","infraction","violation","blacklist","teleportkick",
                "forcedisconnect","forcekick","remotekick",
            }
            mt.__namecall = newcclosure(function(self, ...)
                local isCaller = typeof(checkcaller) == "function" and checkcaller()
                if isCaller then return oldNC(self, ...) end
                local ok, method = pcall(getnamecallmethod)
                if not ok then return oldNC(self, ...) end
                if method == "Kick" then return end
                if method == "FireServer" or method == "InvokeServer" then
                    local args = {...}
                    local s1 = typeof(args[1]) == "string" and args[1]:lower() or ""
                    local s2 = typeof(args[2]) == "string" and args[2]:lower() or ""
                    for _, kw in ipairs(_BAN_KEYS) do
                        if s1:find(kw, 1, true) or s2:find(kw, 1, true) then return end
                    end
                end
                if method == "FireClient" or method == "FireAllClients" then
                    return
                end
                return oldNC(self, ...)
            end)
            setreadonly(mt, true)
            task.spawn(function()
                while true do
                    task.wait(math.random(45, 75))
                    pcall(function()
                        local mt2 = getrawmetatable(game)
                        if not mt2 then return end
                        local cur = rawget(mt2, "__namecall")
                        if cur ~= mt.__namecall then
                            setreadonly(mt2, false)
                            mt2.__namecall = mt.__namecall
                            setreadonly(mt2, true)
                        end
                    end)
                end
            end)
        end)
    end)
end
do
    local _lastActivity = tick()
    if getgenv().OxyoAutoSafe == nil then
        getgenv().OxyoAutoSafe = true
    end
    local function _doAntiAfk()
        if not getgenv().OxyoAutoSafe then return end
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        pcall(function()
            local pg = Players.LocalPlayer:FindFirstChild("PlayerGui")
            if pg then
                game:GetService("GuiService").SelectedObject = nil
            end
        end)
        _lastActivity = tick()
    end
    Players.LocalPlayer.Idled:Connect(function()
        _doAntiAfk()
    end)
    task.spawn(function()
        while true do
            local hopActive = getgenv().OxyoAutoHopCoin
                or getgenv().OxyoAutoHopGodly
                or getgenv().OxyoAutoHopCel
                or getgenv().OxyoAutoHopFrag
            local interval = hopActive and 20 or 55
            task.wait(interval)
            if tick() - _lastActivity >= interval then
                _doAntiAfk()
            end
        end
    end)
    task.spawn(function()
        while true do
            task.wait(90)
            if getgenv().OxyoAutoSafe then
                pcall(function()
                    game:GetService("GuiService").SelectedObject = nil
                end)
            end
        end
    end)
end
task.spawn(function()
    while true do
        task.wait(5)
        if S.grabLock and (tick() - S.grabLockTime) > 8 then
            S.grabLock     = false
            S.grabLockTime = 0
        end
        if S.collectorRunning and not S.collectorThread then
            if S.selectedRarities and #S.selectedRarities > 0 then
                startFarm(S.selectedRarities)
            end
        end
        if S.autoNameEnabled and not S.autoNameThread and S.farmByNameFilter ~= "" then
            S.autoNameThread = task.spawn(function()
                while S.autoNameEnabled do
                    if S.grabLock then task.wait(0.2) continue end
                    local snapshot = monitorData.brainrots
                    local collected = false
                    for _, entry in ipairs(snapshot) do
                        if not S.autoNameEnabled then break end
                        if S.grabLock then break end
                        if entry.obj and entry.obj.Parent and passesByNameFilter(entry.obj) then
                            collected = true
                            local e = entry
                            pcall(function() collectOne(e.rarity, e.obj) end)
                            task.wait(0.5)
                            break
                        end
                    end
                    if not collected then task.wait(1) end
                end
            end)
        end
        if S.volcanoEnabled and not S.volcanoThread then
            Rayfield:Notify({ Title = "🌋 Volcano", Content = "Watchdog: restarting...", Duration = 3, Image = 4483362458 })
            S.volcanoThread = task.spawn(function()
                while S.volcanoEnabled do
                    local reqName, reqMut = getRequiredVolcanoBrainrot()
                    if not reqName then task.wait(3) continue end
                    local obj = findVolcanoTarget(reqName, reqMut)
                    if not obj then task.wait(3) continue end
                    pcall(grabBrainrot, obj)
                    task.wait(0.4)
                    pcall(submitToVolcano)
                    task.wait(1)
                end
            end)
        end
    end
end)
do
    local _noclipParts = {}
    local _noclipChar  = nil
    task.spawn(function()
        while true do
            if not S.noclipEnabled then task.wait(1) continue end
            task.wait(0.5)
            local curChar = player.Character
            if not curChar then continue end
            if curChar ~= _noclipChar then
                _noclipChar  = curChar
                _noclipParts = {}
                for _, part in pairs(curChar:GetDescendants()) do
                    if part:IsA("BasePart") then table.insert(_noclipParts, part) end
                end
            end
            for _, part in ipairs(_noclipParts) do
                if part and part.Parent then part.CanCollide = false end
            end
        end
    end)
end
task.spawn(function()
    while true do
        if not S.speedEnabled and not S.jumpEnabled then
            task.wait(1)
            continue
        end
        task.wait(0.5)
        pcall(function()
            local hum = character and character:FindFirstChild("Humanoid")
            if not hum then return end
            if S.speedEnabled then hum.WalkSpeed = S.currentSpeed end
            if S.jumpEnabled  then hum.JumpPower  = S.currentJumpPower end
        end)
    end
end)
task.spawn(function()
    while true do
        if not S.hitboxEnabled then task.wait(2) continue end
        task.wait(0.5)
        for _, v in next, Players:GetPlayers() do
            if v ~= player then
                pcall(function()
                    local root = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.Size         = Vector3.new(S.hitboxSize, S.hitboxSize, S.hitboxSize)
                        root.Transparency = S.hitboxTransp
                        root.BrickColor   = S.hitboxColor
                        root.Material     = Enum.Material.Neon
                        root.CanCollide   = false
                    end
                end)
            end
        end
    end
end)
MainTab:CreateSection("Remove Objects")
local _removeLavaConn = nil
MainTab:CreateToggle({
    Name         = "🌋 Remove Lava",
    CurrentValue = false,
    Flag         = "RemoveLava",
    Callback     = function(v)
        if v then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name == "Lavas" or obj.Name == "Lava" then
                    pcall(function() obj:Destroy() end)
                end
            end
            S.lavaRemoved = true
            if _removeLavaConn then _removeLavaConn:Disconnect() end
            _removeLavaConn = workspace.DescendantAdded:Connect(function(obj)
                if obj.Name == "Lavas" or obj.Name == "Lava" then
                    task.defer(function() pcall(function() obj:Destroy() end) end)
                end
            end)
            Rayfield:Notify({ Title = "🌋 Remove Lava", Content = "ON — lava removed.", Duration = 3, Image = 4483362458 })
        else
            if _removeLavaConn then _removeLavaConn:Disconnect() _removeLavaConn = nil end
            S.lavaRemoved = false
            Rayfield:Notify({ Title = "🌋 Remove Lava", Content = "OFF — lava returns next round.", Duration = 3, Image = 4483362458 })
        end
    end,
})
MainTab:CreateToggle({
    Name         = "🔒 Lock Lava (prevent auto-enable)",
    CurrentValue = false,
    Flag         = "LockAutoLava",
    Callback     = function(v)
        S.preventAutoLava = v
    end,
})
MainTab:CreateButton({
    Name     = "Remove VIP Walls",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "VIPDoors" or v.Name == "VIPDoor" or v.Name == "VIPWall" then
                pcall(function() v:Destroy() end)
            end
        end
    end,
})
MainTab:CreateButton({
    Name     = "Remove Killbricks",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                local name = v.Name:lower()
                if name:find("kill") or name:find("damage") or name:find("death") or
                   name:find("void") or name:find("lava") or
                   v.BrickColor == BrickColor.new("Really red") then
                    pcall(function() v:Destroy() end)
                end
            end
        end
    end,
})
MainTab:CreateSection("My Plot")
MainTab:CreateButton({
    Name     = "Teleport to My Plot",
    Callback = function()
        local ok = teleportToMyPlot()
        if not ok then
            Rayfield:Notify({ Title = "Plot", Content = "Could not find your plot.", Duration = 3, Image = 4483362458 })
        end
    end,
})
MainTab:CreateSection("Utilities")
MainTab:CreateButton({
    Name     = "Reset Config",
    Callback = function()
        local togglesOff = {
            "InstantGrab","NoClip","SpeedEnabled","JumpEnabled","InfinityJump",
            "AutoMeteor","AutoLuckyBlock","AutoSpinWheel","AutoFarmToggle",
            "AutoFarmNameToggle","AutoMoney","AutoCoin","AutoHopCoin",
            "AutoUpgrade","AutoSell","MutationAlert","AutoBuyGear","AutoBuyLB",
            "HitboxToggle","FullBright",
            "InfiniteZoom","PlayerESP","CelestialESP",
        }
        local slidersDefault = {
            SpeedSlider = 16, JumpSlider = 50, FlySpeed = 1,
            MaxCarrySlider = 1, SellThreshold = 50, SellTimerInterval = 0,
            HitboxSize = 50, HitboxTransp = 7, FragUpgradeSecs = 50,
        }
        local dropdownsDefault = {
            RarityDropdown = {}, MutationDropdown = {}, TraitDropdown = {},
            LuckyBlockType = {"All"}, LuckyTraitDropdown = {}, HitboxColor = {"Really blue"},
            GearDropdown = {}, GearMultiDropdown = {}, MutationAlertDropdown = {},
        }
        pcall(function()
            if writefile then writefile("OxyoHub/oxyoHub_v6.json", "{}") end
        end)
        for _, flag in ipairs(togglesOff) do
            pcall(function()
                if Rayfield.Flags[flag] then
                    Rayfield.Flags[flag]:Set(false)
                end
            end)
        end
        for flag, val in pairs(slidersDefault) do
            pcall(function()
                if Rayfield.Flags[flag] then
                    Rayfield.Flags[flag]:Set(val)
                end
            end)
        end
        for flag, val in pairs(dropdownsDefault) do
            pcall(function()
                if Rayfield.Flags[flag] then
                    Rayfield.Flags[flag]:Set(val)
                end
            end)
        end
        pcall(function() Rayfield:ResetConfiguration() end)
        task.wait(0.3)
        pcall(function() Rayfield:SaveConfiguration() end)
        Rayfield:Notify({ Title = "Config Reset", Content = "All settings reset to default.", Duration = 3, Image = 4483362458 })
    end,
})
MainTab:CreateButton({
    Name     = "Rejoin Server",
    Callback = function()
        task.wait(1)
        doTeleport(game.JobId)
    end,
})
MainTab:CreateButton({
    Name     = "Server Hop",
    Callback = function()
        nuclearStop()
        getgenv().OxyoHopStopped = false
        getgenv().OxyoAutoHopCoin = false
        getgenv().OxyoAutoHopGodly = false
        getgenv().OxyoAutoHopCel = false
        getgenv().OxyoAutoHopFrag = false
        getgenv().OxyoManualHop = true
        task.wait(0.5)
        local servers = {}
        local ok, result = pcall(function() return game:HttpGet("https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100") end)
        if ok and result then
            pcall(function()
                local data = game:GetService("HttpService"):JSONDecode(result)
                if data and data.data then
                    for _, sv in pairs(data.data) do
                        if sv.id ~= game.JobId and sv.playing < sv.maxPlayers then
                            table.insert(servers, sv.id)
                        end
                    end
                end
            end)
        end
        if #servers > 0 then
            local picked = servers[math.random(1, #servers)]
            local ok = pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, picked, Players.LocalPlayer) end)
            if not ok then
                task.wait(2)
                pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[1], Players.LocalPlayer) end)
            end
        else
            Rayfield:Notify({ Title = "Server Hop", Content = "No servers found, retrying...", Duration = 3, Image = 4483362458 })
            task.wait(3)
            pcall(function() TeleportService:Teleport(game.PlaceId, Players.LocalPlayer) end)
        end
        task.delay(5, function() getgenv().OxyoManualHop = false end)
    end,
})
MainTab:CreateSection("Click Teleport")
do
    local _clickTpEnabled = false
    local _clickTpConn = nil
    MainTab:CreateToggle({
        Name         = "Click Teleport",
        CurrentValue = false,
        Flag         = "ClickTeleport",
        Callback     = function(val)
            _clickTpEnabled = val
            if val then
                _clickTpConn = UserInputService.InputBegan:Connect(function(input, gpe)
                    if gpe then return end
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        local char = Players.LocalPlayer.Character
                        local root = char and char:FindFirstChild("HumanoidRootPart")
                        if not root then return end
                        local cam = workspace.CurrentCamera
                        local ray
                        if input.UserInputType == Enum.UserInputType.Touch then
                            local pos = input.Position
                            ray = cam:ScreenPointToRay(pos.X, pos.Y)
                        else
                            local mpos = UserInputService:GetMouseLocation()
                            ray = cam:ScreenPointToRay(mpos.X, mpos.Y)
                        end
                        local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, RaycastParams.new())
                        if result then
                            hideLava()
                            root.CFrame = CFrame.new(result.Position + Vector3.new(0, 3, 0))
                        end
                    end
                end)
                Rayfield:Notify({ Title = "Click Teleport", Content = "ON — tap/click to teleport!", Duration = 2, Image = 4483362458 })
            else
                if _clickTpConn then _clickTpConn:Disconnect() _clickTpConn = nil end
                Rayfield:Notify({ Title = "Click Teleport", Content = "OFF", Duration = 2, Image = 4483362458 })
            end
        end,
    })
end

MainTab:CreateSection("Instant Grab")
MainTab:CreateToggle({
    Name         = "Instant Grab",
    CurrentValue = false,
    Flag         = "InstantGrab",
    Callback     = function(Value)
        S.instantGrabEnabled = Value
        if Value then
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    if not S.OriginalHoldTimes[v] then S.OriginalHoldTimes[v] = v.HoldDuration end
                    v.HoldDuration = 0
                end
            end
            S.instantGrabConnection = workspace.DescendantAdded:Connect(function(v)
                if v:IsA("ProximityPrompt") then
                    if not S.OriginalHoldTimes[v] then S.OriginalHoldTimes[v] = v.HoldDuration end
                    v.HoldDuration = 0
                end
            end)
        else
            if S.instantGrabConnection then
                S.instantGrabConnection:Disconnect()
                S.instantGrabConnection = nil
            end
            for prompt, originalTime in pairs(S.OriginalHoldTimes) do
                if prompt and prompt.Parent then prompt.HoldDuration = originalTime end
            end
            S.OriginalHoldTimes = {}
        end
    end,
})
MainTab:CreateSection("Movement")
MainTab:CreateToggle({
    Name         = "NoClip",
    CurrentValue = false,
    Flag         = "NoClip",
    Callback     = function(Value) S.noclipEnabled = Value end,
})
MainTab:CreateSection("Player")
MainTab:CreateToggle({
    Name         = "Speed On/Off",
    CurrentValue = false,
    Flag         = "SpeedEnabled",
    Callback     = function(Value)
        S.speedEnabled = Value
        pcall(function()
            if character and character:FindFirstChild("Humanoid") then
                if S.speedEnabled then
                    S.originalSpeed = character.Humanoid.WalkSpeed
                    character.Humanoid.WalkSpeed = S.currentSpeed
                else
                    character.Humanoid.WalkSpeed = S.originalSpeed or getGameSpeed()
                    S.originalSpeed = nil
                end
            end
        end)
    end,
})
MainTab:CreateSlider({
    Name         = "Walk Speed",
    Range        = {16, 200},
    Increment    = 1,
    Suffix       = "Speed",
    CurrentValue = 16,
    Flag         = "SpeedSlider",
    Callback     = function(Value)
        S.currentSpeed = Value
        if S.speedEnabled then
            pcall(function()
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid.WalkSpeed = S.currentSpeed
                end
            end)
        end
    end,
})
MainTab:CreateToggle({
    Name         = "Jump Power On/Off",
    CurrentValue = false,
    Flag         = "JumpEnabled",
    Callback     = function(Value)
        S.jumpEnabled = Value
        pcall(function()
            if character and character:FindFirstChild("Humanoid") then
                if S.jumpEnabled then
                    S.originalJump = character.Humanoid.JumpPower
                    character.Humanoid.JumpPower = S.currentJumpPower
                else
                    character.Humanoid.JumpPower = S.originalJump or getGameJump()
                    S.originalJump = nil
                end
            end
        end)
    end,
})
MainTab:CreateSlider({
    Name         = "Jump Power",
    Range        = {50, 300},
    Increment    = 1,
    Suffix       = "Power",
    CurrentValue = 50,
    Flag         = "JumpSlider",
    Callback     = function(Value)
        S.currentJumpPower = Value
        if S.jumpEnabled then
            pcall(function()
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid.JumpPower = S.currentJumpPower
                end
            end)
        end
    end,
})
MainTab:CreateToggle({
    Name         = "Infinity Jump",
    CurrentValue = false,
    Flag         = "InfinityJump",
    Callback     = function(Value) S.infinityJumpEnabled = Value end,
})
MainTab:CreateSection("Fly")
MainTab:CreateToggle({
    Name         = "Enable Fly  (Q = Up | E = Down)",
    CurrentValue = false,
    Callback     = function(Value)
        S.flyEnabled = Value
        if Value then startFlySystem() else stopFlySystem() end
    end,
})
MainTab:CreateSlider({
    Name         = "Fly Speed",
    Range        = {1, 10},
    Increment    = 1,
    Suffix       = "x",
    CurrentValue = 1,
    Flag         = "FlySpeed",
    Callback     = function(Value)
        S.speeds = Value
    end,
})
MainTab:CreateSection("Duplicate Brainrot")
MainTab:CreateButton({
    Name     = "Duplicate Equipped Brainrot",
    Callback = function()
        local success, msg = duplicateEquipped()
        Rayfield:Notify({ Title = "Duplicate", Content = msg, Duration = 3, Image = 4483362458 })
    end,
})
CollectorTab:CreateSection("Auto Meteor")
local showStopHopGui
local nuclearStop
;(function()
CollectorTab:CreateToggle({
    Name         = "Auto Teleport to Meteor",
    CurrentValue = false,
    Flag         = "AutoMeteor",
    Callback     = function(Value)
        auto.meteorEnabled = Value
        if Value then
            hideLava()
            auto.meteorThread = task.spawn(function()
                while auto.meteorEnabled do
                    pcall(function()
                        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                        if not root then return end
                        local bestMeteor, bestDist = nil, math.huge
                        for _, obj in ipairs(workspace:GetChildren()) do
                            if obj.Name == "Meteor" then
                                local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                                if part then
                                    local dist = (part.Position - root.Position).Magnitude
                                    if dist < bestDist then
                                        bestMeteor = part
                                        bestDist   = dist
                                    end
                                end
                            end
                        end
                        if bestMeteor then
                            local vel = bestMeteor.AssemblyLinearVelocity
                            local pos = bestMeteor.Position
                            local landPos
                            if vel and vel.Y < -1 then
                                local t = math.max(0, (pos.Y - 5) / (-vel.Y))
                                landPos = Vector3.new(pos.X + vel.X * t, 5, pos.Z + vel.Z * t)
                            else
                                landPos = Vector3.new(pos.X, pos.Y + 3, pos.Z)
                            end
                            root.CFrame = CFrame.new(landPos)
                        end
                    end)
                    task.wait(0.35)
                end
            end)
        else
            if auto.meteorThread then pcall(task.cancel, auto.meteorThread) auto.meteorThread = nil end
        end
    end,
})
CollectorTab:CreateSection("Auto Lucky Block")
local _luckyOpts = { "All" }
for _, t in ipairs(LUCKY_TYPES) do
    if t ~= "LuckyBlock" then table.insert(_luckyOpts, t) end
end
CollectorTab:CreateDropdown({
    Name          = "Block Type",
    Options       = _luckyOpts,
    CurrentOption = { "All" },
    Flag          = "LuckyBlockType",
    Callback      = function(opt)
        auto.luckyType = type(opt) == "table" and opt[1] or opt
    end,
})
CollectorTab:CreateDropdown({
    Name            = "Trait Filter  (empty = all)",
    Options         = ALL_TRAITS,
    CurrentOption   = {},
    MultipleOptions = true,
    Flag            = "LuckyTraitDropdown",
    Callback        = function(Options) auto.luckyTraits = Options end,
})
CollectorTab:CreateToggle({
    Name         = "Auto Lucky Block",
    CurrentValue = false,
    Flag         = "AutoLuckyBlock",
    Callback     = function(Value)
        auto.luckyEnabled = Value
        if Value then
            hideLava()
            local gf = workspace:FindFirstChild("GameFolder")
            local lb = gf and gf:FindFirstChild("LuckyBlocks")
            if not lb then
                Rayfield:Notify({ Title = "Auto Lucky Block", Content = "LuckyBlocks folder not found!", Duration = 4, Image = 4483362458 })
                auto.luckyEnabled = false
                return
            end
            for _, block in ipairs(lb:GetChildren()) do
                task.spawn(tryFireBlock, block)
            end
            if auto.luckyConn then auto.luckyConn:Disconnect() end
            auto.luckyConn = lb.ChildAdded:Connect(function(block)
                if auto.luckyEnabled then
                    task.wait(0.5)
                    task.spawn(tryFireBlock, block)
                end
            end)
            task.spawn(function()
                while auto.luckyEnabled do
                    task.wait(2)
                    pcall(function()
                        for _, block in ipairs(lb:GetChildren()) do
                            if not auto.luckyEnabled then break end
                            local pp = block:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if pp and isValidPos(pp.Parent.Position) and shouldFireLucky(block.Name) then
                                task.spawn(tryFireBlock, block)
                            end
                        end
                    end)
                end
            end)
        else
            if auto.luckyConn then auto.luckyConn:Disconnect() auto.luckyConn = nil end
        end
    end,
})
CollectorTab:CreateSection("Auto Spin Wheel")
CollectorTab:CreateToggle({
    Name         = "Auto Spin Wheel",
    CurrentValue = false,
    Flag         = "AutoSpinWheel",
    Callback     = function(Value)
        auto.spinEnabled = Value
        if Value then
            auto.spinThread = task.spawn(function()
                local _spinRemote = nil
                pcall(function()
                    _spinRemote = ReplicatedStorage
                        :WaitForChild("Remotes", 5)
                        :WaitForChild("SpinWheel", 5)
                        :WaitForChild("RequestSpin", 5)
                end)
                local _spinRefresh = 0
            while auto.spinEnabled do
                    if tick() - _spinRefresh > 60 then
                        pcall(function()
                            _spinRemote = ReplicatedStorage
                                :WaitForChild("Remotes", 3)
                                :WaitForChild("SpinWheel", 3)
                                :WaitForChild("RequestSpin", 3)
                        end)
                        _spinRefresh = tick()
                    end
                    if _spinRemote and _spinRemote.Parent then
                        pcall(function() _spinRemote:FireServer() end)
                    end
                    task.wait(0.76)
                end
            end)
        else
            if auto.spinThread then pcall(task.cancel, auto.spinThread) auto.spinThread = nil end
        end
    end,
})
CollectorTab:CreateSection("Filters")
CollectorTab:CreateDropdown({
    Name            = "Select Rarities",
    Options         = {"Common","Rare","Epic","Legendary","Mythic","Secret","Celestial","Godly","Forbidden"},
    CurrentOption   = {},
    MultipleOptions = true,
    Flag            = "RarityDropdown",
    Callback        = function(Options) S.selectedRarities = Options end,
})
CollectorTab:CreateDropdown({
    Name            = "Select Mutations  (empty = all)",
    Options         = {"Gold","Emerald","Diamond","Bloodmoon","Rainbow","Aqua"},
    CurrentOption   = {},
    MultipleOptions = true,
    Flag            = "MutationDropdown",
    Callback        = function(Options) S.selectedMutations = Options end,
})
CollectorTab:CreateDropdown({
    Name            = "Select Traits  (empty = all)",
    Options         = ALL_TRAITS,
    CurrentOption   = {},
    MultipleOptions = true,
    Flag            = "TraitDropdown",
    Callback        = function(Options) S.selectedTraits = Options end,
})
CollectorTab:CreateSection("Carry Settings")
CollectorTab:CreateSlider({
    Name         = "Max Carry",
    Range        = {1, 6},
    Increment    = 1,
    Suffix       = "Brainrots",
    CurrentValue = 1,
    Flag         = "MaxCarrySlider",
    Callback     = function(Value)
        S.maxCarry = Value
    end,
})
CollectorTab:CreateSection("Auto Collector")
CollectorTab:CreateToggle({
    Name         = "Start Auto Farm",
    CurrentValue = false,
    Flag         = "AutoFarmToggle",
    Callback     = function(Value)
        if Value then
            task.spawn(function()
                task.wait(0.3)
                if not (Rayfield.Flags["AutoFarmToggle"] and Rayfield.Flags["AutoFarmToggle"].CurrentValue) then return end
                if #S.selectedRarities == 0 then
                    local flagRarities = Rayfield.Flags["RarityDropdown"] and Rayfield.Flags["RarityDropdown"].CurrentOption
                    if type(flagRarities) == "table" and #flagRarities > 0 then
                        S.selectedRarities = flagRarities
                    end
                end
                if #S.selectedRarities == 0 then
                    Rayfield:Notify({ Title = "Auto Farm", Content = "Select at least one Rarity first!", Duration = 4, Image = 4483362458 })
                    pcall(function() if Rayfield.Flags["AutoFarmToggle"] then Rayfield.Flags["AutoFarmToggle"]:Set(false) end end)
                    return
                end
                hideLava()
                local plot = getPlayerPlot()
                if plot then attachPlotCounter(plot) end
                startFarm(S.selectedRarities)
            end)
        else
            stopFarmLoop()
        end
    end,
})
CollectorTab:CreateSection("Farm by Name")
CollectorTab:CreateInput({
    Name                    = "Brainrot Name",
    PlaceholderText         = "e.g. BrrBrr",
    RemoveTextAfterFocusLost = false,
    Flag                    = "FarmByNameInput",
    Callback                = function(Value) S.farmByNameFilter = Value or "" end,
})
CollectorTab:CreateButton({
    Name     = "Farm Selected Brainrot  (one pass)",
    Callback = function()
        if S.farmByNameFilter == "" then
            Rayfield:Notify({ Title = "Farm by Name", Content = "Type a Brainrot name first!", Duration = 4, Image = 4483362458 })
            return
        end
        pcall(scanWorld)
        local found = false
        for _, entry in ipairs(monitorData.brainrots) do
            if entry.obj and entry.obj.Parent and passesByNameFilter(entry.obj) then
                found = true
                Rayfield:Notify({ Title = "Found!", Content = entry.name .. " (" .. entry.rarity .. ") — collecting...", Duration = 3, Image = 4483362458 })
                local e = entry
                task.spawn(function() pcall(function() collectOne(e.rarity, e.obj) end) end)
                break
            end
        end
        if not found then
            Rayfield:Notify({ Title = "Not Spawned", Content = "\"" .. S.farmByNameFilter .. "\" not found in world.", Duration = 4, Image = 4483362458 })
        end
    end,
})
CollectorTab:CreateToggle({
    Name         = "Auto Farm Selected Brainrot  (monitor)",
    CurrentValue = false,
    Flag         = "AutoFarmNameToggle",
    Callback     = function(Value)
        S.autoNameEnabled = Value
        if Value then
            hideLava()
            if S.farmByNameFilter == "" then
                Rayfield:Notify({ Title = "Auto Farm by Name", Content = "Type a Brainrot name first!", Duration = 4, Image = 4483362458 })
                S.autoNameEnabled = false
                pcall(function() if Rayfield.Flags["AutoFarmNameToggle"] then Rayfield.Flags["AutoFarmNameToggle"]:Set(false) end end)
                return
            end
            S.autoNameThread = task.spawn(function()
                while S.autoNameEnabled do
                    if S.grabLock then task.wait(0.2) continue end
                    local snapshot = monitorData.brainrots
                    local collected = false
                    for _, entry in ipairs(snapshot) do
                        if not S.autoNameEnabled then break end
                        if S.grabLock then break end
                        if entry.obj and entry.obj.Parent and passesByNameFilter(entry.obj) then
                            collected = true
                            local e = entry
                            pcall(function() collectOne(e.rarity, e.obj) end)
                            task.wait(0.5)
                            break
                        end
                    end
                    if not collected then task.wait(1) end
                end
            end)
        else
            if S.autoNameThread then pcall(task.cancel, S.autoNameThread) S.autoNameThread = nil end
        end
    end,
})
CollectorTab:CreateSection("Auto Money")
CollectorTab:CreateToggle({
    Name         = "Auto Collect Money",
    CurrentValue = false,
    Flag         = "AutoMoney",
    Callback     = function(Value)
        auto.moneyEnabled = Value
        if Value then
            auto.moneyThread = task.spawn(function()
                while auto.moneyEnabled do
                    pcall(function()
                        local gf = workspace:FindFirstChild("GameFolder")
                        local plots = gf and gf:FindFirstChild("Plots")
                        if not plots then return end
                        for _, plot in pairs(plots:GetChildren()) do
                            local brainrots = plot:FindFirstChild("Brainrots")
                            if not brainrots then continue end
                            for _, br in pairs(brainrots:GetChildren()) do
                                local ok, owner = pcall(function() return br:GetAttribute("Owner") end)
                                if ok and owner and tostring(owner) == tostring(player.UserId) then
                                    local places = plot:FindFirstChild("Places")
                                    if places then
                                        for _, place in pairs(places:GetChildren()) do
                                            local claim = place:FindFirstChild("Claim")
                                            if claim and claim:IsA("BasePart") then
                                                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                                                if root then
                                                    _firetouchinterest(root, claim, 0)
                                                    task.wait(0.05)
                                                    _firetouchinterest(root, claim, 1)
                                                    task.wait(0.1)
                                                end
                                            end
                                        end
                                    end
                                    break
                                end
                            end
                        end
                    end)
                    task.wait(3)
                end
            end)
        else
            if auto.moneyThread then pcall(task.cancel, auto.moneyThread) auto.moneyThread = nil end
        end
    end,
})
CollectorTab:CreateSection("Auto Coin")
local coinEventActive   = false
local coinCollectThread = nil
local _liveCoinParts  = {}
local _coinAddedConns = {}

local function startCoinTracker()
    for _, c in pairs(_coinAddedConns) do pcall(function() c:Disconnect() end) end
    _coinAddedConns = {}
    _liveCoinParts  = {}
    local CS = game:GetService("CollectionService")
    local function registerCoin(obj)
        if not obj or not obj.Parent then return end
        local part = obj:FindFirstChild("Part")
                  or obj.PrimaryPart
                  or obj:FindFirstChildWhichIsA("BasePart")
        if not part then
            task.defer(function()
                if not obj.Parent then return end
                local p = obj:FindFirstChild("Part")
                       or obj.PrimaryPart
                       or obj:FindFirstChildWhichIsA("BasePart")
                if p then
                    _liveCoinParts[p] = obj
                    obj.AncestryChanged:Connect(function()
                        if not obj.Parent then _liveCoinParts[p] = nil end
                    end)
                end
            end)
            return
        end
        _liveCoinParts[part] = obj
        obj.AncestryChanged:Connect(function()
            if not obj.Parent then _liveCoinParts[part] = nil end
        end)
    end
    for _, obj in ipairs(CS:GetTagged("COLLECTABLE_COIN")) do
        registerCoin(obj)
    end
    local c1 = CS:GetInstanceAddedSignal("COLLECTABLE_COIN"):Connect(function(obj)
        registerCoin(obj)
    end)
    local c2 = CS:GetInstanceRemovedSignal("COLLECTABLE_COIN"):Connect(function(obj)
        for part, coinObj in pairs(_liveCoinParts) do
            if coinObj == obj then _liveCoinParts[part] = nil break end
        end
    end)
    table.insert(_coinAddedConns, c1)
    table.insert(_coinAddedConns, c2)
end
local function stopCoinTracker()
    for _, c in pairs(_coinAddedConns) do pcall(function() c:Disconnect() end) end
    _coinAddedConns = {}
    _liveCoinParts  = {}
    if coinCollectThread then pcall(task.cancel, coinCollectThread) coinCollectThread = nil end
    coinEventActive = false
end
local function findCoins()
    local coins = {}
    for part, obj in pairs(_liveCoinParts) do
        if part and part.Parent then
            table.insert(coins, { part = part, obj = obj })
        else
            _liveCoinParts[part] = nil
        end
    end
    if #coins == 0 then
        local _charSet = {}
        pcall(function()
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character then _charSet[plr.Character] = true end
            end
        end)
        for _, obj in ipairs(workspace:GetDescendants()) do
            if not obj or not obj.Parent then continue end
            local n = obj.Name:lower()
            if not n:find("coin") then continue end
            if not (obj:IsA("BasePart") or obj:IsA("Model")) then continue end
            local skip = false
            local anc = obj.Parent
            while anc and anc ~= workspace do
                if _charSet[anc] then skip = true break end
                anc = anc.Parent
            end
            if not skip then
                local part = (obj:IsA("BasePart") and obj)
                    or obj.PrimaryPart
                    or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    _liveCoinParts[part] = obj
                    obj.AncestryChanged:Connect(function()
                        if not obj.Parent then _liveCoinParts[part] = nil end
                    end)
                    table.insert(coins, { part = part, obj = obj })
                end
            end
        end
    end
    return coins
end
local _coinHopDone    = false
local _coinHopPending = false
local function _collectCoinObj(coinEntry)
    local obj  = coinEntry.obj
    local part = coinEntry.part
    if not obj or not obj.Parent then return end
    if not part or not part.Parent then return end
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local pos = part.Position
    pcall(function() root.CFrame = CFrame.new(pos.X, pos.Y + 1, pos.Z) end)
    task.wait(0.1)
    if part.Parent then
        _firetouchinterest(root, part, 0)
        task.wait(0.05)
        _firetouchinterest(root, part, 1)
    end
    task.wait(0.2)
end
local function startCoinCollect()
    if coinCollectThread then pcall(task.cancel, coinCollectThread) coinCollectThread = nil end
    _coinHopDone    = false
    coinEventActive = true
    coinCollectThread = task.spawn(function()
        local deadline     = tick() + S.coinEventDuration
        local absoluteEnd  = tick() + math.max(S.coinEventDuration, 60) + 60
        local idleTicks    = 0
        local hopActive    = S.autoHopCoinEnabled
        while S.autoCoinEnabled and (not hopActive or not getgenv().OxyoHopStopped) do
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not root then task.wait(0.3) continue end
            local coins = findCoins()
            if tick() > absoluteEnd then break end
            if #coins == 0 then
                if not workspace:GetAttribute("CoinRain") then
                    idleTicks = idleTicks + 1
                    if tick() > deadline and idleTicks > 4 then break end
                else
                    idleTicks = idleTicks + 1
                    deadline = math.max(deadline, tick() + 10)
                    if idleTicks > 20 then break end
                end
                task.wait(0.5)
                continue
            end
            idleTicks = 0
            deadline  = math.max(deadline, tick() + 10)
            table.sort(coins, function(a, b)
                local ra = root and (a.part.Position - root.Position).Magnitude or 0
                local rb = root and (b.part.Position - root.Position).Magnitude or 0
                return ra < rb
            end)
            for _, coinEntry in ipairs(coins) do
                if not S.autoCoinEnabled then break end
                if hopActive and getgenv().OxyoHopStopped then break end
                _collectCoinObj(coinEntry)
            end
        end
        coinEventActive   = false
        coinCollectThread = nil
        pcall(function()
            local hum  = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hum and root then
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
        if S.autoHopCoinEnabled and S.autoCoinEnabled and not _coinHopDone and not getgenv().OxyoHopStopped then
            _coinHopDone    = true
            _coinHopPending = true
            Rayfield:Notify({ Title = "Auto Hop", Content = "Coin Rain ended — hopping in 80s...", Duration = 4, Image = 4483362458 })
            task.wait(80)
            if not getgenv().OxyoHopStopped and S.autoHopCoinEnabled then
                getgenv().OxyoAutoHopCoin = true
                getgenv().OxyoHopStopped  = false
                task.spawn(function()
                    task.wait(0.1)
                    ServerHop()
                end)
            end
        end
    end)
end
local _notifConnected = {}
local function _tryConnectNotif(remote)
    if _notifConnected[remote] then return end
    _notifConnected[remote] = true
    remote.OnClientEvent:Connect(function(msg)
        if type(msg) ~= "string" and type(msg) ~= "table" then return end
        local lower = type(msg) == "string" and msg:lower() or ""
        local hasCoinRain = lower:find("coin") and (lower:find("rain") or lower:find("start") or lower:find("event"))
        if not hasCoinRain then
            hasCoinRain = workspace:GetAttribute("CoinRain") == true
        end
        if hasCoinRain then
            local secs = type(msg) == "string" and msg:match("(%d+)") or nil
            S.coinEventDuration = tonumber(secs) or 60
            if S.autoCoinEnabled and not coinEventActive then
                task.wait(0.5)
                startCoinTracker()
                Rayfield:Notify({ Title = "🪙 Coin Rain!", Content = "Started — farming!", Duration = 3, Image = 4483362458 })
                sendWebhook("🪙 Coin Rain Started!", "Event started!", 16766720)
                startCoinCollect()
            end
        end
    end)
end
task.spawn(function()
    local _notifPaths = {
        {"Events","Notification"},{"Remotes","Notification"},
        {"Events","CoinRain"},{"Remotes","CoinRain"},
        {"Events","SystemNotification"},{"Remotes","SystemNotification"},
    }
    for _, path in ipairs(_notifPaths) do
        pcall(function()
            local parent = ReplicatedStorage
            for i = 1, #path - 1 do
                local c = parent:FindFirstChild(path[i]) or parent:WaitForChild(path[i], 3)
                if not c then return end
                parent = c
            end
            local remote = parent:FindFirstChild(path[#path])
            if remote and remote:IsA("RemoteEvent") then _tryConnectNotif(remote) end
        end)
    end
end)
task.spawn(function()
    task.wait(3.5)
    while true do
        task.wait(3)
        if S.autoCoinEnabled and not _coinHopPending then
            local isActive = workspace:GetAttribute("CoinRain") == true
            local coins    = findCoins()
            if (isActive or #coins >= 1) and not coinEventActive then
                S.coinEventDuration = isActive and 60 or 90
                Rayfield:Notify({ Title = "🪙 Coin Rain!", Content = "Detected " .. #coins .. " coins — farming!", Duration = 3, Image = 4483362458 })
                sendWebhook("🪙 Coin Rain!", "Detected **" .. #coins .. "** coins in server!", 16766720)
                startCoinCollect()
            elseif coinEventActive and not coinCollectThread and not _coinHopPending then
                startCoinCollect()
            end
        end
    end
end)
task.spawn(function()
    workspace:GetAttributeChangedSignal("CoinRain"):Connect(function()
        if workspace:GetAttribute("CoinRain") == true then
            if S.autoCoinEnabled and not coinEventActive then
                S.coinEventDuration = 60
                startCoinTracker()
                task.wait(0.5)
                local coins = findCoins()
                Rayfield:Notify({ Title = "🪙 Coin Rain!", Content = "Event started — farming " .. #coins .. " coins!", Duration = 3, Image = 4483362458 })
                sendWebhook("🪙 Coin Rain Started!", "Event started!", 16766720)
                startCoinCollect()
            end
        else
            if coinEventActive and S.autoCoinEnabled then
                Rayfield:Notify({ Title = "🪙 Coin Rain", Content = "Event ended.", Duration = 2, Image = 4483362458 })
            end
        end
    end)
end)
CollectorTab:CreateToggle({
    Name         = "Auto Collect Coins",
    CurrentValue = false,
    Flag         = "AutoCoin",
    Callback     = function(Value)
        S.autoCoinEnabled = Value
        if Value then
            hideLava()
            startCoinTracker()
            task.wait(0.5)
            local isActive = workspace:GetAttribute("CoinRain") == true
            local coins    = findCoins()
            if isActive or #coins >= 1 then
                S.coinEventDuration = isActive and 60 or 90
                Rayfield:Notify({ Title = "🪙 Coin Rain!", Content = "Active — farming " .. #coins .. " coins!", Duration = 3, Image = 4483362458 })
                startCoinCollect()
            else
                Rayfield:Notify({ Title = "🪙 Auto Coin", Content = "Ready — waiting for Coin Rain...", Duration = 3, Image = 4483362458 })
            end
        else
            if coinCollectThread then pcall(task.cancel, coinCollectThread) coinCollectThread = nil end
            coinEventActive = false
            stopCoinTracker()
        end
    end,
})
HopTab:CreateSection("Auto Hop Coin Event")
HopTab:CreateParagraph({
    Title   = "Auto Hop — How it works",
    Content = "Each mode hops servers automatically looking for the selected target.\n🪙 Coin: finds active Coin Rain → farms all coins → hops again.\n👑 Godly / 🌌 Celestial / 🔷 Frag: finds & collects brainrots → hops if none found.\n🌊 Aqua: finds active Aqua Event → auto-fishes → hops when done.\n\nStop: press RightShift (PC) or tap ⛔ button.",
})
local hopToggleRef = HopTab:CreateToggle({
    Name         = "Auto Hop + Farm Coins",
    CurrentValue = false,
    Flag         = "AutoHopCoin",
    Callback     = function(Value)
        if not Value then
            getgenv().OxyoAutoHopCoin = false
            getgenv().OxyoHopStopped  = true
            S.autoHopCoinEnabled = false
            S.autoCoinEnabled    = false
            if coinCollectThread then
                pcall(task.cancel, coinCollectThread)
                coinCollectThread = nil
            end
            pcall(function()
                local g = game:GetService("CoreGui"):FindFirstChild("OxyoStopHopGui")
                if g then g:Destroy() end
            end)
            Rayfield:Notify({ Title = "⛔ Auto Hop", Content = "Stopped.", Duration = 3, Image = 4483362458 })
            return
        end
        if getgenv().OxyoAutoHopGodly or getgenv().OxyoAutoHopCel or getgenv().OxyoAutoHopFrag then
        end
        getgenv().OxyoHopStopped      = false
        getgenv().OxyoHopGodlyStopped = false
        getgenv().OxyoHopCelStopped   = false
        getgenv().OxyoHopFragStopped  = false
        getgenv().OxyoAutoHopCoin = true
        S.autoHopCoinEnabled = true
        S.autoCoinEnabled    = true
        hideLava()
        startCoinTracker()
        showStopHopGui()
        task.spawn(function()
            Rayfield:Notify({ Title = "Auto Hop", Content = "Checking this server...", Duration = 2, Image = 4483362458 })
            local status, timeLeft = waitForCoinRainStatus(10)
            if not getgenv().OxyoAutoHopCoin or getgenv().OxyoHopStopped then return end

            if not status then
                task.wait(1)
                status, timeLeft = getCoinRainStatus()
                if not status then
                    local s2, t2 = _detectCoinRainFallback()
                    if s2 then status, timeLeft = s2, t2 end
                end
            end
            if status == "active" and (timeLeft or 0) >= 10 then
                Rayfield:Notify({ Title = "Coin Rain!", Content = "Active! Farming now...", Duration = 3, Image = 4483362458 })
                coinEventActive   = true
                S.coinEventDuration = timeLeft or 60
                startCoinCollect()
            else

                if status == "active" then
                    Rayfield:Notify({ Title = "🪙 Coin Rain", Content = "بدأ مع وقت قصير — ننتظر...", Duration = 3, Image = 4483362458 })
                    task.wait(5)
                    local s3, t3 = getCoinRainStatus()
                    if s3 == "active" and (t3 or 0) >= 10 then
                        if not getgenv().OxyoAutoHopCoin or getgenv().OxyoHopStopped then return end
                        coinEventActive = true
                        S.coinEventDuration = t3 or 60
                        startCoinCollect()
                        return
                    end
                end
                local queuedSecs = _getCoinRainQueuedTime()
                if queuedSecs and queuedSecs > 0 and queuedSecs <= 1200 then
                    local mins = math.floor(queuedSecs / 60)
                    local secs = queuedSecs % 60
                    Rayfield:Notify({
                        Title   = "🪙 Coin Rain Incoming!",
                        Content = string.format("Queued in %dm %ds — waiting on this server!", mins, secs),
                        Duration = 6, Image = 4483362458,
                    })
                    local waited2 = 0
                    while waited2 < queuedSecs + 15
                        and getgenv().OxyoAutoHopCoin
                        and not getgenv().OxyoHopStopped
                    do
                        task.wait(2)
                        waited2 = waited2 + 2
                        local s2, t2 = getCoinRainStatus()
                        if s2 == "active" and (t2 or 0) >= 8 then
                            Rayfield:Notify({ Title = "🪙 Coin Rain!", Content = "Started! Farming now...", Duration = 3, Image = 4483362458 })
                            coinEventActive     = true
                            S.coinEventDuration = t2 or 60
                            startCoinCollect()
                            return
                        end
                    end
                    if getgenv().OxyoAutoHopCoin and not getgenv().OxyoHopStopped then
                        local sCheck, tCheck = getCoinRainStatus()
                        if sCheck == "active" then
                            Rayfield:Notify({ Title = "🪙 Coin Rain", Content = "Event just started — waiting 90s...", Duration = 5, Image = 4483362458 })
                            local graceWaited = 0
                            while graceWaited < 90 and getgenv().OxyoAutoHopCoin and not getgenv().OxyoHopStopped do
                                task.wait(2)
                                graceWaited = graceWaited + 2
                                local sg, tg = getCoinRainStatus()
                                if sg == "active" and (tg or 0) >= 8 then
                                    Rayfield:Notify({ Title = "🪙 Coin Rain!", Content = "Started! Farming now...", Duration = 3, Image = 4483362458 })
                                    coinEventActive = true
                                    S.coinEventDuration = tg or 60
                                    startCoinCollect()
                                    return
                                end
                            end
                        end
                        if getgenv().OxyoAutoHopCoin and not getgenv().OxyoHopStopped then
                            task.spawn(smartHop)
                        end
                    end
                else
                    Rayfield:Notify({ Title = "Auto Hop", Content = "No Coin Rain — hopping...", Duration = 2, Image = 4483362458 })
                    task.wait(math.random(5, 10))
                    if not getgenv().OxyoAutoHopCoin then return end
                    task.spawn(smartHop)
                end
            end
        end)
    end,
})
local function setHopToggleOff()
    pcall(function()
        if Rayfield and Rayfield.Flags then
            if Rayfield.Flags["AutoHopCoin"]      then Rayfield.Flags["AutoHopCoin"]:Set(false)      end
        end
    end)

    pcall(function()
        if hopToggleRef and hopToggleRef.Set then hopToggleRef:Set(false) end
    end)
end
local hopGodlyToggleRef
local hopCelToggleRef
local hopFragToggleRef
nuclearStop = function()
    getgenv().OxyoAutoHopCoin     = false
    getgenv().OxyoHopStopped      = true
    getgenv().OxyoAutoHopGodly    = false
    getgenv().OxyoHopGodlyStopped = true
    getgenv().OxyoAutoHopCel      = false
    getgenv().OxyoHopCelStopped   = true
    getgenv().OxyoAutoHopFrag     = false
    getgenv().OxyoHopFragStopped  = true
    getgenv().OxyoAutoHopAqua     = false
    getgenv().OxyoHopAquaStopped  = true
    getgenv().OxyoExecQueued      = false
    S.autoHopCoinEnabled  = false
    S.autoCoinEnabled     = false
    S.autoHopGodlyEnabled = false
    S.autoHopCelEnabled   = false
    S.autoHopFragEnabled  = false
    S.autoHopAquaEnabled  = false
    if coinCollectThread then
        pcall(task.cancel, coinCollectThread)
        coinCollectThread = nil
    end
    stopCoinTracker()
    if S.autoHopGodlyThread then
        pcall(task.cancel, S.autoHopGodlyThread)
        S.autoHopGodlyThread = nil
    end
    if S.autoHopCelThread then
        pcall(task.cancel, S.autoHopCelThread)
        S.autoHopCelThread = nil
    end
    if S.autoHopFragThread then
        pcall(task.cancel, S.autoHopFragThread)
        S.autoHopFragThread = nil
    end
    if S.autoHopAquaThread then
        pcall(task.cancel, S.autoHopAquaThread)
        S.autoHopAquaThread = nil
    end
    pcall(function() if getgenv()._OxyoStopAquaLoop then getgenv()._OxyoStopAquaLoop() end end)
    setHopToggleOff()
    pcall(function()
        if Rayfield and Rayfield.Flags then
            if Rayfield.Flags["AutoHopGodly"]    then Rayfield.Flags["AutoHopGodly"]:Set(false)    end
            if Rayfield.Flags["AutoHopCelestial"] then Rayfield.Flags["AutoHopCelestial"]:Set(false) end
            if Rayfield.Flags["AutoHopFrag"]     then Rayfield.Flags["AutoHopFrag"]:Set(false)     end
            if Rayfield.Flags["AutoHopAqua"]     then Rayfield.Flags["AutoHopAqua"]:Set(false)     end
        end
    end)

    pcall(function()
        if hopGodlyToggleRef and hopGodlyToggleRef.Set then hopGodlyToggleRef:Set(false) end
    end)
    pcall(function()
        if hopCelToggleRef and hopCelToggleRef.Set then hopCelToggleRef:Set(false) end
    end)
    pcall(function()
        if hopFragToggleRef and hopFragToggleRef.Set then hopFragToggleRef:Set(false) end
    end)
    pcall(function()
        if hopAquaToggleRef and hopAquaToggleRef.Set then hopAquaToggleRef:Set(false) end
    end)
    pcall(function() if Rayfield then Rayfield:SaveConfiguration() end end)
    pcall(function()
        local g = game:GetService("CoreGui"):FindFirstChild("OxyoStopHopGui")
        if g then g:Destroy() end
    end)
    getgenv().OxyoManualHop = false
    Rayfield:Notify({ Title = "⛔ Auto Hop", Content = "Stopped.", Duration = 3, Image = 4483362458 })
end
showStopHopGui = function()
    pcall(function()
        local old = game:GetService("CoreGui"):FindFirstChild("OxyoStopHopGui")
        if old then old:Destroy() end
    end)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name           = "OxyoStopHopGui"
    screenGui.ResetOnSpawn   = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent         = game:GetService("CoreGui")
    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(0, 170, 0, 55)
    btn.Position         = UDim2.new(0.5, -85, 1, -80)
    btn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    btn.TextColor3       = Color3.fromRGB(255, 255, 255)
    btn.Text             = "⛔ Stop Auto Hop"
    btn.Font             = Enum.Font.GothamBold
    btn.TextSize         = 15
    btn.Parent           = screenGui
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    btn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        nuclearStop()
    end)
end
HopTab:CreateButton({
    Name     = "⛔ Stop Auto Hop",
    Callback = function() nuclearStop() end,
})
HopTab:CreateButton({
    Name     = "🔄 Reset Hop State",
    Callback = function()
        getgenv().OxyoHopStopped      = false
        getgenv().OxyoHopGodlyStopped = false
        getgenv().OxyoHopCelStopped   = false
        getgenv().OxyoHopFragStopped  = false
        getgenv().OxyoHopAquaStopped  = false
        getgenv().OxyoExecQueued      = false
        getgenv().OxyoDeadServers     = {}
        Rayfield:Notify({ Title = "🔄 Reset", Content = "Hop state + dead server list cleared.", Duration = 3, Image = 4483362458 })
    end,
})

HopTab:CreateSection("Auto Hop + Godly")
hopGodlyToggleRef = HopTab:CreateToggle({
    Name         = "Auto Hop + Farm Godly",
    CurrentValue = false,
    Flag         = "AutoHopGodly",
    Callback     = function(Value)
        if not Value then
            getgenv().OxyoAutoHopGodly    = false
            getgenv().OxyoHopGodlyStopped = true
            S.autoHopGodlyEnabled = false
            if S.autoHopGodlyThread then
                pcall(task.cancel, S.autoHopGodlyThread)
                S.autoHopGodlyThread = nil
            end
            pcall(function()
                local g = game:GetService("CoreGui"):FindFirstChild("OxyoStopHopGui")
                if g then g:Destroy() end
            end)
            Rayfield:Notify({ Title = "⛔ Auto Hop Godly", Content = "Stopped.", Duration = 3, Image = 4483362458 })
            return
        end
        if getgenv().OxyoAutoHopCoin or getgenv().OxyoAutoHopCel or getgenv().OxyoAutoHopFrag then
        end
        getgenv().OxyoHopStopped      = false
        getgenv().OxyoHopGodlyStopped = false
        getgenv().OxyoHopCelStopped   = false
        getgenv().OxyoHopFragStopped  = false
        getgenv().OxyoAutoHopGodly    = true
        S.autoHopGodlyEnabled = true
        hideLava()
        showStopHopGui()
        S.autoHopGodlyThread = task.spawn(function()
            runRarityHopFarm("Godly", "OxyoAutoHopGodly", "OxyoHopGodlyStopped")
        end)
    end,
})
HopTab:CreateSection("Auto Hop + Celestial")
hopCelToggleRef = HopTab:CreateToggle({
    Name         = "Auto Hop + Farm Celestial",
    CurrentValue = false,
    Flag         = "AutoHopCelestial",
    Callback     = function(Value)
        if not Value then
            getgenv().OxyoAutoHopCel    = false
            getgenv().OxyoHopCelStopped = true
            S.autoHopCelEnabled = false
            if S.autoHopCelThread then
                pcall(task.cancel, S.autoHopCelThread)
                S.autoHopCelThread = nil
            end
            pcall(function()
                local g = game:GetService("CoreGui"):FindFirstChild("OxyoStopHopGui")
                if g then g:Destroy() end
            end)
            Rayfield:Notify({ Title = "⛔ Auto Hop Celestial", Content = "Stopped.", Duration = 3, Image = 4483362458 })
            return
        end
        if getgenv().OxyoAutoHopCoin or getgenv().OxyoAutoHopGodly or getgenv().OxyoAutoHopFrag then
        end
        getgenv().OxyoHopStopped      = false
        getgenv().OxyoHopGodlyStopped = false
        getgenv().OxyoHopCelStopped   = false
        getgenv().OxyoHopFragStopped  = false
        getgenv().OxyoAutoHopCel    = true
        S.autoHopCelEnabled = true
        hideLava()
        showStopHopGui()
        S.autoHopCelThread = task.spawn(function()
            runRarityHopFarm("Celestial", "OxyoAutoHopCel", "OxyoHopCelStopped")
        end)
    end,
})
HopTab:CreateSection("Auto Hop + Fragments")
hopFragToggleRef = HopTab:CreateToggle({
    Name         = "Auto Hop + Farm Fragments",
    CurrentValue = false,
    Flag         = "AutoHopFrag",
    Callback     = function(Value)
        if not Value then
            getgenv().OxyoAutoHopFrag    = false
            getgenv().OxyoHopFragStopped = true
            S.autoHopFragEnabled = false
            if S.autoHopFragThread then
                pcall(task.cancel, S.autoHopFragThread)
                S.autoHopFragThread = nil
            end
            pcall(function()
                local g = game:GetService("CoreGui"):FindFirstChild("OxyoStopHopGui")
                if g then g:Destroy() end
            end)
            Rayfield:Notify({ Title = "⛔ Auto Hop Fragments", Content = "Stopped.", Duration = 3, Image = 4483362458 })
            return
        end
        if getgenv().OxyoAutoHopCoin or getgenv().OxyoAutoHopGodly or getgenv().OxyoAutoHopCel then
        end
        getgenv().OxyoHopStopped      = false
        getgenv().OxyoHopGodlyStopped = false
        getgenv().OxyoHopCelStopped   = false
        getgenv().OxyoHopFragStopped  = false
        getgenv().OxyoAutoHopFrag    = true
        S.autoHopFragEnabled = true
        hideLava()
        showStopHopGui()
        S.autoHopFragThread = task.spawn(function()
            runFragHopFarm("OxyoAutoHopFrag", "OxyoHopFragStopped")
        end)
    end,
})

HopTab:CreateSection("Auto Hop + Aqua Event")
local hopAquaToggleRef
hopAquaToggleRef = HopTab:CreateToggle({
    Name         = "Auto Hop + Fish (Aqua Event)",
    CurrentValue = false,
    Flag         = "AutoHopAqua",
    Callback     = function(Value)
        if not Value then
            getgenv().OxyoAutoHopAqua    = false
            getgenv().OxyoHopAquaStopped = true
            S.autoHopAquaEnabled         = false
            if S.autoHopAquaThread then
                pcall(task.cancel, S.autoHopAquaThread)
                S.autoHopAquaThread = nil
            end
            pcall(function() if getgenv()._OxyoStopAquaLoop then getgenv()._OxyoStopAquaLoop() end end)
            pcall(function()
                local g = game:GetService("CoreGui"):FindFirstChild("OxyoStopHopGui")
                if g then g:Destroy() end
            end)
            Rayfield:Notify({ Title = "⛔ Auto Hop Aqua", Content = "Stopped.", Duration = 3, Image = 4483362458 })
            return
        end
        getgenv().OxyoHopStopped      = false
        getgenv().OxyoHopAquaStopped  = false
        getgenv().OxyoAutoHopAqua     = true
        S.autoHopAquaEnabled = true
        hideLava()
        showStopHopGui()
        S.autoHopAquaThread = task.spawn(function()
            Rayfield:Notify({ Title = "🌊 Auto Hop Aqua", Content = "Checking current server...", Duration = 2, Image = 4483362458 })
            task.wait(4)
            while getgenv().OxyoAutoHopAqua and not getgenv().OxyoHopAquaStopped do
                if _isAquaActive() then
                    Rayfield:Notify({ Title = "🌊 Aqua Event!", Content = "Active — starting Auto Fish!", Duration = 3, Image = 4483362458 })
                    if not _getAquaRemotes() then
                        Rayfield:Notify({ Title = "🌊 Auto Hop Aqua", Content = "Remotes missing — hopping...", Duration = 2, Image = 4483362458 })
                        task.wait(3)
                        if getgenv().OxyoAutoHopAqua and not getgenv().OxyoHopAquaStopped then
                            task.spawn(ServerHop)
                        end
                        return
                    end
                    _aquaRunning = true
                    _startAquaLoop()
                    local waited = 0
                    while _aquaRunning and getgenv().OxyoAutoHopAqua and not getgenv().OxyoHopAquaStopped do
                        task.wait(5)
                        waited = waited + 5
                        if not _isAquaActive() and waited > 10 then
                            _stopAquaLoop()
                            break
                        end
                    end
                    if not getgenv().OxyoAutoHopAqua or getgenv().OxyoHopAquaStopped then return end
                    Rayfield:Notify({ Title = "🌊 Auto Hop Aqua", Content = "Aqua Event ended — hopping...", Duration = 2, Image = 4483362458 })
                    task.wait(2)
                    if getgenv().OxyoAutoHopAqua and not getgenv().OxyoHopAquaStopped then
                        task.spawn(ServerHop)
                    end
                    return
                else

                    local _aquaGraceEnd = tick() + 8
                    while not _isAquaActive() and tick() < _aquaGraceEnd
                        and getgenv().OxyoAutoHopAqua and not getgenv().OxyoHopAquaStopped do
                        task.wait(1)
                    end
                    if _isAquaActive() then continue end

                    local queuedSecs = _getAquaQueuedTime()
                    if queuedSecs and queuedSecs > 0 and queuedSecs <= 1200 then
                        local mins = math.floor(queuedSecs / 60)
                        local secs = queuedSecs % 60
                        Rayfield:Notify({
                            Title   = "🌊 Aqua Event Incoming!",
                            Content = string.format("Queued in %dm %ds — waiting on this server!", mins, secs),
                            Duration = 6, Image = 4483362458,
                        })

                        local waited2 = 0
                        while waited2 < queuedSecs + 10
                            and getgenv().OxyoAutoHopAqua
                            and not getgenv().OxyoHopAquaStopped
                            and not _isAquaActive() do
                            task.wait(2)
                            waited2 = waited2 + 2
                        end

                        continue
                    end
                    task.wait(math.random(5, 10))
                    if getgenv().OxyoAutoHopAqua and not getgenv().OxyoHopAquaStopped then
                        task.spawn(ServerHop)
                    end
                    return
                end
            end
        end)
    end,
})

HopTab:CreateSection("📊 Session Stats")
local _hopStatsPara = HopTab:CreateParagraph({
    Title   = "Hop Stats",
    Content = "Idle",
})
local _hopCount = 0
local _hopStart = 0
task.spawn(function()
    while true do
        task.wait(10)
        if isAnyHopActive() then
            if _hopStart == 0 then _hopStart = tick() end
            local elapsed = tick() - _hopStart
            local mins = math.floor(elapsed / 60)
            local secs = math.floor(elapsed % 60)
            pcall(function()
                _hopStatsPara:Set({
                    Title   = "📊 Hop Session",
                    Content = string.format("⏱ Running: %02d:%02d\nMode: %s",
                        mins, secs,
                        getgenv().OxyoAutoHopCoin  and "🪙 Coin" or
                        getgenv().OxyoAutoHopGodly and "👑 Godly" or
                        getgenv().OxyoAutoHopCel   and "🌌 Celestial" or
                        getgenv().OxyoAutoHopFrag  and "🔷 Fragments" or
                        getgenv().OxyoAutoHopAqua  and "🌊 Aqua" or "—"
                    ),
                })
            end)
        else
            _hopStart = 0
            pcall(function()
                _hopStatsPara:Set({ Title = "Hop Stats", Content = "Idle" })
            end)
        end
    end
end)
getgenv().OxyoAutoSafe = true
CollectorTab:CreateSection("Auto Upgrade")
CollectorTab:CreateToggle({
    Name         = "Auto Upgrade",
    CurrentValue = false,
    Flag         = "AutoUpgrade",
    Callback     = function(Value)
        auto.upgradeEnabled = Value
        if Value then
            auto.upgradeThread = task.spawn(function()
                local upgradeRemote = nil
                pcall(function() upgradeRemote = ReplicatedStorage.Events.Upgrade end)
                while auto.upgradeEnabled do
                    pcall(function()
                        local gf = workspace:FindFirstChild("GameFolder")
                        local plots = gf and gf:FindFirstChild("Plots")
                        if not plots then return end
                        for _, plot in pairs(plots:GetChildren()) do
                            local brainrots = plot:FindFirstChild("Brainrots")
                            if not brainrots then continue end
                            for _, br in pairs(brainrots:GetChildren()) do
                                local ok, owner = pcall(function() return br:GetAttribute("Owner") end)
                                if ok and owner and tostring(owner) == tostring(player.UserId) then
                                    for _, b in pairs(brainrots:GetChildren()) do
                                        local slot = tonumber(b.Name)
                                        if slot then
                                            pcall(function() upgradeRemote:InvokeServer(slot) end)
                                            task.wait(0.08)
                                        end
                                    end
                                    break
                                end
                            end
                        end
                    end)
                    task.wait(2)
                end
            end)
        else
            if auto.upgradeThread then pcall(task.cancel, auto.upgradeThread) auto.upgradeThread = nil end
        end
    end,
})
CollectorTab:CreateSection("Auto Sell")
CollectorTab:CreateSlider({
    Name         = "Sell Threshold",
    Range        = {5, 50},
    Increment    = 5,
    Suffix       = "Brainrots",
    CurrentValue = 50,
    Flag         = "SellThreshold",
    Callback     = function(Value) auto.sellThreshold = Value end,
})
CollectorTab:CreateSlider({
    Name         = "Sell Every X Seconds  (0 = off)",
    Range        = {0, 300},
    Increment    = 10,
    Suffix       = "sec",
    CurrentValue = 0,
    Flag         = "SellTimerInterval",
    Callback     = function(Value) auto.sellTimer = Value end,
})
CollectorTab:CreateToggle({
    Name         = "Auto Sell",
    CurrentValue = false,
    Flag         = "AutoSell",
    Callback     = function(Value)
        auto.sellEnabled = Value
        if Value then
            auto.sellThread = task.spawn(function()
                local lastTimerSell = tick()
                while auto.sellEnabled do
                    local realCount     = getPlotBrainrotCount()
                    local elapsed       = tick() - lastTimerSell
                    local shouldByCount = realCount >= auto.sellThreshold
                    local shouldByTimer = auto.sellTimer > 0 and elapsed >= auto.sellTimer and realCount > 0
                    if shouldByCount or shouldByTimer then
                        if doSell() then
                            lastTimerSell = tick()
                            Rayfield:Notify({
                                Title    = "Auto Sell",
                                Content  = "Sold " .. realCount .. " Brainrots!",
                                Duration = 2,
                                Image    = 4483362458,
                            })
                        end
                        task.wait(3)
                    else
                        task.wait(2)
                    end
                end
            end)
        else
            if auto.sellThread then pcall(task.cancel, auto.sellThread) auto.sellThread = nil end
        end
    end,
})
CollectorTab:CreateButton({
    Name     = "Sell Now (Manual)",
    Callback = function()
        if doSell() then
            Rayfield:Notify({ Title = "Sold!", Content = "All Brainrots sold successfully!", Duration = 3, Image = 4483362458 })
        else
            Rayfield:Notify({ Title = "Error", Content = "Failed to sell — make sure the game is running.", Duration = 4, Image = 4483362458 })
        end
    end,
})
do
do
local _rebirthRemote = ReplicatedStorage:FindFirstChild("Events")
    and ReplicatedStorage.Events:FindFirstChild("Rebirth")
local function _getRebirthReqs()
    local ok, insider = pcall(function()
        return player.PlayerGui.HUD.Rebirth.InsiderFrame.Insider
    end)
    if not ok or not insider then return nil end
    local reqSpeed, curSpeed
    pcall(function()
        local lbl = insider.RequirementBar.Name
        if lbl and lbl:IsA("TextLabel") then
            local cur, req = lbl.Text:match("(%d+)/(%d+)%s*Speed")
            curSpeed = tonumber(cur)
            reqSpeed = tonumber(req)
        end
    end)
    local reqBrainrot
    pcall(function()
        local nt = insider.Brainrots.RebirthReward.NameText
        if nt and nt:IsA("TextLabel") and nt.Text ~= "" then
            reqBrainrot = nt.Text
        end
    end)
    return { reqSpeed = reqSpeed, curSpeed = curSpeed, reqBrainrot = reqBrainrot }
end
local function _openRebirthMenu()
    pcall(function()
        local pg  = player:FindFirstChild("PlayerGui")
        local hud = pg and pg:FindFirstChild("HUD")
        local btn = hud and hud:FindFirstChild("LeftButtons")
            and hud.LeftButtons:FindFirstChild("Rebirth")
        if btn then btn.MouseButton1Click:Fire() end
    end)
end
local function _brainrotOnPlot(name)
    local nameLow = name:lower()
    local gf = workspace:FindFirstChild("GameFolder")
    local plots = gf and gf:FindFirstChild("Plots")
    if not plots then return false end
    for _, plot in pairs(plots:GetChildren()) do
        local ok2, owner = pcall(function() return plot:GetAttribute("Owner") end)
        if ok2 and owner and tostring(owner) == tostring(player.UserId) then
            local brs = plot:FindFirstChild("Brainrots")
            if brs then
                for _, b in pairs(brs:GetChildren()) do
                    local dn = (b:GetAttribute("DisplayName") or b.Name):lower()
                    if dn:find(nameLow, 1, true) or nameLow:find(dn, 1, true) then
                        return true
                    end
                end
            end
        end
    end
    return false
end
local function _findInWorld(name)
    local nameLow = name:lower()
    for _, entry in ipairs(monitorData.brainrots) do
        if entry.obj and entry.obj.Parent then
            local dn = (entry.name or ""):lower()
            if dn:find(nameLow, 1, true) or nameLow:find(dn, 1, true) then
                return entry
            end
        end
    end
    return nil
end
local function _doRebirth()
    if not _rebirthRemote then
        _rebirthRemote = ReplicatedStorage:FindFirstChild("Events")
            and ReplicatedStorage.Events:FindFirstChild("Rebirth")
    end
    if not _rebirthRemote then return false end
    local ok2 = pcall(function() _rebirthRemote:InvokeServer("Rebirth") end)
    return ok2
end
local function _runRebirthLoop()
    while auto.rebirthEnabled do
        task.wait(5)
        pcall(function()
            if _doRebirth() then
                Rayfield:Notify({
                    Title   = "Rebirth Done!",
                    Content = "Rebirth successful!",
                    Duration = 5,
                    Image   = 4483362458,
                })
                task.wait(6)
            end
        end)
    end
end
CollectorTab:CreateSection("Auto Rebirth")
CollectorTab:CreateToggle({
    Name         = "Auto Rebirth",
    CurrentValue = false,
    Flag         = "AutoRebirth",
    Callback     = function(Value)
        auto.rebirthEnabled = Value
        if Value then
            auto.rebirthThread = task.spawn(_runRebirthLoop)
            Rayfield:Notify({
                Title   = "Auto Rebirth ON",
                Content = "Watching requirements - will rebirth when ready.",
                Duration = 4,
                Image   = 4483362458,
            })
        else
            if auto.rebirthThread then
                pcall(task.cancel, auto.rebirthThread)
                auto.rebirthThread = nil
            end
        end
    end,
})
CollectorTab:CreateButton({
    Name     = "Rebirth Now (Manual)",
    Callback = function()
        task.spawn(function()
            _openRebirthMenu()
            task.wait(0.3)
            if _doRebirth() then
                Rayfield:Notify({ Title = "Rebirth Done!", Content = "Success!", Duration = 4, Image = 4483362458 })
            else
                Rayfield:Notify({ Title = "Rebirth Failed", Content = "Server rejected rebirth.", Duration = 4, Image = 4483362458 })
            end
        end)
    end,
})
end
local statusParagraph = BrainrotStatusTab:CreateParagraph({
    Title   = "Brainrots in World",
    Content = "Scanning...",
})
BrainrotStatusTab:CreateSection("Live Brainrot Status")
task.spawn(function()
    local lastCount = -1
    task.wait(1)
    while true do
        task.wait(3)
        pcall(function()
            local snapshot = monitorData.brainrots
            local alive = 0
            for _, entry in ipairs(snapshot) do
                if entry.obj and entry.obj.Parent then alive = alive + 1 end
            end
            if alive == lastCount then return end
            lastCount = alive
            if alive == 0 then
                pcall(function()
                    statusParagraph:Set({ Title = "Brainrots in World (0)", Content = "No Brainrots in world right now." })
                end)
                return
            end
            local lines = {}
            for _, entry in ipairs(snapshot) do
                if entry.obj and entry.obj.Parent then
                    local traitStr = ""
                    local td = S.traitData[entry.obj]
                    if td and #td.traitNames > 0 then
                        traitStr = " [TRAIT: " .. table.concat(td.traitNames, "+") .. "]"
                    end
                    table.insert(lines, "[" .. (entry.rarity or "?") .. "] " .. (entry.name or "?") .. " — " .. (entry.mutation or "Normal") .. traitStr)
                end
            end
            pcall(function()
                statusParagraph:Set({
                    Title   = "Brainrots in World (" .. #lines .. ")",
                    Content = #lines > 0 and table.concat(lines, "\n") or "Nothing right now.",
                })
            end)
        end)
    end
end)
end
BrainrotStatusTab:CreateSection("Mutation Alert")
BrainrotStatusTab:CreateDropdown({
    Name            = "Alert for Mutations",
    Options         = ALERT_MUTATIONS,
    CurrentOption   = {},
    MultipleOptions = true,
    Flag            = "MutationAlertDropdown",
    Callback        = function(Options) S.mutationAlertDropdown = Options end,
})
BrainrotStatusTab:CreateToggle({
    Name         = "Mutation Alert",
    CurrentValue = false,
    Flag         = "MutationAlert",
    Callback     = function(Value)
        auto.alertEnabled = Value
        if Value then
            local lastSeen = {}
            auto.alertThread = task.spawn(function()
                while auto.alertEnabled do
                    pcall(function()
                        for _, e in ipairs(monitorData.mutations) do
                            if e.obj and e.obj.Parent then
                                local alertSet = {}
                                for _, m in ipairs(S.mutationAlertDropdown) do alertSet[m] = true end
                                local shouldAlert = (#S.mutationAlertDropdown == 0) or alertSet[e.mutation]
                                local key = e.name .. "_" .. e.mutation .. "_" .. e.rarity
                                if shouldAlert and not lastSeen[key] then
                                    lastSeen[key] = true
                                    Rayfield:Notify({
                                        Title    = "Mutation Detected!",
                                        Content  = "[" .. e.mutation .. "] " .. e.name .. "\nZone: " .. e.rarity,
                                        Duration = 6,
                                        Image    = 4483362458,
                                    })
                                end
                            end
                        end
                        local alive = {}
                        for _, e in ipairs(monitorData.mutations) do
                            alive[e.name .. "_" .. e.mutation .. "_" .. e.rarity] = true
                        end
                        for k in pairs(lastSeen) do
                            if not alive[k] then lastSeen[k] = nil end
                        end
                    end)
                    task.wait(2)
                end
            end)
        else
            if auto.alertThread then pcall(task.cancel, auto.alertThread) auto.alertThread = nil end
        end
    end,
})
LuckyStatusTab:CreateSection("Live Status")
do
local luckyStatusPara = LuckyStatusTab:CreateParagraph({
    Title   = "Lucky Block Status",
    Content = "Scanning...",
})
task.spawn(function()
    task.wait(2)
    while true do
        task.wait(3)
        pcall(function()
            local blocks       = getLuckyBlocks()
            local activeLines  = {}
            local pendingLines = {}
            for _, b in ipairs(blocks) do
                local bname = tostring(b.name or "?")
                if b.active then
                    table.insert(activeLines, "✅ " .. bname .. "  (" .. math.floor(b.pos.X) .. ", " .. math.floor(b.pos.Y) .. ", " .. math.floor(b.pos.Z) .. ")")
                else
                    table.insert(pendingLines, "⏳ " .. bname .. " — Respawning...")
                end
            end
            local total   = #blocks
            local active  = #activeLines
            local content = "Active: " .. active .. " / " .. total .. "\n\n"
                          .. table.concat(activeLines, "\n")
                          .. (#pendingLines > 0 and ("\n\n" .. table.concat(pendingLines, "\n")) or "")
            pcall(function()
                luckyStatusPara:Set({ Title = "Lucky Block Status (" .. active .. "/" .. total .. ")", Content = content })
            end)
        end)
    end
end)
end
GearTab:CreateSection("Speed Upgrade")
GearTab:CreateButton({
    Name     = "+1 Speed",
    Callback = function()
        local ok, result = pcall(function() return ReplicatedStorage.Events.Speed:InvokeServer("Speed", 1) end)
        if not ok or (type(result) == "string" and result:lower():find("enough")) then
            Rayfield:Notify({ Title = "Not Enough Cash", Content = "You don't have enough cash for +1 Speed.", Duration = 4, Image = 4483362458 })
        else
            Rayfield:Notify({ Title = "Upgraded!", Content = "+1 Speed purchased!", Duration = 3, Image = 4483362458 })
        end
    end,
})
GearTab:CreateButton({
    Name     = "+5 Speed",
    Callback = function()
        local ok, result = pcall(function() return ReplicatedStorage.Events.Speed:InvokeServer("Speed", 5) end)
        if not ok or (type(result) == "string" and result:lower():find("enough")) then
            Rayfield:Notify({ Title = "Not Enough Cash", Content = "You don't have enough cash for +5 Speed.", Duration = 4, Image = 4483362458 })
        else
            Rayfield:Notify({ Title = "Upgraded!", Content = "+5 Speed purchased!", Duration = 3, Image = 4483362458 })
        end
    end,
})
GearTab:CreateButton({
    Name     = "+10 Speed",
    Callback = function()
        local ok, result = pcall(function() return ReplicatedStorage.Events.Speed:InvokeServer("Speed", 10) end)
        if not ok or (type(result) == "string" and result:lower():find("enough")) then
            Rayfield:Notify({ Title = "Not Enough Cash", Content = "You don't have enough cash for +10 Speed.", Duration = 4, Image = 4483362458 })
        else
            Rayfield:Notify({ Title = "Upgraded!", Content = "+10 Speed purchased!", Duration = 3, Image = 4483362458 })
        end
    end,
})
GearTab:CreateSection("Carry Upgrade")
GearTab:CreateButton({
    Name     = "+1 Carry",
    Callback = function()
        local ok, result = pcall(function() return ReplicatedStorage.Events.Carry:InvokeServer("Carry") end)
        if not ok or (type(result) == "string" and result:lower():find("enough")) then
            Rayfield:Notify({ Title = "Not Enough Cash", Content = "You don't have enough cash for +1 Carry.", Duration = 4, Image = 4483362458 })
        else
            Rayfield:Notify({ Title = "Upgraded!", Content = "+1 Carry purchased!", Duration = 3, Image = 4483362458 })
        end
    end,
})
GearTab:CreateSection("Buy Gear")
local function resolveGearKey(opt)
    if not opt then return nil end
    for key, data in pairs(GEAR_REGISTRY) do
        if data.displayName == opt then return key end
    end
    local optL = opt:lower()
    for key, data in pairs(GEAR_REGISTRY) do
        if data.displayName:lower() == optL then return key end
    end
    return nil
end
do
    local gearOptions = {}
    for key, data in pairs(GEAR_REGISTRY) do
        if key:sub(1,3) ~= "LB_" then
            table.insert(gearOptions, data.displayName)
        end
    end
    table.sort(gearOptions)
    GearTab:CreateDropdown({
        Name            = "Select Gear",
        Options         = gearOptions,
        CurrentOption   = {},
        MultipleOptions = true,
        Flag            = "GearMultiDropdown",
        Callback        = function(Options)
            S.selectedGears = {}
            S.selectedGear  = nil
            local list = type(Options) == "table" and Options or {Options}
            for _, opt in ipairs(list) do
                local key = resolveGearKey(opt)
                if key then
                    table.insert(S.selectedGears, key)
                    if not S.selectedGear then S.selectedGear = key end
                end
            end
        end,
    })
end
GearTab:CreateButton({
    Name     = "Buy Selected Gear",
    Callback = function()
        if not S.selectedGear then
            Rayfield:Notify({ Title = "Gear Shop", Content = "Select a gear from the list first!", Duration = 3, Image = 4483362458 })
            return
        end
        task.spawn(function()
            do
            local data   = GEAR_REGISTRY[S.selectedGear]
            local result = buyGear(S.selectedGear)
            if result == BUY_RESULT.SUCCESS then
                Rayfield:Notify({ Title = "✅ Purchased!", Content = data.displayName .. " bought!", Duration = 4, Image = 4483362458 })
            elseif result == BUY_RESULT.OUT_OF_STOCK then
                Rayfield:Notify({ Title = "Out of Stock", Content = data.displayName .. " is currently out of stock.", Duration = 4, Image = 4483362458 })
            elseif result == BUY_RESULT.NO_COINS then
                Rayfield:Notify({ Title = "Not Enough Coins", Content = "Need " .. data.coinPrice .. " coins for " .. data.displayName, Duration = 4, Image = 4483362458 })
            elseif result == BUY_RESULT.NOT_IN_SHOP then
                Rayfield:Notify({ Title = "Not in Shop", Content = data.displayName .. " is not available right now.", Duration = 4, Image = 4483362458 })
            end
            end
        end)
    end,
})
end)()
;(function()
GearTab:CreateSection("Buy Lucky Block")
do
    local lbOptions = {
        "Common Lucky Block",
        "Rare Lucky Block",
        "Epic Lucky Block",
        "Legendary Lucky Block",
        "Mythic Lucky Block",
        "Secret Lucky Block",
        "Celestial Lucky Block",
        "Godly Lucky Block",
    }
    local LB_DISPLAY_TO_KEY = {
        ["Common Lucky Block"]    = "LB_Common",
        ["Rare Lucky Block"]      = "LB_Rare",
        ["Epic Lucky Block"]      = "LB_Epic",
        ["Legendary Lucky Block"] = "LB_Legendary",
        ["Mythic Lucky Block"]    = "LB_Mythic",
        ["Secret Lucky Block"]    = "LB_Secret",
        ["Celestial Lucky Block"] = "LB_Celestial",
        ["Godly Lucky Block"]     = "LB_Godly",
    }
    GearTab:CreateDropdown({
        Name            = "Select Lucky Block",
        Options         = lbOptions,
        CurrentOption   = {},
        MultipleOptions = true,
        Flag            = "LBMultiDropdown",
        Callback        = function(Options)
            S.selectedLBs = {}
            local list = type(Options) == "table" and Options or {Options}
            for _, opt in ipairs(list) do
                local key = LB_DISPLAY_TO_KEY[opt]
                if key then table.insert(S.selectedLBs, key) end
            end
            getgenv().OxyoSelectedLBs = S.selectedLBs
        end,
    })
end
GearTab:CreateButton({
    Name     = "Buy Selected Lucky Block",
    Callback = function()
        if not S.selectedLBs or #S.selectedLBs == 0 then
            Rayfield:Notify({ Title = "Lucky Block", Content = "Select at least one Lucky Block first!", Duration = 3, Image = 4483362458 })
            return
        end
        task.spawn(function()
            for _, lbKey in ipairs(S.selectedLBs) do
                local data = GEAR_REGISTRY[lbKey]
                if not data then continue end
                local result = buyGear(lbKey)
                if result == BUY_RESULT.SUCCESS then
                    Rayfield:Notify({ Title = "✅ Purchased!", Content = data.displayName .. " bought!", Duration = 4, Image = 4483362458 })
                elseif result == BUY_RESULT.OUT_OF_STOCK then
                    Rayfield:Notify({ Title = "Out of Stock", Content = data.displayName .. " is out of stock.", Duration = 4, Image = 4483362458 })
                elseif result == BUY_RESULT.NO_COINS then
                    Rayfield:Notify({ Title = "Not Enough Coins", Content = "Not enough coins for " .. data.displayName, Duration = 4, Image = 4483362458 })
                elseif result == BUY_RESULT.NOT_IN_SHOP then
                    Rayfield:Notify({ Title = "Not in Shop", Content = data.displayName .. " not available.", Duration = 4, Image = 4483362458 })
                end
                task.wait(0.5)
            end
        end)
    end,
})
end)()
;(function()
GearTab:CreateSection("Auto Buy Lucky Block")
local _lbBuyStatsPara = GearTab:CreateParagraph({
    Title   = "📊 Auto Buy LB Stats",
    Content = "Idle",
})
local _lbBuyStats = { total=0, attempts=0, startTick=0 }
local _lastLBNotifTime = {}
local function _throttledLBNotify(rtype, title, content)
    local now  = tick()
    local last = _lastLBNotifTime[rtype] or 0
    if now - last < 30 then return end
    _lastLBNotifTime[rtype] = now
    pcall(function()
        Rayfield:Notify({ Title=title, Content=content, Duration=3, Image=4483362458 })
    end)
end
local function _updateLBStatsHUD()
    if not auto.buyLBEnabled then return end
    pcall(function()
        local elapsed = tick() - _lbBuyStats.startTick
        local mins    = math.floor(elapsed / 60)
        local secs    = math.floor(elapsed % 60)
        local names   = {}
        for _, k in ipairs(S.selectedLBs or {}) do
            local d = GEAR_REGISTRY[k]
            if d then table.insert(names, d.displayName:gsub(" Lucky Block",""):gsub(" %(World%)","")) end
        end
        _lbBuyStatsPara:Set({
            Title   = "📊 Auto Buy LB — " .. (table.concat(names, ", ") ~= "" and table.concat(names, ", ") or "—"),
            Content = string.format(
                "✅ Bought: %d  •  🔄 Attempts: %d\n⏱ Running: %02d:%02d",
                _lbBuyStats.total, _lbBuyStats.attempts, mins, secs),
        })
    end)
end
local function _resetAutoBuyLBFlag()
    pcall(function()
        local flag = Rayfield.Flags and Rayfield.Flags["AutoBuyLB"]
        if flag then flag:Set(false) end
    end)
end
local function _ensureRemote()
    if _VP_REMOTE and _VP_REMOTE.Parent then return true end
    local ok, found = pcall(function()
        return ReplicatedStorage:WaitForChild("Events", 3):WaitForChild("VendorPurchase", 3)
    end)
    if ok and found then _VP_REMOTE = found return true end
    return false
end
local function _runBuyLBLoop()
    local waitDeadline = tick() + 20
    while auto.buyLBEnabled and tick() < waitDeadline do
        local lbs = S.selectedLBs
        if lbs and #lbs > 0 then break end
        if getgenv().OxyoSelectedLBs and #getgenv().OxyoSelectedLBs > 0 then
            S.selectedLBs = getgenv().OxyoSelectedLBs
            break
        end
        task.wait(0.3)
    end
    if not S.selectedLBs or #S.selectedLBs == 0 then
        Rayfield:Notify({ Title="Auto Buy LB", Content="Select at least one Lucky Block first!", Duration=3, Image=4483362458 })
        auto.buyLBEnabled = false
        _resetAutoBuyLBFlag()
        return
    end
    local names = {}
    for _, k in ipairs(S.selectedLBs) do
        local d = GEAR_REGISTRY[k]
        if d then table.insert(names, d.displayName) end
    end
    Rayfield:Notify({
        Title   = "🌙 LB Auto Buy Active",
        Content = table.concat(names, ", ") .. "\nRuns forever — toggle OFF to stop.",
        Duration = 4,
        Image   = 4483362458,
    })
    while auto.buyLBEnabled do
        _lbBuyStats.attempts = _lbBuyStats.attempts + 1
        if not _ensureRemote() then task.wait(3) continue end
        if (not S.selectedLBs or #S.selectedLBs == 0) and getgenv().OxyoSelectedLBs and #getgenv().OxyoSelectedLBs > 0 then
            S.selectedLBs = getgenv().OxyoSelectedLBs
        end
        local lbsToTry = S.selectedLBs and #S.selectedLBs > 0 and S.selectedLBs or {}
        if #lbsToTry == 0 then task.wait(2) continue end
        local deadline = tick() + 10
        while tick() < deadline do
            local char = Players.LocalPlayer.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then break end
            task.wait(0.5)
        end
        for _, lbKey in ipairs(lbsToTry) do
            if not auto.buyLBEnabled then break end
            local data = GEAR_REGISTRY[lbKey]
            if not data then continue end
            local result
            pcall(function() result = buyGear(lbKey) end)
            result = result or BUY_RESULT.NOT_IN_SHOP
            if result == BUY_RESULT.SUCCESS then
                _lbBuyStats.total = _lbBuyStats.total + 1
                _throttledLBNotify("success","✅ LB Purchased!", data.displayName .. " — " .. _lbBuyStats.total .. " bought")
            elseif result == BUY_RESULT.OUT_OF_STOCK then
                _throttledLBNotify("oos","⏳ LB Out of Stock", data.displayName)
            elseif result == BUY_RESULT.NO_COINS then
                _throttledLBNotify("coins","💰 No Coins", "Not enough coins for " .. data.displayName)
            end
            task.wait(0.5)
        end
        _updateLBStatsHUD()
        local jitter = (math.random(0, 600) / 1000) - 0.3
        task.wait(2 + jitter)
    end
end
GearTab:CreateToggle({
    Name         = "Auto Buy Lucky Block",
    CurrentValue = false,
    Flag         = "AutoBuyLB",
    Callback     = function(Value)
        auto.buyLBEnabled = Value
        if Value then getgenv().OxyoAutoBuyLB = true end
        if Value then
            if (not S.selectedLBs or #S.selectedLBs == 0)
            and getgenv().OxyoSelectedLBs and #getgenv().OxyoSelectedLBs > 0 then
                S.selectedLBs = getgenv().OxyoSelectedLBs
            end
            _lbBuyStats = { total=0, attempts=0, startTick=tick() }
            _lastLBNotifTime = {}
            auto.buyLBThread = task.spawn(_runBuyLBLoop)
            task.spawn(function()
                task.wait(15)
                while auto.buyLBEnabled do
                    task.wait(10)
                    if auto.buyLBEnabled and (auto.buyLBThread == nil or coroutine.status(auto.buyLBThread) == "dead") then
                        auto.buyLBThread = task.spawn(_runBuyLBLoop)
                    end
                end
            end)
        else
            if auto.buyLBThread then pcall(task.cancel, auto.buyLBThread) auto.buyLBThread = nil end
            if _lbBuyStats.startTick > 0 then
                getgenv().OxyoAutoBuyLB = false
                pcall(function()
                    _lbBuyStatsPara:Set({
                        Title   = "📊 Auto Buy LB — Stopped",
                        Content = string.format("Session ended.\n✅ Bought: %d  •  🔄 Attempts: %d", _lbBuyStats.total, _lbBuyStats.attempts),
                    })
                end)
                Rayfield:Notify({
                    Title   = "Auto Buy LB Stopped",
                    Content = string.format("Bought %d Lucky Blocks this session", _lbBuyStats.total),
                    Duration = 5,
                    Image   = 4483362458,
                })
            end
        end
    end,
})
end)()
;(function()
GearTab:CreateSection("Auto Buy")
GearTab:CreateParagraph({
    Title   = "Auto Buy — Night Farm Mode",
    Content = "Buys the selected gear every ~2s forever.\n"
           .. "✅ Continues buying after success\n"
           .. "⏳ Out of Stock → retries in 2s\n"
           .. "💰 No Coins → retries in 2s\n"
           .. "💀 Respawn-safe · 🌙 Night Farm ready\n"
           .. "Toggle OFF to stop.",
})
local _resetAutoBuyFlag do
    _resetAutoBuyFlag = function()
        pcall(function()
            local flag = Rayfield.Flags and Rayfield.Flags["AutoBuyGear"]
            if flag then flag:Set(false) end
        end)
    end
end
local _buyStatsPara = GearTab:CreateParagraph({
    Title   = "📊 Auto Buy Stats",
    Content = "Idle",
})
local _buyStats = { total=0, spent=0, attempts=0, startTick=0 }
local function _updateStatsHUD()
    if not auto.buyEnabled then return end
    pcall(function()
        local elapsed  = tick() - _buyStats.startTick
        local mins     = math.floor(elapsed / 60)
        local secs     = math.floor(elapsed % 60)
        local data     = S.selectedGear and GEAR_REGISTRY[S.selectedGear]
        local gearName = data and data.displayName or "—"
        _buyStatsPara:Set({
            Title   = "📊 Auto Buy — " .. gearName,
            Content = string.format(
                "✅ Bought: %d  •  💰 Spent: ~%d coins\n"
             .. "🔄 Attempts: %d  •  ⏱ Running: %02d:%02d",
                _buyStats.total, _buyStats.spent, _buyStats.attempts, mins, secs),
        })
    end)
end
local _lastNotifTime = {}
local function _throttledNotify(rtype, title, content)
    local now  = tick()
    local last = _lastNotifTime[rtype] or 0
    if now - last < 30 then return end
    _lastNotifTime[rtype] = now
    pcall(function()
        Rayfield:Notify({ Title=title, Content=content, Duration=3, Image=4483362458 })
    end)
end
local function _ensureRemote()
    if _VP_REMOTE and _VP_REMOTE.Parent then return true end
    local ok, found = pcall(function()
        return ReplicatedStorage:WaitForChild("Events", 3):WaitForChild("VendorPurchase", 3)
    end)
    if ok and found then _VP_REMOTE = found return true end
    return false
end
local function _waitForAliveCharacter(maxWait)
    maxWait = maxWait or 10
    local deadline = tick() + maxWait
    while tick() < deadline do
        local char = Players.LocalPlayer.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then return true end
        task.wait(0.5)
    end
    return false
end
local function _runBuyLoop()
    while auto.buyEnabled do
        _buyStats.attempts = _buyStats.attempts + 1
        if not _ensureRemote() then
            _throttledNotify("no_remote","⚠️ Remote Missing","VendorPurchase not found — waiting...")
            task.wait(5) continue
        end
        if not _waitForAliveCharacter(10) then task.wait(2) continue end
        local gearsToTry = {}
        if S.selectedGears and #S.selectedGears > 0 then
            gearsToTry = S.selectedGears
        elseif S.selectedGear then
            gearsToTry = { S.selectedGear }
        end
        if #gearsToTry == 0 then task.wait(2) continue end
        for _, gearKey in ipairs(gearsToTry) do
            if not auto.buyEnabled then break end
            local currentData = GEAR_REGISTRY[gearKey]
            if not currentData then continue end
            local result
            pcall(function() result = buyGear(gearKey) end)
            result = result or BUY_RESULT.NOT_IN_SHOP
            if result == BUY_RESULT.SUCCESS then
                _buyStats.total = _buyStats.total + 1
                _buyStats.spent = _buyStats.spent + (currentData.coinPrice or 0)
                _throttledNotify("success","✅ Purchased!",
                    currentData.displayName .. " — " .. _buyStats.total .. " bought this session")
            elseif result == BUY_RESULT.OUT_OF_STOCK then
                local secs    = _getVendorTimerSeconds()
                local timeStr = secs and string.format(" (restock in %02d:%02d)", math.floor(secs/60), secs%60) or ""
                _throttledNotify("oos","⏳ Out of Stock", currentData.displayName .. timeStr)
                task.delay(3, function()
                    if not auto.buyEnabled then return end
                    local normDN = _normaliseKey(currentData.displayName)
                    local normSK = _normaliseKey(currentData.serverKey)
                    local toErase = {}
                    for k, v in pairs(_stockData) do
                        if v.manual and not v.inStock then
                            local normK = _normaliseKey(k)
                            if normK == normDN or normK == normSK
                            or normK:find(normSK,1,true) or normSK:find(normK,1,true) then
                                table.insert(toErase, k)
                            end
                        end
                    end
                    for _, k in ipairs(toErase) do _stockData[k] = nil end
                end)
            elseif result == BUY_RESULT.NO_COINS then
                _throttledNotify("coins","💰 Not Enough Coins","Need " .. (currentData.coinPrice or 0) .. " coins for " .. currentData.displayName)
            elseif result == BUY_RESULT.NOT_IN_SHOP then
                _writeStock(currentData.displayName, true, 1, false)
            end
            task.wait(0.5)
        end
        _updateStatsHUD()
        local jitter = (math.random(0, 600) / 1000) - 0.3
        task.wait(2 + jitter)
    end
end
GearTab:CreateToggle({
    Name         = "Auto Buy",
    CurrentValue = false,
    Flag         = "AutoBuyGear",
    Callback     = function(Value)
        auto.buyEnabled = Value
        if Value then
            if #S.selectedGears == 0 and not S.selectedGear then
                Rayfield:Notify({ Title="Auto Buy", Content="Select a gear from the list first!", Duration=3, Image=4483362458 })
                auto.buyEnabled = false
                _resetAutoBuyFlag()
                return
            end
            if not S.selectedGear and #S.selectedGears > 0 then
                S.selectedGear = S.selectedGears[1]
            end
            local data = GEAR_REGISTRY[S.selectedGear]
            _buyStats = { total=0, spent=0, attempts=0, startTick=tick() }
            _lastNotifTime = {}
            Rayfield:Notify({
                Title   = "🌙 Night Farm Active",
                Content = "Auto buying: " .. data.displayName .. "\nRuns forever — toggle OFF to stop.",
                Duration = 4,
                Image   = 4483362458,
            })
            auto.buyThread = task.spawn(_runBuyLoop)
            task.spawn(function()
                task.wait(15)
                while auto.buyEnabled do
                    task.wait(10)
                    if auto.buyEnabled and (auto.buyThread == nil or coroutine.status(auto.buyThread) == "dead") then
                        Rayfield:Notify({ Title="⚠️ Auto Buy", Content="Thread recovered — restarting.", Duration=3, Image=4483362458 })
                        auto.buyThread = task.spawn(_runBuyLoop)
                    end
                end
            end)
        else
            if auto.buyThread then pcall(task.cancel, auto.buyThread) auto.buyThread = nil end
            local data  = S.selectedGear and GEAR_REGISTRY[S.selectedGear]
            local name  = data and data.displayName or "Gear"
            pcall(function()
                _buyStatsPara:Set({
                    Title   = "📊 Auto Buy — Stopped",
                    Content = string.format(
                        "Session ended.\n✅ Bought: %d %s  •  💰 Spent: ~%d coins\n🔄 Total Attempts: %d",
                        _buyStats.total, name, _buyStats.spent, _buyStats.attempts),
                })
            end)
            Rayfield:Notify({
                Title   = "Auto Buy Stopped",
                Content = string.format("Bought %d × %s  •  ~%d coins spent", _buyStats.total, name, _buyStats.spent),
                Duration = 5,
                Image   = 4483362458,
            })
        end
    end,
})
end)()
local function getRequiredVolcanoBrainrot()
    local vo = workspace:FindFirstChild("GameFolder") and workspace.GameFolder:FindFirstChild("VolcanoObby")
    local dr = vo and vo:FindFirstChild("DinoRender")
    if not dr then return nil, nil end
    for _, v in pairs(dr:GetChildren()) do
        if v:IsA("Model") then
            local n = v:GetAttribute("Name")
            local mut = v:GetAttribute("Mutation") or "Normal"
            if n and n ~= "" then
                return n, mut
            end
        end
    end
    return nil, nil
end
local function findVolcanoTarget(reqName, reqMut)
    for _, rarity in ipairs(ALL_RARITIES) do
        local folder = getBrainrotFolder(rarity)
        if folder then
            for _, obj in pairs(folder:GetChildren()) do
                if obj and obj.Parent then
                    local objNameAttr    = obj:GetAttribute("Name")        or ""
                    local objDisplayName = obj:GetAttribute("DisplayName") or ""
                    local objMut         = obj:GetAttribute("Mutation")    or "Normal"
                    if (objNameAttr == reqName or objDisplayName == reqName) and objMut == reqMut then
                        return obj
                    end
                end
            end
        end
    end
    return nil
end
local function isVolcanoEventActive()
    return true
end
local GREEN_LINE = Vector3.new(-31.773190, 4.259904, -56.313618)
local function submitToVolcano()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local vo = workspace:FindFirstChild("GameFolder") and workspace.GameFolder:FindFirstChild("VolcanoObby")
    local dino = vo and vo:FindFirstChild("TralaleroDinosauro")
    local rootPart = dino and dino:FindFirstChild("RootPart")
    local att = rootPart and rootPart:FindFirstChild("UIAttachment")
    local prompt = att and att:FindFirstChildWhichIsA("ProximityPrompt")
    local tw1 = TweenService:Create(root,
        TweenInfo.new(1.2, Enum.EasingStyle.Linear),
        { CFrame = CFrame.new(GREEN_LINE) }
    )
    tw1:Play() tw1.Completed:Wait()
    walkForward(5, 3)
    if rootPart then
        local tw2 = TweenService:Create(root,
            TweenInfo.new(0.5, Enum.EasingStyle.Linear),
            { CFrame = CFrame.new(rootPart.Position + Vector3.new(0, 4, 0)) }
        )
        tw2:Play() tw2.Completed:Wait()
    end
    task.wait(0.5)
    if prompt then
        _fireprox(prompt)
        task.wait(0.3)
    end
    local submitRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    submitRemote = submitRemote and submitRemote:FindFirstChild("VolcanoObby")
    submitRemote = submitRemote and submitRemote:FindFirstChild("SubmitBrainrot")
    if submitRemote then
        pcall(function() submitRemote:FireServer() end)
    end
    task.wait(0.5)
end
;(function()
local function _findFragments()
    local found, seen = {}, {}
    local _charSet = {}
    pcall(function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character then _charSet[plr.Character] = true end
        end
    end)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if not (obj and obj.Parent) then continue end
        local n = obj.Name:lower()
        if not (n:find("fragment") or n == "frag") then continue end
        if not (obj:IsA("BasePart") or obj:IsA("Model")) then continue end
        local oa = obj:GetAttribute("Owner") or obj:GetAttribute("Carrying")
               or obj:GetAttribute("IsHeld") or obj:GetAttribute("HeldBy")
        if oa and tostring(oa) ~= "" and tostring(oa) ~= "0" then continue end
        local skip = false
        local anc = obj.Parent
        while anc and anc ~= workspace do
            if seen[anc] then skip = true break end
            if _charSet[anc] then skip = true break end
            local an = anc.Name
            if an == "Plots" or an == "Plot" or an == "PlayerPlot"
            or an == "PlacedItems" or an == "Furniture" or an == "Chair"
            or an == "FuseMachine" or an == "ForbiddenFuse" or an == "FuseSlot"
            or an == "BrainrotSlot" or an == "Slot" or an == "InputSlot"
            or an == "MachinePart" or an == "SubmitArea" or an == "FragmentSlot"
            or an == "FragmentHolder" or an == "SubmitZone" or an == "Throne"
            or an == "ThroneSlot" or an == "ForbiddenThrone" then
                skip = true break
            end
            anc = anc.Parent
        end
        if not skip and not _isFragmentTaken(obj) then
            seen[obj] = true
            table.insert(found, obj)
        end
    end
    return found
end
local function _grabFragmentObj(obj)
    if not obj or not obj.Parent then return false end
    if _isFragmentTaken(obj) then return false end
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local part = (obj:IsA("BasePart") and obj)
        or obj.PrimaryPart
        or obj:FindFirstChildWhichIsA("BasePart")
    if not part then return false end
    safeTeleport(part.CFrame * CFrame.new(0, 4, 0))
    task.wait(0.15)
    root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    pcall(function() root.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0)) end)
    task.wait(0.2)
    local parts = obj:IsA("BasePart") and { obj } or obj:GetDescendants()
    for _, p in ipairs(parts) do
        if p:IsA("BasePart") then
            _firetouchinterest(root, p, 0)
            task.wait(0.05)
        end
    end
    local allDesc = obj:IsA("Model") and obj:GetDescendants() or { obj }
    for _, d in ipairs(allDesc) do
        if d:IsA("ProximityPrompt") then
            local prompt = d
            local origHold = prompt.HoldDuration
            pcall(function() prompt.HoldDuration = 0 end)
            pcall(function() prompt.MaxActivationDistance = 999 end)
            local fired = typeof(fireproximityprompt) == "function" and pcall(fireproximityprompt, prompt)
            if not fired then fired = pcall(function()
                game:GetService("ProximityPromptService"):PromptTriggered(prompt, player)
            end) end
            if not fired then pcall(function()
                local ev = ReplicatedStorage:FindFirstChild("Events")
                local interact = ev and (ev:FindFirstChild("Interact") or ev:FindFirstChild("ProximityPrompt")
                    or ev:FindFirstChild("Trigger") or ev:FindFirstChild("PickUp") or ev:FindFirstChild("Collect"))
                if interact then interact:FireServer(prompt) fired = true end
            end) end
            if not fired then
                _firetouchinterest(root, part, 0)
                task.wait(0.05)
            end
            task.wait(0.15)
            pcall(function() prompt.HoldDuration = origHold end)
            pcall(function() prompt.MaxActivationDistance = 10 end)
            break
        end
    end
    local deadline = tick() + 2
    while obj.Parent and tick() < deadline do
        task.wait(0.1)
    end
    if obj.Parent then return false end
    pcall(function()
        local pid = tostring(game.PlaceId)
        local jid = tostring(game.JobId)
        local serverLink = "https://www.roblox.com/games/start?placeId=" .. pid .. "&gameInstanceId=" .. jid .. "&startPlaceId=" .. pid
        sendWebhook("🔷 Fragment Collected!", "Fragment grabbed!\n[Join Server](" .. serverLink .. ")", 0x3399FF)
    end)
    return true
end
ForbiddenTab:CreateParagraph({
    Title   = "🚫 Forbidden Zone",
    Content = "New underground zone.\nFuse 4 Brainrots → get Fragment → submit 10 to Throne → craft Forbidden La Everything Combinaziones.",
})
ForbiddenTab:CreateSection("Teleport")
ForbiddenTab:CreateButton({
    Name     = "🚫 Teleport to Forbidden Entry",
    Callback = function()
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root then root.CFrame = CFrame.new(Vector3.new(4.677, 57.931, -3700.579)) end
    end,
})
ForbiddenTab:CreateButton({
    Name     = "🧬 Teleport to Fuse Machine",
    Callback = function()
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local gf  = workspace:FindFirstChild("GameFolder")
        local fuse = gf and gf:FindFirstChild("ForbiddenFuse")
        if fuse then
            local ok, cf = pcall(function() return fuse:GetModelCFrame() end)
            if ok then root.CFrame = CFrame.new(cf.Position + Vector3.new(0, 4, 6)) return end
        end
        root.CFrame = CFrame.new(Vector3.new(-11.554, 34, -6342))
    end,
})
ForbiddenTab:CreateSection("Auto Collect")
ForbiddenTab:CreateToggle({
    Name         = "Auto Farm Fragments",
    CurrentValue = false,
    Flag         = "AutoFragment",
    Callback     = function(v)
        S.autoFragmentEnabled = v
        if S.autoFragmentConn then
            S.autoFragmentConn:Disconnect()
            S.autoFragmentConn = nil
        end
        if S.autoFragmentThread then
            pcall(task.cancel, S.autoFragmentThread)
            S.autoFragmentThread = nil
        end
        if not v then
            if S._fragForcedInstantGrab then
                S._fragForcedInstantGrab = false
                S.instantGrabEnabled = false
                if S.instantGrabConnection then
                    S.instantGrabConnection:Disconnect()
                    S.instantGrabConnection = nil
                end
                for prompt, originalTime in pairs(S.OriginalHoldTimes) do
                    if prompt and prompt.Parent then prompt.HoldDuration = originalTime end
                end
                S.OriginalHoldTimes = {}
                pcall(function()
                    local flag = Rayfield.Flags and Rayfield.Flags["InstantGrab"]
                    if flag then flag:Set(false) end
                end)
            end
            Rayfield:Notify({ Title = "🔷 Fragments", Content = "Auto Farm OFF", Duration = 3, Image = 4483362458 })
            return
        end
        hideLava()
        if not S.instantGrabEnabled then
            S._fragForcedInstantGrab = true
            S.instantGrabEnabled = true
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    if not S.OriginalHoldTimes[obj] then S.OriginalHoldTimes[obj] = obj.HoldDuration end
                    obj.HoldDuration = 0
                end
            end
            S.instantGrabConnection = workspace.DescendantAdded:Connect(function(obj)
                if obj:IsA("ProximityPrompt") then
                    task.wait()
                    if not S.OriginalHoldTimes[obj] then S.OriginalHoldTimes[obj] = obj.HoldDuration end
                    obj.HoldDuration = 0
                end
            end)
            pcall(function()
                local flag = Rayfield.Flags and Rayfield.Flags["InstantGrab"]
                if flag then flag:Set(true) end
            end)
        else
            S._fragForcedInstantGrab = false
        end
        Rayfield:Notify({ Title = "🔷 Auto Farm Fragments", Content = "Running — Remove Lava + Instant Grab active.", Duration = 4, Image = 4483362458 })
        S.autoFragmentThread = task.spawn(function()
            local _attemptedFrags = {}
            while S.autoFragmentEnabled do
                local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if not root then task.wait(0.5) continue end
                for fObj in pairs(_attemptedFrags) do
                    if not fObj.Parent then _attemptedFrags[fObj] = nil end
                end
                local frags = _findFragments()
                local pendingFrags = {}
                for _, f in ipairs(frags) do
                    if not _attemptedFrags[f] then
                        table.insert(pendingFrags, f)
                    end
                end
                if #pendingFrags == 0 then task.wait(1) continue end
                table.sort(pendingFrags, function(a, b)
                    local function getPos(o)
                        if o:IsA("BasePart") then return o.Position end
                        local ok, cf = pcall(function() return o:GetModelCFrame() end)
                        return ok and cf.Position or Vector3.zero
                    end
                    return (getPos(a) - root.Position).Magnitude < (getPos(b) - root.Position).Magnitude
                end)
                local grabbed = 0
                for _, frag in ipairs(pendingFrags) do
                    if not S.autoFragmentEnabled then break end
                    if S.grabLock then break end
                    _attemptedFrags[frag] = true
                    local ok, did = pcall(_grabFragmentObj, frag)
                    if ok and did then grabbed = grabbed + 1 end
                end
                if grabbed > 0 and S.autoFragmentEnabled then
                    pcall(function()
                        local rs = game:GetService("ReplicatedStorage")
                        local remote = rs:FindFirstChild("SubmitFragment")
                        if remote then remote:FireServer() end
                    end)
                    pcall(submitAndPlace)
                    if not teleportToMyPlot() then
                        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                        if root then pcall(function() root.CFrame = getSafeBase() end) end
                    end
                    task.wait(2.5)
                end
                task.wait(0.5)
            end
        end)
        S.autoFragmentConn = workspace.DescendantAdded:Connect(function(obj)
            if not S.autoFragmentEnabled then return end
            local n = obj.Name:lower()
            if not (n:find("fragment") or n == "frag") then return end
            if not (obj:IsA("BasePart") or obj:IsA("Model")) then return end
            task.spawn(function()
                task.wait(0.3)
                if not S.autoFragmentEnabled or not obj.Parent then return end
                local ok, did = pcall(_grabFragmentObj, obj)
                if ok and did and S.autoFragmentEnabled then
                    pcall(function()
                        local rs = game:GetService("ReplicatedStorage")
                        local remote = rs:FindFirstChild("SubmitFragment")
                        if remote then remote:FireServer() end
                    end)
                    pcall(submitAndPlace)
                    if not teleportToMyPlot() then
                        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                        if root then pcall(function() root.CFrame = getSafeBase() end) end
                    end
                end
            end)
        end)
    end,
})
ForbiddenTab:CreateSection("Fragments")
ForbiddenTab:CreateButton({
    Name     = "🔷 Submit Fragment (x1)",
    Callback = function()
        local rs = game:GetService("ReplicatedStorage")
        local remote = rs:FindFirstChild("SubmitFragment")
        if not remote then
            Rayfield:Notify({ Title = "❌ Submit Fragment", Content = "SubmitFragment remote not found.", Duration = 4, Image = 4483362458 })
            return
        end
        local ok, err = pcall(function() remote:FireServer() end)
        if ok then
            Rayfield:Notify({ Title = "🔷 Fragment Submitted", Content = "Fired SubmitFragment!", Duration = 3, Image = 4483362458 })
        else
            Rayfield:Notify({ Title = "❌ Error", Content = tostring(err), Duration = 4, Image = 4483362458 })
        end
    end,
})
ForbiddenTab:CreateSection("Forbidden Fuse")
ForbiddenTab:CreateButton({
    Name     = "🧬 Open Forbidden Fuse UI",
    Callback = function()
        local gf   = workspace:FindFirstChild("GameFolder")
        local fuse = gf and gf:FindFirstChild("ForbiddenFuse")
        if not fuse then
            Rayfield:Notify({ Title = "❌ ForbiddenFuse", Content = "ForbiddenFuse not found in workspace.", Duration = 4, Image = 4483362458 })
            return
        end
        local btn = fuse:FindFirstChild("UIButton")
        local prompt = btn and btn:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt then
            pcall(function()
                if typeof(fireproximityprompt) == "function" then
                    fireproximityprompt(prompt)
                end
            end)
            Rayfield:Notify({ Title = "🧬 ForbiddenFuse", Content = "Opened UI!", Duration = 3, Image = 4483362458 })
        else
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root then root.CFrame = CFrame.new(Vector3.new(-11.554, 34, -6342)) end
            Rayfield:Notify({ Title = "🧬 ForbiddenFuse", Content = "Prompt not found, teleported to machine.", Duration = 3, Image = 4483362458 })
        end
    end,
})
ForbiddenTab:CreateButton({
    Name     = "📦 Collect Fuse Result",
    Callback = function()
        local gf     = workspace:FindFirstChild("GameFolder")
        local fuse   = gf and gf:FindFirstChild("ForbiddenFuse")
        local result = fuse and fuse:FindFirstChild("Result")
        if not result then
            Rayfield:Notify({ Title = "❌ Result", Content = "No result part found.", Duration = 3, Image = 4483362458 })
            return
        end
        local att    = result:FindFirstChild("CollectAttachment")
        local prompt = att and att:FindFirstChildWhichIsA("ProximityPrompt")
        if prompt then
            pcall(function()
                if typeof(fireproximityprompt) == "function" then
                    fireproximityprompt(prompt)
                end
            end)
            Rayfield:Notify({ Title = "📦 Collected!", Content = "Fired collect prompt.", Duration = 3, Image = 4483362458 })
        else
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(result.Position + Vector3.new(0, 3, 0))
                if typeof(firetouchinterest) == "function" then
                    pcall(function() firetouchinterest(root, result, 0) end)
                    task.wait(0.05)
                    pcall(function() firetouchinterest(root, result, 1) end)
                end
            end
            Rayfield:Notify({ Title = "📦 Collect", Content = "Prompt not found, used touch.", Duration = 3, Image = 4483362458 })
        end
    end,
})
end)()
ZonesTab:CreateSection("Teleport to Zones")
do
local zones = {
    { name = "Common Zone",    pos = Vector3.new(-5.604886,   6.981283,    -181.638321) },
    { name = "Rare Zone",      pos = Vector3.new(3.469897,    21.468637,   -381.855286) },
    { name = "Epic Zone",      pos = Vector3.new(1.057454,    19.648050,   -653.962280) },
    { name = "Legendary Zone", pos = Vector3.new(34.306286,   29.472792,   -933.720398) },
    { name = "Mythic Zone",    pos = Vector3.new(-4.003283,   41.508194,  -1372.488647) },
    { name = "Secret Zone",    pos = Vector3.new(-41.617702,  77.059113,  -1857.829224) },
    { name = "Celestial Zone", pos = Vector3.new(-44.376785, 170.028870,  -2253.302979) },
    { name = "End Zone",       pos = Vector3.new(-16.794611, 444.921265,  -3505.147217) },
    { name = "🚫 Forbidden Zone", pos = Vector3.new(4.677,    57.931,      -3700.579)   },
}
for _, zone in ipairs(zones) do
    ZonesTab:CreateButton({
        Name     = zone.name,
        Callback = function()
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root then root.CFrame = CFrame.new(zone.pos) end
        end,
    })
end
end
HitboxTab:CreateSection("Hitbox Settings")
HitboxTab:CreateToggle({
    Name         = "Hitbox On/Off",
    CurrentValue = false,
    Flag         = "HitboxToggle",
    Callback     = function(Value)
        S.hitboxEnabled = Value
        if not Value then
            for _, v in next, Players:GetPlayers() do
                if v ~= player then
                    pcall(function()
                        local root = v.Character and v.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            root.Size         = Vector3.new(2, 2, 1)
                            root.Transparency = 1
                            root.CanCollide   = false
                        end
                    end)
                end
            end
        end
    end,
})
HitboxTab:CreateSlider({
    Name         = "Hitbox Size",
    Range        = {5, 150},
    Increment    = 5,
    Suffix       = "Studs",
    CurrentValue = 50,
    Flag         = "HitboxSize",
    Callback     = function(Value) S.hitboxSize = Value end,
})
HitboxTab:CreateSlider({
    Name         = "Hitbox Transparency",
    Range        = {0, 10},
    Increment    = 1,
    Suffix       = "/10",
    CurrentValue = 7,
    Flag         = "HitboxTransp",
    Callback     = function(Value) S.hitboxTransp = Value / 10 end,
})
HitboxTab:CreateDropdown({
    Name          = "Hitbox Color",
    Options       = {"Really blue","Bright red","Lime green","Hot pink","Cyan","Really black","White"},
    CurrentOption = {"Really blue"},
    Flag          = "HitboxColor",
    Callback      = function(Option) S.hitboxColor = BrickColor.new(type(Option)=="table" and Option[1] or Option) end,
})
ExtraTab:CreateSection("Visual Enhancements")
ExtraTab:CreateToggle({
    Name         = "FullBright",
    CurrentValue = false,
    Flag         = "FullBright",
    Callback     = function(Value)
        S.fullBrightEnabled = Value
        if Value then
            Lighting.Brightness     = 2
            Lighting.ClockTime      = 14
            Lighting.FogEnd         = 100000
            Lighting.GlobalShadows  = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        else
            Lighting.Brightness     = origLight[1]
            Lighting.ClockTime      = origLight[2]
            Lighting.FogEnd         = origLight[3]
            Lighting.GlobalShadows  = origLight[4]
            Lighting.OutdoorAmbient = origLight[5]
        end
    end,
})
ExtraTab:CreateButton({
    Name     = "Remove Fog",
    Callback = function()
        Lighting.FogEnd   = 100000
        Lighting.FogStart = 0
    end,
})
ExtraTab:CreateToggle({
    Name         = "Infinite Zoom",
    CurrentValue = false,
    Flag         = "InfiniteZoom",
    Callback     = function(Value)
        S.infiniteZoomEnabled = Value
        if Value then
            player.CameraMaxZoomDistance = 99999
            player.CameraMinZoomDistance = 0
        else
            player.CameraMaxZoomDistance = 128
            player.CameraMinZoomDistance = 0.5
        end
    end,
})
ExtraTab:CreateSection("ESP Features")
ExtraTab:CreateToggle({
    Name         = "Player ESP",
    CurrentValue = false,
    Flag         = "PlayerESP",
    Callback     = function(Value)
        local function createESP(target)
            if not target or not target:FindFirstChild("HumanoidRootPart") then return end
            if target:FindFirstChild("PlayerESP") then return end
            local h = Instance.new("Highlight")
            h.Parent              = target
            h.FillColor           = Color3.fromRGB(255, 0, 0)
            h.OutlineColor        = Color3.fromRGB(255, 255, 255)
            h.FillTransparency    = 0.5
            h.OutlineTransparency = 0
            h.Name                = "PlayerESP"
        end
        local function removeESP(target)
            if target then
                local esp = target:FindFirstChild("PlayerESP")
                if esp then esp:Destroy() end
            end
        end
        S.playerESPEnabled = Value
        if Value then
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character then
                    createESP(otherPlayer.Character)
                end
            end
            S.espConnections.PlayerAdded = Players.PlayerAdded:Connect(function(newPlayer)
                if S.playerESPEnabled then
                    newPlayer.CharacterAdded:Connect(function(char)
                        if S.playerESPEnabled then task.wait(0.5) createESP(char) end
                    end)
                end
            end)
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player then
                    S.espConnections[otherPlayer.UserId] = otherPlayer.CharacterAdded:Connect(function(char)
                        if S.playerESPEnabled then task.wait(0.5) createESP(char) end
                    end)
                end
            end
        else
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer.Character then removeESP(otherPlayer.Character) end
            end
            for _, conn in pairs(S.espConnections) do
                if conn then conn:Disconnect() end
            end
            S.espConnections = {}
        end
    end,
})
ExtraTab:CreateToggle({
    Name         = "Celestial ESP",
    CurrentValue = false,
    Flag         = "CelestialESP",
    Callback     = function(Value)
        S.celestialESPEnabled = Value
        if Value then
            local function addCelestialESP()
                pcall(function()
                    local gf = workspace:FindFirstChild("GameFolder")
                    if not gf then return end
                    local br = gf:FindFirstChild("Brainrots")
                    if not br then return end
                    local cf = br:FindFirstChild("Celestial")
                    if not cf then return end
                    for _, obj in pairs(cf:GetChildren()) do
                        if obj:IsA("Model") and not obj:FindFirstChild("CelestialESP") then
                            local h = Instance.new("Highlight")
                            h.Parent              = obj
                            h.FillColor           = Color3.fromRGB(255, 255, 0)
                            h.OutlineColor        = Color3.fromRGB(255, 255, 255)
                            h.FillTransparency    = 0.3
                            h.OutlineTransparency = 0
                            h.Name                = "CelestialESP"
                        end
                    end
                end)
            end
            addCelestialESP()
            S.celestialESPConnection = task.spawn(function()
                while S.celestialESPEnabled do
                    task.wait(1)
                    addCelestialESP()
                end
            end)
        else
            if S.celestialESPConnection then
                S.celestialESPEnabled = false
                S.celestialESPConnection = nil
            end
            pcall(function()
                local gf = workspace:FindFirstChild("GameFolder")
                if not gf then return end
                local br = gf:FindFirstChild("Brainrots")
                if not br then return end
                local cf = br:FindFirstChild("Celestial")
                if not cf then return end
                for _, obj in pairs(cf:GetDescendants()) do
                    if obj.Name == "CelestialESP" then obj:Destroy() end
                end
            end)
        end
    end,
})
ExtraTab:CreateSection("🦇 Anti-Bat Stun")
ExtraTab:CreateToggle({
    Name         = "🦇 Anti-Bat Stun",
    CurrentValue = false,
    Flag         = "AntiBatStun",
    Callback     = function(val)
        S.antiBatEnabled = val
        local function applyAntiBat()
            if S.batRemote and S.batRemote.Parent then
            elseif ReplicatedStorage:FindFirstChild("Remotes") then
                S.batRemote = ReplicatedStorage.Remotes:FindFirstChild("BatStun")
            end
            if not S.batRemote then return false end
            if typeof(getconnections) == "function" then
                pcall(function()
                    for _, c in ipairs(getconnections(S.batRemote.OnClientEvent)) do
                        pcall(function() c:Disable() end)
                    end
                end)
            end
            if S.batStunConn then S.batStunConn:Disconnect() end
            S.batStunConn = S.batRemote.OnClientEvent:Connect(function()
                if not S.antiBatEnabled then return end
                task.spawn(function()
                    task.wait()
                    local char = player.Character
                    if not char then return end
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if not hum or hum.Health <= 0 then return end
                    pcall(function()
                        hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                        hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
                        hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                    end)
                    pcall(function()
                        for _, v in ipairs(char:GetDescendants()) do
                            if v:IsA("AnimationTrack") then
                                local n = v.Name:lower()
                                if n:find("stun") or n:find("bat") or n:find("freeze") then
                                    v:Stop(0.1)
                                end
                            end
                        end
                    end)
                end)
            end)
            return true
        end
        if val then
            local ok = applyAntiBat()
            if ok then
                Rayfield:Notify({ Title = "🦇 Anti-Bat Stun", Content = "ON — stun blocked.", Duration = 3, Image = 4483362458 })
            else
                Rayfield:Notify({ Title = "🦇 Anti-Bat Stun", Content = "Remote not found — watching...", Duration = 4, Image = 4483362458 })
                task.spawn(function()
                    while S.antiBatEnabled do
                        task.wait(5)
                        if applyAntiBat() then
                            Rayfield:Notify({ Title = "🦇 Anti-Bat Stun", Content = "Remote found! Active.", Duration = 3, Image = 4483362458 })
                            break
                        end
                    end
                end)
            end
        else
            if S.batStunConn then S.batStunConn:Disconnect() S.batStunConn = nil end
            Rayfield:Notify({ Title = "🦇 Anti-Bat Stun", Content = "OFF.", Duration = 2, Image = 4483362458 })
        end
    end,
})
ExtraTab:CreateSection("👑 Brainrot ESP Extras")
ExtraTab:CreateToggle({
    Name         = "👑 Godly ESP",
    CurrentValue = false,
    Flag         = "GodlyESPExtra",
    Callback     = function(val)
        S.godlyESPEnabled = val
        if val then
            local function addGodlyESP()
                pcall(function()
                    local br = getBrainrotsFolder()
                    local gd = br and br:FindFirstChild("Godly")
                    if not gd then return end
                    for _, obj in pairs(gd:GetChildren()) do
                        if obj:IsA("Model") and not obj:FindFirstChild("GodlyESPExtra") then
                            local h = Instance.new("Highlight")
                            h.Parent              = obj
                            h.FillColor           = Color3.fromRGB(255, 120, 30)
                            h.OutlineColor        = Color3.fromRGB(255, 215, 0)
                            h.FillTransparency    = 0.3
                            h.OutlineTransparency = 0
                            h.Name                = "GodlyESPExtra"
                        end
                    end
                end)
            end
            addGodlyESP()
            S.godlyESPConn = task.spawn(function()
                while S.godlyESPEnabled do task.wait(1) addGodlyESP() end
            end)
            Rayfield:Notify({ Title = "👑 Godly ESP", Content = "ON", Duration = 2, Image = 4483362458 })
        else
            S.godlyESPEnabled = false
            S.godlyESPConn    = nil
            pcall(function()
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v.Name == "GodlyESPExtra" then v:Destroy() end
                end
            end)
            Rayfield:Notify({ Title = "👑 Godly ESP", Content = "OFF", Duration = 2, Image = 4483362458 })
        end
    end,
})
local _FULL_ESP_COLORS = {
    Common    = { fill = Color3.fromRGB(180, 180, 180), outline = Color3.fromRGB(220, 220, 220) },
    Rare      = { fill = Color3.fromRGB(80,  140, 255), outline = Color3.fromRGB(120, 180, 255) },
    Epic      = { fill = Color3.fromRGB(180, 80,  255), outline = Color3.fromRGB(210, 130, 255) },
    Legendary = { fill = Color3.fromRGB(255, 180, 0),   outline = Color3.fromRGB(255, 210, 60)  },
    Mythic    = { fill = Color3.fromRGB(255, 80,  80),  outline = Color3.fromRGB(255, 140, 140) },
    Secret    = { fill = Color3.fromRGB(80,  220, 220), outline = Color3.fromRGB(150, 255, 255) },
    Celestial = { fill = Color3.fromRGB(255, 220, 100), outline = Color3.fromRGB(255, 255, 180) },
    Godly     = { fill = Color3.fromRGB(255, 120, 30),  outline = Color3.fromRGB(255, 215, 0)   },
    Forbidden = { fill = Color3.fromRGB(140, 30,  200), outline = Color3.fromRGB(200, 80,  255) },
}
ExtraTab:CreateToggle({
    Name         = "🌈 Full Rarity ESP",
    CurrentValue = false,
    Flag         = "FullRarityESPExtra",
    Callback     = function(val)
        S.fullESPEnabled = val
        if val then
            local function addFullESP()
                pcall(function()
                    local brFolder = getBrainrotsFolder()
                    if not brFolder then return end
                    for rarityName, colors in pairs(_FULL_ESP_COLORS) do
                        local rarFolder = brFolder:FindFirstChild(rarityName)
                        if not rarFolder then continue end
                        for _, obj in pairs(rarFolder:GetChildren()) do
                            if obj:IsA("Model") and not obj:FindFirstChild("FullRarityESP") then
                                local h = Instance.new("Highlight")
                                h.Parent              = obj
                                h.FillColor           = colors.fill
                                h.OutlineColor        = colors.outline
                                h.FillTransparency    = 0.35
                                h.OutlineTransparency = 0
                                h.Name                = "FullRarityESP"
                            end
                        end
                    end
                end)
            end
            addFullESP()
            S.fullESPConn = task.spawn(function()
                while S.fullESPEnabled do task.wait(1.5) addFullESP() end
            end)
            Rayfield:Notify({ Title = "🌈 Full Rarity ESP", Content = "ON — all rarities highlighted.", Duration = 3, Image = 4483362458 })
        else
            S.fullESPEnabled = false
            S.fullESPConn    = nil
            pcall(function()
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v.Name == "FullRarityESP" then v:Destroy() end
                end
            end)
            Rayfield:Notify({ Title = "🌈 Full Rarity ESP", Content = "OFF", Duration = 2, Image = 4483362458 })
        end
    end,
})
;(function()
local RARITY_COLORS = {
    Common    = Color3.fromRGB(180, 180, 180),
    Uncommon  = Color3.fromRGB(100, 220, 100),
    Rare      = Color3.fromRGB(80,  140, 255),
    Epic      = Color3.fromRGB(180, 80,  255),
    Legendary = Color3.fromRGB(255, 180, 0),
    Mythic    = Color3.fromRGB(255, 80,  80),
    Secret    = Color3.fromRGB(80,  220, 220),
    Celestial = Color3.fromRGB(255, 220, 100),
    Godly     = Color3.fromRGB(255, 120, 30),
}
local MUTATION_COLORS = {
    Gold      = Color3.fromRGB(255, 215, 0),
    Emerald   = Color3.fromRGB(80,  200, 120),
    Diamond   = Color3.fromRGB(150, 220, 255),
    Cheese    = Color3.fromRGB(255, 200, 50),
    Bloodmoon = Color3.fromRGB(200, 40,  40),
    Rainbow   = Color3.fromRGB(255, 100, 200),
    Normal    = Color3.fromRGB(120, 120, 140),
}
local listGui = Instance.new("ScreenGui")
listGui.Name           = "OxyoBrainrotList"
listGui.ResetOnSpawn   = false
listGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
listGui.DisplayOrder   = 999
listGui.IgnoreGuiInset = true
pcall(function() listGui.Parent = game:GetService("CoreGui") end)
if not listGui.Parent then listGui.Parent = player.PlayerGui end
local panel = Instance.new("Frame")
panel.Name             = "Panel"
panel.Size             = UDim2.new(0, 320, 0, 400)
panel.Position         = UDim2.new(0.5, -160, 0.5, -200)
panel.BackgroundColor3 = Color3.fromRGB(13, 13, 20)
panel.BorderSizePixel  = 0
panel.Visible          = false
panel.ClipsDescendants = true
panel.Parent           = listGui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)
local ps = Instance.new("UIStroke", panel)
ps.Color     = Color3.fromRGB(55, 55, 75)
ps.Thickness = 1
local titleBar = Instance.new("Frame", panel)
titleBar.Name             = "TitleBar"
titleBar.Size             = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
titleBar.BorderSizePixel  = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)
local tbFix = Instance.new("Frame", titleBar)
tbFix.Size             = UDim2.new(1, 0, 0, 10)
tbFix.Position         = UDim2.new(0, 0, 1, -10)
tbFix.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
tbFix.BorderSizePixel  = 0
local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size                  = UDim2.new(1, -50, 1, 0)
titleLabel.Position              = UDim2.new(0, 14, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3            = Color3.fromRGB(240, 240, 255)
titleLabel.TextXAlignment        = Enum.TextXAlignment.Left
titleLabel.Font                  = Enum.Font.GothamBold
titleLabel.TextSize              = 14
titleLabel.Text                  = "🧠  Brainrot List"
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size             = UDim2.new(0, 26, 0, 26)
closeBtn.Position         = UDim2.new(1, -33, 0.5, -13)
closeBtn.BackgroundColor3 = Color3.fromRGB(160, 35, 35)
closeBtn.Text             = "✕"
closeBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
closeBtn.Font             = Enum.Font.GothamBold
closeBtn.TextSize         = 12
closeBtn.BorderSizePixel  = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
local infoBar = Instance.new("Frame", panel)
infoBar.Size             = UDim2.new(1, -16, 0, 32)
infoBar.Position         = UDim2.new(0, 8, 0, 44)
infoBar.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
infoBar.BorderSizePixel  = 0
Instance.new("UICorner", infoBar).CornerRadius = UDim.new(0, 6)
local rarityLabel = Instance.new("TextLabel", infoBar)
rarityLabel.Size                  = UDim2.new(0.55, 0, 1, 0)
rarityLabel.Position              = UDim2.new(0, 10, 0, 0)
rarityLabel.BackgroundTransparency = 1
rarityLabel.TextColor3            = Color3.fromRGB(170, 170, 210)
rarityLabel.Font                  = Enum.Font.Gotham
rarityLabel.TextSize              = 11
rarityLabel.TextXAlignment        = Enum.TextXAlignment.Left
rarityLabel.Text                  = "Viewing: All"
local countLabel = Instance.new("TextLabel", infoBar)
countLabel.Size                  = UDim2.new(0.45, -10, 1, 0)
countLabel.Position              = UDim2.new(0.55, 0, 0, 0)
countLabel.BackgroundTransparency = 1
countLabel.TextColor3            = Color3.fromRGB(100, 210, 100)
countLabel.Font                  = Enum.Font.GothamBold
countLabel.TextSize              = 11
countLabel.TextXAlignment        = Enum.TextXAlignment.Right
countLabel.Text                  = "Count: 0"
local searchBar = Instance.new("TextBox", panel)
searchBar.Size                  = UDim2.new(1, -16, 0, 30)
searchBar.Position              = UDim2.new(0, 8, 0, 82)
searchBar.BackgroundColor3      = Color3.fromRGB(30, 30, 50)
searchBar.BorderSizePixel       = 0
searchBar.TextColor3            = Color3.fromRGB(230, 230, 255)
searchBar.PlaceholderText       = "🔍  Search..."
searchBar.PlaceholderColor3     = Color3.fromRGB(100, 100, 140)
searchBar.Font                  = Enum.Font.Gotham
searchBar.TextSize              = 12
searchBar.TextXAlignment        = Enum.TextXAlignment.Left
searchBar.ClearTextOnFocus      = false
searchBar.Text                  = ""
Instance.new("UICorner", searchBar).CornerRadius = UDim.new(0, 7)
local sbs = Instance.new("UIStroke", searchBar)
sbs.Color     = Color3.fromRGB(80, 80, 130)
sbs.Thickness = 1.5
local sbPad = Instance.new("UIPadding", searchBar)
sbPad.PaddingLeft = UDim.new(0, 8)
local scrollFrame = Instance.new("ScrollingFrame", panel)
scrollFrame.Size                 = UDim2.new(1, -16, 1, -124)
scrollFrame.Position             = UDim2.new(0, 8, 0, 118)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel      = 0
scrollFrame.ScrollBarThickness   = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 110)
scrollFrame.CanvasSize           = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize  = Enum.AutomaticSize.Y
scrollFrame.ElasticBehavior      = Enum.ElasticBehavior.Always
local listLayout = Instance.new("UIListLayout", scrollFrame)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding   = UDim.new(0, 5)
local lp = Instance.new("UIPadding", scrollFrame)
lp.PaddingLeft  = UDim.new(0, 1)
lp.PaddingRight = UDim.new(0, 1)
lp.PaddingTop   = UDim.new(0, 2)
local listPanelVisible, listEntries, listUpdateThread, currentRarityFilter, currentSearchQuery = false, {}, nil, nil, ""
searchBar:GetPropertyChangedSignal("Text"):Connect(function()
    currentSearchQuery = searchBar.Text:lower()
    pcall(refreshList)
end)
local function clearListEntries()
    for _, f in pairs(listEntries) do pcall(function() f:Destroy() end) end
    listEntries = {}
end
local function makeEntry(entry, order)
    local td     = S.traitData[entry.obj]
    local traits = (td and #td.traitNames > 0) and table.concat(td.traitNames, "+") or "—"
    local mut    = entry.mutation or "Normal"
    local rCol   = RARITY_COLORS[entry.rarity]  or Color3.fromRGB(200, 200, 200)
    local mCol   = MUTATION_COLORS[mut]          or Color3.fromRGB(140, 140, 140)
    local card = Instance.new("Frame", scrollFrame)
    card.Size             = UDim2.new(1, -4, 0, 60)
    card.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    card.BorderSizePixel  = 0
    card.LayoutOrder      = order
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 7)
    local cs = Instance.new("UIStroke", card)
    cs.Color        = rCol
    cs.Thickness    = 1
    cs.Transparency = 0.55
    local bar = Instance.new("Frame", card)
    bar.Size             = UDim2.new(0, 4, 1, 0)
    bar.BackgroundColor3 = rCol
    bar.BorderSizePixel  = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 4)
    local nameL = Instance.new("TextLabel", card)
    nameL.Size                  = UDim2.new(1, -100, 0, 20)
    nameL.Position              = UDim2.new(0, 12, 0, 5)
    nameL.BackgroundTransparency = 1
    nameL.TextColor3            = Color3.fromRGB(240, 240, 255)
    nameL.Font                  = Enum.Font.GothamBold
    nameL.TextSize              = 12
    nameL.TextXAlignment        = Enum.TextXAlignment.Left
    nameL.TextTruncate          = Enum.TextTruncate.AtEnd
    nameL.Text                  = tostring(entry.name or "?")
    local rarL = Instance.new("TextLabel", card)
    rarL.Size                  = UDim2.new(1, -100, 0, 14)
    rarL.Position              = UDim2.new(0, 12, 0, 24)
    rarL.BackgroundTransparency = 1
    rarL.TextColor3            = rCol
    rarL.Font                  = Enum.Font.Gotham
    rarL.TextSize              = 10
    rarL.TextXAlignment        = Enum.TextXAlignment.Left
    rarL.Text                  = entry.rarity
    local infoL = Instance.new("TextLabel", card)
    infoL.Size                  = UDim2.new(1, -100, 0, 14)
    infoL.Position              = UDim2.new(0, 12, 0, 39)
    infoL.BackgroundTransparency = 1
    infoL.TextColor3            = mCol
    infoL.Font                  = Enum.Font.Gotham
    infoL.TextSize              = 9
    infoL.TextXAlignment        = Enum.TextXAlignment.Left
    infoL.Text                  = "Mut: " .. mut .. "  ·  Trait: " .. traits
    local tpBtn = Instance.new("TextButton", card)
    tpBtn.Size             = UDim2.new(0, 68, 0, 26)
    tpBtn.Position         = UDim2.new(1, -76, 0.5, -13)
    tpBtn.BackgroundColor3 = Color3.fromRGB(35, 75, 160)
    tpBtn.Text             = "⟶ TP"
    tpBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
    tpBtn.Font             = Enum.Font.GothamBold
    tpBtn.TextSize         = 11
    tpBtn.BorderSizePixel  = 0
    Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)
    tpBtn.MouseButton1Click:Connect(function()
        pcall(function()
            local obj = entry.obj
            if not obj or not obj.Parent then
                Rayfield:Notify({ Title = "Brainrot List", Content = "Brainrot no longer exists!", Duration = 3, Image = 4483362458 })
                return
            end
            local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if part then
                hideLava()
                safeTeleport(part.CFrame * CFrame.new(0, 4, 0))
                Rayfield:Notify({ Title = "Teleported!", Content = entry.name, Duration = 2, Image = 4483362458 })
            end
        end)
    end)
    tpBtn.MouseEnter:Connect(function() tpBtn.BackgroundColor3 = Color3.fromRGB(55, 100, 200) end)
    tpBtn.MouseLeave:Connect(function() tpBtn.BackgroundColor3 = Color3.fromRGB(35, 75, 160) end)
    table.insert(listEntries, card)
end
local function refreshList()
    clearListEntries()
    local snapshot = monitorData.brainrots
    local filtered = {}
    for _, entry in ipairs(snapshot) do
        if entry.obj and entry.obj.Parent then
            if currentRarityFilter == nil or entry.rarity == currentRarityFilter then
                if currentSearchQuery == "" or entry.name:lower():find(currentSearchQuery, 1, true) then
                    table.insert(filtered, entry)
                end
            end
        end
    end
    table.sort(filtered, function(a, b)
        local ra = RARITY_ORDER[a.rarity] or 99
        local rb = RARITY_ORDER[b.rarity] or 99
        if ra ~= rb then return ra < rb end
        local ma = (a.mutation ~= "Normal") and 0 or 1
        local mb = (b.mutation ~= "Normal") and 0 or 1
        if ma ~= mb then return ma < mb end
        return a.name < b.name
    end)
    for i, entry in ipairs(filtered) do makeEntry(entry, i) end
    rarityLabel.Text = "Viewing: " .. (currentRarityFilter or "All")
    countLabel.Text  = "Count: " .. #filtered
end
local function stopListUpdate()
    listPanelVisible = false
    if listUpdateThread then pcall(task.cancel, listUpdateThread) listUpdateThread = nil end
end
local function showPanel(rarityFilter)
    currentRarityFilter = rarityFilter
    currentSearchQuery  = ""
    searchBar.Text      = ""
    listPanelVisible    = true
    panel.Visible       = true
    scrollFrame.CanvasPosition = Vector2.new(0, 0)
    pcall(refreshList)
    if listUpdateThread then pcall(task.cancel, listUpdateThread) end
    listUpdateThread = task.spawn(function()
        while listPanelVisible do
            task.wait(3)
            pcall(refreshList)
        end
    end)
end
closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
    stopListUpdate()
end)
local drag = { active=false, start=nil, startPos=nil }
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        drag.active   = true
        drag.start    = input.Position
        drag.startPos = panel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                drag.active = false
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not drag.active then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        local d = input.Position - drag.start
        panel.Position = UDim2.new(
            drag.startPos.X.Scale, drag.startPos.X.Offset + d.X,
            drag.startPos.Y.Scale, drag.startPos.Y.Offset + d.Y
        )
    end
end)
BrainrotListTab:CreateSection("Rarities")
BrainrotListTab:CreateButton({
    Name     = "📋  All Brainrots",
    Callback = function() showPanel(nil) end,
})
for _, rarity in ipairs({"Common","Rare","Epic","Legendary","Mythic","Secret","Celestial","Godly"}) do
    BrainrotListTab:CreateButton({
        Name     = rarity,
        Callback = function() showPanel(rarity) end,
    })
end
end)()
pcall(function() Rayfield:LoadConfiguration() end)
task.spawn(function()
    while true do
        task.wait(30)
        pcall(function() Rayfield:SaveConfiguration() end)
    end
end)
if getgenv().OxyoAutoHopCoin == true and not getgenv().OxyoHopStopped then
    S.autoHopCoinEnabled = true
    S.autoCoinEnabled    = true
    coinEventActive      = false
    if coinCollectThread then pcall(task.cancel, coinCollectThread) coinCollectThread = nil end
    hideLava()
    startCoinTracker()
    showStopHopGui()
    task.spawn(function()
        startCoinTracker()
        task.wait(5)
        Rayfield:Notify({ Title = "Auto Hop", Content = "Checking for Coin Rain...", Duration = 3, Image = 4483362458 })
        local status, timeLeft = waitForCoinRainStatus(15)
        if not getgenv().OxyoAutoHopCoin or getgenv().OxyoHopStopped then return end

        if not status then
            task.wait(1)
            status, timeLeft = getCoinRainStatus()
            if not status then
                local s2, t2 = _detectCoinRainFallback()
                if s2 then status, timeLeft = s2, t2 end
            end
        end
        if status == "active" then
            if (timeLeft or 60) < 8 then
                Rayfield:Notify({ Title = "Auto Hop", Content = "Coin Rain almost done — hopping...", Duration = 2, Image = 4483362458 })
                task.wait(1)
                if getgenv().OxyoAutoHopCoin and not getgenv().OxyoHopStopped then task.spawn(smartHop) end
            else
                local coins = findCoins()
                Rayfield:Notify({ Title = "🪙 Coin Rain!", Content = "Active — farming " .. #coins .. " coins!", Duration = 3, Image = 4483362458 })
                coinEventActive   = true
                S.coinEventDuration = timeLeft or 60
                startCoinCollect()
            end
        else
            local queuedSecs = _getCoinRainQueuedTime()
            if queuedSecs and queuedSecs > 0 and queuedSecs <= 1200 then
                local mins = math.floor(queuedSecs / 60)
                local secs = queuedSecs % 60
                Rayfield:Notify({
                    Title   = "🪙 Coin Rain Incoming!",
                    Content = string.format("Queued in %dm %ds — waiting on this server!", mins, secs),
                    Duration = 6, Image = 4483362458,
                })
                local waited2 = 0
                while waited2 < queuedSecs + 15
                    and getgenv().OxyoAutoHopCoin
                    and not getgenv().OxyoHopStopped
                do
                    task.wait(2)
                    waited2 = waited2 + 2
                    local s2, t2 = getCoinRainStatus()
                    if s2 == "active" and (t2 or 0) >= 8 then
                        coinEventActive     = true
                        S.coinEventDuration = t2 or 60
                        startCoinCollect()
                        return
                    end
                end
                if getgenv().OxyoAutoHopCoin and not getgenv().OxyoHopStopped then task.spawn(smartHop) end
            else
                Rayfield:Notify({ Title = "Auto Hop", Content = "No Coin Rain — hopping...", Duration = 2, Image = 4483362458 })
                task.wait(5)
                if getgenv().OxyoAutoHopCoin and not getgenv().OxyoHopStopped then task.spawn(smartHop) end
            end
        end
    end)
end
if getgenv().OxyoAutoHopGodly == true and not getgenv().OxyoHopGodlyStopped then
    S.autoHopGodlyEnabled = true
    getgenv().OxyoHopStopped = false
    hideLava()
    showStopHopGui()
    S.autoHopGodlyThread = task.spawn(function()
        task.wait(5)
        runRarityHopFarm("Godly", "OxyoAutoHopGodly", "OxyoHopGodlyStopped")
    end)
end
if getgenv().OxyoAutoHopCel == true and not getgenv().OxyoHopCelStopped then
    S.autoHopCelEnabled = true
    getgenv().OxyoHopStopped = false
    hideLava()
    showStopHopGui()
    S.autoHopCelThread = task.spawn(function()
        task.wait(5)
        runRarityHopFarm("Celestial", "OxyoAutoHopCel", "OxyoHopCelStopped")
    end)
end
if getgenv().OxyoAutoHopFrag == true and not getgenv().OxyoHopFragStopped then
    S.autoHopFragEnabled = true
    getgenv().OxyoHopStopped = false
    hideLava()
    showStopHopGui()
    S.autoHopFragThread = task.spawn(function()
        task.wait(5)
        runFragHopFarm("OxyoAutoHopFrag", "OxyoHopFragStopped")
    end)
end
;(function()
local _isPrivateServer = getgenv()._isPrivateServer or function() return false end

local _SB_URL     = "https://webhooksqw.mohammadahmadqazplm.workers.dev"
local _SB_KEY     = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx5d2Z4Z2trcGl5eGF5ZHdxeXRlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU2MDA3NzcsImV4cCI6MjA5MTE3Njc3N30.mSs9Vko1yDVWSS-7-CJJUBNm36udqyalNxg0q6ZOmxM"
local _FB_HTTP    = game:GetService("HttpService")
local _FB_JOBKEY  = tostring(game.JobId):gsub("-", "_")
local _FB_JOBID   = tostring(game.JobId)
local _fbHttpExec = (typeof(request)        == "function" and request)
                 or (typeof(http_request)   == "function" and http_request)
                 or (typeof(http)           == "table" and typeof(http.request)   == "function" and http.request)
                 or (typeof(syn)            == "table" and typeof(syn.request)    == "function" and syn.request)
                 or (typeof(fluxus)         == "table" and typeof(fluxus.request) == "function" and fluxus.request)
                 or nil

local function _sbRaw(method, tbl, qparams, data, timeout)
    if not _fbHttpExec then return nil end
    timeout = timeout or 7
    local url = _SB_URL .. "/rest/v1/" .. tbl
    if qparams and qparams ~= "" then url = url .. "?" .. qparams end
    local headers = {
        ["Content-Type"]  = "application/json",
        ["apikey"]        = _SB_KEY,
        ["Authorization"] = "Bearer " .. _SB_KEY,
    }
    if method == "POST" then
        headers["Prefer"] = "resolution=merge-duplicates,return=minimal"
    elseif method == "DELETE" or method == "PATCH" then
        headers["Prefer"] = "return=minimal"
    end
    local done, result = false, nil
    local signal = Instance.new("BindableEvent")
    task.spawn(function()
        local ok, res = pcall(_fbHttpExec, {
            Url     = url,
            Method  = method,
            Headers = headers,
            Body    = (data ~= nil) and _FB_HTTP:JSONEncode(data) or nil,
        })
        if ok and res then
            local status = tonumber(res.StatusCode or res.status) or 0
            if status >= 200 and status < 300 then
                local body = res.Body
                if body and body ~= "" then
                    local ok2, dec = pcall(_FB_HTTP.JSONDecode, _FB_HTTP, body)
                    if ok2 then result = dec else result = true end
                else
                    result = true
                end
            end
        end
        if not done then done = true pcall(function() signal:Fire() end) end
    end)
    local deadline = tick() + timeout
    local conn = signal.Event:Connect(function()
        done = true pcall(function() conn:Disconnect() end)
    end)
    while not done and tick() < deadline do RunService.Heartbeat:Wait() end
    done = true
    pcall(function() conn:Disconnect() end)
    pcall(function() signal:Destroy() end)
    return result
end

local function _fbReq(method, path, data, timeout)
    local parts = {}
    for p in path:gmatch("[^/]+") do table.insert(parts, p) end
    local tbl    = parts[1] or ""
    local rowKey = parts[2]

    if tbl == "sv" then
        if method == "GET" and not rowKey then
            local rows = _sbRaw("GET", "sv", "select=*&place_id=eq." .. tostring(game.PlaceId), nil, timeout)
            if type(rows) ~= "table" then return nil end
            local out = {}
            for _, row in ipairs(rows) do
                if row.job_key then
                    out[row.job_key] = {
                        j = row.job_id,
                        p = row.place_id,
                        t = row.t,
                        c = row.c,
                        b = row.b or {},
                    }
                end
            end
            return out
        elseif method == "PUT" and rowKey then
            local payload = { job_key = rowKey, place_id = tostring(game.PlaceId) }
            if data then
                if data.j then payload.job_id   = data.j end
                if data.p then payload.place_id = tostring(data.p) end
                if data.t then payload.t        = data.t end
                if data.c ~= nil then payload.c = data.c end
                if data.b then payload.b        = data.b end
            end
            local r = _sbRaw("POST", "sv", nil, payload, timeout)
            return r ~= nil and {} or nil
        elseif method == "PATCH" and rowKey then
            local payload = {}
            if data then
                if data.t        then payload.t = data.t end
                if data.c ~= nil then payload.c = data.c end
            end
            local r = _sbRaw("PATCH", "sv", "job_key=eq." .. rowKey, payload, timeout)
            return r ~= nil and {} or nil
        elseif method == "DELETE" and rowKey then
            _sbRaw("DELETE", "sv", "job_key=eq." .. rowKey, nil, timeout)
            return {}
        end

    elseif tbl == "uc" then
        if method == "GET" and not rowKey then
            local rows = _sbRaw("GET", "uc", "select=*&place_id=eq." .. tostring(game.PlaceId), nil, timeout)
            if type(rows) ~= "table" then return nil end
            local out = {}
            for _, row in ipairs(rows) do
                if row.uc_key then out[row.uc_key] = { t = row.t } end
            end
            return out
        elseif method == "PUT" and rowKey then
            local payload = { uc_key = rowKey, place_id = tostring(game.PlaceId) }
            if data and data.t then payload.t = data.t end
            local r = _sbRaw("POST", "uc", nil, payload, timeout)
            return r ~= nil and {} or nil
        elseif method == "DELETE" and rowKey then
            _sbRaw("DELETE", "uc", "uc_key=eq." .. rowKey, nil, timeout)
            return {}
        end
    end
    return nil
end
local _CB_THRESHOLD, _CB_COOLDOWN, _cbFails, _cbTripped, _cbTripTime = 5, 45, 0, false, 0
local function _cbRecord(success)
    if success then
        _cbFails = 0 _cbTripped = false
    else
        _cbFails = _cbFails + 1
        if _cbFails >= _CB_THRESHOLD and not _cbTripped then
            _cbTripped  = true
            _cbTripTime = tick()
        end
    end
end
local function _cbAllow()
    if not _cbTripped then return true end
    if tick() - _cbTripTime >= _CB_COOLDOWN then _cbTripped=false _cbFails=0 return true end
    return false
end
local _readCache = {}
local _readCacheTTL = 20
local function _fbSafe(method, path, data, timeout)
    if not _cbAllow() then return nil end
    if method == "GET" then
        local cached = _readCache[path]
        if cached and (tick() - cached.t) < _readCacheTTL then
            return cached.v
        end
    end
    local res = _fbReq(method, path, data, timeout)
    _cbRecord(res ~= nil)
    if method == "GET" and res ~= nil then
        _readCache[path] = { t = tick(), v = res }
    end
    return res
end
local _reporterActive, _reporterThread, _reporterLastWrite = false, nil, 0
local function _getBrainrotList()
    local list = {}
    for _, e in ipairs(monitorData.brainrots) do
        if e.obj and e.obj.Parent then
            local traitArr = nil
            local td = S.traitData[e.obj]
            if td and #td.traitNames > 0 then
                traitArr = td.traitNames
            end
            table.insert(list, {
                n = e.name,
                r = e.rarity,
                m = (e.mutation and e.mutation ~= "Normal") and e.mutation or nil,
                t = traitArr,
            })
        end
    end
    return list
end
local function _getReporterInterval(count)
    if _cbFails > 2 then return 90 end
    if count == 0  then return 75 end
    if count >= 10 then return 45 end
    return 60
end
local _lastReportedCount = -1
local _lastReportedHash  = ""
local function _listHash(list)
    local s = ""
    for _, e in ipairs(list) do s = s .. (e.name or "") .. "," end
    return s
end
local function _reporterCycle()
    if _isPrivateServer() then return end
    local list = _getBrainrotList()
    local hash = _listHash(list)
    if #list > 0 then
        if hash ~= _lastReportedHash then
            local res = _fbSafe("PUT", "sv/" .. _FB_JOBKEY, {
                j=_FB_JOBID, p=game.PlaceId, t=os.time(), c=#list, b=list,
            })
            if res ~= nil then
                _reporterLastWrite = tick()
                _lastReportedHash  = hash
                _lastReportedCount = #list
            end
        else
            _reporterLastWrite = tick()
        end
    else
        if _lastReportedCount ~= 0 then
            _fbSafe("PATCH", "sv/" .. _FB_JOBKEY, { t=os.time(), c=0 })
            _lastReportedCount = 0
            _lastReportedHash  = ""
        end
        _reporterLastWrite = tick()
    end
    return #list
end
local function _startReporter()
    if _reporterActive then return end
    _reporterActive    = true
    _reporterLastWrite = tick()
    _reporterThread = task.spawn(function()
        while _reporterActive do
            local count = 0
            pcall(function() count = _reporterCycle() or 0 end)
            task.wait(_getReporterInterval(count))
        end
        pcall(function() _fbSafe("DELETE", "sv/" .. _FB_JOBKEY, nil) end)
    end)
end
local function _stopReporter()
    _reporterActive = false
    if _reporterThread then pcall(task.cancel, _reporterThread) _reporterThread = nil end
    pcall(function() _fbSafe("DELETE", "sv/" .. _FB_JOBKEY, nil) end)
end
task.spawn(function()
    task.wait(60)
    while true do
        task.wait(30)
        if _reporterActive then
            local stale = (tick() - _reporterLastWrite) > 150
            local dead  = (_reporterThread == nil)
            if stale or dead then
                if _reporterThread then pcall(task.cancel, _reporterThread) _reporterThread = nil end
                _reporterActive    = false
                _reporterLastWrite = tick()
                _startReporter()
            end
        end
    end
end)
task.spawn(function()
    while true do
        task.wait(300)
        pcall(function()
            while #_webhookHistory > 30 do table.remove(_webhookHistory) end
            local now = tick()
            for _, qkey in next, {"oxyo"} do
                for i = #_queues[qkey], 1, -1 do
                    if now - (_queues[qkey][i].queuedAt or 0) > 600 then table.remove(_queues[qkey], i) end
                end
            end
        end)
    end
end)
local _UC_KEY       = tostring(game.JobId):gsub("-","_") .. "_" .. tostring(Players.LocalPlayer.UserId)
local _ucThread     = nil
local _ucActive     = false
local _ucLastWrite  = 0
local function _startUserCount()
    if _ucActive then return end
    _ucActive = true
    pcall(function()
        local res = _fbSafe("PUT", "uc/" .. _UC_KEY, { t=os.time() })
        if res ~= nil then _ucLastWrite = tick() end
    end)
    _ucThread = task.spawn(function()
        while _ucActive do
            task.wait(20)
            pcall(function()
                local res = _fbSafe("PUT", "uc/" .. _UC_KEY, { t=os.time() })
                if res == nil then
                    task.wait(3)
                    local res2 = _fbSafe("PUT", "uc/" .. _UC_KEY, { t=os.time() })
                    if res2 ~= nil then _ucLastWrite = tick() end
                else
                    _ucLastWrite = tick()
                end
            end)
        end
    end)
end
local function _stopUserCount()
    _ucActive = false
    if _ucThread then pcall(task.cancel, _ucThread) _ucThread = nil end
    pcall(function() _fbSafe("DELETE", "uc/" .. _UC_KEY, nil) end)
end
local function _getActiveUserCount()
    local data = _fbSafe("GET", "uc", nil, 5)
    if type(data) ~= "table" then return 0 end
    local now, count = os.time(), 0
    for _, v in pairs(data) do
        if type(v) == "table" and (now - (v.t or 0)) <= 60 then count = count + 1 end
    end
    return count
end
local _pubCacheIds  = nil
local _pubCacheTime = 0
local _pubCacheTTL  = 25
local function _fetchPublicJobIds(forceFresh)
    if not forceFresh and _pubCacheIds and (tick() - _pubCacheTime) < _pubCacheTTL then
        return _pubCacheIds
    end
    local ids    = {}
    local cursor = ""
    local hs     = game:GetService("HttpService")
    for _ = 1, 6 do
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId
                 .. "/servers/Public?sortOrder=Asc&limit=100"
        if cursor ~= "" then url = url .. "&cursor=" .. cursor end
        local ok, body = pcall(function() return game:HttpGet(url) end)
        if not ok or not body or body == "" then break end
        local ok2, data = pcall(function() return hs:JSONDecode(body) end)
        if not ok2 or not data or not data.data then break end
        for _, s in ipairs(data.data) do
            if s.id then ids[s.id] = tonumber(s.playing) or 0 end
        end
        if data.nextPageCursor and data.nextPageCursor ~= "" then
            cursor = data.nextPageCursor
            task.wait(0.08)
        else
            break
        end
    end
    _pubCacheIds  = ids
    _pubCacheTime = tick()
    return ids
end
local function _fbDeleteAndSkip(key)
    task.spawn(function()
        pcall(function() _fbSafe("DELETE", "sv/" .. key, nil) end)
    end)
    return true
end
_searchServers = function(targetName, targetRarity, targetDisplayName, targetMutation, targetTrait)
    local servers = _fbSafe("GET", "sv", nil, 7)
    if type(servers) ~= "table" then return nil, nil end
    local pubIds = _fetchPublicJobIds()
    local now    = os.time()
    local tRar   = targetRarity   and targetRarity:lower()   or nil
    local tMut   = targetMutation and targetMutation:lower() or nil
    local tTrait = targetTrait    and targetTrait:lower()    or nil
    local function norm(s)
        return (s or ""):lower():gsub("%s+", ""):gsub("[^%a%d]", "")
    end
    local tRaw   = (targetName or ""):lower()
    local tNorm  = norm(targetName)
    local tDisp  = (targetDisplayName or ""):lower()
    local tDispN = norm(targetDisplayName)
    local function nameMatches(bName)
        if not bName or bName == "" then return false end
        local bLow  = bName:lower()
        local bNorm = norm(bName)
        if bLow == tRaw or bLow == tDisp then return true end
        if bNorm == tNorm or bNorm == tDispN then return true end
        if tNorm ~= "" and (bNorm:find(tNorm, 1, true) or tNorm:find(bNorm, 1, true)) then return true end
        if tDispN ~= "" and (bNorm:find(tDispN, 1, true) or tDispN:find(bNorm, 1, true)) then return true end
        return false
    end
    local function mutMatches(bMut)
        if not tMut then return true end
        if not bMut then return false end
        return bMut:lower() == tMut
    end
    local function traitMatches(bTraits)
        if not tTrait then return true end
        if type(bTraits) ~= "table" then return false end
        for _, tr in ipairs(bTraits) do
            if tostring(tr):lower() == tTrait then return true end
        end
        return false
    end
    local candidates = {}
    for key, data in pairs(servers) do
        if key == _FB_JOBKEY then continue end
        if type(data) ~= "table" then continue end
        if (now - (data.t or 0)) > 45 then
            _fbDeleteAndSkip(key)
            continue
        end
        local jobId = data.j
        if not jobId or not pubIds[jobId] then
            _fbDeleteAndSkip(key)
            continue
        end
        if pubIds[jobId] <= 0 then
            _fbDeleteAndSkip(key)
            continue
        end
        if type(data.b) ~= "table" then continue end
        for _, b in ipairs(data.b) do
            if not nameMatches(b.n) then continue end
            local bRar = b.r and b.r:lower() or ""
            if tRar and bRar ~= tRar then continue end
            if not mutMatches(b.m) then continue end
            if not traitMatches(b.t) then continue end
            local score = 0
            if b.m and b.m ~= "" then score = score + 10 end
            if type(b.t) == "table" and #b.t > 0 then score = score + 10 end
            score = score + math.max(0, 45 - (now - (data.t or 0)))
            table.insert(candidates, { job = jobId, entry = b, score = score })
        end
    end
    if #candidates == 0 then return nil, nil end
    table.sort(candidates, function(a, b) return a.score > b.score end)
    return candidates[1].job, candidates[1].entry
end
task.delay(2, function()
    if not _isPrivateServer() then _startUserCount() end
end)
task.delay(5, function()
    if _isPrivateServer() then
        pcall(function()
            Rayfield:Notify({
                Title    = "⛔ Private Server",
                Content  = "Reporter & webhooks are disabled.\nJoin a public server to use the Finder.",
                Duration = 8,
                Image    = 4483362458,
            })
        end)
        return
    end
    task.spawn(function()
        local deadline = tick() + 25
        while tick() < deadline do
            if #_getBrainrotList() > 0 then break end
            task.wait(2)
        end
        _startReporter()
    end)
end)
game:GetService("Players").LocalPlayer.AncestryChanged:Connect(function()
    pcall(_stopReporter)
    pcall(_stopUserCount)
end)
BrainrotFinderTab:CreateSection("Status")
local _userCountPara = BrainrotFinderTab:CreateParagraph({
    Title   = "👥 Active Users",
    Content = "Loading...",
})
task.spawn(function()
    while true do
        pcall(function()
            local n = _getActiveUserCount()
            _userCountPara:Set({
                Title   = "👥 " .. n .. " users online",
                Content = "Players currently running Oxyo Hub in this game.",
            })
        end)
        task.wait(15)
    end
end)
BrainrotFinderTab:CreateButton({
    Name     = "📊 Active Reporters",
    Callback = function()
        task.spawn(function()
            local servers = _fbReq("GET", "sv", nil)
            if type(servers) ~= "table" then
                Rayfield:Notify({ Title = "Finder", Content = "No active reporters found.", Duration = 3, Image = 4483362458 })
                return
            end
            local now   = os.time()
            local count = 0
            local total = 0
            for _, data in pairs(servers) do
                if type(data) == "table" and (now - (data.t or 0)) <= 45 then
                    count = count + 1
                    total = total + (data.c or 0)
                end
            end
            Rayfield:Notify({
                Title   = "📊 " .. count .. " Servers Online",
                Content = total .. " brainrots being tracked right now",
                Duration = 5,
                Image   = 4483362458,
            })
        end)
    end,
})
BrainrotFinderTab:CreateSection("Hunter")
local _hunterName     = ""
local _hunterRarity   = nil
local _hunterMutation = nil
local _hunterTrait    = nil
BrainrotFinderTab:CreateInput({
    Name                     = "Brainrot Name",
    PlaceholderText          = "e.g. Chimpanzini, Titan...",
    RemoveTextAfterFocusLost = false,
    Callback                 = function(v) _hunterName = v:gsub("^%s+", ""):gsub("%s+$", "") end,
})
BrainrotFinderTab:CreateDropdown({
    Name            = "Rarity Filter",
    Options         = { "Any", "Common", "Rare", "Epic", "Legendary", "Mythic", "Secret", "Celestial", "Godly" },
    CurrentOption   = { "Any" },
    MultipleOptions = false,
    Callback        = function(v)
        _hunterRarity = (v == "Any") and nil or v
    end,
})
BrainrotFinderTab:CreateDropdown({
    Name            = "Mutation Filter",
    Options         = { "Any", "Gold", "Emerald", "Diamond", "Bloodmoon", "Rainbow", "Cheese", "Aqua" },
    CurrentOption   = { "Any" },
    MultipleOptions = false,
    Flag            = "FinderMutation",
    Callback        = function(v)
        local opt = type(v) == "table" and v[1] or v
        _hunterMutation = (opt == "Any") and nil or opt
    end,
})
BrainrotFinderTab:CreateDropdown({
    Name            = "Trait Filter",
    Options         = { "Any", "MoonGlow", "Magma", "Storm", "Slime", "Volcano", "Shamrock", "Ice" },
    CurrentOption   = { "Any" },
    MultipleOptions = false,
    Flag            = "FinderTrait",
    Callback        = function(v)
        local opt = type(v) == "table" and v[1] or v
        _hunterTrait = (opt == "Any") and nil or opt
    end,
})
BrainrotFinderTab:CreateButton({
    Name     = "🔍 Search & Hop",
    Callback = function()
        if _hunterName == "" then
            Rayfield:Notify({ Title = "Finder", Content = "Enter a brainrot name first!", Duration = 3, Image = 4483362458 })
            return
        end
        local searchLabel = _hunterName
        if _hunterRarity   then searchLabel = searchLabel .. " | " .. _hunterRarity end
        if _hunterMutation then searchLabel = searchLabel .. " | " .. _hunterMutation end
        if _hunterTrait    then searchLabel = searchLabel .. " | Trait:" .. _hunterTrait end
        Rayfield:Notify({ Title = "🔍 Searching...", Content = searchLabel, Duration = 3, Image = 4483362458 })
        task.spawn(function()
            local realJobId, found = _searchServers(
                _hunterName, _hunterRarity, nil, _hunterMutation, _hunterTrait)
            if not realJobId then
                local relaxMsg = ""
                if _hunterMutation or _hunterTrait then
                    relaxMsg = "\nTip: Try setting filters to 'Any' to find normal variants."
                end
                Rayfield:Notify({
                    Title   = "Not Found ❌",
                    Content = "No server has " .. searchLabel .. " right now.\nMake sure others have Reporter ON!" .. relaxMsg,
                    Duration = 7,
                    Image   = 4483362458,
                })
                return
            end
            local mutStr   = (found.m) and (" [" .. found.m .. "]") or " [Normal]"
            local traitStr = ""
            if type(found.t) == "table" and #found.t > 0 then
                traitStr = " {" .. table.concat(found.t, "+") .. "}"
            end
            Rayfield:Notify({
                Title   = "Found! 🎯",
                Content = found.n .. mutStr .. traitStr
                       .. "\n" .. (found.r or "?")
                       .. "\nHopping in 2s...",
                Duration = 5,
                Image   = 4483362458,
            })
            task.wait(2)
            if isAnyHopStopped() then return end
            getgenv().OxyoHubLoaded = false
            if not getgenv().OxyoExecQueued then
                getgenv().OxyoExecQueued = true
                local _qs = 'loadstring(game:HttpGet("' .. AUTO_EXEC_URL .. '"))()'
                pcall(function() if typeof(queue_on_teleport)=="function" then queue_on_teleport(_qs) end end)
                pcall(function() if typeof(syn)=="table" and typeof(syn.queue_on_teleport)=="function" then syn.queue_on_teleport(_qs) end end)
                pcall(function() if typeof(fluxus)=="table" and typeof(fluxus.queue_on_teleport)=="function" then fluxus.queue_on_teleport(_qs) end end)
            end
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, realJobId, Players.LocalPlayer)
            end)
        end)
    end,
})
BrainrotFinderTab:CreateSection("Quick Hunt")
for _, rarity in ipairs({ "Godly", "Celestial", "Secret", "Mythic" }) do
    BrainrotFinderTab:CreateButton({
        Name     = "⚡ Any " .. rarity,
        Callback = function()
            Rayfield:Notify({ Title = "🔍 Hunting " .. rarity .. "...", Content = "Scanning & verifying servers...", Duration = 3, Image = 4483362458 })
            task.spawn(function()
                local servers = _fbSafe("GET", "sv", nil, 7)
                if type(servers) ~= "table" then
                    Rayfield:Notify({ Title = "Not Found", Content = "No reporters active.", Duration = 4, Image = 4483362458 })
                    return
                end
                local pubIds = _fetchPublicJobIds(true)
                local now    = os.time()
                local rarLow = rarity:lower()
                local candidates = {}
                for key, data in pairs(servers) do
                    if type(data) ~= "table" then continue end
                    if (now - (data.t or 0)) > 45 then
                        _fbDeleteAndSkip(key)
                        continue
                    end
                    local jobId = data.j
                    if not jobId or not pubIds[jobId] then
                        _fbDeleteAndSkip(key)
                        continue
                    end
                    if pubIds[jobId] <= 0 then
                        _fbDeleteAndSkip(key)
                        continue
                    end
                    if type(data.b) ~= "table" then continue end
                    for _, b in ipairs(data.b) do
                        if b.r and b.r:lower() == rarLow then
                            local score = 0
                            if b.m and b.m ~= "" then score = score + 20 end
                            if type(b.t) == "table" and #b.t > 0 then score = score + 15 end
                            score = score + math.max(0, 45 - (now - (data.t or 0)))
                            table.insert(candidates, { job = jobId, b = b, score = score })
                        end
                    end
                end
                if #candidates == 0 then
                    Rayfield:Notify({ Title = "Not Found ❌", Content = "No verified public server has " .. rarity .. " right now.", Duration = 5, Image = 4483362458 })
                    return
                end
                table.sort(candidates, function(a, b2) return a.score > b2.score end)
                local pick   = candidates[1]
                local b      = pick.b
                local mutStr   = b.m and (" [" .. b.m .. "]") or ""
                local traitStr = ""
                if type(b.t) == "table" and #b.t > 0 then
                    traitStr = " {" .. table.concat(b.t, "+") .. "}"
                end
                Rayfield:Notify({
                    Title   = "Found " .. rarity .. "! 🎯",
                    Content = b.n .. mutStr .. traitStr .. "\nHopping in 2s...",
                    Duration = 5,
                    Image   = 4483362458,
                })
                task.wait(2)
                if isAnyHopStopped() then return end
                getgenv().OxyoHubLoaded = false
                if not getgenv().OxyoExecQueued then
                    getgenv().OxyoExecQueued = true
                    local _qs = 'loadstring(game:HttpGet("' .. AUTO_EXEC_URL .. '"))()'
                    pcall(function() if typeof(queue_on_teleport)=="function" then queue_on_teleport(_qs) end end)
                    pcall(function() if typeof(syn)=="table" and typeof(syn.queue_on_teleport)=="function" then syn.queue_on_teleport(_qs) end end)
                    pcall(function() if typeof(fluxus)=="table" and typeof(fluxus.queue_on_teleport)=="function" then fluxus.queue_on_teleport(_qs) end end)
                end
                pcall(function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, pick.job, Players.LocalPlayer)
                end)
            end)
        end,
    })
end
end)()

;(function()

local _dreamRunning  = false
local _dreamThread   = nil
local _dreamSubmitRemote = nil

local DREAM_MACHINE_POS = Vector3.new(0, 5, 0)

local function _isDreamEventActive()
    local gf = workspace:FindFirstChild("GameFolder")
    if gf and gf:FindFirstChild("DreamEvent") then return true end
    if workspace:FindFirstChild("DreamEvent") then return true end

    pcall(function()
        local cfg = require(game:GetService("ReplicatedStorage").Registries.ConfigRegistry)
        if cfg and cfg.DreamEvent == true then return end
    end)
    return false
end

local function _getDreamBrainrots()
    local found = {}
    local gf = workspace:FindFirstChild("GameFolder")
    local brFolder = gf and gf:FindFirstChild("Brainrots")
    if not brFolder then return found end
    for _, rarityFolder in ipairs(brFolder:GetChildren()) do
        for _, obj in ipairs(rarityFolder:GetChildren()) do
            if obj and obj.Parent then
                local td = S.traitData[obj]
                if td then
                    for _, t in ipairs(td.traitNames) do
                        if t == "Dream" then
                            table.insert(found, { obj = obj, rarity = rarityFolder.Name })
                            break
                        end
                    end
                else

                    local ok, traitAttr = pcall(function() return obj:GetAttribute("Traits") end)
                    if ok and type(traitAttr) == "table" then
                        for _, t in ipairs(traitAttr) do
                            if t == "Dream" then
                                table.insert(found, { obj = obj, rarity = rarityFolder.Name })
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    return found
end

local function _findDreamMachine()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            if obj.Name == "DreamMachine" or obj.Name == "Dream Machine" then
                return obj
            end
        end
    end
    return nil
end

local function _getDreamRemote()
    if _dreamSubmitRemote and _dreamSubmitRemote.Parent then return _dreamSubmitRemote end
    local ok, remote = pcall(function()
        return ReplicatedStorage
            :WaitForChild("Remotes", 5)
            :WaitForChild("DreamEvent", 5)
            :WaitForChild("SubmitBrainrot", 5)
    end)
    if ok and remote then
        _dreamSubmitRemote = remote
        return remote
    end
    return nil
end

local function _submitDreamBrainrot(brainrotObj)
    local machine = _findDreamMachine()
    if not machine then return false end

    local machPos
    if machine:IsA("Model") and machine.PrimaryPart then
        machPos = machine.PrimaryPart.Position
    elseif machine:IsA("BasePart") then
        machPos = machine.Position
    else
        local bp = machine:FindFirstChildWhichIsA("BasePart")
        if bp then machPos = bp.Position end
    end
    if not machPos then return false end

    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if hum and brainrotObj:IsA("Tool") then
        pcall(function() hum:EquipTool(brainrotObj) end)
        task.wait(0.2)
    end

    root.CFrame = CFrame.new(machPos + Vector3.new(0, 3, 3))
    task.wait(2)

    local pp = machine:FindFirstChildWhichIsA("ProximityPrompt", true)
    if pp then
        _fireprox(pp)
        task.wait(0.5)
        return true
    end

    local remote = _getDreamRemote()
    if remote then
        pcall(function() remote:FireServer(brainrotObj) end)
        task.wait(0.4)
        return true
    end

    return false
end

local function _startDreamLoop()
    Rayfield:Notify({
        Title   = "💜 Dream Auto",
        Content = "Started! Collecting Dream brainrots and submitting...",
        Duration = 3, Image = 4483362458,
    })

    while _dreamRunning do
        hideLava()

        local dreamBrainrots = _getDreamBrainrots()

        if #dreamBrainrots == 0 then
            task.wait(3)
        else

            local char = Players.LocalPlayer.Character
            if char and char.PrimaryPart then
                local myPos = char.PrimaryPart.Position
                table.sort(dreamBrainrots, function(a, b)
                    local ppA = a.obj.PrimaryPart and a.obj.PrimaryPart.Position or myPos
                    local ppB = b.obj.PrimaryPart and b.obj.PrimaryPart.Position or myPos
                    return (ppA - myPos).Magnitude < (ppB - myPos).Magnitude
                end)
            end

            local submitted = 0
            for _, entry in ipairs(dreamBrainrots) do
                if not _dreamRunning then break end
                if entry.obj and entry.obj.Parent then
                    local ok, did = pcall(grabBrainrot, entry.obj)
                    if ok and did then
                        task.wait(0.3)
                        local subOk = pcall(_submitDreamBrainrot, entry.obj)
                        if subOk then
                            submitted = submitted + 1
                            task.wait(0.3)
                        end

                        pcall(function()
                            local root2 = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            if root2 then root2.CFrame = getSafeBase() end
                        end)
                    end
                end
            end

            if submitted > 0 then
                Rayfield:Notify({
                    Title   = "💜 Dream Auto",
                    Content = "Submitted " .. submitted .. " Dream brainrot(s) to the Machine!",
                    Duration = 3, Image = 4483362458,
                })
            end

            task.wait(2)
        end
    end
end

DreamsTab:CreateSection("💜 Dream Event")

DreamsTab:CreateToggle({
    Name         = "💜 Auto Submit Dream Brainrots",
    CurrentValue = false,
    Flag         = "DreamAutoSubmit",
    Callback     = function(val)
        _dreamRunning = val
        if val then
            hideLava()
            _dreamThread = task.spawn(_startDreamLoop)
        else
            if _dreamThread then pcall(task.cancel, _dreamThread) _dreamThread = nil end
            Rayfield:Notify({ Title = "💜 Dream Auto", Content = "Stopped.", Duration = 2, Image = 4483362458 })
        end
    end,
})

DreamsTab:CreateSection("🎁 Dream Lucky Blocks")

DreamsTab:CreateButton({
    Name     = "🌙 Auto Open Dream Lucky Blocks",
    Callback = function()
        task.spawn(function()
            local gf = workspace:FindFirstChild("GameFolder")
            local lb = gf and gf:FindFirstChild("LuckyBlocks")
            if not lb then
                Rayfield:Notify({ Title = "🌙 Dream LB", Content = "LuckyBlocks folder not found!", Duration = 3, Image = 4483362458 })
                return
            end
            local count = 0
            for _, block in ipairs(lb:GetChildren()) do
                local bn = block.Name:lower()
                if bn:find("dream") then
                    local pp = block:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if pp then
                        local bpos = pp.Parent.Position
                        if isValidPos(bpos) then
                            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            if root then
                                hideLava()
                                root.CFrame = CFrame.new(bpos + Vector3.new(0, 3, 3))
                                task.wait(0.3)
                                _fireprox(pp)
                                task.wait(0.5)
                                root.CFrame = getSafeBase()
                                count = count + 1
                            end
                        end
                    end
                end
            end
            if count == 0 then
                Rayfield:Notify({ Title = "🌙 Dream LB", Content = "No Dream Lucky Blocks found in world!", Duration = 3, Image = 4483362458 })
            else
                Rayfield:Notify({ Title = "🌙 Dream LB", Content = "Opened " .. count .. " Dream Lucky Block(s)!", Duration = 3, Image = 4483362458 })
            end
        end)
    end,
})

DreamsTab:CreateSection("🧸 Dream Brainrots")

local DREAM_BRAINROTS = {
    { name = "CrescentMoonolini",  displayName = "Crescent Moonolini",  rarity = "Secret"    },
    { name = "CloudiniGenie",      displayName = "Cloudini Genie",      rarity = "Secret"    },
    { name = "SnoozySlumberini",   displayName = "Snoozy Slumberini",   rarity = "Celestial" },
    { name = "BuffTeddorini",      displayName = "Buff Teddorini",      rarity = "Celestial" },
    { name = "ShootingStellino",   displayName = "Shooting Stellino",   rarity = "Celestial" },
    { name = "LosTicTacsCitos",    displayName = "Los Tic Tacs Citos",  rarity = "Celestial" },
    { name = "LaCathedraleMammoth",displayName = "La Cathedrale Mammoth",rarity = "Godly"    },
}

DreamsTab:CreateButton({
    Name     = "🔍 Scan for Dream Brainrots",
    Callback = function()
        task.spawn(function()
            local found = {}
            for _, rarity in ipairs(ALL_RARITIES) do
                local folder = getBrainrotFolder(rarity)
                if folder then
                    for _, obj in ipairs(folder:GetChildren()) do
                        if obj and obj.Parent then

                            local hasDream = false
                            local td = S.traitData[obj]
                            if td then
                                for _, t in ipairs(td.traitNames) do
                                    if t == "Dream" then hasDream = true break end
                                end
                            end

                            local dn = obj:GetAttribute("DisplayName") or obj.Name
                            for _, db in ipairs(DREAM_BRAINROTS) do
                                if obj.Name == db.name or dn == db.displayName then
                                    hasDream = true break
                                end
                            end
                            if hasDream then
                                local mut = obj:GetAttribute("Mutation") or "Normal"
                                table.insert(found, rarity .. " - " .. dn .. " [" .. mut .. "]")
                            end
                        end
                    end
                end
            end
            if #found == 0 then
                Rayfield:Notify({ Title = "🔍 Dream Scan", Content = "No Dream brainrots found in world.", Duration = 3, Image = 4483362458 })
            else
                Rayfield:Notify({
                    Title   = "🔍 Dream Scan — " .. #found .. " found",
                    Content = table.concat(found, "\n"):sub(1, 200),
                    Duration = 6,
                    Image   = 4483362458,
                })
            end
        end)
    end,
})

DreamsTab:CreateButton({
    Name     = "🧸 Collect Nearest Dream Brainrot",
    Callback = function()
        task.spawn(function()
            local dreamList = _getDreamBrainrots()
            if #dreamList == 0 then

                for _, rarity in ipairs(ALL_RARITIES) do
                    local folder = getBrainrotFolder(rarity)
                    if folder then
                        for _, obj in ipairs(folder:GetChildren()) do
                            if obj and obj.Parent then
                                for _, db in ipairs(DREAM_BRAINROTS) do
                                    if obj.Name == db.name then
                                        table.insert(dreamList, { obj = obj, rarity = rarity })
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if #dreamList == 0 then
                Rayfield:Notify({ Title = "🧸 Dream", Content = "No Dream brainrots found.", Duration = 3, Image = 4483362458 })
                return
            end
            local char = Players.LocalPlayer.Character
            if char and char.PrimaryPart then
                local myPos = char.PrimaryPart.Position
                table.sort(dreamList, function(a, b)
                    local ppA = (a.obj.PrimaryPart and a.obj.PrimaryPart.Position) or myPos
                    local ppB = (b.obj.PrimaryPart and b.obj.PrimaryPart.Position) or myPos
                    return (ppA - myPos).Magnitude < (ppB - myPos).Magnitude
                end)
            end
            hideLava()
            local ok, did = pcall(grabBrainrot, dreamList[1].obj)
            if ok and did then
                Rayfield:Notify({ Title = "🧸 Dream", Content = "Collected Dream brainrot!", Duration = 2, Image = 4483362458 })
            else
                Rayfield:Notify({ Title = "🧸 Dream", Content = "Failed to collect.", Duration = 2, Image = 4483362458 })
            end
        end)
    end,
})

DreamsTab:CreateSection("📊 Reward Track")

DreamsTab:CreateButton({
    Name     = "📊 Check Reward Track Progress",
    Callback = function()
        task.spawn(function()
            local ok, result = pcall(function()
                local remote = ReplicatedStorage
                    :WaitForChild("Remotes", 5)
                    :WaitForChild("DreamEvent", 5)
                    :WaitForChild("GetRewardTrackState", 5)
                if remote:IsA("RemoteFunction") then
                    return remote:InvokeServer()
                end
                return nil
            end)
            local milestones = {2, 4, 6, 8, 10, 12, 14, 16, 19, 22}
            local rewards = {
                "Slapper x5", "$25,000", "Dream Lucky Block", "75 Coins",
                "Cloudini Genie", "Dream Lucky Block", "Magic Carpet x1",
                "Dream Lucky Block", "Level Potion x1", "Los Tic Tacs Citos"
            }
            if ok and type(result) == "table" and result.submitted ~= nil then
                local sub = tonumber(result.submitted) or 0
                local nextIdx = 1
                for i, m in ipairs(milestones) do
                    if sub >= m then nextIdx = i + 1 end
                end
                local nextReward = rewards[nextIdx] or "All rewards claimed!"
                local nextMile   = milestones[nextIdx] or "MAX"
                Rayfield:Notify({
                    Title   = "📊 Dream Track",
                    Content = "Submitted: " .. sub .. "\nNext reward (" .. tostring(nextMile) .. "): " .. nextReward,
                    Duration = 6, Image = 4483362458,
                })
            else

                local rewardList = ""
                for i, m in ipairs(milestones) do
                    rewardList = rewardList .. "✦ " .. m .. " → " .. rewards[i] .. "\n"
                end
                Rayfield:Notify({
                    Title   = "📊 Dream Machine Rewards",
                    Content = rewardList:sub(1, 250),
                    Duration = 8, Image = 4483362458,
                })
            end
        end)
    end,
})

end)()

;(function()

_aquaRunning            = false
local _aquaCastConn     = nil
local _aquaMinigameConn = nil
local _aquaStats        = { casts = 0, catches = 0, fails = 0, startTick = 0 }

local _aquaStatsPara    = nil

local _aquaRemotes = {}
_getAquaRemotes = function()
    if _aquaRemotes.cast and _aquaRemotes.cast.Parent then return true end
    local ok, r = pcall(function()
        return game:GetService("ReplicatedStorage").Remotes:WaitForChild("AquaEvent", 5)
    end)
    if not ok or not r then return false end
    _aquaRemotes.cast        = r:FindFirstChild("CastFishingRod")
    _aquaRemotes.reel        = r:FindFirstChild("ReelIn")
    _aquaRemotes.startMini   = r:FindFirstChild("StartMinigame")
    _aquaRemotes.miniResult  = r:FindFirstChild("MinigameResult")
    return _aquaRemotes.cast ~= nil
end

_isAquaActive = function()
    if workspace:GetAttribute("AquaEventActive") == true then return true end
    if workspace:GetAttribute("AquaEvent") == true then return true end

    local ok, found = pcall(function()
        local json = workspace:GetAttribute("ActiveEvents")
        if not json or json == "" then return false end
        local d = game:GetService("HttpService"):JSONDecode(json)
        for key, _ in pairs(d) do
            if tostring(key):lower():find("aqua", 1, true) then return true end
        end
        return false
    end)
    return ok and found or false
end

_getAquaQueuedTime = function()

    local ok2, result2 = pcall(function()
        if not _etcCached then
            _etcCached = require(game:GetService("ReplicatedStorage").Modules.EventTimerController)
        end
        local etc = _etcCached
        if not etc or not etc.OnGoingTimers then return nil end
        for _, timer in pairs(etc.OnGoingTimers) do
            local rn   = tostring(timer.RealName or ""):lower()
            local trem = tonumber(timer.TimeRemaining) or 0
            local ui   = timer.UI
            local name = ""
            if typeof(ui) == "Instance" then
                local nl = ui:FindFirstChild("NameLabel")
                if nl and nl:IsA("TextLabel") then name = nl.Text:lower() end
            end
            if (rn:find("aqua") or name:find("aqua")) and trem >= 0 then
                local isActive = false
                pcall(function()
                    local json2 = workspace:GetAttribute("ActiveEvents")
                    if json2 and json2 ~= "" then
                        local d2 = game:GetService("HttpService"):JSONDecode(json2)
                        for k2 in pairs(d2) do
                            if tostring(k2):lower():find("aqua") then isActive = true end
                        end
                    end
                end)
                if not isActive then return math.max(trem, 5) end
            end
        end
        return nil
    end)
    if ok2 and result2 then return result2 end

    local ok, result = pcall(function()
        local json = workspace:GetAttribute("QueuedEvents")
        if not json or json == "" then return nil end
        local d = game:GetService("HttpService"):JSONDecode(json)
        for key, entry in pairs(d) do
            if tostring(key):lower():find("aqua", 1, true) then
                local t = tonumber(type(entry) == "table" and entry.EventTime) or 0
                if t > 0 then return math.min(t, 1200) end
            end
        end
        return nil
    end)
    return ok and result or nil
end

local function _getWaterPos()
    local gf = workspace:FindFirstChild("GameFolder")
    local ae = gf and gf:FindFirstChild("AquaEvent")
    if ae then
        local fm  = ae:FindFirstChild("FishingModel")
        local wp  = fm and fm:FindFirstChild("WaterPart")
        local att = wp and wp:FindFirstChild("PromptAttachment")
        if att then return att.WorldPosition end
        if wp  then return wp.Position end
        local bp = ae:FindFirstChildWhichIsA("BasePart")
        if bp  then return bp.Position end
    end
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        return root.Position + root.CFrame.LookVector * 12 - Vector3.new(0, 3, 0)
    end
    return Vector3.new(0, 0, 0)
end

local function _equipFishingRod()
    local char    = player.Character
    local backpack = player:FindFirstChild("Backpack")
    if not char or not backpack then return false end
    if char:FindFirstChild("Fishing Rod") then return true end
    for _, v in pairs(backpack:GetChildren()) do
        if v:IsA("Tool") and v.Name == "Fishing Rod" then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum:EquipTool(v) end) end
            task.wait(0.2)
            return char:FindFirstChild("Fishing Rod") ~= nil
        end
    end
    return false
end

local function _updateAquaStats()
    if not _aquaStatsPara then return end
    if not _aquaRunning then return end
    pcall(function()
        local elapsed = tick() - _aquaStats.startTick
        local mins    = math.floor(elapsed / 60)
        local secs    = math.floor(elapsed % 60)
        local rate    = _aquaStats.catches > 0
            and string.format("%.1f/min", _aquaStats.catches / math.max(elapsed / 60, 0.01))
            or  "—"
        _aquaStatsPara:Set({
            Title   = "📊 Session Stats",
            Content = string.format(
                "🎣 Casts: %d   ✅ Catches: %d   ❌ Fails: %d\n⚡ Rate: %s   ⏱ %02d:%02d",
                _aquaStats.casts, _aquaStats.catches, _aquaStats.fails, rate, mins, secs
            ),
        })
    end)
end

local function _stopAquaLoopImpl()
    _aquaRunning = false
    if _aquaThread       then pcall(task.cancel, _aquaThread)       _aquaThread       = nil end
    if _aquaMinigameConn then pcall(function() _aquaMinigameConn:Disconnect() end) _aquaMinigameConn = nil end
    if _aquaCastConn     then pcall(function() _aquaCastConn:Disconnect() end)     _aquaCastConn     = nil end
    getgenv()._OxyoStopAquaLoop = nil
end
_stopAquaLoop = _stopAquaLoopImpl
getgenv()._OxyoStopAquaLoop = _stopAquaLoop

_startAquaLoop = function()
    if not _getAquaRemotes() then
        Rayfield:Notify({
            Title   = "🎣 Auto Fish",
            Content = "AquaEvent remotes not found.\nMake sure the Aqua Event is active!",
            Duration = 5, Image = 4483362458,
        })
        _aquaRunning = false
        pcall(function()
            local f = Rayfield.Flags and Rayfield.Flags["AutoFish"]
            if f then f:Set(false) end
        end)
        return
    end

    _aquaStats = { casts = 0, catches = 0, fails = 0, startTick = tick() }
    local _miniPending = false

    if _aquaMinigameConn then _aquaMinigameConn:Disconnect() end
    _aquaMinigameConn = _aquaRemotes.startMini.OnClientEvent:Connect(function()
        if not _aquaRunning then return end
        _miniPending = true
        task.spawn(function()
            task.wait(0.05)
            if not _aquaRunning then _miniPending = false return end
            if _aquaRemotes.miniResult and _aquaRemotes.miniResult.Parent then
                pcall(function() _aquaRemotes.miniResult:FireServer(true) end)
            end
            _aquaStats.catches = _aquaStats.catches + 1
            _miniPending = false
            _updateAquaStats()
        end)
    end)

    _aquaThread = task.spawn(function()
        Rayfield:Notify({
            Title   = "🎣 Auto Fish ON",
            Content = "Casting every ~3s with max luck!\nMake sure Fishing Rod is in backpack.",
            Duration = 4, Image = 4483362458,
        })

        while _aquaRunning do
            if not _isAquaActive() then
                Rayfield:Notify({
                    Title   = "🎣 Auto Fish",
                    Content = "Aqua Event not active — waiting...",
                    Duration = 4, Image = 4483362458,
                })
                local waited = 0
                while not _isAquaActive() and _aquaRunning do
                    task.wait(3)
                    waited = waited + 3
                    if waited >= 120 then
                        Rayfield:Notify({
                            Title   = "🎣 Auto Fish",
                            Content = "No Aqua Event after 2 min — stopped.",
                            Duration = 5, Image = 4483362458,
                        })
                        _aquaRunning = false
                        pcall(function()
                            local f = Rayfield.Flags and Rayfield.Flags["AutoFish"]
                            if f then f:Set(false) end
                        end)
                        return
                    end
                end
                if not _aquaRunning then break end
                Rayfield:Notify({
                    Title   = "🎣 Auto Fish",
                    Content = "Aqua Event detected — casting!",
                    Duration = 3, Image = 4483362458,
                })
            end

            if _miniPending then task.wait(0.2) continue end

            pcall(_equipFishingRod)

            local char = player.Character
            if not char or not char:FindFirstChild("Fishing Rod") then
                Rayfield:Notify({
                    Title   = "🎣 Auto Fish",
                    Content = "Fishing Rod not found in backpack!\nBuy one from the shop first.",
                    Duration = 6, Image = 4483362458,
                })
                task.wait(5)
                continue
            end

            local waterPos = _getWaterPos()
            local ok = false
            if _aquaRemotes.cast and _aquaRemotes.cast.Parent then
                ok = pcall(function()
                    _aquaRemotes.cast:FireServer(waterPos, 3)
                end)
            end

            if ok then
                _aquaStats.casts = _aquaStats.casts + 1
                _updateAquaStats()
            end

            local waitTime = 0
            while waitTime < 3.5 and _aquaRunning do
                task.wait(0.1)
                waitTime = waitTime + 0.1
                if _miniPending then break end
            end

            if _aquaRunning and not _miniPending then
                if _aquaRemotes.reel and _aquaRemotes.reel.Parent then
                    pcall(function() _aquaRemotes.reel:FireServer() end)
                end
                _aquaStats.fails = _aquaStats.fails + 1
                _updateAquaStats()
                task.wait(2.2)
            else
                task.wait(2.2)
            end
        end
    end)
end

AquaTab:CreateSection("🎣 Auto Fish")

AquaTab:CreateParagraph({
    Title   = "How it works",
    Content = "Automatically casts your Fishing Rod with max luck (x3),\n"
           .. "waits for a bite, then instantly completes the minigame.\n"
           .. "Requires: Aqua Event active + Fishing Rod in backpack.",
})

_aquaStatsPara = AquaTab:CreateParagraph({
    Title   = "📊 Session Stats",
    Content = "Idle — start Auto Fish to begin tracking.",
})

AquaTab:CreateToggle({
    Name         = "🎣 Auto Fish",
    CurrentValue = false,
    Flag         = "AutoFish",
    Callback     = function(val)
        _aquaRunning = val
        if val then
            hideLava()
            _startAquaLoop()
        else
            _stopAquaLoop()
            _updateAquaStats()
            pcall(function()
                if _aquaStatsPara then
                    _aquaStatsPara:Set({
                        Title   = "📊 Session Ended",
                        Content = string.format(
                            "🎣 Casts: %d   ✅ Catches: %d   ❌ Fails: %d",
                            _aquaStats.casts, _aquaStats.catches, _aquaStats.fails
                        ),
                    })
                end
            end)
            Rayfield:Notify({
                Title   = "🎣 Auto Fish OFF",
                Content = string.format("Session: %d casts, %d catches", _aquaStats.casts, _aquaStats.catches),
                Duration = 4, Image = 4483362458,
            })
        end
    end,
})

AquaTab:CreateSection("🔧 Manual Controls")

AquaTab:CreateButton({
    Name     = "🔍 Check Aqua Event Status",
    Callback = function()
        local active = _isAquaActive()
        local queuedSecs = _getAquaQueuedTime()
        local hasRod = false
        pcall(function()
            local bp = player:FindFirstChild("Backpack")
            local ch = player.Character
            hasRod = (bp and bp:FindFirstChild("Fishing Rod") ~= nil)
                  or (ch and ch:FindFirstChild("Fishing Rod") ~= nil)
        end)
        local remotesOk = _getAquaRemotes()
        local statusLine
        if active then
            statusLine = "✅ ACTIVE now!"
        elseif queuedSecs and queuedSecs > 0 then
            statusLine = string.format("⏳ Queued — starts in %dm %ds", math.floor(queuedSecs/60), queuedSecs%60)
        else
            statusLine = "❌ Not active / not queued"
        end
        Rayfield:Notify({
            Title   = active and "🌊 Aqua Event: ACTIVE" or (queuedSecs and "⏳ Aqua Event: Queued" or "⚠️ Aqua Event: Inactive"),
            Content = string.format(
                "Event: %s\nFishing Rod: %s\nRemotes: %s",
                statusLine,
                hasRod and "✅ Found" or "❌ Not in backpack",
                remotesOk and "✅ Found" or "❌ Missing"
            ),
            Duration = 8, Image = 4483362458,
        })
    end,
})

end)()

if getgenv().OxyoAutoHopAqua == true and not getgenv().OxyoHopAquaStopped then
    S.autoHopAquaEnabled = true
    hideLava()
    showStopHopGui()
    S.autoHopAquaThread = task.spawn(function()
        task.wait(4)
        while getgenv().OxyoAutoHopAqua and not getgenv().OxyoHopAquaStopped do
            if _isAquaActive() then
                if not _getAquaRemotes() then
                    task.wait(3)
                    if getgenv().OxyoAutoHopAqua and not getgenv().OxyoHopAquaStopped then
                        task.spawn(ServerHop)
                    end
                    return
                end
                _aquaRunning = true
                _startAquaLoop()
                local waited = 0
                while _aquaRunning and getgenv().OxyoAutoHopAqua and not getgenv().OxyoHopAquaStopped do
                    task.wait(5) waited = waited + 5
                    if not _isAquaActive() and waited > 10 then _stopAquaLoop() break end
                end
                if not getgenv().OxyoAutoHopAqua or getgenv().OxyoHopAquaStopped then return end
                task.wait(2)
                if getgenv().OxyoAutoHopAqua and not getgenv().OxyoHopAquaStopped then task.spawn(ServerHop) end
                return
            else

                local _aquaGraceEnd2 = tick() + 8
                while not _isAquaActive() and tick() < _aquaGraceEnd2
                    and getgenv().OxyoAutoHopAqua and not getgenv().OxyoHopAquaStopped do
                    task.wait(1)
                end
                if _isAquaActive() then continue end

                local queuedSecs = _getAquaQueuedTime()
                if queuedSecs and queuedSecs > 0 and queuedSecs <= 1200 then
                    local mins = math.floor(queuedSecs / 60)
                    local secs = queuedSecs % 60
                    Rayfield:Notify({
                        Title   = "🌊 Aqua Event Incoming!",
                        Content = string.format("Queued in %dm %ds — waiting on this server!", mins, secs),
                        Duration = 6, Image = 4483362458,
                    })
                    local waited2 = 0
                    while waited2 < queuedSecs + 10
                        and getgenv().OxyoAutoHopAqua
                        and not getgenv().OxyoHopAquaStopped
                        and not _isAquaActive() do
                        task.wait(2)
                        waited2 = waited2 + 2
                    end
                    continue
                end
                task.wait(math.random(5,10))
                if getgenv().OxyoAutoHopAqua and not getgenv().OxyoHopAquaStopped then task.spawn(ServerHop) end
                return
            end
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(1800)
        pcall(function()
            getgenv().OxyoDeadServers    = {}
            getgenv().OxyoVisitedServers = {}
        end)
    end
end)
print("Oxyo Hub loaded.")
