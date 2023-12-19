local Socket = require("Socket")

local function listen(callback)
  Socket.listen(function()
    local sendMessage = function(table)
      table.command = table.command or "message"

      local identifier = table.identifier or {}
      identifier.channel = "RobotChannel"
      identifier.computer_id = os.getComputerID()

      table.identifier = textutils.serialiseJSON(identifier)

      local serialized_table = textutils.serialiseJSON(table)

      Socket.send(serialized_table)
    end

    local function onMessage(messageCallback)
      Socket.onMessage(messageCallback)
    end

    local function subscribe()
      sendMessage({
        command = "subscribe",
      })

      Socket.expectResponse(function (response)
        if response then
          local json_data = textutils.unserialiseJSON(response)

          if json_data then
            if json_data.type == "confirm_subscription" then
              return json_data
            end
          end
        end
      end)

      callback({
        sendMessage = sendMessage,
        onMessage = onMessage,
      })
    end

    return {
      url = "ws://localhost:3001/cable",
      subscribe = subscribe,
    }
  end)
end

return listen
