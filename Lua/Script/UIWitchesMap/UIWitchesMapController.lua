local View = require("UIWitchesMap/UIWitchesMapView")
local DataModel = require("UIWitchesMap/UIWitchesMapDataModel")
local Controller = {}

function Controller:AlignStartBranchGrids()
  local mapGrid = View.ScrollView_.Viewport.Content.Img_Map.StaticGrid_.grid
  local startGrid = View.ScrollView_.Viewport.Content.Img_Map.StaticGrid_Start.grid
  for startListIndex, gridIndices in ipairs(DataModel.startBranchGridIndices) do
    local startElement = startGrid[startListIndex]
    local centerGridIndex = gridIndices[math.ceil(#gridIndices / 2)]
    local centerElement = mapGrid[centerGridIndex]
    if startElement and centerElement then
      local offsetX = startElement.transform.position.x - centerElement.transform.position.x
      for _, gridIndex in ipairs(gridIndices) do
        local element = mapGrid[gridIndex]
        if element then
          local position = element.transform.position
          element.transform.position = Vector3(position.x + offsetX, position.y, position.z)
        end
      end
    end
  end
end

function Controller:Init()
  DataModel:Init()
  View.ScrollView_.Viewport.Content.Img_Map.StaticGrid_.grid.self:RefreshAllElement()
  View.ScrollView_.Viewport.Content.self:SetLocalPositionY(1880)
  View.ScrollView_.Viewport.Content.Img_Map.StaticGrid_Start.grid.self:SetDataCount(#DataModel.startList)
  View.ScrollView_.Viewport.Content.Img_Map.StaticGrid_Start.grid.self:RefreshAllElement()
  View.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
    Controller:AlignStartBranchGrids()
  end))
  local max = 20
  local group = "Group_Building"
  for i = 1, max do
    local objGroup = View.ScrollView_.Viewport.Content.Img_Map[group .. i]
    if objGroup then
      objGroup:SetActive(DataModel.sealList[i])
      if DataModel.sealList[i] then
        objGroup.Txt_Name:SetText(DataModel.sealList[i].name)
        objGroup.Group_Seal.Img_Unknown:SetActive(not DataModel.sealList[i].seal and table.count(DataModel.sealList[i].gridSealList) > 0)
        objGroup.Group_Seal:SetActive(table.count(DataModel.sealList[i].gridSealList) > 0)
        objGroup.Group_Seal.Img_Seal:SetActive(DataModel.sealList[i].seal or not (table.count(DataModel.sealList[i].gridSealList) > 0))
        if DataModel.sealList[i].seal ~= nil then
          local itemCA = PlayerData:GetFactoryData(DataModel.sealList[i].seal)
          objGroup.Group_Seal.Img_Seal:SetSprite(itemCA.iconPath)
        end
        if i == 9 then
          local buildingGridIndex = DataModel.sealList[i].displayIndex
          objGroup.Img_player:SetActive(DataModel.currentUserIndex == buildingGridIndex)
          objGroup.Img_arrived:SetActive(DataModel.arrivedList[buildingGridIndex])
        end
      end
    end
  end
  View.Group_CarStatus.self:SetActive(DataModel.isShowFloat)
  View.Group_CarStatus.Txt_Round:SetText(string.format(GetText(80610489), DataModel.floatNum))
  local groupBoss = "Group_Spot"
  local preBossBaseIndex = DataModel.sealList[9] and DataModel.sealList[9].displayIndex
  for i = 1, max do
    local obj = View.ScrollView_.Viewport.Content.Img_Map.Group_PreBoss[groupBoss .. i]
    if obj and preBossBaseIndex then
      local key = i + preBossBaseIndex
      obj.Img_player:SetActive(DataModel.currentUserIndex == key)
      obj.Img_arrived:SetActive(DataModel.arrivedList[key])
      if DataModel.parkGridList[key] then
        obj.self:SetActive(DataModel.parkGridList[key].isShow)
        obj.Img_:SetSprite(DataModel.eventIconList[key])
      else
        obj.self:SetActive(false)
      end
    end
  end
end

function Controller:ClickSealBtn(str)
  local row = DataModel.sealList[str]
  if row == nil then
    return
  end
  View.Group_BuildingInfo.self:SetActive(true)
  View.Group_BuildingInfo.Txt_Des:SetText(row.des)
  View.Group_BuildingInfo.Txt_Name:SetText(row.name)
  View.Group_BuildingInfo.Img_Building:SetSprite(row.pic)
  View.Group_BuildingInfo.Group_Event.Img_:SetSprite(row.eventMapIcon)
  View.Group_BuildingInfo.Group_Event.Img_:SetActive(row.eventMapIcon ~= nil)
  View.Group_BuildingInfo.Group_Seal.Img_Unknown:SetActive(row.seal == nil)
  View.Group_BuildingInfo.Group_Seal.Img_Icon:SetActive(row.seal ~= nil)
  View.Group_BuildingInfo.Group_Event.self:SetActive(table.count(row.gridSealList) ~= 0)
  View.Group_BuildingInfo.Group_Seal.self:SetActive(table.count(row.gridSealList) ~= 0)
  if View.Group_BuildingInfo.Img_BGTitle then
    View.Group_BuildingInfo.Img_BGTitle:SetActive(table.count(row.gridSealList) ~= 0)
  end
  if row.seal ~= nil then
    local itemCA = PlayerData:GetFactoryData(row.seal)
    View.Group_BuildingInfo.Group_Seal.Img_Icon:SetSprite(itemCA.iconPath)
  end
end

function Controller:ClickSealColor(str)
  local row = DataModel.sealList[str]
  if row == nil then
    return
  end
  if row.seal == nil then
    CommonTips.OpenTips(80610469)
    return
  end
end

return Controller
