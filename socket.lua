local url = nil
local ws = nil
local hooks = {}

local function getConnection()
  local _status, err = pcall(function()
    print(url)
    ws = assert(http.websocket(url))
  end)

  if err then
    print(err)
    error("Could not connect to server. Is it running?")
  else
    print("Connected to server")

    return ws
  end
end

local function send(message)
  ws.send(message)
end

local function expectResponse(callback)
  while true do
    local data = ws.receive()

    if data then
      callback(data)

      break
    end
  end
end

local function onMessage(callback)
  table.insert(hooks, callback)
end

local function handleData(data, callback)
  local json_data = textutils.unserialiseJSON(data)

  if json_data then
    callback(json_data)
  end
end

local function readMessages()
  local event = ws.receive(0.5)

  if event ~= nil then
    handleData(event, function (data)
      for _, hook in ipairs(hooks) do
        hook(data)
      end
    end)
  end
end

local function listen()
  while true do
    local _status, err = pcall(function()
      readMessages()
    end)

    if err then
      print(err)
      print("Websocket connection appears to have been closed. Retrying in 5 seconds")

      sleep(5)

      local _status, retryErr = pcall(function()
        ws = getConnection(url)

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

return {
  listen = function(callback)
    local args = callback()

    print(args.url)
    url = args.url

    ws = getConnection()

    args.subscribe()

    listen()
  end,
  send = send,
  onMessage = onMessage,
  expectResponse = expectResponse,
}
