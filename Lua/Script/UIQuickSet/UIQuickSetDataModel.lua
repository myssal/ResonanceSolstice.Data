local DataModel = {
  defaultColorList = {
    12601417,
    12601418,
    12601421,
    12601420,
    12601419,
    12601460
  },
  tagColorMap = {
    [12601417] = "Blue",
    [12601418] = "Red",
    [12601421] = "Green",
    [12601420] = "Yellow",
    [12601419] = "Purple",
    [12601460] = "Orange"
  },
  curColorList = {}
}

function DataModel:GetColorWeight()
  local weightMap = {}
  for i = 1, #DataModel.curColorList do
    local colorId = DataModel.curColorList[i]
    local colorKey = DataModel.tagColorMap[colorId]
    weightMap[colorKey] = i
  end
  return weightMap
end

return DataModel
