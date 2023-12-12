local Socket = require("socket")

function run()
  print("Establishing connection to server")

  local socket = Socket:new()

  socket:subscribe("MovementChannel")

  print("connected")

  socket:onMessage("roll_call", function (data)
    print("responding to roll call")

    socket:sendMessage("MovementChannel", {
      command = "message",

      data = textutils.serialiseJSON({
        action = "acknowledgement",
        computer_id = os.getComputerID(),
      }),
    })
  end)

  socket:onMessage("move", function ()
    turtle.forward()
  end)

  socket:listen()
end

return { run = run }
