local View = require("UIChangeSealEvent/UIChangeSealEventView")
local DataModel = require("UIChangeSealEvent/UIChangeSealEventDataModel")
local Controller = require("UIChangeSealEvent/UIChangeSealEventController")
local ViewFunction = {
  ChangeSealEvent_Img_mask_Btn__Click = function(btn, str)
    if DataModel.sealEventType == "refreshSealToFull" then
      Controller:CloseAndContinue()
    end
  end,
  ChangeSealEvent_Group_GetMulti_Group_Deal_StaticGrid_Seal_SetGrid = function(element, elementIndex)
    Controller:SetGetMultiSealElement(element, elementIndex)
  end,
  ChangeSealEvent_Group_Copy_Group_Deal_Group_Seal_Btn_Instead_Click = function(btn, str)
  end,
  ChangeSealEvent_Group_Copy_Group_Deal_StaticGrid_Seal_SetGrid = function(element, elementIndex)
    Controller:SetCopySealElement(element, elementIndex)
  end,
  ChangeSealEvent_Group_Copy_Group_Deal_StaticGrid_Seal_Group_Seal_Btn_Instead_Click = function(btn, str)
    Controller:SelectSeal(tonumber(str))
  end,
  ChangeSealEvent_Group_Copy_Btn_Confirm_Click = function(btn, str)
    Controller:ConfirmCopy()
  end
}
return ViewFunction
