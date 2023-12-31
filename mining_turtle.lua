function cleanInventory()
  local itemsToFilter = {
    "minecraft:diamond_ore",
    "minecraft:emerald_ore",
    "minecraft:iron_ore",
    "minecraft:diamond",
    "minecraft:emerald",
    "minecraft:iron",
    "minecraft:coal",
    "minecraft:torch",
    "minecraft:redstone",
    "minecraft:raw_gold",
    "minecraft:raw_iron",
    "minecraft:raw_diamond",
    "minecraft:raw_emarald",
    "minecraft:dirt",
    "minecraft:oak_fence",
    "minecraft:oak_planks",
    "minecraft:rail",
    "minecraft:torch",
  }

  for slot = 1, 16 do
   local itemDetails = turtle.getItemDetail(slot)

   if itemDetails then
     local itemName = itemDetails.name

      turtle.select(slot)

      local isFiltered = false

      for _, filterItem in ipairs(itemsToFilter) do
        if itemName == filterItem then
          isFiltered = true
          break
        end
      end

      if not isFiltered then
        turtle.drop()
      end
    end
  end
end

function work(scale)
  turtle.dig()
  turtle.digUp()
  turtle.suck()

  if scale and scale > 10 then
    cleanInventory()
  end
end

return { work = work }
