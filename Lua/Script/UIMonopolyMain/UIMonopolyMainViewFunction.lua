local View = require("UIMonopolyMain/UIMonopolyMainView")
local DataModel = require("UIMonopolyMain/UIMonopolyMainDataModel")
local Manager = require("UIMonopolyMain/UIMonopolyMainManager")
local ViewFunction = {
  MonopolyMain_Group_Main_Btn_Play_Click = function(btn, str)
    Manager.OnPlayBtnClick()
  end,
  MonopolyMain_Group_Main_Btn_Gacha_Click = function(btn, str)
    local viewType = 1
    local activityCA = PlayerData:GetFactoryData(86000020, "ActivityFactory")
    if activityCA and activityCA.bannerCapsuleList and #activityCA.bannerCapsuleList > 0 then
      viewType = activityCA.bannerCapsuleList[1]
    end
    local t = {}
    t.viewType = viewType
    UIManager:Open("UI/Home/HomeCapsule", Json.encode(activityCA.bannerCapsuleList))
  end,
  MonopolyMain_Group_Main_Btn_Join_Click = function(btn, str)
    Manager.OnJoinBtnClick()
  end,
  MonopolyMain_Group_JoinTicket_Group_Much_ScrollGrid_List_SetGrid = function(element, elementIndex)
    Manager.RefreshJoinTicketElement(element, elementIndex)
  end,
  MonopolyMain_Group_JoinTicket_Group_Much_ScrollGrid_List_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreItemTips({itemId = itemId})
  end,
  MonopolyMain_Group_JoinTicket_Group_Few_StaticGrid_List_SetGrid = function(element, elementIndex)
    Manager.RefreshJoinTicketElement(element, elementIndex)
  end,
  MonopolyMain_Group_JoinTicket_Group_Few_StaticGrid_List_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreItemTips({itemId = itemId})
  end,
  MonopolyMain_Group_JoinTicket_Group_Much_Img_BG_Btn_Cancel_Click = function(btn, str)
    View.Group_JoinTicket:SetActive(false)
  end,
  MonopolyMain_Group_JoinTicket_Group_Much_Img_BG_Btn_Ok_Click = function(btn, str)
    Net:SendProto("monopoly.sign_up", function(json)
      if string.nilorempty(json.rc) then
        View.Group_JoinTicket:SetActive(false)
        PlayerData.SetMonopolyCurrentSign(1)
        Manager.RefreshJoinAndPlayBtnShow()
      end
    end, 1)
  end,
  MonopolyMain_Group_JoinTicket_Group_Few_Btn_Ok_Click = function(btn, str)
    Net:SendProto("monopoly.sign_up", function(json)
      if string.nilorempty(json.rc) then
        View.Group_JoinTicket:SetActive(false)
        PlayerData.SetMonopolyCurrentSign(1)
        PlayerData.SetMonopolySignMpy(1)
        Manager.RefreshJoinAndPlayBtnShow()
        CommonTips.OpenTips(80601249)
      end
    end, 1)
  end,
  MonopolyMain_Group_JoinTicket_Group_Few_Btn_Cancel_Click = function(btn, str)
    View.Group_JoinTicket:SetActive(false)
  end,
  MonopolyMain_Group_RankRewards_Group_RankList_ScrollGrid_RankList_SetGrid = function(element, elementIndex)
    Manager.RefreshRankElement(element, elementIndex)
  end,
  MonopolyMain_Group_RankRewards_Group_RankList_ScrollGrid_RankList_Group_Item_StaticGrid_Reward_SetGrid = function(element, elementIndex)
    Manager.RefreshRewardElement(element, elementIndex)
  end,
  MonopolyMain_Group_RankRewards_Group_RankList_ScrollGrid_RankList_Group_Item_StaticGrid_Reward_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenRewardDetail(itemId, nil, true)
  end,
  MonopolyMain_Group_Main_Group_TopRight_Btn_Card_Click = function(btn, str)
    local activityCA = PlayerData:GetFactoryData(86000020, "ActivityFactory")
    if not activityCA then
      return
    end
    local cardPackId = activityCA.activityCardPack or -1
    if cardPackId == -1 then
      return
    end
    local activityName = activityCA.name
    
    local function callBack()
    end
    
    UIManager:Open("UI/CollectionCard/CardPack_Open", Json.encode({cardPackId = cardPackId, activityName = activityName}), callBack)
  end,
  MonopolyMain_Group_Main_Group_TopRight_Btn_LV_Click = function(btn, str)
    local isSignMpy = PlayerData.ServerData.user_monopoly.sign_mpy == 1
    local isEndMpy = PlayerData.GetMonopolyIsEnd()
    if not isSignMpy and not isEndMpy then
      CommonTips.OpenTips(80609949)
      return
    end
    local mapId = PlayerData.GetUserMonopolyId() or 0
    if mapId ~= 0 then
      UIManager:Open("UI/Monopoly/UI/Grade/MonopolyGrade", Json.encode({isOpenByMap = false}))
    end
  end,
  MonopolyMain_Group_Main_Btn_Rank_Click = function(btn, str)
    Manager.OpenRankRewardPanel(0)
  end,
  MonopolyMain_Group_Schedule_Btn_Close_Click = function(btn, str)
    View.Group_Schedule:SetActive(false)
  end,
  MonopolyMain_Group_Schedule_Img_BG_ScrollGrid_PK_SetGrid = function(element, elementIndex)
    Manager.RefreshScheduleElement(element, elementIndex)
  end,
  MonopolyMain_Group_Main_Btn_Logo_Click = function(btn, str)
    UIManager:Open("UI/Monopoly/UI/Help/Group_Help", Json.encode({helpId = 80305471}))
  end,
  MonopolyMain_Group_SignUPTip_Btn_Close_Click = function(btn, str)
    if Manager.signUpCo then
      View.self:StopC(Manager.signUpCo)
      Manager.signUpCo = nil
    end
    View.Group_SignUPTip:SetActive(false)
  end,
  MonopolyMain_Group_RankRewards_Btn_Close_Click = function(btn, str)
    View.Group_RankRewards:SetActive(false)
  end
}
return ViewFunction
