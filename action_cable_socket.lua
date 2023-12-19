local Socket = require("socket")
local socket = Socket:new("ws://localhost:3001/cable")

local sendMessage = function(table)
  local identifier = table.identifier or {}
  identifier.channel = "RobotChannel"
  identifier.computer_id = os.getComputerID()

  table.identifier = textutils.serialiseJSON(identifier)

  local serialized_table = textutils.serialiseJSON(table)

  socket:send(serialized_table)
end

local function onMessage(callback)
  socket:onMessage(callback)
end

local function listen(callback)
  sendMessage({
    command = "subscribe"
  })

  socket:expectResponse("confirm_subscription")

  callback({
    sendMessage = sendMessage,
    onMessage = onMessage,
  })

  socket:listen()
end

return listen
