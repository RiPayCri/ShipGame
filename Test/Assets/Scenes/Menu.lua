local Menu = {}

local box = love.graphics.newImage('Assets/Images/Box.png')
local imgH, imgW = box:getHeight(), box:getWidth()
local width, height = love.graphics.getWidth(), love.graphics.getHeight()

local choices = {
  'Start Game',
  'Multiplayer',
  'Exit'
}

local picked = false

local Multiplayer = {
  'Host',
  'Join'
}

local current = 1
local timer = 15
local clickTime = 15

function Menu:update(dt)
  timer = timer - 1
  clickTime = clickTime - 1
  if love.keyboard.isDown('up') and timer <= 0 then
    current = current - 1
    timer = 15
  elseif love.keyboard.isDown('down') and timer <= 0 then
    current = current + 1
    timer = 15
  end

  if not picked then
    if current < 1 then
      current = table.getn(choices)
    elseif current > table.getn(choices) then
      current = 1
    end
  elseif picked then
    if current < 1 then
      current = table.getn(Multiplayer)
    elseif current > table.getn(Multiplayer) then
      current = 1
    end
  end

  if love.keyboard.isDown('return') and clickTime <= 0 then
    clickTime = 15
    if not picked then
      if current == 1 then
        local Game = require('Assets/Scenes/Game')
        currentScene = Game
      elseif current == 2 then
        picked = true
        current = 1
      elseif current == 3 then
        love.event.quit()
      end
    elseif picked then
      if current == 1 and love.keyboard.isDown('return') then
        local HosGame = require('Assets/Scenes/HosGame')
        currentScene = HosGame
      elseif current == 2 then
        local CliGame = require('Assets/Scenes/CliGame')
        currentScene = CliGame
      end
    end
  end
end

function Menu:draw()
  if not picked then
    for i,v in ipairs(choices) do
      if current == i then
        love.graphics.setColor(75, 75, 255)
        love.graphics.draw(box, (width / 2) - (imgW / 2), (height / 2) + (i - 1) * (imgH + 10))
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(v, (width / 6) + 20, (height / 2) + (i - 1) * (imgH + 10) + (imgH / 3), 250, 'center', 0, 2)
      elseif current ~= i then
        love.graphics.setColor(0, 0, 150)
        love.graphics.draw(box, (width / 2) - (imgW / 2), (height / 2) + (i - 1) * (imgH + 10))
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(v, (width / 6) + 20, (height / 2) + (i - 1) * (imgH + 10) + (imgH / 3), 250, 'center', 0, 2)
      end
    end
  elseif picked then
    for i,v in ipairs(Multiplayer) do
      if current == i then
        love.graphics.setColor(75, 75, 255)
        love.graphics.draw(box, (width / 2) - (imgW / 2), (height / 2) + (i - 1) * (imgH + 10))
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(v, (width / 6) + 20, (height / 2) + (i - 1) * (imgH + 10) + (imgH / 3), 250, 'center', 0, 2)
      elseif current ~= i then
        love.graphics.setColor(0, 0, 150)
        love.graphics.draw(box, (width / 2) - (imgW / 2), (height / 2) + (i - 1) * (imgH + 10))
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(v, (width / 6) + 20, (height / 2) + (i - 1) * (imgH + 10) + (imgH / 3), 250, 'center', 0, 2)
      end
    end
  end
end

return Menu
