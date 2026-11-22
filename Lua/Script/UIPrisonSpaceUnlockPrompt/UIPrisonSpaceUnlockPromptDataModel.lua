local DataModel = {RoomIndex = 1}

function DataModel.AddUnit(num)
  local numText = ""
  if 1000 <= num and num < 1000000 then
    numText = tostring(math.floor(num / 1000)) .. "K"
  elseif 1000000 <= num and num < 1000000000 then
    numText = tostring(math.floor(num / 1000000)) .. "M"
  elseif 1000000000 <= num then
    numText = tostring(math.floor(num / 1000000000)) .. "G"
  end
  return numText
end

return DataModel
