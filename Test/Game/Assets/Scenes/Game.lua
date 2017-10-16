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
local pausecounter = 30
local leveltxt, scoretxt = string.format('level %d', level), string.format('score: %d', score)

--Creation of the Game object
local Game = {}

--Entity initialization
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
  --Updates the player and its collisions
  P:update(p, dt)
  WallLoop(p)
  P:collisionAsteroid(p, asteroids)

  --Updates the global variables
  _G.shots = P:trackShots()
  _G.score = score

  --Updates the asteroids
  Eni:update(asteroids, dt)

  --Asteroid looping
  for i,a in ipairs(asteroids) do
    WallLoop(a)
  end

  --Grabs the bullets to check for collisions
  bullets = P:grabBullets()

  --Leveling and scoring
  score = Eni:checkCollision(asteroids, bullets, score)
  level = Eni:checkRespawn(level, asteroids)
  leveltxt = string.format('level %d', level)
  scoretxt = string.format('score: %d', score)

  --Pauseing
  pausecounter = pausecounter - 1
  if love.keyboard.isDown('escape') and pausecounter <= 0 then
    pausecounter = 30
    local Pause = require('Assets/Scenes/Pause')
    currentScene = Pause
  end

end

function Game:draw()
  P:draw(p)

  Eni:draw(asteroids)

  love.graphics.printf(leveltxt, 10, 10, 100)
  love.graphics.printf(scoretxt, Width - 80, 10, 80)
end

return Game
