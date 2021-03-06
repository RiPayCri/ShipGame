local Read = {}

function Read:readServer()
  if io.open("Test/server.txt", "r") ~= nil then
    ServStuff = {}
    file = io.open("Test/server.txt", r)
    empty = file:read()
    ServStuff.Address = file:read()
    ServStuff.Address = string.sub(ServStuff.Address, 10)
    ServStuff.Port = file:read()
    ServStuff.Port = string.sub(ServStuff.Port, 7)
    ServStuff.Port = tonumber(ServStuff.Port)
    io.close(file)
    return ServStuff
  else
    print("Could not find server.txt")
  end
end

function Read:readClient()
  if io.open("Test/server.txt", "r") ~= nil then
    CliStuff = {}
    file = io.open("Test/server.txt", "r")
    for i = 1, 5 do
      empty = file:read()
    end
    CliStuff.Address = file:read()
    CliStuff.Address = string.sub(CliStuff.Address, 10)
    CliStuff.Port = file:read()
    CliStuff.Port = string.sub(CliStuff.Port, 7)
    CliStuff.Port = tonumber(CliStuff.Port)
    io.close(file)
    return CliStuff
  end
end

function Read:readProperties()
  if io.open("Test/server.txt", "r") ~= nil then
    Properties = {}
    file = io.open("Test/server.txt", "r")
    for i = 1, 9 do
      empty = file:read()
    end
    Properties.bulletCollision = file:read()
    Properties.bulletCollision = string.sub(Properties.bulletCollision, 20)
    if Properties.bulletCollision == 'true' then
      Properties.bulletCollision = true
    elseif Properties.bulletCollision == 'false' then
      Properties.bulletCollision = false
    else
      error("BulletCollision Property: not true or false")
    end
    return Properties
  end
end

return Read
