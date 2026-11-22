local View = require("UIActivityEngineCore/UIActivityEngineCoreView")
local DataModel = require("UIActivityEngineCore/UIActivityEngineCoreDataModel")
local Controller = require("UIActivityEngineCore/UIActivityEngineCoreController")
local ViewFunction = {
  ActivityEngineCore_Group_Reward_Btn__Click = function(btn, str)
    Controller.OnRewardBtnClick()
  end,
  ActivityEngineCore_Group_Right_Group_CoreLevel_Img_Contain_StaticGrid_Corelist_SetGrid = function(element, elementIndex)
    Controller.RefreshCoreListElement(element, elementIndex)
  end,
  ActivityEngineCore_Group_Right_Group_Skip_Btn__Click = function(btn, str)
    Controller.OnSkipBtnClick()
  end
}
return ViewFunction
