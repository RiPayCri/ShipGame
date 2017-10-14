--Reqs
local Width = love.graphics.getWidth()
local Height = love.graphics.getHeight()
local vect = require('Assets/Tools/vector')
local bullet = require('Assets/Entities/Bullets')
local hc = require('Assets/Tools/HC')
local anim8 = require('Assets/Tools/anim8')

local player = {}

local zeroVector = vect(0,0)

--The player spawn function
function player:create()
  --Player values
  p = {}
  p.image = love.graphics.newImage('Assets/Images/Ship.png')
  p.image2 = love.graphics.newImage('Assets/Images/ShipAnim.png')
  p.w = p.image:getWidth()
  p.h = p.image:getHeight()
  p.ratio = 1/6
  p.x = love.math.random(love.graphics.getWidth())
  p.y = love.math.random(love.graphics.getHeight())
  p.v = vect(0, 0)
  p.acc = 10
  p.max = 200
  p.deg = 0
  p.whalf = (p.w * p.ratio) / 2
  p.hhalf = (p.h * p.ratio) / 2
  p.mask = hc.polygon(p.x , p.y - p.hhalf, p.x - p.whalf, p.y + p.hhalf, p.x + p.whalf, p.y + p.hhalf)
  p.push = false
  p.collisionTime = 20
  local g = anim8.newGrid(300, 318, p.image2:getWidth(), p.image2:getHeight())
  p.anim = anim8.newAnimation(g(1, '1-2'), 0.1)
  bullet:init()
  return p
end

--Server/client use, adds values to the objects
function player:addValues(data, p)
  data.mask = hc.polygon(data.x , data.y - p.hhalf, data.x - p.whalf, data.y + p.hhalf, data.x + p.whalf, data.y + p.hhalf)
  data.anim = p.anim
  return data
end

--The collision system
function player:collisionPlayer(p, data, bullets, props)
  if p.mask:collidesWith(data.mask) and p.collisionTime <= 0 then
    temp = data.v
    p.v = ((p.v * 0.5) + temp) / 2
    p.collisionTime = 20
  end
  if props.bulletCollision == true then
    for i,b in pairs(bullets) do
      if p.mask:collidesWith(b.mask) then
        temp = vect(b.v.x, b.v.y)
        p.v = ((p.v * 0.5) + (temp * 0.0625)) / 2
        table.remove(bullets, i)
      end
    end
  end
end

function player:update(p, dt)
  p.push = false
  p.collisionTime = p.collisionTime - 1

  --Player Controls
  if love.keyboard.isDown('up') and p.v:len() <= 50 then
    p.v.y = p.v.y - p.acc * dt * math.cos(p.deg)
    p.v.x = p.v.x + p.acc * dt * math.sin(p.deg)
    p.push = true
  elseif love.keyboard.isDown('down') and p.v:len() <= 50 then
    p.v.y = p.v.y + p.acc * dt * math.cos(p.deg)
    p.v.x = p.v.x - p.acc * dt * math.sin(p.deg)
    p.push = true
  end

  if love.keyboard.isDown('left') then
    p.deg = p.deg - 5 * dt
  elseif love.keyboard.isDown('right') then
    p.deg = p.deg + 5 * dt
  end

  if love.keyboard.isDown('lshift') then
    p.v.x = p.v.x * 0.95
    p.v.y = p.v.y * 0.95
    p.push = true
  end

  if love.keyboard.isDown('escape') then
    love.event.quit()
  end

  if p.push then
    p.anim:update(dt)
  end

  --Player movements
  p.y = p.y + p.v.y
  p.x = p.x + p.v.x
  p.mask:moveTo(p.x, p.y)
  p.mask:setRotation(p.deg)

  --Bulletstuff
  bullet:update(dt)
end

--Other player movement
function player:otherMove(data, dt)
  data.mask:moveTo(data.x, data.y)
  data.mask:setRotation(data.deg)
  if data.push then
    data.anim:update(dt)
  end
end

function player:draw(p)
  --Draws the player
  if p.push then
    love.graphics.setColor(255, 255, 255)
    p.anim:draw(p.image2, p.x, p.y, p.deg, p.ratio, p.ratio, p.w / 2, p.h / 2)
  else
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(p.image, p.x, p.y, p.deg, p.ratio, p.ratio, p.w / 2, p.h / 2)
  end

  --Draws the bullet
  bullet:draw()
end

function player:clidraw(p, data)
  --Draws the connected player
  if data.push then
    data.anim:draw(p.image2, data.x, data.y, data.deg, p.ratio, p.ratio, p.w / 2, p.h / 2)
  else
    love.graphics.draw(p.image, data.x, data.y, data.deg, p.ratio, p.ratio, p.w / 2, p.h / 2)
  end
end

return player
