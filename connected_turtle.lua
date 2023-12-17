local Socket = require("socket")
local pretty = require "cc.pretty"

function setupCoordinates()
  print("Enter your coordinates:")
  print("x: ")
  local x = read()

  print("y: ")
  local y = read()

  print("z: ")
  local z = read()

  print("facing: ")
  local facing = read()

  return { x = x, y = y, z = z, direction = facing }
end

function run()
  local coordinates = setupCoordinates()

  print("Establishing connection to server")
  local socket = Socket:new("RobotChannel")

  socket:subscribe(coordinates)

  function rollCall()
    socket:sendMessage({
      command = "message",

      data = textutils.serialiseJSON({
        action = "acknowledgement",
        computer_id = os.getComputerID(),
        coordinates = coordinates,
      }),
    })
  end

  rollCall()

  socket:onMessage(function(data)
    if type(data.message) == "table" then
      if data.message.type == "mine" then
        print("MINING 3")
      end
    end
  end)

  socket:listen()
end

return { run = run }
