local View = require("UISkipArrestSettlement/UISkipArrestSettlementView")
local DataModel = require("UIArrestSettlement/UIArrestSettlementDataModel")
local ViewFunction = {
  SkipArrestSettlement_Btn__Click = function(btn, str)
    UIManager:GoBack()
    View.self:Confirm()
  end,
  SkipArrestSettlement_ScrollGrid__SetGrid = function(element, elementIndex)
    DataModel:OnPrisonerSetGrid(element, elementIndex)
  end,
  SkipArrestSettlement_ScrollGrid_Center_SetGrid = function(element, elementIndex)
    DataModel:OnPrisonerSetGrid(element, elementIndex)
  end
}
return ViewFunction
