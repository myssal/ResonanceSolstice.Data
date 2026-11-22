local View = require("UIFurnitureTips/UIFurnitureTipsView")
local DataModel = require("UIFurnitureTips/UIFurnitureTipsDataModel")
local ViewFunction = require("UIFurnitureTips/UIFurnitureTipsViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local param = Json.decode(initParams)
    local furCA = PlayerData:GetFactoryData(param.id, "HomeFurnitureFactory")
    View.Group_Show.Txt_Name:SetText(furCA.name)
    View.Group_Show.ScrollView_Describe.Viewport.Txt_Describe:SetText(furCA.describe)
    local homeCoachDataModel = require("UIHomeCoach/UIHomeCoachDataModel")
    local furData = homeCoachDataModel.GetFurnitureData(param.id)
    local furSkinCA
    local count = PlayerData.GetFurnitureTotleCount(param.id)
    View.Group_Show.Group_Num.self:SetActive(true)
    View.Group_Show.Group_Num.Txt_Num:SetText(count)
    if furData.data[1] == nil then
      furSkinCA = PlayerData:GetFactoryData(param.id, "HomeFurnitureSkinFactory")
    else
      furSkinCA = PlayerData:GetFactoryData(PosClickHandler.GetFurnitureSkinId(furData.data[1].server.u_fid), "HomeFurnitureSkinFactory")
    end
    local tipsPath = ""
    if tonumber(param.id) == 81300192 then
      tipsPath = PlayerData:GetUserInfo().gender == 1 and furSkinCA.tipsPath or furSkinCA.SecondtipsPath
    else
      tipsPath = furSkinCA.tipsPath
    end
    View.Group_Show.Img_Icon:SetSprite(tipsPath)
    local x, y, z = furCA.x, furCA.y, furCA.z
    local cellX, cellY, cellZ = 1, 1, 1
    local playgroundId = param.playgroundId or CommonCoachData.GetPlaygroundId()
    if playgroundId and 0 < playgroundId then
      local ca = PlayerData:GetFactoryData(playgroundId)
      cellX = ca.cellX
      cellY = ca.cellY
      cellZ = ca.cellZ
    else
      local homeConfig = PlayerData:GetFactoryData(99900014, "ConfigFactory")
      cellX = homeConfig.CellX
      cellY = homeConfig.CellY
      cellZ = homeConfig.CellZ
    end
    x = math.ceil(x / cellX)
    y = math.ceil(y / cellY)
    z = math.ceil(z / cellZ)
    local size = x .. "\195\151" .. z .. "\195\151" .. y
    View.Group_Show.Txt_Area:SetText(size)
    DataModel.furnitureAttrList = {}
    local addedTable = {}
    local homeConfig = PlayerData:GetFactoryData(99900014, "ConfigFactory")
    local machineTypeList = PlayerData:GetFactoryData(99900014).prisonMachineList
    local isMachine = false
    for i, v in ipairs(machineTypeList) do
      if v.id == furCA.type then
        isMachine = true
        break
      end
    end
    if isMachine then
      local t = {}
      t.attrName = GetText(80607156)
      t.param = furCA.PrisonExtraOutputProbability
      t.iconPath = homeConfig.furnitureAttrList[1].iconPath
      table.insert(DataModel.furnitureAttrList, t)
    else
      for k, v in pairs(homeConfig.furnitureAttrList) do
        local param = furCA[v.field]
        if 0 < param then
          addedTable[k] = 0
          local t = {}
          t.attrName = v.attrName
          t.param = param
          t.iconPath = v.iconPath
          table.insert(DataModel.furnitureAttrList, t)
        end
      end
    end
    local num = #DataModel.furnitureAttrList
    if num < 4 then
      for k, v in pairs(homeConfig.furnitureAttrList) do
        if addedTable[k] == nil then
          addedTable[k] = 0
          local t = {}
          t.attrName = v.attrName
          t.param = 0
          t.iconPath = v.iconPath
          table.insert(DataModel.furnitureAttrList, t)
          num = num + 1
          if 4 <= num then
            break
          end
        end
      end
    end
    View.Group_Show.StaticGrid_Attr.grid.self:RefreshAllElement()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
