local listen = require("action_cable_socket")
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

local run = function()
  local coordinates = setupCoordinates()

  local rollCall = function(socket)
    socket.sendMessage({
      command = "message",

      data = textutils.serialiseJSON({
        action = "acknowledgement",
        computer_id = os.getComputerID(),
        coordinates = coordinates,
      }),
    })
  end

  listen(function(socket)
    rollCall(socket)

    socket.onMessage(function(data)
      if type(data.message) == "table" then
        if data.message.type == 'turtle_action' or data.message.type == 'chained_action' then
          pretty.pretty_print(data.message)

          for _, action in ipairs(data.message.actions) do
            turtle[action]()
          end

          socket.sendMessage({
            command = "message",
            data = textutils.serialiseJSON({
              action = "action_done",
              computer_id = os.getComputerID(),
              job_id = data.message.job_id,
              original_message = data.message,
            }),
          })
        elseif data.message.type == 'turtle_query' then
          pretty.pretty_print(data.message)

          response = {}

          for _, query in ipairs(data.message.queries) do
            response[query] = turtle[query]()
          end

          socket.sendMessage({
            command = "message",

            data = textutils.serialiseJSON({
              action = "action_done",
              computer_id = os.getComputerID(),
              job_id = data.message.job_id,
              original_message = data.message,
              response = response,
            }),
          })
        else
          print("Unknown message type")
        end
      end
    end)
  end)
end

return { run = run }
