local View = require("UITicketTips/UITicketTipsView")
local DataModel = require("UITicketTips/UITicketTipsDataModel")
local ViewFunction = {
  TicketTips_Btn_BG_Click = function(btn, str)
    View.self:CloseUI()
  end,
  TicketTips_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreItemTips({itemId = itemId})
  end,
  TicketTips_Btn_Min_Click = function(btn, str)
    View.Group_Slider.Slider_Value:SetSliderValue(DataModel.MinBuyNum)
  end,
  TicketTips_Btn_Dec_Click = function(btn, str)
    if DataModel.curBuyNum == 1 then
      return
    end
    DataModel.curBuyNum = DataModel.curBuyNum - 1
    View.Group_Slider.Slider_Value:SetSliderValue(DataModel.curBuyNum)
  end,
  TicketTips_Group_Slider_Slider_Value_Slider = function(slider, value)
    local parkMapCA = WitchData.GetParkMapCA(DataModel.ActivityId)
    local num = math.floor(value)
    DataModel.curBuyNum = num
    View.Group_Slider.Group_Num.Txt_Select:SetText(num)
    local costInfo = parkMapCA.ticketCostList[1]
    if costInfo then
      View.Group_Price.Txt_Num:SetText(costInfo.num * num)
    end
  end,
  TicketTips_Group_Slider_Slider_Value_SliderDown = function(slider)
  end,
  TicketTips_Group_Slider_Slider_Value_SliderUp = function(slider)
  end,
  TicketTips_Btn_Add_Click = function(btn, str)
    if DataModel.curBuyNum == DataModel.remainBuyNum then
      return
    end
    DataModel.curBuyNum = DataModel.curBuyNum + 1
    View.Group_Slider.Slider_Value:SetSliderValue(DataModel.curBuyNum)
  end,
  TicketTips_Btn_Max_Click = function(btn, str)
    View.Group_Slider.Slider_Value:SetSliderValue(DataModel.remainBuyNum)
  end,
  TicketTips_Btn_Cancel_Click = function(btn, str)
    View.self:CloseUI()
  end,
  TicketTips_Btn_Sale_Click = function(btn, str)
    local function cb(json)
      if json.reward then
        CommonTips.OpenShowItem(json.reward)
      end
      if UIManager:IsPanelOpened(WitchData.GetActivityUIPath(DataModel.ActivityId)) then
        local UIWitchsActivityMainDataModel = require("UIWitchsActivityMain/UIWitchsActivityMainDataModel")
        UIWitchsActivityMainDataModel.RefreshTicket(DataModel.ActivityId)
        UIWitchsActivityMainDataModel.RefreshJoinInMapRedPoint(DataModel.ActivityId)
      end
      View.self:CloseUI(true)
    end
    
    WitchData.ReqBuyTicket(DataModel.curBuyNum, cb, DataModel.ActivityId)
  end,
  TicketTips_Btn_Medal_Click = function(btn, str)
  end,
  TicketTips_Btn_Medal_Btn_Add_Click = function(btn, str)
    CommonTips.OpenStoreBuy()
  end
}
return ViewFunction
