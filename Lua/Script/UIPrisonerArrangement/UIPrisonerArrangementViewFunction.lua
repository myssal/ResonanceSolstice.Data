local View = require("UIPrisonerArrangement/UIPrisonerArrangementView")
local DataModel = require("UIPrisonerArrangement/UIPrisonerArrangementDataModel")
local ViewFunction = {
  PrisonerArrangement_Btn__Click = function(btn, str)
    UIManager:GoBack(true)
  end,
  PrisonerArrangement_ScrollGrid__SetGrid = function(element, elementIndex)
    DataModel:SetPrisonerGrid(element, elementIndex)
  end
}
return ViewFunction
