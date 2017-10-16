local Pause = {}

pc = 30

function Pause:update(dt)
  pc = pc - 1
  if love.keyboard.isDown('escape') and pc <= 0 then
    pc = 30
    local Game = require('Assets/Scenes/Game')
    currentScene = Game
  end
end

function Pause:draw()
  love.graphics.printf("Press escape to go back into the game", 0, _G.h / 2 - 8, _G.w, "center")
end

return Pause
