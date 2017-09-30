--Reqs
local P = require('Assets/Entities/Player')
local Menu = require('Assets/Scenes/Menu')

--Settings
local Width = love.graphics.getWidth()
local Height = love.graphics.getHeight()
love.graphics.setDefaultFilter('nearest', 'nearest')
currentScene = Menu
choice = nil

function love.load()
end

function love.update(dt)
  currentScene:update(dt)
end

function love.draw()
  currentScene:draw()
end
