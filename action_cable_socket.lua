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

  print("Connected to server")

  callback({
    sendMessage = sendMessage,
    onMessage = onMessage,
  })

 local _status, err = pcall(function ()
    socket:listen()
  end)

  if err then
    socket = Socket:new("ws://localhost:3001/cable")

    socket:listen()
  end
end

return listen
