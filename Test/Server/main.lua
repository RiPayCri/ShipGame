--Local Requirements
local sock = require('Tools/sock')
local bitser = require('Tools/bitser')
local read = require('Tools/read')
require "socket"

--Local Variables
local Height, Width = love.graphics.getHeight(), love.graphics.getWidth()
local logs = {}

--The server
local s = socket.udp()
s:setpeername("74.125.115.104", 80)
local ip, _ = s:getsockname()

local server = sock.newServer('*', 22122, 5)
server:setSerialization(bitser.dumps, bitser.loads)
table.insert(logs, 1, string.format("Server has been created on %s:%s", ip, "22122"))

server:setSchema('Playerdata', {
  'id',
  'x',
  'y',
  'v',
  'deg',
  'push'
})

server:on('connect', function(data, client)
  table.insert(logs, 1, string.format("Client %s has joined the server", server:getClientCount()))
end)


server:on('disconnect', function(data, client)
  table.insert(logs, 1, "A client has left the server")
end)

server:on('Playerdata', function(data, client)
  server:sendToAllBut(client, 'Playersdata', {
    data.id,
    data.x,
    data.y,
    data.v,
    data.deg,
    data.push
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
  for i, v in ipairs(logs) do
    love.graphics.setColor(255, 255, 255, 255 - i * 10)
    love.graphics.printf(logs[i], 10, Height - i * 30, Width, "left")
  end
end
