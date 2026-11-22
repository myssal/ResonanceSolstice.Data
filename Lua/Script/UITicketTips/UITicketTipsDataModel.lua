local View = require("UITicketTips/UITicketTipsView")
local DataModel = {}
DataModel.ActivityId = WitchData.GetActivityId()
DataModel.curBuyNum = 0
DataModel.MinBuyNum = 1
DataModel.remainBuyNum = 1

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.ActivityId = tonumber(data.activityId) or DataModel.ActivityId
end

function DataModel.InitData()
  DataModel.ParkMapCA = WitchData.GetParkMapCA(DataModel.ActivityId)
end

function DataModel.RefreshOnShow()
  local parkMapCA = DataModel.ParkMapCA
  local remainBuyNum = WitchData.GetDayRemainTicketBuyNum(DataModel.ActivityId)
  DataModel.remainBuyNum = remainBuyNum
  local itemId = parkMapCA.ticketBuyItem[1].id
  View.Group_Item.Btn_Item:SetClickParam(itemId)
  local buyNum = DataModel.MinBuyNum
  DataModel.curBuyNum = buyNum
  local sliderMinNum = DataModel.MinBuyNum
  if remainBuyNum == 1 then
    sliderMinNum = 0
  end
  View.Group_Slider.Slider_Value:SetMinAndMaxValue(sliderMinNum, remainBuyNum)
  View.Group_Slider.Slider_Value:SetSliderValue(buyNum)
  View.Group_Slider.Group_Num.Txt_Select:SetText(buyNum)
  View.Group_Slider.Group_Num.Txt_Possess:SetText(remainBuyNum)
  local costInfo = parkMapCA.ticketCostList[1]
  if costInfo then
    View.Group_Price.Txt_Num:SetText(costInfo.num)
    View.Btn_Medal.Txt_Num:SetText(PlayerData:GetGoodsById(costInfo.id).num)
  end
  View.Group_Limit.Txt_Num:SetText(WitchData.GetDayBuyNum(DataModel.ActivityId) .. "/" .. parkMapCA.ticketLimit)
end

return DataModel
