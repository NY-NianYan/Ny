--所属功能：WindUI加载
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

--所属功能：防重复执行
local ScriptRunningFlag = "_SiScript_IsRunning"
if getrenv()[ScriptRunningFlag] then
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://87437544236708"
        s.Volume = 0.5
        s.Parent = SoundService
        s:Play()
        Debris:AddItem(s, 3)
    end)
    return
end
getrenv()[ScriptRunningFlag] = true
local ScriptClosed = false

--所属功能：提示音
local function playNotifySound()
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://87437544236708"
        s.Volume = 0.5
        s.Parent = SoundService
        s:Play()
        Debris:AddItem(s, 3)
    end)
end

local function Notify(text, duration)
    playNotifySound()
    pcall(function()
        WindUI:Notify({Title = "NY恶魔学", Content = tostring(text), Duration = duration or 1})
    end)
end

--所属功能：主界面
local Window = WindUI:CreateWindow({
    Title = "NY恶魔学",
    Author = "创作者测试",
    Icon = "ghost",
    Size = UDim2.fromOffset(600, 420),
    Theme = "Dark",
    Resizable = true
})

--所属功能：Tab
local TabGhost = Window:Tab({Title = "幽灵区", Icon = "ghost"})
local TabEvidence = Window:Tab({Title = "证据", Icon = "search"})
local TabItems = Window:Tab({Title = "物品", Icon = "box"})
local TabPlayer = Window:Tab({Title = "玩家", Icon = "user"})
local TabMap = Window:Tab({Title = "地图", Icon = "map"})
local TabSettings = Window:Tab({Title = "设置", Icon = "settings"})

--所属功能：翻译
local TranslationMap = {
    Male = "男", Female = "女",
    ["Living Room"] = "客厅", Kitchen = "厨房", Bedroom = "卧室",
    ["Master Bedroom"] = "主卧室", ["Kids Bedroom"] = "儿童卧室",
    Bathroom = "洗手间", ["Master Bathroom"] = "主客卫", Basement = "地下室",
    Garage = "车库", Hallway = "走廊", Attic = "阁楼", Foyer = "门厅",
    ["Dining Room"] = "餐厅", Library = "图书馆", Study = "书房",
    ["Laundry Room"] = "洗衣房", ["Storage Room"] = "储藏室",
    Corridor = "通道", Closet = "壁橱", ["Cold Storage Room"] = "冷藏室",
    ["Cleaning Room"] = "洁净室", Office = "办公室", Stairway = "楼梯间",
    ["Base Camp"] = "基地营地", ["Service Station"] = "服务站", ["Main Store"] = "主商店",
    ["Master Closet"] = "主壁橱", ["Blue Bedroom"] = "蓝色卧室",
    ["Pink Bedroom"] = "粉色卧室", Pantry = "食品储藏室",
    ["F2 Dining Area"] = "二楼餐区", Scullery = "洗涤间", ["Staff Room"] = "员工房",
    ["Coffee Bar"] = "咖啡吧", ["Restroom 2"] = "洗手间2", ["Restroom 1"] = "洗手间1",
    ["Meeting Room 2"] = "会议室2", ["Meeting Room 1"] = "会议室1",
    ["F1 Dining Area"] = "一楼餐区", Alley = "小巷", Lounge = "休息室",
    ["Staff Bathroom"] = "员工浴室", ["F2 Hallway"] = "二楼走廊",
    ["Closet Room"] = "壁橱房", ["F1 Hallway"] = "一楼走廊", Stairs = "楼梯",
    Laundry = "洗衣房",
    ["Cell Block A"] = "A区牢房", ["Block A Guard Room F1"] = "A区一楼警卫室",
    ["Block B Hallway"] = "B区走廊", ["Block A Checkpoint"] = "A区检查站",
    Classroom = "教室", ["Block A Hallway"] = "A区走廊", ["Program Room"] = "活动室",
    Showers = "淋浴室", ["Block A Stairwell"] = "A区楼梯间",
    ["Services Hallway"] = "服务走廊", ["Mail Room"] = "邮件室",
    ["Cell Block B"] = "B区牢房", ["Block B Checkpoint"] = "B区检查站",
    Cafeteria = "食堂", ["Staff Restroom"] = "员工洗手间",
    ["Guards Office"] = "警卫办公室", Armory = "军械库", Infirmary = "医务室",
    ["Admin Control Room"] = "行政控制室", Workshop = "工坊",
    ["Blacklight"] = "紫外线手电", Cross = "十字架", ["EMF Reader"] = "EMF检测仪",
    Flowers = "鲜花", ["Holy Oil"] = "圣油", ["LIDAR Scanner"] = "激光雷达扫描仪",
    ["Laser Proj."] = "点阵投影仪", ["Laser Projector"] = "点阵投影仪",
    ["Photo Camera"] = "数码相机", Plushie = "玩偶", ["Spirit Book"] = "通灵书",
    ["Spirit Box"] = "通灵盒", Thermometer = "温度计", ["Video Camera"] = "摄像机",
    ["Flower Pot"] = "花盆", ["Energy Drink"] = "能量饮料", Flashlight = "手电筒",
    ["Salt Canister"] = "盐罐", ["Fortune Coin"] = "好运币", ["Haunted Mirror"] = "鬼镜",
    ["Music box"] = "音乐盒", ["Music Box"] = "音乐盒", ["Magnifying Glass"] = "放大镜",
    ["Summoning Circle"] = "召唤阵", ["Umbra Board"] = "通灵板",
    Lighter = "打火机", ["Energy Watch"] = "理智手表"
}

local function translate(text)
    if text == nil then return "未知" end
    return TranslationMap[tostring(text)] or tostring(text)
end

--所属功能：诅咒道具
local CursedItemNames = {
    ["Haunted Mirror"] = true,
    ["Music box"] = true,
    ["Music Box"] = true,
    ["Magnifying Glass"] = true,
    ["Umbra Board"] = true,
    ["Summoning Circle"] = true
}

--所属功能：基础函数
local function getRoot(model)
    if not model then return nil end
    if model:IsA("BasePart") then return model end
    return model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
end

local function getDistance(position)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root or not position then return "无" end
    return string.format("%dm", math.floor((root.Position - position).Magnitude))
end

local function getAttributeAny(instance, names)
    if not instance then return nil end
    for _, name in ipairs(names) do
        local value = instance:GetAttribute(name)
        if value ~= nil then return value end
    end
end

local function getPlayerCurrentRoom()
    local value = LocalPlayer:GetAttribute("CurrentRoom") or (LocalPlayer:FindFirstChild("CurrentRoom") and LocalPlayer.CurrentRoom.Value)
    if not value and LocalPlayer.Character then
        value = LocalPlayer.Character:GetAttribute("CurrentRoom")
        local obj = LocalPlayer.Character:FindFirstChild("CurrentRoom", true)
        if obj and obj:IsA("ValueBase") then value = obj.Value end
    end
    return value
end

local function getGhostModel()
    local ghost = workspace:FindFirstChild("Ghost")
    if ghost and ghost:IsA("Model") then return ghost end
    ghost = workspace:FindFirstChild("Ghost", true)
    return ghost and ghost:IsA("Model") and ghost or nil
end

local function getRoomInstance(roomName)
    if not roomName then return nil end
    local map = workspace:FindFirstChild("Map")
    local rooms = map and map:FindFirstChild("Rooms")
    return rooms and rooms:FindFirstChild(tostring(roomName))
end

local function getRoomTemperatureByName(roomName)
    local room = getRoomInstance(roomName)
    if not room then return nil end
    local temp = room:GetAttribute("Temperature")
    if typeof(temp) == "number" then return temp end
    local value = room:FindFirstChild("Temperature", true)
    if value and value:IsA("NumberValue") then return value.Value end
end

local function getGhostRoomName(ghost)
    if not ghost then return getPlayerCurrentRoom() end
    return getAttributeAny(ghost, {"GhostRoom", "FavoriteRoom", "CurrentRoom", "Room"}) or getPlayerCurrentRoom()
end

local function detectGhostOrb()
    return workspace:FindFirstChild("GhostOrb", true) ~= nil
end

--所属功能：获取幽灵速度
local function getGhostSpeed(ghost)
    if not ghost then return nil end
    -- 尝试Humanoid
    local humanoid = ghost:FindFirstChildWhichIsA("Humanoid")
    if humanoid then
        return humanoid.WalkSpeed
    end
    -- 尝试根部件速度
    local root = getRoot(ghost)
    if root and root:IsA("BasePart") and root.Velocity then
        return root.Velocity.Magnitude
    end
    -- 尝试属性
    local attr = getAttributeAny(ghost, {"Speed", "MoveSpeed", "WalkSpeed", "CurrentSpeed", "MovementSpeed"})
    if attr ~= nil then
        if typeof(attr) == "number" then return attr end
        if typeof(attr) == "Vector3" then return attr.Magnitude end
        return tonumber(attr)
    end
    return nil
end

--所属功能：获取幽灵最高速度
local function getGhostMaxSpeed(ghost)
    if not ghost then return nil end
    local humanoid = ghost:FindFirstChildWhichIsA("Humanoid")
    if humanoid and humanoid.WalkSpeed then
        return humanoid.WalkSpeed
    end
    local attr = getAttributeAny(ghost, {"MaxSpeed", "MaxWalkSpeed", "MaximumSpeed", "TopSpeed"})
    if attr ~= nil then
        if typeof(attr) == "number" then return attr end
        if typeof(attr) == "Vector3" then return attr.Magnitude end
        return tonumber(attr)
    end
    return getGhostSpeed(ghost)
end

--所属功能：ESP
local ESPEnabled = {
    Ghost = false, Player = false, Generator = false, Fingerprint = false,
    Item = false, Cursed = false, GhostOrb = false, Candle = false
}
local ESPStorage = {}
local GhostTransparency = {}
local ESPColors = {
    Ghost = Color3.fromRGB(138, 43, 226),
    Player = Color3.fromRGB(0, 255, 80),
    Generator = Color3.fromRGB(255, 230, 0),
    Fingerprint = Color3.fromRGB(0, 255, 80),
    Item = Color3.fromRGB(0, 255, 255),
    Cursed = Color3.fromRGB(255, 150, 0),
    GhostOrb = Color3.fromRGB(170, 255, 190),
    Candle = Color3.fromRGB(255, 60, 60)
}

local function createHighlight(object, espType)
    if not object or not object:IsDescendantOf(workspace) then return nil end
    local old = object:FindFirstChild("SiESPHighlight")
    if old then old:Destroy() end
    local highlight = Instance.new("Highlight")
    highlight.Name = "SiESPHighlight"
    highlight.FillColor = ESPColors[espType]
    highlight.FillTransparency = 0.72
    highlight.OutlineColor = ESPColors[espType]
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = object
    return highlight
end

local function getDisplayName(object, espType)
    if espType == "Player" then
        local player = Players:GetPlayerFromCharacter(object)
        if player then return player.DisplayName or player.Name end
    elseif espType == "Item" or espType == "Cursed" then
        local name = object:GetAttribute("ItemName")
        if name then return translate(name) end
    elseif espType == "Generator" then return "发电机"
    elseif espType == "Fingerprint" then return "指纹"
    elseif espType == "Ghost" then return "幽灵"
    elseif espType == "GhostOrb" then return "幽灵球"
    elseif espType == "Candle" then return "蜡烛"
    end
    return object.Name
end

--所属功能：普通ESP
local function createESP(object, espType)
    if not object or not object:IsDescendantOf(workspace) then return end
    if ESPStorage[object] then
        if ESPStorage[object].type == espType then return end
        local old = ESPStorage[object]
        pcall(function()
            if old.highlight then old.highlight:Destroy() end
            if old.billboard then old.billboard:Destroy() end
            if old.connection then old.connection:Disconnect() end
        end)
        ESPStorage[object] = nil
    end
    local root = getRoot(object)
    if not root then return end
    local highlight = createHighlight(object, espType)
    if not highlight then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "SiESPInfo"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.fromOffset(220, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Adornee = root
    billboard.Parent = root
    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.TextColor3 = ESPColors[espType]
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextWrapped = true
    label.Parent = billboard
    local function update()
        label.Text = getDisplayName(object, espType) .. "\n[" .. getDistance(root.Position) .. "]"
    end
    update()
    local connection = RunService.Heartbeat:Connect(function()
        if ScriptClosed or not ESPEnabled[espType] or not object:IsDescendantOf(workspace) or not root:IsDescendantOf(workspace) then return end
        update()
    end)
    ESPStorage[object] = {type = espType, highlight = highlight, billboard = billboard, connection = connection}
end

--所属功能：幽灵透明度
local function restoreGhostTransparency(object)
    local saved = GhostTransparency[object]
    if not saved then return end
    for instance, info in pairs(saved) do
        if instance and instance.Parent then
            pcall(function()
                if info.Transparency ~= nil then instance.Transparency = info.Transparency end
                if info.Material ~= nil and instance:IsA("BasePart") then instance.Material = info.Material end
            end)
        end
    end
    GhostTransparency[object] = nil
end

--所属功能：幽灵ESP
local function createGhostESP(object)
    if not object or not object:IsDescendantOf(workspace) then return end
    if ESPStorage[object] then return end
    if not GhostTransparency[object] then
        GhostTransparency[object] = {}
        for _, part in ipairs(object:GetDescendants()) do
            if part:IsA("BasePart") then
                GhostTransparency[object][part] = {Transparency = part.Transparency, Material = part.Material}
                part.Transparency = 0
                part.Material = Enum.Material.SmoothPlastic
            elseif part:IsA("Decal") or part:IsA("Texture") then
                GhostTransparency[object][part] = {Transparency = part.Transparency}
                part.Transparency = 0
            end
        end
    else
        for part in pairs(GhostTransparency[object]) do
            if part and part.Parent then
                pcall(function()
                    part.Transparency = 0
                    if part:IsA("BasePart") then part.Material = Enum.Material.SmoothPlastic end
                end)
            end
        end
    end
    local root = getRoot(object)
    if not root then return end
    local highlight = createHighlight(object, "Ghost")
    if not highlight then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "SiGhostInfo"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.fromOffset(320, 34)
    billboard.StudsOffset = Vector3.new(0, 3.2, 0)
    billboard.Adornee = root
    billboard.Parent = root
    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.TextColor3 = ESPColors.Ghost
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSans
    label.TextSize = 13
    label.TextWrapped = true
    label.Parent = billboard
    local function update()
        local room = translate(getGhostRoomName(object))
        local age = getAttributeAny(object, {"Age", "GhostAge"}) or "未知"
        local gender = translate(getAttributeAny(object, {"Gender", "Sex"}))
        local orb = detectGhostOrb() and "🟩" or "🟥"
        local hunting = object:GetAttribute("Hunting") == true and "🟩" or "🟥"
        label.Text = string.format("幽灵 | 房间:%s | 年龄:%s | 性别:%s | 球:%s | 猎杀:%s | [%s]", room, age, gender, orb, hunting, getDistance(root.Position))
    end
    local connection = RunService.Heartbeat:Connect(function()
        if ScriptClosed or not ESPEnabled.Ghost or not object:IsDescendantOf(workspace) or not root:IsDescendantOf(workspace) then return end
        update()
    end)
    ESPStorage[object] = {type = "Ghost", highlight = highlight, billboard = billboard, connection = connection}
end

--所属功能：ESP删除
local function removeESP(object)
    local data = ESPStorage[object]
    if not data then return end
    pcall(function()
        if data.highlight then data.highlight:Destroy() end
        if data.billboard then data.billboard:Destroy() end
        if data.connection then data.connection:Disconnect() end
    end)
    if data.type == "Ghost" then restoreGhostTransparency(object) end
    ESPStorage[object] = nil
end

local function clearESPType(espType)
    for object, data in pairs(ESPStorage) do
        if data.type == espType then removeESP(object) end
    end
end

--所属功能：ESP扫描
local function collectObjects(espType)
    local result = {}
    if espType == "Ghost" then
        local ghost = getGhostModel()
        if ghost then table.insert(result, ghost) end
    elseif espType == "GhostOrb" then
        local orb = workspace:FindFirstChild("GhostOrb")
        if orb then table.insert(result, orb) end
    elseif espType == "Candle" then
        local map = workspace:FindFirstChild("Map")
        local candles = map and map:FindFirstChild("Candles")
        if candles then for _, candle in ipairs(candles:GetChildren()) do table.insert(result, candle) end end
    elseif espType == "Player" then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then table.insert(result, player.Character) end
        end
    elseif espType == "Generator" then
        local map = workspace:FindFirstChild("Map")
        local fuseBox = map and map:FindFirstChild("FuseBox")
        if fuseBox then table.insert(result, fuseBox) end
    elseif espType == "Fingerprint" then
        local handprints = workspace:FindFirstChild("Handprints")
        if handprints then for _, child in ipairs(handprints:GetChildren()) do table.insert(result, child) end end
    elseif espType == "Item" or espType == "Cursed" then
        local items = workspace:FindFirstChild("Items")
        if items then
            for _, child in ipairs(items:GetChildren()) do
                local itemName = child:GetAttribute("ItemName")
                if itemName then
                    local cursed = CursedItemNames[itemName] == true
                    if (espType == "Cursed" and cursed) or (espType == "Item" and not cursed) then table.insert(result, child) end
                end
            end
        end
    end
    return result
end

local function scanESP()
    if ScriptClosed then return end
    for espType, enabled in pairs(ESPEnabled) do
        if enabled then
            local found = {}
            for _, object in ipairs(collectObjects(espType)) do
                found[object] = true
                if espType == "Ghost" then createGhostESP(object) else createESP(object, espType) end
            end
            for object, data in pairs(ESPStorage) do
                if data.type == espType and not found[object] then removeESP(object) end
            end
        end
    end
end

local ESPConnection = RunService.Heartbeat:Connect(scanESP)

--所属功能：幽灵信息侧边栏
local SideGui = Instance.new("ScreenGui")
SideGui.Name = "SiSideStats"
SideGui.ResetOnSpawn = false
SideGui.IgnoreGuiInset = true
SideGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SideGui.Parent = CoreGui

local SideContainer = Instance.new("Frame")
SideContainer.Name = "Container"
SideContainer.Size = UDim2.fromOffset(90, 0)
SideContainer.AutomaticSize = Enum.AutomaticSize.Y
SideContainer.Position = UDim2.new(1, -100, 0, 10)
SideContainer.BackgroundTransparency = 1
SideContainer.Parent = SideGui

local SideList = Instance.new("UIListLayout")
SideList.SortOrder = Enum.SortOrder.LayoutOrder
SideList.Padding = UDim.new(0, 2)
SideList.HorizontalAlignment = Enum.HorizontalAlignment.Right
SideList.Parent = SideContainer

local function createRoundedInfoBox(name, size, textColor)
    local background = Instance.new("Frame")
    background.Name = name .. "Background"
    background.Size = size
    background.BackgroundColor3 = Color3.new(0, 0, 0)
    background.BackgroundTransparency = 0.25
    background.BorderSizePixel = 0
    background.Parent = SideContainer
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = background
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Transparency = 0.45
    stroke.Color = textColor
    stroke.Parent = background
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 2)
    padding.PaddingBottom = UDim.new(0, 2)
    padding.Parent = background
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.TextColor3 = textColor
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextStrokeTransparency = 0.2
    label.Font = Enum.Font.Code
    label.TextSize = 10
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Right
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.Parent = background
    return background, label
end

--所属功能：幽灵信息框
local GhostInfoBackground, GhostInfoLabel = createRoundedInfoBox("GhostInfo", UDim2.fromOffset(90, 145), Color3.fromRGB(0, 255, 255))
--所属功能：玩家信息框
local PlayerInfoBackground, PlayerStatsLabel = createRoundedInfoBox("PlayerInfo", UDim2.fromOffset(90, 45), Color3.new(1, 1, 1))
GhostInfoBackground.LayoutOrder = 1
PlayerInfoBackground.LayoutOrder = 2
GhostInfoBackground.Visible = false
PlayerInfoBackground.Visible = false
local GhostInfoEnabled = false

--所属功能：幽灵资料
local Ghosts = {
    {Name = "Aswang", CNName = "阿斯旺", Evidences = {"EMF5", "鬼写字", "花枯萎"}, Features = "每击杀一次移速变快；穿过盐会减速。"},
    {Name = "Banshee", CNName = "班希女巫", Evidences = {"冻结温度", "幽灵球", "指纹"}, Features = "更容易打碎玻璃；狩猎时会发出独特哭声。"},
    {Name = "Demon", CNName = "恶魔", Evidences = {"EMF5", "冻结温度", "指纹"}, Features = "极其危险、频繁狩猎；十字架对它效果更强。"},
    {Name = "Dullahan", CNName = "无头骑士", Evidences = {"冻结温度", "幽灵点阵", "花枯萎"}, Features = "照片中无头；盯着目标时间越久，移动速度越快。"},
    {Name = "Dybbuk", CNName = "迪布布克", Evidences = {"冻结温度", "指纹", "花枯萎"}, Features = "可以投掷尸体；第一次播放音乐盒会被定住。"},
    {Name = "Entity", CNName = "实体", Evidences = {"指纹", "幽灵点阵"}, Features = "可以传送；投掷物品前会先传送物体。"},
    {Name = "Ghoul", CNName = "食尸鬼", Evidences = {"冻结温度", "幽灵球"}, Features = "听到人声容易发怒；无法干扰电子设备。"},
    {Name = "Keres", CNName = "克雷斯", Evidences = {"指纹", "花枯萎"}, Features = "优先锁定能量最低的玩家；击杀玩家后自身持续减速。"},
    {Name = "Leviathan", CNName = "巨兽利维坦", Evidences = {"鬼写字", "指纹", "幽灵球"}, Features = "非狩猎状态也能闪烁、关闭灯光设备；会淹没周边电力。"},
    {Name = "Nightmare", CNName = "噩梦", Evidences = {"EMF5", "幽灵球"}, Features = "制造幻觉；更常在黑暗中狩猎。"},
    {Name = "Oni", CNName = "日本恶鬼", Evidences = {"冻结温度", "幽灵点阵"}, Features = "狩猎时会冲刺；现身频率远高于其他幽灵。"},
    {Name = "Phantom", CNName = "幻影", Evidences = {"EMF5", "指纹", "幽灵球"}, Features = "追击模式闪烁慢，隐身状态移速很快；情绪激动会变得凶猛。"},
    {Name = "Ravager", CNName = "掠夺者", Evidences = {"EMF5", "鬼写字"}, Features = "可以同时投掷多个物品；所有互动行为都会触发EMF5。"},
    {Name = "Revenant", CNName = "复仇者", Evidences = {"EMF5", "冻结温度", "鬼写字"}, Features = "狩猎冷却时间很短；击杀人类后会进入休息状态。"},
    {Name = "Shadow", CNName = "阴影", Evidences = {"EMF5", "鬼写字", "幽灵点阵"}, Features = "几乎不改变室温；明亮房间里活动频率大幅降低。"},
    {Name = "Siren", CNName = "海妖", Evidences = {"EMF5", "花枯萎"}, Features = "灵魂盒仅以女性语调回答；狩猎追逐时自身移速降低。"},
    {Name = "Skinwalker", CNName = "皮行者", Evidences = {"冻结温度", "鬼写字"}, Features = "可以伪造幽灵球证据；能模仿其他幽灵的专属能力。"},
    {Name = "Specter", CNName = "幽影", Evidences = {"EMF5", "冻结温度", "幽灵点阵"}, Features = "仅狩猎时会游荡，平时死守鬼房；投掷物品概率更高。"},
    {Name = "Spirit", CNName = "灵魂", Evidences = {"鬼写字", "指纹"}, Features = "无专属强弱项；可以改变蜡烛的火焰颜色。"},
    {Name = "Umbra", CNName = "暗影生物", Evidences = {"指纹", "幽灵球", "幽灵点阵"}, Features = "全程不会发出脚步声；光照充足的房间移动速度变慢。"},
    {Name = "Vesper", CNName = "维斯珀", Evidences = {"鬼写字", "指纹", "花枯萎"}, Features = "仅依靠声音狩猎定位；可以穿透墙壁进行追踪。"},
    {Name = "Vex", CNName = "维克", Evidences = {"冻结温度", "幽灵球", "花枯萎"}, Features = "激光扫描模式下无法被检测到；可以穿透墙壁行进。"},
    {Name = "Wendigo", CNName = "温迪戈", Evidences = {"鬼写字", "幽灵球", "幽灵点阵"}, Features = "惧怕明火，不会在火焰附近开始狩猎；能量越低移速越快。"},
    {Name = "The Wisp", CNName = "鬼火", Evidences = {"幽灵球", "幽灵点阵", "花枯萎"}, Features = "可以穿过火焰；只能在自己最喜欢的房间开启狩猎。"},
    {Name = "Wraith", CNName = "幽灵", Evidences = {"EMF5", "幽灵点阵"}, Features = "快速消耗猎人能量；不会触碰盐线。"}
}

--所属功能：证据状态
local EvidenceState = {
    EMF5 = false, Finger = false, Orb = false, Temp = false,
    Writing = false, Flower = false, Dots = false
}
local EvidenceConfirmed = {
    EMF5 = false, Finger = false, Orb = false, Temp = false,
    Writing = false, Flower = false, Dots = false
}
local EvidenceNameMap = {
    EMF5 = "EMF5", Finger = "指纹", Orb = "幽灵球", Temp = "冻结温度",
    Writing = "鬼写字", Flower = "花枯萎", Dots = "幽灵点阵"
}
local EvidenceDisplayName = {
    EMF5 = "EMF5级", Finger = "指纹", Orb = "幽灵球", Temp = "冻结温度",
    Writing = "鬼写字", Flower = "花枯萎", Dots = "幽灵点阵"
}

--所属功能：证据判断
local function ghostHasEvidence(ghost, evidence)
    return table.find(ghost.Evidences, evidence) ~= nil
end

local function isGhostPossible(ghost)
    for stateName, evidenceName in pairs(EvidenceNameMap) do
        if EvidenceConfirmed[stateName] then
            local has = ghostHasEvidence(ghost, evidenceName)
            if EvidenceState[stateName] and not has then return false end
            if not EvidenceState[stateName] and has then return false end
        end
    end
    return true
end

local function getPossibleGhostList()
    local result = {}
    for _, ghost in ipairs(Ghosts) do
        if isGhostPossible(ghost) then table.insert(result, ghost) end
    end
    return result
end

local function getPositiveEvidenceCount()
    local count = 0
    for name in pairs(EvidenceState) do
        if EvidenceConfirmed[name] and EvidenceState[name] then count += 1 end
    end
    return count
end

--所属功能：证据Paragraph
local EvidenceParagraph = TabEvidence:Paragraph({Title = "证据", Desc = "等待证据检测..."})
local GhostSearchParagraph = TabEvidence:Paragraph({Title = "幽灵检索", Desc = "正在等待证据..."})

--所属功能：证据文本
local function getEvidenceStatusText(name)
    if not EvidenceConfirmed[name] then return "❔" end
    return EvidenceState[name] and "🟩" or "🟥"
end

local function buildEvidenceText()
    local lines = {"自动检测结果", ""}
    local ordered = {"EMF5", "Finger", "Orb", "Temp", "Writing", "Flower", "Dots"}
    for _, name in ipairs(ordered) do
        table.insert(lines, EvidenceDisplayName[name] .. "：" .. getEvidenceStatusText(name))
    end
    table.insert(lines, "")
    table.insert(lines, "🟩 已发现　🟥 已确认不存在　❔ 未确认")
    return table.concat(lines, "\n")
end

--所属功能：幽灵检索
local GhostDropdownValues = {"请选择幽灵"}
local GhostDataMap = {}
local SelectedGhostDisplay
local GhostSelector
local UpdatingGhostSelector = false
local LastGhostDropdownSignature

local function getGhostDisplay(ghost)
    return string.format("%s [%s]", ghost.Name, ghost.CNName)
end

local function getGhostDropdownSignature(list)
    return table.concat(list, "\31")
end

local function buildGhostSearchText()
    local possible = getPossibleGhostList()
    local positiveCount = getPositiveEvidenceCount()
    local lines = {}
    if #possible == 0 then
        return "状态：❌ 没有符合当前证据的幽灵"
    end
    if #possible == 1 and positiveCount >= 3 then
        local ghost = possible[1]
        table.insert(lines, "状态：🟩 已锁定")
        table.insert(lines, "幽灵：" .. ghost.Name .. " [" .. ghost.CNName .. "]")
        table.insert(lines, "证据：" .. table.concat(ghost.Evidences, "、"))
        table.insert(lines, "特征：" .. ghost.Features)
    else
        table.insert(lines, "状态：🔎 正在筛选")
        table.insert(lines, "候选数量：" .. #possible)
        local names = {}
        for _, ghost in ipairs(possible) do
            table.insert(names, ghost.Name .. " [" .. ghost.CNName .. "]")
        end
        table.insert(lines, "候选：" .. table.concat(names, "、"))
    end
    if SelectedGhostDisplay and GhostDataMap[SelectedGhostDisplay] then
        local ghost = GhostDataMap[SelectedGhostDisplay]
        table.insert(lines, "")
        table.insert(lines, "当前选择：" .. ghost.Name .. " [" .. ghost.CNName .. "]")
        table.insert(lines, "证据：" .. table.concat(ghost.Evidences, "、"))
        table.insert(lines, "特征：" .. ghost.Features)
    end
    return table.concat(lines, "\n")
end

local function updateEvidenceUI()
    if ScriptClosed then return end
    pcall(function()
        EvidenceParagraph:SetDesc(buildEvidenceText())
        GhostSearchParagraph:SetDesc(buildGhostSearchText())
    end)
end

local function refreshGhostQuery()
    if ScriptClosed then return end
    local newList = {"请选择幽灵"}
    local newMap = {}
    local possible = getPossibleGhostList()
    for _, ghost in ipairs(possible) do
        local display = getGhostDisplay(ghost)
        table.insert(newList, display)
        newMap[display] = ghost
    end
    local signature = getGhostDropdownSignature(newList)
    local oldSelected = SelectedGhostDisplay
    local oldStillExists = oldSelected and newMap[oldSelected] ~= nil
    GhostDropdownValues = newList
    GhostDataMap = newMap
    if GhostSelector and signature ~= LastGhostDropdownSignature then
        LastGhostDropdownSignature = signature
        UpdatingGhostSelector = true
        pcall(function()
            GhostSelector:Refresh(newList)
            if oldStillExists then GhostSelector:SetValue(oldSelected) else GhostSelector:SetValue("请选择幽灵") end
        end)
        SelectedGhostDisplay = oldStillExists and oldSelected or nil
        UpdatingGhostSelector = false
    end
    updateEvidenceUI()
end

--所属功能：幽灵选择器
GhostSelector = TabEvidence:Dropdown({
    Title = "选择幽灵",
    Desc = "从当前可能的幽灵中选择",
    Values = GhostDropdownValues,
    Value = "请选择幽灵",
    Callback = function(value)
        if UpdatingGhostSelector then return end
        if value == "请选择幽灵" or not value then
            SelectedGhostDisplay = nil
            updateEvidenceUI()
            return
        end
        local ghost = GhostDataMap[value]
        if not ghost then return end
        if SelectedGhostDisplay ~= value then
            SelectedGhostDisplay = value
            Notify("已选择：" .. ghost.Name .. " [" .. ghost.CNName .. "]", 1)
        end
        updateEvidenceUI()
    end
})

--所属功能：幽灵筛选刷新
TabEvidence:Button({
    Title = "刷新幽灵筛选",
    Desc = "按照当前证据重新计算",
    Callback = function()
        LastGhostDropdownSignature = nil
        refreshGhostQuery()
    end
})

--所属功能：属性小窗
TabGhost:Toggle({
    Title = "属性小窗",
    Desc = "显示幽灵与玩家状态",
    Default = false,
    Callback = function(value)
        GhostInfoEnabled = value
        GhostInfoBackground.Visible = value
        PlayerInfoBackground.Visible = value
    end
})

--所属功能：猎杀提示
local HuntingNotifyEnabled = false
local HuntingConnections = {}
local HuntingGhost

local function disconnectHuntingConnections()
    for _, connection in ipairs(HuntingConnections) do
        pcall(function() connection:Disconnect() end)
    end
    table.clear(HuntingConnections)
    HuntingGhost = nil
end

local function watchGhostHunting(ghost)
    if not ghost or not ghost:IsA("Model") or HuntingGhost == ghost then return end
    disconnectHuntingConnections()
    HuntingGhost = ghost
    local connection = ghost:GetAttributeChangedSignal("Hunting"):Connect(function()
        if ScriptClosed or not HuntingNotifyEnabled then return end
        if ghost:GetAttribute("Hunting") == true then
            Notify("👻 幽灵开始猎杀", 1)
        else
            Notify("👻 猎杀结束", 1)
        end
    end)
    table.insert(HuntingConnections, connection)
end

TabGhost:Toggle({
    Title = "猎杀提示",
    Desc = "监听幽灵 Hunting 属性",
    Default = false,
    Callback = function(value)
        HuntingNotifyEnabled = value
        disconnectHuntingConnections()
        if value then
            local ghost = getGhostModel()
            if ghost then watchGhostHunting(ghost) end
        end
    end
})

--所属功能：ESP菜单
local ESPNames = {"幽灵", "玩家", "发电机", "指纹", "物品", "诅咒道具", "幽灵球", "蜡烛"}
local ESPMap = {
    ["幽灵"] = "Ghost", ["玩家"] = "Player", ["发电机"] = "Generator", ["指纹"] = "Fingerprint",
    ["物品"] = "Item", ["诅咒道具"] = "Cursed", ["幽灵球"] = "GhostOrb", ["蜡烛"] = "Candle"
}

TabGhost:Dropdown({
    Title = "透视",
    Desc = "可以同时开启多个透视",
    Values = ESPNames,
    Multi = true,
    AllowNone = true,
    Callback = function(values)
        local selected = {}
        if type(values) == "table" then
            for key, value in pairs(values) do
                if type(key) == "number" then selected[value] = true
                elseif type(key) == "string" and value == true then selected[key] = true end
            end
        elseif type(values) == "string" then
            selected[values] = true
        end
        for display, espType in pairs(ESPMap) do
            ESPEnabled[espType] = selected[display] == true
            if not ESPEnabled[espType] then clearESPType(espType) end
        end
        scanESP()
    end
})

--所属功能：物品
local ItemOptionsList = {}
local ItemDataMap = {}
local SelectedItemString

local function refreshItemsList()
    ItemOptionsList = {}
    ItemDataMap = {}
    local items = workspace:FindFirstChild("Items")
    if items then
        local duplicate = {}
        for _, item in ipairs(items:GetChildren()) do
            local itemName = item:GetAttribute("ItemName")
            if itemName and not CursedItemNames[itemName] then
                local name = translate(itemName)
                duplicate[name] = duplicate[name] or {}
                table.insert(duplicate[name], item)
            end
        end
        for name, list in pairs(duplicate) do
            if #list == 1 then
                table.insert(ItemOptionsList, name)
                ItemDataMap[name] = list[1]
            else
                for index, item in ipairs(list) do
                    local key = string.format("%s[%d]", name, index)
                    table.insert(ItemOptionsList, key)
                    ItemDataMap[key] = item
                end
            end
        end
    end
    if #ItemOptionsList == 0 then table.insert(ItemOptionsList, "无物品") end
    table.sort(ItemOptionsList)
    SelectedItemString = ItemOptionsList[1]
end

refreshItemsList()

local ItemDropdown = TabItems:Dropdown({
    Title = "选择物品",
    Values = ItemOptionsList,
    Value = ItemOptionsList[1],
    Callback = function(value)
        SelectedItemString = value
    end
})

local function unanchorItem(item)
    if not item then return end
    if item:IsA("BasePart") then item.Anchored = false end
    for _, child in ipairs(item:GetDescendants()) do
        if child:IsA("BasePart") then child.Anchored = false end
    end
end

TabItems:Button({
    Title = "刷新物品",
    Callback = function()
        refreshItemsList()
        pcall(function() ItemDropdown:Refresh(ItemOptionsList) end)
    end
})

TabItems:Button({
    Title = "物品到幽灵",
    Callback = function()
        local item = ItemDataMap[SelectedItemString]
        local ghost = getGhostModel()
        local root = ghost and getRoot(ghost)
        if item and root then
            local cf = root.CFrame
            if item:IsA("Model") then item:PivotTo(cf) elseif item:IsA("BasePart") then item.CFrame = cf end
            unanchorItem(item)
        end
    end
})

TabItems:Button({
    Title = "物品到身边",
    Callback = function()
        local item = ItemDataMap[SelectedItemString]
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if item and root then
            local cf = root.CFrame * CFrame.new(0, 0, -3)
            if item:IsA("Model") then item:PivotTo(cf) elseif item:IsA("BasePart") then item.CFrame = cf end
            unanchorItem(item)
        end
    end
})

--所属功能：玩家
local NoclipEnabled = false
local NoclipConnection
local InfiniteStaminaEnabled = false
local StaminaLoopConn
local BrightnessEnabled = false
local BrightnessConnection
local OriginalBrightness
local OriginalAmbient
local OriginalOutdoorAmbient
local OriginalGlobalShadows

--所属功能：无限体力
TabPlayer:Toggle({
    Title = "无限体力",
    Desc = "持续保持体力100",
    Default = false,
    Callback = function(value)
        InfiniteStaminaEnabled = value
        if StaminaLoopConn then StaminaLoopConn:Disconnect() StaminaLoopConn = nil end
        if value then
            StaminaLoopConn = RunService.Heartbeat:Connect(function()
                if ScriptClosed then return end
                pcall(function()
                    if LocalPlayer:GetAttribute("Stamina") ~= nil then LocalPlayer:SetAttribute("Stamina", 100) end
                    local valueObject = LocalPlayer:FindFirstChild("Stamina")
                    if valueObject and valueObject:IsA("ValueBase") then valueObject.Value = 100 end
                    local character = LocalPlayer.Character
                    if not character then return end
                    if character:GetAttribute("Stamina") ~= nil then character:SetAttribute("Stamina", 100) end
                    local characterValue = character:FindFirstChild("Stamina", true)
                    if characterValue and characterValue:IsA("ValueBase") then characterValue.Value = 100 end
                end)
            end)
        end
    end
})

--所属功能：穿墙
TabPlayer:Toggle({
    Title = "穿墙",
    Desc = "关闭后恢复碰撞",
    Default = false,
    Callback = function(value)
        NoclipEnabled = value
        if NoclipConnection then NoclipConnection:Disconnect() NoclipConnection = nil end
        if value then
            NoclipConnection = RunService.Stepped:Connect(function()
                if not NoclipEnabled or ScriptClosed or not LocalPlayer.Character then return end
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end)
        elseif LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
})

--所属功能：全局明亮
TabPlayer:Toggle({
    Title = "全局明亮",
    Desc = "提高环境亮度",
    Default = false,
    Callback = function(value)
        BrightnessEnabled = value
        if BrightnessConnection then BrightnessConnection:Disconnect() BrightnessConnection = nil end
        if value then
            OriginalBrightness = Lighting.Brightness
            OriginalAmbient = Lighting.Ambient
            OriginalOutdoorAmbient = Lighting.OutdoorAmbient
            OriginalGlobalShadows = Lighting.GlobalShadows
            local function apply()
                if ScriptClosed then return end
                Lighting.Brightness = 2
                Lighting.Ambient = Color3.new(1, 1, 1)
                Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
                Lighting.GlobalShadows = false
            end
            apply()
            BrightnessConnection = RunService.Heartbeat:Connect(apply)
        else
            if OriginalBrightness ~= nil then
                Lighting.Brightness = OriginalBrightness
                Lighting.Ambient = OriginalAmbient
                Lighting.OutdoorAmbient = OriginalOutdoorAmbient
                Lighting.GlobalShadows = OriginalGlobalShadows
            end
        end
    end
})

--所属功能：玩家速度
TabPlayer:Input({
    Title = "玩家速度",
    Desc = "-1恢复默认16",
    Placeholder = "-1",
    Numeric = true,
    Callback = function(value)
        local speed = tonumber(value)
        if speed == -1 or not speed then speed = 16 end
        pcall(function()
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then humanoid.WalkSpeed = speed end
        end)
    end
})

--所属功能：重置人物
TabPlayer:Button({
    Title = "重置人物",
    Callback = function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then humanoid.Health = 0 end
    end
})

--所属功能：房间
local RoomOptionsList = {}
local RawRoomNames = {}
local SelectedRoom

local function refreshRoomsList()
    RoomOptionsList = {}
    RawRoomNames = {}
    local map = workspace:FindFirstChild("Map")
    local rooms = map and map:FindFirstChild("Rooms")
    if rooms then
        for _, room in ipairs(rooms:GetChildren()) do
            local display = translate(room.Name)
            if not RawRoomNames[display] then
                table.insert(RoomOptionsList, display)
                RawRoomNames[display] = room.Name
            end
        end
    end
    if #RoomOptionsList == 0 then table.insert(RoomOptionsList, "无房间") end
    SelectedRoom = RoomOptionsList[1]
end

refreshRoomsList()

local RoomDropdown = TabPlayer:Dropdown({
    Title = "房间",
    Values = RoomOptionsList,
    Value = RoomOptionsList[1],
    Callback = function(value)
        SelectedRoom = value
    end
})

local function setPlayerCurrentRoom(roomName)
    if not roomName then return end
    pcall(function()
        if LocalPlayer:GetAttribute("CurrentRoom") ~= nil then LocalPlayer:SetAttribute("CurrentRoom", roomName) end
        local value = LocalPlayer:FindFirstChild("CurrentRoom")
        if value and value:IsA("ValueBase") then value.Value = roomName end
        if LocalPlayer.Character then
            local character = LocalPlayer.Character
            if character:GetAttribute("CurrentRoom") ~= nil then character:SetAttribute("CurrentRoom", roomName) end
            local characterValue = character:FindFirstChild("CurrentRoom", true)
            if characterValue and characterValue:IsA("ValueBase") then characterValue.Value = roomName end
        end
    end)
end

TabPlayer:Button({
    Title = "更改房间",
    Callback = function()
        local raw = RawRoomNames[SelectedRoom]
        if raw then setPlayerCurrentRoom(raw) end
    end
})

--所属功能：房间锁定
local RoomLockEnabled = false
local RoomLockConn
local LockedRoomRawName

TabPlayer:Toggle({
    Title = "锁定房间",
    Desc = "保持CurrentRoom不变",
    Default = false,
    Callback = function(value)
        RoomLockEnabled = value
        if RoomLockConn then RoomLockConn:Disconnect() RoomLockConn = nil end
        if value then
            LockedRoomRawName = getPlayerCurrentRoom()
            if LockedRoomRawName then
                RoomLockConn = RunService.Heartbeat:Connect(function()
                    if ScriptClosed then return end
                    if RoomLockEnabled and LockedRoomRawName and getPlayerCurrentRoom() ~= LockedRoomRawName then
                        setPlayerCurrentRoom(LockedRoomRawName)
                    end
                end)
            end
        else
            LockedRoomRawName = nil
        end
    end
})

TabPlayer:Button({
    Title = "刷新房间",
    Callback = function()
        refreshRoomsList()
        pcall(function() RoomDropdown:Refresh(RoomOptionsList) end)
    end
})

--所属功能：地图
TabMap:Button({
    Title = "删除所有门",
    Desc = "删除workspace.Doors",
    Callback = function()
        local doors = workspace:FindFirstChild("Doors")
        if doors then
            doors:Destroy()
            Notify("所有门已删除", 1)
        end
    end
})

--所属功能：玻璃次数
local function getGlassBreakCount(ghost)
    if not ghost then return "-" end
    local value = getAttributeAny(ghost, {"GlassBreaks", "GlassBreakCount", "GlassBroken", "BrokenGlass", "BrokenGlassCount", "ShatteredGlass", "GlassBreaksCount"})
    if typeof(value) == "number" then return tostring(math.max(0, math.floor(value))) end
    if typeof(value) == "boolean" then return value and "1" or "0" end
    return "-"
end

--所属功能：幽灵信息
local function updateMenuGhostInfo()
    if not GhostInfoEnabled or ScriptClosed then return end
    local ghost = getGhostModel()
    if not ghost then
        GhostInfoLabel.Text = "👻 幽灵信息\n幽灵：筛选\n年龄：-\n当前房间：-\n鬼房：-\n鬼房温度：-\n幽灵球：-\n性别：-\n打碎玻璃：-\n速度：-\n最高速度：-\n猎杀中：🟥"
        return
    end
    local age = getAttributeAny(ghost, {"Age", "GhostAge"}) or "-"
    local gender = translate(getAttributeAny(ghost, {"Gender", "Sex"}))
    local currentRoomRaw = getAttributeAny(ghost, {"CurrentRoom", "Room"})
    local currentRoom = currentRoomRaw and translate(currentRoomRaw) or "-"
    local ghostRoomRaw = getAttributeAny(ghost, {"GhostRoom", "FavoriteRoom"}) or currentRoomRaw
    local ghostRoom = ghostRoomRaw and translate(ghostRoomRaw) or "-"
    local ghostTemp = getRoomTemperatureByName(ghostRoomRaw)
    local orb = detectGhostOrb() and "🟩" or "🟥"
    local hunting = ghost:GetAttribute("Hunting") == true and "🟩" or "🟥"
    local glassBreaks = getGlassBreakCount(ghost)
    local speed = getGhostSpeed(ghost)
    local maxSpeed = getGhostMaxSpeed(ghost)
    local speedText = speed and string.format("%.1f", speed) or "-"
    local maxSpeedText = maxSpeed and string.format("%.1f", maxSpeed) or "-"
    local possible = getPossibleGhostList()
    local ghostName = #possible == 1 and possible[1].CNName or "筛选"
    GhostInfoLabel.Text = string.format(
        "👻 幽灵信息\n幽灵：%s\n年龄：%s\n当前房间：%s\n鬼房：%s\n鬼房温度：%s\n幽灵球：%s\n性别：%s\n打碎玻璃：%s次\n速度：%s\n最高速度：%s\n猎杀中：%s",
        ghostName, tostring(age), currentRoom, ghostRoom,
        ghostTemp and string.format("%.2f℃", ghostTemp) or "-",
        orb, gender, glassBreaks, speedText, maxSpeedText, hunting
    )
end

local function updatePlayerInfo()
    if not GhostInfoEnabled or ScriptClosed then return end
    local roomName = getPlayerCurrentRoom()
    local room = roomName and translate(roomName) or "无"
    local temperature = roomName and (getRoomTemperatureByName(roomName) or 0) or 0
    local energy = LocalPlayer:GetAttribute("Energy") or LocalPlayer:GetAttribute("Sanity") or 100
    PlayerStatsLabel.Text = string.format("玩家\n房间：%s\n温度：%.2f℃\n理智：%d%%", room, temperature, math.clamp(math.round(tonumber(energy) or 100), 0, 100))
end

local GhostInfoConnection = RunService.Heartbeat:Connect(function()
    if GhostInfoEnabled and not ScriptClosed then
        updateMenuGhostInfo()
        updatePlayerInfo()
    end
end)

--所属功能：EMF5检测
local function checkEMF5()
    local items = workspace:FindFirstChild("Items")
    if not items then return false end
    for _, item in ipairs(items:GetChildren()) do
        if item:GetAttribute("ItemName") == "EMF Reader" then
            local indicators = item:FindFirstChild("Indicators")
            local five = indicators and indicators:FindFirstChild("5")
            if five and five:IsA("BasePart") and five.Material == Enum.Material.Neon then return true end
        end
    end
    return false
end

--所属功能：指纹检测
local function checkFingerprints()
    local folder = workspace:FindFirstChild("Handprints")
    return folder and #folder:GetChildren() > 0 or false
end

--所属功能：冻结温度检测
local function checkFreezing()
    local map = workspace:FindFirstChild("Map")
    local rooms = map and map:FindFirstChild("Rooms")
    if not rooms then return false end
    local playerRoom = getPlayerCurrentRoom()
    if playerRoom then
        local temperature = getRoomTemperatureByName(playerRoom)
        if temperature and temperature < 0 then return true end
    end
    for _, room in ipairs(rooms:GetChildren()) do
        local temperature = room:GetAttribute("Temperature")
        if typeof(temperature) == "number" and temperature < 0 then return true end
    end
    return false
end

--所属功能：点阵检测
local function checkDots()
    local ghost = getGhostModel()
    return ghost and ghost:GetAttribute("LaserVisible") == true or false
end

--所属功能：鬼写字检测
local function checkGhostWriting()
    local items = workspace:FindFirstChild("Items")
    if not items then return false end
    for _, item in ipairs(items:GetChildren()) do
        if item:GetAttribute("ItemName") == "Spirit Book" then
            if item:GetAttribute("PhotoRewardType") == "Inscription" or item:GetAttribute("Disabled") == true then return true end
        end
    end
    return false
end

--所属功能：花枯萎检测
local function checkWitheredFlower()
    local items = workspace:FindFirstChild("Items")
    if not items then return false end
    for _, item in ipairs(items:GetChildren()) do
        if item:GetAttribute("ItemName") == "Flower Pot" then
            if item:GetAttribute("PhotoRewardType") == "WitheredFlowers" or item:GetAttribute("Disabled") == true then return true end
        end
    end
    return false
end

--所属功能：幽灵球初始化
local GhostOrbInitialized = false

local function initializeGhostOrb()
    if GhostOrbInitialized then return end
    local orbExists = detectGhostOrb()
    GhostOrbInitialized = true
    EvidenceConfirmed.Orb = true
    EvidenceState.Orb = orbExists
    Notify(orbExists and "幽灵球" or "幽灵球：🟥", 1)
    updateEvidenceUI()
    refreshGhostQuery()
end

--所属功能：点阵监听
local DotsConnection
local WatchedDotsGhost

local function disconnectDotsConnection()
    if DotsConnection then pcall(function() DotsConnection:Disconnect() end) DotsConnection = nil end
    WatchedDotsGhost = nil
end

local function watchGhostDots(ghost)
    if not ghost or not ghost:IsA("Model") then return end
    if WatchedDotsGhost == ghost then return end
    disconnectDotsConnection()
    WatchedDotsGhost = ghost
    local function checkVisible()
        if ghost:GetAttribute("LaserVisible") == true and not EvidenceState.Dots then
            EvidenceState.Dots = true
            EvidenceConfirmed.Dots = true
            Notify("幽灵点阵", 1)
            updateEvidenceUI()
            refreshGhostQuery()
        end
    end
    checkVisible()
    DotsConnection = ghost:GetAttributeChangedSignal("LaserVisible"):Connect(function()
        if not ScriptClosed then checkVisible() end
    end)
end

--所属功能：幽灵出现监听
local GhostWatcher = workspace.DescendantAdded:Connect(function(object)
    if ScriptClosed then return end
    if object.Name == "Ghost" and object:IsA("Model") then
        task.defer(function()
            if ScriptClosed then return end
            watchGhostDots(object)
            if HuntingNotifyEnabled then watchGhostHunting(object) end
        end)
    end
end)

--所属功能：证据循环
task.spawn(function()
    while not ScriptClosed do
        task.wait(0.5)
        if ScriptClosed then break end
        pcall(function()
            if not EvidenceState.EMF5 and checkEMF5() then
                EvidenceState.EMF5 = true
                EvidenceConfirmed.EMF5 = true
                Notify("EMF5", 1)
            end
            if not EvidenceState.Finger and checkFingerprints() then
                EvidenceState.Finger = true
                EvidenceConfirmed.Finger = true
                Notify("指纹", 1)
            end
            if not GhostOrbInitialized then initializeGhostOrb() end
            if not EvidenceState.Temp and checkFreezing() then
                EvidenceState.Temp = true
                EvidenceConfirmed.Temp = true
                Notify("冻结温度", 1)
            end
            if not EvidenceState.Writing and checkGhostWriting() then
                EvidenceState.Writing = true
                EvidenceConfirmed.Writing = true
                Notify("鬼写字", 1)
            end
            if not EvidenceState.Flower and checkWitheredFlower() then
                EvidenceState.Flower = true
                EvidenceConfirmed.Flower = true
                Notify("花枯萎", 1)
            end
            local ghost = getGhostModel()
            if ghost then
                watchGhostDots(ghost)
                if HuntingNotifyEnabled then watchGhostHunting(ghost) end
            end
            updateEvidenceUI()
            refreshGhostQuery()
        end)
    end
end)

--所属功能：启动初始化
task.defer(function()
    task.wait(0.5)
    if ScriptClosed then return end
    initializeGhostOrb()
    local ghost = getGhostModel()
    if ghost then
        watchGhostDots(ghost)
        if HuntingNotifyEnabled then watchGhostHunting(ghost) end
    end
    updateEvidenceUI()
    refreshGhostQuery()
end)

--所属功能：设置
local cleanupScript

TabSettings:Button({
    Title = "关闭脚本",
    Desc = "清理全部功能与UI",
    Callback = function()
        if cleanupScript then cleanupScript() end
    end
})

--所属功能：脚本关闭
cleanupScript = function()
    if ScriptClosed then return end
    ScriptClosed = true

    for object in pairs(ESPStorage) do removeESP(object) end
    for object in pairs(GhostTransparency) do restoreGhostTransparency(object) end

    if ESPConnection then pcall(function() ESPConnection:Disconnect() end) ESPConnection = nil end

    HuntingNotifyEnabled = false
    disconnectHuntingConnections()
    disconnectDotsConnection()

    if GhostWatcher then pcall(function() GhostWatcher:Disconnect() end) GhostWatcher = nil end

    GhostInfoEnabled = false
    if GhostInfoConnection then pcall(function() GhostInfoConnection:Disconnect() end) GhostInfoConnection = nil end

    InfiniteStaminaEnabled = false
    if StaminaLoopConn then StaminaLoopConn:Disconnect() StaminaLoopConn = nil end

    NoclipEnabled = false
    if NoclipConnection then NoclipConnection:Disconnect() NoclipConnection = nil end
    if LocalPlayer.Character then
        pcall(function()
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end)
    end

    BrightnessEnabled = false
    if BrightnessConnection then BrightnessConnection:Disconnect() BrightnessConnection = nil end
    if OriginalBrightness ~= nil then
        pcall(function()
            Lighting.Brightness = OriginalBrightness
            Lighting.Ambient = OriginalAmbient
            Lighting.OutdoorAmbient = OriginalOutdoorAmbient
            Lighting.GlobalShadows = OriginalGlobalShadows
        end)
    end

    RoomLockEnabled = false
    LockedRoomRawName = nil
    if RoomLockConn then RoomLockConn:Disconnect() RoomLockConn = nil end

    pcall(function() if SideGui then SideGui:Destroy() end end)
    pcall(function() if Window then if Window.Destroy then Window:Destroy() elseif Window.Close then Window:Close() end end end)
    pcall(function() getrenv()[ScriptRunningFlag] = nil end)
end

--所属功能：最终初始化
updateEvidenceUI()
refreshGhostQuery()
Notify("NY恶魔学加载完成", 1)