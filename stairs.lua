local fuel = require("fueled_turtle")
local target = 20
local inventory = require("inventoried_turtle")
local blockName = "minecraft:cobbled_deepslate"
local stairBlockName = "minecraft:cobbled_deepslate_stairs"

function hasEnoughFuelToDoWork()
  local targetFuel = target

  print("target fuel: " .. targetFuel)
  print("current fuel: " .. fuel.getLevel())

  return fuel.fueled(targetFuel)
end

function placeBlock()
  local blockSlot = inventory.findInInventory(blockName)
  local stairBlockSlot = inventory.findInInventory(stairBlockName)

  if blockSlot and stairBlockSlot then
    turtle.down()
    turtle.turnLeft()
    turtle.turnLeft()

    turtle.select(blockSlot)
    turtle.place()

    turtle.up()
    turtle.forward()
    turtle.forward()
    turtle.forward()
    turtle.down()

    turtle.turnLeft()
    turtle.turnLeft()

    turtle.select(stairBlockSlot)
    turtle.place()

    turtle.up()
    turtle.forward()
    turtle.forward()
    turtle.forward()

    return true
  else
    print("Out of blocks!")

    return false
  end
end

function checkBlockAvailability()
  local itemDetail = inventory.itemDetail(blockName)
  local stairDetail = inventory.itemDetail(stairBlockName)

  if itemDetail.count < target then
    print("Please add some cobblestone! " .. target - itemDetail.count .. " more needed")

    os.sleep(1)

    return checkBlockAvailability()
  end

  print(stairDetail.name)

  if stairDetail.count < target then
    print("Please add some cobblestone stairs! " .. target - stairDetail.count .. " more needed")

    os.sleep(1)

    return checkBlockAvailability()
  end
end

function hitGravel()
  local _success, blockinfo = turtle.inspect()

  if blockinfo and blockinfo.name == "minecraft:gravel" then
    return true
  end

  return false
end

function run()
  checkBlockAvailability()

  if hasEnoughFuelToDoWork() then
    print("Enough fuel to do work!")

    local stairs = 0

    while stairs < target do
      print("Working on stair " .. stairs + 1 .. " of " .. target)

      if hitGravel() then
        print("hit gravel!")
        break
      end

      local height = 6

      for _i = 1, height do
        turtle.dig()
        turtle.digUp()
        turtle.up()
      end

      for i = 1, height - 1 do
        turtle.down()
      end

      turtle.forward()

      if not placeBlock() then
        break
      end

      print("Stair " .. stairs + 1 .. " complete!")

      stairs = stairs + 1
    end

    print("Done!")
  else
    print("Not enough fuel to do work!")
  end
end

return { run = run }
