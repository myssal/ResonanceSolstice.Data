local View = require("UILM_UI/UILM_UIView")
local DataModel = {}
DataModel.playgroundId = 87300002
DataModel.curData = {}
DataModel.historyData = {}
DataModel.scoreInfo = {}
DataModel.clean = 0
DataModel.wasteNum = 0
DataModel.wasteBlock = 0
DataModel.curFrame = 0
DataModel.MenuType = {
  Total = "Total",
  Day = "Day",
  Week = "Week",
  Month = "Month"
}
DataModel.selectMenuType = nil
DataModel.menuList = {}

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.curData = data.cur_record
  DataModel.historyData = data.hty_record
  DataModel.wasteBlock = data.waste_block
  DataModel.clean = data.current_clean
end

function DataModel.InitData()
  local playgroundId = DataModel.playgroundId
  local playgroundCA = PlayerData:GetFactoryData(playgroundId, "PlaygroundFactory")
  local playgroundData = PlayerData.GetPlaygroundData(playgroundId)
  DataModel.scoreInfo = {}
  local wasteNum = 0
  local furBagData = PlayerData.ServerData.user_home_info.facility[tostring(playgroundCA.bag)]
  for ucid, blockData in pairs(playgroundData.block) do
    if blockData.location then
      for _, v in pairs(blockData.location) do
        local ufid = v.id
        local furData = furBagData[ufid]
        local scoreInfo = PlayerData.GetFurScoreWithAllBuff(ufid, playgroundCA.bag)
        for scoreType, score in pairs(scoreInfo) do
          if not DataModel.scoreInfo[scoreType] then
            DataModel.scoreInfo[scoreType] = score
          else
            DataModel.scoreInfo[scoreType] = DataModel.scoreInfo[scoreType] + score
          end
        end
        local furCA = PlayerData:GetFactoryData(furData.id, "HomeFurnitureFactory")
        wasteNum = wasteNum + furCA.wasteoutput
        if furData.water then
          wasteNum = wasteNum + (furData.water.volume or 0)
        end
      end
    end
  end
  for k, v in pairs(playgroundData.block) do
    local coach_cfg = PlayerData:GetFactoryData(v.id, "HomeCoachFactory")
    wasteNum = wasteNum + coach_cfg.carriageRubbish
  end
  local visitors = PlayerData:GetVisitorsData(playgroundId) or {}
  for _, v in pairs(visitors) do
    for k, num in pairs(v.vt_info) do
      local splitT = string.split(k, ":")
      local psgCA = PlayerData:GetFactoryData(splitT[1], "PassageFactory")
      wasteNum = wasteNum + psgCA.wasteOutPut * num
    end
  end
  DataModel.wasteNum = wasteNum
  DataModel.menuList = {
    Total = View.Group_BBG.Group_Btn.Group_ZL,
    Day = View.Group_BBG.Group_Btn.Group_BR,
    Week = View.Group_BBG.Group_Btn.Group_BZ,
    Month = View.Group_BBG.Group_Btn.Group_BY
  }
  DataModel.circleAnim = {}
end

function DataModel.RefreshOnShow()
  local defaultMenuType = DataModel.MenuType.Total
  DataModel.selectMenuType = defaultMenuType
  View.Group_BBG.Group_Btn.Img_Btn:SetAnchoredPositionX(0)
  DataModel.RefreshPanel(defaultMenuType)
end

function DataModel.RefreshPanel(menuType)
  for i, v in pairs(DataModel.menuList) do
    v.Txt_On:SetActive(i == menuType)
    v.Txt_Down:SetActive(i ~= menuType)
  end
  View.Group_Overview:SetActive(menuType == DataModel.MenuType.Total)
  View.Group_Statistics:SetActive(menuType ~= DataModel.MenuType.Total)
  View.Group_Statistics.Group_Transaction_Day:SetActive(menuType == DataModel.MenuType.Day)
  View.Group_Statistics.Group_Transaction_Week:SetActive(menuType == DataModel.MenuType.Week)
  View.Group_Statistics.Group_Transaction_Month:SetActive(menuType == DataModel.MenuType.Month)
  if menuType == DataModel.MenuType.Total then
    DataModel.RefreshTotal()
  elseif menuType == DataModel.MenuType.Day then
    DataModel.RefreshDay()
  elseif menuType == DataModel.MenuType.Week then
    DataModel.RefreshWeek()
  elseif menuType == DataModel.MenuType.Month then
    DataModel.RefreshMonth()
  end
end

function DataModel.ClickMenu(menuType)
  if DataModel.selectMenuType == menuType then
    return
  end
  DataModel.selectMenuType = menuType
  DataModel.RefreshPanel(menuType)
  local posX = 0
  if menuType == DataModel.MenuType.Total then
    posX = -408
  elseif menuType == DataModel.MenuType.Day then
    posX = -204
  elseif menuType == DataModel.MenuType.Week then
    posX = 0
  elseif menuType == DataModel.MenuType.Month then
    posX = 204
  end
  DOTweenTools.DOLocalMoveX(View.Group_BBG.Group_Btn.Img_Btn.transform, posX, 0.1)
end

function DataModel.ScoreFormatShow(num)
  return MathEx.roundToDecimalPlaces(num)
end

function DataModel.GetTotalVisitorNum()
  local playgroundData = PlayerData.GetPlaygroundData(DataModel.playgroundId)
  local casualNum = playgroundData.casual.people or 0
  local psgNum = playgroundData.psg.people or 0
  local pubNum = playgroundData.pub.people or 0
  return casualNum + psgNum + pubNum
end

function DataModel.RefreshTotal()
  local playgroundId = DataModel.playgroundId
  local playgroundData = PlayerData.GetPlaygroundData(playgroundId)
  local playgroundCA = PlayerData:GetFactoryData(playgroundId, "PlaygroundFactory")
  View.Group_Overview.Group_IslandLv.Group_LvNum.Txt_LvNum:SetText(playgroundData.lv)
  View.Group_Overview.Group_IslandScore.Group_ScoreDelicious.Txt_Score:SetText(DataModel.ScoreFormatShow(DataModel.scoreInfo.food))
  View.Group_Overview.Group_IslandScore.Group_ScoreFun.Txt_Score:SetText(DataModel.ScoreFormatShow(DataModel.scoreInfo.play))
  View.Group_Overview.Group_IslandScore.Group_ScoreComfortable.Txt_Score:SetText(DataModel.ScoreFormatShow(DataModel.scoreInfo.comfort))
  View.Group_Overview.Group_IslandScore.Group_ScorePlant.Txt_Score:SetText(DataModel.ScoreFormatShow(DataModel.scoreInfo.plant))
  View.Group_Overview.Group_IslandScore.Group_ScoreFish.Txt_Score:SetText(DataModel.ScoreFormatShow(DataModel.scoreInfo.fish))
  View.Group_Overview.Group_IslandScore.Group_ScoreMadic.Txt_Score:SetText(DataModel.ScoreFormatShow(DataModel.scoreInfo.medical))
  View.Group_Overview.Group_IslandScore.Group_ScorePet.Txt_Score:SetText(DataModel.ScoreFormatShow(DataModel.scoreInfo.pet))
  View.Group_Overview.Group_IslandScore.Group_ScoreClean.Txt_Score:SetText(math.floor(DataModel.clean * 100) .. "%")
  local day = 0
  if 0 < playgroundData.rti then
    day = math.ceil((TimeUtil:GetServerTimeStamp() - playgroundData.rti) / 86400)
  end
  View.Group_Overview.Group_BasicInf.Group_TimeNum.Group_Text.Txt_Num:SetText(day)
  View.Group_Overview.Group_BasicInf.Group_TouristNum.Group_Text.Txt_Num:SetText(DataModel.GetTotalVisitorNum())
  View.Group_Overview.Group_BasicInf.Group_SafeNum.Group_Text.Txt_Num:SetText(playgroundData.stability .. "/" .. playgroundCA.maxStability)
  local count = 0
  for ucid, blockData in pairs(playgroundData.block) do
    if blockData.location then
      count = count + table.count(blockData.location)
    end
  end
  View.Group_Overview.Group_BasicInf.Group_FacilitiesNum.Group_Text.Txt_Num:SetText(count)
  local furBagData = PlayerData.ServerData.user_home_info.facility[tostring(playgroundCA.bag)]
  local lv = 0
  for i, v in pairs(furBagData) do
    local furCA = PlayerData:GetFactoryData(v.id, "HomeFurnitureFactory")
    if furCA.functionType == 12601374 then
      lv = furCA.Level
      break
    end
  end
  View.Group_Overview.Group_BasicInf.Group_HouseLv.Group_Text.Txt_Num:SetText(lv)
  local decorateNum = 0
  for i, v in pairs(furBagData) do
    local furCA = PlayerData:GetFactoryData(v.id, "HomeFurnitureFactory")
    if furCA.type == 12601233 then
      decorateNum = decorateNum + 1
    end
  end
  View.Group_Overview.Group_BasicInf.Group_DecorationNum.Group_Text.Txt_Num:SetText(decorateNum)
  View.Group_Overview.Group_EnvEvaluate.Group_Evaluate.Group_Out.Txt_RubNum:SetText(string.format(GetText(80601007), DataModel.wasteNum))
  View.Group_Overview.Group_EnvEvaluate.Group_Evaluate.Group_Clear.Txt_RubNum:SetText(DataModel.wasteBlock)
end

function DataModel.RefreshDay()
  local playgroundId = DataModel.playgroundId
  local casualConsume = 0
  local pubConsume = 0
  local psgConsume = 0
  local visitors = PlayerData.GetVisitorsData(playgroundId)
  if visitors then
    for i, v in pairs(visitors) do
      if v.source == "pub" then
        pubConsume = pubConsume + v.earn
      elseif v.source == "casual" then
        casualConsume = casualConsume + v.earn
      else
        psgConsume = psgConsume + v.earn
      end
    end
  end
  DataModel.RefreshConsume(casualConsume, pubConsume, psgConsume)
  DataModel.RefreshLike(DataModel.MenuType.Day)
  DataModel.RefreshHistoryDay()
end

function DataModel.RefreshWeek()
  local weekData = DataModel.curData.week
  local casualConsume = weekData.money.casual
  local pubConsume = weekData.money.pub
  local psgConsume = weekData.money.psg
  DataModel.RefreshConsume(casualConsume, pubConsume, psgConsume)
  DataModel.RefreshLike(DataModel.MenuType.Week)
  DataModel.RefreshHistoryWeek()
end

function DataModel.RefreshMonth()
  local monthData = DataModel.curData.month
  local casualConsume = monthData.money.casual
  local pubConsume = monthData.money.pub
  local psgConsume = monthData.money.psg
  DataModel.RefreshConsume(casualConsume, pubConsume, psgConsume)
  DataModel.RefreshLike(DataModel.MenuType.Month)
  DataModel.RefreshHistoryMonth()
end

function DataModel.RefreshHistoryDay()
  View.Group_Statistics.Group_Transaction_Day:SetActive(true)
  View.Group_Statistics.Group_Transaction_Week:SetActive(false)
  View.Group_Statistics.Group_Transaction_Month:SetActive(false)
  local htyData = DataModel.historyData.day
  if not htyData then
    return
  end
  local curConsume = htyData[5] and htyData[5].money or 0
  local lastConsume = htyData[4] and htyData[4].money or 0
  local ratio = 0 < lastConsume and (curConsume - lastConsume) / lastConsume * 100 or 0
  View.Group_Statistics.Group_Transaction_Day.Group_ProgressNum.Txt_Num:SetText(ClearFollowZero(ratio, 1) .. "%")
  View.Group_Statistics.Group_Transaction_Day.Group_TransactionList.Group_Estimate.Group_Money.Txt_Num:SetText(lastConsume)
  View.Group_Statistics.Group_Transaction_Day.Group_TransactionList.Group_Actual.Group_Money.Txt_Num:SetText(curConsume)
  local maxConsume = 0
  local maxVisitorNum = 0
  for i, v in pairs(htyData) do
    if maxConsume < v.money then
      maxConsume = v.money
    end
    if maxVisitorNum < v.people then
      maxVisitorNum = v.people
    end
  end
  local money1 = htyData[1] and htyData[1].money or 0
  local visitorNum1 = htyData[1] and htyData[1].people or 0
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_1.Group_Zero:SetActive(money1 == 0)
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_1.Group_Common:SetActive(money1 ~= 0)
  local consumeRatio1 = 0 < maxConsume and money1 / maxConsume or 0
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_1.Group_Common.Group_Income.Img_:SetFilledImgAmount(consumeRatio1 * 0.8)
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_1.Group_Common.Group_Income.Img_.Txt_:SetText(PlayerData:TransitionNum(money1))
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_1.Group_Common.Group_Income.Img_.Txt_:SetAnchoredPositionY(200 * consumeRatio1 * 0.8)
  local visitorNumRatio1 = 0 < maxVisitorNum and visitorNum1 / maxVisitorNum or 0
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_1.Group_Common.Group_TouistNum.Img_:SetFilledImgAmount(visitorNumRatio1 * 0.8)
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_1.Group_Common.Group_TouistNum.Img_.Txt_:SetText(PlayerData:TransitionNum(visitorNum1))
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_1.Group_Common.Group_TouistNum.Img_.Txt_:SetAnchoredPositionY(200 * visitorNumRatio1 * 0.8)
  local money2 = htyData[2] and htyData[2].money or 0
  local visitorNum2 = htyData[2] and htyData[2].people or 0
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_2.Group_Zero:SetActive(money2 == 0)
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_2.Group_Common:SetActive(money2 ~= 0)
  local consumeRatio2 = 0 < maxConsume and money2 / maxConsume or 0
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_2.Group_Common.Group_Income.Img_:SetFilledImgAmount(consumeRatio2 * 0.8)
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_2.Group_Common.Group_Income.Img_.Txt_:SetText(PlayerData:TransitionNum(money2))
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_2.Group_Common.Group_Income.Img_.Txt_:SetAnchoredPositionY(200 * consumeRatio2 * 0.8)
  local visitorNumRatio2 = 0 < maxVisitorNum and visitorNum2 / maxVisitorNum or 0
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_2.Group_Common.Group_TouistNum.Img_:SetFilledImgAmount(visitorNumRatio2 * 0.8)
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_2.Group_Common.Group_TouistNum.Img_.Txt_:SetText(PlayerData:TransitionNum(visitorNum2))
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_2.Group_Common.Group_TouistNum.Img_.Txt_:SetAnchoredPositionY(200 * visitorNumRatio2 * 0.8)
  local money3 = htyData[3] and htyData[3].money or 0
  local visitorNum3 = htyData[3] and htyData[3].people or 0
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_3.Group_Zero:SetActive(money3 == 0)
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_3.Group_Common:SetActive(money3 ~= 0)
  local consumeRatio3 = 0 < maxConsume and money3 / maxConsume or 0
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_3.Group_Common.Group_Income.Img_:SetFilledImgAmount(consumeRatio3 * 0.8)
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_3.Group_Common.Group_Income.Img_.Txt_:SetText(PlayerData:TransitionNum(money3))
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_3.Group_Common.Group_Income.Img_.Txt_:SetAnchoredPositionY(200 * consumeRatio3 * 0.8)
  local visitorNumRatio3 = 0 < maxVisitorNum and visitorNum3 / maxVisitorNum or 0
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_3.Group_Common.Group_TouistNum.Img_:SetFilledImgAmount(visitorNumRatio3 * 0.8)
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_3.Group_Common.Group_TouistNum.Img_.Txt_:SetText(PlayerData:TransitionNum(visitorNum3))
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_3.Group_Common.Group_TouistNum.Img_.Txt_:SetAnchoredPositionY(200 * visitorNumRatio3 * 0.8)
  local money4 = htyData[4] and htyData[4].money or 0
  local visitorNum4 = htyData[4] and htyData[4].people or 0
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_4.Group_Zero:SetActive(money4 == 0)
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_4.Group_Common:SetActive(money4 ~= 0)
  local consumeRatio4 = 0 < maxConsume and money4 / maxConsume or 0
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_4.Group_Common.Group_Income.Img_:SetFilledImgAmount(consumeRatio4 * 0.8)
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_4.Group_Common.Group_Income.Img_.Txt_:SetText(PlayerData:TransitionNum(money4))
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_4.Group_Common.Group_Income.Img_.Txt_:SetAnchoredPositionY(200 * consumeRatio4 * 0.8)
  local visitorNumRatio4 = 0 < maxVisitorNum and visitorNum4 / maxVisitorNum or 0
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_4.Group_Common.Group_TouistNum.Img_:SetFilledImgAmount(visitorNumRatio4 * 0.8)
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_4.Group_Common.Group_TouistNum.Img_.Txt_:SetText(PlayerData:TransitionNum(visitorNum4))
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_4.Group_Common.Group_TouistNum.Img_.Txt_:SetAnchoredPositionY(200 * visitorNumRatio4 * 0.8)
  local money5 = htyData[5] and htyData[5].money or 0
  local visitorNum5 = htyData[5] and htyData[5].people or 0
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_Today.Group_Zero:SetActive(money5 == 0)
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_Today.Group_Common:SetActive(money5 ~= 0)
  local consumeRatio5 = 0 < maxConsume and money5 / maxConsume or 0
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_Today.Group_Common.Group_Income.Img_:SetFilledImgAmount(consumeRatio5 * 0.8)
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_Today.Group_Common.Group_Income.Img_.Txt_:SetText(PlayerData:TransitionNum(money5))
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_Today.Group_Common.Group_Income.Img_.Txt_:SetAnchoredPositionY(200 * consumeRatio5 * 0.8)
  local visitorNumRatio5 = 0 < maxVisitorNum and visitorNum5 / maxVisitorNum or 0
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_Today.Group_Common.Group_TouistNum.Img_:SetFilledImgAmount(visitorNumRatio5 * 0.8)
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_Today.Group_Common.Group_TouistNum.Img_.Txt_:SetText(PlayerData:TransitionNum(visitorNum5))
  View.Group_Statistics.Group_Transaction_Day.Group_TransctionPic.Group_Line.Group_Today.Group_Common.Group_TouistNum.Img_.Txt_:SetAnchoredPositionY(200 * visitorNumRatio5 * 0.8)
end

function DataModel.RefreshHistoryWeek()
  View.Group_Statistics.Group_Transaction_Day:SetActive(false)
  View.Group_Statistics.Group_Transaction_Week:SetActive(true)
  View.Group_Statistics.Group_Transaction_Month:SetActive(false)
  local htyData = DataModel.historyData.week
  if not htyData then
    return
  end
  local curConsume = htyData[4] and htyData[4].money or 0
  local lastConsume = htyData[3] and htyData[3].money or 0
  local ratio = 0 < lastConsume and (curConsume - lastConsume) / lastConsume * 100 or 0
  View.Group_Statistics.Group_Transaction_Week.Group_ProgressNum.Txt_Num:SetText(ClearFollowZero(ratio, 1) .. "%")
  View.Group_Statistics.Group_Transaction_Week.Group_TransactionList.Group_Estimate.Group_Money.Txt_Num:SetText(lastConsume)
  View.Group_Statistics.Group_Transaction_Week.Group_TransactionList.Group_Actual.Group_Money.Txt_Num:SetText(curConsume)
  local maxConsume = 0
  local maxVisitorNum = 0
  for i, v in pairs(htyData) do
    if maxConsume < v.money then
      maxConsume = v.money
    end
    if maxVisitorNum < v.people then
      maxVisitorNum = v.people
    end
  end
  local money1 = htyData[1] and htyData[1].money or 0
  local visitorNum1 = htyData[1] and htyData[1].people or 0
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_1.Group_Zero:SetActive(money1 == 0)
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_1.Group_Common:SetActive(money1 ~= 0)
  local consumeRatio1 = 0 < maxConsume and money1 / maxConsume or 0
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_1.Group_Common.Group_Income.Img_:SetFilledImgAmount(consumeRatio1 * 0.8)
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_1.Group_Common.Group_Income.Img_.Txt_:SetText(PlayerData:TransitionNum(money1))
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_1.Group_Common.Group_Income.Img_.Txt_:SetAnchoredPositionY(200 * consumeRatio1 * 0.8)
  local visitorNumRatio1 = 0 < maxVisitorNum and visitorNum1 / maxVisitorNum or 0
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_1.Group_Common.Group_TouistNum.Img_:SetFilledImgAmount(visitorNumRatio1 * 0.8)
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_1.Group_Common.Group_TouistNum.Img_.Txt_:SetText(PlayerData:TransitionNum(visitorNum1))
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_1.Group_Common.Group_TouistNum.Img_.Txt_:SetAnchoredPositionY(200 * visitorNumRatio1 * 0.8)
  local money2 = htyData[2] and htyData[2].money or 0
  local visitorNum2 = htyData[2] and htyData[2].people or 0
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_2.Group_Zero:SetActive(money2 == 0)
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_2.Group_Common:SetActive(money2 ~= 0)
  local consumeRatio2 = 0 < maxConsume and money2 / maxConsume or 0
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_2.Group_Common.Group_Income.Img_:SetFilledImgAmount(consumeRatio2 * 0.8)
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_2.Group_Common.Group_Income.Img_.Txt_:SetText(PlayerData:TransitionNum(money2))
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_2.Group_Common.Group_Income.Img_.Txt_:SetAnchoredPositionY(200 * consumeRatio2 * 0.8)
  local visitorNumRatio2 = 0 < maxVisitorNum and visitorNum2 / maxVisitorNum or 0
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_2.Group_Common.Group_TouistNum.Img_:SetFilledImgAmount(visitorNumRatio2 * 0.8)
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_2.Group_Common.Group_TouistNum.Img_.Txt_:SetText(PlayerData:TransitionNum(visitorNum2))
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_2.Group_Common.Group_TouistNum.Img_.Txt_:SetAnchoredPositionY(200 * visitorNumRatio2 * 0.8)
  local money3 = htyData[3] and htyData[3].money or 0
  local visitorNum3 = htyData[3] and htyData[3].people or 0
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_3.Group_Zero:SetActive(money3 == 0)
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_3.Group_Common:SetActive(money3 ~= 0)
  local consumeRatio3 = 0 < maxConsume and money3 / maxConsume or 0
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_3.Group_Common.Group_Income.Img_:SetFilledImgAmount(consumeRatio3 * 0.8)
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_3.Group_Common.Group_Income.Img_.Txt_:SetText(PlayerData:TransitionNum(money3))
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_3.Group_Common.Group_Income.Img_.Txt_:SetAnchoredPositionY(200 * consumeRatio3 * 0.8)
  local visitorNumRatio3 = 0 < maxVisitorNum and visitorNum3 / maxVisitorNum or 0
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_3.Group_Common.Group_TouistNum.Img_:SetFilledImgAmount(visitorNumRatio3 * 0.8)
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_3.Group_Common.Group_TouistNum.Img_.Txt_:SetText(PlayerData:TransitionNum(visitorNum3))
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_3.Group_Common.Group_TouistNum.Img_.Txt_:SetAnchoredPositionY(200 * visitorNumRatio3 * 0.8)
  local money4 = htyData[4] and htyData[4].money or 0
  local visitorNum4 = htyData[4] and htyData[4].people or 0
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_Today.Group_Zero:SetActive(money4 == 0)
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_Today.Group_Common:SetActive(money4 ~= 0)
  local consumeRatio4 = 0 < maxConsume and money4 / maxConsume or 0
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_Today.Group_Common.Group_Income.Img_:SetFilledImgAmount(consumeRatio4 * 0.8)
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_Today.Group_Common.Group_Income.Img_.Txt_:SetText(PlayerData:TransitionNum(money4))
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_Today.Group_Common.Group_Income.Img_.Txt_:SetAnchoredPositionY(200 * consumeRatio4 * 0.8)
  local visitorNumRatio4 = 0 < maxVisitorNum and visitorNum4 / maxVisitorNum or 0
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_Today.Group_Common.Group_TouistNum.Img_:SetFilledImgAmount(visitorNumRatio4 * 0.8)
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_Today.Group_Common.Group_TouistNum.Img_.Txt_:SetText(PlayerData:TransitionNum(visitorNum4))
  View.Group_Statistics.Group_Transaction_Week.Group_TransctionPic.Group_Line.Group_Today.Group_Common.Group_TouistNum.Img_.Txt_:SetAnchoredPositionY(200 * visitorNumRatio4 * 0.8)
end

function DataModel.RefreshHistoryMonth()
  View.Group_Statistics.Group_Transaction_Day:SetActive(false)
  View.Group_Statistics.Group_Transaction_Week:SetActive(false)
  View.Group_Statistics.Group_Transaction_Month:SetActive(true)
  local htyData = DataModel.historyData.month
  if not htyData then
    return
  end
  local curConsume = htyData[3] and htyData[3].money or 0
  local lastConsume = htyData[2] and htyData[2].money or 0
  local ratio = 0 < lastConsume and (curConsume - lastConsume) / lastConsume * 100 or 0
  View.Group_Statistics.Group_Transaction_Month.Group_ProgressNum.Txt_Num:SetText(ClearFollowZero(ratio, 1) .. "%")
  View.Group_Statistics.Group_Transaction_Month.Group_TransactionList.Group_Estimate.Group_Money.Txt_Num:SetText(lastConsume)
  View.Group_Statistics.Group_Transaction_Month.Group_TransactionList.Group_Actual.Group_Money.Txt_Num:SetText(curConsume)
  local maxConsume = 0
  local maxVisitorNum = 0
  for i, v in pairs(htyData) do
    if maxConsume < v.money then
      maxConsume = v.money
    end
    if maxVisitorNum < v.people then
      maxVisitorNum = v.people
    end
  end
  local money1 = htyData[1] and htyData[1].money or 0
  local visitorNum1 = htyData[1] and htyData[1].people or 0
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_1.Group_Zero:SetActive(money1 == 0)
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_1.Group_Common:SetActive(money1 ~= 0)
  local consumeRatio1 = 0 < maxConsume and money1 / maxConsume or 0
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_1.Group_Common.Group_Income.Img_:SetFilledImgAmount(consumeRatio1 * 0.8)
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_1.Group_Common.Group_Income.Img_.Txt_:SetText(PlayerData:TransitionNum(money1))
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_1.Group_Common.Group_Income.Img_.Txt_:SetAnchoredPositionY(200 * consumeRatio1 * 0.8)
  local visitorNumRatio1 = 0 < maxVisitorNum and visitorNum1 / maxVisitorNum or 0
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_1.Group_Common.Group_TouistNum.Img_:SetFilledImgAmount(visitorNumRatio1 * 0.8)
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_1.Group_Common.Group_TouistNum.Img_.Txt_:SetText(PlayerData:TransitionNum(visitorNum1))
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_1.Group_Common.Group_TouistNum.Img_.Txt_:SetAnchoredPositionY(200 * visitorNumRatio1 * 0.8)
  local money2 = htyData[2] and htyData[2].money or 0
  local visitorNum2 = htyData[2] and htyData[2].people or 0
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_2.Group_Zero:SetActive(money2 == 0)
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_2.Group_Common:SetActive(money2 ~= 0)
  local consumeRatio2 = 0 < maxConsume and money2 / maxConsume or 0
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_2.Group_Common.Group_Income.Img_:SetFilledImgAmount(consumeRatio2 * 0.8)
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_2.Group_Common.Group_Income.Img_.Txt_:SetText(PlayerData:TransitionNum(money2))
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_2.Group_Common.Group_Income.Img_.Txt_:SetAnchoredPositionY(200 * consumeRatio2 * 0.8)
  local visitorNumRatio2 = 0 < maxVisitorNum and visitorNum2 / maxVisitorNum or 0
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_2.Group_Common.Group_TouistNum.Img_:SetFilledImgAmount(visitorNumRatio2 * 0.8)
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_2.Group_Common.Group_TouistNum.Img_.Txt_:SetText(PlayerData:TransitionNum(visitorNum2))
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_2.Group_Common.Group_TouistNum.Img_.Txt_:SetAnchoredPositionY(200 * visitorNumRatio2 * 0.8)
  local money3 = htyData[3] and htyData[3].money or 0
  local visitorNum3 = htyData[3] and htyData[3].people or 0
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_Today.Group_Zero:SetActive(money3 == 0)
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_Today.Group_Common:SetActive(money3 ~= 0)
  local consumeRatio3 = 0 < maxConsume and money3 / maxConsume or 0
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_Today.Group_Common.Group_Income.Img_:SetFilledImgAmount(consumeRatio3 * 0.8)
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_Today.Group_Common.Group_Income.Img_.Txt_:SetText(PlayerData:TransitionNum(money3))
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_Today.Group_Common.Group_Income.Img_.Txt_:SetAnchoredPositionY(200 * consumeRatio3 * 0.8)
  local visitorNumRatio3 = 0 < maxVisitorNum and visitorNum3 / maxVisitorNum or 0
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_Today.Group_Common.Group_TouistNum.Img_:SetFilledImgAmount(visitorNumRatio3 * 0.8)
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_Today.Group_Common.Group_TouistNum.Img_.Txt_:SetText(PlayerData:TransitionNum(visitorNum3))
  View.Group_Statistics.Group_Transaction_Month.Group_TransctionPic.Group_Line.Group_Today.Group_Common.Group_TouistNum.Img_.Txt_:SetAnchoredPositionY(200 * visitorNumRatio3 * 0.8)
end

local circleAnimFrame = {
  {frameStart = 20, frameEnd = 40},
  {frameStart = 40, frameEnd = 60},
  {frameStart = 60, frameEnd = 80}
}
DataModel.circleAnim = {}
DataModel.totalConsume = 0

function DataModel.RefreshConsume(casualConsume, pubConsume, psgConsume)
  DataModel.circleAnim = {}
  local totalConsume = casualConsume + pubConsume + psgConsume
  DataModel.totalConsume = totalConsume
  local consumeList = {
    {
      name = GetText(80609787),
      consume = casualConsume
    },
    {
      name = GetText(80609786),
      consume = pubConsume
    },
    {
      name = GetText(80609788),
      consume = psgConsume
    }
  }
  table.sort(consumeList, function(a, b)
    return a.consume > b.consume
  end)
  View.Group_Statistics.Group_Income.Group_List.Group_Yellow.Txt_Name:SetText(consumeList[1].name)
  View.Group_Statistics.Group_Income.Group_List.Group_Yellow.Group_Money.Txt_Num:SetText(consumeList[1].consume)
  View.Group_Statistics.Group_Income.Group_List.Group_Pink.Txt_Name:SetText(consumeList[2].name)
  View.Group_Statistics.Group_Income.Group_List.Group_Pink.Group_Money.Txt_Num:SetText(consumeList[2].consume)
  View.Group_Statistics.Group_Income.Group_List.Group_Blue.Txt_Name:SetText(consumeList[3].name)
  View.Group_Statistics.Group_Income.Group_List.Group_Blue.Group_Money.Txt_Num:SetText(consumeList[3].consume)
  local firstRate = 0 < totalConsume and consumeList[1].consume / totalConsume or 0
  View.Group_Statistics.Group_Income.Group_Pic.Group_Text.Group_Yellow.Txt_Yellow:SetText(ClearFollowZero(firstRate * 100) .. "%")
  local secondRate = 0 < totalConsume and consumeList[2].consume / totalConsume or 0
  View.Group_Statistics.Group_Income.Group_Pic.Group_Text.Group_Pink.Txt_Pink:SetText(ClearFollowZero(secondRate * 100) .. "%")
  local thirdRate = 0 < totalConsume and consumeList[3].consume / totalConsume or 0
  View.Group_Statistics.Group_Income.Group_Pic.Group_Text.Group_Blue.Txt_Blue:SetText(ClearFollowZero(thirdRate * 100) .. "%")
  View.Group_Statistics.Group_Income.Group_Pic.Group_Circle.Img_Yellow:SetFilledImgAmount(0)
  View.Group_Statistics.Group_Income.Group_Pic.Group_Circle.Img_Pink:SetFilledImgAmount(0)
  View.Group_Statistics.Group_Income.Group_Pic.Group_Circle.Img_Blue:SetFilledImgAmount(0)
  local animIndex = 0
  local firstNum = consumeList[1].consume
  if 0 < firstNum then
    animIndex = animIndex + 1
    table.insert(DataModel.circleAnim, {
      num = firstNum,
      ctrl = View.Group_Statistics.Group_Income.Group_Pic.Group_Circle.Img_Yellow,
      frame = circleAnimFrame[animIndex]
    })
  end
  local secondNum = consumeList[2].consume
  if 0 < secondNum then
    animIndex = animIndex + 1
    table.insert(DataModel.circleAnim, {
      num = secondNum,
      ctrl = View.Group_Statistics.Group_Income.Group_Pic.Group_Circle.Img_Pink,
      frame = circleAnimFrame[animIndex]
    })
  end
  local thirdNum = consumeList[3].consume
  if 0 < thirdNum then
    animIndex = animIndex + 1
    table.insert(DataModel.circleAnim, {
      num = thirdNum,
      ctrl = View.Group_Statistics.Group_Income.Group_Pic.Group_Circle.Img_Blue,
      frame = circleAnimFrame[animIndex]
    })
  end
  DataModel.curFrame = 0
end

local function GetCommonSum(psgCfg, tagCfg)
  local psgCANum = 0
  local tagCANum = 0
  for i, v in pairs(psgCfg) do
    psgCANum = psgCANum + v.common
  end
  for i, v in pairs(tagCfg) do
    tagCANum = tagCANum + v.common
  end
  return psgCANum + tagCANum
end

local function SetLevel(ctrl, level)
  for i = 1, 5 do
    local child = ctrl.transform:Find("Img_lv" .. i).gameObject
    child:SetActive(i <= level)
  end
end

function DataModel.RefreshLike(menuType)
  local totalLikeNumList = {
    comfort = 0,
    plant = 0,
    fish = 0,
    food = 0,
    play = 0,
    medical = 0,
    pet = 0
  }
  local playgroundId = DataModel.playgroundId
  local data = DataModel.curData
  local visitors = {}
  if menuType == DataModel.MenuType.Day then
    local visitorData = PlayerData.GetVisitorsData(playgroundId)
    for _, v in pairs(visitorData) do
      for k, num in pairs(v.vt_info) do
        if not visitors[k] then
          visitors[k] = num
        else
          visitors[k] = visitors[k] + num
        end
      end
    end
  elseif menuType == DataModel.MenuType.Week then
    visitors = data.week and data.week.vt
  elseif menuType == DataModel.MenuType.Month then
    visitors = data.month and data.month.vt
  end
  local visitorsNum = 0
  if visitors then
    for k, num in pairs(visitors) do
      local likeNumList = {}
      local splitT = string.split(k, ":")
      local psgCA = PlayerData:GetFactoryData(splitT[1], "PassageFactory")
      local tagCA = PlayerData:GetFactoryData(splitT[2], "ListFactory")
      table.insert(likeNumList, {
        scoreType = "comfort",
        score = GetCommonSum(psgCA.comfort, tagCA.comfort)
      })
      table.insert(likeNumList, {
        scoreType = "plant",
        score = GetCommonSum(psgCA.plantScores, tagCA.plantScores)
      })
      table.insert(likeNumList, {
        scoreType = "fish",
        score = GetCommonSum(psgCA.fishScores, tagCA.fishScores)
      })
      table.insert(likeNumList, {
        scoreType = "pet",
        score = GetCommonSum(psgCA.petScores, tagCA.petScores)
      })
      table.insert(likeNumList, {
        scoreType = "food",
        score = GetCommonSum(psgCA.foodScores, tagCA.foodScores)
      })
      table.insert(likeNumList, {
        scoreType = "play",
        score = GetCommonSum(psgCA.playScores, tagCA.playScores)
      })
      table.insert(likeNumList, {
        scoreType = "medical",
        score = GetCommonSum(psgCA.medicalScores, tagCA.medicalScores)
      })
      table.sort(likeNumList, function(a, b)
        return a.score > b.score
      end)
      for i = 1, 3 do
        if 0 < likeNumList[i].score then
          totalLikeNumList[likeNumList[i].scoreType] = totalLikeNumList[likeNumList[i].scoreType] + num
        end
      end
      visitorsNum = visitorsNum + num
    end
  end
  SetLevel(View.Group_Statistics.Group_Predisposition.Group_Like.Group_medical, math.ceil(totalLikeNumList.medical / visitorsNum * 5))
  SetLevel(View.Group_Statistics.Group_Predisposition.Group_Like.Group_play, math.ceil(totalLikeNumList.play / visitorsNum * 5))
  SetLevel(View.Group_Statistics.Group_Predisposition.Group_Like.Group_food, math.ceil(totalLikeNumList.food / visitorsNum * 5))
  SetLevel(View.Group_Statistics.Group_Predisposition.Group_Like.Group_pet, math.ceil(totalLikeNumList.pet / visitorsNum * 5))
  SetLevel(View.Group_Statistics.Group_Predisposition.Group_Like.Group_fish, math.ceil(totalLikeNumList.fish / visitorsNum * 5))
  SetLevel(View.Group_Statistics.Group_Predisposition.Group_Like.Group_plant, math.ceil(totalLikeNumList.plant / visitorsNum * 5))
  SetLevel(View.Group_Statistics.Group_Predisposition.Group_Like.Group_comfort, math.ceil(totalLikeNumList.comfort / visitorsNum * 5))
end

return DataModel
