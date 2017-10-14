local Read = {}

function Read:readClient()
  if io.open("Test/Game/server.txt", "r") ~= nil then
    ServStuff = {}
    file = io.open("Test/Game/server.txt", "r")
    empty = file:read()
    ServStuff.Address = file:read()
    ServStuff.Address = string.sub(ServStuff.Address, 10)
    ServStuff.Port = file:read()
    ServStuff.Port = string.sub(ServStuff.Port, 7)
    ServStuff.Port = tonumber(ServStuff.Port)
    io.close(file)
    return ServStuff
  else
    error("Could not find server.txt")
  end
end

return Read
