--Local reqs
local P = require('Assets/Entities/Player')
local Eni = require('Assets/Entities/Enemies')

--Local Variables
local Height, Width = love.graphics.getHeight(), love.graphics.getWidth()
local level = 5

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

  Eni:update(asteroids, dt)

  for i,a in ipairs(asteroids) do
    WallLoop(a)
  end
end

function Game:draw()
  P:draw(p)

  Eni:draw(asteroids)
end

return Game
