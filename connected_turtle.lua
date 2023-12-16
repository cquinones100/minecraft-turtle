local Socket = require("socket")
local coordinatedTurtle = require("coordinated_turtle")

function mine(theCoordinatedTurtle, onError)
  print("MINING")
  if theCoordinatedTurtle.getFuelLevel() < 1 then
    if not theCoordinatedTurtle.refuel() then
      print("Not enough fuel to do work!")

      onError()

      return
    end
  end

  theCoordinatedTurtle.forward()

  if theCoordinatedTurtle.detectDown() then
    theCoordinatedTurtle.dig()

    if theCoordinatedTurtle.detectUp() then
      theCoordinatedTurtle.digUp()
    end

    theCoordinatedTurtle.suck()
  else
    theCoordinatedTurtle.back()

    onError()
  end
end

function run()
  local coordinates = coordinatedTurtle.setupCoordinates()

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

  print("connected")

  socket:onMessage("roll_call", rollCall)

  socket:onMessage("move", function ()
    local i = 1

    socket:onTick("move", function (cancel)
      coordinatedTurtle.forward()

      if i == 5 then
        print("done moving")

        cancel({
          coordinates = coordinatedTurtle.getCoordinates(),
        })
      end

      i = i + 1
    end)
  end)

  local cancelMining = nil

  socket:onMessage("mine", function ()
    local i = 1

    socket:onTick("mine", function (cancel)
      cancelMining = cancel

      if i % 5 == 0 then
        rollCall()
      end

      mine(coordinatedTurtle, function ()
        cancel({
          coordinates = coordinatedTurtle.getCoordinates(),
        })
      end)
    end)
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
