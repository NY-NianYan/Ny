-- 恶魔学
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- 脚本：防重复执行

local ScriptRunningFlag = "_SiScript_IsRunning"

if getrenv()[ScriptRunningFlag] then
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://87437544236708"
        sound.Volume = 0.5
        sound.Parent = SoundService
        sound:Play()
        Debris:AddItem(sound, 3)
    end)
    return
end

getrenv()[ScriptRunningFlag] = true

local ScriptClosed = false

local function playNotifySound()
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://87437544236708"
        sound.Volume = 0.5
        sound.Parent = SoundService
        sound:Play()
        Debris:AddItem(sound, 3)
    end)
end

local originalNotify = Library.Notify

Library.Notify = function(self, text, duration)
    playNotifySound()
    return originalNotify(self, text, 1)
end

-- 主界面：俟脚本

local Window = Library:CreateWindow({
    Title = "NY恶魔学",
    Footer = "测试版V0.1",
    ToggleKeybind = Enum.KeyCode.C,
    Center = true,
    AutoShow = true,
    ShowCustomCursor = false,
    Size = UDim2.new(0, 600, 0, 420),
})

local TabGhost = Window:AddTab("幽灵区", "user-round-pen", "幽灵功能")
local TabEvidence = Window:AddTab("证据", "search", "证据检测")
local TabItems = Window:AddTab("物品", "box", "物品管理")
local TabPlayer = Window:AddTab("玩家", "eye", "玩家功能")
local TabMap = Window:AddTab("地图", "map", "地图功能")
local TabSettings = Window:AddTab("设置", "settings", "存档设置")

-- 翻译：名称

local TranslationMap = {
    ["Male"] = "男",
    ["Female"] = "女",

    ["Living Room"] = "客厅",
    ["Kitchen"] = "厨房",
    ["Bedroom"] = "卧室",
    ["Master Bedroom"] = "主卧室",
    ["Kids Bedroom"] = "儿童卧室",
    ["Bathroom"] = "洗手间",
    ["Master Bathroom"] = "主客卫",
    ["Basement"] = "地下室",
    ["Garage"] = "车库",
    ["Hallway"] = "走廊",
    ["Attic"] = "阁楼",
    ["Foyer"] = "门厅",
    ["Dining Room"] = "餐厅",
    ["Library"] = "图书馆",
    ["Study"] = "书房",
    ["Laundry Room"] = "洗衣房",
    ["Storage Room"] = "储藏室",
    ["Corridor"] = "通道",
    ["Closet"] = "壁橱",
    ["Cold Storage Room"] = "冷藏室",
    ["Cleaning Room"] = "洁净室",
    ["Office"] = "办公室",
    ["Stairway"] = "楼梯间",
    ["Base Camp"] = "基地营地",
    ["Service Station"] = "服务站",
    ["Main Store"] = "主商店",
        ["Master Closet"] = "主卧衣帽间",
    ["Blue Bedroom"] = "蓝色卧室",
    ["Pink Bedroom"] = "粉色卧室",
    ["Pantry"] = "食品储藏室",
    ["F2 Dining Area"] = "二楼用餐区",
    ["Scullery"] = "配膳洗涤间",
    ["Staff Room"] = "员工休息室",
    ["Coffee Bar"] = "咖啡吧台",
    ["Restroom 2"] = "二号卫生间",
    ["Restroom 1"] = "一号卫生间",
    ["Meeting Room 2"] = "二号会议室",
    ["Meeting Room 1"] = "一号会议室",
    ["F1 Dining Area"] = "一楼用餐区",
    ["Alley"] = "小巷/过道",
    ["Lounge"] = "休闲厅",
    ["Staff Bathroom"] = "员工浴室",
    ["F2 Hallway"] = "二楼走廊",
    ["Closet Room"] = "储藏衣帽间",
    ["F1 Hallway"] = "一楼走廊",
    ["Stairs"] = "楼梯间",
    ["Laundry"] = "洗衣房",
    ["Cell Block A"] = "A监区",
    ["Block A Guard Room F1"] = "A监区一楼看守室",
    ["Block B Hallway"] = "B监区走廊",
    ["Block A Checkpoint"] = "A监区安检检查站",
    ["Classroom"] = "教室",
    ["Block A Hallway"] = "A监区走廊",
    ["Program Room"] = "活动活动室",
    ["Showers"] = "淋浴间",
    ["Block A Stairwell"] = "A监区楼梯井",
    ["Services Hallway"] = "后勤通道",
    ["Mail Room"] = "邮件收发室",
    ["Cell Block B"] = "B监区",
    ["Block B Checkpoint"] = "B监区安检检查站",
    ["Cafeteria"] = "食堂",
    ["Staff Restroom"] = "员工洗手间",
    ["Guards Office"] = "狱警办公室",
    ["Armory"] = "军械库",
    ["Infirmary"] = "医务室",
    ["Admin Control Room"] = "行政中控室",
    ["Workshop"] = "工坊/劳作间",
    ["Block B Guard Room F1"] = "B监区一楼看守室",
    ["Block B Yard"] = "B监区放风场",
    ["Block A Guard Room F2"] = "A监区二楼看守室",
    ["Services Control Room"] = "后勤中控室",
    ["Services Checkpoint"] = "后勤检查站",
    ["Utility Room"] = "设备杂物间",
    ["Lobby"] = "大厅前厅",
    ["Visitation Room"] = "探视会见室",
    ["Prison Intake"] = "监狱收押登记处",
    ["Cell A01"] = "A01监舍",
    ["Cell A06"] = "A06监舍",
    ["Cell A10"] = "A10监舍",
    ["Cell A15"] = "A15监舍",
    ["Cell A17"] = "A17监舍",
    ["Cell A19"] = "A19监舍",
    ["Cell A23"] = "A23监舍",
    ["Cell B02"] = "B02监舍",
    ["Cell B06"] = "B06监舍",
    ["Cell B10"] = "B10监舍",
    ["Block A Hallway F2"] = "A监区二楼走廊",
    ["Holding Cell"] = "临时拘留室",
    ["Admin Restroom"] = "行政办公区卫生间",


    ["Blacklight"] = "紫外线手电",
    ["Cross"] = "十字架",
    ["EMF Reader"] = "EMF检测仪",
    ["Flowers"] = "鲜花",
    ["Holy Oil"] = "圣油",
    ["LIDAR Scanner"] = "激光雷达扫描仪",
    ["Laser Proj."] = "点阵投影仪",
    ["Laser Projector"] = "点阵投影仪",
    ["Photo Camera"] = "数码相机",
    ["Plushie"] = "玩偶",
    ["Spirit Book"] = "通灵书",
    ["Spirit Box"] = "通灵盒",
    ["Thermometer"] = "温度计",
    ["Video Camera"] = "摄像机",
    ["Flower Pot"] = "花盆",
    ["Energy Drink"] = "能量饮料",
    ["Flashlight"] = "手电筒",
    ["Salt Canister"] = "盐罐",
    ["Fortune Coin"] = "好运币",

    ["Haunted Mirror"] = "鬼镜",
    ["Music box"] = "音乐盒",
    ["Magnifying Glass"] = "放大镜",
    ["Summoning Circle"] = "召唤阵",
    ["Umbra Board"] = "通灵板",
}

local function translate(text)
    if text == nil then
        return "未知"
    end

    return TranslationMap[tostring(text)] or tostring(text)
end

local CursedItemNames = {
    ["Haunted Mirror"] = true,
    ["Music box"] = true,
    ["Music Box"] = true,
    ["Magnifying Glass"] = true,
    ["Umbra Board"] = true,
    ["Summoning Circle"] = true,
}

-- 通用：基础函数

local function getRoot(model)
    if not model then
        return nil
    end

    if model:IsA("BasePart") then
        return model
    end

    return model:FindFirstChild("HumanoidRootPart")
        or model.PrimaryPart
        or model:FindFirstChildWhichIsA("BasePart", true)
end

local function getDistance(position)
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root or not position then
        return "无"
    end

    return string.format("%dm", math.floor((root.Position - position).Magnitude))
end

local function getAttributeAny(instance, names)
    if not instance then
        return nil
    end

    for _, name in ipairs(names) do
        local value = instance:GetAttribute(name)

        if value ~= nil then
            return value
        end
    end

    return nil
end

local function getPlayerCurrentRoom()
    local value =
        LocalPlayer:GetAttribute("CurrentRoom")
        or (LocalPlayer:FindFirstChild("CurrentRoom") and LocalPlayer.CurrentRoom.Value)

    if not value and LocalPlayer.Character then
        value = LocalPlayer.Character:GetAttribute("CurrentRoom")

        local obj = LocalPlayer.Character:FindFirstChild("CurrentRoom", true)

        if obj and obj:IsA("ValueBase") then
            value = obj.Value
        end
    end

    return value
end

local function getGhostModel()
    local ghost = workspace:FindFirstChild("Ghost")

    if ghost and ghost:IsA("Model") then
        return ghost
    end

    local recursive = workspace:FindFirstChild("Ghost", true)

    if recursive and recursive:IsA("Model") then
        return recursive
    end

    return nil
end

local function getRoomInstance(roomName)
    if not roomName then
        return nil
    end

    local map = workspace:FindFirstChild("Map")
    local rooms = map and map:FindFirstChild("Rooms")

    if not rooms then
        return nil
    end

    return rooms:FindFirstChild(tostring(roomName))
end

local function getRoomTemperatureByName(roomName)
    local room = getRoomInstance(roomName)

    if not room then
        return nil
    end

    local temp = room:GetAttribute("Temperature")

    if typeof(temp) == "number" then
        return temp
    end

    local value = room:FindFirstChild("Temperature", true)

    if value and value:IsA("NumberValue") then
        return value.Value
    end

    return nil
end

local function getGhostRoomName(ghost)
    if not ghost then
        return getPlayerCurrentRoom()
    end

    return getAttributeAny(ghost, {
        "GhostRoom",
        "FavoriteRoom",
        "CurrentRoom",
        "Room",
    }) or getPlayerCurrentRoom()
end

local function detectGhostOrb()
    return workspace:FindFirstChild("GhostOrb", true) ~= nil
end

-- ESP：类型

local ESPEnabled = {
    Ghost = false,
    Player = false,
    Generator = false,
    Fingerprint = false,
    Item = false,
    Cursed = false,
}

local ESPStorage = {}

local GhostTransparency = {}

local ESPScanConnection
local HighlightRefreshRunning = true
local EvidenceLoopRunning = true

local ESPColors = {
    Ghost = Color3.fromRGB(138, 43, 226),
    Player = Color3.fromRGB(0, 255, 80),
    Generator = Color3.fromRGB(255, 230, 0),
    Fingerprint = Color3.fromRGB(0, 255, 80),
    Item = Color3.fromRGB(0, 255, 255),
    Cursed = Color3.fromRGB(255, 150, 0),
}

local function createHighlight(object, espType)
    if not object or not object:IsDescendantOf(workspace) then
        return nil
    end

    local old = object:FindFirstChild("SiESPHighlight")

    if old then
        old:Destroy()
    end

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

        if player then
            return player.DisplayName or player.Name
        end
    end

    if espType == "Item" or espType == "Cursed" then
        local itemName = object:GetAttribute("ItemName")

        if itemName then
            return translate(itemName)
        end
    end

    if espType == "Generator" then
        return "发电机"
    end

    if espType == "Fingerprint" then
        return "指纹"
    end

    if espType == "Ghost" then
        return "幽灵"
    end

    return object.Name
end

local function createESP(object, espType)
    if not object or not object:IsDescendantOf(workspace) then
        return
    end

    if ESPStorage[object] then
        if ESPStorage[object].type == espType then
            return
        end

        local old = ESPStorage[object]

        pcall(function()
            old.highlight:Destroy()
            old.billboard:Destroy()
            old.connection:Disconnect()
        end)

        ESPStorage[object] = nil
    end

    local root = getRoot(object)

    if not root then
        return
    end

    local highlight = createHighlight(object, espType)

    if not highlight then
        return
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "SiESPInfo"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 220, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Adornee = root
    billboard.Parent = root

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = ESPColors[espType]
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.Text = getDisplayName(object, espType) .. "\n[" .. getDistance(root.Position) .. "]"
    label.Parent = billboard

    local connection = RunService.Heartbeat:Connect(function()
        if ScriptClosed then
            return
        end

        if not ESPEnabled[espType]
            or not object:IsDescendantOf(workspace)
            or not root:IsDescendantOf(workspace) then
            return
        end

        label.Text =
            getDisplayName(object, espType)
            .. "\n[" .. getDistance(root.Position) .. "]"
    end)

    ESPStorage[object] = {
        type = espType,
        highlight = highlight,
        billboard = billboard,
        connection = connection,
    }
end

local function restoreGhostTransparency(object)
    local saved = GhostTransparency[object]

    if not saved then
        return
    end

    for instance, info in pairs(saved) do
        if instance and instance.Parent then
            pcall(function()
                if info.Transparency ~= nil then
                    instance.Transparency = info.Transparency
                end

                if info.Material ~= nil and instance:IsA("BasePart") then
                    instance.Material = info.Material
                end
            end)
        end
    end

    GhostTransparency[object] = nil
end

local function createGhostESP(object)
    if not object or not object:IsDescendantOf(workspace) then
        return
    end

    if ESPStorage[object] then
        return
    end

    if not GhostTransparency[object] then
        GhostTransparency[object] = {}

        for _, part in ipairs(object:GetDescendants()) do
            if part:IsA("BasePart") then
                GhostTransparency[object][part] = {
                    Transparency = part.Transparency,
                    Material = part.Material,
                }

                part.Transparency = 0
                part.Material = Enum.Material.SmoothPlastic

            elseif part:IsA("Decal") or part:IsA("Texture") then
                GhostTransparency[object][part] = {
                    Transparency = part.Transparency,
                }

                part.Transparency = 0
            end
        end
    else
        for part in pairs(GhostTransparency[object]) do
            if part and part.Parent then
                pcall(function()
                    part.Transparency = 0

                    if part:IsA("BasePart") then
                        part.Material = Enum.Material.SmoothPlastic
                    end
                end)
            end
        end
    end

    local root = getRoot(object)

    if not root then
        return
    end

    local highlight = createHighlight(object, "Ghost")

    if not highlight then
        return
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "SiGhostInfo"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 320, 0, 34)
    billboard.StudsOffset = Vector3.new(0, 3.2, 0)
    billboard.Adornee = root
    billboard.Parent = root

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = ESPColors.Ghost
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSans
    label.TextSize = 13
    label.Parent = billboard

    local connection = RunService.Heartbeat:Connect(function()
        if ScriptClosed then
            return
        end

        if not ESPEnabled.Ghost
            or not object:IsDescendantOf(workspace)
            or not root:IsDescendantOf(workspace) then
            return
        end

        local room = translate(getGhostRoomName(object))
        local age = getAttributeAny(object, {"Age", "GhostAge"}) or "未知"
        local gender = translate(getAttributeAny(object, {"Gender", "Sex"}))
        local orb = detectGhostOrb() and "✔" or "❌"

        label.Text = string.format(
            "幽灵 | 房间:%s | 年龄:%s | 性别:%s | 球:%s | [%s]",
            room,
            age,
            gender,
            orb,
            getDistance(root.Position)
        )
    end)

    ESPStorage[object] = {
        type = "Ghost",
        highlight = highlight,
        billboard = billboard,
        connection = connection,
    }
end

local function removeESP(object)
    local data = ESPStorage[object]

    if data then
        pcall(function()
            if data.highlight then
                data.highlight:Destroy()
            end

            if data.billboard then
                data.billboard:Destroy()
            end

            if data.connection then
                data.connection:Disconnect()
            end
        end)

        if data.type == "Ghost" then
            restoreGhostTransparency(object)
        end

        ESPStorage[object] = nil
    end
end

local function clearESPType(espType)
    for object, data in pairs(ESPStorage) do
        if data.type == espType then
            removeESP(object)
        end
    end
end

local function collectObjects(espType)
    local result = {}

    if espType == "Ghost" then

        local ghost = getGhostModel()

        if ghost then
            table.insert(result, ghost)
        end

    elseif espType == "Player" then

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                table.insert(result, player.Character)
            end
        end

    elseif espType == "Generator" then

        local map = workspace:FindFirstChild("Map")
        local fuseBox = map and map:FindFirstChild("FuseBox")

        if fuseBox then
            if fuseBox:IsA("Model") or fuseBox:IsA("BasePart") then
                table.insert(result, fuseBox)
            else
                for _, child in ipairs(fuseBox:GetChildren()) do
                    table.insert(result, child)
                end
            end
        end

    elseif espType == "Fingerprint" then

        local handprints = workspace:FindFirstChild("Handprints")

        if handprints then
            for _, child in ipairs(handprints:GetChildren()) do
                table.insert(result, child)
            end
        end

    elseif espType == "Item" then

        local items = workspace:FindFirstChild("Items")

        if items then
            for _, child in ipairs(items:GetChildren()) do
                local itemName = child:GetAttribute("ItemName")

                if itemName and not CursedItemNames[itemName] then
                    table.insert(result, child)
                end
            end
        end

    elseif espType == "Cursed" then

        local items = workspace:FindFirstChild("Items")

        if items then
            for _, child in ipairs(items:GetChildren()) do
                local itemName = child:GetAttribute("ItemName")

                if itemName and CursedItemNames[itemName] then
                    table.insert(result, child)
                end
            end
        end

        local holder = workspace:FindFirstChild("CursedPossessionHolder")

        if holder and #holder:GetChildren() > 0 then

            for _, child in ipairs(holder:GetChildren()) do
                local itemName = child:GetAttribute("ItemName")

                if itemName and CursedItemNames[itemName] then
                    table.insert(result, child)
                end

                if child.Name == "Summoning Circle" then
                    if not table.find(result, child) then
                        table.insert(result, child)
                    end
                end
            end

            local circle = holder:FindFirstChild("Summoning Circle", true)

            if circle and not table.find(result, circle) then
                table.insert(result, circle)
            end
        end
    end

    return result
end

local function scanESP()
    if ScriptClosed then
        return
    end

    for espType, enabled in pairs(ESPEnabled) do
        if enabled then
            local found = {}

            for _, object in ipairs(collectObjects(espType)) do
                found[object] = true

                if espType == "Ghost" then
                    createGhostESP(object)
                else
                    createESP(object, espType)
                end
            end

            for object, data in pairs(ESPStorage) do
                if data.type == espType and not found[object] then
                    removeESP(object)
                end
            end
        end
    end
end

local function refreshHighlights()
    if ScriptClosed then
        return
    end

    for object, data in pairs(ESPStorage) do
        if data.highlight then
            pcall(function()
                data.highlight:Destroy()
            end)

            if object:IsDescendantOf(workspace)
                and ESPEnabled[data.type] then

                data.highlight = createHighlight(object, data.type)
            end
        end
    end
end

ESPScanConnection = RunService.Heartbeat:Connect(scanESP)

task.spawn(function()
    while HighlightRefreshRunning and not ScriptClosed do
        task.wait(1)

        if HighlightRefreshRunning and not ScriptClosed then
            refreshHighlights()
        end
    end
end)

local function setESPType(espType, state)
    ESPEnabled[espType] = state

    if not state then
        clearESPType(espType)
    else
        scanESP()
    end
end

-- 幽灵区：属性信息

local SideGui = Instance.new("ScreenGui")
SideGui.Name = "SiSideStats"
SideGui.ResetOnSpawn = false
SideGui.IgnoreGuiInset = true
SideGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SideGui.Parent = CoreGui

local SideContainer = Instance.new("Frame")
SideContainer.Name = "Container"
SideContainer.Size = UDim2.new(0, 210, 0, 150)
SideContainer.Position = UDim2.new(1, -220, 0, 10)
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
    background.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    background.BackgroundTransparency = 0.24
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
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = textColor
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextStrokeTransparency = 0.2
    label.Font = Enum.Font.Code
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Right
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.Parent = background

    return background, label
end

local GhostInfoBackground, GhostInfoLabel = createRoundedInfoBox(
    "GhostInfo",
    UDim2.new(0, 210, 0, 85),
    ESPColors.Ghost
)

local PlayerInfoBackground, PlayerStatsLabel = createRoundedInfoBox(
    "PlayerInfo",
    UDim2.new(0, 210, 0, 70),
    Color3.new(1, 1, 1)
)

GhostInfoBackground.LayoutOrder = 1
PlayerInfoBackground.LayoutOrder = 2

GhostInfoBackground.Visible = false
PlayerInfoBackground.Visible = false

local GhostInfoEnabled = false
local MaxGhostSpeed = 0
local GhostInfoUpdateConn

local function updateMenuGhostInfo()
    if not GhostInfoLabel or not GhostInfoEnabled or ScriptClosed then
        return
    end

    local ghost = getGhostModel()

    if not ghost then
        GhostInfoLabel.Text =
            "👻 幽灵信息\n"
            .. "----------------------------------\n"
            .. "年龄：-\n"
            .. "当前房间：-\n"
            .. "鬼房：-\n"
            .. "鬼房温度：-\n"
            .. "幽灵球：-\n"
            .. "性别：-"

        return
    end

    local root = getRoot(ghost)

    local age = getAttributeAny(ghost, {
        "Age",
        "GhostAge",
    }) or "-"

    local gender = translate(getAttributeAny(ghost, {
        "Gender",
        "Sex",
    }))

    local currentRoomRaw = getAttributeAny(ghost, {
        "CurrentRoom",
        "Room",
    })

    local currentRoom =
        currentRoomRaw
        and translate(currentRoomRaw)
        or "-"

    local ghostRoomRaw = getAttributeAny(ghost, {
        "GhostRoom",
        "FavoriteRoom",
    }) or currentRoomRaw

    local ghostRoom =
        ghostRoomRaw
        and translate(ghostRoomRaw)
        or "-"

    local ghostTemp = getRoomTemperatureByName(ghostRoomRaw)

    local orb = detectGhostOrb() and "✔" or "❌"

    local speed = 0

    if root then
        speed = root.AssemblyLinearVelocity.Magnitude

        if speed < 0.1 then
            speed = 0
        end

        if speed > MaxGhostSpeed then
            MaxGhostSpeed = speed
        end
    end

    GhostInfoLabel.Text = string.format(
        "👻 幽灵信息\n"
        .. "----------------------------------\n"
        .. "年龄：%s\n"
        .. "当前房间：%s\n"
        .. "鬼房：%s\n"
        .. "鬼房温度：%s\n"
        .. "幽灵球：%s\n"
        .. "性别：%s",
        tostring(age),
        currentRoom,
        ghostRoom,
        ghostTemp and string.format("%.2f℃", ghostTemp) or "-",
        orb,
        gender
    )
end

local function getRoomTemperature()
    local roomName = getPlayerCurrentRoom()

    if not roomName then
        return 0, "无"
    end

    local temperature = getRoomTemperatureByName(roomName)

    return temperature or 0, translate(roomName)
end

local function updatePlayerInfo()
    if not GhostInfoEnabled or ScriptClosed then
        return
    end

    local temperature, room = getRoomTemperature()

    local energy = LocalPlayer:GetAttribute("Energy")

    if energy == nil then
        energy = LocalPlayer:GetAttribute("Sanity")
    end

    if energy == nil then
        energy = 100
    end

    PlayerStatsLabel.Text = string.format(
        "玩家信息\n房间：%s\n温度：%.2f℃\n理智：%d%%",
        room,
        temperature,
        math.clamp(math.round(tonumber(energy) or 100), 0, 100)
    )
end

GhostInfoUpdateConn = RunService.Heartbeat:Connect(function()
    if GhostInfoEnabled and not ScriptClosed then
        updateMenuGhostInfo()
        updatePlayerInfo()
    end
end)

local GroupGhost = TabGhost:AddLeftGroupbox("幽灵")

GroupGhost:AddToggle("GhostStatsWindow", {
    Text = "属性信息小窗",
    Default = false,

    Callback = function(v)
        GhostInfoEnabled = v

        GhostInfoBackground.Visible = v
        PlayerInfoBackground.Visible = v
    end,
})

-- 幽灵区：透视

local GroupESP = TabGhost:AddRightGroupbox("透视")

local ESPSelectorValues = {
    "幽灵",
    "玩家",
    "发电机",
    "指纹",
    "物品",
    "诅咒道具",
}

local ESPNameToType = {
    ["幽灵"] = "Ghost",
    ["玩家"] = "Player",
    ["发电机"] = "Generator",
    ["指纹"] = "Fingerprint",
    ["物品"] = "Item",
    ["诅咒道具"] = "Cursed",
}

GroupESP:AddDropdown("ESPSelector", {
    Values = ESPSelectorValues,
    Default = {},
    Multi = true,
    Text = "透视",

    Callback = function(values)
        local selected = {}

        if type(values) == "table" then
            for _, value in ipairs(values) do
                selected[value] = true
            end

            for value, enabled in pairs(values) do
                if type(value) == "string" and enabled == true then
                    selected[value] = true
                end
            end

        elseif type(values) == "string" then
            selected[values] = true
        end

        for displayName, espType in pairs(ESPNameToType) do
            setESPType(
                espType,
                selected[displayName] == true
            )
        end
    end,
})

-- 证据页：证据检测

local GroupEvidence = TabEvidence:AddLeftGroupbox("证据")

local EvidenceState = {
    EMF5 = false,
    Finger = false,
    Orb = false,
    Temp = false,
    Writing = false,
    Flower = false,
    Dots = false,
    Box = false,
}

local LabelEMF = GroupEvidence:AddLabel("EMF5级：❌")
local LabelFinger = GroupEvidence:AddLabel("指纹：❌")
local LabelOrb = GroupEvidence:AddLabel("幽灵球：❌")
local LabelTemp = GroupEvidence:AddLabel("冻结温度：❌")
local LabelWriting = GroupEvidence:AddLabel("鬼写字：❌")
local LabelFlower = GroupEvidence:AddLabel("花枯萎：❌")
local LabelDots = GroupEvidence:AddLabel("幽灵点阵：❌")
local LabelBox = GroupEvidence:AddLabel("灵魂盒子：❌")

local Ghosts = {
    {
        Name = "Aswang",
        CNName = "阿斯旺",
        PosStr = "[排:1 列:1][页:1]",
        Evidences = {"EMF5", "鬼写字", "花枯萎"},
        Features = "每击杀一次移速变快；穿过盐会减速。",
    },
    {
        Name = "Banshee",
        CNName = "班希女巫",
        PosStr = "[排:1 列:2][页:1]",
        Evidences = {"冻结温度", "幽灵球", "指纹"},
        Features = "更容易打碎玻璃；狩猎时会发出独特哭声。",
    },
    {
        Name = "Demon",
        CNName = "恶魔",
        PosStr = "[排:1 列:3][页:1]",
        Evidences = {"EMF5", "冻结温度", "指纹"},
        Features = "极其危险、频繁狩猎；十字架对它效果更强。",
    },
    {
        Name = "Dullahan",
        CNName = "无头骑士",
        PosStr = "[排:2 列:1][页:1]",
        Evidences = {"冻结温度", "幽灵点阵", "花枯萎"},
        Features = "照片中无头；盯着目标时间越久，移动速度越快。",
    },
    {
        Name = "Dybbuk",
        CNName = "迪布布克",
        PosStr = "[排:2 列:2][页:1]",
        Evidences = {"冻结温度", "指纹", "花枯萎"},
        Features = "可以投掷尸体；第一次播放音乐盒会被定住。",
    },
    {
        Name = "Entity",
        CNName = "实体",
        PosStr = "[排:2 列:3][页:1]",
        Evidences = {"指纹", "幽灵点阵", "灵魂盒子"},
        Features = "可以传送；投掷物品前会先传送物体。",
    },
    {
        Name = "Ghoul",
        CNName = "食尸鬼",
        PosStr = "[排:3 列:1][页:1]",
        Evidences = {"冻结温度", "幽灵球", "灵魂盒子"},
        Features = "听到人声容易发怒；无法干扰电子设备。",
    },
    {
        Name = "Keres",
        CNName = "克雷斯",
        PosStr = "[排:3 列:2][页:1]",
        Evidences = {"指纹", "灵魂盒子", "花枯萎"},
        Features = "优先锁定能量最低的玩家；击杀玩家后自身持续减速。",
    },
    {
        Name = "Leviathan",
        CNName = "巨兽利维坦",
        PosStr = "[排:3 列:3][页:1]",
        Evidences = {"鬼写字", "指纹", "幽灵球"},
        Features = "非狩猎状态也能闪烁、关闭灯光设备；会淹没周边电力。",
    },
    {
        Name = "Nightmare",
        CNName = "噩梦",
        PosStr = "[排:4 列:1][页:1]",
        Evidences = {"EMF5", "幽灵球", "灵魂盒子"},
        Features = "制造幻觉；更常在黑暗中狩猎。",
    },
    {
        Name = "Oni",
        CNName = "日本恶鬼",
        PosStr = "[排:4 列:2][页:1]",
        Evidences = {"冻结温度", "幽灵点阵", "灵魂盒子"},
        Features = "狩猎时会冲刺；现身频率远高于其他幽灵。",
    },
    {
        Name = "Phantom",
        CNName = "幻影",
        PosStr = "[排:4 列:3][页:1]",
        Evidences = {"EMF5", "指纹", "幽灵球"},
        Features = "追击模式闪烁慢，隐身状态移速很快；情绪激动会变得凶猛。",
    },
    {
        Name = "Ravager",
        CNName = "掠夺者",
        PosStr = "[排:5 列:1][页:1]",
        Evidences = {"EMF5", "鬼写字", "灵魂盒子"},
        Features = "可以同时投掷多个物品；所有互动行为都会触发EMF5。",
    },
    {
        Name = "Revenant",
        CNName = "复仇者",
        PosStr = "[排:5 列:2][页:1]",
        Evidences = {"EMF5", "冻结温度", "鬼写字"},
        Features = "狩猎冷却时间很短；击杀人类后会进入休息状态。",
    },
    {
        Name = "Shadow",
        CNName = "阴影",
        PosStr = "[排:5 列:3][页:1]",
        Evidences = {"EMF5", "鬼写字", "幽灵点阵"},
        Features = "几乎不改变室温；明亮房间里活动频率大幅降低。",
    },
    {
        Name = "Siren",
        CNName = "海妖",
        PosStr = "[排:6 列:1][页:1]",
        Evidences = {"EMF5", "灵魂盒子", "花枯萎"},
        Features = "灵魂盒仅以女性语调回答；狩猎追逐时自身移速降低。",
    },
    {
        Name = "Skinwalker",
        CNName = "皮行者",
        PosStr = "[排:6 列:2][页:1]",
        Evidences = {"冻结温度", "鬼写字", "灵魂盒子"},
        Features = "可以伪造幽灵球证据；能模仿其他幽灵的专属能力。",
    },
    {
        Name = "Specter",
        CNName = "幽影",
        PosStr = "[排:6 列:3][页:1]",
        Evidences = {"EMF5", "冻结温度", "幽灵点阵"},
        Features = "仅狩猎时会游荡，平时死守鬼房；投掷物品概率更高。",
    },
    {
        Name = "Spirit",
        CNName = "灵魂",
        PosStr = "[排:1 列:1][页:2]",
        Evidences = {"鬼写字", "指纹", "灵魂盒子"},
        Features = "无专属强弱项；可以改变蜡烛的火焰颜色。",
    },
    {
        Name = "Umbra",
        CNName = "暗影生物",
        PosStr = "[排:1 列:2][页:2]",
        Evidences = {"指纹", "幽灵球", "幽灵点阵"},
        Features = "全程不会发出脚步声；光照充足的房间移动速度变慢。",
    },
    {
        Name = "Vesper",
        CNName = "维斯珀",
        PosStr = "[排:1 列:3][页:2]",
        Evidences = {"鬼写字", "指纹", "花枯萎"},
        Features = "仅依靠声音狩猎定位；可以穿透墙壁进行追踪。",
    },
    {
        Name = "Vex",
        CNName = "维克",
        PosStr = "[排:2 列:1][页:2]",
        Evidences = {"冻结温度", "幽灵球", "花枯萎"},
        Features = "激光扫描模式下无法被检测到；可以穿透墙壁行进。",
    },
    {
        Name = "Wendigo",
        CNName = "温迪戈",
        PosStr = "[排:2 列:2][页:2]",
        Evidences = {"鬼写字", "幽灵球", "幽灵点阵"},
        Features = "惧怕明火，不会在火焰附近开始狩猎；能量越低移速越快。",
    },
    {
        Name = "The Wisp",
        CNName = "鬼火",
        PosStr = "[排:2 列:3][页:2]",
        Evidences = {"幽灵球", "幽灵点阵", "花枯萎"},
        Features = "可以穿过火焰；只能在自己最喜欢的房间开启狩猎。",
    },
    {
        Name = "Wraith",
        CNName = "幽灵",
        PosStr = "[排:3 列:1][页:2]",
        Evidences = {"EMF5", "幽灵点阵", "灵魂盒子"},
        Features = "快速消耗猎人能量；不会触碰盐线。",
    },
}

local function checkEMF5()
    local items = workspace:FindFirstChild("Items")

    if not items then
        return false
    end

    for _, item in ipairs(items:GetChildren()) do
        if item:GetAttribute("ItemName") == "EMF Reader" then
            local indicators = item:FindFirstChild("Indicators")
            local five = indicators and indicators:FindFirstChild("5")

            if five
                and five:IsA("BasePart")
                and five.Material == Enum.Material.Neon then
                return true
            end
        end
    end

    return false
end

local function checkFingerprints()
    local folder = workspace:FindFirstChild("Handprints")

    return folder and #folder:GetChildren() > 0 or false
end

local function checkGhostOrb()
    return detectGhostOrb()
end

local function checkFreezing()
    local map = workspace:FindFirstChild("Map")
    local rooms = map and map:FindFirstChild("Rooms")

    if not rooms then
        return false
    end

    local playerRoom = getPlayerCurrentRoom()

    if playerRoom then
        local temperature = getRoomTemperatureByName(playerRoom)

        if temperature and temperature < 0 then
            return true
        end
    end

    for _, room in ipairs(rooms:GetChildren()) do
        local temperature = room:GetAttribute("Temperature")

        if typeof(temperature) == "number" and temperature < 0 then
            return true
        end
    end

    return false
end

local function checkDots()
    local ghost = getGhostModel()

    if not ghost then
        return false
    end

    return ghost:GetAttribute("InLaser") ~= nil
        or ghost:GetAttribute("LaserVisible") ~= nil
end

local function checkGhostWriting()
    local items = workspace:FindFirstChild("Items")

    if not items then
        return false
    end

    for _, item in ipairs(items:GetChildren()) do
        if item:GetAttribute("ItemName") == "Spirit Book" then
            if item:GetAttribute("PhotoRewardType") == "Inscription"
                or item:GetAttribute("Disabled") == true then
                return true
            end
        end
    end

    return false
end

local function checkWitheredFlower()
    local items = workspace:FindFirstChild("Items")

    if not items then
        return false
    end

    for _, item in ipairs(items:GetChildren()) do
        if item:GetAttribute("ItemName") == "Flower Pot" then
            if item:GetAttribute("PhotoRewardType") == "WitheredFlowers"
                or item:GetAttribute("Disabled") == true then
                return true
            end
        end
    end

    return false
end

local function checkSpiritBox()
    local items = workspace:FindFirstChild("Items")

    if not items then
        return false
    end

    for _, item in ipairs(items:GetChildren()) do
        if item:GetAttribute("ItemName") == "Spirit Box" then
            if item:GetAttribute("Response")
                or item:GetAttribute("Answered")
                or item:GetAttribute("GhostResponse") then
                return true
            end
        end
    end

    return false
end

local function updateEvidenceUI()
    LabelEMF:SetText("EMF5级：" .. (EvidenceState.EMF5 and "✔️" or "❌"))
    LabelFinger:SetText("指纹：" .. (EvidenceState.Finger and "✔️" or "❌"))
    LabelOrb:SetText("幽灵球：" .. (EvidenceState.Orb and "✔️" or "❌"))
    LabelTemp:SetText("冻结温度：" .. (EvidenceState.Temp and "✔️" or "❌"))
    LabelWriting:SetText("鬼写字：" .. (EvidenceState.Writing and "✔️" or "❌"))
    LabelFlower:SetText("花枯萎：" .. (EvidenceState.Flower and "✔️" or "❌"))
    LabelDots:SetText("幽灵点阵：" .. (EvidenceState.Dots and "✔️" or "❌"))
    LabelBox:SetText("灵魂盒子：" .. (EvidenceState.Box and "✔️" or "❌"))
end

local PossibleLabel = GroupEvidence:AddLabel("幽灵：筛选中")

local function updatePossibleGhosts()
    local count = 0
    local last

    for _, ghost in ipairs(Ghosts) do
        local match = true

        if EvidenceState.EMF5
            and not table.find(ghost.Evidences, "EMF5") then
            match = false
        end

        if EvidenceState.Finger
            and not table.find(ghost.Evidences, "指纹") then
            match = false
        end

        if EvidenceState.Orb
            and not table.find(ghost.Evidences, "幽灵球") then
            match = false
        end

        if EvidenceState.Temp
            and not table.find(ghost.Evidences, "冻结温度") then
            match = false
        end

        if EvidenceState.Writing
            and not table.find(ghost.Evidences, "鬼写字") then
            match = false
        end

        if EvidenceState.Flower
            and not table.find(ghost.Evidences, "花枯萎") then
            match = false
        end

        if EvidenceState.Dots
            and not table.find(ghost.Evidences, "幽灵点阵") then
            match = false
        end

        if EvidenceState.Box
            and not table.find(ghost.Evidences, "灵魂盒子") then
            match = false
        end

        if match then
            count = count + 1
            last = ghost
        end
    end

    if count == 1 and last then
        PossibleLabel:SetText(
            "幽灵：" .. last.Name .. last.PosStr
        )
    else
        PossibleLabel:SetText(
            "幽灵：筛选中 (" .. count .. "个)"
        )
    end
end

task.spawn(function()
    while EvidenceLoopRunning and not ScriptClosed do
        task.wait(0.5)

        if not EvidenceLoopRunning or ScriptClosed then
            break
        end

        pcall(function()

            if not EvidenceState.EMF5 and checkEMF5() then
                EvidenceState.EMF5 = true
                Library:Notify("EMF5", 1)
            end

            if not EvidenceState.Finger and checkFingerprints() then
                EvidenceState.Finger = true
                Library:Notify("指纹", 1)
            end

            if not EvidenceState.Orb and checkGhostOrb() then
                EvidenceState.Orb = true
                Library:Notify("幽灵球", 1)
            end

            if not EvidenceState.Temp and checkFreezing() then
                EvidenceState.Temp = true
                Library:Notify("冻结温度", 1)
            end

            if not EvidenceState.Writing and checkGhostWriting() then
                EvidenceState.Writing = true
                Library:Notify("鬼写字", 1)
            end

            if not EvidenceState.Flower and checkWitheredFlower() then
                EvidenceState.Flower = true
                Library:Notify("花枯萎", 1)
            end

            if not EvidenceState.Dots and checkDots() then
                EvidenceState.Dots = true
                Library:Notify("幽灵点阵", 1)
            end

            if not EvidenceState.Box and checkSpiritBox() then
                EvidenceState.Box = true
                Library:Notify("灵魂盒子", 1)
            end

            updateEvidenceUI()
            updatePossibleGhosts()
        end)
    end
end)

-- 证据页：幽灵检索

local GroupGhostQuery = TabEvidence:AddRightGroupbox("幽灵检索")

local GhostDropdownList = {}
local GhostDataMap = {}

for _, ghost in ipairs(Ghosts) do
    local display = string.format(
        "%s [%s]",
        ghost.Name,
        ghost.CNName
    )

    table.insert(GhostDropdownList, display)
    GhostDataMap[display] = ghost
end

local QueryEvidence = GroupGhostQuery:AddLabel("证据：")
local QueryFeatures = GroupGhostQuery:AddLabel("特征：")

local function formatEvidenceList(list)
    local result = {}

    for _, evidence in ipairs(list) do
        table.insert(result, "[" .. evidence .. "]")
    end

    return table.concat(result, "")
end

GroupGhostQuery:AddDropdown("GhostSelector", {
    Values = GhostDropdownList,
    Default = 1,
    Multi = false,
    Text = "选择幽灵",

    Callback = function(value)
        local ghost = GhostDataMap[value]

        if ghost then
            QueryEvidence:SetText(
                "证据：" .. formatEvidenceList(ghost.Evidences)
            )

            QueryFeatures:SetText(
                "特征：\n" .. ghost.Features
            )
        end
    end,
})

-- 物品页：物品管理

local GroupItems = TabItems:AddLeftGroupbox("物品")

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

                table.insert(
                    duplicate[name],
                    item
                )
            end
        end

        for name, list in pairs(duplicate) do
            if #list == 1 then

                table.insert(
                    ItemOptionsList,
                    name
                )

                ItemDataMap[name] = list[1]

            else

                for index, item in ipairs(list) do
                    local key = string.format(
                        "%s[%d]",
                        name,
                        index
                    )

                    table.insert(
                        ItemOptionsList,
                        key
                    )

                    ItemDataMap[key] = item
                end
            end
        end
    end

    if #ItemOptionsList == 0 then
        table.insert(
            ItemOptionsList,
            "无物品"
        )
    end

    table.sort(ItemOptionsList)

    SelectedItemString = ItemOptionsList[1]
end

refreshItemsList()

local ItemDropdown = GroupItems:AddDropdown("ItemSelector", {
    Values = ItemOptionsList,
    Default = 1,
    Multi = false,
    Text = "选择物品",

    Callback = function(v)
        SelectedItemString = v
    end,
})

GroupItems:AddButton({
    Text = "刷新物品",

    Func = function()
        refreshItemsList()

        ItemDropdown:SetValues(
            ItemOptionsList
        )

        ItemDropdown:SetValue(
            ItemOptionsList[1]
        )
    end,
})

local function unanchorItem(item)
    if not item then
        return
    end

    if item:IsA("BasePart") then
        item.Anchored = false
    end

    for _, child in ipairs(item:GetDescendants()) do
        if child:IsA("BasePart") then
            child.Anchored = false
        end
    end
end

GroupItems:AddButton({
    Text = "物品到幽灵",

    Func = function()
        local item = ItemDataMap[SelectedItemString]
        local ghost = getGhostModel()
        local root = ghost and getRoot(ghost)

        if item and root then
            if item:IsA("Model") then
                item:PivotTo(root.CFrame)
            elseif item:IsA("BasePart") then
                item.CFrame = root.CFrame
            end

            unanchorItem(item)
        end
    end,
})

GroupItems:AddButton({
    Text = "物品到身边",

    Func = function()
        local item = ItemDataMap[SelectedItemString]

        local root =
            LocalPlayer.Character
            and LocalPlayer.Character:FindFirstChild(
                "HumanoidRootPart"
            )

        if item and root then
            local cf = root.CFrame * CFrame.new(0, 0, -3)

            if item:IsA("Model") then
                item:PivotTo(cf)
            elseif item:IsA("BasePart") then
                item.CFrame = cf
            end

            unanchorItem(item)
        end
    end,
})

-- 玩家页：玩家功能

local GroupPlayer = TabPlayer:AddLeftGroupbox("玩家")

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

GroupPlayer:AddToggle("InfiniteStamina", {
    Text = "无限体力",
    Default = false,

    Callback = function(v)
        InfiniteStaminaEnabled = v

        if StaminaLoopConn then
            StaminaLoopConn:Disconnect()
            StaminaLoopConn = nil
        end

        if v then
            StaminaLoopConn = RunService.Heartbeat:Connect(function()
                if ScriptClosed then
                    return
                end

                pcall(function()

                    if LocalPlayer:GetAttribute("Stamina") ~= nil then
                        LocalPlayer:SetAttribute(
                            "Stamina",
                            100
                        )
                    end

                    local value =
                        LocalPlayer:FindFirstChild("Stamina")

                    if value and value:IsA("ValueBase") then
                        value.Value = 100
                    end

                    if LocalPlayer.Character then

                        if LocalPlayer.Character:GetAttribute("Stamina") ~= nil then
                            LocalPlayer.Character:SetAttribute(
                                "Stamina",
                                100
                            )
                        end

                        local characterValue =
                            LocalPlayer.Character:FindFirstChild(
                                "Stamina",
                                true
                            )

                        if characterValue
                            and characterValue:IsA("ValueBase") then

                            characterValue.Value = 100
                        end
                    end
                end)
            end)
        end
    end,
})

GroupPlayer:AddToggle("NoclipToggle", {
    Text = "穿墙",
    Default = false,

    Callback = function(v)
        NoclipEnabled = v

        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
        end

        if v then

            NoclipConnection = RunService.Stepped:Connect(function()
                if not NoclipEnabled
                    or ScriptClosed
                    or not LocalPlayer.Character then
                    return
                end

                for _, part in ipairs(
                    LocalPlayer.Character:GetDescendants()
                ) do

                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)

        else

            if LocalPlayer.Character then
                for _, part in ipairs(
                    LocalPlayer.Character:GetDescendants()
                ) do

                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end,
})

GroupPlayer:AddToggle("BrightnessToggle", {
    Text = "全局明亮",
    Default = false,

    Callback = function(v)
        BrightnessEnabled = v

        if BrightnessConnection then
            BrightnessConnection:Disconnect()
            BrightnessConnection = nil
        end

        if v then

            OriginalBrightness = Lighting.Brightness
            OriginalAmbient = Lighting.Ambient
            OriginalOutdoorAmbient = Lighting.OutdoorAmbient
            OriginalGlobalShadows = Lighting.GlobalShadows

            local function apply()
                if ScriptClosed then
                    return
                end

                Lighting.Brightness = 2
                Lighting.Ambient = Color3.new(1, 1, 1)
                Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
                Lighting.GlobalShadows = false
            end

            apply()

            BrightnessConnection =
                RunService.Heartbeat:Connect(apply)

        else

            if OriginalBrightness then
                Lighting.Brightness = OriginalBrightness
                Lighting.Ambient = OriginalAmbient
                Lighting.OutdoorAmbient = OriginalOutdoorAmbient
                Lighting.GlobalShadows = OriginalGlobalShadows
            end
        end
    end,
})

GroupPlayer:AddInput("WalkSpeedInput", {
    Text = "玩家速度",
    Default = "-1",
    Numeric = true,
    Finished = true,
    Placeholder = "-1恢复",

    Callback = function(value)
        local speed = tonumber(value)

        if speed == -1 or not speed then
            speed = 16
        end

        pcall(function()
            local humanoid =
                LocalPlayer.Character
                and LocalPlayer.Character:FindFirstChild(
                    "Humanoid"
                )

            if humanoid then
                humanoid.WalkSpeed = speed
            end
        end)
    end,
})

GroupPlayer:AddButton({
    Text = "重置人物",

    Func = function()
        local humanoid =
            LocalPlayer.Character
            and LocalPlayer.Character:FindFirstChild(
                "Humanoid"
            )

        if humanoid then
            humanoid.Health = 0
        end
    end,
})

-- 玩家页：房间

local GroupRoom = TabPlayer:AddRightGroupbox("房间")

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
                table.insert(
                    RoomOptionsList,
                    display
                )

                RawRoomNames[display] = room.Name
            end
        end
    end

    if #RoomOptionsList == 0 then
        table.insert(
            RoomOptionsList,
            "无房间"
        )
    end

    SelectedRoom = RoomOptionsList[1]
end

refreshRoomsList()

local RoomDropdown = GroupRoom:AddDropdown(
    "RoomSelector",
    {
        Values = RoomOptionsList,
        Default = 1,
        Multi = false,
        Text = "房间",

        Callback = function(v)
            SelectedRoom = v
        end,
    }
)

local function setPlayerCurrentRoom(roomName)
    if not roomName then
        return
    end

    pcall(function()

        if LocalPlayer:GetAttribute("CurrentRoom") ~= nil then
            LocalPlayer:SetAttribute(
                "CurrentRoom",
                roomName
            )
        end

        local value =
            LocalPlayer:FindFirstChild("CurrentRoom")

        if value and value:IsA("ValueBase") then
            value.Value = roomName
        end
    end)

    if LocalPlayer.Character then

        pcall(function()

            if LocalPlayer.Character:GetAttribute("CurrentRoom") ~= nil then
                LocalPlayer.Character:SetAttribute(
                    "CurrentRoom",
                    roomName
                )
            end

            local value =
                LocalPlayer.Character:FindFirstChild(
                    "CurrentRoom",
                    true
                )

            if value and value:IsA("ValueBase") then
                value.Value = roomName
            end
        end)
    end
end

GroupRoom:AddButton({
    Text = "更改房间",

    Func = function()
        local raw = RawRoomNames[SelectedRoom]

        if raw then
            setPlayerCurrentRoom(raw)
        end
    end,
})

local RoomLockEnabled = false
local RoomLockConn
local LockedRoomRawName

GroupRoom:AddToggle("LockRoomToggle", {
    Text = "锁定房间",
    Default = false,

    Callback = function(v)
        RoomLockEnabled = v

        if RoomLockConn then
            RoomLockConn:Disconnect()
            RoomLockConn = nil
        end

        if v then

            LockedRoomRawName = getPlayerCurrentRoom()

            if LockedRoomRawName then

                RoomLockConn =
                    RunService.Heartbeat:Connect(function()

                        if ScriptClosed then
                            return
                        end

                        if RoomLockEnabled
                            and LockedRoomRawName
                            and getPlayerCurrentRoom()
                                ~= LockedRoomRawName then

                            setPlayerCurrentRoom(
                                LockedRoomRawName
                            )
                        end
                    end)
            end

        else
            LockedRoomRawName = nil
        end
    end,
})

GroupRoom:AddButton({
    Text = "刷新房间",

    Func = function()
        refreshRoomsList()

        RoomDropdown:SetValues(
            RoomOptionsList
        )

        RoomDropdown:SetValue(
            RoomOptionsList[1]
        )
    end,
})

-- 地图页：地图

local GroupMap = TabMap:AddLeftGroupbox("地图")

GroupMap:AddButton({
    Text = "删除所有门",

    Func = function()
        local doors = workspace:FindFirstChild("Doors")

        if doors then
            doors:Destroy()
        end
    end,
})

-- 设置页：关闭脚本

local cleanupScript

cleanupScript = function()
    if ScriptClosed then
        return
    end

    ScriptClosed = true

    HighlightRefreshRunning = false
    EvidenceLoopRunning = false

    -- ESP

    for espType in pairs(ESPEnabled) do
        ESPEnabled[espType] = false
    end

    if ESPScanConnection then
        ESPScanConnection:Disconnect()
        ESPScanConnection = nil
    end

    for object in pairs(ESPStorage) do
        removeESP(object)
    end

    for object in pairs(GhostTransparency) do
        restoreGhostTransparency(object)
    end

    -- 幽灵信息

    GhostInfoEnabled = false

    if GhostInfoBackground then
        GhostInfoBackground.Visible = false
    end

    if PlayerInfoBackground then
        PlayerInfoBackground.Visible = false
    end

    if GhostInfoUpdateConn then
        GhostInfoUpdateConn:Disconnect()
        GhostInfoUpdateConn = nil
    end

    -- 玩家功能

    InfiniteStaminaEnabled = false

    if StaminaLoopConn then
        StaminaLoopConn:Disconnect()
        StaminaLoopConn = nil
    end

    NoclipEnabled = false

    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end

    if LocalPlayer.Character then
        pcall(function()
            for _, part in ipairs(
                LocalPlayer.Character:GetDescendants()
            ) do

                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end)
    end

    -- 亮度

    BrightnessEnabled = false

    if BrightnessConnection then
        BrightnessConnection:Disconnect()
        BrightnessConnection = nil
    end

    if OriginalBrightness ~= nil then
        pcall(function()
            Lighting.Brightness = OriginalBrightness
            Lighting.Ambient = OriginalAmbient
            Lighting.OutdoorAmbient = OriginalOutdoorAmbient
            Lighting.GlobalShadows = OriginalGlobalShadows
        end)
    end

    -- 房间

    RoomLockEnabled = false
    LockedRoomRawName = nil

    if RoomLockConn then
        RoomLockConn:Disconnect()
        RoomLockConn = nil
    end

    -- 小窗

    pcall(function()
        if SideGui then
            SideGui:Destroy()
        end
    end)

    -- UI

    pcall(function()
        if Library.Unload then
            Library:Unload()
        end
    end)

    -- 标记

    pcall(function()
        getrenv()[ScriptRunningFlag] = nil
    end)
end

local GroupSettings = TabSettings:AddLeftGroupbox("脚本")

GroupSettings:AddButton({
    Text = "关闭脚本",

    Func = function()
        cleanupScript()
    end,
})

-- 设置页：存档

Library.ToggleKeybind = Library.Options.MenuKey

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:BuildConfigSection(TabSettings)
SaveManager:LoadAutoloadConfig()

-- 脚本：窗口关闭

pcall(function()
    Window:OnClose(function()
        cleanupScript()
    end)
end)
