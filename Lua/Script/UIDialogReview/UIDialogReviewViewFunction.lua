local View = require("UIDialogReview/UIDialogReviewView")
local DataModel = require("UIDialogReview/UIDialogReviewDataModel")
local DialogDataModel = require("UIDialog/UIDialogDataModel")
local ViewFunction = {
  DialogReview_CustomScrollGrid_LOG_SetGrid = function(element, elementIndex)
    View.myCustomSV:SetItemShowAndHide(View.CustomScrollGrid_LOG.self.currentPosXOrY)
  end,
  DialogReview_Btn_LogBack_Click = function(btn, str)
    UIManager:CloseTip("UI/Dialog/DialogReview")
    DialogDataModel.isPause = false
    for i, v in ipairs(DialogDataModel.PaintData) do
      v.spine:SetOrder(v.spine.order + i, false)
    end
    DataModel.StopReviewSound()
  end,
  DialogReview_Btn_BackToButton_Click = function(btn, str)
  end,
  DialogReview_CustomScrollGrid_LOG_Group_Item_Btn_Sound_Click = function(btn, str)
    DialogDataModel.StopPlotSound()
    local cvPath = DataModel.dialog_content[tonumber(str)].dialog_info.cvPath
    DataModel.PlayReviewSound(cvPath)
  end
}
return ViewFunction
