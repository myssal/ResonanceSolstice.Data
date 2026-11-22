local View = require("UICollectionReward/UICollectionRewardView")
local DataModel = require("UICollectionReward/UICollectionRewardDataModel")
local Controller = require("UICollectionReward/UICollectionRewardController")
local ViewFunction = {
  CollectionReward_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    EventMgr:SendEvent("event_cube_rogue_collection_close", DataModel.bookId)
    UIManager:ClosePanel()
  end,
  CollectionReward_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  CollectionReward_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  CollectionReward_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  CollectionReward_ScrollGrid_Stage_SetGrid = function(element, elementIndex)
    Controller.RefreshItemElement(element, elementIndex)
  end,
  CollectionReward_ScrollGrid_Stage_Group_Item_StaticGrid_Rewareds_SetGrid = function(element, elementIndex)
    Controller.RefreshRewardElement(element, elementIndex)
  end,
  CollectionReward_ScrollGrid_Stage_Group_Item_StaticGrid_Rewareds_Group_Rewards_Group_CommonItem_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    if itemId then
      CommonTips.OpenRewardDetail(itemId)
    end
  end,
  CollectionReward_ScrollGrid_Stage_Group_Item_Btn_Claim_Click = function(btn, str)
  end
}
return ViewFunction
