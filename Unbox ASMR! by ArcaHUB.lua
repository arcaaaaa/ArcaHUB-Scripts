-- ArcaHUB Massive Expansion for LO
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Cleanup
if CoreGui:FindFirstChild("ArcaHUB") then CoreGui.ArcaHUB:Destroy() end
if LocalPlayer.PlayerGui:FindFirstChild("ArcaHUB") then LocalPlayer.PlayerGui.ArcaHUB:Destroy() end

local screen = Instance.new("ScreenGui")
screen.Name = "ArcaHUB"
screen.ResetOnSpawn = false
pcall(function() screen.Parent = CoreGui end)
if not screen.Parent then screen.Parent = LocalPlayer.PlayerGui end

-- Global State
local state = {
    -- Main
    AutoFarm = false,
    AutoSpawn = false,
    SpawnDelay = 1.5,
    AutoPlaceCrate = false,
    AutoOpenCrate = false,
    AutoPlaceItem = false,
    Filters = {
        Common = false, Uncommon = false, Rare = false, Epic = true,
        Legendary = true, Godly = true, Mythic = true, Exotic = true
    },
    -- Main 2
    AutoBuyWorker = false,
    AutoUpgradeConveyor = false,
    AutoExpandPlot = false,
    AutoDaily = false,
    AutoRebirth = false,
    -- Settings
    UIScale = 1,
    PerfMode = false,
}

local uiScaleObj = Instance.new("UIScale")
uiScaleObj.Scale = state.UIScale
uiScaleObj.Parent = screen

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 750, 0, 480)
MainFrame.Position = UDim2.new(0.5, -375, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = screen
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Build Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 200, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0, 1, 1, 0)
SidebarLine.Position = UDim2.new(1, -1, 0, 0)
SidebarLine.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SidebarLine.BorderSizePixel = 0
SidebarLine.Parent = Sidebar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 0, 60)
Title.Position = UDim2.new(0, 15, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "ArcaHUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Sidebar

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -30, 0, 20)
SubTitle.Position = UDim2.new(0, 15, 0, 35)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Unbox ASMR"
SubTitle.TextColor3 = Color3.fromRGB(120, 120, 120)
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 12
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Sidebar

local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 1, -80)
tabContainer.Position = UDim2.new(0, 0, 0, 80)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = Sidebar
local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 10)
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.Parent = tabContainer

-- Tab System
local tabs = {}
local currentTab = nil
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -200, 1, 0)
Content.Position = UDim2.new(0, 200, 0, 0)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local function addTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Text = "    " .. name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.Parent = tabContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Visible = false
    contentFrame.Parent = Content
    
    local leftPanel = Instance.new("ScrollingFrame")
    leftPanel.Size = UDim2.new(0.5, -20, 1, -40)
    leftPanel.Position = UDim2.new(0, 15, 0, 20)
    leftPanel.BackgroundTransparency = 1
    leftPanel.ScrollBarThickness = 2
    leftPanel.Parent = contentFrame
    local ll = Instance.new("UIListLayout")
    ll.Padding = UDim.new(0, 10)
    ll.Parent = leftPanel

    local rightPanel = Instance.new("ScrollingFrame")
    rightPanel.Size = UDim2.new(0.5, -20, 1, -40)
    rightPanel.Position = UDim2.new(0.5, 5, 0, 20)
    rightPanel.BackgroundTransparency = 1
    rightPanel.ScrollBarThickness = 2
    rightPanel.Parent = contentFrame
    local rl = Instance.new("UIListLayout")
    rl.Padding = UDim.new(0, 10)
    rl.Parent = rightPanel

    btn.MouseButton1Click:Connect(function()
        if currentTab then
            currentTab.btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            currentTab.btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            currentTab.frame.Visible = false
        end
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        contentFrame.Visible = true
        currentTab = {btn = btn, frame = contentFrame}
    end)

    tabs[name] = {left = leftPanel, right = rightPanel, btn = btn}
    return tabs[name]
end

local tabMain = addTab("Main")
local tabMain2 = addTab("Main 2")
local tabSettings = addTab("Settings")

-- Select Main first
tabMain.btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
tabMain.btn.TextColor3 = Color3.fromRGB(255, 255, 255)
tabMain.btn.Parent.Parent.Parent.Content:GetChildren()[1].Visible = true
currentTab = {btn = tabMain.btn, frame = tabMain.btn.Parent.Parent.Parent.Content:GetChildren()[1]}
-- // Component Builders
local function createSection(parent, title)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 100)
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(30, 30, 30)
    stroke.Parent = frame

    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, -30, 0, 40)
    header.Position = UDim2.new(0, 15, 0, 0)
    header.BackgroundTransparency = 1
    header.Text = string.upper(title)
    header.TextColor3 = Color3.fromRGB(100, 100, 100)
    header.Font = Enum.Font.GothamBold
    header.TextSize = 11
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = frame

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, -40)
    container.Position = UDim2.new(0, 0, 0, 40)
    container.BackgroundTransparency = 1
    container.Parent = frame
    
    local cl = Instance.new("UIListLayout")
    cl.Padding = UDim.new(0, 5)
    cl.Parent = container

    local function updateSize()
        frame.Size = UDim2.new(1, 0, 0, 40 + cl.AbsoluteContentSize.Y + 10)
        parent.CanvasSize = UDim2.new(0, 0, 0, parent.UIListLayout.AbsoluteContentSize.Y + 20)
    end
    cl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSize)
    task.delay(0.1, updateSize)
    return container
end

local function createToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 36, 0, 20)
    toggleBtn.Position = UDim2.new(1, -50, 0.5, -10)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40)
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = frame
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    circle.BackgroundColor3 = default and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(255, 255, 255)
    circle.Parent = toggleBtn
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local currentState = default
    toggleBtn.MouseButton1Click:Connect(function()
        currentState = not currentState
        local goalColor = currentState and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40)
        local goalPos = currentState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        local goalCircleCol = currentState and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(255, 255, 255)

        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = goalColor}):Play()
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = goalPos, BackgroundColor3 = goalCircleCol}):Play()
        callback(currentState)
    end)
end

local function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderBg = Instance.new("TextButton")
    sliderBg.Size = UDim2.new(0, 110, 0, 4)
    sliderBg.Position = UDim2.new(0.45, 0, 0.5, -2)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBg.Text = ""
    sliderBg.AutoButtonColor = false
    sliderBg.Parent = frame
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderFill.Parent = sliderBg
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

    local valInput = Instance.new("TextBox")
    valInput.Size = UDim2.new(0, 35, 0, 20)
    valInput.Position = UDim2.new(1, -45, 0.5, -10)
    valInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    valInput.Text = tostring(default)
    valInput.TextColor3 = Color3.fromRGB(200, 200, 200)
    valInput.Font = Enum.Font.Gotham
    valInput.TextSize = 11
    valInput.Parent = frame
    Instance.new("UICorner", valInput).CornerRadius = UDim.new(0, 4)

    local currentVal = default
    local dragging = false
    sliderBg.MouseButton1Down:Connect(function() dragging = true end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UIS:GetMouseLocation().X
            local relPos = mousePos - sliderBg.AbsolutePosition.X
            local pct = math.clamp(relPos / sliderBg.AbsoluteSize.X, 0, 1)
            local val = min + (max - min) * pct
            val = math.floor(val * 10) / 10
            currentVal = val
            sliderFill.Size = UDim2.new(pct, 0, 1, 0)
            valInput.Text = tostring(val)
            callback(val)
        end
    end)

    valInput.FocusLost:Connect(function()
        local num = tonumber(valInput.Text)
        if num then
            num = math.clamp(num, min, max)
            local pct = (num - min) / (max - min)
            currentVal = num
            sliderFill.Size = UDim2.new(pct, 0, 1, 0)
            valInput.Text = tostring(num)
            callback(num)
        else
            valInput.Text = tostring(currentVal)
        end
    end)
end

local function createMultiDropdown(parent, text, options, defaultStates, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    frame.ClipsDescendants = true

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -30, 0, 30)
    btn.Position = UDim2.new(0, 15, 0, 5)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = "  " .. text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.Position = UDim2.new(1, -25, 0.5, -10)
    icon.BackgroundTransparency = 1
    icon.Text = "v"
    icon.TextColor3 = Color3.fromRGB(150, 150, 150)
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 12
    icon.Parent = btn

    local listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(1, -30, 0, #options * 30)
    listFrame.Position = UDim2.new(0, 15, 0, 40)
    listFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    listFrame.Parent = frame
    Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 6)

    local y = 0
    local states = defaultStates
    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 30)
        optBtn.Position = UDim2.new(0, 0, 0, y)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = "    " .. opt .. (states[opt] and " (ON)" or " (OFF)")
        optBtn.TextColor3 = states[opt] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 12
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.Parent = listFrame
        
        optBtn.MouseButton1Click:Connect(function()
            states[opt] = not states[opt]
            optBtn.Text = "    " .. opt .. (states[opt] and " (ON)" or " (OFF)")
            optBtn.TextColor3 = states[opt] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
            callback(states)
        end)
        y = y + 30
    end

    local expanded = false
    btn.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            TweenService:Create(frame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 45 + (#options * 30))}):Play()
            icon.Text = "^"
        else
            TweenService:Create(frame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 40)}):Play()
            icon.Text = "v"
        end
    end)
end

local function createInput(parent, text, placeholder, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -30, 0, 15)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(150, 150, 150)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -30, 0, 25)
    input.Position = UDim2.new(0, 15, 0, 15)
    input.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    input.PlaceholderText = placeholder
    input.Text = ""
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.Font = Enum.Font.Gotham
    input.TextSize = 13
    input.Parent = frame
    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)

    input.FocusLost:Connect(function(enterPressed)
        callback(input.Text, enterPressed)
    end)
end

local function createButton(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -30, 0, 30)
    btn.Position = UDim2.new(0, 15, 0, 5)
    btn.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.AutoButtonColor = true
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(callback)
end
-- // Build MAIN Tab
local secMainFarm = createSection(tabMain.left, "AUTO FARMING")
createToggle(secMainFarm, "Auto Farm Items", state.AutoFarm, function(val) state.AutoFarm = val end)

local secMainCrate = createSection(tabMain.left, "AUTO CRATE")
createToggle(secMainCrate, "Auto Place Crate", state.AutoPlaceCrate, function(val) state.AutoPlaceCrate = val end)
createToggle(secMainCrate, "Auto Open Crate", state.AutoOpenCrate, function(val) state.AutoOpenCrate = val end)
createToggle(secMainCrate, "Auto Place Item", state.AutoPlaceItem, function(val) state.AutoPlaceItem = val end)

local secMainBuy = createSection(tabMain.right, "AUTO BUY CRATE")
createSlider(secMainBuy, "Auto Start Delay", 0, 10, state.SpawnDelay, function(val) state.SpawnDelay = val end)
createToggle(secMainBuy, "Auto Spawn Crate", state.AutoSpawn, function(val) state.AutoSpawn = val end)
createToggle(secMainBuy, "Auto Buy Crate", state.AutoBuyCrate, function(val) state.AutoBuyCrate = val end)
local rarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Godly", "Mythic", "Exotic"}
createMultiDropdown(secMainBuy, "Rarity Filters", rarities, state.Filters, function(val) state.Filters = val end)

-- // Build MAIN 2 Tab
local secMain2Worker = createSection(tabMain2.left, "WORKERS & UPGRADES")
createToggle(secMain2Worker, "Auto Buy Worker", state.AutoBuyWorker, function(val) state.AutoBuyWorker = val end)
createToggle(secMain2Worker, "Auto Upgrade Conveyor", state.AutoUpgradeConveyor, function(val) state.AutoUpgradeConveyor = val end)
createToggle(secMain2Worker, "Auto Expand Plot", state.AutoExpandPlot, function(val) state.AutoExpandPlot = val end)

local secMain2Rewards = createSection(tabMain2.right, "REWARDS & REBIRTH")
createToggle(secMain2Rewards, "Auto Daily Reward", state.AutoDaily, function(val) state.AutoDaily = val end)
createToggle(secMain2Rewards, "Auto Rebirth", state.AutoRebirth, function(val) state.AutoRebirth = val end)

-- // Build SETTINGS Tab
local secSettingsUi = createSection(tabSettings.left, "UI & CODES")
createSlider(secSettingsUi, "UI Scale", 0.5, 2, state.UIScale, function(val) 
    state.UIScale = val
    uiScaleObj.Scale = val
end)

-- Code array (LO can edit these codes manually)
local workingCodes = {"UPDATE1", "RELEASE", "FREEWORKER"}
createButton(secSettingsUi, "Redeem All Codes", function()
    -- This fires code redemption (LO please update the remote path if needed)
    local remote = RS:FindFirstChild("RedeemCode", true) or RS:FindFirstChild("PromoCode", true)
    for _, code in ipairs(workingCodes) do
        if remote then
            pcall(function() remote:InvokeServer(code) end)
        else
            warn("Redeem Remote Not Found! Check the script.")
        end
    end
end)

local secSettingsPerf = createSection(tabSettings.right, "PERFORMANCE & INFO")
createToggle(secSettingsPerf, "Performance Mode", state.PerfMode, function(val) 
    state.PerfMode = val
    if state.PerfMode then
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
            if v:IsA("Texture") or v:IsA("Decal") then v.Transparency = 1 end
        end
        game.Lighting.GlobalShadows = false
    else
        game.Lighting.GlobalShadows = true
        -- (Restoring textures requires storing original states, which is heavy. 
        -- Rejoining is usually how perf mode is reverted in exploit scripts)
    end
end)

local eventInfoLabel = Instance.new("TextLabel")
eventInfoLabel.Size = UDim2.new(1, -20, 0, 50)
eventInfoLabel.Position = UDim2.new(0, 10, 0, 0)
eventInfoLabel.BackgroundTransparency = 1
eventInfoLabel.Text = "Event: Checking...\\nNext: Calculating..."
eventInfoLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
eventInfoLabel.Font = Enum.Font.GothamMedium
eventInfoLabel.TextSize = 12
eventInfoLabel.Parent = createSection(tabSettings.right, "LIVE EVENT INFO")

-- // Core Logic Loops
local lastSpawn = 0
local lastDaily = 0
local lastRebirth = 0
local isPlacingCrate = false
local isPlacingItem = false

local function getFreeCellCFrame(plot, item)
    local cells = plot:FindFirstChild("Placement") and plot.Placement:FindFirstChild("Unlocked")
    local lockedFolder = plot:FindFirstChild("Placement") and plot.Placement:FindFirstChild("Locked")
    local boundsPart = plot:FindFirstChild("Placement") and plot.Placement:FindFirstChild("Bounds")
    if not cells then return nil end

    local isCrate = item.Name:match("Crate")
    local previewModel
    local v14 = Vector3.new(0, 0.015, 0)
    local v13 = Vector3.new(4, 1, 4)
    local bbSize = Vector3.new(4, 4, 4)

    if isCrate then
        local crateType = item:GetAttribute("CrateTemplateName") or item.Name
        local crates = game:GetService("ReplicatedStorage"):FindFirstChild("CratePlacementPreviews")
        if crates then previewModel = crates:FindFirstChild(crateType) end
        if previewModel then
            local bbCFrame, size = previewModel:GetBoundingBox()
            bbSize = size
            local pivot = previewModel:GetPivot()
            v13 = Vector3.new(math.max(bbSize.X * 0.94, 0.5), 1.4, math.max(bbSize.Z * 0.94, 0.5))
            v14 = pivot:VectorToObjectSpace(pivot.Position - (bbCFrame.Position - bbCFrame.UpVector * (bbSize.Y / 2)))
        end
    else
        local templateName = item:GetAttribute("ASMRTemplateName") or item.Name
        local previews = game:GetService("ReplicatedStorage"):FindFirstChild("ASMRPlacementPreviews")
        if previews then previewModel = previews:FindFirstChild(templateName) end
        if previewModel then
            local bbCFrame, size = previewModel:GetBoundingBox()
            bbSize = size
            local pivot = previewModel:GetPivot()
            v14 = pivot:VectorToObjectSpace(pivot.Position - (bbCFrame.Position - bbCFrame.UpVector * (bbSize.Y / 2)))
            local v7 = previewModel.PrimaryPart or previewModel:FindFirstChild("Hitbox", true) or previewModel:FindFirstChild("Base", true)
            local rawV13 = v7 and v7:IsA("BasePart") and Vector3.new(v7.Size.X, bbSize.Y, v7.Size.Z) or bbSize
            v13 = Vector3.new(math.max(rawV13.X * 0.94, 0.5), 1.4, math.max(rawV13.Z * 0.94, 0.5))
        end
    end

    local function isPlacementValid(targetCFrame, rot)
        if boundsPart then
            local localPos = boundsPart.CFrame:PointToObjectSpace(targetCFrame.Position)
            local limitX, limitZ
            if isCrate then
                local v16 = math.max(bbSize.X, bbSize.Z) * 1.77 / 2
                limitX = boundsPart.Size.X / 2 - v16
                limitZ = boundsPart.Size.Z / 2 - v16
            else
                local v20 = math.abs(math.cos(rot))
                local v22 = math.abs(math.sin(rot))
                local v25 = Vector3.new(v13.X * v20 + v13.Z * v22, v13.Y, v13.X * v22 + v13.Z * v20)
                limitX = boundsPart.Size.X / 2 - v25.X / 2
                limitZ = boundsPart.Size.Z / 2 - v25.Z / 2
            end
            
            if limitX <= 0 or limitZ <= 0 or math.abs(localPos.X) > limitX or math.abs(localPos.Z) > limitZ then
                return false
            end
        end

        local v4 = CFrame.new(targetCFrame.Position - targetCFrame:VectorToWorldSpace(v14)) * (targetCFrame - targetCFrame.Position)
        local params = OverlapParams.new()
        params.FilterType = Enum.RaycastFilterType.Include
        params.RespectCanCollide = false

        params.FilterDescendantsInstances = {cells}
        local overlapsUnlocked = workspace:GetPartBoundsInBox(v4, v13, params)
        local isOnPlaceable = false
        for _, v in ipairs(overlapsUnlocked) do
            if v:IsA("BasePart") and v:GetAttribute("Placeable") == true then
                isOnPlaceable = true
                break
            end
        end
        if not isOnPlaceable then return false end

        if lockedFolder then
            params.FilterDescendantsInstances = {lockedFolder}
            local overlapsLocked = workspace:GetPartBoundsInBox(v4, v13, params)
            for _, v in ipairs(overlapsLocked) do
                if v:IsA("BasePart") then
                    local isGrass = false
                    local curr = v
                    while curr and curr ~= plot.Placement do
                        if curr.Name == "Grass" then isGrass = true break end
                        curr = curr.Parent
                    end
                    if not isGrass and v:GetAttribute("Placeable") == false then return false end
                end
            end
        end

        local toCheck = {"PlacedCrates", "ASMR"}
        for _, folderName in ipairs(toCheck) do
            local folder = plot:FindFirstChild(folderName)
            if folder then
                params.FilterDescendantsInstances = {folder}
                local overlaps = workspace:GetPartBoundsInBox(v4, v13, params)
                for _, v in ipairs(overlaps) do
                    if v:IsA("BasePart") then return false end
                end
            end
        end
        return true
    end

    local offsets = isCrate and {-6, -3, 0, 3, 6} or {-6, -4, -2, 0, 2, 4, 6}
    local rotations = isCrate and {0} or {0, math.pi/2, math.pi, -math.pi/2}

    for _, cell in ipairs(cells:GetChildren()) do
        for _, offsetX in ipairs(offsets) do
            for _, offsetZ in ipairs(offsets) do
                for _, rot in ipairs(rotations) do
                    local baseCFrame = cell.CFrame * CFrame.new(offsetX, cell.Size.Y / 2, offsetZ) * CFrame.Angles(0, rot, 0)
                    local targetCFrame = CFrame.new(baseCFrame.Position + baseCFrame:VectorToWorldSpace(v14)) * (baseCFrame - baseCFrame.Position)
                    if isPlacementValid(targetCFrame, rot) then
                        return targetCFrame
                    end
                end
            end
        end
    end
    return nil
end

-- Function to get the local player's active plot
local function getMyPlot()
    local plotsFolder = workspace:FindFirstChild("Plots") and workspace.Plots:FindFirstChild("ActivePlots")
    if plotsFolder then
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            if plot:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
                return plot
            end
        end
    end
    return nil
end

RunService.RenderStepped:Connect(function()
    -- Auto Farm (Walk around ASMR items)
    if state.AutoFarm then
        local myPlot = getMyPlot()
        if myPlot and myPlot:FindFirstChild("ASMR") then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, item in ipairs(myPlot.ASMR:GetChildren()) do
                    if item:IsA("Model") and item.PrimaryPart then
                        -- Teleport to the item to collect money!
                        hrp.CFrame = item:GetPivot() * CFrame.new(0, 1, 0)
                        break -- Just do one per frame
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        local myPlot = getMyPlot()
        
        -- Removed Event Info Updater as UI element no longer exists

        -- Auto Spawn Crate
        if state.AutoSpawn then
            local conveyorRemote = RS:FindFirstChild("ConveyorButtonPress", true)
            if conveyorRemote and tick() - lastSpawn >= state.SpawnDelay then
                lastSpawn = tick()
                pcall(function() conveyorRemote:FireServer() end)
            end
        end
        
        -- Auto Buy Crate
        if state.AutoBuyCrate then
            for _, prompt in ipairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.Name == "CrateBuyPrompt" then
                    local crateModel = prompt.Parent and prompt.Parent.Parent
                    if crateModel then
                        -- Check rarity text on the crate's BillboardGui
                        local rarityFound = nil
                        for _, v in ipairs(crateModel:GetDescendants()) do
                            if v:IsA("TextLabel") and state.Filters[v.Text] ~= nil then
                                rarityFound = v.Text
                                break
                            end
                        end
                        
                        -- Buy it if the filter is ON!
                        if rarityFound and state.Filters[rarityFound] then
                            pcall(function()
                                if fireproximityprompt then
                                    fireproximityprompt(prompt, 1)
                                else
                                    prompt:InputHoldBegin()
                                    task.wait(prompt.HoldDuration + 0.1)
                                    prompt:InputHoldEnd()
                                end
                            end)
                        end
                    end
                end
            end
        end
        
        -- Auto Place Crate
        if state.AutoPlaceCrate and myPlot and not isPlacingCrate then
            local placeRemote = RS:FindFirstChild("RequestPlaceCrate", true)
            local currentCrates = myPlot:FindFirstChild("PlacedCrates") and #myPlot.PlacedCrates:GetChildren() or 0
            local maxCrates = 20
            if currentCrates < maxCrates and placeRemote then
                local itemsToPlace = {}
                local char = LocalPlayer.Character
                if char then
                    for _, i in ipairs(char:GetChildren()) do
                        if i:IsA("Tool") and i.Name:match("Crate") then table.insert(itemsToPlace, i) end
                    end
                end
                local bp = LocalPlayer:FindFirstChild("Backpack")
                if bp then
                    for _, i in ipairs(bp:GetChildren()) do
                        if i:IsA("Tool") and i.Name:match("Crate") then table.insert(itemsToPlace, i) end
                    end
                end
                
                if #itemsToPlace > 0 then
                    local item = itemsToPlace[1]
                    if char and char:FindFirstChild("Humanoid") then
                        local targetCFrame = getFreeCellCFrame(myPlot, item)
                        if targetCFrame then
                            isPlacingCrate = true
                            task.spawn(function()
                                char.Humanoid:EquipTool(item)
                                task.wait(0.3)
                                pcall(function() placeRemote:FireServer(targetCFrame) end)
                                task.wait(1.2)
                                isPlacingCrate = false
                            end)
                        end
                    end
                end
            end
        end

        -- Auto Open Crate
        if state.AutoOpenCrate and myPlot then
            local placed = myPlot:FindFirstChild("PlacedCrates")
            if placed then
                for _, crate in ipairs(placed:GetChildren()) do
                    local prompt = crate:FindFirstChild("OpenCratePrompt", true)
                    if prompt and prompt.Enabled and crate:GetAttribute("Ready") == true then
                        pcall(function()
                            if fireproximityprompt then
                                fireproximityprompt(prompt, 1)
                            else
                                prompt:InputHoldBegin()
                                task.wait(prompt.HoldDuration + 0.1)
                                prompt:InputHoldEnd()
                            end
                        end)
                    end
                end
            end
        end

        -- Auto Place Item
        if state.AutoPlaceItem and myPlot and not isPlacingItem then
            local placeItemRemote = RS:FindFirstChild("RequestPlaceASMR", true)
            local currentItems = myPlot:FindFirstChild("ASMR") and #myPlot.ASMR:GetChildren() or 0
            local maxItems = 50 
            if currentItems < maxItems and placeItemRemote then
                local itemsToPlace = {}
                local char = LocalPlayer.Character
                if char then
                    for _, i in ipairs(char:GetChildren()) do
                        if i:IsA("Tool") and not (i.Name:match("Crate") or i.Name:match("Worker") or i.Name:match("Pickup")) then 
                            table.insert(itemsToPlace, i) 
                        end
                    end
                end
                local bp = LocalPlayer:FindFirstChild("Backpack")
                if bp then
                    for _, i in ipairs(bp:GetChildren()) do
                        if i:IsA("Tool") and not (i.Name:match("Crate") or i.Name:match("Worker") or i.Name:match("Pickup")) then 
                            table.insert(itemsToPlace, i) 
                        end
                    end
                end
                
                if #itemsToPlace > 0 then
                    local item = itemsToPlace[1]
                    if char and char:FindFirstChild("Humanoid") then
                        local targetCFrame = getFreeCellCFrame(myPlot, item)
                        if targetCFrame then
                            isPlacingItem = true
                            task.spawn(function()
                                char.Humanoid:EquipTool(item)
                                task.wait(0.3)
                                pcall(function() placeItemRemote:FireServer(targetCFrame) end)
                                task.wait(1.2)
                                isPlacingItem = false
                            end)
                        end
                    end
                end
            end
        end

        -- Auto Buy Worker
        if state.AutoBuyWorker then
            local buyWorker = RS:FindFirstChild("BuyWorker", true)
            if buyWorker then pcall(function() buyWorker:FireServer() end) end
        end

        -- Auto Upgrade Conveyor
        if state.AutoUpgradeConveyor then
            local myPlot = getMyPlot()
            if myPlot then
                local upgradeBtn = myPlot:FindFirstChild("UpgradeConveyorButton")
                local btnPart = upgradeBtn and upgradeBtn:FindFirstChild("ButtonPart")
                if btnPart and btnPart:FindFirstChild("TouchInterest") then
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        pcall(function()
                            if firetouchinterest then
                                firetouchinterest(hrp, btnPart, 0)
                                task.wait()
                                firetouchinterest(hrp, btnPart, 1)
                            else
                                hrp.CFrame = btnPart.CFrame * CFrame.new(0, 2, 0)
                            end
                        end)
                    end
                end
            end
        end

        -- Auto Expand Plot
        if state.AutoExpandPlot then
            local myPlot = getMyPlot()
            if myPlot then
                local lockedFolder = myPlot:FindFirstChild("Placement") and myPlot.Placement:FindFirstChild("Locked")
                if lockedFolder then
                    for _, cell in ipairs(lockedFolder:GetChildren()) do
                        local prompt = cell:FindFirstChild("ExpansionPurchasePrompt")
                        if prompt and prompt.Enabled then
                            pcall(function()
                                if fireproximityprompt then
                                    fireproximityprompt(prompt, 1)
                                else
                                    prompt:InputHoldBegin()
                                    task.wait(prompt.HoldDuration + 0.1)
                                    prompt:InputHoldEnd()
                                end
                            end)
                        end
                    end
                end
            end
        end

        -- Auto Daily Reward (checks once every 10 seconds approx to reduce spam, turning itself off if claimed)
        if state.AutoDaily and tick() - lastDaily > 10 then
            lastDaily = tick()
            local claimDaily = RS:FindFirstChild("ClaimDailyReward", true)
            if claimDaily then 
                local success, result = pcall(function() return claimDaily:InvokeServer() end)
                if success and result == "Claimed" or result == "AlreadyClaimed" then
                    state.AutoDaily = false
                    -- Update the toggle UI visually
                    -- This requires referencing the toggle button, so LO will just see it stop spamming
                end
            end
        end

        -- Auto Rebirth
        if state.AutoRebirth and tick() - lastRebirth > 5 then
            lastRebirth = tick()
            local reqRebirth = RS:FindFirstChild("RequestRebirth", true)
            if reqRebirth then pcall(function() reqRebirth:InvokeServer() end) end
        end
    end
end)

print("ArcaHUB V3 Loaded Successfully!")
