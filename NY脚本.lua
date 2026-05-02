local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 基础路径
local Paths = {
    FishingMain = LocalPlayer.PlayerGui:WaitForChild("MainGui"):WaitForChild("Fishing"),
    SkillFrame = LocalPlayer.PlayerGui.MainGui.Fishing:WaitForChild("SkillButton"):WaitForChild("Frame"),
    BarFrame = LocalPlayer.PlayerGui.MainGui.Fishing:WaitForChild("BarFrame"),
    Bar = LocalPlayer.PlayerGui.MainGui.Fishing.BarFrame:WaitForChild("Bar"),
    MobileFishing = LocalPlayer.PlayerGui.MainGui:WaitForChild("Mobile"):WaitForChild("Fishing")
}

_G.AutoFishing = false
_G.FishingDelay = 0
_G.LockBar = false
_G.LockMode = "控鱼"
_G.AutoSkills = false
_G.SelectedSkills = {} 
_G.SelectedIsland = "初始岛"
_G.AutoSell = false

-- 穿墙数据
local NoclipEnabled = false
local NoclipConnection = nil

-- 飞行数据
local nowe = false
local speeds = 1
local tpwalking = false

-- 战斗与透视变量
local AimAssistEnabled = false
local AimAssistInterval = 0
local AimOffsetY = 0
local TrackingRange = 500
local LastAimTime = 0
local ESPEnabled, NPCESPEnabled = false, false
local PlayerUIStorage, NPCUIStorage = {}, {} 
local ESPSettings = {ShowHighlight = false, ShowName = false, ShowHealth = false, ShowDistance = false, MaxDistance = 500}
local NPCSettings = {ShowHighlight = false, ShowName = false, ShowHealth = false, ShowDistance = false, MaxDistance = 500}

-- 地图高亮变量
local BrightnessEnabled = false
local OriginalBrightness = nil
local OriginalAmbient = nil
local OriginalOutdoorAmbient = nil
local BrightnessConnection = nil

-- 点击功能
local function click(btn)
    if not btn then return end
    pcall(function()
        for _, event in pairs({"MouseButton1Click", "MouseButton1Down"}) do
            local conns = getconnections(btn[event])
            for _, conn in pairs(conns) do
                conn:Fire()
            end
        end
    end)
end

-- 音效功能
local function playEffectSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://87437544236708"
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    sound.Ended:Connect(function() sound:Destroy() end)
end

local function getHumanoid() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end

-- 穿墙功能逻辑
local function enableNoclip()
    if NoclipEnabled then return end
    NoclipEnabled = true
    NoclipConnection = RunService.Stepped:Connect(function()
        if not NoclipEnabled then return end
        local character = LocalPlayer.Character
        if not character then return end
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
        end
    end)
end

local function disableNoclip()
    if not NoclipEnabled then return end
    NoclipEnabled = false
    if NoclipConnection then NoclipConnection:Disconnect(); NoclipConnection = nil end
    local character = LocalPlayer.Character
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

-- 飞行功能代码
local function toggleFly()
    if nowe == true then
        nowe = false
        local hum = getHumanoid()
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Running,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
            hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
        end
    else 
        nowe = true
        for i = 1, speeds do
            spawn(function()
                local hb = RunService.Heartbeat    
                tpwalking = true
                while tpwalking and hb:Wait() and LocalPlayer.Character and getHumanoid() and getHumanoid().Parent do
                    if getHumanoid().MoveDirection.Magnitude > 0 then
                        LocalPlayer.Character:TranslateBy(getHumanoid().MoveDirection)
                    end
                end
            end)
        end
        
        if LocalPlayer.Character:FindFirstChild("Animate") then LocalPlayer.Character.Animate.Disabled = true end
        local hum = getHumanoid()
        if hum then
            for i,v in next, hum:GetPlayingAnimationTracks() do v:AdjustSpeed(0) end
            hum:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
            hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
            hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Running,false)
            hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
            hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
            hum:ChangeState(Enum.HumanoidStateType.Swimming)
        end
    end

    spawn(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = getHumanoid()
        local isR6 = (hum.RigType == Enum.HumanoidRigType.R6)
        local root = isR6 and char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
        if not root then return end

        local bg = Instance.new("BodyGyro", root)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = root.CFrame
        local bv = Instance.new("BodyVelocity", root)
        bv.velocity = Vector3.new(0,0.1,0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        if nowe == true then hum.PlatformStand = true end
        
        local ctrl = {f = 0, b = 0, l = 0, r = 0}
        local flySpeedBase = 50 

        while nowe == true and hum.Health > 0 do
            RunService.RenderStepped:Wait()
            bv.velocity = ((Camera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((Camera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - Camera.CoordinateFrame.p))*flySpeedBase
            bg.cframe = Camera.CoordinateFrame
        end
        bg:Destroy()
        bv:Destroy()
        if getHumanoid() then 
            getHumanoid().PlatformStand = false 
            if char:FindFirstChild("Animate") then char.Animate.Disabled = false end
        end
        tpwalking = false
    end)
end

-- 高亮逻辑记录
local function recordOriginalLighting()
    OriginalBrightness = Lighting.Brightness
    OriginalAmbient = Lighting.Ambient
    OriginalOutdoorAmbient = Lighting.OutdoorAmbient
end

local function enableBrightness()
    if BrightnessEnabled then return end
    BrightnessEnabled = true
    if OriginalBrightness == nil then recordOriginalLighting() end
    
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    Lighting.GlobalShadows = false
    Lighting.ClockTime = 12
    Lighting.FogEnd = 100000
    Lighting.FogStart = 0
    
    local colorCorrection = Lighting:FindFirstChild("ColorCorrection")
    if colorCorrection then
        colorCorrection.Brightness = 0
        colorCorrection.Contrast = 0
        colorCorrection.Saturation = 0
    end
    
    BrightnessConnection = RunService.Heartbeat:Connect(function()
        if BrightnessEnabled then
            if Lighting.Brightness < 2 then Lighting.Brightness = 2 end
            if Lighting.Ambient ~= Color3.new(1, 1, 1) then Lighting.Ambient = Color3.new(1, 1, 1) end
            if Lighting.OutdoorAmbient ~= Color3.new(1, 1, 1) then Lighting.OutdoorAmbient = Color3.new(1, 1, 1) end
            if Lighting.GlobalShadows ~= false then Lighting.GlobalShadows = false end
        end
    end)
end

local function disableBrightness()
    if not BrightnessEnabled then return end
    BrightnessEnabled = false
    if BrightnessConnection then BrightnessConnection:Disconnect(); BrightnessConnection = nil end
    
    if OriginalBrightness then Lighting.Brightness = OriginalBrightness end
    if OriginalAmbient then Lighting.Ambient = OriginalAmbient end
    if OriginalOutdoorAmbient then Lighting.OutdoorAmbient = OriginalOutdoorAmbient end
    
    Lighting.GlobalShadows = true
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.FogStart = 0
end

-- 透视功能逻辑
local function createESP(target, isPlayer, storage, settings)
    if isPlayer and target == LocalPlayer then return end
    local function setup(character)
        if not character or storage[target] then return end
        local hum = character:WaitForChild("Humanoid", 10)
        local root = character:WaitForChild("HumanoidRootPart", 10)
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP"
        highlight.Parent = character
        
        local billboard = Instance.new("BillboardGui")
        billboard.AlwaysOnTop = true; billboard.Size = UDim2.new(0, 200, 0, 100); billboard.StudsOffset = Vector3.new(0, 3, 0); billboard.Parent = character:WaitForChild("Head", 10)
        
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 1, 0); container.BackgroundTransparency = 1; container.Parent = billboard
        Instance.new("UIListLayout", container).HorizontalAlignment = Enum.HorizontalAlignment.Center
        container.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        
        local function createLabel(isBold)
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, 0, 0, 18)
            l.BackgroundTransparency = 1
            l.TextColor3 = Color3.new(1, 1, 1)
            l.TextStrokeTransparency = 0
            l.Font = isBold and Enum.Font.SourceSansBold or Enum.Font.SourceSans
            l.Parent = container
            return l
        end
        
        local nameLabel = createLabel(true)
        nameLabel.Text = isPlayer and target.DisplayName or target.Name
        local healthLabel = createLabel(false)
        local distLabel = createLabel(false)
        
        local conn = RunService.RenderStepped:Connect(function()
            local currentEnabled = isPlayer and ESPEnabled or NPCESPEnabled
            if not character.Parent or not currentEnabled then billboard.Enabled = false; highlight.Enabled = false; return end
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            
            local dist = (root.Position - myRoot.Position).Magnitude
            if dist <= settings.MaxDistance then
                highlight.Enabled = settings.ShowHighlight
                billboard.Enabled = true
                
                local hpPerc = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                highlight.FillColor = Color3.fromHSV(hpPerc * 0.3, 1, 1)
                
                nameLabel.Visible = settings.ShowName
                healthLabel.Visible = settings.ShowHealth
                healthLabel.Text = math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)
                healthLabel.TextColor3 = Color3.fromHSV(hpPerc * 0.3, 1, 1)
                
                distLabel.Visible = settings.ShowDistance
                distLabel.Text = math.floor(dist).."m"
            else 
                billboard.Enabled = false
                highlight.Enabled = false 
            end
        end)
        storage[target] = {Connection = conn}
    end
    if isPlayer then
        target.CharacterAdded:Connect(setup); if target.Character then setup(target.Character) end
    else
        setup(target)
    end
end

-- UI
local Window = WindUI:CreateWindow({ 
    Title = "NY脚本", 
    Size = UDim2.fromOffset(580, 600), 
    Theme = "Dark" 
})

-- 钓鱼功能
local FishingSection = Window:Section({ Title = "重型钓鱼", Opened = true })
local TabFishAuto = FishingSection:Tab({ Title = "自动钓鱼", Icon = "anchor" })
local TabFishTP = FishingSection:Tab({ Title = "钓鱼传送", Icon = "map" })

TabFishAuto:Toggle({ Title = "自动钓鱼", Default = false, Callback = function(v) _G.AutoFishing = v end })
TabFishAuto:Input({ Title = "下杆延迟", Placeholder = "秒...", Callback = function(v) _G.FishingDelay = tonumber(v) or 0 end })

TabFishAuto:Toggle({ Title = "进度条强锁", Default = false, Callback = function(v) playEffectSound(); _G.LockBar = v end })
TabFishAuto:Dropdown({ 
    Title = "锁定模式选择", 
    Values = {"控鱼", "爆竿"}, 
    Default = "控鱼", 
    Callback = function(v) _G.LockMode = v end 
})

TabFishAuto:Toggle({ Title = "自动技能", Default = false, Callback = function(v) _G.AutoSkills = v end })
TabFishAuto:Dropdown({ Title = "技能选择", Multi = true, Values = {"Z", "X", "C", "V"}, Callback = function(v) _G.SelectedSkills = v end })

TabFishAuto:Toggle({ Title = "自动卖鱼", Default = false, Callback = function(v) playEffectSound(); _G.AutoSell = v end })

-- 鱼类信息与传送
local IslandData = {
    ["初始岛"] = { Pos = Vector3.new(-221.18, 10, -26.04), Info = "包含: 鳟鱼, 金枪鱼, 猩红金枪鱼, 翡翠金枪鱼, 斑鱼, 金色金枪鱼, 皇家金枪鱼, 傲慢鱼, 白金金枪鱼, 电流草金枪鱼, 蔚蓝色金枪鱼" },
    ["竹子岛"] = { Pos = Vector3.new(-1223.00, 10, -24.25), Info = "包含: 长角银金枪鱼, 黑色鳍草鲤鱼, 猩红草鲤鱼, 金鳞草鲤鱼, 玫瑰鳍金枪鱼, 蔚蓝色草金枪鱼, 统治草鳗鱼, 龙头金枪鱼, 长老龙头金枪鱼, 杰奥龙龙鱼" },
    ["核弹岛"] = { Pos = Vector3.new(48.90, 10, 1186.60), Info = "包含: 带刺三文鱼, 斑甲金枪鱼, 蔚蓝色鳟鱼, 日光斑金枪鱼, 符文喇叭组合器, 钢铁之鳍潜水员, 被链接的鲨鱼" },
    ["主权岛"] = { Pos = Vector3.new(-1215.80, 10, 1244.59), Info = "包含: 边界眼鱼, 幼年焦龙鱼, 黄金鲤鱼, 龙步鲤鱼, 地面老虎深水鱼, 成年焦龙鱼, 年长锁链鲨鱼, 真形焦龙鱼" },
    ["鲈鱼岛"] = { Pos = Vector3.new(-65.69, 10, -1338.62), Info = "包含: 长老鲈鱼(I-VIII), 老鱼珀奇I, 真形鲈鱼, 晋升鲈鱼\n秘密头目: 飞鱼皇帝、飞鱼女皇" },
    ["冰霜岛"] = { Pos = Vector3.new(-1324.89, 10, -1398.24), Info = "包含: 肉食鱼, 坤鱼, 成年坤鱼, 长老坤鱼, 原始坤鱼, 原始坤鱼霸主\n秘密头目: 重生羽绒兽" },
    ["椰子岛"] = { Pos = Vector3.new(1493.61, 10, -1430.62), Info = "包含: 装甲战斗鱼, 黑暗战斗鱼, 龙战斗鱼, 幻影战斗鱼, 绯红战鲤鱼, 翡翠战鲤鱼, 战争伟者鲨鱼, 巨型石斑鱼, 突变独角鲸鱼" },
    ["琥珀岛"] = { Pos = Vector3.new(1259.41, 10, 1401.48), Info = "包含: 沙猫鱼, 深渊光辉鱼, 青金石鱼, 草鲤鱼, 猩红边缘头, 风暴鳞片塔托格, 蛇鱼, 恐惧鳗鱼, 彩色锦鲤" },
    ["战场岛"] = { Pos = Vector3.new(1393.49, 10, 169.63), Info = "包含: 绯红金霸主, 白银光辉霸主, 巨型虎鱼" }
}

local SortedIslands = {"初始岛", "竹子岛", "核弹岛", "主权岛", "鲈鱼岛", "冰霜岛", "椰子岛", "琥珀岛", "战场岛"}
local FishInfoDisplay = TabFishTP:Paragraph({ Title = "地图详细信息", Desc = IslandData["初始岛"].Info })
TabFishTP:Dropdown({ Title = "选择地图", Values = SortedIslands, Callback = function(v) _G.SelectedIsland = v; FishInfoDisplay:SetDesc(IslandData[v].Info) end })
TabFishTP:Button({ Title = "开始传送", Callback = function() local data = IslandData[_G.SelectedIsland] if data and LocalPlayer.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(data.Pos + Vector3.new(0, 5, 0)) end end })

-- 玩家页
local PlayerSection = Window:Section({ Title = "玩家管理", Opened = false })
local TabAttr = PlayerSection:Tab({ Title = "属性修改", Icon = "user" })

TabAttr:Toggle({ Title = "修改速度", Callback = function(s) playEffectSound(); WalkSpeedEnabled = s; local h = getHumanoid() if h then h.WalkSpeed = s and TargetWalkSpeed or 16 end end })
TabAttr:Input({ Title = "速度数值", Callback = function(v) TargetWalkSpeed = tonumber(v) or 16; if WalkSpeedEnabled then getHumanoid().WalkSpeed = TargetWalkSpeed end end })
TabAttr:Toggle({ Title = "修改跳跃", Callback = function(s) playEffectSound(); JumpPowerEnabled = s; local h = getHumanoid() if h then h.UseJumpPower = true; h.JumpPower = s and TargetJumpPower or 50 end end })
TabAttr:Input({ Title = "跳跃数值", Callback = function(v) TargetJumpPower = tonumber(v) or 50 end })
TabAttr:Toggle({ Title = "无限跳跃", Callback = function(s) playEffectSound(); InfiniteJumpEnabled = s end })
TabAttr:Divider()
TabAttr:Toggle({ Title = "穿墙功能", Callback = function(v) playEffectSound() if v then enableNoclip() else disableNoclip() end end })
TabAttr:Button({ Title = "重置角色", Callback = function() playEffectSound(); if getHumanoid() then getHumanoid().Health = 0 end end })

-- 飞行功能
local TabFly = PlayerSection:Tab({ Title = "飞行功能", Icon = "user" })
TabFly:Toggle({ Title = "开启飞行", Callback = function(v) playEffectSound() if v ~= nowe then toggleFly() end end })
TabFly:Input({ Title = "飞行速度", Placeholder = "1", Callback = function(v) speeds = tonumber(v) or 1 end })

-- 视觉辅助页
local VisualSection = Window:Section({ Title = "视觉辅助" })
local TabVis = VisualSection:Tab({ Title = "透视辅助", Icon = "eye" })

TabVis:Toggle({ Title = "高亮模式", Callback = function(s) playEffectSound(); if s then enableBrightness() else disableBrightness() end end })
TabVis:Input({ Title = "亮度调节", Placeholder = "输入数值...", Callback = function(v) local val = tonumber(v); if val and BrightnessEnabled then Lighting.Brightness = val end end })
TabVis:Button({ Title = "恢复默认亮度", Callback = function() playEffectSound(); if BrightnessEnabled then disableBrightness() end Lighting.Brightness = 1; Lighting.Ambient = Color3.new(0, 0, 0); Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5); Lighting.GlobalShadows = true; Lighting.ClockTime = 14 end })

TabVis:Divider()
TabVis:Toggle({ Title = "玩家透视", Callback = function(s) playEffectSound(); ESPEnabled = s; if s then for _, p in pairs(Players:GetPlayers()) do createESP(p, true, PlayerUIStorage, ESPSettings) end end end })
TabVis:Input({ Title = "玩家透视范围", Placeholder = "500", Callback = function(v) ESPSettings.MaxDistance = tonumber(v) or 500 end })
TabVis:Dropdown({ Title = "玩家透视选择器", Multi = true, Values = {"轮廓高亮", "显示名字", "显示血量", "显示距离"}, Callback = function(v) 
    ESPSettings.ShowHighlight = table.find(v, "轮廓高亮") ~= nil
    ESPSettings.ShowName = table.find(v, "显示名字") ~= nil
    ESPSettings.ShowHealth = table.find(v, "显示血量") ~= nil
    ESPSettings.ShowDistance = table.find(v, "显示距离") ~= nil
end })
TabVis:Divider()
TabVis:Toggle({ Title = "NPC透视", Callback = function(s) playEffectSound(); NPCESPEnabled = s; if s then for _, v in pairs(workspace:GetDescendants()) do if v:IsA("Humanoid") and not Players:GetPlayerFromCharacter(v.Parent) then createESP(v.Parent, false, NPCUIStorage, NPCSettings) end end end end })
TabVis:Input({ Title = "NPC透视范围", Placeholder = "500", Callback = function(v) NPCSettings.MaxDistance = tonumber(v) or 500 end })
TabVis:Dropdown({ Title = "NPC透视选择器", Multi = true, Values = {"轮廓高亮", "显示名字", "显示血量", "显示距离"}, Callback = function(v) 
    NPCSettings.ShowHighlight = table.find(v, "轮廓高亮") ~= nil
    NPCSettings.ShowName = table.find(v, "显示名字") ~= nil
    NPCSettings.ShowHealth = table.find(v, "显示血量") ~= nil
    NPCSettings.ShowDistance = table.find(v, "显示距离") ~= nil
end })

-- 战斗增强
local TabAim = Window:Section({ Title = "战斗增强" }):Tab({ Title = "自动瞄准", Icon = "target" })
TabAim:Toggle({ Title = "开启自瞄", Callback = function(s) playEffectSound(); AimAssistEnabled = s end })
TabAim:Input({ Title = "自瞄间隔(秒)", Placeholder = "0", Callback = function(v) AimAssistInterval = tonumber(v) or 0 end })
TabAim:Input({ Title = "瞄准偏移", Placeholder = "0", Callback = function(v) AimOffsetY = tonumber(v) or 0 end })
TabAim:Input({ Title = "自瞄距离范围", Placeholder = "500", Callback = function(v) TrackingRange = tonumber(v) or 500 end })

-- 传送系统
local TabTP = Window:Section({ Title = "传送系统" }):Tab({ Title = "玩家传送", Icon = "map-pin" })
local function getPlrs() local t = {} for _, v in ipairs(Players:GetPlayers()) do if v ~= LocalPlayer then table.insert(t, v.DisplayName .. " [" .. v.Name .. "]") end end return t end
local PlrDrop = TabTP:Dropdown({ Title = "选择玩家", Values = getPlrs(), Callback = function(v) _G.SelectedPlayerName = v:match("%[(.-)%]") end })
TabTP:Button({ Title = "刷新列表", Callback = function() PlrDrop:SetValues(getPlrs()) end })
TabTP:Button({ Title = "点击传送", Callback = function() playEffectSound(); if _G.SelectedPlayerName then local t = Players:FindFirstChild(_G.SelectedPlayerName) if t and t.Character then LocalPlayer.Character:SetPrimaryPartCFrame(t.Character.HumanoidRootPart.CFrame * CFrame.new(0, 4, 0)) end end end })

-- 核心循环功能
RunService.RenderStepped:Connect(function()
    -- 强锁逻辑
    if _G.LockBar and Paths.BarFrame.Visible then
        if _G.LockMode == "爆竿" then
            Paths.Bar.Position = UDim2.new(-0.1, 0, 0.5, 0)
        else
            Paths.Bar.Position = UDim2.new(0.5, 0, 0.5, 0)
        end
    end
    -- 自瞄逻辑修复实现
    if AimAssistEnabled and (tick() - LastAimTime) >= AimAssistInterval then
        local nearest, dist = nil, TrackingRange
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                local d = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then nearest = p.Character.HumanoidRootPart; dist = d end
            end
        end
        if nearest then 
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, nearest.Position + Vector3.new(0, AimOffsetY, 0)) 
            LastAimTime = tick()
        end
    end
end)

-- 自动技能循环
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoSkills and Paths.FishingMain.Visible then
            for _, skillName in pairs(_G.SelectedSkills) do
                local skillBtn = Paths.SkillFrame:FindFirstChild(skillName)
                if skillBtn then click(skillBtn) end
            end
        end
    end
end)

-- 自动抛竿循环
task.spawn(function()
    local wasVisible = false
    while task.wait(0.1) do
        local isVisible = Paths.FishingMain.Visible
        if _G.AutoFishing and wasVisible and not isVisible then
            task.wait(_G.FishingDelay)
            click(Paths.MobileFishing)
        end
        wasVisible = isVisible
    end
end)

-- 自动卖鱼循环
task.spawn(function()
    local wasVisible = false
    while task.wait(0.1) do
        local isVisible = Paths.FishingMain.Visible
        if _G.AutoSell and wasVisible and not isVisible then
            local pGui = LocalPlayer:FindFirstChild("PlayerGui")
            if pGui and pGui:FindFirstChild("MainGui") and pGui.MainGui:FindFirstChild("Menu") and pGui.MainGui.Menu:FindFirstChild("Sell") and pGui.MainGui.Menu.Sell:FindFirstChild("Choose") then
                local sellBtn = pGui.MainGui.Menu.Sell.Choose:FindFirstChild("All")
                if sellBtn then
                    click(sellBtn)
                end
            end
        end
        wasVisible = isVisible
    end
end)

-- 反挂机逻辑
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- 角色重生处理逻辑
LocalPlayer.CharacterAdded:Connect(function(char)
    wait(0.7)
    nowe = false
    if NoclipEnabled then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
        end
    end
end)

-- 连跳功能监听
UserInputService.JumpRequest:Connect(function() if InfiniteJumpEnabled then local h = getHumanoid() if h then h:ChangeState("Jumping") end end end)
