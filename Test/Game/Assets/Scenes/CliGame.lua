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
Ident = nil

--The data that is recieved from the server
client:setSchema('Playersdata', {
  'id',
  'data'
})

client:connect()

--The initial data sent upon connection to the server
client:on('connect', function(data)
  client:send('Playerdata', {
    pl.x,
    pl.y,
    pl.deg,
    pl.push
  })
end)

client:on('Identification', function(id)
  Ident = id
end)

--Player data that is recieved from the server
client:on('Playersdata', function(data)
  Data = data.data
  Data = P:addValues(Data, pl)

  if not (Ident == data.id) then
    print('Things are happening')
    Players[data.id] = Data
  else
    print('Things are not happening')
  end
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

  --The data that is sent to the server
  client:send('Playerdata',{
    pl.x,
    pl.y,
    pl.deg,
    pl.push
  })

  --updates the other players
  if table.getn(Players) > 0 then
    for i,v in ipairs(Players) do
      P:otherMove(v, dt)
    end
  end
end

function Game:draw()
  --Draws the Player
  P:draw(pl)


  --Draws the other Players
  if table.getn(Players) > 0 then
    for i,v in ipairs(Players) do
      P:clidraw(pl, Players[i])
    end
  end
end

return Game
