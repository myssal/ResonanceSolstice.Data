local View = require("UISelectItemAcculate/UISelectItemAcculateView")
local DataModel = require("UISelectItemAcculate/UISelectItemAcculateDataModel")
local ViewFunction = require("UISelectItemAcculate/UISelectItemAcculateViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.SetJsonData(initParams)
    DataModel.InitData()
    DataModel.RefreshOnShow()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if DataModel.selectIndex then
      if DataModel.addSpeedType == 3 then
        DataModel.remainTime = DataModel.remainTime + Time.deltaTime
      elseif DataModel.remainTime > 0 then
        DataModel.remainTime = DataModel.remainTime - Time.deltaTime
        if DataModel.remainTime < 0 then
          DataModel.remainTime = 0
        end
        local maxNum = math.ceil(DataModel.remainTime / DataModel.itemUseList[DataModel.selectIndex].time)
        if maxNum < DataModel.maxUseNum then
          DataModel.maxUseNum = maxNum
          if maxNum < DataModel.selectNum then
            DataModel.selectNum = maxNum
          end
          if maxNum <= 1 then
            View.Group_SelectQuantity.Group_Slider.Slider_Value:SetMinAndMaxValue(0, 1)
            if maxNum == 1 then
              View.Group_SelectQuantity.Group_Slider.Slider_Value:SetSliderValue(1)
              DataModel.selectNum = 1
            else
              View.Group_SelectQuantity.Group_Slider.Slider_Value:SetSliderValue(0)
              DataModel.selectNum = 0
            end
            View.Group_SelectQuantity.Group_Slider.Slider_Value.slider.enabled = false
          else
            View.Group_SelectQuantity.Group_Slider.Slider_Value:SetMinAndMaxValue(1, maxNum)
            View.Group_SelectQuantity.Group_Slider.Slider_Value:SetSliderValue(DataModel.selectNum)
          end
          View.Group_SelectQuantity.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.selectNum)
          View.Group_SelectQuantity.Group_Slider.Group_Num.Txt_Max:SetText(maxNum)
        end
      end
      local timeStr = DataModel.GetTimeStr(DataModel.remainTime)
      if DataModel.addSpeedType == 1 then
        View.Group_Line.Txt_BuildTime:SetText(timeStr)
      elseif DataModel.addSpeedType == 2 or DataModel.addSpeedType == 3 or DataModel.addSpeedType == 4 then
        View.Group_ProductLine.Txt_ProductTime:SetText(timeStr)
      end
      DataModel.RefreshImmediatelyCost()
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
