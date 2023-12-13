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

function Socket:receive(callback)
  local data = self.ws.receive()

  if data then
    local json_data = textutils.unserialiseJSON(data)

    if json_data then
      callback(json_data)
    end
  end
end

function Socket:onMessage(type, callback)
  self.hooks[type] = callback
end

function Socket:onTick(identifier, callback)
  self.actions[identifier] = function()
    callback(function ()
      self.actions[identifier] = nil

      self:sendMessage({
        command = "message",

        data = textutils.serialiseJSON({
          action = identifier .. "_complete",
        }),
      })
    end)
  end
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
      if type(data.message) == "table" then
        for type, callback in pairs(self.hooks) do
          if data.message.type == type then
            callback(data.message)
          end
        end
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
    self:doActions()
  end
end

return Socket
