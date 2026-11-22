local View = require("UIPrison/UIPrisonView")
local DataModel = require("UIPrison/UIPrisonDataModel")
local ViewFunction = require("UIPrison/UIPrisonViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    View.Img_RayCastMask:SetActive(true)
    DataModel.PrisonerRelease()
    DataModel.InitData()
    DataModel.RefreshOnShow()
    PrisonController.PlayBgmSound()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    for roomTypeId, ctr in pairs(DataModel.buildCtrList) do
      local data = DataModel.buildList[roomTypeId]
      if data then
        if data.remainTime and data.remainTime > 0 then
          data.remainTime = data.remainTime - Time.deltaTime
          if ctr.Img_FirstBuild and ctr.Img_FirstBuild.IsActive then
            local timeStr = DataModel.GetTimeStr(data.remainTime)
            ctr.Img_FirstBuild.Group_Time.Txt_Time:SetText(timeStr)
          end
          if ctr.Group_Build and ctr.Group_Build.IsActive then
            local timeStr = DataModel.GetTimeStr(data.remainTime)
            ctr.Group_Build.Txt_Time:SetText(timeStr)
          end
          if data.remainTime <= 0 then
            local buildTypeCA = PlayerData:GetFactoryData(roomTypeId, "PrisonRoomTypeFactory")
            ctr:SelectPlayAnim("CompleteConstruction")
            ctr.Img_FirstBuild:SetActive(false)
            ctr.Group_Locked:SetActive(false)
            ctr.Group_Build:SetActive(false)
            if buildTypeCA.sizeType == "RoomA" then
              if ctr.UI_Prison_BuildingLevelUp_Small then
                ctr.UI_Prison_BuildingLevelUp_Small:SetActive(false)
                ctr.UI_Prison_BuildingLevelUp_Small:SetActive(true)
              end
            elseif buildTypeCA.sizeType == "RoomB" and ctr.UI_Prison_BuildingLevelUp_Big then
              ctr.UI_Prison_BuildingLevelUp_Big:SetActive(false)
              ctr.UI_Prison_BuildingLevelUp_Big:SetActive(true)
            end
            DataModel.buildList[roomTypeId] = nil
          end
        end
      elseif ctr.Group_LvAvailable then
        ctr.Group_LvAvailable:SetActive(DataModel.IsRoomCanUpgrade(roomTypeId))
      end
    end
    for i, v in pairs(DataModel.materialWorkingList) do
      local workTime = TimeUtil:GetServerTimeStamp() - v.startTime + v.speedTime
      local timeTbl = TimeUtil:SecondToTableHMS(workTime)
      v.ctr:SetText(string.format("%02d:%02d:%02d", timeTbl.hour, timeTbl.minute, timeTbl.second))
    end
    DataModel.RefreshRoomFunList()
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
