local View = require("UIFriendUI/UIFriendUIView")
local DataModel = require("UIFriendUI/UIFriendUIDataModel")
local ViewFunction = {
  FriendUI_Btn_Next_Click = function(btn, str)
    DataModel.VisitNextClick()
  end,
  FriendUI_Btn_Good_Click = function(btn, str)
    DataModel.GiveLikeClick()
  end,
  FriendUI_Btn_Clean_Click = function(btn, str)
    DataModel.CleanClick()
  end,
  FriendUI_Btn_Rank_Click = function(btn, str)
    Net:SendProto("main.revenue_record", function(json)
      UIManager:Open("UI/RevenueOverview/RevenueOverview", Json.encode({
        incomeRecord = json.revenue_record
      }))
    end, PlayerData:GetUserInfo().uid)
  end,
  FriendUI_Btn_Moster_Click = function(btn, str)
    DataModel.ClickMonster()
  end,
  FriendUI_Btn_Moster_Btn_Debuff_Click = function(btn, str)
  end,
  FriendUI_Img_LV_Btn_ProfilePhoto_Click = function(btn, str)
  end,
  FriendUI_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    DataModel.GoBackSelfPlayground()
  end,
  FriendUI_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  FriendUI_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  FriendUI_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  FriendUI_Group_RateTips_Btn_Close_Click = function(btn, str)
    View.Group_RateTips:SetActive(false)
  end,
  FriendUI_Btn_FriendOpen_Click = function(btn, str)
    Net:SendProto("playground.fg_get_friend_list", function(json)
      if json.friends then
        UIManager:Open("UI/Playground/FriendIslandUpdate/FriendList/FriendList", Json.encode({
          friends = json.friends
        }))
      end
    end, 87300002)
  end,
  FriendUI_Btn_Last_Click = function(btn, str)
    DataModel.VisitLastClick()
  end,
  FriendUI_Group_Info_Btn_RateDesc_Click = function(btn, str)
    View.Group_RateTips:SetActive(true)
    local cleanRate = DataModel.GetCleanRate()
    View.Group_RateTips.Img_Tips.Txt_Tips:SetText(string.format(GetText(80610072), ClearFollowZero(cleanRate * 100), ClearFollowZero(DataModel.petReduceRate * 100)))
  end
}
return ViewFunction
