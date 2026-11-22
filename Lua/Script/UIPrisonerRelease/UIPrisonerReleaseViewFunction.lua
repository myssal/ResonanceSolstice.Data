local View = require("UIPrisonerRelease/UIPrisonerReleaseView")
local Controller = require("UIPrisonerRelease/UIPrisonerReleaseController")
local ViewFunction = {
  PrisonerRelease_Btn_Close_Click = function(btn, str)
    View.self:CloseUI()
    View.self:Confirm()
  end,
  PrisonerRelease_ScrollGrid_List_SetGrid = function(element, elementIndex)
    Controller.SetElement(element, elementIndex)
  end
}
return ViewFunction
