local View = require("UIFriendsList/UIFriendsListView")
local DataModel = require("UIFriendsList/UIFriendsListDataModel")
local Controller = require("UIFriendsList/UIFriendsListController")
local ViewFunction = {
  FriendsList_Img_BG_Group_List_Btn_Log_Click = function(btn, str)
    Controller:SwitchTabIndex(2)
  end,
  FriendsList_Img_BG_Group_List_Btn_List_Click = function(btn, str)
    Controller:SwitchTabIndex(1)
  end,
  FriendsList_Img_BG_Group_List_Group_List_ScrollGrid_Friends_SetGrid = function(element, elementIndex)
    Controller:SetFriendElement(element, elementIndex)
  end,
  FriendsList_Img_BG_Group_List_Group_List_ScrollGrid_Friends_Group_Friend_Btn_Visit_Click = function(btn, str)
    Controller:TryVisitFriend(tonumber(str))
  end,
  FriendsList_Img_BG_Group_List_Group_List_ScrollGrid_Log_SetGrid = function(element, elementIndex)
    Controller:SetLogElement(element, elementIndex)
  end,
  FriendsList_Btn_Close_Click = function(btn, str)
    View.self:PlayAnimOnce("FriendsList_Out", function()
      UIManager:GoBack()
    end)
  end
}
return ViewFunction
