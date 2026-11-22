local View = require("UITeam_Illustration/UITeam_IllustrationView")
local DataModel = require("UITeam_Illustration/UITeam_IllustrationDataModel")
local Controller = require("UITeam_Illustration/UITeam_IllustrationController")
local ViewFunction = {
  Team_Illustration_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:ClosePanel()
  end,
  Team_Illustration_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  Team_Illustration_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Team_Illustration_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  Team_Illustration_ScrollGrid_Tab_SetGrid = function(element, elementIndex)
    Controller.RefreshTabElement(element, elementIndex)
  end,
  Team_Illustration_ScrollGrid_Tab_Group_Item_Btn__Click = function(btn, str)
  end,
  Team_Illustration_ScrollView_Info_Viewport_Content_StaticGrid_ExtraBuff_SetGrid = function(element, elementIndex)
    Controller.RefreshExtraBuffElement(element, elementIndex)
  end,
  Team_Illustration_Group_Info_Group_Extra_StaticGrid_Icon_SetGrid = function(element, elementIndex)
    Controller.RefreshExtraBuffElement(element, elementIndex)
  end,
  Team_Illustration_Group_Info_Group_Extra_StaticGrid_Icon_Group_Item_Btn__Click = function(btn, str)
  end,
  Team_Illustration_Group_Info_Group_Extra_Group_Item_Btn__Click = function(btn, str)
  end
}
return ViewFunction
