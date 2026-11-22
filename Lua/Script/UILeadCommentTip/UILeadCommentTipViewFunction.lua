local View = require("UILeadCommentTip/UILeadCommentTipView")
local DataModel = require("UILeadCommentTip/UILeadCommentTipDataModel")
local ViewController = require("UILeadCommentTip/UILeadCommentTipViewController")
local ViewFunction = {
  LeadCommentTip_Btn_Accept_Click = function(btn, str)
    ViewController:OnBtnAccept()
  end,
  LeadCommentTip_Btn_Refuse_Click = function(btn, str)
    ViewController:OnBtnRefuse()
  end
}
return ViewFunction
