--Local reqs
local P = require('Assets/Entities/Player')
local Eni = require('Assets/Entities/Enemies')

--Local Variables
local Height, Width = love.graphics.getHeight(), love.graphics.getWidth()
local level = 1
local score = 0
local shots = 0
_G.shots = 0
_G.score = 0
local leveltxt, scoretxt = string.format('level %d', level), string.format('score: %d', score)

local Game = {}

local pl = P:create()
local asteroids = Eni:initializeAsteroids()

Eni:createAsteroids(asteroids, level)

--ExtraFunctions
function WallLoop(obj)
  if obj.y < 0 then
    obj.y = Height - (obj.h * obj.ratio) / 2
  elseif obj.y > Height then
    obj.y = 0
  end

  if obj.x < 0 then
    obj.x = Width - (obj.w * obj.ratio) / 2
  elseif obj.x > Width then
    obj.x = 0
  end
end

function Game:update(dt)
  P:update(p, dt)
  WallLoop(p)
  P:collisionAsteroid(p, asteroids)

  _G.shots = P:trackShots()
  _G.score = score

  Eni:update(asteroids, dt)

  bullets = P:grabBullets()

  score = Eni:checkCollision(asteroids, bullets, score)
  level = Eni:checkRespawn(level, asteroids)

  for i,a in ipairs(asteroids) do
    WallLoop(a)
  end

  leveltxt = string.format('level %d', level)
  scoretxt = string.format('score: %d', score)
end

function Game:draw()
  P:draw(p)

  Eni:draw(asteroids)

  love.graphics.printf(leveltxt, 10, 10, 100)
  love.graphics.printf(scoretxt, Width - 80, 10, 80)
end

return Game
