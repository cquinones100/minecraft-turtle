# Socket

A thin wrapper around CC:Tweaked websocket.

## Usage

Socket it blocks the main thread to continoulsy recieve messages. Pass a callback function to `Socket.listen` to run code on each tick.

```lua
Socket.listen(function()
  -- send a message
  Socket.send({
    -- message properties
  })

  --send a message that expects a response
  Socket.send({
    -- message properties

    Socket.expectResponse(function(response)
      function isExpectedResponse()
        -- inspect the response and return true if is expected
      end

      return isExpectedREsponse()
    end)
  })

  -- handle incoming messages
  Socket.onMessage(function()
    -- ... handle any message
  end)

  return {
    url = --the webocket url,
    subscribe -- a function that is run after the connection is established,
  }
end)
```
