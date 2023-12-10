local inventory = require("inventoried_turtle")
local coordinatedTurtle = require("coordinated_turtle")
local miningTurtle = require("mining_turtle")
local fuel = require("fueled_turtle")

function placeTorch()
  local torchSlot = inventory.findInInventory("minecraft:torch")

  if torchSlot then
    turtle.select(torchSlot)
    turtle.place()
  else
    print("Out of torches!")
  end
end


function act()
  if not coordinatedTurtle.willBeInBounds() then
    print("Out of bounds!")
    placeTorch()

    if not coordinatedTurtle.moveToNextColumn(miningTurtle) then
      print("Move to next column failed!")

      return false
    end
  end

  coordinatedTurtle.moveForward()
  miningTurtle.work()

  return true
end

coordinatedTurtle.recordSpace()

function hasEnoughFuelToDoWork()
  local targetFuel = coordinatedTurtle.getScale() * coordinatedTurtle.getScale() + coordinatedTurtle.getScale() * 3

  print("target fuel: " .. targetFuel)
  print("current fuel: " .. fuel.getLevel())

  return fuel.fueled(targetFuel)
end

function run()
  if hasEnoughFuelToDoWork() then
    print("Enough fuel to do work!")
    placeTorch()

    while true do
      if not inventory.checkInventory() then
        print("Inventory full!")

        os.sleep(1000)
      else
        if not act() then
          print("aborting")

          break
        end
      end
    end
  else
    print("Not enough fuel to do work!")
  end
end

return { run = run }
