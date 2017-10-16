local Over = {}

function Over:update(dt)
  if love.keyboard.isDown('return') then
    love.event.quit("restart")
  end
end

function Over:draw()
  love.graphics.printf(string.format("Score: %d", _G.score), 100, (_G.h / 2) - 50, _G.h, "center")
  love.graphics.printf(string.format("Shots: %d", _G.shots), 100, (_G.h / 2) - 29, _G.h, "center")
  love.graphics.printf(string.format("Accuracy: %d percent", (_G.score / _G.shots)), 100, (_G.h / 2) - 8, _G.h, "center")
  love.graphics.printf("Press enter to go back to the menu", 100, (_G.h / 2) + 14, _G.h, "center")
end

return Over
