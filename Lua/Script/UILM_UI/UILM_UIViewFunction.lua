local View = require("UILM_UI/UILM_UIView")
local DataModel = require("UILM_UI/UILM_UIDataModel")
local ViewFunction = {
  LM_UI_Group_BBG_Group_Btn_Group_ZL_Btn__Click = function(btn, str)
    DataModel.ClickMenu(DataModel.MenuType.Total)
  end,
  LM_UI_Group_BBG_Group_Btn_Group_BR_Btn__Click = function(btn, str)
    DataModel.ClickMenu(DataModel.MenuType.Day)
  end,
  LM_UI_Group_BBG_Group_Btn_Group_BZ_Btn__Click = function(btn, str)
    DataModel.ClickMenu(DataModel.MenuType.Week)
  end,
  LM_UI_Group_BBG_Group_Btn_Group_BY_Btn__Click = function(btn, str)
    DataModel.ClickMenu(DataModel.MenuType.Month)
  end,
  LM_UI_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  LM_UI_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  LM_UI_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  LM_UI_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  LM_UI_Btn_Close_Click = function(btn, str)
    View.self:CloseUI()
  end
}
return ViewFunction
