local View = require("UIGuKa/UIGuKaView")
local DataModel = {
  BoardWidth = 12,
  BoardHeight = 5,
  BoardData = {},
  GuKaPlaceData = {},
  CurBlockData = {
    id = 0,
    x = -1,
    y = -1,
    width = 0,
    height = 0,
    shape = {},
    rotateIndex = 0
  },
  BagData = {},
  BoardGridSize = 0,
  GuKaImgItems = {},
  GuKaInfoList = {},
  CurBlockPlaceConflict = false
}

function DataModel.Init()
  DataModel.InitBoard()
  DataModel.InitBag()
  if table.count(DataModel.GuKaImgItems) > 0 then
    for i, v in pairs(DataModel.GuKaImgItems) do
      Object.Destroy(v)
    end
  end
  DataModel.GuKaImgItems = {}
  DataModel.BoardGridSize = View.Group_Panel.ScrollGrid_.grid.self:GetChildByIndex(1).rect.size.x
  View.Group_GukaImg:SetActive(false)
end

function DataModel.InitBoard()
  DataModel.BoardData = {}
  DataModel.GuKaPlaceData = {}
  for i = 1, DataModel.BoardWidth do
    for j = 1, DataModel.BoardHeight do
      if not DataModel.BoardData[i] then
        DataModel.BoardData[i] = {}
      end
      DataModel.BoardData[i][j] = {
        gridValue = 0,
        rotateIndex = 0,
        blockId = 0,
        startIndex = -1
      }
    end
  end
  local witchData = WitchData.GetWitchesData()
  for id, v in pairs(witchData.wearing) do
    DataModel.GuKaPlaceData[id] = v
    local data = DataModel.GetBlockData(id, v.rotateIndex)
    local x, y = DataModel.ConvertIndex2Pos(v.index)
    for i = 1, data.width do
      for j = 1, data.height do
        if data.shape[i][j] == 1 then
          DataModel.BoardData[x + i - 1][y + j - 1] = {
            gridValue = data.shape[i][j] + DataModel.BoardData[x + i - 1][y + j - 1].gridValue,
            rotateIndex = v.rotateIndex,
            blockId = id,
            startIndex = v.index
          }
        end
      end
    end
  end
end

function DataModel.InitBag()
  DataModel.BagData = {}
  local witchData = WitchData.GetWitchesData()
  local listCfg = witchData.guka
  for i, v in pairs(listCfg) do
    if v.had == 1 then
      table.insert(DataModel.BagData, {
        id = i,
        lv = v.lv,
        isUse = DataModel.GuKaPlaceData[i] and 1 or 0
      })
    end
  end
end

function DataModel.CollectGuKaEffects(isInGuKaView)
  local effectList = {}
  if isInGuKaView then
    local witchData = WitchData.GetWitchesData()
    for id, v in pairs(DataModel.GuKaPlaceData) do
      local gukaData = witchData.guka[tostring(id)]
      local cfg = PlayerData:GetFactoryData(id)
      if cfg and cfg.skillList and table.count(cfg.skillList) > 0 then
        table.insert(effectList, {
          skillId = cfg.skillList[1].skillId,
          gukaId = id,
          gukaLv = gukaData.lv
        })
      end
    end
  else
    local witchData = WitchData.GetWitchesData()
    for id, v in pairs(witchData.wearing) do
      local gukaData = witchData.guka[tostring(id)]
      local cfg = PlayerData:GetFactoryData(id)
      if cfg and cfg.skillList and table.count(cfg.skillList) > 0 then
        table.insert(effectList, {
          skillId = cfg.skillList[1].skillId,
          gukaId = id,
          gukaLv = gukaData.lv
        })
      end
    end
  end
  return effectList
end

function DataModel.GetGuKaBuffList()
  local buffList = {}
  local witchData = WitchData.GetWitchesData()
  local wearing = witchData.wearing
  local gukaAll = witchData.guka
  if not wearing or not gukaAll then
    return buffList
  end
  for id, v in pairs(witchData.wearing) do
    local data = gukaAll[tostring(id)]
    if data and data.had then
      local cfg = PlayerData:GetFactoryData(id)
      if cfg and cfg.skillList and table.count(cfg.skillList) > 0 then
        buffList[tostring(cfg.skillList[1].skillId)] = data.lv
      end
    end
  end
  return buffList
end

function DataModel.GetBlockData(id, rotateIndex)
  local data = {
    id = id,
    width = 0,
    height = 0,
    shape = {},
    rotateIndex = 0
  }
  local cfg = PlayerData:GetFactoryData(id, "GuKaFactory")
  if not cfg then
    return {}
  end
  for i = 1, cfg.x do
    for j = 1, cfg.y do
      if not data.shape[i] then
        data.shape[i] = {}
      end
      data.shape[i][j] = 1
    end
  end
  for index, v in ipairs(cfg.HoleList) do
    local startX, startY = v.startX, v.startY
    local xLength, yLength = v.xLength, v.yLength
    for i = startX, startX + xLength - 1 do
      for j = startY, startY + yLength - 1 do
        data.shape[i][j] = 0
      end
    end
  end
  data.shape = DataModel.CalculateRotateShape(data.shape, rotateIndex)
  data.width = rotateIndex % 2 == 0 and cfg.x or cfg.y
  data.height = rotateIndex % 2 == 0 and cfg.y or cfg.x
  return data
end

function DataModel.GetBoardBlockId(idx)
  local x, y = DataModel.ConvertIndex2Pos(idx)
  return DataModel.BoardData[x][y].blockId or 0
end

function DataModel.GetBoardGridValue(x, y)
  if not DataModel.IsPlacingBlock() then
    return DataModel.BoardData[x][y].gridValue
  end
  local blockX = DataModel.CurBlockData.x
  local blockY = DataModel.CurBlockData.y
  local relativeX = x - blockX + 1
  local relativeY = y - blockY + 1
  if not (DataModel.CurBlockData.shape[relativeX] and DataModel.CurBlockData.shape[relativeX][relativeY]) or DataModel.CurBlockData.shape[relativeX][relativeY] == 0 then
    return DataModel.BoardData[x][y].gridValue, false
  else
    if DataModel.CurBlockPlaceConflict then
      return 2, true
    end
    return DataModel.BoardData[x][y].gridValue + DataModel.CurBlockData.shape[relativeX][relativeY], true
  end
end

function DataModel.IsPlacingBlock()
  return DataModel.CurBlockData.id ~= 0 and DataModel.CurBlockData.x ~= -1 and DataModel.CurBlockData.y ~= -1
end

function DataModel.ConvertIndex2Pos(index)
  local x = (index - 1) % DataModel.BoardWidth + 1
  local y = math.floor((index - 1) / DataModel.BoardWidth) + 1
  return x, y
end

function DataModel.ConvertPos2Index(x, y)
  return (y - 1) * DataModel.BoardWidth + x
end

function DataModel.CheckBlockPlace(x, y)
  if x < 1 or x > DataModel.BoardWidth or y < 1 or y > DataModel.BoardHeight then
    return false
  end
  for i = 1, #DataModel.CurBlockData.shape do
    for j = 1, #DataModel.CurBlockData.shape[i] do
      if not DataModel.CheckPosInArea(x + i - 1, y + j - 1) or not DataModel.CheckPosCanPlace(x + i - 1, y + j - 1, DataModel.CurBlockData.shape[i][j]) then
        return false
      end
    end
  end
  return true
end

function DataModel.CheckPosInArea(x, y)
  return 1 <= x and x <= DataModel.BoardWidth and 1 <= y and y <= DataModel.BoardHeight
end

function DataModel.CheckPosCanPlace(x, y, shapeValue)
  return DataModel.BoardData[x][y].gridValue + shapeValue < 2
end

function DataModel.CheckBoardNoConflict()
  for i = 1, DataModel.BoardWidth do
    for j = 1, DataModel.BoardHeight do
      if DataModel.GetBoardGridValue(i, j) >= 2 then
        return false
      end
    end
  end
  return true
end

function DataModel.RotateBlock()
  if DataModel.CurBlockData.id == 0 then
    return
  end
  local rotateIndex = DataModel.CurBlockData.rotateIndex + 1
  if 3 < rotateIndex then
    rotateIndex = 0
  end
  DataModel.CurBlockData.rotateIndex = rotateIndex
  local shape = DataModel.CurBlockData.shape
  local newShape = DataModel.CalculateRotateShape(shape, 1)
  DataModel.CurBlockData.shape = newShape
  DataModel.CurBlockData.width, DataModel.CurBlockData.height = DataModel.CurBlockData.height, DataModel.CurBlockData.width
  if DataModel.IsPlacingBlock() then
    local maxX = DataModel.BoardWidth - DataModel.CurBlockData.width + 1
    DataModel.CurBlockData.x = math.min(maxX, DataModel.CurBlockData.x)
    DataModel.CurBlockData.x = math.max(1, DataModel.CurBlockData.x)
    local maxY = DataModel.BoardHeight - DataModel.CurBlockData.height + 1
    DataModel.CurBlockData.y = math.min(maxY, DataModel.CurBlockData.y)
    DataModel.CurBlockData.y = math.max(1, DataModel.CurBlockData.y)
  end
end

function DataModel.CalculateRotateShape(shape, times)
  if not times or times == 0 then
    return shape
  end
  local rltShape = shape
  for count = 1, times do
    local newShape = {}
    local rows = #rltShape
    local cols = #rltShape[1]
    for i = 1, cols do
      newShape[i] = {}
      for j = 1, rows do
        newShape[i][j] = rltShape[j][cols - i + 1]
      end
    end
    rltShape = newShape
  end
  return rltShape
end

function DataModel.ResetBlock()
  DataModel.CurBlockData.id = 0
  DataModel.CurBlockData.x = -1
  DataModel.CurBlockData.y = -1
  DataModel.CurBlockData.width = 0
  DataModel.CurBlockData.height = 0
  DataModel.CurBlockData.shape = {}
end

function DataModel.GetBlockCenterPos(id, startX, startY, rotateIndex)
  if not DataModel.IsPlacingBlock() and not id then
    return 0, 0
  end
  local data
  if id then
    data = DataModel.GetBlockData(id, rotateIndex)
    data.x = startX
    data.y = startY
  else
    data = DataModel.CurBlockData
  end
  local x, y = data.x, data.y
  local width = data.width
  local height = data.height
  local leftUpIndex = (y - 1) * DataModel.BoardWidth + x
  local rightDownIndex = (y + height - 1 - 1) * DataModel.BoardWidth + (x + width - 1)
  local leftUp = View.Group_Panel.ScrollGrid_.grid.self:GetChildByIndex(leftUpIndex - 1).transform.position
  local rightDown = View.Group_Panel.ScrollGrid_.grid.self:GetChildByIndex(rightDownIndex - 1).transform.position
  local centerX = (leftUp.x + rightDown.x) / 2 + 2.5
  local centerY = (leftUp.y + rightDown.y) / 2 - 2.5
  return centerX, centerY
end

function DataModel.CheckGuKaRedPoint()
  local witchData = WitchData.GetWitchesData()
  local wearing = witchData.wearing
  local list = witchData.guka
  for i, v in pairs(list) do
    if v.had == 1 and not wearing[tostring(i)] then
      return true
    end
  end
  return false
end

return DataModel
