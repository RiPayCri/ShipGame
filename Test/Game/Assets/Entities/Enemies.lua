local vect = require('Assets/Tools/vector')

local Enemies = {}

function Enemies:initializeAsteroids()
  enemycontroller = {}
  enemycontroller.Asteroids = {}
  return enemycontroller.Asteroids
end

function Enemies:createAsteroids(list, level)
  speed = level * 50

  for i = 1, level * 5 do
    asteroid = {}
    asteroid.x = love.math.random(love.graphics.getWidth())
    asteroid.y = love.math.random(love.graphics.getHeight())
    asteroid.v = vect(love.math.random(speed, -speed), love.math.random(speed, -speed))
    asteroid.image = love.graphics.newImage('Assets/Images/Asteroid.png')
    asteroid.h = asteroid.image:getHeight()
    asteroid.w = asteroid.image:getWidth()
    asteroid.ratio = 1
    table.insert(list, asteroid)
  end
end

function Enemies:update(enemies, dt)
  for i,enemy in ipairs(enemies) do
    enemy.x = enemy.x + enemy.v.x * dt
    enemy.y = enemy.y + enemy.v.y * dt
  end
end

function Enemies:draw(enemies)
  for i,enemy in ipairs(enemies) do
    love.graphics.draw(enemy.image, enemy.x, enemy.y)
  end
end

return Enemies
