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
  listen(function(socket)
    local coordinates = setupCoordinates()

    local rollCall = function()
      socket.sendMessage({
        command = "message",

        data = textutils.serialiseJSON({
          action = "acknowledgement",
          computer_id = os.getComputerID(),
          coordinates = coordinates,
        }),
      })
    end

    rollCall()

    socket.onMessage(function(data)
      local function sendMessage(newMessage)
        local message_to_send = {
          data = {
            computer_id = os.getComputerID(),
            job_id = data.message.job_id,
            original_message = data.message,
          }
        }

        for key, value in pairs(newMessage) do
          message_to_send.data[key] = value
        end

        message_to_send.data = textutils.serialiseJSON(message_to_send.data)

        socket.sendMessage(message_to_send)
      end

      if type(data.message) == "table" then
        if data.message.type == 'turtle_action' or data.message.type == 'chained_action' then
          for _, action in ipairs(data.message.actions) do
            turtle[action]()
          end

          sendMessage({ action = "action_done", })
        elseif data.message.type == 'turtle_query' then
          response = {}

          for _, query in ipairs(data.message.queries) do
            response[query] = turtle[query]()
          end

          sendMessage({ action = "action_done", response = response })
        else
          print("Unknown message type")
        end
      end
    end)
  end)
end

return { run = run }
