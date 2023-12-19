local pretty = require "cc.pretty"
Socket = {}

function Socket:new(url)
  local obj = {
    ws = assert(http.websocket(url)),

    hooks = {},

    actions = {},

    channel = channel,
  }

  setmetatable(obj, self)

  self.__index = self

  return obj
end

function Socket:send(message)
  self.ws.send(message)
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
