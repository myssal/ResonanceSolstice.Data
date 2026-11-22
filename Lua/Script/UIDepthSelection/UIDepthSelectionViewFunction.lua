local View = require("UIDepthSelection/UIDepthSelectionView")
local DataModel = require("UIDepthSelection/UIDepthSelectionDataModel")
local Controller = require("UIDepthSelection/UIDepthSelectionController")
local ViewFunction = {
  DepthSelection_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  DepthSelection_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  DepthSelection_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  DepthSelection_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  DepthSelection_Img_Reward_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:OnSetRewardGrid(element, elementIndex)
  end,
  DepthSelection_Img_Reward_ScrollGrid_Reward_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenCubeRogueItemDetails({id = str})
  end,
  DepthSelection_Btn_Descent_Click = function(btn, str)
    UIManager:Open("UI/CubeRogue/Descent/Descent", Json.encode({
      cubeId = DataModel.cubeId
    }))
  end,
  DepthSelection_Btn_Start_Click = function(btn, str)
    Controller:OnBtnStart()
  end,
  DepthSelection_ScrollView_Main_Viewport_Content_Group_Line_StaticGrid_Line_SetGrid = function(element, elementIndex)
  end,
  DepthSelection_ScrollView_Main_Viewport_Content_StaticGrid_Level_SetGrid = function(element, elementIndex)
    Controller:OnSetLevelGrid(element, elementIndex)
  end,
  DepthSelection_ScrollView_Main_Viewport_Content_StaticGrid_Level_Group_Depth_Btn_Defult_Click = function(btn, str)
    Controller:OnBtnLevel(tonumber(str))
  end
}
return ViewFunction
