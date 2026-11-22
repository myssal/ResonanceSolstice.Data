local View = require("UIEmailLogin/UIEmailLoginView")
local DataModel = require("UIEmailLogin/UIEmailLoginDataModel")
local ViewController = require("UIEmailLogin/UIEmailLoginViewController")
local ViewFunction = {
  EmailLogin_Group_NewLoginAndJoin_Img_BG_Btn_Cmd_Click = function(btn, str)
  end,
  EmailLogin_Group_NewLoginAndJoin_Group_Login_Btn_Back_Click = function(btn, str)
  end,
  EmailLogin_Group_NewLoginAndJoin_Group_Login_Btn_Login_Click = function(btn, str)
    ViewController:Login()
  end,
  EmailLogin_Group_NewLoginAndJoin_Group_Login_Btn_ShowandHide_Click = function(btn, str)
    ViewController:SwitchLoginPasswordShow()
  end,
  EmailLogin_Group_NewLoginAndJoin_Group_Login_Btn_Forget_Click = function(btn, str)
    ViewController:OnGroupLoginBtnForgetClick()
  end,
  EmailLogin_Group_NewLoginAndJoin_Group_Login_Btn_Join_Click = function(btn, str)
    ViewController:SwitchPanelRegister()
  end,
  EmailLogin_Group_NewLoginAndJoin_Group_Join_Btn_Back_Click = function(btn, str)
    ViewController:SwitchPanelLogin()
  end,
  EmailLogin_Group_NewLoginAndJoin_Group_Join_Btn_Join_Click = function(btn, str)
    ViewController:Register()
  end,
  EmailLogin_Group_NewLoginAndJoin_Group_Join_Btn_GetCode_Click = function(btn, str)
    ViewController:GetEmailCodeForRegister()
  end,
  EmailLogin_Group_NewLoginAndJoin_Group_Switch_Btn_Show_Click = function(btn, str)
  end,
  EmailLogin_Group_NewLoginAndJoin_Group_Switch_Btn_Login_Click = function(btn, str)
  end,
  EmailLogin_Group_NewLoginAndJoin_Group_Switch_Btn_Switch_Click = function(btn, str)
  end,
  EmailLogin_Group_NewLoginAndJoin_Group_Switch_Btn_off_Click = function(btn, str)
  end,
  EmailLogin_Group_NewLoginAndJoin_Group_Switch_ScrollGrid_AccountList_SetGrid = function(element, elementIndex)
  end,
  EmailLogin_Group_NewLoginAndJoin_Group_Switch_ScrollGrid_AccountList_Group_Item_Btn_Choose_Click = function(btn, str)
  end,
  EmailLogin_Group_NewLoginAndJoin_Group_Switch_ScrollGrid_AccountList_Group_Item_Btn_Close_Click = function(btn, str)
  end,
  EmailLogin_Group_NewLoginAndJoin_Btn_Close_Click = function(btn, str)
  end,
  EmailLogin_Group_NewLoginAndJoin_Group_Change_Btn_Back_Click = function(btn, str)
    ViewController:SwitchPanelLogin()
  end,
  EmailLogin_Group_NewLoginAndJoin_Group_Change_Btn_Change_Click = function(btn, str)
    ViewController:ChangePassword()
  end,
  EmailLogin_Group_NewLoginAndJoin_Group_Change_Btn_GetCode_Click = function(btn, str)
    ViewController:GetEmailCodeForChangePassword()
  end,
  EmailLogin_Btn_Tips3_Click = function(btn, str)
    ViewController:HideTips()
  end,
  EmailLogin_Group_tip4_Btn_Cancel_Click = function(btn, str)
  end,
  EmailLogin_Group_tip4_Btn_Sure_Click = function(btn, str)
  end,
  EmailLogin_Group_NewLoginAndJoin_Group_Join_Group_Toggle_Btn_toggle_Click = function(btn, str)
    ViewController:OnToggleUserAgreement()
  end,
  EmailLogin_Group_NewLoginAndJoin_Group_Join_Group_Toggle_Group_Text_Btn_UserAgreement_Click = function(btn, str)
    ViewController:OnBtnUserAgreement()
  end,
  EmailLogin_Group_NewLoginAndJoin_Group_Join_Group_Toggle_Group_Text_Btn_PrivacyPolicy_Click = function(btn, str)
    ViewController:OnBtnPrivacy()
  end
}
return ViewFunction
