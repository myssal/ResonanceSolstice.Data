local View = require("UIActivitySignBattleRanking/UIActivitySignBattleRankingView")
local DataModel = require("UIActivitySignBattleRanking/UIActivitySignBattleRankingDataModel")
local Controller = require("UIActivitySignBattleRanking/UIActivitySignBattleRankingController")
local ViewFunction = {
  ActivitySignBattleRanking_Btn_Close_Click = function(btn, str)
    UIManager:GoBack()
  end,
  ActivitySignBattleRanking_Group_RankRewards_Group_RankList_ScrollGrid_RankList_SetGrid = function(element, elementIndex)
    Controller:SetRankElement(element, elementIndex)
  end,
  ActivitySignBattleRanking_Group_RankRewards_Group_RankList_ScrollGrid_RankList_Group_Item_Group_Head_Btn_Click_Click = function(btn, str)
    UIManager:Open("UI/Friends/Friends", Json.encode({uid = str}))
  end,
  ActivitySignBattleRanking_Group_RankRewards_Group_RankList_ScrollGrid_RankList_Group_Item_Group_Likes_Group_Unlike_Btn__Click = function(btn, str)
    if PlayerData.IsGiveLikeMax() then
      CommonTips.OpenTips(80609371)
      return
    end
    local rankData = DataModel.CurDetailInfo[tonumber(str)]
    if rankData then
      local function callBack(json)
        rankData.being_like_count = rankData.being_like_count + 1
        
        rankData.being_like_count = math.floor(rankData.being_like_count)
        local element = DataModel.rankElements[tonumber(str)]
        if element then
          element.Group_Likes.Group_Unlike:SetActive(false)
          element.Group_Likes.Group_Liked:SetActive(true)
          element.Group_Likes.Group_Liked.Group_Likes_effect_blue:SetActive(false)
          element.Group_Likes.Group_Liked.Group_Likes_effect_blue:SetActive(true)
          element.Group_Likes:SetEnableAnimator(true)
          element.Group_Likes.transform:GetComponent(typeof(CS.UIAnimator)):SetCallBack(function()
            if json.reward then
              CommonTips.OpenShowItem(json.reward)
            end
          end)
          element.Group_Likes.transform:GetComponent(typeof(CS.UIAnimator)).animator:Play("Group_Likes", 0, 0)
          element.Img_LikesNum.Txt_:SetText(rankData.being_like_count)
        end
        Controller.RefreshGiveLike()
        DataModel.giveLiveC = View.self:StartC(LuaUtil.cs_generator(function()
          coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
        end))
      end
      
      PlayerData.GiveLive(rankData.uid, EnumDefine.GiveLikeType.Revenue, callBack)
    end
  end,
  ActivitySignBattleRanking_Group_RankRewards_Group_RankList_ScrollGrid_RankList_Group_Item_StaticGrid_Seal_SetGrid = function(element, elementIndex)
  end,
  ActivitySignBattleRanking_Group_RankRewards_Group_RankList_ScrollGrid_RankList_Group_Item_StaticGrid_Team_SetGrid = function(element, elementIndex)
    Controller:SetTeamElement(element, elementIndex)
  end,
  ActivitySignBattleRanking_Group_RankRewards_Group_RankList_Group_Self_Group_Head_Btn_Click_Click = function(btn, str)
  end,
  ActivitySignBattleRanking_Group_RankRewards_Group_RankList_Group_Self_StaticGrid_Seal_SetGrid = function(element, elementIndex)
  end,
  ActivitySignBattleRanking_Group_RankRewards_Group_RankList_Group_Self_StaticGrid_Team_SetGrid = function(element, elementIndex)
    Controller:SetTeamElement(element, elementIndex)
  end,
  ActivitySignBattleRanking_Group_RankRewards_Group_Tab_Btn_Day_Click = function(btn, str)
    Controller:SelectTab(1)
  end,
  ActivitySignBattleRanking_Group_RankRewards_Group_Tab_Btn_All_Click = function(btn, str)
    Controller:SelectTab(2)
  end,
  ActivitySignBattleRanking_Group_RankRewards_Group_LikesNum_Btn__Click = function(btn, str)
    CommonTips.OpenRankGiveLikeTips()
  end,
  ActivitySignBattleRanking_Group_RankRewards_Group_Reward_Group_Reward_StaticGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:SetRewardElement(element, elementIndex)
  end,
  ActivitySignBattleRanking_Group_RankRewards_Group_Reward_Group_Reward_StaticGrid_Reward_Group_Reward_Btn_Item_Click = function(btn, str)
    CommonTips.OpenRewardDetail(tonumber(str))
  end
}
return ViewFunction
