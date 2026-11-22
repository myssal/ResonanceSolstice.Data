local View = require("UICompletePopup/UICompletePopupView")
local DataModel = require("UICompletePopup/UICompletePopupDataModel")
local ViewFunction = {
  CompletePopup_Btn_Mask_Click = function(btn, str)
    PlayerData:SetPlayerPrefs("string", "constructionSchedule", "isOpen", true)
    View.self:PlayAnim("Out", function()
      Net:SendProto("main.get_activity_stage", function(json)
        UIManager:GoBack()
        CommonTips.OpenShowItem(json.reward)
      end, DataModel.activityId, "completed", 0)
    end)
  end
}
return ViewFunction
