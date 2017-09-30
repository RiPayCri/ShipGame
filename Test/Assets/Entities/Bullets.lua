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
  mask = hc.rectangle(bullet.x, bullet.y, 5, 5)
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
  for _,b in pairs(bulletcontroller.bullets) do
    b.x = b.x + b.v.x * dt
    b.y = b.y + b.v.y * dt
  end
end

function Bullets:draw()
  --Draws in the bullets
  for _,b in pairs(bulletcontroller.bullets) do
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle('fill', b.x, b.y, b.s, b.s)
  end
end

function Bullets:draw2(data)
  --Draws other bullets
  for _,b in pairs(data) do
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle('fill', b.x, b.y, 5, 5)
  end
end

function Bullets:update2(data, dt, prop)
  --Moves the other bullets
  for _,b in pairs(data) do
    b.x = b.x + b.v.x * dt
    b.y = b.y + b.v.y * dt
    if prop.bulletCollision == true then
      b.mask:moveTo(b.x, b.y)
    end
  end
end

return Bullets
