local Socket = require("socket")
local mine = require("mine").mine

function run()
  print("Establishing connection to server")

  local socket = Socket:new("MovementChannel")

  socket:subscribe()

  print("connected")

  socket:onMessage("roll_call", function (data)
    print("responding to roll call")

    socket:sendMessage({
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
