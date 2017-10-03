--Local Requirements
local sock = require('Tools/sock')
local bitser = require('Tools/bitser')
local read = require('Tools/read')

--Server stuff
servStuff = read:readServer()
server = sock.newServer(servStuff.Address, servStuff.Port)
server:setSerialization(bitser.dumps, bitser.loads)

function love.load()
end

server:on('connect', function(data, client)
  print('A player has connected')
end)

function love.update(dt)
  server:update()
end

function love.draw()
  love.graphics.print(server:getClientCount(), love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
end
