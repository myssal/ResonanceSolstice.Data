local DataModel = {
  GoldMaxSpace = 0,
  DiamondMaxSpace = 0,
  BuySpaceNum = 1,
  BuyType = 1,
  CurCapacityBuyMode = 1
}

function DataModel.NumFloorPrecision(num)
  local a, b = math.modf(num)
  if 0 <= num then
    if b + 1.0E-4 > 1 then
      a = a + 1
    else
      return a
    end
  elseif b - 1.0E-4 < -1 then
    a = a - 1
  else
    return a
  end
  return a
end

function DataModel.NumRound(num)
  if 0 < num then
    return DataModel.NumFloorPrecision(num + 0.5)
  elseif num < 0 then
    return DataModel.NumFloorPrecision(num - 0.5)
  end
  return 0
end

return DataModel
