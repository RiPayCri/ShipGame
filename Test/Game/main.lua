--Reqs
local P = require('Assets/Entities/Player')
local Menu = require('Assets/Scenes/Menu')


--Settings
local Width = love.graphics.getWidth()
local Height = love.graphics.getHeight()
love.graphics.setDefaultFilter('nearest', 'nearest')
currentScene = Menu
choice = nil

--Global values
_G = {}
_G.shots = 0
_G.score = 0
_G.w = Width
_G.h = Height

function love.load()
end

function love.update(dt)
  --Updates the current scene
  currentScene:update(dt)
end

function love.draw()
  --Draws the current scene
  currentScene:draw()
end
