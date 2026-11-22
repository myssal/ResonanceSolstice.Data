local BtnItem = require("Common/BtnItem")
local View = require("UIMonopolyMain/UIMonopolyMainView")
local CardPackDataModel = require("UICardPack_Open/UICardPack_OpenDataModel")
local DataModel = require("UIMonopolyMain/UIMonopolyMainDataModel")
local UIMonopolyMainManager = {
  rankRewardList = {},
  joinTicket = {},
  scheduleList = {},
  signUpCo = nil,
  activityId = 86000020
}

function UIMonopolyMainManager.Init()
  UIMonopolyMainManager.ReqMpyInfo()
end

function UIMonopolyMainManager.ReqMpyInfo()
  Net:SendProto("monopoly.mpy_refresh", function(json)
    if json and string.nilorempty(json.rc) then
      PlayerData.SetUserMonopolyData(json.user_monopoly)
      print("***\229\136\183\230\150\176\231\149\140\233\157\162")
      UIMonopolyMainManager.RefreshUI()
    end
  end)
end

function UIMonopolyMainManager.RefreshUI()
  UIMonopolyMainManager.RefreshCardPoolShow()
  UIMonopolyMainManager.RefreshStartTimeShow()
  UIMonopolyMainManager.RefreshJoinAndPlayBtnShow()
  UIMonopolyMainManager.RefreshMonopolyLv()
  if PlayerData.GetUserMonopolyRankRec() == 0 then
    UIMonopolyMainManager.OpenRankRewardPanel(1)
  end
  View.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForSeconds(0.5))
    View.SpineAnimation_Main:SetAction("idle", true)
  end))
  View.Group_Main.Btn_Logo.Img_Logo:SetSprite(GetResPath(88300163))
end

function UIMonopolyMainManager.RefreshCardPoolShow()
  View.Group_Main.Group_TopRight.Btn_Card:SetActive(false)
  local activityCA = PlayerData:GetFactoryData(UIMonopolyMainManager.activityId, "ActivityFactory")
  if not activityCA or activityCA.activityCardPack == -1 then
    return
  end
  local cardPackInfo = CardPackDataModel.GetCardPackInfo(activityCA.activityCardPack)
  if not cardPackInfo then
    return
  end
  View.Group_Main.Group_TopRight.Btn_Card:SetActive(true)
  View.Group_Main.Group_TopRight.Btn_Card.Group_Num.Txt_OwnNum:SetText(tostring(cardPackInfo.ownCount))
  View.Group_Main.Group_TopRight.Btn_Card.Group_Num.Txt_1:SetText("/" .. tostring(cardPackInfo.allCount))
end

function UIMonopolyMainManager.RefreshStartTimeShow()
  local activityCA = PlayerData:GetFactoryData(UIMonopolyMainManager.activityId, "ActivityFactory")
  if not activityCA then
    return
  end
  local startTime = activityCA.startTime
  local endTime = activityCA.endTime
  local startMonth = string.sub(startTime, 6, 7) or 0
  local startDay = string.sub(startTime, 9, 10) or 0
  local startHour = string.sub(startTime, 12, 13) or 0
  local startMin = string.sub(startTime, 15, 16) or 0
  local endMonth = string.sub(endTime, 6, 7) or 0
  local endDay = string.sub(endTime, 9, 10) or 0
  local endHour = string.sub(startTime, 12, 13) or 0
  local endMin = string.sub(startTime, 15, 16) or 0
  View.Group_Main.Btn_Logo.Img_Time.Txt_Time:SetText(startMonth .. "/" .. startDay .. " " .. startHour .. ":" .. startMin .. "--" .. endMonth .. "/" .. endDay .. " " .. endHour .. ":" .. endMin)
end

function UIMonopolyMainManager.RefreshMonopolyLv()
  local lv = PlayerData.GetUserMonopolyLv() or 1
  View.Group_Main.Group_TopRight.Btn_LV.Group_LV.Txt_Num:SetText(tostring(lv))
  local isHasRed = DataModel.GetIsHasCanGetReward()
  View.Group_Main.Group_TopRight.Btn_LV.Group_RedPoint:SetActive(isHasRed)
end

function UIMonopolyMainManager.OpenRankRewardPanel(nType)
  UIMonopolyMainManager.rankRewardList = {}
  View.Group_RankRewards:SetActive(true)
  Net:SendProto("monopoly.monopoly_rank_reward", function(json)
    if json and string.nilorempty(json.rc) then
      PlayerData.SetUserMonopolyRankRec(1)
      if json.rr_info and table.count(json.rr_info) > 0 then
        for gridId, v in pairs(json.rr_info) do
          local t = {}
          t.gridId = gridId
          t.rank = v.rank
          t.reward = v.reward
          table.insert(UIMonopolyMainManager.rankRewardList, t)
        end
      end
      if 0 < table.count(UIMonopolyMainManager.rankRewardList) then
        View.Group_RankRewards.Group_RankList.Group_Empty:SetActive(false)
        View.Group_RankRewards.Group_RankList.ScrollGrid_RankList.grid.self.gameObject:SetActive(true)
        View.Group_RankRewards.Group_RankList.ScrollGrid_RankList.grid.self:SetDataCount(#UIMonopolyMainManager.rankRewardList)
        View.Group_RankRewards.Group_RankList.ScrollGrid_RankList.grid.self:RefreshAllElement()
        if json.reward and 0 < table.count(json.reward) then
          UIManager:Open("UI/Monopoly/UI/ShowItem/MonopolyShowItem", Json.encode({
            rewards = json.reward,
            title = nil,
            ignoreCloseTime = true
          }), nil)
        end
      else
        View.Group_RankRewards.Group_RankList.Group_Empty:SetActive(true)
        View.Group_RankRewards.Group_RankList.ScrollGrid_RankList.grid.self.gameObject:SetActive(false)
      end
    end
  end, nType)
end

function UIMonopolyMainManager.RefreshRankElement(element, elementIndex)
  if element == nil then
    return
  end
  local info = UIMonopolyMainManager.rankRewardList[elementIndex]
  if not info then
    return
  end
  element.Img_No1:SetActive(info.rank == 1)
  element.Img_No2:SetActive(info.rank == 2)
  element.Img_No3:SetActive(info.rank == 3)
  element.Img_No4:SetActive(info.rank > 3)
  if info.rank > 3 then
    element.Img_No4.Txt_Num:SetText(tostring(info.rank))
  end
  local gridInfo = PlayerData:GetFactoryData(info.gridId, "MonopolyGameGridFactory")
  if not gridInfo then
    return
  end
  element.Txt_Name:SetText(gridInfo.name)
  local rewardList = info.reward or {}
  element.StaticGrid_Reward.grid.self:SetParentParam(elementIndex)
  element.StaticGrid_Reward.grid.self:SetDataCount(#rewardList)
  element.StaticGrid_Reward.grid.self:RefreshAllElement()
  element.Group_Head.Img_ProfilePhoto.Img_Head:SetSprite(gridInfo.gridImg)
end

function UIMonopolyMainManager.RefreshRewardElement(element, elementIndex)
  local index = tonumber(element.ParentParam)
  local info = UIMonopolyMainManager.rankRewardList[index]
  if not info then
    return
  end
  local rankDailyList = info.reward or {}
  if rankDailyList[elementIndex] then
    BtnItem:SetItem(element, {
      id = rankDailyList[elementIndex].id,
      num = rankDailyList[elementIndex].num
    })
    element.Btn_Item:SetClickParam(rankDailyList[elementIndex].id)
  end
end

function UIMonopolyMainManager.OpenJoinTicketPanel()
  local monopolyInfo = PlayerData:GetFactoryData(PlayerData.GetMonopolyControlId(), "MapControlFactory")
  if not monopolyInfo then
    return
  end
  View.Group_JoinTicket:SetActive(true)
  UIMonopolyMainManager.joinTicket = monopolyInfo.joinTicket or {}
  local count = #UIMonopolyMainManager.joinTicket
  if count <= 7 then
    View.Group_JoinTicket.Group_Few:SetActive(true)
    View.Group_JoinTicket.Group_Much:SetActive(false)
    View.Group_JoinTicket.Group_Few.StaticGrid_List.grid.self:SetDataCount(#UIMonopolyMainManager.joinTicket)
    View.Group_JoinTicket.Group_Few.StaticGrid_List.grid.self:RefreshAllElement()
  else
    View.Group_JoinTicket.Group_Few:SetActive(false)
    View.Group_JoinTicket.Group_Much:SetActive(true)
    View.Group_JoinTicket.Group_Much.ScrollGrid_List.grid.self:SetDataCount(#UIMonopolyMainManager.joinTicket)
    View.Group_JoinTicket.Group_Much.ScrollGrid_List.grid.self:RefreshAllElement()
  end
end

function UIMonopolyMainManager.RefreshJoinTicketElement(element, elementIndex)
  local info = UIMonopolyMainManager.joinTicket[elementIndex]
  if not info then
    return
  end
  BtnItem:SetItem(element, {
    id = UIMonopolyMainManager.joinTicket[elementIndex].id,
    num = UIMonopolyMainManager.joinTicket[elementIndex].num
  })
  element.Btn_Item:SetClickParam(UIMonopolyMainManager.joinTicket[elementIndex].id)
end

function UIMonopolyMainManager.RefreshJoinAndPlayBtnShow()
  local ca = PlayerData:GetFactoryData(PlayerData.GetUserMonopolyId(), "MonopolyGameMapFactory")
  if not ca then
    View.Group_Main.Btn_Join:SetActive(false)
    View.Group_Main.Btn_Play:SetActive(false)
    return
  end
  local mpyEndTime = TimeUtil:TimeStamp(ca.endTime)
  local signEndStr = PlayerData.GetMonopolySignEnd() or ""
  local signEndTime = TimeUtil:TimeStamp(signEndStr) or 0
  if mpyEndTime < signEndTime then
    View.Group_Main.Btn_Join:SetActive(false)
    return
  end
  local timeNow = TimeUtil:GetServerTimeStamp() or 0
  local signStartStr = PlayerData.GetMonopolySignStart()
  local signStartTime = TimeUtil:TimeStamp(signStartStr) or 0
  local isSignNext = PlayerData.GetMonopolyNextSign()
  local endMonth = string.sub(signEndStr, 6, 7)
  local endDay = string.sub(signEndStr, 9, 10)
  local endHour = string.sub(signEndStr, 12, 13)
  local endMin = string.sub(signEndStr, 15, 16)
  if isSignNext then
    View.Group_Main.Btn_Join.Img_Joined:SetActive(true)
    View.Group_Main.Btn_Join.Img_Join:SetActive(false)
    View.Group_Main.Btn_Join.Img_Stop:SetActive(false)
    View.Group_Main.Btn_Join.Group_Time:SetActive(false)
    View.Group_Main.Btn_Join.Txt_Check:SetActive(true)
  elseif timeNow >= signStartTime and signEndTime > timeNow then
    if string.nilorempty(signStartStr) then
      View.Group_Main.Btn_Join.Img_Joined:SetActive(false)
      View.Group_Main.Btn_Join.Img_Join:SetActive(false)
      View.Group_Main.Btn_Join.Img_Stop:SetActive(true)
      View.Group_Main.Btn_Join.Group_Time:SetActive(false)
      View.Group_Main.Btn_Join.Txt_Check:SetActive(true)
    else
      View.Group_Main.Btn_Join.Img_Joined:SetActive(false)
      View.Group_Main.Btn_Join.Img_Join:SetActive(true)
      View.Group_Main.Btn_Join.Img_Stop:SetActive(false)
      View.Group_Main.Btn_Join.Group_Time:SetActive(true)
      View.Group_Main.Btn_Join.Group_Time.Txt_Day:SetText(endMonth .. "/" .. endDay)
      View.Group_Main.Btn_Join.Txt_Check:SetActive(false)
    end
  elseif string.nilorempty(signStartStr) then
    View.Group_Main.Btn_Join:SetActive(false)
  else
    View.Group_Main.Btn_Join.Img_Joined:SetActive(false)
    View.Group_Main.Btn_Join.Img_Join:SetActive(false)
    View.Group_Main.Btn_Join.Img_Stop:SetActive(true)
    View.Group_Main.Btn_Join.Group_Time:SetActive(false)
    View.Group_Main.Btn_Join.Txt_Check:SetActive(true)
  end
  local ju = PlayerData.GetUserMonopolyPeriodTime()
  if ju <= 0 then
    ju = 1
  elseif ju > #ca.scheduleList then
    ju = #ca.scheduleList
  end
  local scheduleList = ca.scheduleList or {}
  local info = scheduleList[ju]
  local gameStartTime = TimeUtil:TimeStamp(info.gameStart .. ":00")
  if timeNow >= gameStartTime and signEndTime > timeNow then
    local isSignCur = PlayerData.GetMonopolyCurrentSign()
    if isSignCur then
      View.Group_Main.Btn_Play.Group_TXT.Img_Title.Txt_Title:SetText(GetText(80608038))
      View.Group_Main.Btn_Play.Img_NumableMask:SetActive(false)
    else
      View.Group_Main.Btn_Play.Group_TXT.Img_Title.Txt_Title:SetText(GetText(80609913))
      View.Group_Main.Btn_Play.Img_NumableMask:SetActive(true)
    end
    View.Group_Main.Btn_Play.Group_TXT.Img_Time.Txt_Day:SetText(endMonth .. "/" .. endDay .. " " .. endHour .. ":" .. endMin)
  elseif mpyEndTime <= timeNow then
    View.Group_Main.Btn_Play:SetActive(false)
  else
    View.Group_Main.Btn_Play.Img_NumableMask:SetActive(true)
    View.Group_Main.Btn_Play.Group_TXT.Img_Title.Txt_Title:SetText(GetText(80609912))
    View.Group_Main.Btn_Play.Group_TXT.Img_Time.Txt_Day:SetText(info.gameStart)
  end
end

function UIMonopolyMainManager.OnJoinBtnClick()
  local monopolyInfo = PlayerData:GetFactoryData(PlayerData.GetMonopolyControlId(), "MapControlFactory")
  if not monopolyInfo then
    return
  end
  local roleLv = PlayerData:GetUserInfo().lv or 1
  if roleLv < monopolyInfo.gameMinLV then
    CommonTips.OpenTips(string.format(GetText(80609909), monopolyInfo.gameMinLV))
    return
  end
  local timeNow = TimeUtil:GetServerTimeStamp() or 0
  local signStartTime = TimeUtil:TimeStamp(PlayerData.GetMonopolySignStart()) or 0
  local signEndTime = TimeUtil:TimeStamp(PlayerData.GetMonopolySignEnd()) or 0
  if timeNow >= signStartTime and timeNow < signEndTime then
    local isSignNext = PlayerData.GetMonopolyNextSign()
    if isSignNext then
      UIMonopolyMainManager.OpenSchedule()
    else
      Net:SendProto("monopoly.sign_up", function(json)
        if string.nilorempty(json.rc) then
          PlayerData.SetMonopolyNextSign(1)
          UIMonopolyMainManager.RefreshJoinAndPlayBtnShow()
          View.Group_SignUPTip:SetActive(true)
          local ca = PlayerData:GetFactoryData(PlayerData.GetUserMonopolyId(), "MonopolyGameMapFactory")
          if ca then
            local ju = PlayerData.GetUserMonopolyPeriodTime()
            ju = ju + 1
            if ju > #ca.scheduleList then
              ju = #ca.scheduleList
            end
            local scheduleList = ca.scheduleList
            local info = scheduleList[ju]
            View.Group_SignUPTip.Img_BG.Txt_Time:SetText(string.format(GetText(80609935), info.gameStart))
          else
            View.Group_SignUPTip.Img_BG.Txt_Time:SetActive(false)
          end
          UIMonopolyMainManager.signUpCo = View.self:StartC(LuaUtil.cs_generator(function()
            coroutine.yield(CS.UnityEngine.WaitForSeconds(5))
            View.Group_SignUPTip:SetActive(false)
          end))
        end
      end, 0)
    end
  else
    UIMonopolyMainManager.OpenSchedule()
  end
end

function UIMonopolyMainManager.OpenSchedule()
  local ca = PlayerData:GetFactoryData(PlayerData.GetUserMonopolyId(), "MonopolyGameMapFactory")
  if not ca then
    return
  end
  View.Group_Schedule:SetActive(true)
  local activityCA = PlayerData:GetFactoryData(UIMonopolyMainManager.activityId, "ActivityFactory")
  if activityCA then
    View.Group_Schedule.Img_BG.Img_Title.Txt_StartTime:SetText(activityCA.startTime)
    View.Group_Schedule.Img_BG.Img_Title.Txt_EndTime:SetText(activityCA.endTime)
  end
  UIMonopolyMainManager.scheduleList = ca.scheduleList or {}
  View.Group_Schedule.Img_BG.ScrollGrid_PK.grid.self:SetDataCount(#ca.scheduleList)
  View.Group_Schedule.Img_BG.ScrollGrid_PK.grid.self:RefreshAllElement()
end

function UIMonopolyMainManager.RefreshScheduleElement(element, elementIndex)
  local info = UIMonopolyMainManager.scheduleList[elementIndex]
  if not info then
    return
  end
  element.Txt_Turn:SetText(string.format(GetText(80609926), tostring(elementIndex)))
  element.Group_SignUP.Group_Start.Txt_Time:SetText(string.sub(info.signStart, 6))
  element.Group_SignUP.Group_End.Txt_Time:SetText(string.sub(info.signEnd, 6))
  element.Group_Game.Group_Start.Txt_Time:SetText(string.sub(info.gameStart, 6))
  element.Group_Game.Group_End.Txt_Time:SetText(string.sub(info.gameEnd, 6))
end

function UIMonopolyMainManager.OnPlayBtnClick()
  local monopolyInfo = PlayerData:GetFactoryData(PlayerData.GetMonopolyControlId(), "MapControlFactory")
  if not monopolyInfo then
    return
  end
  local roleLv = PlayerData:GetUserInfo().lv or 1
  if roleLv < monopolyInfo.gameMinLV then
    CommonTips.OpenTips(string.format(GetText(80609909), monopolyInfo.gameMinLV))
    return
  end
  local ca = PlayerData:GetFactoryData(PlayerData.GetUserMonopolyId(), "MonopolyGameMapFactory")
  if not ca then
    return
  end
  local timeNow = TimeUtil:GetServerTimeStamp() or 0
  local signEndTime = TimeUtil:TimeStamp(PlayerData.GetMonopolySignEnd()) or 0
  local ju = PlayerData.GetUserMonopolyPeriodTime()
  if ju <= 0 then
    ju = 1
  elseif ju > #ca.scheduleList then
    ju = #ca.scheduleList
  end
  local scheduleList = ca.scheduleList
  local info = scheduleList[ju]
  local gameStartTime = TimeUtil:TimeStamp(info.gameStart .. ":00")
  if timeNow >= gameStartTime and timeNow < signEndTime then
    local isSignCur = PlayerData.GetMonopolyCurrentSign()
    if isSignCur then
      LoadingManager:OpenLoading("UI/Monopoly/UI/Loading/MonopolyLoading", nil, function()
        if MainManager.bgSceneName == "Monopoly" then
          LoadingManager.loadingPercent = 1
          UIManager:Open("UI/Monopoly/Monopoly")
          return
        else
          CBus:ChangeScene("Monopoly")
        end
      end)
    else
      UIMonopolyMainManager.OpenJoinTicketPanel()
    end
  else
    CommonTips.OpenTips(80609489)
  end
end

return UIMonopolyMainManager
