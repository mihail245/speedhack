-- Основные переменные
local isMenuOpen = false
local animationProgress = 0
local targetAnimationProgress = 0
local currentSpeed = 1.0
local defaultSpeed = 1.0

-- Создаем иконку меню
local menuIcon = createSprite("speed_icon.png")
menuIcon.color = Color(70, 130, 180, 200)  -- SteelBlue с прозрачностью
menuIcon.size = Vector2(50, 50)
menuIcon.position = Vector2(50, 50)

-- Основное меню
local mainMenu = {
    visible = false,
    position = Vector2(100, 100),
    size = Vector2(250, 300),
    color = Color(30, 30, 35, 230),
    cornerRadius = 15
}

-- Элементы меню
local speedInput = {
    text = "1.0",
    position = Vector2(125, 150),
    size = Vector2(200, 40),
    color = Color(45, 45, 50, 255),
    active = false,
    placeholder = "Скорость"
}

local setSpeedButton = {
    text = "Установить скорость",
    position = Vector2(125, 200),
    size = Vector2(200, 45),
    color = Color(65, 105, 225, 255),  -- RoyalBlue
    hoverColor = Color(75, 115, 235, 255)
}

local resetSpeedButton = {
    text = "Обычная скорость",
    position = Vector2(125, 255),
    size = Vector2(200, 45),
    color = Color(90, 90, 100, 255),
    hoverColor = Color(110, 110, 120, 255)
}

local closeButton = {
    text = "✕",
    position = Vector2(330, 110),
    size = Vector2(30, 30),
    color = Color(200, 60, 60, 255),
    hoverColor = Color(220, 80, 80, 255)
}

-- Функция для проверки касания
function isTouchInRect(touchPos, rectPos, rectSize)
    return touchPos.x >= rectPos.x and touchPos.x <= rectPos.x + rectSize.x and
           touchPos.y >= rectPos.y and touchPos.y <= rectPos.y + rectSize.y
end

-- Функция для плавной анимации
function lerp(a, b, t)
    return a + (b - a) * math.min(math.max(t, 0), 1)
end

-- Функция установки скорости
function setPlayerSpeed(speed)
    local player = getLocalPlayer()
    if player then
        player.speed = speed
        currentSpeed = speed
    end
end

-- Основная функция обновления
function update()
    -- Обновление анимации
    animationProgress = lerp(animationProgress, targetAnimationProgress, 0.2)
    
    -- Обработка касаний
    local touches = getTouches()
    for _, touch in ipairs(touches) do
        if touch.phase == "BEGAN" then
            -- Проверка касания иконки меню
            if isTouchInRect(touch.position, menuIcon.position, menuIcon.size) then
                isMenuOpen = not isMenuOpen
                targetAnimationProgress = isMenuOpen and 1 or 0
                playSound("click.wav")
            end
            
            -- Если меню открыто, проверяем элементы
            if isMenuOpen then
                -- Кнопка закрытия
                if isTouchInRect(touch.position, closeButton.position, closeButton.size) then
                    isMenuOpen = false
                    targetAnimationProgress = 0
                    playSound("close.wav")
                end
                
                -- Поле ввода
                if isTouchInRect(touch.position, speedInput.position, speedInput.size) then
                    speedInput.active = true
                    showKeyboard()
                else
                    speedInput.active = false
                end
                
                -- Кнопка установки скорости
                if isTouchInRect(touch.position, setSpeedButton.position, setSpeedButton.size) then
                    local speed = tonumber(speedInput.text)
                    if speed and speed > 0 then
                        setPlayerSpeed(speed)
                        playSound("confirm.wav")
                    else
                        playSound("error.wav")
                    end
                end
                
                -- Кнопка сброса скорости
                if isTouchInRect(touch.position, resetSpeedButton.position, resetSpeedButton.size) then
                    setPlayerSpeed(defaultSpeed)
                    speedInput.text = tostring(defaultSpeed)
                    playSound("reset.wav")
                end
            end
        end
    end
    
    -- Обновление позиции меню с анимацией
    if isMenuOpen then
        mainMenu.visible = true
    else
        if animationProgress < 0.1 then
            mainMenu.visible = false
        end
    end
end

-- Функция отрисовки
function render()
    -- Рисуем иконку меню
    drawSprite(menuIcon)
    
    -- Если меню видимо, рисуем его с анимацией
    if mainMenu.visible then
        local scale = animationProgress
        local alpha = 255 * animationProgress
        
        -- Фон меню
        drawRoundedRect(
            mainMenu.position, 
            mainMenu.size, 
            mainMenu.cornerRadius, 
            Color(mainMenu.color.r, mainMenu.color.g, mainMenu.color.b, alpha)
        )
        
        -- Заголовок
        drawText("Управление скоростью", Vector2(125, 120), Color(255, 255, 255, alpha), 18, "center")
        
        -- Поле ввода
        local inputColor = speedInput.active and Color(60, 60, 70, alpha) or Color(speedInput.color.r, speedInput.color.g, speedInput.color.b, alpha)
        drawRoundedRect(speedInput.position, speedInput.size, 8, inputColor)
        drawText(speedInput.text, Vector2(speedInput.position.x + 10, speedInput.position.y + 10), Color(255, 255, 255, alpha), 16)
        
        if speedInput.text == "" and not speedInput.active then
            drawText(speedInput.placeholder, Vector2(speedInput.position.x + 10, speedInput.position.y + 10), Color(150, 150, 150, alpha), 16)
        end
        
        -- Кнопки
        drawRoundedRect(setSpeedButton.position, setSpeedButton.size, 10, Color(setSpeedButton.color.r, setSpeedButton.color.g, setSpeedButton.color.b, alpha))
        drawText(setSpeedButton.text, Vector2(setSpeedButton.position.x + setSpeedButton.size.x/2, setSpeedButton.position.y + setSpeedButton.size.y/2 - 8), Color(255, 255, 255, alpha), 16, "center")
        
        drawRoundedRect(resetSpeedButton.position, resetSpeedButton.size, 10, Color(resetSpeedButton.color.r, resetSpeedButton.color.g, resetSpeedButton.color.b, alpha))
        drawText(resetSpeedButton.text, Vector2(resetSpeedButton.position.x + resetSpeedButton.size.x/2, resetSpeedButton.position.y + resetSpeedButton.size.y/2 - 8), Color(255, 255, 255, alpha), 16, "center")
        
        -- Кнопка закрытия
        drawRoundedRect(closeButton.position, closeButton.size, 15, Color(closeButton.color.r, closeButton.color.g, closeButton.color.b, alpha))
        drawText(closeButton.text, Vector2(closeButton.position.x + closeButton.size.x/2, closeButton.position.y + closeButton.size.y/2 - 8), Color(255, 255, 255, alpha), 18, "center")
        
        -- Текущая скорость
        drawText("Текущая: " .. currentSpeed .. "x", Vector2(125, 310), Color(200, 200, 200, alpha), 14, "center")
    end
end

-- Обработка ввода с клавиатуры
function onTextInput(text)
    if speedInput.active then
        if text == "\b" then
            -- Backspace
            speedInput.text = speedInput.text:sub(1, -2)
        elseif text:match("[%d%.]") and #speedInput.text < 6 then
            -- Только цифры и точка
            speedInput.text = speedInput.text .. text
        end
    end
end

-- Инициализация
function init()
    print("Скрипт управления скоростью загружен!")
    print("Нажмите на иконку в левом верхнем углу для открытия меню")
end

-- Очистка
function cleanup()
    setPlayerSpeed(defaultSpeed)
    print("Скрипт управления скоростью выгружен")
end
