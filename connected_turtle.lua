local Socket = require("socket")
local coordinatedTurtle = require("coordinated_turtle")

function run()
  local coordinates = coordinatedTurtle.setupCoordinates()

  print("Establishing connection to server")
  local socket = Socket:new("MovementChannel")

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

  print("connected")

  socket:onMessage("roll_call", rollCall)

  socket:onMessage("move", function ()
    turtle.forward()
  end)

  socket:onMessage("say_hello", function ()
    local i = 1

    socket:onTick("say_hello", function (cancel)
      print("hello: " .. i)

      if i == 5 then
        print("done")

        cancel()
      end

      i = i + 1
    end)
  end)

  socket:listen()
end

return { run = run }
