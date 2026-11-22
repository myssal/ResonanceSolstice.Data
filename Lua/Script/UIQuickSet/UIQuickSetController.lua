local View = require("UIQuickSet/UIQuickSetView")
local DataModel = require("UIQuickSet/UIQuickSetDataModel")
local Controller = {}

function Controller:init()
  for i = 1, #DataModel.defaultColorList do
    DataModel.curColorList[i] = DataModel.defaultColorList[i]
  end
  View.Img_Mask.StaticGrid_Set.grid.self:SetDataCount(#DataModel.curColorList)
  View.Img_Mask.StaticGrid_Set.grid.self:RefreshAllElement()
  View.self:PlayAnimOnce("QuickSetShow")
end

function Controller:OnSetTagGird(element, elementIndex)
  local tagId = DataModel.curColorList[elementIndex]
  Controller:SetTagGirdById(element, tagId)
  element.Group_Main.self:SetActive(DataModel.dragIdx ~= elementIndex)
  element.Group_Main.Btn_Click:SetClickParam(elementIndex)
end

function Controller:SetTagGirdById(element, tagId)
  local ca = PlayerData:GetFactoryData(tagId)
  element.Group_Main.Img_Icon:SetSprite(ca.icon)
  element.Group_Main.Txt_Type:SetText(ca.tagName)
  element.Group_Main.Txt_Type.Txt_Explain:SetText(ca.detail)
end

function Controller:GetMousePos()
  local minScale = math.min(GameSetting.scaleWidth, GameSetting.scaleHeight)
  local position = Input.mousePosition
  position = Vector3((position.x - Screen.width * 0.5) / minScale, (position.y - Screen.height * 0.5) / minScale + 20, position.z)
  return position
end

function Controller:BeginDrag(index)
  if DataModel.curFrameMouseUp then
    return
  end
  local tagId = DataModel.curColorList[index]
  if tagId == nil then
    return
  end
  DataModel.isDrag = true
  DataModel.dragIdx = index
  local pos = Controller:GetMousePos()
  View.Group_RowTemp.self:SetLocalPosition(pos)
  Controller:SetTagGirdById(View.Group_RowTemp, tagId)
  View.Group_RowTemp:SetActive(true)
  View.Img_Mask.StaticGrid_Set.grid.self:RefreshAllElement()
end

function Controller:CalcDragingPos()
  local gridTag = View.Img_Mask.StaticGrid_Set
  local cardCount = gridTag.grid.self.DataCount
  local toIndex = -1
  local pos = gridTag.grid.self.transform:InverseTransformPoint(View.Group_RowTemp.self.transform.position)
  for i = 1, cardCount do
    local groupCard = gridTag.grid[i]
    local gridPos = gridTag.grid.self.transform:InverseTransformPoint(groupCard.self.transform.position)
    if math.abs(gridPos.x - pos.x) <= 800 and math.abs(gridPos.y - pos.y) <= 47 then
      toIndex = i
      break
    end
    if toIndex ~= -1 then
      break
    end
  end
  return toIndex
end

function Controller:Draging()
end

function Controller:DragEnd()
  local toIdx = Controller:CalcDragingPos()
  if toIdx ~= -1 and DataModel.dragIdx ~= toIdx then
    local data = DataModel.curColorList[DataModel.dragIdx]
    table.remove(DataModel.curColorList, DataModel.dragIdx)
    table.insert(DataModel.curColorList, toIdx, data)
    DataModel.IsChanged = true
  end
  DataModel.dragIdx = nil
  View.Group_RowTemp:SetActive(false)
  View.Img_Mask.StaticGrid_Set.grid.self:RefreshAllElement()
end

return Controller
