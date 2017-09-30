--Local Requirements
local P = require('Assets/Entities/Player')
local sock = require('Assets/Tools/sock')
local bitser = require('Assets/Tools/bitser')
local read = require('Assets/Tools/read')
local bullets = require('Assets/Entities/Bullets')

--Variables
local Height, Width = love.graphics.getHeight(), love.graphics.getWidth()
local Data, count = nil, 0
local Bullets = {}
local Properties = read:readProperties()

local Game = {}

--Creates the Player
local pl = P:create()

--The server
local serverData = read:readServer()
local server = sock.newServer(serverData.Address, serverData.Port, '2')
server:setSerialization(bitser.dumps, bitser.loads)
server:setSchema('playerData', {
  'x',
  'y',
  'deg',
  'v',
  'push'
})
server:setSchema('clientFire', {
  'x',
  'y',
  'v'
})
server:on('playerData', function(data, client)
  Data = data
  Data = P:addValues(Data, pl)
end)
server:on('clientFire', function(data, client)
  b = {}
  b.x = data.x
  b.y = data.y
  b.v = data.v
  if Properties.bulletCollision == true then
    b.mask = bullets:addMask(b)
  end
  table.insert(Bullets, b)
end)
server:on('connect', function(data, client)
  server:sendToPeer(client, 'serverProps', {
    Properties.bulletCollision
  })
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
  --Player Functions
  P:update(pl, dt)
  WallLoop(pl)
  if server:getClientCount() > 0 then
    P:collisionPlayer(pl, Data, Bullets, Properties)
  end
  if love.keyboard.isDown('space') then
    cliBullets = bullets:grabBullets()
    for i,b in ipairs(cliBullets) do
      if i > count then
        count = i
        server:sendToAll('hostFire', {
          b.x,
          b.y,
          b.v
        })
      end
    end
  end

  --Server Functions
  server:sendToAll('hostData', {
    p.x,
    p.y,
    p.deg,
    p.v,
    p.push
  })
  server:update()

  --Bullet update
  if server:getClientCount() > 0 then
    P:otherMove(Data, dt)
    if Bullets ~= {} then
      bullets:update2(Bullets, dt, Properties)
    end
  end
end

function Game:draw()
  --Draws the players
  P:draw(p)

  --Draws the amount of clients that are connected
  love.graphics.print(server:getClientCount(), 10, 10)

  --Draws connected players
  if server:getClientCount() > 0 then
    P:clidraw(p, Data)
    if Bullets ~= {} then
      bullets:draw2(Bullets)
    end
  end
end

return Game
