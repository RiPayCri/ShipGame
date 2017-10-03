--Local Requirements
local P = require('Assets/Entities/Player')
local sock = require('Assets/Tools/sock')
local bitser = require('Assets/Tools/bitser')
local read = require('Assets/Tools/read')
local bullets = require('Assets/Entities/Bullets')

--Local Variables
local Height, Width = love.graphics.getHeight(), love.graphics.getWidth()

local Game = {}

--Creates the Player
local pl = P:create2(love.math.random(Width), love.math.random(Height))

--Client and functions
cliStuff = read:readClient()
client = sock.newClient(cliStuff.Address, cliStuff.Port)
client:setSerialization(bitser.dumps, bitser.loads)
client:connect()

--ExtraFunctions
--Loops the player around the map
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
  --Player functions
  P:update(pl, dt)
  WallLoop(pl)

  --Client functions
  client:update()
end

function Game:draw()
  --Draws the Player
  P:draw(pl)
end

return Game
