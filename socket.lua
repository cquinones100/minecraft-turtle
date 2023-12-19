local pretty = require "cc.pretty"
Socket = {}

function getConnection(url)
  local ws

  local _status, err = pcall(function()
    ws = assert(http.websocket(url))
  end)

  if err then
    error("Could not connect to server. Is it running?")
  else
    print("Connected to server")

    return ws
  end
end

function Socket:new(url)
  local obj = {
    ws = nil,

    hooks = {},

    actions = {},

    url = url
  }

  obj.ws = getConnection(url)

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

function Socket:listen()
  while true do
    local _status, err = pcall(function()
      self:readMessages()
    end)

    if err then
      print("Websocket connection appears to have been closed. Retrying in 5 seconds")

      sleep(5)

      local _status, _err = pcall(function()
        self.ws = getConnection(self.url)
      end)

      if not err then
        break
      end
    end
  end
end

return Socket
