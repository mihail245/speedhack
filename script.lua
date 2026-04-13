-- SpeedHack GUI with WalkSpeed ONLY + Close button
-- Works on any Roblox executor (PC + Mobile)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local originalWalkSpeed = humanoid.WalkSpeed
local originalJumpPower = 50 -- Default Roblox JumpPower (unchanged)

-- State
local speedhack = {
    enabled = false,
    speed = 1.0,
    menuOpen = true,
    position = UDim2.new(0.5, -150, 0.5, -100)
}

-- GUI Elements
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedHackGUI"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 200) -- Сразу полный размер
MainFrame.Position = speedhack.position
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = screenGui

-- Shadow
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.7
shadow.BorderSizePixel = 0
shadow.Parent = MainFrame

-- Title bar (draggable)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, -90, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "⚡ SPEED HACK"
TitleText.TextColor3 = Color3.fromRGB(255, 200, 100)
TitleText.TextSize = 14
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Font = Enum.Font.GothamBold
TitleText.Parent = TitleBar

-- Toggle menu button (≡ / ×) - сворачивание
local ToggleMenuBtn = Instance.new("TextButton")
ToggleMenuBtn.Name = "ToggleMenuBtn"
ToggleMenuBtn.Size = UDim2.new(0, 30, 1, 0)
ToggleMenuBtn.Position = UDim2.new(1, -60, 0, 0)
ToggleMenuBtn.BackgroundTransparency = 1
ToggleMenuBtn.Text = "≡"
ToggleMenuBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleMenuBtn.TextSize = 20
ToggleMenuBtn.Font = Enum.Font.GothamBold
ToggleMenuBtn.Parent = TitleBar

-- CLOSE BUTTON (✕) - ПОЛНОЕ ЗАКРЫТИЕ GUI
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

-- Hover эффект для кнопки закрытия
CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 50, 50)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 100, 100)}):Play()
end)

-- Закрытие GUI при нажатии на ✕
CloseBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Content panel (collapsible)
local ContentPanel = Instance.new("Frame")
ContentPanel.Name = "ContentPanel"
ContentPanel.Size = UDim2.new(1, 0, 1, -30)
ContentPanel.Position = UDim2.new(0, 0, 0, 30)
ContentPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ContentPanel.BorderSizePixel = 0
ContentPanel.Visible = true
ContentPanel.Parent = MainFrame

-- Speed input field
local SpeedInput = Instance.new("TextBox")
SpeedInput.Name = "SpeedInput"
SpeedInput.Size = UDim2.new(0, 120, 0, 30)
SpeedInput.Position = UDim2.new(0, 10, 0, 10)
SpeedInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedInput.Text = "1.0"
SpeedInput.TextSize = 14
SpeedInput.Font = Enum.Font.Gotham
SpeedInput.PlaceholderText = "Speed multiplier"
SpeedInput.ClearTextOnFocus = false
SpeedInput.Parent = ContentPanel

-- Filter input (only digits and dot)
SpeedInput:GetPropertyChangedSignal("Text"):Connect(function()
    local text = SpeedInput.Text
    local filtered = ""
    local dots = 0
    for i = 1, #text do
        local char = text:sub(i, i)
        if char:match("[%d]") then
            filtered = filtered .. char
        elseif char == "." and dots == 0 then
            filtered = filtered .. char
            dots = dots + 1
        end
    end
    if filtered ~= text then
        SpeedInput.Text = filtered
    end
end)

-- Apply button
local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Name = "ApplyBtn"
ApplyBtn.Size = UDim2.new(0, 100, 0, 30)
ApplyBtn.Position = UDim2.new(0, 140, 0, 10)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(60, 80, 120)
ApplyBtn.Text = "ПРИМЕНИТЬ"
ApplyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyBtn.TextSize = 12
ApplyBtn.Font = Enum.Font.GothamBold
ApplyBtn.Parent = ContentPanel

-- Slider background
local SliderBg = Instance.new("Frame")
SliderBg.Name = "SliderBg"
SliderBg.Size = UDim2.new(1, -20, 0, 4)
SliderBg.Position = UDim2.new(0, 10, 0, 60)
SliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
SliderBg.BorderSizePixel = 0
SliderBg.Parent = ContentPanel

-- Slider fill
local SliderFill = Instance.new("Frame")
SliderFill.Name = "SliderFill"
SliderFill.Size = UDim2.new(0, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBg

-- Slider knob
local SliderKnob = Instance.new("TextButton")
SliderKnob.Name = "SliderKnob"
SliderKnob.Size = UDim2.new(0, 16, 0, 16)
SliderKnob.Position = UDim2.new(0, -8, 0, -6)
SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderKnob.Text = ""
SliderKnob.AutoButtonColor = false
SliderKnob.BorderSizePixel = 0
SliderKnob.Parent = SliderBg

-- Corner rounding for knob
local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = SliderKnob

-- Speed value label
local SpeedValueLabel = Instance.new("TextLabel")
SpeedValueLabel.Name = "SpeedValueLabel"
SpeedValueLabel.Size = UDim2.new(0, 50, 0, 20)
SpeedValueLabel.Position = UDim2.new(1, -60, 0, 55)
SpeedValueLabel.BackgroundTransparency = 1
SpeedValueLabel.Text = "1.0x"
SpeedValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedValueLabel.TextSize = 12
SpeedValueLabel.Font = Enum.Font.Gotham
SpeedValueLabel.Parent = ContentPanel

-- Toggle speedhack button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(1, -20, 0, 36)
ToggleBtn.Position = UDim2.new(0, 10, 0, 85)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 60)
ToggleBtn.Text = "ВКЛЮЧИТЬ"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = ContentPanel

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 4)
toggleCorner.Parent = ToggleBtn

-- Status label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, -20, 0, 20)
StatusLabel.Position = UDim2.new(0, 10, 0, 130)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Статус: Выключен"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = ContentPanel

-- UI Corners
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = MainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = ContentPanel

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 4)
inputCorner.Parent = SpeedInput

local applyCorner = Instance.new("UICorner")
applyCorner.CornerRadius = UDim.new(0, 4)
applyCorner.Parent = ApplyBtn

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 2)
sliderCorner.Parent = SliderBg

-- Hover animations
local function animateButton(btn, hover)
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local targetColor = hover and btn.BackgroundColor3:Lerp(Color3.fromRGB(255, 255, 255), 0.15) or btn.BackgroundColor3
    if btn == ToggleBtn then
        targetColor = hover and (speedhack.enabled and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)) or (speedhack.enabled and Color3.fromRGB(60, 150, 60) or Color3.fromRGB(150, 60, 60))
    elseif btn == ApplyBtn then
        targetColor = hover and Color3.fromRGB(80, 100, 140) or Color3.fromRGB(60, 80, 120)
    end
    local tween = TweenService:Create(btn, tweenInfo, {BackgroundColor3 = targetColor})
    tween:Play()
end

ApplyBtn.MouseEnter:Connect(function() animateButton(ApplyBtn, true) end)
ApplyBtn.MouseLeave:Connect(function() animateButton(ApplyBtn, false) end)
ToggleBtn.MouseEnter:Connect(function() animateButton(ToggleBtn, true) end)
ToggleBtn.MouseLeave:Connect(function() animateButton(ToggleBtn, false) end)

-- Update speed (WalkSpeed only)
local function setGameSpeed(multiplier)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        local hum = char.Humanoid
        hum.WalkSpeed = originalWalkSpeed * multiplier
    end
end

local function updateSpeed(newSpeed)
    newSpeed = math.clamp(newSpeed, 0.1, 50)
    speedhack.speed = newSpeed
    SpeedInput.Text = string.format("%.2f", newSpeed)
    SpeedValueLabel.Text = string.format("%.2fx", newSpeed)
    
    -- Update slider position
    local percent = (newSpeed - 0.1) / (50 - 0.1)
    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    SliderKnob.Position = UDim2.new(percent, -8, 0, -6)
    
    if speedhack.enabled then
        setGameSpeed(newSpeed)
    end
end

-- Toggle speedhack
local function toggleSpeedhack()
    speedhack.enabled = not speedhack.enabled
    
    if speedhack.enabled then
        setGameSpeed(speedhack.speed)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 150, 60)
        ToggleBtn.Text = "ВЫКЛЮЧИТЬ"
        StatusLabel.Text = "Статус: Включён (x" .. string.format("%.2f", speedhack.speed) .. ")"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        setGameSpeed(1.0)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 60, 60)
        ToggleBtn.Text = "ВКЛЮЧИТЬ"
        StatusLabel.Text = "Статус: Выключен"
        StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end

-- Apply from input
local function applyFromInput()
    local value = tonumber(SpeedInput.Text)
    if value then
        updateSpeed(value)
    else
        updateSpeed(speedhack.speed)
    end
end

ApplyBtn.MouseButton1Click:Connect(applyFromInput)
SpeedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then applyFromInput() end
end)

ToggleBtn.MouseButton1Click:Connect(toggleSpeedhack)

-- Slider dragging
local draggingSlider = false
local function updateSliderFromInput(input)
    if not draggingSlider then return end
    local mousePos = input.Position.X
    local sliderAbsPos = SliderBg.AbsolutePosition.X
    local sliderWidth = SliderBg.AbsoluteSize.X
    if sliderWidth > 0 then
        local percent = math.clamp((mousePos - sliderAbsPos) / sliderWidth, 0, 1)
        local newSpeed = 0.1 + percent * (50 - 0.1)
        updateSpeed(newSpeed)
    end
end

SliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
    end
end)

SliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local mousePos = input.Position.X
        local sliderAbsPos = SliderBg.AbsolutePosition.X
        local sliderWidth = SliderBg.AbsoluteSize.X
        if sliderWidth > 0 then
            local percent = math.clamp((mousePos - sliderAbsPos) / sliderWidth, 0, 1)
            local newSpeed = 0.1 + percent * (50 - 0.1)
            updateSpeed(newSpeed)
            draggingSlider = true
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and draggingSlider then
        updateSliderFromInput(input)
    end
end)

-- Menu toggle (collapse/expand) - ИСПРАВЛЕНО
local menuCollapsed = false
local isAnimating = false

ToggleMenuBtn.MouseButton1Click:Connect(function()
    if isAnimating then return end
    isAnimating = true
    
    menuCollapsed = not menuCollapsed
    local targetHeight = menuCollapsed and 40 or 200
    local targetText = menuCollapsed and "▶" or "≡"  -- Меняем иконку для наглядности
    ToggleMenuBtn.Text = targetText
    
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 300, 0, targetHeight)})
    tween:Play()
    ContentPanel.Visible = not menuCollapsed
    
    tween.Completed:Connect(function()
        isAnimating = false
    end)
end)

-- Dragging window - С БЛОКИРОВКОЙ КАМЕРЫ
local dragging = false
local dragStart
local frameStart
local dragConnection = nil
local endConnection = nil

local function startDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        frameStart = MainFrame.Position
        
        -- Блокируем камеру и движение персонажа во время перетаскивания
        local camera = workspace.CurrentCamera
        if camera then
            camera.CameraType = Enum.CameraType.Scriptable
        end
        
        -- Отключаем стандартное управление камерой
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    end
end

local function updateDrag(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
        speedhack.position = MainFrame.Position
    end
end

local function endDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        
        -- Возвращаем управление камерой
        local camera = workspace.CurrentCamera
        if camera then
            camera.CameraType = Enum.CameraType.Custom
        end
        
        -- Возвращаем нормальное поведение мыши
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end
end

TitleBar.InputBegan:Connect(startDrag)
dragConnection = UserInputService.InputChanged:Connect(updateDrag)
endConnection = UserInputService.InputEnded:Connect(endDrag)

-- Character respawn handling
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    originalWalkSpeed = humanoid.WalkSpeed
    
    if speedhack.enabled then
        setGameSpeed(speedhack.speed)
    end
end)

-- Initialize
updateSpeed(1.0)

-- Фикс для мобильных устройств - отключаем скролл камеры при касании GUI
local function blockCameraOnGuiTouch(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        local guiObjects = screenGui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
        if #guiObjects > 0 then
            return true
        end
    end
    return false
end

UserInputService.TouchStarted:Connect(function(input)
    if blockCameraOnGuiTouch(input) then
        -- Предотвращаем движение камеры
        return
    end
end)
