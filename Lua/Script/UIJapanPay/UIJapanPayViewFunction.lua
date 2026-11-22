local View = require("UIJapanPay/UIJapanPayView")
local DataModel = require("UIJapanPay/UIJapanPayDataModel")
local ViewController = require("UIJapanPay/UIJapanPayViewController")
local ViewFunction = {
  JapanPay_Group_PayWay_Group_visa_Btn__Click = function(btn, str)
    ViewController:OnBtnCard()
  end,
  JapanPay_Group_PayWay_Group_google1_Btn__Click = function(btn, str)
    ViewController:OnBtnGoogle()
  end,
  JapanPay_Group_PayWay_Group_apple_Btn__Click = function(btn, str)
    ViewController:OnBtnApple()
  end,
  JapanPay_Group_PayWay_Group_google2_Btn__Click = function(btn, str)
    ViewController:OnBtnNative()
  end,
  JapanPay_Group_Pay_Btn__Click = function(btn, str)
    ViewController:OnBtnConfirm()
  end
}
return ViewFunction
