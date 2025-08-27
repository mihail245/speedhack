-- SpeedHack UI с анимациями
local speedhack = {
    enabled = false,
    speed = 1.0,
    menuOpen = false,
    animationProgress = 0,
    targetAnimationProgress = 0
}

-- Цвета темной темы
local colors = {
    background = {0.12, 0.12, 0.12, 0.95},
    primary = {0.26, 0.26, 0.28, 1.0},
    accent = {0.05, 0.55, 0.85, 1.0},
    text = {0.95, 0.95, 0.95, 1.0},
    border = {0.35, 0.35, 0.35, 1.0},
    hover = {0.35, 0.35, 0.35, 0.3}
}

-- Размеры и позиции
local sizes = {
    icon = 40,
    menuWidth = 250,
    menuHeight = 180,
    padding = 15,
    buttonHeight = 35,
    sliderHeight = 20
}

local positions = {
    icon = {x = 50, y = 50},
    menu = {x = 50, y = 100}
}

-- Анимация
local function animate(dt)
    if speedhack.animationProgress < speedhack.targetAnimationProgress then
        speedhack.animationProgress = math.min(speedhack.animationProgress + dt * 8, speedhack.targetAnimationProgress)
    elseif speedhack.animationProgress > speedhack.targetAnimationProgress then
        speedhack.animationProgress = math.max(speedhack.animationProgress - dt * 8, speedhack.targetAnimationProgress)
    end
end

-- Отрисовка закругленного прямоугольника
local function drawRoundedRect(x, y, w, h, radius, color)
    local r, g, b, a = table.unpack(color)
    imgui.DrawList_AddRectFilledRound(x, y, x + w, y + h, radius, 12, imgui.GetColorU32(r, g, b, a))
end

-- Отрисовка иконки
local function drawIcon()
    local iconX, iconY = positions.icon.x, positions.icon.y
    local iconSize = sizes.icon
    
    -- Фон иконки
    drawRoundedRect(iconX, iconY, iconSize, iconSize, 8, colors.primary)
    
    -- Анимация иконки
    local rotation = speedhack.animationProgress * 90
    local scale = 0.8 + math.sin(speedhack.animationProgress * math.pi) * 0.2
    
    if speedhack.menuOpen then
        -- Крестик
        local centerX, centerY = iconX + iconSize/2, iconY + iconSize/2
        local lineSize = iconSize * 0.35 * scale
        
        imgui.DrawList_AddLine(
            centerX - lineSize, centerY - lineSize,
            centerX + lineSize, centerY + lineSize,
            imgui.GetColorU32(1, 1, 1, 1), 3
        )
        imgui.DrawList_AddLine(
            centerX + lineSize, centerY - lineSize,
            centerX - lineSize, centerY + lineSize,
            imgui.GetColorU32(1, 1, 1, 1), 3
        )
    else
        -- Машинка с анимацией
        local carX, carY = iconX + iconSize/2, iconY + iconSize/2
        local carSize = iconSize * 0.5 * scale
        
        -- Кузов машинки
        drawRoundedRect(carX - carSize*0.8, carY - carSize*0.3, carSize*1.6, carSize*0.8, 5, {0.8, 0.2, 0.2, 1.0})
        
        -- Окна
        drawRoundedRect(carX - carSize*0.6, carY - carSize*0.25, carSize*1.2, carSize*0.4, 3, {0.6, 0.8, 1.0, 0.7})
        
        -- Колеса
        drawRoundedRect(carX - carSize*0.7, carY + carSize*0.3, carSize*0.3, carSize*0.3, carSize*0.15, {0.1, 0.1, 0.1, 1.0})
        drawRoundedRect(carX + carSize*0.4, carY + carSize*0.3, carSize*0.3, carSize*0.3, carSize*0.15, {0.1, 0.1, 0.1, 1.0})
    end
end

-- Отрисовка меню
local function drawMenu()
    if speedhack.menuOpen or speedhack.animationProgress > 0 then
        local menuAlpha = speedhack.animationProgress
        local menuX, menuY = positions.menu.x, positions.menu.y
        
        -- Фон меню с анимацией
        local currentColors = {
            background = {colors.background[1], colors.background[2], colors.background[3], colors.background[4] * menuAlpha},
            text = {colors.text[1], colors.text[2], colors.text[3], colors.text[4] * menuAlpha}
        }
        
        drawRoundedRect(menuX, menuY, sizes.menuWidth, sizes.menuHeight, 12, currentColors.background)
        
        -- Заголовок
        imgui.SetCursorPos(menuX + sizes.padding, menuY + sizes.padding)
        imgui.TextColored(table.unpack(currentColors.text), "🚗 SpeedHack")
        
        imgui.SetCursorPos(menuX + sizes.padding, menuY + sizes.padding * 3)
        
        -- Слайдер скорости
        imgui.TextColored(table.unpack(currentColors.text), "Скорость: %.1fx", speedhack.speed)
        imgui.SetCursorPos(menuX + sizes.padding, menuY + sizes.padding * 5)
        
        if imgui.SliderFloat("##speed", speedhack.speed, 0.1, 10.0, "%.1f", sizes.menuWidth - sizes.padding * 2) then
            if speedhack.enabled then
                setGameSpeed(speedhack.speed)
            end
        end
        
        -- Кнопка включения/выключения
        imgui.SetCursorPos(menuX + sizes.padding, menuY + sizes.menuHeight - sizes.buttonHeight - sizes.padding)
        
        local buttonColor = speedhack.enabled and {0.8, 0.2, 0.2, 0.8} or {0.2, 0.8, 0.2, 0.8}
        local buttonText = speedhack.enabled and "Выключить" or "Включить"
        
        if imgui.Button(buttonText, sizes.menuWidth - sizes.padding * 2, sizes.buttonHeight) then
            speedhack.enabled = not speedhack.enabled
            if speedhack.enabled then
                setGameSpeed(speedhack.speed)
            else
                setGameSpeed(1.0)
            end
        end
    end
end

-- Основная функция рендеринга
function onRender()
    animate(imgui.GetIO().DeltaTime)
    
    -- Проверка клика по иконке
    local mousePos = imgui.GetMousePos()
    local iconRect = {
        x = positions.icon.x,
        y = positions.icon.y,
        w = sizes.icon,
        h = sizes.icon
    }
    
    local isHovering = mousePos.x >= iconRect.x and mousePos.x <= iconRect.x + iconRect.w and
                      mousePos.y >= iconRect.y and mousePos.y <= iconRect.y + iconRect.h
    
    -- Подсветка при наведении
    if isHovering then
        drawRoundedRect(iconRect.x - 2, iconRect.y - 2, iconRect.w + 4, iconRect.h + 4, 10, colors.hover)
    end
    
    -- Отрисовка иконки
    drawIcon()
    
    -- Отрисовка меню
    drawMenu()
    
    -- Обработка клика
    if imgui.IsMouseClicked(0) and isHovering then
        speedhack.menuOpen = not speedhack.menuOpen
        speedhack.targetAnimationProgress = speedhack.menuOpen and 1.0 or 0.0
    end
end

-- Функция установки скорости игры (замените на вашу реализацию)
function setGameSpeed(speed)
    -- Ваша реализация изменения скорости игры здесь
    print("Установлена скорость: " .. tostring(speed) .. "x")
end

-- Инициализация
print("🚗 SpeedHack загружен! Нажмите на иконку машинки чтобы открыть меню.")
