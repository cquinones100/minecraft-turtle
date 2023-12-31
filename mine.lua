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

    if coordinatedTurtle.getNumColumns() % 4 == 0 then
      placeTorch()
    end

    if not coordinatedTurtle.moveToNextColumn(miningTurtle) then
      print("Move to next column failed!")

      return false
    end
  end

  coordinatedTurtle.moveForward()
  miningTurtle.work(coordinatedTurtle.getScale())

  return true
end

coordinatedTurtle.recordSpace()

function hasEnoughFuelToDoWork()
  local targetFuel = coordinatedTurtle.getScale() * coordinatedTurtle.getScale() + coordinatedTurtle.getScale() * 3

  print("target fuel: " .. targetFuel)
  print("current fuel: " .. fuel.getLevel())

  return fuel.fueled(targetFuel)
end

function checkTorchAvailability()
  local itemDetail = inventory.itemDetail("minecraft:torch")
  local target = coordinatedTurtle.getScale() / 4

  if itemDetail.count < target then
    print("Please add some torches! " .. target - itemDetail.count .. " more needed")

    os.sleep(1)

    return checkTorchAvailability()
  end
end

function mine()
  if not inventory.checkInventory() then
    print("Inventory full!")

    return false
  else
    if not act() then
      return false
    end
  end

  return true
end

function run()
  if hasEnoughFuelToDoWork() then
    checkTorchAvailability()

    print("Enough fuel to do work!")

    while true do
      if not mine() then
        print("aborting")
      end
    end
  else
    print("Not enough fuel to do work!")
  end
end

return { run = run, mine = mine }
