function findInInventory(itemName)
  local itemSlot = nil

  for slot = 1, 16 do
    local item = turtle.getItemDetail(slot)

    if item and item.name == itemName then
      itemSlot = slot
    end
  end

  return itemSlot
end

function itemDetail(itemName)
  local slot = findInInventory(itemName)

  if not slot then
    return { count = 0, name = "No Item" }
  end

  local itemDetails = turtle.getItemDetail(slot)

  return itemDetails
end

function hasAvailableSlot()
  for slot = 1, 16 do

    if turtle.getItemCount(slot) == 0 then
      return true
    end
  end

  return false
end

function checkInventory()
  if hasAvailableSlot() then
    return true
  else
    return false
  end
end

return {
  checkInventory = checkInventory,
  findInInventory = findInInventory,
  itemDetail = itemDetail
}
