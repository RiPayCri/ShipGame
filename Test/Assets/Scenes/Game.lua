--Local reqs
local P = require('Assets/Entities/Player')

--Local Variables
local Height, Width = love.graphics.getHeight(), love.graphics.getWidth()

local Game = {}

local pl = P:create()

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
end

function Game:draw()
  P:draw(p)
end

return Game
