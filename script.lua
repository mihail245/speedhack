-- SpeedHack UI для Roblox с современным оконным интерфейсом
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

local speedhack = {
    enabled = false,
    speed = 1.0,
    isMinimized = false,
    windows = {}
}

-- Создаем основной интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpeedHackUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Функция создания современного окна
local function createModernWindow(title, initialSize, initialPosition)
    local window = {}
    
    -- Контейнер окна
    local frame = Instance.new("Frame")
    frame.Size = initialSize
    frame.Position = initialPosition
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = ScreenGui
    
    -- Тень окна
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.5
    shadow.BorderSizePixel = 0
    shadow.ZIndex = -1
    shadow.Parent = frame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 12)
    shadowCorner.Parent = shadow
    
    -- Основной корнер
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = frame
    
    -- Обводка
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 60, 70)
    stroke.Thickness = 1
    stroke.Parent = frame
    
    -- Заголовок окна
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 45)
    header.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    header.BackgroundTransparency = 0
    header.BorderSizePixel = 0
    header.Parent = frame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header
    
    -- Иконка окна
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 30, 1, 0)
    icon.Position = UDim2.new(0, 10, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "⚡"
    icon.TextColor3 = Color3.fromRGB(255, 200, 100)
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 20
    icon.TextXAlignment = Enum.TextXAlignment.Center
    icon.Parent = header
    
    -- Заголовок
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 150, 1, 0)
    titleLabel.Position = UDim2.new(0, 45, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextYAlignment = Enum.TextYAlignment.Center
    titleLabel.Parent = header
    
    -- Кнопка сворачивания
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 35, 1, 0)
    minimizeBtn.Position = UDim2.new(1, -105, 0, 0)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Text = "─"
    minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 18
    minimizeBtn.Parent = header
    
    -- Кнопка разворачивания
    local maximizeBtn = Instance.new("TextButton")
    maximizeBtn.Size = UDim2.new(0, 35, 1, 0)
    maximizeBtn.Position = UDim2.new(1, -70, 0, 0)
    maximizeBtn.BackgroundTransparency = 1
    maximizeBtn.Text = "□"
    maximizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    maximizeBtn.Font = Enum.Font.GothamBold
    maximizeBtn.TextSize = 16
    maximizeBtn.Parent = header
    
    -- Кнопка закрытия
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 1, 0)
    closeBtn.Position = UDim2.new(1, -35, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.Parent = header
    
    -- Контент окна
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, -45)
    content.Position = UDim2.new(0, 0, 0, 45)
    content.BackgroundTransparency = 1
    content.Parent = frame
    
    -- Контейнер для скроллинга
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollingFrame.Position = UDim2.new(0, 0, 0, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 110)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.Parent = content
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 12)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = scrollingFrame
    
    -- Поле ввода скорости
    local inputCard = Instance.new("Frame")
    inputCard.Size = UDim2.new(1, -24, 0, 70)
    inputCard.BackgroundColor3 = Color3.fromRGB(38, 38, 45)
    inputCard.BorderSizePixel = 0
    inputCard.Parent = scrollingFrame
    
    local inputCardCorner = Instance.new("UICorner")
    inputCardCorner.CornerRadius = UDim.new(0, 8)
    inputCardCorner.Parent = inputCard
    
    local inputLabel = Instance.new("TextLabel")
    inputLabel.Size = UDim2.new(1, -20, 0, 25)
    inputLabel.Position = UDim2.new(0, 10, 0, 8)
    inputLabel.BackgroundTransparency = 1
    inputLabel.Text = "Скорость движения"
    inputLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
    inputLabel.Font = Enum.Font.GothamMedium
    inputLabel.TextSize = 12
    inputLabel.TextXAlignment = Enum.TextXAlignment.Left
    inputLabel.Parent = inputCard
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(0.6, -15, 0, 32)
    inputBox.Position = UDim2.new(0, 10, 0, 35)
    inputBox.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    inputBox.BorderSizePixel = 0
    inputBox.Text = "1.0"
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextSize = 14
    inputBox.TextXAlignment = Enum.TextXAlignment.Center
    inputBox.PlaceholderText = "0.1 - 50.0"
    inputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
    inputBox.Parent = inputCard
    
    local inputBoxCorner = Instance.new("UICorner")
    inputBoxCorner.CornerRadius = UDim.new(0, 6)
    inputBoxCorner.Parent = inputBox
    
    local speedUnit = Instance.new("TextLabel")
    speedUnit.Size = UDim2.new(0.4, -15, 0, 32)
    speedUnit.Position = UDim2.new(0.6, 5, 0, 35)
    speedUnit.BackgroundTransparency = 1
    speedUnit.Text = "x скорость"
    speedUnit.TextColor3 = Color3.fromRGB(150, 150, 160)
    speedUnit.Font = Enum.Font.Gotham
    speedUnit.TextSize = 13
    speedUnit.TextXAlignment = Enum.TextXAlignment.Left
    speedUnit.TextYAlignment = Enum.TextYAlignment.Center
    speedUnit.Parent = inputCard
    
    -- Слайдер
    local sliderCard = Instance.new("Frame")
    sliderCard.Size = UDim2.new(1, -24, 0, 70)
    sliderCard.BackgroundColor3 = Color3.fromRGB(38, 38, 45)
    sliderCard.BorderSizePixel = 0
    sliderCard.Parent = scrollingFrame
    
    local sliderCardCorner = Instance.new("UICorner")
    sliderCardCorner.CornerRadius = UDim.new(0, 8)
    sliderCardCorner.Parent = sliderCard
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(1, -20, 0, 25)
    sliderLabel.Position = UDim2.new(0, 10, 0, 8)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = "Регулировка слайдером"
    sliderLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
    sliderLabel.Font = Enum.Font.GothamMedium
    sliderLabel.TextSize = 12
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Parent = sliderCard
    
    local sliderValue = Instance.new("TextLabel")
    sliderValue.Size = UDim2.new(0, 60, 0, 25)
    sliderValue.Position = UDim2.new(1, -70, 0, 8)
    sliderValue.BackgroundTransparency = 1
    sliderValue.Text = "1.0x"
    sliderValue.TextColor3 = Color3.fromRGB(255, 200, 100)
    sliderValue.Font = Enum.Font.GothamBold
    sliderValue.TextSize = 14
    sliderValue.TextXAlignment = Enum.TextXAlignment.Right
    sliderValue.Parent = sliderCard
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(1, -20, 0, 4)
    sliderTrack.Position = UDim2.new(0, 10, 0, 45)
    sliderTrack.BackgroundColor3 = Color3.fromRGB(55, 55, 62)
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = sliderCard
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = sliderTrack
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(0.02, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local sliderThumb = Instance.new("Frame")
    sliderThumb.Size = UDim2.new(0, 18, 0, 18)
    sliderThumb.Position = UDim2.new(0.02, -9, 0, -7)
    sliderThumb.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
    sliderThumb.BorderSizePixel = 0
    sliderThumb.Parent = sliderCard
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = sliderThumb
    
    -- Кнопка применения
    local applyCard = Instance.new("Frame")
    applyCard.Size = UDim2.new(1, -24, 0, 50)
    applyCard.BackgroundColor3 = Color3.fromRGB(38, 38, 45)
    applyCard.BorderSizePixel = 0
    applyCard.Parent = scrollingFrame
    
    local applyCardCorner = Instance.new("UICorner")
    applyCardCorner.CornerRadius = UDim.new(0, 8)
    applyCardCorner.Parent = applyCard
    
    local applyBtn = Instance.new("TextButton")
    applyBtn.Size = UDim2.new(1, -20, 0, 36)
    applyBtn.Position = UDim2.new(0, 10, 0, 7)
    applyBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
    applyBtn.BorderSizePixel = 0
    applyBtn.Text = "ПРИМЕНИТЬ СКОРОСТЬ"
    applyBtn.TextColor3 = Color3.fromRGB(28, 28, 35)
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.TextSize = 13
    applyBtn.Parent = applyCard
    
    local applyBtnCorner = Instance.new("UICorner")
    applyBtnCorner.CornerRadius = UDim.new(0, 6)
    applyBtnCorner.Parent = applyBtn
    
    -- Кнопка включения/выключения
    local toggleCard = Instance.new("Frame")
    toggleCard.Size = UDim2.new(1, -24, 0, 50)
    toggleCard.BackgroundColor3 = Color3.fromRGB(38, 38, 45)
    toggleCard.BorderSizePixel = 0
    toggleCard.Parent = scrollingFrame
    
    local toggleCardCorner = Instance.new("UICorner")
    toggleCardCorner.CornerRadius = UDim.new(0, 8)
    toggleCardCorner.Parent = toggleCard
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, -20, 0, 36)
    toggleBtn.Position = UDim2.new(0, 10, 0, 7)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = "ВКЛЮЧИТЬ"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 13
    toggleBtn.Parent = toggleCard
    
    local toggleBtnCorner = Instance.new("UICorner")
    toggleBtnCorner.CornerRadius = UDim.new(0, 6)
    toggleBtnCorner.Parent = toggleBtn
    
    -- Статус
    local statusCard = Instance.new("Frame")
    statusCard.Size = UDim2.new(1, -24, 0, 40)
    statusCard.BackgroundColor3 = Color3.fromRGB(38, 38, 45)
    statusCard.BorderSizePixel = 0
    statusCard.Parent = scrollingFrame
    
    local statusCardCorner = Instance.new("UICorner")
    statusCardCorner.CornerRadius = UDim.new(0, 8)
    statusCardCorner.Parent = statusCard
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, -20, 1, 0)
    statusText.Position = UDim2.new(0, 10, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "⚫ Статус: Неактивно"
    statusText.TextColor3 = Color3.fromRGB(220, 80, 80)
    statusText.Font = Enum.Font.GothamMedium
    statusText.TextSize = 12
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.TextYAlignment = Enum.TextYAlignment.Center
    statusText.Parent = statusCard
    
    -- Обновление CanvasSize
    local function updateCanvasSize()
        wait(0.1)
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)
    task.wait(0.1)
    updateCanvasSize()
    
    -- Функции управления окном
    local isMinimized = false
    local isMaximized = false
    local savedSize = initialSize
    local savedPosition = initialPosition
    
    window.toggleMinimize = function()
        isMinimized = not isMinimized
        if isMinimized then
            content.Visible = false
            frame.Size = UDim2.new(initialSize.X.Scale, initialSize.X.Offset, 0, 45)
            minimizeBtn.Text = "□"
        else
            content.Visible = true
            frame.Size = savedSize
            minimizeBtn.Text = "─"
        end
    end
    
    window.toggleMaximize = function()
        isMaximized = not isMaximized
        if isMaximized then
            savedSize = frame.Size
            savedPosition = frame.Position
            frame.Size = UDim2.new(1, -40, 1, -80)
            frame.Position = UDim2.new(0, 20, 0, 40)
            maximizeBtn.Text = "❐"
        else
            frame.Size = savedSize
            frame.Position = savedPosition
            maximizeBtn.Text = "□"
        end
    end
    
    window.close = function()
        frame:Destroy()
        if window.onClose then window.onClose() end
    end
    
    -- Перетаскивание окна
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    
    local function updateInput(input)
        if dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end
    
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateInput(input)
        end
    end)
    
    -- Обработчики кнопок
    minimizeBtn.MouseButton1Click:Connect(window.toggleMinimize)
    maximizeBtn.MouseButton1Click:Connect(window.toggleMaximize)
    closeBtn.MouseButton1Click:Connect(window.close)
    
    -- Функции SpeedHack
    local function setGameSpeed(speed)
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16 * speed
                humanoid.JumpPower = 50 * speed
            end
        end
    end
    
    local function updateSpeed(value)
        speedhack.speed = math.clamp(value, 0.1, 50.0)
        inputBox.Text = string.format("%.1f", speedhack.speed)
        sliderValue.Text = string.format("%.1fx", speedhack.speed)
        
        local fillWidth = (speedhack.speed - 0.1) / 49.9
        sliderFill.Size = UDim2.new(fillWidth, 0, 1, 0)
        sliderThumb.Position = UDim2.new(fillWidth, -9, 0, -7)
        
        if speedhack.enabled then
            setGameSpeed(speedhack.speed)
            statusText.Text = string.format("🟢 Статус: Активно (%.1fx)", speedhack.speed)
        end
    end
    
    local function toggleSpeedhack()
        speedhack.enabled = not speedhack.enabled
        
        if speedhack.enabled then
            toggleBtn.Text = "ВЫКЛЮЧИТЬ"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
            statusText.Text = string.format("🟢 Статус: Активно (%.1fx)", speedhack.speed)
            statusText.TextColor3 = Color3.fromRGB(80, 200, 80)
            setGameSpeed(speedhack.speed)
        else
            toggleBtn.Text = "ВКЛЮЧИТЬ"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
            statusText.Text = "⚫ Статус: Неактивно"
            statusText.TextColor3 = Color3.fromRGB(220, 80, 80)
            setGameSpeed(1.0)
        end
    end
    
    local function applySpeedFromInput()
        local number = tonumber(inputBox.Text)
        if number then
            updateSpeed(number)
        else
            inputBox.Text = string.format("%.1f", speedhack.speed)
        end
    end
    
    -- Обработчики событий
    toggleBtn.MouseButton1Click:Connect(toggleSpeedhack)
    applyBtn.MouseButton1Click:Connect(applySpeedFromInput)
    
    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then applySpeedFromInput() end
    end)
    
    inputBox:GetPropertyChangedSignal("Text"):Connect(function()
        local text = inputBox.Text
        local filtered = text:gsub("[^%d.]", "")
        local dots = filtered:gsub("[^.]", "")
        if #dots > 1 then
            filtered = filtered:gsub("%.", "", #dots - 1)
        end
        if filtered ~= text then
            inputBox.Text = filtered
        end
    end)
    
    -- Слайдер
    local sliderDragging = false
    
    sliderThumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliderDragging = true
        end
    end)
    
    sliderThumb.InputEnded:Connect(function()
        sliderDragging = false
    end)
    
    local function updateSliderFromMouse()
        if sliderDragging then
            local mousePos = UserInputService:GetMouseLocation()
            local trackPos = sliderTrack.AbsolutePosition
            local trackSize = sliderTrack.AbsoluteSize
            
            if trackSize.X > 0 then
                local relativeX = math.clamp((mousePos.X - trackPos.X) / trackSize.X, 0, 1)
                local speedValue = 0.1 + relativeX * 49.9
                updateSpeed(speedValue)
            end
        end
    end
    
    RunService.RenderStepped:Connect(updateSliderFromMouse)
    
    sliderTrack.MouseButton1Down:Connect(function()
        local mousePos = UserInputService:GetMouseLocation()
        local trackPos = sliderTrack.AbsolutePosition
        local trackSize = sliderTrack.AbsoluteSize
        
        if trackSize.X > 0 then
            local relativeX = math.clamp((mousePos.X - trackPos.X) / trackSize.X, 0, 1)
            local speedValue = 0.1 + relativeX * 49.9
            updateSpeed(speedValue)
        end
    end)
    
    -- Эффекты наведения
    local function addHoverEffect(button, normalColor, hoverColor)
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
        end)
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
        end)
    end
    
    addHoverEffect(applyBtn, Color3.fromRGB(255, 200, 100), Color3.fromRGB(255, 215, 130))
    addHoverEffect(toggleBtn, toggleBtn.BackgroundColor3, toggleBtn.BackgroundColor3:Lerp(Color3.fromRGB(255, 255, 255), 0.2))
    addHoverEffect(minimizeBtn, Color3.fromRGB(200, 200, 200), Color3.fromRGB(255, 255, 255))
    addHoverEffect(maximizeBtn, Color3.fromRGB(200, 200, 200), Color3.fromRGB(255, 255, 255))
    addHoverEffect(closeBtn, Color3.fromRGB(200, 200, 200), Color3.fromRGB(255, 80, 80))
    
    window.frame = frame
    return window
end

-- Создаем главное окно
local mainWindow = createModernWindow("SpeedHack v2.0", UDim2.new(0, 320, 0, 420), UDim2.new(0.5, -160, 0.5, -210))

print("⚡ SpeedHack с современным интерфейсом загружен!")
print("✓ Окно можно перетаскивать за заголовок")
print("✓ Кнопки: свернуть (_), развернуть (□), закрыть (✕)")
print("✓ Используйте слайдер или вводите скорость вручную")
