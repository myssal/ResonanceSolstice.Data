local View = require("UIMoneyMakingGuide/UIMoneyMakingGuideView")
local DataModel = require("UIMoneyMakingGuide/UIMoneyMakingGuideDataModel")
local Controller = require("UIMoneyMakingGuide/UIMoneyMakingGuideController")
local ViewFunction = {
  MoneyMakingGuide_Btn_Close_Click = function(btn, str)
    UIManager:GoBack()
  end,
  MoneyMakingGuide_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  MoneyMakingGuide_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  MoneyMakingGuide_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  MoneyMakingGuide_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  MoneyMakingGuide_Group_Panel_Group_Panel01_Level_Btn_GoTo_Click = function(btn, str)
    Controller:OpenActivity()
  end,
  MoneyMakingGuide_Group_Panel_Group_Panel02_Trade_Btn_GoTo_Click = function(btn, str)
    Controller:ClickHomeTrade()
  end,
  MoneyMakingGuide_Group_Panel_Group_Panel04_Note_Btn_GoTo_Click = function(btn, str)
    Controller:OpenNote()
  end,
  MoneyMakingGuide_Group_Panel_Group_Panel03_Shop_Btn_GoTo_Click = function(btn, str)
    Controller:OpenShop()
  end
}
return ViewFunction
