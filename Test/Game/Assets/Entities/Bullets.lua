--Reqs
local vect = require('Assets/Tools/vector')
local hc = require('Assets/Tools/HC')

local Bullets = {}

--Initializes the bullet collection object
function Bullets:init()
  bulletcontroller = {}
  bulletcontroller.bullets = {}
  bulletT = 15
  ch = 1
end

--Grabs the current list of bullets
function Bullets:grabBullets()
  return bulletcontroller.bullets
end

--Adds a mask to new bullets
function Bullets:addMask(bullet)
  mask = hc.point(bullet.x, bullet.y)
  return mask
end

--Creates new bullets
function Bullets:newBullet(t)
  bullet = {}
  if math.mod(t, 2) == 1 then
    bullet.x = p.x + p.w * p.ratio * 0.5 * math.cos(p.deg)
    bullet.y = p.y + p.h * p.ratio * 0.5 * math.sin(p.deg)
  elseif math.mod(t, 2) == 0 then
    bullet.x = p.x - p.w * p.ratio * 0.5 * math.cos(p.deg)
    bullet.y = p.y - p.h * p.ratio * 0.5 * math.sin(p.deg)
  end
  bullet.v = vect(p.v.x * 2 + math.sin(p.deg) * 150, p.v.y * 2 - math.cos(p.deg) * 150)
  bullet.s = 5
  bullet.mask = hc.point(bullet.x, bullet.y)
  table.insert(bulletcontroller.bullets, bullet)
end

function Bullets:update(dt)
  --Bullet Fire
  bulletT = bulletT - 1
  if love.keyboard.isDown('space') and bulletT <= 0 then
    Bullets:newBullet(ch)
    bulletT = 15
    ch = ch + 1
  end

  --Bullet movement
  for i,b in ipairs(bulletcontroller.bullets) do
    b.x = b.x + b.v.x * dt
    b.y = b.y + b.v.y * dt
    b.mask:moveTo(b.x, b.y)
    if b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() or b.x < 0 or b.y < 0 then
      table.remove(bulletcontroller.bullets, i)
    end
  end
end

function Bullets:draw()
  --Draws in the bullets
  for i,b in ipairs(bulletcontroller.bullets) do
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle('fill', b.x, b.y, b.s, b.s)
  end
end

function Bullets:draw2(data)
  --Draws other bullets
  for i,b in ipairs(data) do
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle('fill', b.x, b.y, 5, 5)
  end
end

function Bullets:update2(data, dt, prop)
  --Moves the other bullets
  for i,b in ipairs(data) do
    b.x = b.x + b.v.x * dt
    b.y = b.y + b.v.y * dt
    if prop.bulletCollision == true then
      b.mask:moveTo(b.x, b.y)
    end
  end
end

return Bullets
