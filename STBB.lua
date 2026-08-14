--所属功能：WindUI加载

local WindUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"
))()

--所属功能：服务

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")

local Player = Players.LocalPlayer

--所属功能：数据

local STBB = {
    SkillEnabled = false,
    SelectedSkill = "普攻",
    SkillDelay = 0.15,

    BattleTPEnabled = false,
    BattleTPMode = "头顶",
    BattleTPOffset = 0,

    SpeedEnabled = false,
    Speed = 16,

    JumpEnabled = false,
    JumpPower = 50,

    BrightnessEnabled = false,
    Brightness = 1,

    PlayerESPEnabled = false,
    MonsterESPEnabled = false,

    PlayerESP = {},
    MonsterESP = {}
}

local SkillList = {
    "全部",
    "普攻",
    "Q",
    "E",
    "R",
    "T",
    "Y",
    "G",
    "H",
    "Z",
    "X",
    "C",
    "V",
    "B",
    "U",
    "F"
}

local BattleTPModes = {
    "头顶",
    "身前",
    "身后",
    "左侧",
    "右侧"
}

local KeyList = {
    Q = Enum.KeyCode.Q,
    E = Enum.KeyCode.E,
    R = Enum.KeyCode.R,
    T = Enum.KeyCode.T,
    Y = Enum.KeyCode.Y,
    G = Enum.KeyCode.G,
    H = Enum.KeyCode.H,
    Z = Enum.KeyCode.Z,
    X = Enum.KeyCode.X,
    C = Enum.KeyCode.C,
    V = Enum.KeyCode.V,
    B = Enum.KeyCode.B,
    U = Enum.KeyCode.U,
    F = Enum.KeyCode.F
}

--所属功能：提示音

local SOUND_ID = "rbxassetid://87437544236708"

local function PlaySound()
    pcall(function()
        local Sound = Instance.new("Sound")

        Sound.SoundId = SOUND_ID
        Sound.Volume = 1
        Sound.Parent = SoundService

        Sound:Play()

        Sound.Ended:Connect(function()
            Sound:Destroy()
        end)
    end)
end

--所属功能：人物获取

local function GetCharacter()
    return Player.Character
end

local function GetHumanoid(Character)
    Character = Character or GetCharacter()
    return Character and Character:FindFirstChildOfClass("Humanoid")
end

local function GetRoot(Character)
    return Character and Character:FindFirstChild("HumanoidRootPart")
end

--所属功能：最近敌人

local function IsPlayerCharacter(Model)
    for _, Target in ipairs(Players:GetPlayers()) do
        if Target.Character == Model then
            return true
        end
    end

    return false
end

local function GetNearestEnemy()
    local Character = GetCharacter()
    local MyRoot = GetRoot(Character)

    if not MyRoot then
        return nil
    end

    local Living = workspace:FindFirstChild("Living")

    if not Living then
        return nil
    end

    local Nearest
    local Distance = math.huge

    for _, Object in ipairs(Living:GetDescendants()) do
        if Object:IsA("Model")
            and Object ~= Character
            and not IsPlayerCharacter(Object)
        then
            local Humanoid = GetHumanoid(Object)
            local Root = GetRoot(Object)

            if Humanoid
                and Root
                and Humanoid.Health > 0
            then
                local CurrentDistance =
                    (Root.Position - MyRoot.Position).Magnitude

                if CurrentDistance < Distance then
                    Distance = CurrentDistance
                    Nearest = Object
                end
            end
        end
    end

    return Nearest
end

--所属功能：角色面向敌人

local function FaceEnemy(Enemy)
    local Character = GetCharacter()
    local Root = GetRoot(Character)
    local EnemyRoot = GetRoot(Enemy)

    if not Root or not EnemyRoot then
        return false
    end

    local Position = Root.Position
    local TargetPosition = EnemyRoot.Position

    Root.CFrame = CFrame.lookAt(
        Position,
        Vector3.new(
            TargetPosition.X,
            Position.Y,
            TargetPosition.Z
        )
    )

    return true
end

--所属功能：战斗传送

local function TeleportToEnemy(Enemy)
    if not STBB.BattleTPEnabled then
        return FaceEnemy(Enemy)
    end

    if not Enemy then
        return false
    end

    local Character = GetCharacter()
    local Root = GetRoot(Character)
    local EnemyRoot = GetRoot(Enemy)

    if not Root or not EnemyRoot then
        return false
    end

    local EnemyPosition = EnemyRoot.Position
    local EnemyCFrame = EnemyRoot.CFrame

    local TargetPosition

    if STBB.BattleTPMode == "头顶" then

        TargetPosition =
            EnemyPosition +
            Vector3.new(
                0,
                5 + STBB.BattleTPOffset,
                0
            )

    elseif STBB.BattleTPMode == "身前" then

        TargetPosition =
            EnemyPosition +
            EnemyCFrame.LookVector * 5 +
            Vector3.new(
                0,
                STBB.BattleTPOffset,
                0
            )

    elseif STBB.BattleTPMode == "身后" then

        TargetPosition =
            EnemyPosition -
            EnemyCFrame.LookVector * 5 +
            Vector3.new(
                0,
                STBB.BattleTPOffset,
                0
            )

    elseif STBB.BattleTPMode == "左侧" then

        TargetPosition =
            EnemyPosition -
            EnemyCFrame.RightVector * 5 +
            Vector3.new(
                0,
                STBB.BattleTPOffset,
                0
            )

    elseif STBB.BattleTPMode == "右侧" then

        TargetPosition =
            EnemyPosition +
            EnemyCFrame.RightVector * 5 +
            Vector3.new(
                0,
                STBB.BattleTPOffset,
                0
            )
    else

        TargetPosition =
            EnemyPosition +
            Vector3.new(
                0,
                5 + STBB.BattleTPOffset,
                0
            )
    end

    Root.CFrame =
        CFrame.new(TargetPosition)

    FaceEnemy(Enemy)

    return true
end

--所属功能：普攻

local function GetLMB()
    local LMB =
        ReplicatedStorage:FindFirstChild("LMB")

    if LMB
        and LMB:IsA("RemoteEvent")
    then
        return LMB
    end

    for _, Object in ipairs(
        ReplicatedStorage:GetDescendants()
    ) do

        if Object.Name == "LMB"
            and Object:IsA("RemoteEvent")
        then
            return Object
        end
    end

    return nil
end

local function UseLMB()
    local LMB = GetLMB()

    if not LMB then
        return false
    end

    return pcall(function()
        LMB:FireServer()
    end)
end

--所属功能：键盘技能

local function PressSkill(KeyName)
    local KeyCode =
        KeyList[KeyName]

    if not KeyCode then
        return
    end

    pcall(function()

        VirtualInputManager:SendKeyEvent(
            true,
            KeyCode,
            false,
            game
        )

        task.wait(0.03)

        VirtualInputManager:SendKeyEvent(
            false,
            KeyCode,
            false,
            game
        )
    end)
end

--所属功能：执行技能

local function UseSelectedSkill()
    local Enemy =
        GetNearestEnemy()

    if not Enemy then
        return
    end

    if STBB.BattleTPEnabled then
        TeleportToEnemy(Enemy)
    else
        FaceEnemy(Enemy)
    end

    local Skill =
        STBB.SelectedSkill

    if Skill == "普攻" then

        UseLMB()

        return
    end

    if Skill == "全部" then

        UseLMB()

        task.wait(
            STBB.SkillDelay
        )

        for _, Key in ipairs({
            "Q",
            "E",
            "R",
            "T",
            "Y",
            "G",
            "H",
            "Z",
            "X",
            "C",
            "V",
            "B",
            "U",
            "F"
        }) do

            if not STBB.SkillEnabled then
                break
            end

            Enemy =
                GetNearestEnemy()

            if not Enemy then
                break
            end

            if STBB.BattleTPEnabled then
                TeleportToEnemy(Enemy)
            else
                FaceEnemy(Enemy)
            end

            PressSkill(Key)

            task.wait(
                STBB.SkillDelay
            )
        end

        return
    end

    PressSkill(Skill)
end

--所属功能：自动战斗

local SkillThread

local function StopSkillLoop()

    STBB.SkillEnabled = false

    if SkillThread then
        task.cancel(SkillThread)
        SkillThread = nil
    end
end

local function SetSkillEnabled(Value)

    StopSkillLoop()

    if not Value then
        return
    end

    STBB.SkillEnabled = true

    SkillThread =
        task.spawn(function()

            while STBB.SkillEnabled do

                if GetNearestEnemy() then
                    UseSelectedSkill()
                end

                task.wait(
                    math.max(
                        0.05,
                        STBB.SkillDelay
                    )
                )
            end
        end)
end

--所属功能：速度修改

local SpeedConnection

local function UpdateSpeed()
    local Humanoid =
        GetHumanoid()

    if Humanoid
        and STBB.SpeedEnabled
    then
        Humanoid.WalkSpeed =
            STBB.Speed
    end
end

local function SetSpeedEnabled(Value)

    STBB.SpeedEnabled =
        Value

    if SpeedConnection then
        SpeedConnection:Disconnect()
        SpeedConnection = nil
    end

    if Value then

        SpeedConnection =
            RunService.Heartbeat:Connect(
                UpdateSpeed
            )

        UpdateSpeed()

    else

        local Humanoid =
            GetHumanoid()

        if Humanoid then
            Humanoid.WalkSpeed = 16
        end
    end
end

--所属功能：跳跃修改

local JumpConnection

local function UpdateJump()

    local Humanoid =
        GetHumanoid()

    if not Humanoid then
        return
    end

    Humanoid.UseJumpPower = true

    if STBB.JumpEnabled then
        Humanoid.JumpPower =
            STBB.JumpPower
    end
end

local function SetJumpEnabled(Value)

    STBB.JumpEnabled =
        Value

    if JumpConnection then
        JumpConnection:Disconnect()
        JumpConnection = nil
    end

    if Value then

        JumpConnection =
            RunService.Heartbeat:Connect(
                UpdateJump
            )

        UpdateJump()

    else

        local Humanoid =
            GetHumanoid()

        if Humanoid then
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = 50
        end
    end
end

--所属功能：亮度修改

local OriginalLighting = {
    Brightness =
        Lighting.Brightness,

    Ambient =
        Lighting.Ambient,

    OutdoorAmbient =
        Lighting.OutdoorAmbient,

    GlobalShadows =
        Lighting.GlobalShadows,

    ClockTime =
        Lighting.ClockTime,

    FogEnd =
        Lighting.FogEnd,

    FogStart =
        Lighting.FogStart
}

local BrightnessConnection

local function ApplyBrightness()

    if not STBB.BrightnessEnabled then
        return
    end

    Lighting.Brightness =
        math.clamp(
            STBB.Brightness,
            0,
            20
        )

    Lighting.Ambient =
        Color3.new(1, 1, 1)

    Lighting.OutdoorAmbient =
        Color3.new(1, 1, 1)

    Lighting.GlobalShadows = false
    Lighting.ClockTime = 12
    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
end

local function SetBrightnessEnabled(Value)

    STBB.BrightnessEnabled =
        Value

    if BrightnessConnection then
        BrightnessConnection:Disconnect()
        BrightnessConnection = nil
    end

    if Value then

        ApplyBrightness()

        BrightnessConnection =
            RunService.Heartbeat:Connect(
                ApplyBrightness
            )

    else

        Lighting.Brightness =
            OriginalLighting.Brightness

        Lighting.Ambient =
            OriginalLighting.Ambient

        Lighting.OutdoorAmbient =
            OriginalLighting.OutdoorAmbient

        Lighting.GlobalShadows =
            OriginalLighting.GlobalShadows

        Lighting.ClockTime =
            OriginalLighting.ClockTime

        Lighting.FogEnd =
            OriginalLighting.FogEnd

        Lighting.FogStart =
            OriginalLighting.FogStart
    end
end

--所属功能：玩家透视

local function RemovePlayerESP(Target)

    local Data =
        STBB.PlayerESP[Target]

    if not Data then
        return
    end

    if Data.Connection then
        Data.Connection:Disconnect()
    end

    if Data.CharacterConnection then
        Data.CharacterConnection:Disconnect()
    end

    if Data.Highlight then
        Data.Highlight:Destroy()
    end

    if Data.Billboard then
        Data.Billboard:Destroy()
    end

    STBB.PlayerESP[Target] = nil
end

local function CreatePlayerESP(Target)

    if Target == Player then
        return
    end

    RemovePlayerESP(Target)

    STBB.PlayerESP[Target] = {}

    local function Setup(Character)

        local Humanoid =
            GetHumanoid(Character)

        local Root =
            GetRoot(Character)

        local Head =
            Character:FindFirstChild(
                "Head"
            )

        if not Humanoid or not Root then
            return
        end

        local Highlight =
            Instance.new("Highlight")

        Highlight.Name =
            "STBB_PlayerESP"

        Highlight.Adornee =
            Character

        Highlight.DepthMode =
            Enum.HighlightDepthMode.AlwaysOnTop

        Highlight.FillColor =
            Color3.fromRGB(
                255,
                0,
                0
            )

        Highlight.FillTransparency =
            0.82

        Highlight.OutlineColor =
            Color3.new(
                1,
                1,
                1
            )

        Highlight.Parent =
            Character

        local Billboard
        local Connection

        if Head then

            Billboard =
                Instance.new(
                    "BillboardGui"
                )

            Billboard.Name =
                "STBB_PlayerInfo"

            Billboard.AlwaysOnTop = true

            Billboard.Size =
                UDim2.fromOffset(
                    220,
                    45
                )

            Billboard.StudsOffset =
                Vector3.new(
                    0,
                    3.2,
                    0
                )

            Billboard.Parent = Head

            local Label =
                Instance.new(
                    "TextLabel"
                )

            Label.Size =
                UDim2.fromScale(
                    1,
                    1
                )

            Label.BackgroundTransparency =
                1

            Label.TextColor3 =
                Color3.new(
                    1,
                    1,
                    1
                )

            Label.TextStrokeTransparency =
                0

            Label.TextScaled =
                true

            Label.Font =
                Enum.Font.SourceSansBold

            Label.Parent =
                Billboard

            Connection =
                RunService.RenderStepped:Connect(
                    function()

                        if not STBB.PlayerESP[Target] then
                            return
                        end

                        local MyRoot =
                            GetRoot(
                                GetCharacter()
                            )

                        if MyRoot
                            and Root.Parent
                        then

                            local Distance =
                                math.floor(
                                    (
                                        Root.Position -
                                        MyRoot.Position
                                    ).Magnitude
                                )

                            Label.Text =
                                Target.DisplayName ..
                                " | HP: " ..
                                math.floor(
                                    Humanoid.Health
                                ) ..
                                "/" ..
                                math.floor(
                                    Humanoid.MaxHealth
                                ) ..
                                " | " ..
                                Distance ..
                                "m"
                        end
                    end
                )
        end

        STBB.PlayerESP[Target] = {
            Highlight = Highlight,
            Billboard = Billboard,
            Connection = Connection
        }
    end

    if Target.Character then
        Setup(Target.Character)
    end

    STBB.PlayerESP[Target].CharacterConnection =
        Target.CharacterAdded:Connect(
            function(Character)

                task.wait(0.2)

                if STBB.PlayerESP[Target] then
                    RemovePlayerESP(Target)
                    CreatePlayerESP(Target)
                end
            end
        )
end

local function SetPlayerESP(Value)

    STBB.PlayerESPEnabled =
        Value

    if Value then

        for _, Target in ipairs(
            Players:GetPlayers()
        ) do

            if Target ~= Player then
                CreatePlayerESP(Target)
            end
        end

    else

        for Target in pairs(
            STBB.PlayerESP
        ) do

            RemovePlayerESP(Target)
        end

        STBB.PlayerESP = {}
    end
end

Players.PlayerAdded:Connect(
    function(Target)

        if STBB.PlayerESPEnabled then

            task.wait(0.3)

            CreatePlayerESP(Target)
        end
    end
)

Players.PlayerRemoving:Connect(
    function(Target)
        RemovePlayerESP(Target)
    end
)

--所属功能：怪物透视

local LivingAddedConnection
local LivingRemovedConnection

local function RemoveMonsterESP(Model)

    local Data =
        STBB.MonsterESP[Model]

    if not Data then
        return
    end

    if Data.Connection then
        Data.Connection:Disconnect()
    end

    if Data.DiedConnection then
        Data.DiedConnection:Disconnect()
    end

    if Data.Highlight then
        Data.Highlight:Destroy()
    end

    if Data.Billboard then
        Data.Billboard:Destroy()
    end

    STBB.MonsterESP[Model] = nil
end

local function CreateMonsterESP(Model)

    if not Model:IsA("Model")
        or IsPlayerCharacter(Model)
    then
        return
    end

    local Humanoid =
        GetHumanoid(Model)

    if not Humanoid then
        return
    end

    RemoveMonsterESP(Model)

    local Highlight =
        Instance.new("Highlight")

    Highlight.Name =
        "STBB_MonsterESP"

    Highlight.Adornee =
        Model

    Highlight.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop

    Highlight.FillColor =
        Color3.fromRGB(
            255,
            0,
            0
        )

    Highlight.FillTransparency =
        0.45

    Highlight.OutlineColor =
        Color3.new(
            1,
            1,
            1
        )

    Highlight.Parent =
        Model

    local Head =
        Model:FindFirstChild(
            "Head"
        )

    local Billboard
    local Connection

    if Head then

        Billboard =
            Instance.new(
                "BillboardGui"
            )

        Billboard.Name =
            "STBB_MonsterHealth"

        Billboard.AlwaysOnTop =
            true

        Billboard.Size =
            UDim2.fromOffset(
                130,
                28
            )

        Billboard.StudsOffset =
            Vector3.new(
                0,
                3,
                0
            )

        Billboard.Parent =
            Head

        local Label =
            Instance.new(
                "TextLabel"
            )

        Label.Size =
            UDim2.fromScale(
                1,
                1
            )

        Label.BackgroundTransparency =
            1

        Label.TextColor3 =
            Color3.new(
                1,
                1,
                1
            )

        Label.TextStrokeTransparency =
            0

        Label.TextScaled =
            true

        Label.Font =
            Enum.Font.SourceSansBold

        Label.Parent =
            Billboard

        Connection =
            RunService.RenderStepped:Connect(
                function()

                    if not STBB.MonsterESP[Model] then
                        return
                    end

                    Label.Text =
                        "HP: " ..
                        math.floor(
                            math.max(
                                0,
                                Humanoid.Health
                            )
                        ) ..
                        "/" ..
                        math.floor(
                            math.max(
                                0,
                                Humanoid.MaxHealth
                            )
                        )
                end
            )
    end

    local DiedConnection =
        Humanoid.Died:Connect(
            function()

                task.delay(
                    0.5,
                    function()
                        RemoveMonsterESP(
                            Model
                        )
                    end
                )
            end
        )

    STBB.MonsterESP[Model] = {
        Highlight = Highlight,
        Billboard = Billboard,
        Connection = Connection,
        DiedConnection = DiedConnection
    }
end

local function ScanLiving()

    local Living =
        workspace:FindFirstChild(
            "Living"
        )

    if not Living then
        return
    end

    for _, Object in ipairs(
        Living:GetDescendants()
    ) do

        if Object:IsA("Model")
            and not IsPlayerCharacter(Object)
        then

            if GetHumanoid(Object) then
                CreateMonsterESP(
                    Object
                )
            end
        end
    end
end

local function SetMonsterESP(Value)

    STBB.MonsterESPEnabled =
        Value

    if LivingAddedConnection then
        LivingAddedConnection:Disconnect()
        LivingAddedConnection = nil
    end

    if LivingRemovedConnection then
        LivingRemovedConnection:Disconnect()
        LivingRemovedConnection = nil
    end

    if not Value then

        for Model in pairs(
            STBB.MonsterESP
        ) do
            RemoveMonsterESP(Model)
        end

        STBB.MonsterESP = {}

        return
    end

    local Living =
        workspace:FindFirstChild(
            "Living"
        )

    if not Living then
        return
    end

    ScanLiving()

    LivingAddedConnection =
        Living.DescendantAdded:Connect(
            function(Object)

                if not STBB.MonsterESPEnabled then
                    return
                end

                task.wait(0.1)

                if Object:IsA("Model")
                    and GetHumanoid(Object)
                    and not IsPlayerCharacter(Object)
                then

                    CreateMonsterESP(
                        Object
                    )
                end
            end
        )

    LivingRemovedConnection =
        Living.DescendantRemoving:Connect(
            function(Object)

                if STBB.MonsterESP[Object] then
                    RemoveMonsterESP(
                        Object
                    )
                end
            end
        )
end

--所属功能：玩家传送

local SelectedPlayer

local function GetPlayerList()

    local List = {}

    for _, Target in ipairs(
        Players:GetPlayers()
    ) do

        if Target ~= Player then

            table.insert(
                List,
                Target.DisplayName ..
                " [" ..
                Target.Name ..
                "]"
            )
        end
    end

    table.sort(List)

    return List
end

local function GetPlayerFromDisplay(Value)

    if not Value then
        return nil
    end

    local Username =
        Value:match(
            "%[(.-)%]"
        )

    return Username
        and Players:FindFirstChild(
            Username
        )
end

local function TeleportToPlayer()

    local Target =
        GetPlayerFromDisplay(
            SelectedPlayer
        )

    if not Target then
        return
    end

    local MyRoot =
        GetRoot(
            GetCharacter()
        )

    local TargetRoot =
        GetRoot(
            Target.Character
        )

    if not MyRoot
        or not TargetRoot
    then
        return
    end

    MyRoot.CFrame =
        TargetRoot.CFrame *
        CFrame.new(
            0,
            4,
            0
        )

    FaceEnemy(Target.Character)

    PlaySound()
end

--所属功能：主页

local Window = WindUI:CreateWindow({
    Title = "STBB",
    Author = "UI",
    Icon = "layout-dashboard",
    Size = UDim2.fromOffset(
        580,
        460
    ),
    Theme = "Dark",
    Resizable = true
})

local TabHome = Window:Tab({
    Title = "主页",
    Icon = "home"
})

local HomeStatus =
    TabHome:Paragraph({
        Title = "STBB",
        Desc = "正在初始化..."
    })

HomeStatus:SetDesc(
    "STBB WindUI\n" ..
    "战斗 / 透视 / 玩家 / 模式 / 拾取 / 波浪\n" ..
    "自动 / 设置"
)

local InfoTab =
    TabHome:Paragraph({
        Title = "主窗口快捷键",
        Desc = "LeftControl（左 Ctrl）"
    })

TabHome:Paragraph({
    Title = "当前版本",
    Desc = "WindUI"
})

TabHome:Paragraph({
    Title = "运行状态",
    Desc = "脚本正在运行"
})

--所属功能：战斗页面

local TabCombat = Window:Tab({
    Title = "战斗",
    Icon = "swords"
})

local CombatStatus =
    TabCombat:Paragraph({
        Title = "自动战斗",
        Desc = "关闭"
    })

TabCombat:Dropdown({
    Title = "选择技能",
    Desc = "选择自动执行的技能",

    Values = SkillList,

    Value = "普攻",

    Multi = false,
    AllowNone = false,

    Callback = function(Value)

        if type(Value) == "table" then
            Value =
                Value[1]
                or "普攻"
        end

        STBB.SelectedSkill =
            tostring(Value)

        CombatStatus:SetDesc(
            "技能：" ..
            STBB.SelectedSkill ..
            "\n状态：" ..
            (
                STBB.SkillEnabled
                and "开启"
                or "关闭"
            )
        )
    end
})

TabCombat:Input({
    Title = "技能间隔",
    Desc = "自动技能执行间隔",

    Placeholder = "0.15",
    Default = "0.15",

    Callback = function(Value)

        local Number =
            tonumber(Value)

        if Number then

            STBB.SkillDelay =
                math.max(
                    0.05,
                    Number
                )
        end
    end
})

TabCombat:Toggle({
    Title = "自动战斗",
    Desc = "锁定最近敌对目标并自动执行技能",

    Default = false,

    Callback = function(Value)

        PlaySound()

        SetSkillEnabled(
            Value
        )

        CombatStatus:SetDesc(
            "技能：" ..
            STBB.SelectedSkill ..
            "\n战斗传送：" ..
            (
                STBB.BattleTPEnabled
                and "开启"
                or "关闭"
            ) ..
            "\n状态：" ..
            (
                Value
                and "开启"
                or "关闭"
            )
        )
    end
})

--所属功能：战斗传送

local BattleTPStatus =
    TabCombat:Paragraph({
        Title = "战斗传送",
        Desc = "关闭"
    })

TabCombat:Dropdown({
    Title = "传送位置",
    Desc = "选择敌人周围的位置",

    Values = BattleTPModes,

    Value = "头顶",

    Multi = false,
    AllowNone = false,

    Callback = function(Value)

        if type(Value) == "table" then
            Value =
                Value[1]
                or "头顶"
        end

        STBB.BattleTPMode =
            tostring(Value)

        BattleTPStatus:SetDesc(
            "位置：" ..
            STBB.BattleTPMode ..
            "\n偏移：" ..
            tostring(
                STBB.BattleTPOffset
            )
        )
    end
})

TabCombat:Slider({
    Title = "传送偏移",
    Desc = "调整传送位置",

    Value = {
        Min = -100,
        Max = 100,
        Default = 0
    },

    Step = 1,

    Callback = function(Value)

        STBB.BattleTPOffset =
            tonumber(Value)
            or 0

        BattleTPStatus:SetDesc(
            "位置：" ..
            STBB.BattleTPMode ..
            "\n偏移：" ..
            tostring(
                STBB.BattleTPOffset
            )
        )
    end
})

TabCombat:Toggle({
    Title = "战斗传送",
    Desc = "攻击时传送到敌人指定位置并自动面向敌人",

    Default = false,

    Callback = function(Value)

        PlaySound()

        STBB.BattleTPEnabled =
            Value

        BattleTPStatus:SetDesc(
            "位置：" ..
            STBB.BattleTPMode ..
            "\n偏移：" ..
            tostring(
                STBB.BattleTPOffset
            ) ..
            "\n状态：" ..
            (
                Value
                and "开启"
                or "关闭"
            )
        )

        CombatStatus:SetDesc(
            "技能：" ..
            STBB.SelectedSkill ..
            "\n战斗传送：" ..
            (
                Value
                and "开启"
                or "关闭"
            ) ..
            "\n自动战斗：" ..
            (
                STBB.SkillEnabled
                and "开启"
                or "关闭"
            )
        )
    end
})

--所属功能：透视页面

local TabESP = Window:Tab({
    Title = "透视",
    Icon = "eye"
})

TabESP:Paragraph({
    Title = "玩家透视",
    Desc = "显示玩家轮廓、生命值和距离"
})

TabESP:Toggle({
    Title = "玩家透视",
    Desc = "玩家红色内部 + 白色描边",

    Default = false,

    Callback = function(Value)

        PlaySound()

        SetPlayerESP(
            Value
        )
    end
})

TabESP:Paragraph({
    Title = "怪物透视",
    Desc = "显示 Living 中的敌对角色"
})

TabESP:Toggle({
    Title = "怪物透视",
    Desc = "怪物红色内部 + 白色描边",

    Default = false,

    Callback = function(Value)

        PlaySound()

        SetMonsterESP(
            Value
        )
    end
})

--所属功能：玩家页面

local TabPlayer = Window:Tab({
    Title = "玩家",
    Icon = "user"
})

local PlayerStatus =
    TabPlayer:Paragraph({
        Title = "人物状态",
        Desc = "正常"
    })

TabPlayer:Input({
    Title = "速度数值",
    Desc = "默认 16",

    Placeholder = "16",
    Default = "16",

    Callback = function(Value)

        local Number =
            tonumber(Value)

        if Number then

            STBB.Speed =
                Number

            if STBB.SpeedEnabled then
                UpdateSpeed()
            end
        end
    end
})

TabPlayer:Toggle({
    Title = "速度修改",
    Desc = "持续锁定移动速度",

    Default = false,

    Callback = function(Value)

        PlaySound()

        SetSpeedEnabled(
            Value
        )

        PlayerStatus:SetDesc(
            "速度：" ..
            (
                Value
                and tostring(
                    STBB.Speed
                )
                or "默认"
            )
        )
    end
})

TabPlayer:Input({
    Title = "跳跃数值",
    Desc = "默认 50",

    Placeholder = "50",
    Default = "50",

    Callback = function(Value)

        local Number =
            tonumber(Value)

        if Number then

            STBB.JumpPower =
                Number

            if STBB.JumpEnabled then
                UpdateJump()
            end
        end
    end
})

TabPlayer:Toggle({
    Title = "跳跃修改",
    Desc = "持续锁定跳跃力度",

    Default = false,

    Callback = function(Value)

        PlaySound()

        SetJumpEnabled(
            Value
        )
    end
})

TabPlayer:Paragraph({
    Title = "玩家传送",
    Desc = "选择玩家后传送"
})

local PlayerDropdown =
    TabPlayer:Dropdown({
        Title = "选择玩家",
        Desc = "选择目标",

        Values = GetPlayerList(),

        Value = nil,

        Multi = false,
        AllowNone = true,

        Callback = function(Value)
            SelectedPlayer = Value
        end
    })

TabPlayer:Button({
    Title = "刷新玩家",
    Desc = "刷新当前服务器玩家",

    Callback = function()

        PlaySound()

        PlayerDropdown:SetValues(
            GetPlayerList()
        )
    end
})

TabPlayer:Button({
    Title = "传送到玩家",
    Desc = "传送到选择的玩家",

    Callback = function()

        TeleportToPlayer()
    end
})

--所属功能：模式页面

local TabMode = Window:Tab({
    Title = "模式",
    Icon = "gamepad-2"
})

TabMode:Paragraph({
    Title = "模式",
    Desc = "模式功能区域"
})

--所属功能：拾取页面

local TabPickup = Window:Tab({
    Title = "拾取",
    Icon = "hand"
})

TabPickup:Paragraph({
    Title = "拾取",
    Desc = "拾取功能区域"
})

--所属功能：波浪页面

local TabWave = Window:Tab({
    Title = "波浪",
    Icon = "waves"
})

TabWave:Paragraph({
    Title = "波浪",
    Desc = "波浪功能区域"
})

--所属功能：设置页面

local TabSettings =
    Window:Tab({
        Title = "设置",
        Icon = "settings"
    })

local OriginalSettings =
    TabSettings:Paragraph({
        Title = "STBB",
        Desc = "正常运行"
    })

TabSettings:Input({
    Title = "亮度数值",
    Desc = "范围 0 - 20",

    Placeholder = "1",
    Default = "1",

    Callback = function(Value)

        local Number =
            tonumber(Value)

        if Number then

            STBB.Brightness =
                math.clamp(
                    Number,
                    0,
                    20
                )

            if STBB.BrightnessEnabled then
                ApplyBrightness()
            end
        end
    end
})

TabSettings:Toggle({
    Title = "亮度修改",
    Desc = "关闭阴影和雾效",

    Default = false,

    Callback = function(Value)

        PlaySound()

        SetBrightnessEnabled(
            Value
        )
    end
})

TabSettings:Button({
    Title = "关闭 STBB",
    Desc = "关闭所有功能",

    Callback = function()

        SetSkillEnabled(false)
        SetSpeedEnabled(false)
        SetJumpEnabled(false)
        SetBrightnessEnabled(false)
        SetPlayerESP(false)
        SetMonsterESP(false)

        STBB.BattleTPEnabled =
            false

        OriginalSettings:SetDesc(
            "STBB 已关闭"
        )

        PlaySound()

        task.wait(0.2)

        pcall(function()
            Window:Destroy()
        end)
    end
})

--所属功能：玩家重生

Player.CharacterAdded:Connect(
    function()

        task.wait(0.5)

        if STBB.SpeedEnabled then
            UpdateSpeed()
        end

        if STBB.JumpEnabled then
            UpdateJump()
        end
    end
)

--所属功能：玩家列表

Players.PlayerAdded:Connect(
    function()

        task.wait(0.2)

        pcall(function()

            PlayerDropdown:SetValues(
                GetPlayerList()
            )
        end)
    end
)

Players.PlayerRemoving:Connect(
    function(Target)

        if SelectedPlayer then

            local Username =
                SelectedPlayer:match(
                    "%[(.-)%]"
                )

            if Username ==
                Target.Name
            then
                SelectedPlayer =
                    nil
            end
        end

        pcall(function()

            PlayerDropdown:SetValues(
                GetPlayerList()
            )
        end)
    end
)

--所属功能：启动

PlaySound()

WindUI:Notify({
    Title = "STBB",
    Content = "加载完成",
    Duration = 3
})