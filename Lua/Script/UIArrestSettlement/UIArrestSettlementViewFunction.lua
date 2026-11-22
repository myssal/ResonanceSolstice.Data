local View = require("UIArrestSettlement/UIArrestSettlementView")
local DataModel = require("UIArrestSettlement/UIArrestSettlementDataModel")
local ViewFunction = {
  ArrestSettlement_ScrollGrid__SetGrid = function(element, elementIndex)
    DataModel:OnPrisonerSetGrid(element, elementIndex)
  end,
  ArrestSettlement_Btn__Click = function(btn, str)
    local VF = require("UISettlement/UISettlementViewFunction")
    VF:Settlement_Group_Victory_Btn_Next_Click()
  end,
  ArrestSettlement_ScrollGrid_Center_SetGrid = function(element, elementIndex)
    DataModel:OnPrisonerSetGrid(element, elementIndex)
  end
}
return ViewFunction
