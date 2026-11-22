local View = require("UIGroup_GukaAllAttr/UIGroup_GukaAllAttrView")
local DataModel = require("UIGroup_GukaAllAttr/UIGroup_GukaAllAttrDataModel")
local ViewFunction = {
  Group_GukaAllAttr_Btn_Close_Click = function(btn, str)
    View.self:CloseUI()
  end,
  Group_GukaAllAttr_ScrollGrid__SetGrid = function(element, elementIndex)
    DataModel.SetEffectElement(element, elementIndex)
  end
}
return ViewFunction
