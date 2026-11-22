local View = require("UIItemFloatInquirySettlement/UIItemFloatInquirySettlementView")
local DataModel = require("UIItemFloatInquirySettlement/UIItemFloatInquirySettlementDataModel")
local ViewFunction = {
  ItemFloatInquirySettlement_Btn_Close_Click = function(btn, str)
    UIManager:GoBack()
  end,
  ItemFloatInquirySettlement_Btn_Map_Click = function(btn, str)
    UIManager:GoBack()
    UIManager:Open(WitchData.GetUIPath("UI/Witches/Map/WitchesMap"))
  end
}
return ViewFunction
