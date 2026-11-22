local View = require("UIWitchesRanking/UIWitchesRankingView")
local DataModel = require("UIWitchesRanking/UIWitchesRankingDataModel")
local Controller = require("UIWitchesRanking/UIWitchesRankingController")
local ViewFunction = {
  WitchesRanking_Group_RankRewards_Group_RankList_ScrollGrid_RankList_SetGrid = function(element, elementIndex)
    if DataModel.CurTab == 1 then
      Controller:SetRankElement(element, elementIndex)
    elseif DataModel.CurTab == 2 then
      local rankData = DataModel.serverRankList[elementIndex]
      if not rankData then
        if DataModel.serveRankCacheInfo.has_more then
          DataModel.serveRankCacheInfo.has_more = false
          Controller.RollGetServerRankData()
        end
      else
        Controller:SetRankElement(element, elementIndex)
      end
    end
  end,
  WitchesRanking_Group_RankRewards_Group_RankList_ScrollGrid_RankList_Group_Item_Group_Likes_Group_Unlike_Btn__Click = function(btn, str)
    if PlayerData.IsGiveLikeMax() then
      CommonTips.OpenTips(80609371)
      return
    end
    local rankList = DataModel.GetRankList()
    local rankData = rankList[tonumber(str)]
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
  WitchesRanking_Group_RankRewards_Group_Tab_Btn_Day_Click = function(btn, str)
    Controller:SelectTab(1)
  end,
  WitchesRanking_Group_RankRewards_Group_Tab_Btn_All_Click = function(btn, str)
    Controller:SelectTab(2)
  end,
  WitchesRanking_Group_RankRewards_Group_LikesNum_Btn__Click = function(btn, str)
    CommonTips.OpenRankGiveLikeTips()
  end,
  WitchesRanking_Group_RankRewards_Group_Reward_Group_Reward_StaticGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:SetRewardElement(element, elementIndex)
  end,
  WitchesRanking_Group_RankRewards_Group_Reward_Group_Reward_StaticGrid_Reward_Group_Reward_Btn_Item_Click = function(btn, str)
    CommonTips.OpenRewardDetail(tonumber(str))
  end,
  WitchesRanking_Group_RankRewards_Group_RankList_ScrollGrid_RankList_Group_Item_StaticGrid_Seal_SetGrid = function(element, elementIndex)
    Controller:SetSealElement(element, elementIndex)
  end,
  WitchesRanking_Group_RankRewards_Group_RankList_Group_Self_StaticGrid_Seal_SetGrid = function(element, elementIndex)
    Controller:SetSealElement(element, elementIndex)
  end,
  WitchesRanking_Group_RankRewards_Group_RankList_ScrollGrid_RankList_Group_Item_Group_Head_Btn_Click_Click = function(btn, str)
    UIManager:Open("UI/Friends/Friends", Json.encode({uid = str}))
  end,
  WitchesRanking_Group_RankRewards_Group_RankList_ScrollGrid_RankList_Group_Item_StaticGrid_Team_SetGrid = function(element, elementIndex)
    Controller:SetTeamElement(element, elementIndex)
  end,
  WitchesRanking_Group_RankRewards_Group_RankList_Group_Self_Group_Head_Btn_Click_Click = function(btn, str)
  end,
  WitchesRanking_Group_RankRewards_Group_RankList_Group_Self_StaticGrid_Team_SetGrid = function(element, elementIndex)
    Controller:SetTeamElement(element, elementIndex)
  end,
  WitchesRanking_Btn_Close_Click = function(btn, str)
    UIManager:GoBack()
  end
}
return ViewFunction
