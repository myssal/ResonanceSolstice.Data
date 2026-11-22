local View = require("UIPurchaseOrder/UIPurchaseOrderView")
local DataModel = require("UIPurchaseOrder/UIPurchaseOrderDataModel")
local ViewFunction = require("UIPurchaseOrder/UIPurchaseOrderViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.InitData()
    DataModel.RefreshOnShow()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    for element, v in pairs(DataModel.timeElementList) do
      if v.remainTime > 0 then
        v.remainTime = v.remainTime - Time.deltaTime
        if v.remainTime < 0 then
          v.remainTime = 0
        end
        local timeStr = DataModel.GetTimeStr(v.remainTime)
        element.Group_Show.Group_Time.Group_Waiting.Txt_Time:SetText(timeStr)
      else
        v.orderInfo.status = PrisonData.OrderStatus.Completed
        v.remainTime = 0
        element.Group_Show.Group_Time.Group_Waiting:SetActive(false)
        element.Group_Show.Group_Time.Group_Defult:SetActive(true)
        element.Group_Show.Group_Time.Group_Defult.Txt_Time:SetText("00:00:00")
        element.Group_Show.Group_Waiting:SetActive(false)
        element.Group_Show.Group_Finished:SetActive(true)
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
