local View = require("UIRogueItemDetails/UIRogueItemDetailsView")
local DataModel = require("UIRogueItemDetails/UIRogueItemDetailsDataModel")
local Controller = require("UIRogueItemDetails/UIRogueItemDetailsController")
local ViewFunction = {
  RogueItemDetails_Btn_OK_Click = function(btn, str)
    UIManager:GoBack(false)
  end
}
return ViewFunction
