local View = require("UIGroup_Income/UIGroup_IncomeView")
local NPCDialog = require("Common/NPCDialog")
local DataModel = {}
DataModel.stationId = nil
DataModel.playGroundId = 87300002
DataModel.npcId = 83700092
DataModel.playGroundData = {}
DataModel.ticket = 0
DataModel.maxTicket = 0
DataModel.tax = 0
DataModel.divide = 0
DataModel.maxDivide = 0
DataModel.totalInCome = 0
DataModel.curIncome = 0
DataModel.totalInvest = 0
DataModel.investNum = 0
DataModel.pond = {}
DataModel.investRewardItemObjList = {}

function DataModel.SetJsonData(json)
  if not json then
    return
  end
end

function DataModel.InitData()
  if PlayerData:GetHomeInfo().station_info.status == -1 then
    DataModel.stationId = PlayerData:GetHomeInfo().station_info.sid
  end
  local playGroundId = DataModel.playGroundId
  local playGroundCA = PlayerData:GetFactoryData(playGroundId, "PlaygroundFactory")
  local playGroundData = PlayerData.GetPlaygroundData(playGroundId)
  DataModel.playGroundData = playGroundData
  DataModel.maxTicket = playGroundCA.parkTicket + playGroundCA.parkTicketMax
  DataModel.maxDivide = playGroundCA.maxDivide
  DataModel.tax = DataModel.GetTax()
  DataModel.ticket = DataModel.GetTicket()
  DataModel.divide = DataModel.GetDivide()
  DataModel.totalInCome = DataModel.GetTotalInCome()
  DataModel.totalInvest = DataModel.GetTotalInvest()
  DataModel.investNum = DataModel.GetInvestNum()
  DataModel.pond = DataModel.GetInvestPond()
end

local function PlayNPCTalk(talk_type)
  local npcConfig = PlayerData:GetFactoryData(DataModel.npcId, "NPCFactory")
  local textTable = npcConfig[talk_type]
  if textTable then
    NPCDialog.SetNPCText(View.Group_NPC, textTable, talk_type)
  end
end

function DataModel.RefreshOnShow()
  if not DataModel.playGroundData then
    return
  end
  DataModel.RefreshRevenue()
  NPCDialog.SetNPC(View.Group_NPC, DataModel.npcId)
  PlayNPCTalk("enterText")
end

function DataModel.GetTax()
  local tax = DataModel.playGroundData and DataModel.playGroundData.tax or 0
  return tax < 0 and 0 or tax
end

function DataModel.GetTicket()
  local playGroundCA = PlayerData:GetFactoryData(DataModel.playGroundId, "PlaygroundFactory")
  local ticket = playGroundCA.parkTicket
  for i, v in pairs(DataModel.playGroundData.add) do
    ticket = ticket + v
  end
  local maxTicket = playGroundCA.parkTicket + playGroundCA.parkTicketMax
  return ticket > maxTicket and maxTicket or ticket
end

function DataModel.GetDivide()
  local playGroundCA = PlayerData:GetFactoryData(DataModel.playGroundId, "PlaygroundFactory")
  local divide = DataModel.playGroundData and DataModel.playGroundData.divide or 0
  return divide > playGroundCA.maxDivide and playGroundCA.maxDivide or divide
end

function DataModel.GetTotalInCome()
  return DataModel.GetCasualReward() + DataModel.GetTransReward() + DataModel.GetPubReward()
end

function DataModel.GetCasualNum()
  return DataModel.playGroundData and DataModel.playGroundData.casual.people or 0
end

function DataModel.GetCasualReward()
  return DataModel.playGroundData and DataModel.playGroundData.casual.money or 0
end

function DataModel.GetTransNum()
  return DataModel.playGroundData and DataModel.playGroundData.psg.people or 0
end

function DataModel.GetTransReward()
  return DataModel.playGroundData and DataModel.playGroundData.psg.money or 0
end

function DataModel.GetPubNum()
  return DataModel.playGroundData and DataModel.playGroundData.pub.people or 0
end

function DataModel.GetPubReward()
  return DataModel.playGroundData and DataModel.playGroundData.pub.money or 0
end

function DataModel.GetTotalPsgNum()
  return DataModel.GetCasualNum() + DataModel.GetTransNum() + DataModel.GetPubNum()
end

function DataModel.GetCurDay()
  local playGroundId = DataModel.playGroundId
  local playgroundData = DataModel.playGroundData
  local playgroundCA = PlayerData:GetFactoryData(playGroundId, "PlaygroundFactory")
  local basicDay = playgroundCA.parkPond[playgroundData.lv].travelDay
  local scoreDayAdd = 0
  local scoreInfo = {}
  for ucid, blockData in pairs(playgroundData.block) do
    if blockData.location then
      for _, v in pairs(blockData.location) do
        local scoreList = PlayerData.GetFurScoreWithAllBuff(v.id, playgroundCA.bag)
        for scoreType, score in pairs(scoreList) do
          if not scoreInfo[scoreType] then
            scoreInfo[scoreType] = score
          else
            scoreInfo[scoreType] = scoreInfo[scoreType] + score
          end
        end
      end
    end
  end
  local comfortDayAdd = math.modf(scoreInfo.comfort / playgroundCA.comfortNum) * playgroundCA.comfortDayAdd
  comfortDayAdd = comfortDayAdd > playgroundCA.comfortDayAddMax and playgroundCA.comfortDayAddMax or comfortDayAdd
  scoreDayAdd = scoreDayAdd + comfortDayAdd
  local plantDayAdd = math.modf(scoreInfo.plant / playgroundCA.plantNum) * playgroundCA.plantDayAdd
  plantDayAdd = plantDayAdd > playgroundCA.plantDayAddMax and playgroundCA.plantDayAddMax or plantDayAdd
  scoreDayAdd = scoreDayAdd + plantDayAdd
  local fishDayAdd = math.modf(scoreInfo.fish / playgroundCA.fishNum) * playgroundCA.fishDayAdd
  fishDayAdd = fishDayAdd > playgroundCA.fishDayAddMax and playgroundCA.fishDayAddMax or fishDayAdd
  scoreDayAdd = scoreDayAdd + fishDayAdd
  local petDayAdd = math.modf(scoreInfo.pet / playgroundCA.petNum) * playgroundCA.petDayAdd
  petDayAdd = petDayAdd > playgroundCA.petDayAddMax and playgroundCA.petDayAddMax or petDayAdd
  scoreDayAdd = scoreDayAdd + petDayAdd
  local foodDayAdd = math.modf(scoreInfo.food / playgroundCA.foodNum) * playgroundCA.foodDayAdd
  foodDayAdd = foodDayAdd > playgroundCA.foodDayAddMax and playgroundCA.foodDayAddMax or foodDayAdd
  scoreDayAdd = scoreDayAdd + foodDayAdd
  local playDayAdd = math.modf(scoreInfo.play / playgroundCA.playNum) * playgroundCA.playDayAdd
  plantDayAdd = playDayAdd > playgroundCA.playDayAddMax and playgroundCA.playDayAddMax or playDayAdd
  scoreDayAdd = scoreDayAdd + playDayAdd
  local medicalDayAdd = math.modf(scoreInfo.medical / playgroundCA.medicalNum) * playgroundCA.medicalDayAdd
  plantDayAdd = medicalDayAdd > playgroundCA.medicalDayAddMax and playgroundCA.medicalDayAddMax or medicalDayAdd
  scoreDayAdd = scoreDayAdd + medicalDayAdd
  local maxDayAdd = playgroundCA.islandTravelDayUp
  scoreDayAdd = scoreDayAdd > maxDayAdd and maxDayAdd or scoreDayAdd
  scoreDayAdd = ClearFollowZero(scoreDayAdd, 1)
  return basicDay + scoreDayAdd
end

function DataModel.RefreshRevenue()
  local playgroundId = DataModel.playGroundId
  View.Group_TapBattle.Group_TicketProfit.Btn_on:SetActive(true)
  View.Group_TapBattle.Group_TicketProfit.Btn_off:SetActive(false)
  View.Group_TapBattle.Group_Investment.Btn_on:SetActive(false)
  View.Group_TapBattle.Group_Investment.Btn_off:SetActive(true)
  View.Group_TicketProfit:SetActive(true)
  View.Group_Investment:SetActive(false)
  View.Group_TapBattle.GroupGold.Txt_Num:SetText(PlayerData:GetUserInfo().gold)
  local playGroundCA = PlayerData:GetFactoryData(playgroundId, "PlaygroundFactory")
  local curDay = DataModel.GetCurDay()
  local intPart, fractionPart = math.modf(curDay)
  if fractionPart == 0 then
    curDay = string.format("%02d", curDay)
  end
  View.Group_TicketProfit.Group_title.Img_fate.Txt_num:SetText(curDay)
  local ticket = DataModel.ticket
  View.Group_TicketProfit.Group_information.Group_profit.Img_ticket.Img_jinbi.Txt_num:SetText(ticket)
  local tax = DataModel.tax
  View.Group_TicketProfit.Group_information.Group_profit.Img_tax.Txt_num:SetText(ClearFollowZero((tax < 0 and 0 or tax) * 100) .. "%")
  local baseDivide = playGroundCA.divide
  local maxDivide = playGroundCA.maxDivide
  View.Group_TicketProfit.Group_information.Group_circle.Group_maximum.Txt_:SetText(string.format(GetText(80607713), maxDivide * 100))
  local divide = DataModel.divide
  View.Group_TicketProfit.Group_information.Img_divide.Txt_num:SetText(ClearFollowZero(divide * 100) .. "%")
  View.Group_TicketProfit.Group_information.Group_circle.Group_original.Txt_num:SetText(ClearFollowZero(baseDivide * 100) .. "%")
  View.Group_TicketProfit.Group_information.Group_circle.Group_added.Txt_num:SetText(ClearFollowZero((divide - baseDivide) * 100) .. "%")
  View.Group_TicketProfit.Group_information.Group_circle.Group_original.Img_original:SetFilledImgAmount(baseDivide / maxDivide)
  View.Group_TicketProfit.Group_information.Group_circle.Group_added.Img_added:SetFilledImgAmount((divide - baseDivide) / maxDivide)
  View.Group_TicketProfit.Group_information.Group_circle.Group_added.Img_added.transform.localRotation = Quaternion.Euler(0, 0, 360 * baseDivide / maxDivide)
  local transNum = DataModel.GetTransNum()
  View.Group_TicketProfit.Group_information.Group_profit.Group_EachPeopleNum.Group_Traffic.Img_Icon.Txt_Num:SetText(transNum)
  local pubNum = DataModel.GetPubNum()
  View.Group_TicketProfit.Group_information.Group_profit.Group_EachPeopleNum.Group_Publicize.Img_Icon.Txt_Num:SetText(pubNum)
  local casualNum = DataModel.GetCasualNum()
  View.Group_TicketProfit.Group_information.Group_profit.Group_EachPeopleNum.Group_SanKe.Img_Icon.Txt_Num:SetText(casualNum)
  View.Group_TicketProfit.Group_information.Group_profit.Group_EachPeopleNum.Group_Traffic.Img_Jiaobiao:SetActive(0 < transNum and transNum >= pubNum and transNum >= casualNum)
  View.Group_TicketProfit.Group_information.Group_profit.Group_EachPeopleNum.Group_Publicize.Img_Jiaobiao:SetActive(0 < pubNum and transNum <= pubNum and pubNum >= casualNum)
  View.Group_TicketProfit.Group_information.Group_profit.Group_EachPeopleNum.Group_SanKe.Img_Jiaobiao:SetActive(0 < casualNum and transNum <= casualNum and pubNum <= casualNum)
  local totalPsgNum = DataModel.GetTotalPsgNum()
  View.Group_TicketProfit.Group_information.Group_profit.Group_TotalPeopleNum.Txt_:SetText(totalPsgNum)
  local totalInCome = DataModel.totalInCome
  View.Group_TicketProfit.Group_income.Group_progress.Txt_money:SetText(totalInCome)
  local transReward = DataModel.GetTransReward()
  local pubReward = DataModel.GetPubReward()
  local casualReward = DataModel.GetCasualReward()
  local transRewardPercent = 0
  local pubRewardPercent = 0
  local casualRewardPercent = 0
  if 0 < totalInCome then
    transRewardPercent = transReward / totalInCome
    pubRewardPercent = pubReward / totalInCome
    casualRewardPercent = casualReward / totalInCome
  end
  View.Group_TicketProfit.Group_income.Group_Classify.Img_Traffic.Txt_Num:SetText(ClearFollowZero(transRewardPercent * 100) .. "%")
  View.Group_TicketProfit.Group_income.Group_Classify.Img_Publicize.Txt_Num:SetText(ClearFollowZero(pubRewardPercent * 100) .. "%")
  View.Group_TicketProfit.Group_income.Group_Classify.Img_SanKe.Txt_Num:SetText(ClearFollowZero(casualRewardPercent * 100) .. "%")
  View.Group_TicketProfit.Group_Reward.Img_ticketprofit.Group_profit.Txt_money:SetText(DataModel.curIncome)
end

function DataModel.RefreshInvest()
  DataModel.investRewardItemObjList = DataModel.investRewardItemObjList or {}
  View.Group_TapBattle.Group_TicketProfit.Btn_on:SetActive(false)
  View.Group_TapBattle.Group_TicketProfit.Btn_off:SetActive(true)
  View.Group_TapBattle.Group_Investment.Btn_on:SetActive(true)
  View.Group_TapBattle.Group_Investment.Btn_off:SetActive(false)
  View.Group_TicketProfit:SetActive(false)
  View.Group_Investment:SetActive(true)
  View.Group_TapBattle.GroupGold.Txt_Num:SetText(PlayerData:GetUserInfo().gold)
  local playGroundCA = PlayerData:GetFactoryData(DataModel.playGroundId, "PlaygroundFactory")
  local investNum = DataModel.investNum
  View.Group_Investment.Img_investmenticon.Txt_investmentTime:SetText(string.format(GetText(80604852), investNum))
  local totalInvest = DataModel.totalInvest
  View.Group_Investment.Group_information.Group_grossInvestment.Txt_num:SetText(PlayerData.FormatNumThousands(totalInvest))
  local addDivide = DataModel.divide - playGroundCA.divide
  View.Group_Investment.Group_information.Group_divide.Txt_num:SetText(ClearFollowZero(addDivide * 100) .. "%")
  local reduceTax = DataModel.tax - playGroundCA.tax
  View.Group_Investment.Group_information.Group_tax.Txt_num:SetText(ClearFollowZero(reduceTax * 100) .. "%")
  local ticket = DataModel.ticket
  View.Group_Investment.Group_information.Group_ticket.Txt_num:SetText(ticket - playGroundCA.parkTicket)
  View.Group_Investment.ScrollGrid_List.grid.self:SetDataCount(table.count(DataModel.pond))
  View.Group_Investment.ScrollGrid_List.grid.self:RefreshAllElement()
end

function DataModel.GetTotalInvest()
  return DataModel.playGroundData and DataModel.playGroundData.invest_gold or 0
end

function DataModel.GetInvestNum()
  local playGroundCA = PlayerData:GetFactoryData(DataModel.playGroundId, "PlaygroundFactory")
  local useNum = DataModel.playGroundData and DataModel.playGroundData.invest_num or 0
  return playGroundCA.investTime - useNum
end

function DataModel.GetInvestPond()
  return DataModel.playGroundData and DataModel.playGroundData.pond or {}
end

function DataModel.InvestRefreshData(investIndex)
  local pondCfg = PlayerData:GetFactoryData(DataModel.pond[investIndex], "PondFactory")
  DataModel.playGroundData.invest_num = DataModel.playGroundData.invest_num + 1
  DataModel.playGroundData.tax = DataModel.playGroundData.tax + pondCfg.tax
  DataModel.playGroundData.divide = DataModel.playGroundData.divide + pondCfg.divide
  DataModel.playGroundData.add.donate = DataModel.playGroundData.add.donate + pondCfg.ticket
  for i, v in ipairs(pondCfg.item) do
    if v.id == 11400001 then
      DataModel.playGroundData.invest_gold = DataModel.playGroundData.invest_gold + v.num
    end
  end
  DataModel.investNum = DataModel.GetInvestNum()
  DataModel.tax = DataModel.GetTax()
  DataModel.divide = DataModel.GetDivide()
  DataModel.ticket = DataModel.GetTicket()
  DataModel.totalInvest = DataModel.GetTotalInvest()
end

function DataModel.IsInvestTipsShow(pondId)
  local time = PlayerData:GetPlayerPrefs("int", "ParkInvest")
  if time == 0 or time < PlayerData:GetSeverTime() then
    local pondCfg = PlayerData:GetFactoryData(pondId, "PondFactory")
    local ticketMax = pondCfg.ticket ~= 0 and DataModel.ticket >= DataModel.maxTicket
    if ticketMax then
      return 80602599
    end
    local taxMax = pondCfg.tax ~= 0 and 0 >= DataModel.tax
    if taxMax then
      return 80602600
    end
    local divideMax = pondCfg.divide ~= 0 and DataModel.divide >= DataModel.maxDivide
    if divideMax then
      return 80602601
    end
  end
  return 0
end

function DataModel.Invest(investIndex)
  if PlayerData:GetHomeInfo().station_info.status ~= -1 or tonumber(DataModel.stationId) ~= 83000002 then
    CommonTips.OpenTips(80608246)
    return
  end
  if DataModel.investNum == 0 then
    CommonTips.OpenTips(80601933)
    return
  end
  
  local function callback()
    Net:SendProto("playground.invest", function(json)
      DataModel.InvestRefreshData(investIndex)
      local pondCfg = PlayerData:GetFactoryData(DataModel.pond[investIndex], "PondFactory")
      local ticketMax = DataModel.ticket == DataModel.maxTicket
      local taxMax = DataModel.tax == 0
      local divideMax = DataModel.divide == DataModel.maxDivide
      View.Group_StageReward.Group_InvestReward.Group_Up.Group_Divide:SetActive(pondCfg.divide ~= 0)
      View.Group_StageReward.Group_InvestReward.Group_Up.Group_Divide.Group_num:SetActive(not divideMax)
      View.Group_StageReward.Group_InvestReward.Group_Up.Group_Divide.Txt_Max:SetActive(divideMax)
      View.Group_StageReward.Group_InvestReward.Group_Up.Group_Divide.Group_num.Txt_Num:SetText(ClearFollowZero(pondCfg.divide * 100) .. "%")
      View.Group_StageReward.Group_InvestReward.Group_Up.Group_Divide.Group_num.Img_UP.transform.localScale = 0 < pondCfg.divide and Vector3(1, 1, 1) or Vector3(1, -1, 1)
      View.Group_StageReward.Group_InvestReward.Group_Up.Group_Rate:SetActive(pondCfg.tax ~= 0)
      View.Group_StageReward.Group_InvestReward.Group_Up.Group_Rate.Group_num:SetActive(not taxMax)
      View.Group_StageReward.Group_InvestReward.Group_Up.Group_Rate.Txt_Max:SetActive(taxMax)
      View.Group_StageReward.Group_InvestReward.Group_Up.Group_Rate.Group_num.Txt_Num:SetText(ClearFollowZero(pondCfg.tax * 100) .. "%")
      View.Group_StageReward.Group_InvestReward.Group_Up.Group_Rate.Group_num.Img_UP.transform.localScale = pondCfg.tax > 0 and Vector3(1, 1, 1) or Vector3(1, -1, 1)
      View.Group_StageReward.Group_InvestReward.Group_Up.Group_Ticket:SetActive(pondCfg.ticket ~= 0)
      View.Group_StageReward.Group_InvestReward.Group_Up.Group_Ticket.Group_num:SetActive(not ticketMax)
      View.Group_StageReward.Group_InvestReward.Group_Up.Group_Ticket.Txt_Max:SetActive(ticketMax)
      View.Group_StageReward.Group_InvestReward.Group_Up.Group_Ticket.Group_num.Txt_Num:SetText(pondCfg.ticket)
      View.Group_StageReward.Group_InvestReward.Group_Up.Group_Ticket.Group_num.Img_UP.transform.localScale = pondCfg.ticket > 0 and Vector3(1, 1, 1) or Vector3(1, -1, 1)
      View.Group_StageReward:SetActive(true)
      local sound = SoundManager:CreateSound(30002966)
      sound:Play()
      DataModel:RefreshInvest()
    end, investIndex - 1)
  end
  
  local txtId = DataModel.IsInvestTipsShow(DataModel.pond[investIndex])
  if 0 < txtId then
    UIManager:Open("UI/HomeBattleCenter/Group_InvestTip", Json.encode({txtId = txtId}), callback)
  else
    callback()
  end
end

return DataModel
