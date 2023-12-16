-- local direction = 1
-- local coordinates = {x = 1, y = 1}
-- local cache = {}
-- local scale = 10
-- local numColumns = 1

-- function getDirection()
--   return direction
-- end

-- function getCoordinates()
--   return coordinates
-- end

-- function getCache()
--   return cache
-- end

-- function getScale()
--   return scale
-- end

-- function getNumColumns()
--   return numColumns
-- end

-- function facingUp()
--   return direction == 1
-- end

-- function facingDown()
--   return direction == 3
-- end

-- function facingLeft()
--   return direction == 4
-- end

-- function facingRight()
--   return direction == 2
-- end

-- function faceUp()
--   if facingLeft() then
--     turtle.turnRight()
--   end

--   if facingRight() then
--     turtle.turnLeft()
--   end

--   if facingDown() then
--     turtle.turnRight()
--     turtle.turnRight()
--   end

--   direction = 1
-- end

-- function faceDown()
--   if facingLeft() then
--     turtle.turnLeft()
--   end

--   if facingRight() then
--     turtle.turnRight()
--   end

--   if facingUp() then
--     turtle.turnRight()
--     turtle.turnRight()
--   end

--   direction = 3
-- end

-- function faceLeft()
--   if facingUp() then
--     turtle.turnLeft()
--   end

--   if facingDown() then
--     turtle.turnRight()
--   end

--   if facingRight() then
--     turtle.turnRight()
--     turtle.turnRight()
--   end

--   direction = 4
-- end

-- function faceRight()
--   if facingUp() then
--     turtle.turnRight()
--   end

--   if facingDown() then
--     turtle.turnLeft()
--   end

--   if facingLeft() then
--     turtle.turnRight()
--     turtle.turnRight()
--   end

--   direction = 2
-- end

-- function turnForward()
--   if facingUp() then
--     faceLeft()
--   elseif facingLeft() then
--     faceDown()
--   elseif facingRight() then
--     faceUp()
--   elseif facingDown() then
--     faceRight()
--   end
-- end

-- function turnBackward()
--   if facingUp() then
--     faceRight()
--   elseif facingLeft() then
--     faceUp()
--   elseif facingRight() then
--     faceDown()
--   elseif facingDown() then
--     faceLeft()
--   end
-- end

-- function recordSpace()
--   if not cache[coordinates.x] then
--     cache[coordinates.x] = {}
--   end
--   cache[coordinates.x][coordinates.y] = 1
-- end

-- function moveForward(move)
--   if move == nil then
--     move = true
--   end

--   if facingUp() then
--     coordinates.y = coordinates.y + 1
--   elseif facingLeft() then
--     coordinates.x = coordinates.x + 1
--   elseif facingDown() then
--     coordinates.y = coordinates.y - 1
--   elseif facingRight() then
--     coordinates.x = coordinates.x - 1
--   end

--   if move then
--     turtle.forward()

--     recordSpace()
--   end
-- end

-- function hasAvailableSpace()
--   if turtle.down() then
--     turtle.up()
--     turtle.back()

--     return false
--   else
--     moveForward()
--   end

--   return true
-- end

-- function willBeInBounds()
--   if facingUp() then
--     if coordinates.y + 1 > scale then
--       return false
--     end
--   elseif facingLeft() then
--     if coordinates.x + 1 > scale then
--       return false
--     end
--   elseif facingDown() then
--     if coordinates.y - 1 < 1 then
--       return false
--     end
--   elseif facingRight() then
--     if coordinates.x - 1 < 1 then
--       return false
--     end
--   end

--   return true
-- end

-- function hasLeftOverWork()
--   if coordinates.x == 1 then
--     return false
--   end

--   local workToDo = false

--   for y = 1, scale do
--     if not cache[coordinates.x - 1][y] then
--       workToDo = true
--     end
--   end

--   return workToDo
-- end

-- function moveToNextColumn(miningTurtle)
--   print("Moving from column " .. numColumns .. " to " .. (numColumns + 1))

--   if numColumns == scale then
--     if scale % 2 == 1 then
--       faceDown()
--       for i = 1, scale - 1 do
--         moveForward()
--       end
--     else
--       faceUp()
--     end

--     faceRight()

--     for i = 1, scale - 1 do
--       moveForward()
--     end

--     faceUp()

--     return false
--   end

--   if numColumns % 2 == 1 then
--     faceLeft()

--     miningTurtle.work()
--     moveForward()
--     miningTurtle.work()

--     faceDown()
--   else
--     faceLeft()

--     miningTurtle.work()
--     moveForward()
--     miningTurtle.work()

--     faceUp()
--   end

--   numColumns = numColumns + 1

--   return true
-- end

-- return {
--   hasAvailableSpace = hasAvailableSpace,
--   willBeInBounds = willBeInBounds,
--   moveForward = moveForward,
--   direction = direction,
--   turnForward = turnForward,
--   turnBackward = turnBackward,
--   recordSpace = recordSpace,
--   getDirection = getDirection,
--   getCoordinates = getCoordinates,
--   getCache = getCache,jjj
--   moveToNextColumn = moveToNextColumn,
--   getScale = getScale,
--   getNumColumns = getNumColumns,
-- }
--
--

local coordinates = {}

function setupCoordinates()
  print("Enter your coordinates:")
  print("x: ")
  x = read()

  print("y: ")
  y = read()

  print("z: ")
  z = read()

  print("facing: ")
  facing = read()

  coordinates = { x = x, y = y, z = z, direction = facing }

  return coordinates
end

function forward()
  if turtle.forward() then
    if coordinates.direction == "north" then
      coordinates.z = coordinates.z - 1
    elseif coordinates.direction == "south" then
      coordinates.z = coordinates.z + 1
    elseif coordinates.direction == "east" then
      coordinates.x = coordinates.x + 1
    elseif coordinates.direction == "west" then
      coordinates.x = coordinates.x - 1
    end
  end
end

function getCoordinates()
  return coordinates
end

function dig()
  turtle.dig()
end

function digUp()
  turtle.digUp()
end

function suck()
  turtle.suck()
end

function detect()
  return turtle.detect()
end

function detectUp()
  return turtle.detectUp()
end

function detectDown()
  return turtle.detectDown()
end

function back()
  turtle.back()
end

function getFuelLevel()
  return turtle.getFuelLevel()
end

function refuel()
  return turtle.refuel()
end

return {
  setupCoordinates = setupCoordinates,
  forward = forward,
  getCoordinates = getCoordinates,
  dig = dig,
  digUp = digUp,
  suck = suck,
  detect = detect,
  detectUp = detectUp,
  detectDown = detectDown,
  back = back,
  getFuelLevel = getFuelLevel,
  refuel = refuel,
}

