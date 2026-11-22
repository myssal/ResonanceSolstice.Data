local View = require("UILinkPasswordSet/UILinkPasswordSetView")
local DataModel = require("UILinkPasswordSet/UILinkPasswordSetDataModel")
local ViewController = require("UILinkPasswordSet/UILinkPasswordSetViewController")
local ViewFunction = {
  LinkPasswordSet_Btn_BG_Click = function(btn, str)
  end,
  LinkPasswordSet_Group_GoLink_Btn_Confirm_Click = function(btn, str)
    ViewController:StartDataLink()
  end,
  LinkPasswordSet_Group_GoLink_Btn_Cancel_Click = function(btn, str)
    ViewController:CloseView()
  end,
  LinkPasswordSet_Group_SetPassword_Btn_Confirm_Click = function(btn, str)
    ViewController:SetDataLinkPassword()
  end,
  LinkPasswordSet_Group_SetPassword_Btn_Cancel_Click = function(btn, str)
    ViewController:CloseView()
  end,
  LinkPasswordSet_Group_SetSuccess_Btn_Back_Click = function(btn, str)
    ViewController:CloseView()
  end,
  LinkPasswordSet_Btn_Tips3_Click = function(btn, str)
    ViewController:HideTip()
  end,
  LinkPasswordSet_Group_SetPassword_Group_ID_Btn_Copy_Click = function(btn, str)
    ViewController:OnBtnCopyLinkCode()
  end
}
return ViewFunction
