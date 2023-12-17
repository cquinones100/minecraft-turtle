Socket = {}

function Socket:new(channel)
  local obj = {
    ws = assert(http.websocket("ws://localhost:3001/cable")),

    hooks = {},

    actions = {},

    channel = channel,
  }

  setmetatable(obj, self)

  self.__index = self

  return obj
end

function Socket:sendMessage(table, expect_response)
  local identifier = table.identifier or {}

  identifier.channel = self.channel
  identifier.computer_id = os.getComputerID()

  table.identifier = textutils.serialiseJSON(identifier)

  local serialized_table = textutils.serialiseJSON(table)

  self.ws.send(serialized_table)

  if expect_response then
    self:expectResponse(expect_response)
  end
end

function Socket:expectResponse(type)
  while true do
    local data = self.ws.receive()

    if data then
      local json_data = textutils.unserialiseJSON(data)

      if json_data then
        if json_data.type == type then
          return json_data
        end
      end
    end
  end
end

function Socket:subscribe(coordinates)
  self:sendMessage({
    command = "subscribe",

    data = {
      coordinates = coordinates,
    },
  }, "confirm_subscription")
end

function Socket:onMessage(callback)
  table.insert(self.hooks, callback)
end

function Socket:handleData(data, callback)
  local json_data = textutils.unserialiseJSON(data)

  if json_data then
    callback(json_data)
  end
end

function Socket:readMessages()
  local event = self.ws.receive(0.5)

  if event ~= nil then
    self:handleData(event, function (data)
      for _, hook in ipairs(self.hooks) do
        hook(data)
      end
    end)
  end
end

function Socket:doActions()
  for _, action in pairs(self.actions) do
    action()
  end
end

function Socket:listen()
  while true do
    self:readMessages()
  end
end

return Socket
