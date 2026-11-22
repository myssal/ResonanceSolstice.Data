local View = require("UILinkLogin/UILinkLoginView")
local DataModel = require("UILinkLogin/UILinkLoginDataModel")
local ViewController = require("UILinkLogin/UILinkLoginViewController")
local ViewFunction = {
  LinkLogin_Btn_BG_Click = function(btn, str)
  end,
  LinkLogin_Group_Login_Btn_Confirm_Click = function(btn, str)
    ViewController:StartLogin()
  end,
  LinkLogin_Group_Login_Btn_Cancel_Click = function(btn, str)
    ViewController:CloseView()
  end,
  LinkLogin_Group_LoginSuccess_Btn_Confirm_Click = function(btn, str)
    ViewController:StartLoginAfter()
  end,
  LinkLogin_Btn_Tips3_Click = function(btn, str)
    ViewController:HideTip()
  end
}
return ViewFunction
