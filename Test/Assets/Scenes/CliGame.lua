--Local Requirements
local P = require('Assets/Entities/Player')
local sock = require('Assets/Tools/sock')
local bitser = require('Assets/Tools/bitser')
local read = require('Assets/Tools/read')
local bullets = require('Assets/Entities/Bullets')

--Local Variables
local Height, Width = love.graphics.getHeight(), love.graphics.getWidth()

local Game = {}

local Data, clientTimer = nil, 30
local cliBullets = nil
local hostBullets = {}
local Props = {}

--Creates the Player
local pl = P:create2(100, 100)
local count = 0

--The Client
local clientData = read:readClient()
local client = sock.newClient(clientData.Address, clientData.Port)
client:setSerialization(bitser.dumps, bitser.loads)
client:setSchema('serverProps', {
  'bulletCollision'
})
client:setSchema('hostData', {
  'x',
  'y',
  'deg',
  'v',
  'push'
})
client:setSchema('hostFire', {
  'x',
  'y',
  'v'
})
client:on('hostData', function(data)
Data = data
Data = P:addValues(Data, pl)
end)
client:on('connect', function(data)
  client:send('playerData', {
    pl.x,
    pl.y,
    pl.deg,
    pl.v
  }
)
end)
client:on('serverProps', function(data)
  Props.bulletCollision = data.bulletCollision
end)
client:on('hostFire', function(data)
  b = {}
  b.x = data.x
  b.y = data.y
  b.v = data.v
  b.mask = bullets:addMask(b)
  table.insert(hostBullets, b)
end)
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
  --Player Functions
  if love.keyboard.isDown('escape') then
    client:disconnect()
  end

  P:update(pl, dt)
  WallLoop(pl)
  if client:isConnected() then
    if love.keyboard.isDown('space') then
      cliBullets = bullets:grabBullets()
      for i,b in ipairs(cliBullets) do
        if i > count then
          count = i
          client:send('clientFire', {
            b.x,
            b.y,
            b.v
          })
        end
      end
    end
    if Data ~= nil then
      P:collisionPlayer(pl, Data, hostBullets, Props)
    end
    if hostBullets ~= nil then
      bullets:update2(hostBullets, dt)
    end
  end
  --Client Functions
  client:send('playerData', {
    pl.x,
    pl.y,
    pl.deg,
    pl.v,
    pl.push
  })
  client:update()
  if clientTimer > 0 then
    clientTimer = clientTimer - 1
  end

  if clientTimer <= 0 then
    P:otherMove(Data, dt)
  end
end

function Game:draw()
  --Draws the Player
  P:draw(pl)

  --Draws the host
  if clientTimer <= 0 then
    P:clidraw(pl, Data)
  end

  if hostBullets ~= nil then
    bullets:draw2(hostBullets)
  end
end

return Game
