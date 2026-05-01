local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 基础路径与初始化
local Paths = {
    FishingMain = Player.PlayerGui:WaitForChild("MainGui"):WaitForChild("Fishing"),
    SkillFrame = Player.PlayerGui.MainGui.Fishing:WaitForChild("SkillButton"):WaitForChild("Frame"),
    BarFrame = Player.PlayerGui.MainGui.Fishing:WaitForChild("BarFrame"),
    Bar = Player.PlayerGui.MainGui.Fishing.BarFrame:WaitForChild("Bar"),
    MobileFishing = Player.PlayerGui.MainGui:WaitForChild("Mobile"):WaitForChild("Fishing")
}

_G.AutoFishing = false
_G.FishingDelay = 0
_G.LockBar = false
_G.LockMode = "控鱼"
_G.AutoSkills = false
_G.SelectedSkills = {} 
_G.SelectedIsland = "初始岛"

-- 穿墙变量
local NoclipEnabled = false
local NoclipConnection = nil

-- 飞行变量
local nowe = false
local speeds = 1
local tpwalking = false

-- 战斗变量
local AimAssistEnabled = false
local AimOffsetY = 0
local TrackingRange = 500

-- 透视相关变量
local ESPEnabled, NPCESPEnabled = false, false
local PlayerUIStorage, NPCUIStorage = {}, {} 
local ESPSettings = {ShowHighlight = false, ShowName = false, ShowHealth = false, ShowDistance = false, MaxDistance = 500}
local NPCSettings = {ShowHighlight = false, ShowName = false, ShowHealth = false, ShowDistance = false, MaxDistance = 500}

-- 基础函数
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

local function playEffectSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://87437544236708"
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    sound.Ended:Connect(function() sound:Destroy() end)
end

local function getHumanoid() return Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") end

-- 穿墙逻辑
local function enableNoclip()
    if NoclipEnabled then return end
    NoclipEnabled = true
    NoclipConnection = RunService.Stepped:Connect(function()
        if not NoclipEnabled then return end
        local character = Player.Character
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
    local character = Player.Character
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

-- 飞行逻辑代码
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
                while tpwalking and hb:Wait() and Player.Character and getHumanoid() and getHumanoid().Parent do
                    if getHumanoid().MoveDirection.Magnitude > 0 then
                        Player.Character:TranslateBy(getHumanoid().MoveDirection)
                    end
                end
            end)
        end
        
        if Player.Character:FindFirstChild("Animate") then Player.Character.Animate.Disabled = true end
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
        local char = Player.Character
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

-- 透视核心逻辑
local function createESP(target, isPlayer, storage, settings)
    if isPlayer and target == Player then return end
    local function setup(character)
        if not character or storage[target] then return end
        local hum = character:WaitForChild("Humanoid", 10)
        local root = character:WaitForChild("HumanoidRootPart", 10)
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP"; highlight.Parent = character
        
        local billboard = Instance.new("BillboardGui")
        billboard.AlwaysOnTop = true; billboard.Size = UDim2.new(0, 200, 0, 100); billboard.StudsOffset = Vector3.new(0, 3, 0); billboard.Parent = character:WaitForChild("Head", 10)
        
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 1, 0); container.BackgroundTransparency = 1; container.Parent = billboard
        Instance.new("UIListLayout", container).HorizontalAlignment = Enum.HorizontalAlignment.Center
        container.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        
        local function createLabel()
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, 0, 0, 18); l.BackgroundTransparency = 1; l.TextColor3 = Color3.new(1, 1, 1); l.TextStrokeTransparency = 0; l.Parent = container; return l
        end
        
        local nameLabel = createLabel()
        nameLabel.Text = isPlayer and target.DisplayName or target.Name
        local healthLabel = createLabel()
        local distLabel = createLabel()
        
        local conn = RunService.RenderStepped:Connect(function()
            local currentEnabled = isPlayer and ESPEnabled or NPCESPEnabled
            if not character.Parent or not currentEnabled then billboard.Enabled = false; highlight.Enabled = false; return end
            local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            local dist = (root.Position - myRoot.Position).Magnitude
            if dist <= settings.MaxDistance then
                highlight.Enabled = settings.ShowHighlight; billboard.Enabled = true
                nameLabel.Visible = settings.ShowName
                healthLabel.Visible = settings.ShowHealth; healthLabel.Text = math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)
                distLabel.Visible = settings.ShowDistance; distLabel.Text = math.floor(dist).."m"
            else billboard.Enabled = false; highlight.Enabled = false end
        end)
        storage[target] = {Connection = conn}
    end
    if isPlayer then
        target.CharacterAdded:Connect(setup); if target.Character then setup(target.Character) end
    else
        setup(target)
    end
end

-- UI构建
local Window = WindUI:CreateWindow({ 
    Title = "NY脚本", 
    Size = UDim2.fromOffset(580, 600), 
    Theme = "Dark" 
})

-- 自动钓鱼
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

local IslandData = {
    ["初始岛"] = { Pos = Vector3.new(-221.18, 10, -26.04), Info = "包含: 鳟鱼, 金枪鱼, 斑鱼" },
    ["竹子岛"] = { Pos = Vector3.new(-1223.00, 10, -24.25), Info = "包含: 银金枪鱼, 草鲤鱼" },
    ["核弹岛"] = { Pos = Vector3.new(48.90, 10, 1186.60), Info = "包含: 带刺三文鱼" },
    ["主权岛"] = { Pos = Vector3.new(-1215.80, 10, 1244.59), Info = "包含: 幼年焦龙" },
    ["鲈鱼岛"] = { Pos = Vector3.new(-65.69, 10, -1338.62), Info = "包含: 长老鲈鱼" },
    ["冰霜岛"] = { Pos = Vector3.new(-1324.89, 10, -1398.24), Info = "包含: 坤鱼" }
}
local SortedIslands = {"初始岛", "竹子岛", "核弹岛", "主权岛", "鲈鱼岛", "冰霜岛"}
local FishInfoDisplay = TabFishTP:Paragraph({ Title = "地图详细信息", Desc = IslandData["初始岛"].Info })
TabFishTP:Dropdown({ Title = "选择地图", Values = SortedIslands, Callback = function(v) _G.SelectedIsland = v; FishInfoDisplay:SetDesc(IslandData[v].Info) end })
TabFishTP:Button({ Title = "开始传送", Callback = function() local data = IslandData[_G.SelectedIsland] if data and Player.Character then Player.Character.HumanoidRootPart.CFrame = CFrame.new(data.Pos + Vector3.new(0, 5, 0)) end end })

-- 玩家管理
local PlayerSection = Window:Section({ Title = "玩家管理", Opened = false })
local TabAttr = PlayerSection:Tab({ Title = "属性修改", Icon = "user" })

TabAttr:Toggle({ Title = "修改速度", Callback = function(s) playEffectSound(); WalkSpeedEnabled = s; local h = getHumanoid() if h then h.WalkSpeed = s and TargetWalkSpeed or 16 end end })
TabAttr:Input({ Title = "速度数值", Callback = function(v) TargetWalkSpeed = tonumber(v) or 16; if WalkSpeedEnabled then getHumanoid().WalkSpeed = TargetWalkSpeed end end })
TabAttr:Toggle({ Title = "修改跳跃", Callback = function(s) playEffectSound(); JumpPowerEnabled = s; local h = getHumanoid() if h then h.UseJumpPower = true; h.JumpPower = s and TargetJumpPower or 50 end end })
TabAttr:Input({ Title = "跳跃数值", Callback = function(v) TargetJumpPower = tonumber(v) or 50 end })
TabAttr:Toggle({ Title = "无限跳跃", Callback = function(s) playEffectSound(); InfiniteJumpEnabled = s end })
TabAttr:Divider()
TabAttr:Toggle({ Title = "穿墙模式", Callback = function(v) playEffectSound() if v then enableNoclip() else disableNoclip() end end })
TabAttr:Button({ Title = "重置角色", Callback = function() playEffectSound(); if getHumanoid() then getHumanoid().Health = 0 end end })

-- 飞行功能独立Tab
local TabFly = PlayerSection:Tab({ Title = "飞行功能", Icon = "user" })
TabFly:Toggle({ Title = "开启飞行", Callback = function(v) playEffectSound() if v ~= nowe then toggleFly() end end })
TabFly:Input({ Title = "飞行速度", Placeholder = "1", Callback = function(v) speeds = tonumber(v) or 1 end })

-- 视觉辅助
local VisualSection = Window:Section({ Title = "视觉辅助" })
local TabVis = VisualSection:Tab({ Title = "透视辅助", Icon = "eye" })

TabVis:Toggle({ Title = "全图亮度", Callback = function(s) playEffectSound(); Lighting.Brightness = s and 2 or 1; Lighting.GlobalShadows = not s end })
TabVis:Divider()
TabVis:Toggle({ Title = "玩家透视", Callback = function(s) playEffectSound(); ESPEnabled = s; if s then for _, p in pairs(Players:GetPlayers()) do createESP(p, true, PlayerUIStorage, ESPSettings) end end end })
TabVis:Dropdown({ Title = "玩家显示选择", Multi = true, Values = {"轮廓高亮", "显示名字", "显示血量", "显示距离"}, Callback = function(v) 
    ESPSettings.ShowHighlight = table.find(v, "轮廓高亮") ~= nil
    ESPSettings.ShowName = table.find(v, "显示名字") ~= nil
    ESPSettings.ShowHealth = table.find(v, "显示血量") ~= nil
    ESPSettings.ShowDistance = table.find(v, "显示距离") ~= nil
end })
TabVis:Divider()
TabVis:Toggle({ Title = "NPC透视", Callback = function(s) playEffectSound(); NPCESPEnabled = s; if s then for _, v in pairs(workspace:GetDescendants()) do if v:IsA("Humanoid") and not Players:GetPlayerFromCharacter(v.Parent) then createESP(v.Parent, false, NPCUIStorage, NPCSettings) end end end end })
TabVis:Dropdown({ Title = "NPC显示选择", Multi = true, Values = {"轮廓高亮", "显示名字", "显示血量", "显示距离"}, Callback = function(v) 
    NPCSettings.ShowHighlight = table.find(v, "轮廓高亮") ~= nil
    NPCSettings.ShowName = table.find(v, "显示名字") ~= nil
    NPCSettings.ShowHealth = table.find(v, "显示血量") ~= nil
    NPCSettings.ShowDistance = table.find(v, "显示距离") ~= nil
end })

-- 战斗增强
local CombatSection = Window:Section({ Title = "战斗增强" })
local TabAim = CombatSection:Tab({ Title = "自动瞄准", Icon = "target" })
TabAim:Toggle({ Title = "开启自瞄", Callback = function(s) playEffectSound(); AimAssistEnabled = s end })
TabAim:Input({ Title = "瞄准偏移", Callback = function(v) AimOffsetY = tonumber(v) or 0 end })
TabAim:Input({ Title = "自瞄范围", Callback = function(v) TrackingRange = tonumber(v) or 500 end })

-- 传送系统
local TabTP = Window:Section({ Title = "传送系统" }):Tab({ Title = "玩家传送", Icon = "map-pin" })
local function getPlrs() local t = {} for _, v in ipairs(Players:GetPlayers()) do if v ~= Player then table.insert(t, v.DisplayName .. " [" .. v.Name .. "]") end end return t end
local PlrDrop = TabTP:Dropdown({ Title = "选择玩家", Values = getPlrs(), Callback = function(v) SelectedTeleportPlayer = v:match("%[(.-)%]") end })
TabTP:Button({ Title = "刷新列表", Callback = function() PlrDrop:SetValues(getPlrs()) end })
TabTP:Button({ Title = "点击传送", Callback = function() playEffectSound(); if SelectedTeleportPlayer then local t = Players:FindFirstChild(SelectedTeleportPlayer) if t and t.Character then Player.Character:SetPrimaryPartCFrame(t.Character.HumanoidRootPart.CFrame * CFrame.new(0, 4, 0)) end end end })

-- 核心循环监听
RunService.RenderStepped:Connect(function()
    -- 进度条锁定
    if _G.LockBar and Paths.BarFrame.Visible then
        if _G.LockMode == "爆竿" then
            Paths.Bar.Position = UDim2.new(-0.1, 0, 0.5, 0)
        else
            Paths.Bar.Position = UDim2.new(0.5, 0, 0.5, 0)
        end
    end
    -- 自动瞄准
    if AimAssistEnabled then
        local nearest, dist = nil, TrackingRange
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (p.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then nearest = p.Character.HumanoidRootPart; dist = d end
            end
        end
        if nearest then Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, nearest.Position + Vector3.new(0, AimOffsetY, 0)) end
    end
end)

-- 自动功能循环
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

-- 角色死亡处理
Player.CharacterAdded:Connect(function(char)
    wait(0.7)
    nowe = false
    if NoclipEnabled then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
        end
    end
end)

-- 无限跳跃
UserInputService.JumpRequest:Connect(function() if InfiniteJumpEnabled then local h = getHumanoid() if h then h:ChangeState("Jumping") end end end)
