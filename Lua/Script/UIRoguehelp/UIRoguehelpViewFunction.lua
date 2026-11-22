local View = require("UIRoguehelp/UIRoguehelpView")
local DataModel = require("UIRoguehelp/UIRoguehelpDataModel")
local Controller = require("UIRoguehelp/UIRoguehelpController")
local ViewFunction = {
  Roguehelp_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
  end,
  Roguehelp_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  Roguehelp_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Roguehelp_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  Roguehelp_Group_Info_Group_Btn_Btn_frost_Click = function(btn, str)
    Controller.OnNextBtnClick()
  end,
  Roguehelp_Group_Info_Group_Btn_Btn_back_Click = function(btn, str)
    Controller.OnBackBtnClick()
  end,
  Roguehelp_Group_Info_StaticGrid_Pagecount_SetGrid = function(element, elementIndex)
    Controller.RefreshPageCountElement(element, elementIndex)
  end,
  Roguehelp_Btn_quit_Click = function(btn, str)
    UIManager:GoBack()
  end,
  Roguehelp_Group_Info_Group_bg_Btn__Click = function(btn, str)
  end
}
return ViewFunction
