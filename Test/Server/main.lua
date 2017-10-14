--Local Requirements
local sock = require('Tools/sock')
local bitser = require('Tools/bitser')
local read = require('Tools/read')
require "socket"

--Local Variables
local Height, Width = love.graphics.getHeight(), love.graphics.getWidth()
local logs = {}

--The server's Ip address
local s = socket.udp()
s:setpeername("74.125.115.104", 80)
local ip, _ = s:getsockname()

--The actual server that is hosted
local server = sock.newServer('*', 22122, 5)
server:setSerialization(bitser.dumps, bitser.loads)
table.insert(logs, 1, string.format("Server has been created on %s:%s", ip, "22122"))

--Schema for the data recieved from clients
server:setSchema('Playerdata', {
  'x',
  'y',
  'deg',
  'push'
})

--When a client connects to the server, this text is printed to the screen.
server:on('connect', function(data, client)
  table.insert(logs, 1, string.format("Client %s has joined the server", client:getIndex()))
  client:send('Identification', client:getIndex())
end)

--When a client disconnects from the server, this text is displayed
server:on('disconnect', function(data, client)
  table.insert(logs, 1, "A client has left the server")
end)

--The actual data recieved and sent from and to the clients
server:on('Playerdata', function(data, client)
  server:sendToAll('Playersdata', {
    client:getIndex(),
    data
  })
end)

function love.load()
  entercount = 30
  choosing = false
end

function love.update(dt)
  if entercount > 0 then
    entercount = entercount - 1
  end

  if love.keyboard.isDown('return') and entercount <= 0 and choosing then
  end

  --Server functions
  server:update()
end

function love.draw()
  --The text that is drawn to the screen
  for i, v in ipairs(logs) do
    love.graphics.setColor(255, 255, 255, 255 - i * 10)
    love.graphics.printf(logs[i], 10, Height - i * 30, Width, "left")
  end
end
