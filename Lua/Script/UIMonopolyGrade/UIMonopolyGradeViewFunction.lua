local View = require("UIMonopolyGrade/UIMonopolyGradeView")
local DataModel = require("UIMonopolyGrade/UIMonopolyGradeDataModel")
local Controller = require("UIMonopolyGrade/UIMonopolyGradeController")
local ViewFunction = {
  MonopolyGrade_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    Controller.OnQuitBtnClick()
  end,
  MonopolyGrade_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  MonopolyGrade_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  MonopolyGrade_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  MonopolyGrade_Btn_GetAll_Click = function(btn, str)
    Controller.OnGetAllRewardBtnClick()
  end,
  MonopolyGrade_NewScrollGrid_RewardList_SetGrid = function(element, elementIndex)
    Controller.RefreshRankElement(element, elementIndex)
  end,
  MonopolyGrade_NewScrollGrid_RewardList_Group_Item_Img_Able_Btn_Get_Click = function(btn, str)
    local index = tonumber(str) or 0
    local getState = Controller.GetGetBtnState(index)
    if getState ~= 2 then
      return
    end
    Net:SendProto("monopoly.recv_monopoly_lv_reward", function(json)
      if string.nilorempty(json.rc) then
        UIManager:Open("UI/Monopoly/UI/ShowItem/MonopolyShowItem", Json.encode({
          rewards = json.reward,
          title = nil,
          ignoreCloseTime = true
        }), nil)
        Controller.GetLVReward(index - 1)
        Controller.RefreshAllGetBtnState()
      end
    end, index - 1, function(json)
      if not string.nilorempty(json) then
        Controller.CheckMPYIsOver()
      end
    end)
  end,
  MonopolyGrade_NewScrollGrid_RewardList_Group_Item_StaticGrid_Item_SetGrid = function(element, elementIndex)
    Controller.RefreshRewardElement(element, elementIndex)
  end,
  MonopolyGrade_NewScrollGrid_RewardList_Group_Item_StaticGrid_Item_Group_SimpleItem_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenRewardDetail(itemId)
  end
}
return ViewFunction
