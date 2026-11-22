local View = require("UIInvestmentRankList/UIInvestmentRankListView")
local DataModel = require("UIInvestmentRankList/UIInvestmentRankListDataModel")
local Controller = require("UIInvestmentRankList/UIInvestmentRankListController")
local ViewFunction = {
  InvestmentRankList_Btn_BG_Click = function(btn, str)
    UIManager:GoBack()
  end,
  InvestmentRankList_Group_Tab_ScrollGrid_Tab_SetGrid = function(element, elementIndex)
    Controller:RefreshTabElement(element, elementIndex)
  end,
  InvestmentRankList_Group_Tab_ScrollGrid_Tab_Group_Item_Btn__Click = function(btn, str)
    Controller:TabElementClick(btn, str)
  end,
  InvestmentRankList_Group_Rank_Group_List_ScrollGrid_List_SetGrid = function(element, elementIndex)
    Controller:RefreshRankElement(element, elementIndex)
  end,
  InvestmentRankList_Group_Rank_Group_List_ScrollGrid_List_Group_Item_Btn_ProfilePhoto_Click = function(btn, str)
    Controller:ProfilePhotoClick(btn, str)
  end,
  InvestmentRankList_Group_Rank_Group_List_ScrollGrid_List_Group_Item_Group_Likes_Group_Unlike_Btn__Click = function(btn, str)
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
          element.Group_Likes.Group_Liked.Group_Likes_effect:SetActive(false)
          element.Group_Likes.Group_Liked.Group_Likes_effect:SetActive(true)
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
  InvestmentRankList_Group_Rank_Group_List_Group_Oneself_Btn_ProfilePhoto_Click = function(btn, str)
    Controller:ProfilePhotoClick(btn, str)
  end,
  InvestmentRankList_Group_Rank_Group_Top_Group_LikesNum_Btn__Click = function(btn, str)
    CommonTips.OpenRankGiveLikeTips()
  end,
  InvestmentRankList_Group_Rank_Group_Top_Group_Section_Btn_Click_Click = function(btn, str)
    Controller:ShowRankLvToggleArea(true)
  end,
  InvestmentRankList_Group_Rank_Group_Top_Group_Select_Group_Total_Btn__Click = function(btn, str)
    Controller:SelectTab(DataModel.CurTabIndex, DataModel.TimeType.forever, DataModel.CurRankLvIdx)
  end,
  InvestmentRankList_Group_Rank_Group_Top_Group_Select_Group_Month_Btn__Click = function(btn, str)
    Controller:SelectTab(DataModel.CurTabIndex, DataModel.TimeType.monthly, DataModel.CurRankLvIdx)
  end,
  InvestmentRankList_Group_Rank_Group_Top_Group_Select_Group_Week_Btn__Click = function(btn, str)
    Controller:SelectTab(DataModel.CurTabIndex, DataModel.TimeType.weekly, DataModel.CurRankLvIdx)
  end,
  InvestmentRankList_Group_Rank_Group_Top_Group_Select_Group_Day_Btn__Click = function(btn, str)
    Controller:SelectTab(DataModel.CurTabIndex, DataModel.TimeType.daily, DataModel.CurRankLvIdx)
  end,
  InvestmentRankList_Group_Rank_Group_Top_Btn_CloseToggleArea_Click = function(btn, str)
    Controller:ShowRankLvToggleArea(false)
  end,
  InvestmentRankList_Group_Rank_Group_Top_Group_ToggleArea_Group_Toggle_Btn_Click_Click = function(btn, str)
    Controller:ShowRankLvToggleArea(true)
  end,
  InvestmentRankList_Group_Rank_Group_Top_Group_ToggleArea_StaticGrid_Toggle_SetGrid = function(element, elementIndex)
    Controller:RefreshLvToggleElement(element, elementIndex)
  end,
  InvestmentRankList_Group_Rank_Group_Top_Group_ToggleArea_StaticGrid_Toggle_Group_Toggle_Btn_Click_Click = function(btn, str)
    Controller:ClickLvToggle(str)
  end,
  InvestmentRankList_Group_Tips_Btn_Close_Click = function(btn, str)
    View.Group_Tips:SetActive(false)
  end,
  InvestmentRankList_Group_Rank_Group_Top_Group_Select_Btn_Buff_Click = function(btn, str)
    if View.Group_BuffTips.gameObject.activeSelf == false then
      View.Btn_CloseBuffTips:SetActive(true)
      Controller:ShowBuffPanel()
    else
      View.Group_BuffTips:SetActive(false)
      View.Btn_CloseBuffTips:SetActive(false)
    end
  end,
  InvestmentRankList_Btn_CloseBuffTips_Click = function(btn, str)
    View.Group_BuffTips:SetActive(false)
    View.Btn_CloseBuffTips:SetActive(false)
  end
}
return ViewFunction
