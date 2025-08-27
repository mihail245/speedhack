-- SpeedHack UI для Roblox
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local speedhack = {
    enabled = false,
    speed = 1.0,
    menuOpen = false,
    position = UDim2.new(0, 20, 0, 50)
}

-- Создаем основной интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpeedHackUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Контейнер меню
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 40)
MainFrame.Position = speedhack.position
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Закругленные углы
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Тень
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(20, 20, 20)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Заголовок
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Header.BackgroundTransparency = 0
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 8)
HeaderCorner.Parent = Header

-- Текст заголовка
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 120, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "🚗 SpeedHack"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.Font = Enum.Font.GothamMedium
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Кнопка открытия/закрытия
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 30, 0, 30)
ToggleButton.Position = UDim2.new(1, -40, 0, 5)
ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ToggleButton.BackgroundTransparency = 0
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "≡"
ToggleButton.TextColor3 = Color3.fromRGB(240, 240, 240)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 16
ToggleButton.Parent = Header

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = ToggleButton

-- Контент меню
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, 0, 0, 140)
Content.Position = UDim2.new(0, 0, 0, 40)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Слайдер скорости
local SpeedSlider = Instance.new("Frame")
SpeedSlider.Name = "SpeedSlider"
SpeedSlider.Size = UDim2.new(1, -20, 0, 50)
SpeedSlider.Position = UDim2.new(0, 10, 0, 10)
SpeedSlider.BackgroundTransparency = 1
SpeedSlider.Parent = Content

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedLabel.Position = UDim2.new(0, 0, 0, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Скорость: 1.0x"
SpeedLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 14
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = SpeedSlider

local SliderTrack = Instance.new("Frame")
SliderTrack.Name = "SliderTrack"
SliderTrack.Size = UDim2.new(1, 0, 0, 6)
SliderTrack.Position = UDim2.new(0, 0, 0, 25)
SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SliderTrack.BorderSizePixel = 0
SliderTrack.Parent = SpeedSlider

local TrackCorner = Instance.new("UICorner")
TrackCorner.CornerRadius = UDim.new(1, 0)
TrackCorner.Parent = SliderTrack

local SliderFill = Instance.new("Frame")
SliderFill.Name = "SliderFill"
SliderFill.Size = UDim2.new(0.1, 0, 1, 0)
SliderFill.Position = UDim2.new(0, 0, 0, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderTrack

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = SliderFill

local SliderThumb = Instance.new("TextButton")
SliderThumb.Name = "SliderThumb"
SliderThumb.Size = UDim2.new(0, 16, 0, 16)
SliderThumb.Position = UDim2.new(0.1, -8, 0, -5)
SliderThumb.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
SliderThumb.BorderSizePixel = 0
SliderThumb.Text = ""
SliderThumb.Parent = SpeedSlider

local ThumbCorner = Instance.new("UICorner")
ThumbCorner.CornerRadius = UDim.new(1, 0)
ThumbCorner.Parent = SliderThumb

-- Кнопка включения/выключения
local ToggleSpeedButton = Instance.new("TextButton")
ToggleSpeedButton.Name = "ToggleSpeedButton"
ToggleSpeedButton.Size = UDim2.new(1, -20, 0, 35)
ToggleSpeedButton.Position = UDim2.new(0, 10, 0, 70)
ToggleSpeedButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
ToggleSpeedButton.BorderSizePixel = 0
ToggleSpeedButton.Text = "ВКЛЮЧИТЬ"
ToggleSpeedButton.TextColor3 = Color3.fromRGB(240, 240, 240)
ToggleSpeedButton.Font = Enum.Font.GothamBold
ToggleSpeedButton.TextSize = 14
ToggleSpeedButton.Parent = Content

local ToggleButtonCorner = Instance.new("UICorner")
ToggleButtonCorner.CornerRadius = UDim.new(0, 6)
ToggleButtonCorner.Parent = ToggleSpeedButton

-- Статус
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, -20, 0, 20)
StatusLabel.Position = UDim2.new(0, 10, 0, 115)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Статус: Неактивно"
StatusLabel.TextColor3 = Color3.fromRGB(200, 60, 60)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = Content

-- Переменные для перетаскивания
local dragging = false
local dragInput, dragStart, startPos

-- Функция обновления скорости
local function updateSpeed(value)
    speedhack.speed = math.clamp(value, 0.1, 10.0)
    SpeedLabel.Text = string.format("Скорость: %.1fx", speedhack.speed)
    
    local fillWidth = (speedhack.speed - 0.1) / 9.9
    SliderFill.Size = UDim2.new(fillWidth, 0, 1, 0)
    SliderThumb.Position = UDim2.new(fillWidth, -8, 0, -5)
    
    if speedhack.enabled then
        setGameSpeed(speedhack.speed)
    end
end

-- Функция установки скорости игры
local function setGameSpeed(speed)
    -- Изменяем скорость персонажа
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16 * speed
            humanoid.JumpPower = 50 * speed
        end
    end
    
    -- Можно добавить другие эффекты скорости здесь
    print("Скорость установлена: " .. tostring(speed) .. "x")
end

-- Функция переключения состояния
local function toggleSpeedhack()
    speedhack.enabled = not speedhack.enabled
    
    if speedhack.enabled then
        ToggleSpeedButton.Text = "ВЫКЛЮЧИТЬ"
        ToggleSpeedButton.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        StatusLabel.Text = "Статус: Активно"
        StatusLabel.TextColor3 = Color3.fromRGB(60, 200, 60)
        setGameSpeed(speedhack.speed)
    else
        ToggleSpeedButton.Text = "ВКЛЮЧИТЬ"
        ToggleSpeedButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        StatusLabel.Text = "Статус: Неактивно"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 60, 60)
        setGameSpeed(1.0)
    end
end

-- Функция переключения меню
local function toggleMenu()
    speedhack.menuOpen = not speedhack.menuOpen
    
    if speedhack.menuOpen then
        ToggleButton.Text = "×"
        MainFrame.Size = UDim2.new(0, 280, 0, 180)
    else
        ToggleButton.Text = "≡"
        MainFrame.Size = UDim2.new(0, 280, 0, 40)
    end
end

-- Обработчики событий
ToggleButton.MouseButton1Click:Connect(toggleMenu)
ToggleSpeedButton.MouseButton1Click:Connect(toggleSpeedhack)

-- Обработка слайдера
SliderThumb.MouseButton1Down:Connect(function()
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            connection:Disconnect()
            return
        end
        
        local mousePos = UserInputService:GetMouseLocation()
        local sliderAbsolutePos = SliderTrack.AbsolutePosition
        local sliderAbsoluteSize = SliderTrack.AbsoluteSize
        
        local relativeX = math.clamp((mousePos.X - sliderAbsolutePos.X) / sliderAbsoluteSize.X, 0, 1)
        local speedValue = 0.1 + relativeX * 9.9
        
        updateSpeed(speedValue)
    end)
end)

-- Обработка клика по треку слайдера
SliderTrack.MouseButton1Down:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    local sliderAbsolutePos = SliderTrack.AbsolutePosition
    local sliderAbsoluteSize = SliderTrack.AbsoluteSize
    
    local relativeX = math.clamp((mousePos.X - sliderAbsolutePos.X) / sliderAbsoluteSize.X, 0, 1)
    local speedValue = 0.1 + relativeX * 9.9
    
    updateSpeed(speedValue)
end)

-- Функции для перетаскивания окна
local function updateInput(input)
    if dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Эффекты при наведении
ToggleButton.MouseEnter:Connect(function()
    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(90, 90, 90)}):Play()
end)

ToggleButton.MouseLeave:Connect(function()
    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
end)

ToggleSpeedButton.MouseEnter:Connect(function()
    local targetColor = speedhack.enabled and Color3.fromRGB(80, 220, 80) or Color3.fromRGB(220, 80, 80)
    TweenService:Create(ToggleSpeedButton, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
end)

ToggleSpeedButton.MouseLeave:Connect(function()
    local targetColor = speedhack.enabled and Color3.fromRGB(60, 200, 60) or Color3.fromRGB(200, 60, 60)
    TweenService:Create(ToggleSpeedButton, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
end)

-- Инициализация
print("🚗 SpeedHack для Roblox загружен!")
print("Перетаскивайте за заголовок чтобы переместить меню")
print("Нажмите ≡ чтобы открыть/закрыть меню")
