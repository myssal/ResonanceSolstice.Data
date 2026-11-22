local View = require("UISeal/UISealView")
local DataModel = require("UISeal/UISealDataModel")
local Controller = require("UISeal/UISealController")
local ViewFunction = {
  Seal_Img_mask_Btn__Click = function(btn, str)
    if table.count(WitchData.GetWitchesData().other_seal) > 0 then
      return
    end
    local mainDataModel = require("UIWitchMain/UIWitchMainDataModel")
    mainDataModel.RefreshSeal()
    View.self:CloseUI()
    View.self:Confirm()
    if DataModel.WitchEventNextId and 0 < DataModel.WitchEventNextId then
      local EventDataModel = require("UIWitchesEvent/UIWitchesEventDataModel")
      EventDataModel.DealEvent(DataModel.WitchEventNextId)
      DataModel.WitchEventNextId = nil
    end
  end,
  Seal_Group_Single_Btn__Click = function(btn, str)
    CommonTips.OpenItem({
      itemId = DataModel.NewSealId
    })
  end,
  Seal_Group_Multi_Btn__Click = function(btn, str)
    CommonTips.OpenItem({
      itemId = DataModel.NewSealId
    })
  end,
  Seal_Group_Multi_Group_Deal_Group_Seal_Btn_Instead_Click = function(btn, str)
  end,
  Seal_Group_Multi_Group_Deal_StaticGrid_Seal_SetGrid = function(element, elementIndex)
    Controller:SetSealElement(element, elementIndex)
  end,
  Seal_Group_Multi_Group_Deal_StaticGrid_Seal_Group_Seal_Btn_Instead_Click = function(btn, str)
    Controller:ClickInstead(tonumber(str))
  end,
  Seal_Group_Multi_Group_Deal_Img_Drop_Btn__Click = function(btn, str)
  end,
  Seal_Group_Multi_Group_Deal_Btn_Drop_Click = function(btn, str)
    Controller:ClickInstead(-1)
  end
}
return ViewFunction
