-- Synapse X Neo - Full Lua Script Executor with session password memory

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local PASSWORD = "Duaiukam"
local PasswordAccepted = false

-- Create ScreenGui container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SynapseXNeoGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Create the main executor frame (hidden initially)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -60, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Synapse X Neo"
TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Close button on TitleBar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 50, 1, 0)
CloseBtn.Position = UDim2.new(1, -50, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
CloseBtn.Text = "Close"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Parent = TitleBar

-- TextBox for Lua code input
local CodeBox = Instance.new("TextBox")
CodeBox.Name = "CodeBox"
CodeBox.Size = UDim2.new(1, -20, 1, -90)
CodeBox.Position = UDim2.new(0, 10, 0, 40)
CodeBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
CodeBox.TextColor3 = Color3.new(1,1,1)
CodeBox.Font = Enum.Font.Code
CodeBox.TextSize = 14
CodeBox.TextWrapped = true
CodeBox.ClearTextOnFocus = false
CodeBox.MultiLine = true
CodeBox.PlaceholderText = "-- Enter your Lua script here"
CodeBox.Parent = MainFrame

-- Execute button
local ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Name = "ExecuteBtn"
ExecuteBtn.Size = UDim2.new(0.48, -10, 0, 40)
ExecuteBtn.Position = UDim2.new(0, 10, 1, -40)
ExecuteBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
ExecuteBtn.Text = "Execute"
ExecuteBtn.Font = Enum.Font.GothamBold
ExecuteBtn.TextSize = 18
ExecuteBtn.TextColor3 = Color3.new(1,1,1)
ExecuteBtn.Parent = MainFrame

-- Clear button
local ClearBtn = Instance.new("TextButton")
ClearBtn.Name = "ClearBtn"
ClearBtn.Size = UDim2.new(0.48, -10, 0, 40)
ClearBtn.Position = UDim2.new(0.52, 0, 1, -40)
ClearBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 120)
ClearBtn.Text = "Clear"
ClearBtn.Font = Enum.Font.GothamBold
ClearBtn.TextSize = 18
ClearBtn.TextColor3 = Color3.new(1,1,1)
ClearBtn.Parent = MainFrame

-- Notification label (bottom)
local NotificationLabel = Instance.new("TextLabel")
NotificationLabel.Name = "NotificationLabel"
NotificationLabel.Size = UDim2.new(1, -20, 0, 25)
NotificationLabel.Position = UDim2.new(0, 10, 1, -70)
NotificationLabel.BackgroundTransparency = 1
NotificationLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
NotificationLabel.Font = Enum.Font.Gotham
NotificationLabel.TextSize = 16
NotificationLabel.Text = ""
NotificationLabel.TextXAlignment = Enum.TextXAlignment.Center
NotificationLabel.Parent = MainFrame

-- Toggle Icon (draggable)
local toggleIcon = Instance.new("ImageButton")
toggleIcon.Name = "ToggleIcon"
toggleIcon.Size = UDim2.new(0, 45, 0, 45)
toggleIcon.Position = UDim2.new(0, 15, 0.5, -22)
toggleIcon.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleIcon.AutoButtonColor = false
toggleIcon.Parent = ScreenGui
toggleIcon.Image = "rbxassetid://7072711791" -- You can change icon here
toggleIcon.Active = true
toggleIcon.Draggable = true

-- Tween function for fade in/out animations
local function tweenVisibility(frame, visible)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {}
    if visible then
        goal.BackgroundTransparency = 0
        if frame:IsA("TextLabel") or frame:IsA("TextBox") then
            goal.TextTransparency = 0
        end
        frame.Visible = true
        local tween = TweenService:Create(frame, tweenInfo, goal)
        tween:Play()
    else
        goal.BackgroundTransparency = 1
        if frame:IsA("TextLabel") or frame:IsA("TextBox") then
            goal.TextTransparency = 1
        end
        local tween = TweenService:Create(frame, tweenInfo, goal)
        tween:Play()
        tween.Completed:Connect(function()
            frame.Visible = false
        end)
    end
end

-- Show notification for 3 seconds
local function showNotification(text)
    NotificationLabel.Text = text
    tweenVisibility(NotificationLabel, true)
    delay(3, function()
        tweenVisibility(NotificationLabel, false)
    end)
end

-- Password Prompt UI
local passwordGui = Instance.new("ScreenGui")
passwordGui.Name = "PasswordPromptGui"
passwordGui.Parent = game.CoreGui
passwordGui.ResetOnSpawn = false

local passFrame = Instance.new("Frame")
passFrame.Size = UDim2.new(0, 350, 0, 140)
passFrame.Position = UDim2.new(0.5, -175, 0.5, -70)
passFrame.AnchorPoint = Vector2.new(0.5, 0.5)
passFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
passFrame.BorderSizePixel = 0
passFrame.Parent = passwordGui
passFrame.ClipsDescendants = true
passFrame.Active = true
passFrame.Draggable = true

local passTitle = Instance.new("TextLabel")
passTitle.Size = UDim2.new(1, -20, 0, 35)
passTitle.Position = UDim2.new(0, 10, 0, 10)
passTitle.BackgroundTransparency = 1
passTitle.Text = "Enter Password"
passTitle.TextColor3 = Color3.fromRGB(220,220,220)
passTitle.Font = Enum.Font.GothamBold
passTitle.TextSize = 20
passTitle.Parent = passFrame

local passBox = Instance.new("TextBox")
passBox.Size = UDim2.new(1, -20, 0, 40)
passBox.Position = UDim2.new(0, 10, 0, 55)
passBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
passBox.TextColor3 = Color3.new(1,1,1)
passBox.Font = Enum.Font.Code
passBox.TextSize = 18
passBox.PlaceholderText = "Password"
passBox.ClearTextOnFocus = false
passBox.TextScaled = false
passBox.TextEditable = true
passBox.TextWrapped = false
passBox.Parent = passFrame
passBox.ClearTextOnFocus = true
passBox.TextStrokeTransparency = 1
passBox.TextStrokeColor3 = Color3.new(0,0,0)
passBox.TextTransparency = 0
passBox.TextXAlignment = Enum.TextXAlignment.Left
passBox.TextYAlignment = Enum.TextYAlignment.Center
passBox.TextEditable = true
passBox.TextWrapped = false
passBox.TextTruncate = Enum.TextTruncate.None
passBox.Text = ""
passBox.ClearTextOnFocus = false
passBox.MultiLine = false
passBox.Text = ""
passBox.TextScaled = true
passBox.TextEditable = true
passBox.TextStrokeTransparency = 1
passBox.TextStrokeColor3 = Color3.new(0,0,0)
passBox.TextTransparency = 0
passBox.TextXAlignment = Enum.TextXAlignment.Left
passBox.TextYAlignment = Enum.TextYAlignment.Center
passBox.TextWrapped = false
passBox.TextTruncate = Enum.TextTruncate.None

local submitPassBtn = Instance.new("TextButton")
submitPassBtn.Size = UDim2.new(0.5, -15, 0, 40)
submitPassBtn.Position = UDim2.new(0, 10, 1, -50)
submitPassBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
submitPassBtn.Font = Enum.Font.GothamBold
submitPassBtn.TextSize = 18
submitPassBtn.TextColor3 = Color3.new(1,1,1)
submitPassBtn.Text = "Submit"
submitPassBtn.Parent = passFrame

local cancelPassBtn = Instance.new("TextButton")
cancelPassBtn.Size = UDim2.new(0.5, -15, 0, 40)
cancelPassBtn.Position = UDim2.new(0.5, 5, 1, -50)
cancelPassBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
cancelPassBtn.Font = Enum.Font.GothamBold
cancelPassBtn.TextSize = 18
cancelPassBtn.TextColor3 = Color3.new(1,1,1)
cancelPassBtn.Text = "Cancel"
cancelPassBtn.Parent = passFrame

-- Password attempt limit
local maxAttempts = 50
local attempts = 0

-- Functions
local function closeExecutor()
    -- Animate close
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local tween = TweenService:Create(MainFrame, tweenInfo, {BackgroundTransparency = 1})
    tween:Play()
    tween.Completed:Wait()
    MainFrame.Visible = false
    MainFrame.BackgroundTransparency = 0
end

local function openExecutor()
    MainFrame.Visible = true
    MainFrame.BackgroundTransparency = 1
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(MainFrame, tweenInfo, {BackgroundTransparency = 0})
    tween:Play()
end

local function toggleExecutor()
    if MainFrame.Visible then
        closeExecutor()
    else
        -- If password accepted already, skip prompt
        if PasswordAccepted then
            openExecutor()
        else
            passwordGui.Enabled = true
        end
    end
end

-- Submit password function
local function submitPassword()
    if attempts >= maxAttempts then
        showNotification("Max password attempts reached! Access denied.")
        passwordGui.Enabled = false
        return
    end

    if passBox.Text == PASSWORD then
        PasswordAccepted = true
        passwordGui.Enabled = false
        openExecutor()
        showNotification("Password accepted! Welcome to Synapse X Neo.")
    else
        attempts = attempts + 1
        showNotification("Incorrect password! Attempts: "..attempts.."/"..maxAttempts)
        if attempts >= maxAttempts then
            showNotification("Max password attempts reached! Access denied.")
            passwordGui.Enabled = false
        end
    end
    passBox.Text = ""
end

-- Button Events
toggleIcon.MouseButton1Click:Connect(toggleExecutor)
CloseBtn.MouseButton1Click:Connect(closeExecutor)
ExecuteBtn.MouseButton1Click:Connect(function()
    local scriptText = CodeBox.Text
    if scriptText == "" then
        showNotification("No script to execute!")
        return
    end
    local success, err = pcall(function()
        loadstring(scriptText)()
    end)
    if success then
        showNotification("Script executed successfully!")
    else
        showNotification("Error executing script: "..err)
    end
end)
ClearBtn.MouseButton1Click:Connect(function()
    CodeBox.Text = ""
end)

submitPassBtn.MouseButton1Click:Connect(submitPassword)
cancelPassBtn.MouseButton1Click:Connect(function()
    passwordGui.Enabled = false
end)

-- Initially hide notification
NotificationLabel.Visible = false
passwordGui.Enabled = false

-- Return this so user can disable GUI if needed
return {
    ToggleIcon = toggleIcon,
    ExecutorFrame = MainFrame,
    PasswordGui = passwordGui
}
