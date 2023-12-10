function getLevel()
  return turtle.getFuelLevel()
end

function fueled(target)
  if turtle.getFuelLevel() < target then
    print("fuel level" .. turtle.getFuelLevel())

    if turtle.refuel() then
      print("Refueled!")

      return true
    else
      return false
    end
  else
    return true
  end
end

return { fueled = fueled, getLevel = getLevel }
