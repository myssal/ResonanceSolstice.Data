local View = require("UIGuKa/UIGuKaView")
local DataModel = require("UIGuKa/UIGuKaDataModel")
local Controller = {}

function Controller:Init()
  DataModel.Init()
  DataModel.ResetBlock()
  View.Group_ControlPanel:SetActive(false)
  View.Group_CantControlPanel:SetActive(true)
  View.Img_Guka:SetActive(false)
  Controller:RefreshBag()
  Controller:RefreshBoard()
  Controller:RefreshGukKaInfo()
  Controller:PlayGuKaAnim()
end

function Controller:RefreshGukKaInfo()
  if table.count(DataModel.BagData) == 0 then
    View.Group_NoGuKa:SetActive(true)
    View.Group_NoSelectGuKa:SetActive(false)
    View.Group_GukaInfo:SetActive(false)
    return
  end
  View.Group_NoGuKa:SetActive(false)
  if DataModel.CurBlockData.id == 0 then
    View.Group_NoSelectGuKa:SetActive(true)
    View.Group_GukaInfo:SetActive(false)
    View.Group_GukaInfo.Txt_Name:SetText("")
    View.Group_GukaInfo.Txt_Desc:SetText("")
    View.Group_GukaInfo.Group_Entry.Txt_Entry_1:SetText("")
  else
    View.Group_NoSelectGuKa:SetActive(false)
    View.Group_GukaInfo:SetActive(true)
    local cfg = PlayerData:GetFactoryData(DataModel.CurBlockData.id)
    View.Group_GukaInfo.Txt_Name:SetText(cfg.name)
    View.Group_GukaInfo.Txt_Desc:SetText(cfg.des)
    if 0 < table.count(cfg.skillList) then
      local skillCfg = PlayerData:GetFactoryData(cfg.skillList[1].skillId)
      local lv = WitchData.GetWitchesData().guka[tostring(DataModel.CurBlockData.id)].lv
      if skillCfg.isPercent then
        local value = skillCfg.minAttrSN + skillCfg.digitSN * (lv - 1)
        value = value * 100
        View.Group_GukaInfo.Group_Entry.Txt_Entry_1:SetText(string.format(skillCfg.description, value .. "%"))
      else
        View.Group_GukaInfo.Group_Entry.Txt_Entry_1:SetText(string.format(skillCfg.description, skillCfg.minAttrSN + skillCfg.digitSN * (lv - 1)))
      end
    else
      View.Group_Attr.Group_Entry.Txt_Entry_1:SetText("")
      View.Group_Attr2.Group_Entry.Txt_Entry_1:SetText("")
    end
  end
end

function Controller:ClickGuKaInBag(elementIndex)
  local function cb(selectBlockId)
    if not selectBlockId then
      local blockData = DataModel.BagData[elementIndex]
      
      if blockData.isUse == 1 then
        return
      end
      DataModel.CurBlockData = DataModel.GetBlockData(blockData.id, 0)
      local x, y = Controller:TryAutoPlace()
      if x == -1 and y == -1 then
        x, y = Controller:GetEmptyGrid()
        if x == -1 and y == -1 then
          DataModel.ResetBlock()
          return
        end
      end
      DataModel.CurBlockData.rotateIndex = 0
      Controller:PlaceBlock(x, y)
      Controller:RefreshGukKaInfo()
      Controller:RefreshBag()
    else
      for i, v in ipairs(DataModel.BagData) do
        if v.id == selectBlockId then
          local blockData = DataModel.BagData[i]
          if blockData.isUse == 1 then
            return
          end
          DataModel.CurBlockData = DataModel.GetBlockData(blockData.id, 0)
          local x, y = Controller:TryAutoPlace()
          if x == -1 and y == -1 then
            x, y = Controller:GetEmptyGrid()
            if x == -1 and y == -1 then
              DataModel.ResetBlock()
              return
            end
          end
          DataModel.CurBlockData.rotateIndex = 0
          Controller:PlaceBlock(x, y)
          Controller:RefreshGukKaInfo()
          Controller:RefreshBag()
        end
      end
    end
  end
  
  if DataModel.CurBlockData.id == 0 then
    cb()
  elseif DataModel.CurBlockData.id ~= DataModel.BagData[elementIndex].id then
    local selectBlockId = DataModel.BagData[elementIndex].id
    if Controller:ConfirmPlaceBlock() then
      cb(selectBlockId)
    end
  end
end

function Controller:GetEmptyGrid()
  for i = 1, DataModel.BoardWidth do
    for j = 1, DataModel.BoardHeight do
      if DataModel.BoardData[i][j].gridValue == 0 and i + DataModel.CurBlockData.width - 1 <= DataModel.BoardWidth and j + DataModel.CurBlockData.height - 1 <= DataModel.BoardHeight then
        return i, j
      end
    end
  end
  return -1, -1
end

function Controller:ClickGuKaInBoard(idx)
  local blockId = DataModel.GetBoardBlockId(idx)
  if blockId == 0 then
    return
  end
  if DataModel.CurBlockData.id ~= 0 and DataModel.CurBlockData.id ~= blockId and not DataModel.CheckBoardNoConflict() then
    return
  end
  if DataModel.CurBlockData.id == 0 then
    Controller:ChooseBlockInBoard(idx)
  elseif Controller:ConfirmPlaceBlock() then
    Controller:ChooseBlockInBoard(idx)
  end
end

function Controller:ChooseBlockInBoard(idx)
  local blockId = DataModel.GetBoardBlockId(idx)
  local x, y = DataModel.ConvertIndex2Pos(idx)
  local blockStartIndex = DataModel.BoardData[x][y].startIndex
  local startX, startY = DataModel.ConvertIndex2Pos(blockStartIndex)
  DataModel.ResetBlock()
  DataModel.CurBlockData = DataModel.GetBlockData(blockId, DataModel.BoardData[x][y].rotateIndex)
  DataModel.CurBlockData.x = startX
  DataModel.CurBlockData.y = startY
  DataModel.CurBlockData.rotateIndex = DataModel.BoardData[x][y].rotateIndex
  Controller:ClearBlockShapeInBoard()
  Controller:ShowControlPanel()
  Controller:RefreshGukKaInfo()
end

function Controller:ClearBlockShapeInBoard()
  local blockX = DataModel.CurBlockData.x
  local blockY = DataModel.CurBlockData.y
  local blockWidth = DataModel.CurBlockData.width
  local blockHeight = DataModel.CurBlockData.height
  for i = 1, blockWidth do
    for j = 1, blockHeight do
      if DataModel.CurBlockData.shape[i][j] == 1 then
        local x, y = blockX + i - 1, blockY + j - 1
        DataModel.BoardData[x][y] = {
          gridValue = 0,
          blockId = 0,
          rotateIndex = 0,
          startIndex = -1
        }
      end
    end
  end
  DataModel.GuKaPlaceData[DataModel.CurBlockData.id] = nil
  Controller:RefreshBoard()
end

function Controller:SetBagBlockElement(element, elementIndex)
  local blockData = DataModel.BagData[elementIndex]
  if not blockData then
    return
  end
  local cfg = PlayerData:GetFactoryData(blockData.id)
  if not cfg then
    return
  end
  local x = element.Group_GuKa.transform.anchoredPosition.x
  if elementIndex % 2 == 0 then
    element.Group_GuKa.transform.anchoredPosition = Vector2(x, -10)
  else
    element.Group_GuKa.transform.anchoredPosition = Vector2(x, 40)
  end
  element.Group_GuKa.Group_InUse.Img_:SetSprite(WitchData.GetUIPath(GetResPath(88300232)))
  element.Group_GuKa.Img_:SetSprite(cfg.iconPath)
  element.Group_GuKa.Img_Symbol:SetSprite(cfg.symbol)
  element.Group_GuKa.Img_NameBg.Txt_Name:SetText(cfg.name)
  element.Group_GuKa.Img_Select.Txt_Name:SetText(cfg.name)
  element.Group_GuKa.Group_Effect:SetActive(tostring(cfg.id) == DataModel.CurBlockData.id)
  element.Group_GuKa.Img_Select:SetActive(tostring(cfg.id) == DataModel.CurBlockData.id)
  element.Group_GuKa.Group_InUse:SetActive(blockData.isUse == 1)
  element.Group_GuKa.Btn_:SetClickParam(elementIndex)
end

function Controller:RefreshBag()
  table.sort(DataModel.BagData, function(a, b)
    if a.isUse == b.isUse then
      return a.id < b.id
    end
    return a.isUse < b.isUse
  end)
  View.Group_Pack.ScrollGrid_.grid.self:SetDataCount(#DataModel.BagData)
  View.Group_Pack.ScrollGrid_.grid.self:RefreshAllElement()
end

function Controller:TryAutoPlace()
  if DataModel.CurBlockData.id == 0 then
    return -1, -1
  end
  for i = 1, DataModel.BoardWidth do
    for j = 1, DataModel.BoardHeight do
      if DataModel.CheckBlockPlace(i, j) then
        return i, j
      end
    end
  end
  return -1, -1
end

function Controller:OnDragBlock(pos)
  local deltaX = pos.x - DataModel.DragStartPos.x
  local deltaY = pos.y - DataModel.DragStartPos.y
  local gridSize = DataModel.BoardGridSize
  local targetX = DataModel.CurBlockData.x
  local targetY = DataModel.CurBlockData.y
  if gridSize <= math.abs(deltaX) then
    local moveStep = math.floor(deltaX / gridSize + 0.5)
    targetX = DataModel.CurBlockData.x + moveStep
    if 1 <= targetX and targetX + DataModel.CurBlockData.width - 1 <= DataModel.BoardWidth then
      DataModel.DragStartPos.x = DataModel.DragStartPos.x + moveStep * gridSize
    else
      targetX = DataModel.CurBlockData.x
    end
  end
  if gridSize <= math.abs(deltaY) then
    local moveStep = math.floor(-deltaY / gridSize + 0.5)
    targetY = DataModel.CurBlockData.y + moveStep
    if 1 <= targetY and targetY + DataModel.CurBlockData.height - 1 <= DataModel.BoardHeight then
      DataModel.DragStartPos.y = DataModel.DragStartPos.y - moveStep * gridSize
    else
      targetY = DataModel.CurBlockData.y
    end
  end
  if targetX == DataModel.CurBlockData.x and targetY == DataModel.CurBlockData.y then
    return
  end
  Controller:PlaceBlock(targetX, targetY)
end

function Controller:RotateBlock()
  DataModel.RotateBlock()
  Controller:RefreshBoard()
  Controller:ShowControlPanel()
end

function Controller:RestoreBlock()
  DataModel.ResetBlock()
  Controller:RefreshBoard()
  DataModel.InitBag()
  Controller:RefreshBag()
  Controller:RefreshGukKaInfo()
  View.Group_ControlPanel:SetActive(false)
  View.Group_CantControlPanel:SetActive(true)
  View.Img_Guka:SetActive(false)
end

function Controller:PlaceBlock(x, y)
  DataModel.CurBlockData.x = x
  DataModel.CurBlockData.y = y
  Controller:RefreshBoard()
  Controller:ShowControlPanel()
end

function Controller:ShowControlPanel()
  View.Group_ControlPanel:SetActive(true)
  View.Group_CantControlPanel:SetActive(false)
  local cfg = PlayerData:GetFactoryData(DataModel.CurBlockData.id)
  View.Img_Guka:SetSprite(cfg.gukaImg)
  View.Img_Guka:SetNativeSize()
  View.Img_Guka:SetRotate(-90 * DataModel.CurBlockData.rotateIndex)
  local targetX, targetY = DataModel.GetBlockCenterPos()
  local z = View.Group_ControlPanel.self.transform.position.z
  View.Img_Guka.self.transform.position = Vector3(targetX, targetY, z)
  View.Img_Guka:SetActive(true)
end

function Controller:ConfirmPlaceBlock()
  if DataModel.CurBlockData.id == 0 or 0 >= DataModel.CurBlockData.x or 0 >= DataModel.CurBlockData.y then
    return false
  end
  if not DataModel.CheckBoardNoConflict() then
    return false
  end
  local startIndex = DataModel.ConvertPos2Index(DataModel.CurBlockData.x, DataModel.CurBlockData.y)
  for i = 1, DataModel.CurBlockData.width do
    for j = 1, DataModel.CurBlockData.height do
      if DataModel.CurBlockData.shape[i][j] == 1 then
        local x, y = DataModel.CurBlockData.x + i - 1, DataModel.CurBlockData.y + j - 1
        DataModel.BoardData[x][y] = {
          gridValue = DataModel.BoardData[x][y].gridValue + DataModel.CurBlockData.shape[i][j],
          blockId = DataModel.CurBlockData.id,
          rotateIndex = DataModel.CurBlockData.rotateIndex,
          startIndex = startIndex
        }
        DataModel.GuKaPlaceData[DataModel.CurBlockData.id] = {
          index = startIndex,
          rotateIndex = DataModel.CurBlockData.rotateIndex
        }
      end
    end
  end
  View.Img_Guka:SetActive(false)
  View.Group_ControlPanel:SetActive(false)
  View.Group_CantControlPanel:SetActive(true)
  DataModel.ResetBlock()
  Controller:RefreshBoard()
  DataModel.InitBag()
  Controller:RefreshBag()
  Controller:RefreshGukKaInfo()
  return true
end

function Controller:ReqDecorate(cb)
  local gukaLoc
  if table.count(DataModel.GuKaPlaceData) == 0 then
    gukaLoc = "{}"
  else
    gukaLoc = Json.encode(DataModel.GuKaPlaceData)
  end
  Net:SendProto("activity.decorate", function(json)
    WitchData.GetWitchesData().wearing = {}
    for i, v in pairs(DataModel.GuKaPlaceData) do
      WitchData.GetWitchesData().wearing[i] = v
    end
    if cb then
      cb()
    end
  end, gukaLoc, WitchData.GetActivityId())
end

function Controller:RefreshBoard()
  local noConflict = DataModel.CheckBoardNoConflict()
  DataModel.CurBlockPlaceConflict = not noConflict
  View.Group_Panel.ScrollGrid_.grid.self:SetDataCount(DataModel.BoardHeight * DataModel.BoardWidth)
  View.Group_Panel.ScrollGrid_.grid.self:RefreshAllElement()
  Controller:SetGuKaImgs()
  DataModel.CurBlockPlaceConflict = false
end

function Controller:SetGuKaImgs()
  for i, v in pairs(DataModel.GuKaImgItems) do
    DataModel.GuKaImgItems[i]:SetActive(false)
  end
  for i, v in pairs(DataModel.GuKaPlaceData) do
    local obj = DataModel.GuKaImgItems[tostring(i)]
    if not obj then
      local Parent = View.Group_GuKaImgRoot.transform
      obj = View.self:GetRes(WitchData.GetUIPath("UI/Witches/Guka/Group_GukaImg"), Parent)
      DataModel.GuKaImgItems[tostring(i)] = obj
    end
    local cfg = PlayerData:GetFactoryData(i)
    local imgComp = obj.transform:Find("Img_").transform:GetComponent(typeof(CS.Seven.UIImg))
    imgComp:SetSprite(cfg.gukaImg)
    imgComp:SetNativeSize()
    imgComp:SetRotate(-90 * v.rotateIndex)
    local posX, posY = DataModel.ConvertIndex2Pos(v.index)
    local targetX, targetY = DataModel.GetBlockCenterPos(i, posX, posY, v.rotateIndex)
    local z = View.self.transform.position.z
    imgComp.transform.position = Vector3(targetX, targetY, z)
    obj:SetActive(true)
  end
end

function Controller:PlayGuKaAnim()
  View.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
    for i, v in pairs(DataModel.GuKaImgItems) do
      v.transform:GetComponent(typeof(CS.UnityEngine.Animator)):Play("Show", 0, 0)
    end
  end))
end

function Controller:SetBoardElement(element, elementIndex)
  local x, y = DataModel.ConvertIndex2Pos(elementIndex)
  local value, isSelect = DataModel.GetBoardGridValue(x, y)
  if value == 1 then
    if isSelect then
      element.Img_:SetSprite(WitchData.GetUIPath("UI/Witches/Guka/GuKaUI/Grid_Can"))
    else
      element.Img_:SetSprite(WitchData.GetUIPath("UI/Witches/Guka/GuKaUI/Grid_Select"))
    end
  elseif value == 2 then
    element.Img_:SetSprite(WitchData.GetUIPath("UI/Witches/Guka/GuKaUI/Grid_Cant"))
  else
    element.Img_:SetSprite(WitchData.GetUIPath("UI/Witches/Guka/GuKaUI/Grid"))
  end
  element.Btn_:SetClickParam(elementIndex)
end

function Controller:ShowAttrValue()
  if DataModel.CurBlockData.id == 0 then
    UIManager:Open(WitchData.GetUIPath("UI/Witches/Guka/Group_GukaAllAttr"), Json.encode({IsInGuKaView = true}))
  elseif DataModel.CheckBoardNoConflict() then
    Controller:ConfirmPlaceBlock()
    UIManager:Open(WitchData.GetUIPath("UI/Witches/Guka/Group_GukaAllAttr"), Json.encode({IsInGuKaView = true}))
  else
    UIManager:Open(WitchData.GetUIPath("UI/Witches/Guka/Group_GukaAllAttr"), Json.encode({IsInGuKaView = true}))
  end
end

return Controller
