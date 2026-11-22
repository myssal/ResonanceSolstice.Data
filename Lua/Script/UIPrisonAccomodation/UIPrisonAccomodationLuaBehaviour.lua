local View = require("UIPrisonAccomodation/UIPrisonAccomodationView")
local DataModel = require("UIPrisonAccomodation/UIPrisonAccomodationDataModel")
local ViewFunction = require("UIPrisonAccomodation/UIPrisonAccomodationViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams then
      DataModel.SetJsonData(initParams)
    end
    DataModel.InitData()
    DataModel.RefreshOnShow()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    local prisonCA = PrisonData.GetPrisonCA()
    local areaCount = table.count(prisonCA.prisonRoomPosition)
    if 1 < areaCount then
      local camPos = HomeManager.cam.transform.localPosition
      local stationPlaceCA = PlayerData:GetFactoryData(81500009, "HomeStationFactory")
      local stage = (stationPlaceCA.cameraRight - stationPlaceCA.cameraLeft) / (areaCount - 1)
      local areaIndex = math.ceil(camPos.x / stage)
      local areaId = PrisonData.CellRoomAreaIndexToAreaIdMap[areaIndex]
      local unLock = DataModel.IsAreaUnLock(areaId)
      if unLock and areaIndex ~= DataModel.areaIndex then
        local ctr = View.Group_Area["Group_" .. DataModel.areaIndex]
        if ctr then
          local oldAreaId = PrisonData.CellRoomAreaIndexToAreaIdMap[DataModel.areaIndex]
          local oldAreaUnLock = DataModel.IsAreaUnLock(oldAreaId)
          ctr.Group_Locked:SetActive(not oldAreaUnLock)
          ctr.Group_Selected:SetActive(false)
          ctr.Btn_:SetActive(oldAreaUnLock)
        end
        ctr = View.Group_Area["Group_" .. areaIndex]
        if ctr then
          ctr.Group_Locked:SetActive(false)
          ctr.Group_Selected:SetActive(true)
          ctr.Btn_:SetActive(false)
        end
        DataModel.areaIndex = areaIndex
        PrisonData.SetCurCellRoomAreaIndex(areaId)
      end
    end
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
