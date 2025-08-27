-- Основные переменные
local isMenuOpen = false
local animationProgress = 0
local targetAnimationProgress = 0
local currentSpeed = 1.0
local defaultSpeed = 1.0

-- Цветовая схема
local colors = {
    background = Color(20, 20, 25, 240),
    surface = Color(35, 35, 40, 255),
    primary = Color(50, 50, 55, 255),
    accent = Color(65, 65, 75, 255),
    text = Color(220, 220, 220, 255),
    hint = Color(150, 150, 150, 255),
    success = Color(80, 200, 120, 255),
    error = Color(200, 80, 80, 255)
}

-- Иконка меню (символ вместо спрайта)
local menuIcon = {
    position = Vector2(30, 30),
    size = Vector2(60, 60),
    color = colors.accent,
    hoverColor = Color(85, 85, 95, 255),
    isHovered = false
}

-- Основное меню
local mainMenu = {
    visible = false,
    position = Vector2(80, 80),
    size = Vector2(280, 380),
    cornerRadius = 20
}

-- Элементы меню
local speedInput = {
    text = "1.0",
    position = Vector2(100, 180),
    size = Vector2(240, 50),
    active = false,
    placeholder = "Введите скорость"
}

local setSpeedButton = {
    text = "УСТАНОВИТЬ СКОРОСТЬ",
    position = Vector2(100, 250),
    size = Vector2(240, 55),
    isHovered = false
}

local resetSpeedButton = {
    text = "ОБЫЧНАЯ СКОРОСТЬ",
    position = Vector2(100, 320),
    size = Vector2(240, 55),
    isHovered = false
}

local closeButton = {
    text = "✕",
    position = Vector2(330, 90),
    size = Vector2(40, 40),
    isHovered = false
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

-- Функция рисования закругленного прямоугольника
function drawRoundedRect(position, size, radius, color)
    -- Простая реализация прямоугольника с закругленными углами
    drawRect(position, size, color, radius)
end

-- Функция рисования иконки
function drawMenuIcon()
    local iconColor = menuIcon.isHovered and menuIcon.hoverColor or menuIcon.color
    local alpha = 255 * animationProgress
    
    -- Фон иконки
    drawRoundedRect(menuIcon.position, menuIcon.size, 15, Color(iconColor.r, iconColor.g, iconColor.b, alpha))
    
    -- Символ скорости (три линии)
    local center = Vector2(menuIcon.position.x + menuIcon.size.x/2, menuIcon.position.y + menuIcon.size.y/2)
    local iconAlpha = isMenuOpen and alpha or 255
    
    -- Горизонтальные линии
    drawLine(
        Vector2(center.x - 15, center.y - 8),
        Vector2(center.x + 15, center.y - 8),
        Color(colors.text.r, colors.text.g, colors.text.b, iconAlpha),
        3
    )
    drawLine(
        Vector2(center.x - 12, center.y),
        Vector2(center.x + 12, center.y),
        Color(colors.text.r, colors.text.g, colors.text.b, iconAlpha),
        3
    )
    drawLine(
        Vector2(center.x - 9, center.y + 8),
        Vector2(center.x + 9, center.y + 8),
        Color(colors.text.r, colors.text.g, colors.text.b, iconAlpha),
        3
    )
end

-- Основная функция обновления
function update()
    -- Обновление анимации
    animationProgress = lerp(animationProgress, targetAnimationProgress, 0.15)
    
    -- Сброс состояний наведения
    menuIcon.isHovered = false
    setSpeedButton.isHovered = false
    resetSpeedButton.isHovered = false
    closeButton.isHovered = false
    
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
                    if speed and speed > 0 and speed <= 10 then
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
        
        -- Проверка наведения для анимаций
        if touch.phase == "MOVED" then
            if isTouchInRect(touch.position, menuIcon.position, menuIcon.size) then
                menuIcon.isHovered = true
            end
            
            if isMenuOpen then
                if isTouchInRect(touch.position, setSpeedButton.position, setSpeedButton.size) then
                    setSpeedButton.isHovered = true
                end
                if isTouchInRect(touch.position, resetSpeedButton.position, resetSpeedButton.size) then
                    resetSpeedButton.isHovered = true
                end
                if isTouchInRect(touch.position, closeButton.position, closeButton.size) then
                    closeButton.isHovered = true
                end
            end
        end
    end
    
    -- Обновление видимости меню
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
    -- Рисуем иконку меню (всегда видима)
    drawMenuIcon()
    
    -- Если меню видимо, рисуем его с анимацией
    if mainMenu.visible then
        local scale = animationProgress
        local alpha = 255 * animationProgress
        
        -- Фон меню с тенью
        drawRoundedRect(
            Vector2(mainMenu.position.x - 2, mainMenu.position.y - 2),
            Vector2(mainMenu.size.x + 4, mainMenu.size.y + 4),
            mainMenu.cornerRadius,
            Color(0, 0, 0, alpha * 0.3)
        )
        
        drawRoundedRect(
            mainMenu.position, 
            mainMenu.size, 
            mainMenu.cornerRadius, 
            Color(colors.background.r, colors.background.g, colors.background.b, alpha)
        )
        
        -- Заголовок
        drawText("УПРАВЛЕНИЕ СКОРОСТЬЮ", 
                Vector2(mainMenu.position.x + mainMenu.size.x/2, mainMenu.position.y + 40), 
                Color(colors.text.r, colors.text.g, colors.text.b, alpha), 
                20, "center", "bold")
        
        -- Поле ввода
        local inputColor = speedInput.active and colors.primary or colors.surface
        drawRoundedRect(speedInput.position, speedInput.size, 12, 
                       Color(inputColor.r, inputColor.g, inputColor.b, alpha))
        
        -- Текст в поле ввода
        if speedInput.text ~= "" then
            drawText(speedInput.text, 
                    Vector2(speedInput.position.x + 15, speedInput.position.y + 15), 
                    Color(colors.text.r, colors.text.g, colors.text.b, alpha), 
                    18)
        else
            drawText(speedInput.placeholder, 
                    Vector2(speedInput.position.x + 15, speedInput.position.y + 15), 
                    Color(colors.hint.r, colors.hint.g, colors.hint.b, alpha), 
                    18)
        end
        
        -- Кнопка установки скорости
        local setButtonColor = setSpeedButton.isHovered and colors.accent or colors.primary
        drawRoundedRect(setSpeedButton.position, setSpeedButton.size, 12, 
                       Color(setButtonColor.r, setButtonColor.g, setButtonColor.b, alpha))
        drawText(setSpeedButton.text, 
                Vector2(setSpeedButton.position.x + setSpeedButton.size.x/2, setSpeedButton.position.y + setSpeedButton.size.y/2 - 10), 
                Color(colors.text.r, colors.text.g, colors.text.b, alpha), 
                16, "center", "bold")
        
        -- Кнопка сброса скорости
        local resetButtonColor = resetSpeedButton.isHovered and colors.accent or colors.primary
        drawRoundedRect(resetSpeedButton.position, resetSpeedButton.size, 12, 
                       Color(resetButtonColor.r, resetButtonColor.g, resetButtonColor.b, alpha))
        drawText(resetSpeedButton.text, 
                Vector2(resetSpeedButton.position.x + resetSpeedButton.size.x/2, resetSpeedButton.position.y + resetSpeedButton.size.y/2 - 10), 
                Color(colors.text.r, colors.text.g, colors.text.b, alpha), 
                16, "center", "bold")
        
        -- Кнопка закрытия
        local closeButtonColor = closeButton.isHovered and Color(220, 90, 90, alpha) or Color(200, 70, 70, alpha)
        drawRoundedRect(closeButton.position, closeButton.size, 20, closeButtonColor)
        drawText(closeButton.text, 
                Vector2(closeButton.position.x + closeButton.size.x/2, closeButton.position.y + closeButton.size.y/2 - 12), 
                Color(255, 255, 255, alpha), 
                20, "center", "bold")
        
        -- Текущая скорость
        drawText("Текущая скорость: " .. currentSpeed .. "x", 
                Vector2(mainMenu.position.x + mainMenu.size.x/2, mainMenu.position.y + mainMenu.size.y - 30), 
                Color(colors.hint.r, colors.hint.g, colors.hint.b, alpha), 
                14, "center")
    end
end

-- Обработка ввода с клавиатуры
function onTextInput(text)
    if speedInput.active then
        if text == "\b" then
            -- Backspace
            speedInput.text = speedInput.text:sub(1, -2)
        elseif text:match("[%d%.]") and #speedInput.text < 6 then
            -- Только цифры и точка, максимум 6 символов
            if not (text == "." and speedInput.text:find("%.")) then -- Проверка на дублирование точки
                speedInput.text = speedInput.text .. text
            end
        end
    end
end

-- Инициализация
function init()
    print("🚀 Скрипт управления скоростью загружен!")
    print("👉 Нажмите на иконку в левом верхнем углу для открытия меню")
end

-- Очистка
function cleanup()
    setPlayerSpeed(defaultSpeed)
    print("📴 Скрипт управления скоростью выгружен")
end
