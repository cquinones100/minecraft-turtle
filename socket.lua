Socket = {}

local function getConnection(url)
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

function Socket:new()
  local obj = {
    ws = nil,

    hooks = {},

    actions = {},

    url = nil,

    subscribe = nil,
  }

  setmetatable(obj, self)

  self.__index = self

  return obj
end

function Socket:send(message)
  self.ws.send(message)
end

function Socket:expectResponse(callback)
  while true do
    local data = self.ws.receive()

    if data then
      callback(data)

      break
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
      print(err)
      print("Websocket connection appears to have been closed. Retrying in 5 seconds")

      sleep(5)

      local _status, retryErr = pcall(function()
        self.ws = getConnection(self.url)

        print("Connection re-established")
      end)

      if retryErr then
        error(retryErr)
      end

      if not retryErr then
        break
      end
    end
  end
end

local function listen(callback)
  local socket = Socket:new()

  local args = callback(socket)

  socket.url = args.url
  socket.subscribe = args.subscribe
  socket.ws = getConnection(socket.url)

  args.subscribe()

  socket:listen()
end

return {
  listen = listen,
}
