--Local Requirements
local P = require('Assets/Entities/Player')
local sock = require('Assets/Tools/sock')
local bitser = require('Assets/Tools/bitser')
local read = require('Assets/Tools/read')
local bullets = require('Assets/Entities/Bullets')

--Local Variables
local Height, Width = love.graphics.getHeight(), love.graphics.getWidth()

local Game = {}

--Creates the Player and Players
local pl = P:create()
local Players = {}
local tempdata = nil

--Server stuff
clientstuff = read:readClient()
local client = sock.newClient(clientstuff.Address, clientstuff.Port)
client:setSerialization(bitser.dumps, bitser.loads)
client:connect()

--Client data
client:setSchema('Playersdata', {
  'id',
  'x',
  'y',
  'v',
  'deg',
  'push'
})

client:on('Playersdata', function(data)
  if Players["Player" .. data.id] ~= nil then
    Players["Player" .. data.id] = data
  else
    Players["Player" .. data.id] = {}
  end
  tempdata = data.id
end)

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
  client:send('Playerdata', {
    pl.id,
    pl.x,
    pl.y,
    pl.v,
    pl.deg,
    pl.push
  })

  --updates the other players
  if table.getn(Players) > 0 then
    for _,v in pairs(Players) do
      P:otherMove(v, dt)
    end
  end
end

function Game:draw()
  --Draws the Player
  P:draw(pl)


  --Draws the other Players
  if table.getn(Players) > 0 then
    for _,v in pairs(Players) do
      P:clidraw(pl, v)
    end
  end

  if tempdata ~= nil then
    love.graphics.print(tempdata, 10, 10)
  end
end

return Game
