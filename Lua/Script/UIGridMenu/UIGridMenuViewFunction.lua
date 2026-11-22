local View = require("UIGridMenu/UIGridMenuView")
local DataModel = require("UIGridMenu/UIGridMenuDataModel")
local Manager = require("UIGridMenu/UIGridMenuManager")
local ViewFunction = {
  GridMenu_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Manager.OnCloseBtnClick()
  end,
  GridMenu_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  GridMenu_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  GridMenu_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  GridMenu_Group_Monopolis_Btn_CitySwitch_Click = function(btn, str)
    if View.Group_Monopolis.Group_CityList.gameObject.activeSelf then
      Manager.HideCityListPanel()
    else
      Manager.OpenCityListPanel()
    end
  end,
  GridMenu_Group_Monopolis_Group_RewardList_Btn_Day_Click = function(btn, str)
    Manager.OnClickDayRewardBtn()
  end,
  GridMenu_Group_Monopolis_Group_RewardList_Btn_Issue_Click = function(btn, str)
    Manager.OnClickIssueRewardBtn()
  end,
  GridMenu_Group_Monopolis_Group_RewardList_ScrollGrid_RewardList_SetGrid = function(element, elementIndex)
    Manager.RefreshRankRewardElement(element, elementIndex)
  end,
  GridMenu_Group_Monopolis_Group_RewardList_ScrollGrid_RewardList_Group_Item_StaticGrid_Reward_SetGrid = function(element, elementIndex)
    Manager.RefreshRewardElement(element, elementIndex)
  end,
  GridMenu_Group_Monopolis_Group_RewardList_ScrollGrid_RewardList_Group_Item_StaticGrid_Reward_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenRewardDetail(itemId, nil, true)
  end,
  GridMenu_Group_Monopolis_Group_RankList_ScrollGrid_RankList_SetGrid = function(element, elementIndex)
    Manager.RefreshRankElement(element, elementIndex)
  end,
  GridMenu_Group_Monopolis_Group_CityList_ScrollGrid_CityList_SetGrid = function(element, elementIndex)
    Manager.RefreshCityElement(element, elementIndex)
  end,
  GridMenu_Group_Monopolis_Group_CityList_ScrollGrid_CityList_Group_Item_Btn_Change_Click = function(btn, str)
  end,
  GridMenu_Group_Invest_Group_Right_ScrollGrid_InvestList_SetGrid = function(element, elementIndex)
    Manager.RefreshInvestElement(element, elementIndex)
  end,
  GridMenu_Group_Invest_Group_Right_ScrollGrid_InvestList_Group_Item_Btn_Invest_Click = function(btn, str)
    Manager.OnInvestElementTZBtnClick(tonumber(str))
  end,
  GridMenu_Img_Plane_Img_BG_Btn_Rank_Click = function(btn, str)
    Manager.OnRankBtnClick()
  end,
  GridMenu_Img_Plane_Img_BG_Btn_Get_Click = function(btn, str)
    Manager.OnGetBtnClick()
  end,
  GridMenu_Img_Plane_Img_BG_Group_God_Img_Des_StaticGrid_Txt_SetGrid = function(element, elementIndex)
    Manager.RefreshDescElement(element, elementIndex)
  end,
  GridMenu_Btn_Main_Click = function(btn, str)
    View.Btn_Main.Img_On:SetActive(true)
    View.Btn_Invest.Img_On:SetActive(false)
    View.self:PlayAnimOnce("Group_Invest_Out2", function()
      Manager.OpenCityMenuPanel()
    end)
  end,
  GridMenu_Btn_Invest_Click = function(btn, str)
    Manager.OnInvestBtnClick()
  end
}
return ViewFunction
