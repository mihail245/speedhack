-- SpeedHack UI для Roblox с полем ввода
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
MainFrame.Size = UDim2.new(0, 300, 0, 40)
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
Content.Size = UDim2.new(1, 0, 0, 160)
Content.Position = UDim2.new(0, 0, 0, 40)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Поле ввода скорости
local InputContainer = Instance.new("Frame")
InputContainer.Name = "InputContainer"
InputContainer.Size = UDim2.new(1, -20, 0, 30)
InputContainer.Position = UDim2.new(0, 10, 0, 10)
InputContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
InputContainer.BorderSizePixel = 0
InputContainer.Parent = Content

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = InputContainer

local SpeedInput = Instance.new("TextBox")
SpeedInput.Name = "SpeedInput"
SpeedInput.Size = UDim2.new(0.7, 0, 1, 0)
SpeedInput.Position = UDim2.new(0, 0, 0, 0)
SpeedInput.BackgroundTransparency = 1
SpeedInput.Text = "1.0"
SpeedInput.TextColor3 = Color3.fromRGB(240, 240, 240)
SpeedInput.Font = Enum.Font.Gotham
SpeedInput.TextSize = 14
SpeedInput.TextXAlignment = Enum.TextXAlignment.Left
SpeedInput.PlaceholderText = "Введите скорость..."
SpeedInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SpeedInput.Parent = InputContainer

local InputLabel = Instance.new("TextLabel")
InputLabel.Name = "InputLabel"
InputLabel.Size = UDim2.new(0.3, 0, 1, 0)
InputLabel.Position = UDim2.new(0.7, 0, 0, 0)
InputLabel.BackgroundTransparency = 1
InputLabel.Text = "x скорость"
InputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InputLabel.Font = Enum.Font.Gotham
InputLabel.TextSize = 12
InputLabel.TextXAlignment = Enum.TextXAlignment.Right
InputLabel.Parent = InputContainer

-- Кнопка применения ввода
local ApplyButton = Instance.new("TextButton")
ApplyButton.Name = "ApplyButton"
ApplyButton.Size = UDim2.new(1, -20, 0, 30)
ApplyButton.Position = UDim2.new(0, 10, 0, 50)
ApplyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
ApplyButton.BorderSizePixel = 0
ApplyButton.Text = "ПРИМЕНИТЬ СКОРОСТЬ"
ApplyButton.TextColor3 = Color3.fromRGB(240, 240, 240)
ApplyButton.Font = Enum.Font.GothamBold
ApplyButton.TextSize = 12
ApplyButton.Parent = Content

local ApplyButtonCorner = Instance.new("UICorner")
ApplyButtonCorner.CornerRadius = UDim.new(0, 6)
ApplyButtonCorner.Parent = ApplyButton

-- Слайдер скорости (дополнительная опция)
local SpeedSlider = Instance.new("Frame")
SpeedSlider.Name = "SpeedSlider"
SpeedSlider.Size = UDim2.new(1, -20, 0, 30)
SpeedSlider.Position = UDim2.new(0, 10, 0, 90)
SpeedSlider.BackgroundTransparency = 1
SpeedSlider.Parent = Content

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Name = "SliderLabel"
SliderLabel.Size = UDim2.new(1, 0, 0, 15)
SliderLabel.Position = UDim2.new(0, 0, 0, 0)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "Или используйте слайдер:"
SliderLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
SliderLabel.Font = Enum.Font.Gotham
SliderLabel.TextSize = 11
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SliderLabel.Parent = SpeedSlider

local SliderTrack = Instance.new("Frame")
SliderTrack.Name = "SliderTrack"
SliderTrack.Size = UDim2.new(1, 0, 0, 6)
SliderTrack.Position = UDim2.new(0, 0, 0, 20)
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
ToggleSpeedButton.Position = UDim2.new(0, 10, 0, 130)
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
StatusLabel.Position = UDim2.new(0, 10, 0, 175)
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
    speedhack.speed = math.clamp(value, 0.1, 50.0) -- Увеличил максимальную скорость до 50x
    
    -- Обновляем поле ввода
    SpeedInput.Text = string.format("%.1f", speedhack.speed)
    
    -- Обновляем слайдер
    local fillWidth = (speedhack.speed - 0.1) / 49.9
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
    
    print("Скорость установлена: " .. tostring(speed) .. "x")
end

-- Функция переключения состояния
local function toggleSpeedhack()
    speedhack.enabled = not speedhack.enabled
    
    if speedhack.enabled then
        ToggleSpeedButton.Text = "ВЫКЛЮЧИТЬ"
        ToggleSpeedButton.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        StatusLabel.Text = "Статус: Активно (" .. string.format("%.1f", speedhack.speed) .. "x)"
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
        MainFrame.Size = UDim2.new(0, 300, 0, 200)
    else
        ToggleButton.Text = "≡"
        MainFrame.Size = UDim2.new(0, 300, 0, 40)
    end
end

-- Функция применения скорости из поля ввода
local function applySpeedFromInput()
    local text = SpeedInput.Text
    local number = tonumber(text)
    
    if number then
        updateSpeed(number)
        if speedhack.enabled then
            StatusLabel.Text = "Статус: Активно (" .. string.format("%.1f", speedhack.speed) .. "x)"
        end
    else
        -- Сбрасываем на текущее значение при неверном вводе
        SpeedInput.Text = string.format("%.1f", speedhack.speed)
    end
end

-- Обработчики событий
ToggleButton.MouseButton1Click:Connect(toggleMenu)
ToggleSpeedButton.MouseButton1Click:Connect(toggleSpeedhack)
ApplyButton.MouseButton1Click:Connect(applySpeedFromInput)

-- Обработка ввода текста
SpeedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        applySpeedFromInput()
    end
end)

-- Фильтрация ввода - только цифры и точка
SpeedInput:GetPropertyChangedSignal("Text"):Connect(function()
    local text = SpeedInput.Text
    local filtered = text:gsub("[^%d.]", "")
    local dots = filtered:gsub("[^.]", "")
    
    if #dots > 1 then
        filtered = filtered:gsub("%.", "", #dots - 1)
    end
    
    if filtered ~= text then
        SpeedInput.Text = filtered
    end
end)

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
        local speedValue = 0.1 + relativeX * 49.9
        
        updateSpeed(speedValue)
    end)
end)

-- Обработка клика по треку слайдера
SliderTrack.MouseButton1Down:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    local sliderAbsolutePos = SliderTrack.AbsolutePosition
    local sliderAbsoluteSize = SliderTrack.AbsoluteSize
    
    local relativeX = math.clamp((mousePos.X - sliderAbsolutePos.X) / sliderAbsoluteSize.X, 0, 1)
    local speedValue = 0.1 + relativeX * 49.9
    
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

ApplyButton.MouseEnter:Connect(function()
    TweenService:Create(ApplyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 160, 255)}):Play()
end)

ApplyButton.MouseLeave:Connect(function()
    TweenService:Create(ApplyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 120, 255)}):Play()
end)

ToggleSpeedButton.MouseEnter:Connect(function()
    local targetColor = speedhack.enabled and Color3.fromRGB(80, 220, 80) or Color3.fromRGB(220, 80, 80)
    TweenService:Create(ToggleSpeedButton, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
end)

ToggleSpeedButton.MouseLeave:Connect(function()
    local targetColor = speedhack.enabled and Color3.fromRGB(60, 200, 60) or Color3.fromRGB(200, 60, 60)
    TweenService:Create(ToggleSpeedButton, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
end)

InputContainer.MouseEnter:Connect(function()
    TweenService:Create(InputContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
end)

InputContainer.MouseLeave:Connect(function()
    TweenService:Create(InputContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
end)

-- Инициализация
print("🚗 SpeedHack для Roblox загружен!")
print("Перетаскивайте за заголовок чтобы переместить меню")
print("Нажмите ≡ чтобы открыть/закрыть меню")
print("Вводите скорость в поле и нажимайте Применить или Enter")
