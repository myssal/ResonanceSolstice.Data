local View = require("UIOpenWorkshopSuccess/UIOpenWorkshopSuccessView")
local DataModel = require("UIOpenWorkshopSuccess/UIOpenWorkshopSuccessDataModel")
local ViewFunction = {
  OpenWorkshopSuccess_Btn_Mask_Click = function(btn, str)
    if DataModel.isFromProductionEdit then
      local ProductionEditController = require("UIPrisonProductionEdit/UIPrisonProductionEditController")
      ProductionEditController:AreaUnlockCallBack(DataModel.roomIndex, DataModel.unlockIndex)
    else
      local EditController = require("UIPrisonEdit/UIPrisonEditController")
      EditController:AreaUnlockCallBack(DataModel.roomIndex, DataModel.unlockIndex)
    end
    View.self:CloseUI()
  end
}
return ViewFunction
