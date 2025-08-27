-- SpeedHack Mobile UI
local speedhack = {
    enabled = false,
    speed = 1.0,
    menuOpen = false,
    animationProgress = 0,
    dragStartPos = {x = 0, y = 0},
    isDragging = false,
    position = {x = 20, y = 50}
}

-- Цвета темной темы
local colors = {
    background = {0.12, 0.12, 0.12, 0.95},
    primary = {0.26, 0.26, 0.28, 1.0},
    accent = {0.05, 0.55, 0.85, 1.0},
    text = {0.95, 0.95, 0.95, 1.0},
    border = {0.35, 0.35, 0.35, 1.0},
    hover = {0.35, 0.35, 0.35, 0.3},
    button = {0.2, 0.5, 0.8, 1.0},
    buttonHover = {0.3, 0.6, 0.9, 1.0},
    buttonActive = {0.15, 0.4, 0.7, 1.0}
}

-- Размеры и позиции
local sizes = {
    headerHeight = 40,
    menuWidth = 280,
    menuHeight = 180,
    padding = 15,
    buttonHeight = 35,
    sliderHeight = 20,
    handleSize = 40,
    dragThreshold = 5
}

-- Анимация
local function animate(dt)
    if speedhack.animationProgress < (speedhack.menuOpen and 1 or 0) then
        speedhack.animationProgress = math.min(speedhack.animationProgress + dt * 8, 1)
    elseif speedhack.animationProgress > (speedhack.menuOpen and 1 or 0) then
        speedhack.animationProgress = math.max(speedhack.animationProgress - dt * 8, 0)
    end
end

-- Отрисовка закругленного прямоугольника
local function drawRoundedRect(x, y, w, h, radius, color)
    local r, g, b, a = table.unpack(color)
    imgui.DrawList_AddRectFilledRound(x, y, x + w, y + h, radius, 12, imgui.GetColorU32(r, g, b, a))
end

-- Отрисовка кнопки
local function drawButton(x, y, w, h, text, isActive)
    local mousePos = imgui.GetMousePos()
    local isHovering = mousePos.x >= x and mousePos.x <= x + w and mousePos.y >= y and mousePos.y <= y + h
    local isClicked = isHovering and imgui.IsMouseClicked(0)
    
    local color = isActive and colors.buttonActive or (isHovering and colors.buttonHover or colors.button)
    drawRoundedRect(x, y, w, h, 6, color)
    
    -- Текст кнопки
    local textWidth = imgui.CalcTextSize(text)
    imgui.DrawList_AddText(x + (w - textWidth) / 2, y + (h - imgui.GetFontSize()) / 2, 
                          imgui.GetColorU32(1, 1, 1, 1), text)
    
    return isClicked
end

-- Отрисовка заголовка с кнопкой закрытия
local function drawHeader()
    local headerX, headerY = speedhack.position.x, speedhack.position.y
    local headerWidth = sizes.menuWidth
    
    -- Фон заголовка
    drawRoundedRect(headerX, headerY, headerWidth, sizes.headerHeight, 8, colors.primary)
    
    -- Заголовок
    local title = "🚗 SpeedHack"
    local titleWidth = imgui.CalcTextSize(title)
    imgui.DrawList_AddText(headerX + sizes.padding, headerY + (sizes.headerHeight - imgui.GetFontSize()) / 2, 
                          imgui.GetColorU32(table.unpack(colors.text)), title)
    
    -- Кнопка закрытия/открытия
    local buttonSize = sizes.headerHeight - 10
    local buttonX = headerX + headerWidth - buttonSize - 5
    local buttonY = headerY + 5
    
    local mousePos = imgui.GetMousePos()
    local isHovering = mousePos.x >= buttonX and mousePos.x <= buttonX + buttonSize and 
                      mousePos.y >= buttonY and mousePos.y <= buttonY + buttonSize
    
    -- Анимированный крестик/бургер
    local centerX, centerY = buttonX + buttonSize/2, buttonY + buttonSize/2
    local lineSize = buttonSize * 0.4
    
    if speedhack.menuOpen then
        -- Крестик
        imgui.DrawList_AddLine(
            centerX - lineSize, centerY - lineSize,
            centerX + lineSize, centerY + lineSize,
            imgui.GetColorU32(1, 1, 1, 1), 2
        )
        imgui.DrawList_AddLine(
            centerX + lineSize, centerY - lineSize,
            centerX - lineSize, centerY + lineSize,
            imgui.GetColorU32(1, 1, 1, 1), 2
        )
    else
        -- Бургер меню
        local lineY1 = centerY - lineSize/2
        local lineY2 = centerY
        local lineY3 = centerY + lineSize/2
        
        imgui.DrawList_AddLine(
            centerX - lineSize, lineY1,
            centerX + lineSize, lineY1,
            imgui.GetColorU32(1, 1, 1, 1), 2
        )
        imgui.DrawList_AddLine(
            centerX - lineSize, lineY2,
            centerX + lineSize, lineY2,
            imgui.GetColorU32(1, 1, 1, 1), 2
        )
        imgui.DrawList_AddLine(
            centerX - lineSize, lineY3,
            centerX + lineSize, lineY3,
            imgui.GetColorU32(1, 1, 1, 1), 2
        )
    end
    
    -- Обработка клика по кнопке
    if isHovering and imgui.IsMouseClicked(0) then
        speedhack.menuOpen = not speedhack.menuOpen
        return true
    end
    
    -- Проверка на начало перетаскивания
    local isInHeader = mousePos.x >= headerX and mousePos.x <= headerX + headerWidth and 
                      mousePos.y >= headerY and mousePos.y <= headerY + sizes.headerHeight
    
    if isInHeader and imgui.IsMouseClicked(0) then
        speedhack.dragStartPos = {x = mousePos.x - speedhack.position.x, y = mousePos.y - speedhack.position.y}
        speedhack.isDragging = true
    end
    
    if imgui.IsMouseDown(0) and speedhack.isDragging then
        speedhack.position.x = mousePos.x - speedhack.dragStartPos.x
        speedhack.position.y = mousePos.y - speedhack.dragStartPos.y
        
        -- Ограничение позиции в пределах экрана
        local screenWidth, screenHeight = getScreenSize()
        speedhack.position.x = math.max(0, math.min(screenWidth - sizes.menuWidth, speedhack.position.x))
        speedhack.position.y = math.max(0, math.min(screenHeight - sizes.menuHeight, speedhack.position.y))
    else
        speedhack.isDragging = false
    end
    
    return false
end

-- Отрисовка меню
local function drawMenu()
    if speedhack.menuOpen or speedhack.animationProgress > 0 then
        local menuAlpha = speedhack.animationProgress
        local menuX, menuY = speedhack.position.x, speedhack.position.y + sizes.headerHeight
        
        -- Фон меню с анимацией
        local currentColors = {
            background = {colors.background[1], colors.background[2], colors.background[3], colors.background[4] * menuAlpha},
            text = {colors.text[1], colors.text[2], colors.text[3], colors.text[4] * menuAlpha}
        }
        
        drawRoundedRect(menuX, menuY, sizes.menuWidth, sizes.menuHeight, 8, currentColors.background)
        
        -- Содержимое меню
        local contentY = menuY + sizes.padding
        
        -- Слайдер скорости
        imgui.SetCursorPos(menuX + sizes.padding, contentY)
        imgui.TextColored(table.unpack(currentColors.text), "Скорость: %.1fx", speedhack.speed)
        
        imgui.SetCursorPos(menuX + sizes.padding, contentY + imgui.GetFontSize() + 5)
        if imgui.SliderFloat("##speed", speedhack.speed, 0.1, 10.0, "%.1f", sizes.menuWidth - sizes.padding * 2) then
            if speedhack.enabled then
                setGameSpeed(speedhack.speed)
            end
        end
        
        -- Кнопка включения/выключения
        local buttonY = contentY + imgui.GetFontSize() * 2 + sizes.sliderHeight + 15
        local buttonText = speedhack.enabled and "ВЫКЛЮЧИТЬ" or "ВКЛЮЧИТЬ"
        
        if drawButton(menuX + sizes.padding, buttonY, sizes.menuWidth - sizes.padding * 2, sizes.buttonHeight, buttonText, speedhack.enabled) then
            speedhack.enabled = not speedhack.enabled
            if speedhack.enabled then
                setGameSpeed(speedhack.speed)
            else
                setGameSpeed(1.0)
            end
        end
        
        -- Информация о состоянии
        local statusY = buttonY + sizes.buttonHeight + 10
        local statusText = speedhack.enabled and "Активно" or "Неактивно"
        local statusColor = speedhack.enabled and {0.2, 0.8, 0.2, menuAlpha} or {0.8, 0.2, 0.2, menuAlpha}
        
        imgui.SetCursorPos(menuX + sizes.padding, statusY)
        imgui.TextColored(statusColor[1], statusColor[2], statusColor[3], statusColor[4], "Статус: " .. statusText)
    end
end

-- Основная функция рендеринга
function onRender()
    animate(imgui.GetIO().DeltaTime)
    
    -- Отрисовка заголовка
    drawHeader()
    
    -- Отрисовка меню
    drawMenu()
end

-- Функция установки скорости игры (замените на вашу реализацию)
function setGameSpeed(speed)
    -- Ваша реализация изменения скорости игры здесь
    print("Установлена скорость: " .. tostring(speed) .. "x")
end

-- Функция получения размера экрана (замените на вашу реализацию)
function getScreenSize()
    -- Замените на реальное получение размера экрана
    return 1920, 1080
end

-- Инициализация
print("🚗 Mobile SpeedHack загружен!")
print("Нажмите на заголовок чтобы перетащить меню")
print("Нажмите на кнопку в правом углу чтобы открыть/закрыть меню")
