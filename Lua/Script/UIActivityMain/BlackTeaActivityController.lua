local Controller = {}
local personalView = require("UIPersonalProgress/UIPersonalProgressView")
local personalDataModel = require("UIPersonalProgress/UIPersonalProgressDataModel")
local serverView = require("UIServerProgress/UIServerProgressView")
local serverDataModel = require("UIServerProgress/UIServerProgressDataModel")
local buffView = require("UIBuffTips/UIBuffTipsView")
local buffDataModel = require("UIBuffTips/UIBuffTipsDataModel")
local achieveView = require("UIActivityAchievement/UIActivityAchievementView")
local achieveDataModel = require("UIActivityAchievement/UIActivityAchievementDataModel")

function Controller.RefreshPersonalStage()
  local num = personalDataModel.curNum
  personalView.Group_Left.Group_Sum.Txt_Num:SetText(NumThousandsSplit(num))
  personalDataModel.SortStage()
  personalView.Group_Right.ScrollGrid_ProgressList.grid.self:SetDataCount(#personalDataModel.allStage)
  personalView.Group_Right.ScrollGrid_ProgressList.grid.self:RefreshAllElement()
  personalView.Group_TopLeft.Btn_Server.Img_RedPoint:SetActive(serverDataModel.GetRedPointState())
end

function Controller.ClickReceivePersonalReward(questId)
  local function callBack(json)
    if json.reward then
      CommonTips.OpenShowItem(json.reward)
    end
    personalDataModel.SortStage()
    personalView.Group_Right.ScrollGrid_ProgressList.grid.self:SetDataCount(#personalDataModel.allStage)
    personalView.Group_Right.ScrollGrid_ProgressList.grid.self:RefreshAllElement()
  end
  
  Controller.ReceivePersonalReward(questId, callBack)
end

function Controller.ReceivePersonalReward(questId, callBack)
  local state = PlayerData.GetQuestState(questId)
  if state ~= EnumDefine.EQuestState.Finish then
    return
  end
  Net:SendProto("quest.recv_rewards", function(json)
    local serverData = PlayerData.ServerData.quests.activity_quests
    if serverData[tostring(questId)] then
      serverData[tostring(questId)].recv = TimeUtil:GetServerTimeStamp()
    end
    PlayerData.RefreshCardsData(json.reward)
    if callBack then
      callBack(json)
    end
  end, questId)
end

function Controller.RefreshServerStage()
  local curStageCfg = serverDataModel.curStageCfg
  local curStageIndex = serverDataModel.curStageIndex
  local num = serverDataModel.curNum
  serverView.Group_Left.Group_Sum.Txt_Num:SetText(NumThousandsSplit(num))
  local nextStage = serverDataModel.GetNextStageInfo()
  local max = not nextStage.cfg
  serverView.Group_Left.Group_ShowNum:SetActive(not max)
  if not max then
    local curStageNum = 0
    if 0 < curStageIndex then
      curStageNum = PlayerData:GetFactoryData(curStageCfg.id, "QuestFactory").num
    end
    serverView.Group_Left.Group_ShowNum.Group_Present.Txt_Num:SetText(NumThousandsSplit(curStageNum))
    local nextNum = PlayerData:GetFactoryData(nextStage.cfg.id, "QuestFactory").num
    serverView.Group_Left.Group_ShowNum.Group_Next.Group_Num.Txt_Num:SetText(NumThousandsSplit(nextNum))
    local ratio = string.format("%.3f", num / nextNum)
    serverView.Group_Left.Group_Bar.Img_Line:SetFilledImgAmount(0.1 + 0.8 * tonumber(ratio))
  else
    serverView.Group_Left.Group_Bar.Img_Line:SetFilledImgAmount(1)
  end
  serverDataModel.SortStage()
  serverView.Group_Right.ScrollGrid_ProgressList.grid.self:SetDataCount(#serverDataModel.allStage)
  serverView.Group_Right.ScrollGrid_ProgressList.grid.self:RefreshAllElement()
  serverView.Group_TopLeft.Btn_Personal.Img_RedPoint:SetActive(personalDataModel.GetRedPointState())
  serverView.Group_Left.Txt_Stage.Txt_Num:SetText(curStageIndex)
  serverView.Group_Left.Txt_Stage.Txt_Max:SetActive(max)
  local activityCfg = PlayerData:GetFactoryData(86000001, "ActivityFactory")
  local inTime = TimeUtil:IsActive(activityCfg.startTime, activityCfg.endTime)
  if activityCfg.isTriggerTime then
    local activityData = PlayerData:GetActivityData(86000001)
    local startTime = activityData.st
    if startTime then
      local time = startTime + activityCfg.buffContinueTime * 86400
      if 0 < activityCfg.continueTime then
        local endTime = PlayerData.ServerData.user_home_info.addTime + (activityCfg.putTime + activityCfg.continueTime) * 86400
        if time > endTime then
          time = endTime
        end
      end
      local remainTime = time - PlayerData:GetSeverTime()
      inTime = 0 < remainTime
      if inTime then
        local timeTxt = ""
        if 86400 <= remainTime then
          timeTxt = string.format(GetText(80609064), math.floor(remainTime / 86400))
        else
          timeTxt = string.format(GetText(80609067), math.floor(remainTime / 3600))
        end
        serverView.Group_Left.Group_Buff.Group_Time.Txt_Time:SetText(timeTxt)
      end
      serverView.Group_Left.Group_Buff.Group_Time:SetActive(inTime)
    else
      serverView.Group_Left.Group_Buff.Group_Time:SetActive(false)
    end
  else
    serverView.Group_Left.Group_Buff.Group_Time:SetActive(false)
  end
  local buyTxtNum = ""
  local buyColor = "#FFFFFF"
  local taxTxtNum = ""
  local taxColor = "#FFFFFF"
  if inTime then
    local buyNum = curStageCfg and curStageCfg.buyNum or 0
    local taxNum = curStageCfg and curStageCfg.revenueNum or 0
    buyTxtNum = 0 < buyNum and buyNum .. "%" or GetText(80602606)
    taxTxtNum = 0 < taxNum and taxNum .. "%" or GetText(80602606)
  else
    buyTxtNum = GetText(80609065)
    buyColor = "#9B9B9B"
    taxTxtNum = GetText(80609065)
    taxColor = "#9B9B9B"
  end
  serverView.Group_Left.Group_Buff.Group_Buy.Txt_Des:SetColor(buyColor)
  serverView.Group_Left.Group_Buff.Group_Buy.Txt_State:SetColor(buyColor)
  serverView.Group_Left.Group_Buff.Group_Buy.Txt_State:SetText(buyTxtNum)
  serverView.Group_Left.Group_Buff.Group_Tax.Txt_Des:SetColor(taxColor)
  serverView.Group_Left.Group_Buff.Group_Tax.Txt_State:SetColor(taxColor)
  serverView.Group_Left.Group_Buff.Group_Tax.Txt_State:SetText(taxTxtNum)
  serverView.Group_Left.Group_Buff.Group_Buy.Img_Icon:SetSprite(curStageCfg.buyIcon)
  serverView.Group_Left.Group_Buff.Group_Tax.Img_Icon:SetSprite(curStageCfg.revenueIcon)
  local parent = serverView.Group_Left.Img_Door.Img_Table
  for i = 1, parent.transform.childCount do
    local child = parent.transform:GetChild(i - 1)
    child:Find("Img_Mask").gameObject:SetActive(curStageIndex <= i)
  end
end

function Controller.ClickReceiveSeverReward(questId, limitQuestId)
  local function callBack(json)
    if json.reward then
      CommonTips.OpenShowItem(json.reward)
    end
    serverDataModel.SortStage()
    serverView.Group_Right.ScrollGrid_ProgressList.grid.self:SetDataCount(#serverDataModel.allStage)
    serverView.Group_Right.ScrollGrid_ProgressList.grid.self:RefreshAllElement()
  end
  
  Controller.ReceiveServerReward(questId, limitQuestId, callBack)
end

function Controller.ReceiveServerReward(questId, limitQuestId, callBack)
  local state = PlayerData.GetQuestState(questId)
  local limitQuestState = PlayerData.GetQuestState(limitQuestId)
  local canReceive = state == EnumDefine.EQuestState.Finish and (limitQuestState == EnumDefine.EQuestState.Finish or limitQuestState == EnumDefine.EQuestState.Receive)
  if not canReceive then
    return
  end
  local questCfg = PlayerData:GetFactoryData(questId, "QuestFactory")
  Net:SendProto("main.recv_activity", function(json)
    PlayerData.RefreshCardsData(json.reward)
    PlayerData:RefreshActivityData(questCfg.correspondActivity, json.activity)
    if callBack then
      callBack(json)
    end
  end, questCfg.correspondActivity, questId)
end

function Controller.RefreshBuffStage()
  local num = serverDataModel.GetCurNum()
  buffView.Group_Bar.Img_Stage.Txt_Num:SetText(buffDataModel.curStageIndex)
  buffView.Group_Bar.Group_Bar.Group_Num.Txt_Num:SetText(NumThousandsSplit(num))
  local nextStage = serverDataModel.GetNextStageInfo()
  local max = not nextStage.cfg
  buffView.Group_Bar.Group_Bar.Group_RightTxt.Group_Max:SetActive(max)
  buffView.Group_Bar.Group_Bar.Group_RightTxt.Group_Next:SetActive(not max)
  buffView.Group_Bar.Group_Bar.Group_NextStage.Group_Max:SetActive(max)
  buffView.Group_Bar.Group_Bar.Group_NextStage.Group_Next:SetActive(not max)
  if not max then
    buffView.Group_Bar.Group_Bar.Group_NextStage.Group_Next.Img_Icon.Txt_Level:SetText(nextStage.index)
    local questCfg = PlayerData:GetFactoryData(nextStage.cfg.id, "QuestFactory")
    local nextNum = questCfg.num
    buffView.Group_Bar.Group_Bar.Group_RightTxt.Group_Next.Group_Num.Txt_Num:SetText(NumThousandsSplit(nextNum))
    buffView.Group_Bar.Group_Bar.Img_Slider.Img_Bar:SetFilledImgAmount(num / nextNum)
  else
    buffView.Group_Bar.Group_Bar.Img_Slider.Img_Bar:SetFilledImgAmount(1)
  end
  buffView.StaticGrid_Stage.grid.self:SetDataCount(#buffDataModel.allBuffStage)
  buffView.StaticGrid_Stage.grid.self:RefreshAllElement()
  local parent = buffView.Img_Door.Group_Dessert
  for i = 1, parent.transform.childCount do
    local child = parent.transform:GetChild(i - 1)
    child:Find("Img_Mask").gameObject:SetActive(i >= buffDataModel.curStageIndex)
  end
  local activityCfg = PlayerData:GetFactoryData(86000001, "ActivityFactory")
  local inTime = TimeUtil:IsActive(activityCfg.startTime, activityCfg.endTime)
  if activityCfg.isTriggerTime then
    local activityData = PlayerData:GetActivityData(86000001)
    local startTime = activityData.st
    if startTime then
      local time = startTime + activityCfg.buffContinueTime * 86400
      if activityCfg.continueTime > 0 then
        local endTime = PlayerData.ServerData.user_home_info.addTime + (activityCfg.putTime + activityCfg.continueTime) * 86400
        if time > endTime then
          time = endTime
        end
      end
      local remainTime = time - PlayerData:GetSeverTime()
      inTime = 0 < remainTime
      if inTime then
        local timeTxt = ""
        if 86400 <= remainTime then
          timeTxt = string.format(GetText(80609064), math.floor(remainTime / 86400))
        else
          timeTxt = string.format(GetText(80609067), math.floor(remainTime / 3600))
        end
        buffView.Group_Time.Txt_Time:SetText(timeTxt)
      end
      buffView.Group_Time:SetActive(inTime)
    else
      buffView.Group_Time:SetActive(false)
    end
  else
    buffView.Group_Time:SetActive(false)
  end
end

function Controller.RefreshAchieve(achieveType)
  if achieveDataModel.achieveType == achieveType then
    return
  end
  achieveDataModel.achieveType = achieveType
  local showTrade = achieveType == achieveDataModel.AchieveType.Trade
  local showBattle = achieveType == achieveDataModel.AchieveType.Battle
  achieveView.Group_TopRight.Group_Trade.Btn_Switch:SetClickParam(achieveDataModel.AchieveType.Trade)
  achieveView.Group_TopRight.Group_Battle.Btn_Switch:SetClickParam(achieveDataModel.AchieveType.Battle)
  achieveView.Group_DownTrade:SetActive(showTrade)
  achieveView.Group_DownBattle:SetActive(showBattle)
  achieveView.Group_TopRight.Group_Trade.Group_On:SetActive(showTrade)
  achieveView.Group_TopRight.Group_Trade.Group_Off:SetActive(not showTrade)
  achieveView.Group_TopRight.Group_Battle.Group_On:SetActive(showBattle)
  achieveView.Group_TopRight.Group_Battle.Group_Off:SetActive(not showBattle)
  if showTrade then
    achieveView.Group_DownTrade.ScrollGrid_TypeList.grid.self:SetDataCount(#achieveDataModel.achieveTradeData)
    achieveView.Group_DownTrade.ScrollGrid_TypeList.grid.self:RefreshAllElement()
    achieveView.Group_TopRight.Group_Battle.Group_Off.Img_Red:SetActive(achieveDataModel.GetRedPointStateByType(achieveDataModel.AchieveType.Battle))
  end
  if showBattle then
    achieveView.Group_DownBattle.StaticGrid_Mission.grid.self:SetDataCount(#achieveDataModel.achieveBattleData)
    achieveView.Group_DownBattle.StaticGrid_Mission.grid.self:RefreshAllElement()
    achieveView.Group_TopRight.Group_Trade.Group_Off.Img_Red:SetActive(achieveDataModel.GetRedPointStateByType(achieveDataModel.AchieveType.Trade))
  end
end

return Controller
