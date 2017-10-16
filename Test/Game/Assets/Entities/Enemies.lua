local vect = require('Assets/Tools/vector')
local HC = require('Assets/Tools/HC')
local anim = require('Assets/Tools/anim8')

local Enemies = {}

local delay = 30
local delayt = 30

function Enemies:initializeAsteroids()
  enemycontroller = {}
  enemycontroller.Asteroids = {}
  return enemycontroller.Asteroids
end

function Enemies:createAsteroids(list, level)
  speed = (level * 15) * math.log10((level * level) + 1)

  for i = 1, level * 3 do
    asteroid = {}
    asteroid.x = love.math.random(love.graphics.getWidth())
    asteroid.y = love.math.random(love.graphics.getHeight())
    asteroid.v = vect(love.math.random(speed, -speed), love.math.random(speed, -speed))
    asteroid.image = love.graphics.newImage('Assets/Images/Asteroid.png')
    asteroid.h = asteroid.image:getHeight()
    asteroid.w = asteroid.image:getWidth()
    asteroid.ratio = 1
    asteroid.mask = HC.rectangle(asteroid.x, asteroid.y, asteroid.w, asteroid.h)
    asteroid.animimage = love.graphics.newImage('Assets/Images/AsteroidAnim.png')
    asteroid.g = anim.newGrid(32, 32, asteroid.animimage:getWidth(), asteroid.animimage:getHeight())
    asteroid.anim = anim.newAnimation(asteroid.g(1, '1-6'), 0.15)
    asteroid.destroyed = false
    asteroid.dtimer = 50
    asteroid.id = "asteroid"
    asteroid.rad = 0
    asteroid.rspeed = love.math.random(10)
    asteroid.audio = love.audio.newSource('Assets/Audio/Explosion.wav', 'static')
    table.insert(list, asteroid)
  end
end

function Enemies:update(enemies, dt)
  for i,enemy in ipairs(enemies) do
    enemy.x = enemy.x + enemy.v.x * dt
    enemy.y = enemy.y + enemy.v.y * dt
    enemy.mask:moveTo(enemy.x + enemy.w / 2, enemy.y + enemy.h / 2)

    if enemy.destroyed then
      enemy.dtimer = enemy.dtimer - 1
      enemy.anim:update(dt)
      if enemy.dtimer <= 0 then
        table.remove(enemies, i)
      end
    end

    if enemy.id == "asteroid" then
      enemy.rad = enemy.rad + enemy.rspeed * dt
      enemy.mask:setRotation(enemy.rad)
    end
  end
end

function Enemies:checkRespawn(level, enemies)
  if table.getn(enemies) <= 0 then
    level = level + 1
    Enemies:createAsteroids(enemies, level)
  end
  return level
end


function Enemies:draw(enemies)
  for i,enemy in ipairs(enemies) do
    if not enemy.destroyed then
      love.graphics.draw(enemy.image, enemy.x + enemy.w / 2, enemy.y + enemy.h / 2, enemy.rad, enemy.ratio, enemy.ratio, enemy.w / 2, enemy.h / 2)
    else
      enemy.anim:draw(enemy.animimage, enemy.x, enemy.y)
    end
  end
end

function Enemies:checkCollision(enemies, bullets, score)
  for i,enemy in ipairs(enemies) do
    for x,bullet in ipairs(bullets) do
      if enemy.mask:collidesWith(bullet.mask) then
        enemy.destroyed = true
        score = score + 100
        enemy.audio:play()
        table.remove(bullets, x)
      end
    end
  end
  return score
end

return Enemies
