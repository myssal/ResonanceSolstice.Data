local View = require("UIKoreaAcountInfo/UIKoreaAcountInfoView")
local DataModel = require("UIKoreaAcountInfo/UIKoreaAcountInfoDataModel")
local ViewController = require("UIKoreaAcountInfo/UIKoreaAcountInfoViewController")
local ViewFunction = {
  KoreaAcountInfo_Group_NewLoginAndJoin_Group_Main_Btn_Touchwith_Click = function(btn, str)
  end,
  KoreaAcountInfo_Group_NewLoginAndJoin_Group_Main_Group_Toggle_Btn_toggle_Click = function(btn, str)
  end,
  KoreaAcountInfo_Group_NewLoginAndJoin_Group_Main_Group_Toggle_Group_Text_Btn_UserAgreement_Click = function(btn, str)
    ViewController:OnBtnUserAgreement()
  end,
  KoreaAcountInfo_Group_NewLoginAndJoin_Group_Main_Group_Toggle_Group_Text_Btn_PrivacyPolicy_Click = function(btn, str)
    ViewController:OnBtnPrivacy()
  end,
  KoreaAcountInfo_Group_NewLoginAndJoin_Btn_Close_Click = function(btn, str)
    ViewController:OnBtnClose()
  end,
  KoreaAcountInfo_Group_NewLoginAndJoin_Group_Change_Btn_Back_Click = function(btn, str)
  end,
  KoreaAcountInfo_Group_NewLoginAndJoin_Group_Change_Btn_Join_Click = function(btn, str)
  end,
  KoreaAcountInfo_Group_NewLoginAndJoin_Group_Change_Btn_GetCode_Click = function(btn, str)
  end,
  KoreaAcountInfo_Btn_Tips3_Click = function(btn, str)
  end,
  KoreaAcountInfo_Group_NewLoginAndJoin_Group_Main_Group_Btn_Btn_yh_Click = function(btn, str)
    ViewController:OnBtnUserCenter()
  end,
  KoreaAcountInfo_Group_NewLoginAndJoin_Group_Main_Group_Btn_Btn_bd_Click = function(btn, str)
    ViewController:OnBtnBindAccount()
  end,
  KoreaAcountInfo_Group_NewLoginAndJoin_Group_Main_Group_Btn_Btn_dc_Click = function(btn, str)
    ViewController:OnBtnLogout()
  end
}
return ViewFunction
