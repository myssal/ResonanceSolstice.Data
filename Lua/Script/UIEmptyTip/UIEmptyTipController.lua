local View = require("UIEmptyTip/UIEmptyTipView")
local DataModel = require("UIEmptyTip/UIEmptyTipDataModel")
local Controller = {}

function Controller:Init()
  local strTalk = ""
  local strTrade = GetText(80609089)
  local strPassenger = GetText(80609088)
  if DataModel.hasLoadageEmpty and DataModel.hasPassengerEmpty then
    strTalk = GetText(80609101)
  elseif DataModel.hasLoadageEmpty then
    strTalk = GetText(80609099)
    strPassenger = GetText(80609103)
  elseif DataModel.hasPassengerEmpty then
    strTalk = GetText(80609100)
    strTrade = GetText(80609102)
  end
  local isPassengerMaskShow = not DataModel.hasPassengerEmpty
  local user_lv = PlayerData:GetUserInfo().lv
  local configCA = PlayerData:GetFactoryData(99900061)
  if user_lv < configCA.solicitOpen then
    strPassenger = string.format(GetText(80609104), configCA.solicitOpen)
    isPassengerMaskShow = true
  end
  local curTradeNum = PlayerData:GetUserInfo().space_info.now_train_goods_num or 0
  local maxTradeNum = PlayerData.GetMaxTrainGoodsNum()
  local curPassengerNum = PlayerData:GetCurPassengerNum() or 0
  local maxPassengerNum = PlayerData:GetMaxPassengerNum() or 0
  View.Group_Talk.Img_Dialog.Txt_Talk:SetText(strTalk)
  View.Group_Btn.Btn_Trade.Txt_T:SetText(strTrade)
  View.Group_Btn.Btn_Trade.Txt_Num:SetText(curTradeNum .. "/" .. maxTradeNum)
  View.Group_Btn.Btn_Passenger.Txt_T:SetText(strPassenger)
  View.Group_Btn.Btn_Passenger.Txt_Num:SetText(curPassengerNum .. "/" .. maxPassengerNum)
  View.Group_Btn.Btn_Trade.Img_Mask:SetActive(not DataModel.hasLoadageEmpty)
  View.Group_Btn.Btn_Passenger.Img_Mask:SetActive(isPassengerMaskShow)
  local isJudge = PlayerData:GetPlayerPrefs("int", "isIgnoreTradeEmpty") ~= 1
  Controller:SetTradeJudge(isJudge)
  local isJudge = PlayerData:GetPlayerPrefs("int", "isIgnorePassengerEmpty") ~= 1
  Controller:SetPassengerJudge(isJudge)
  local cityCA = PlayerData:GetFactoryData(DataModel.curCityId)
  local questStr = GetText(80609090)
  if not cityCA.isCOC then
    questStr = GetText(80609106)
  end
  View.Group_Btn.Btn_Quest.Txt_T:SetText(questStr)
  View.Group_Btn.Btn_Quest.Img_Mask:SetActive(not cityCA.isCOC)
  local checkType = PlayerData:GetPlayerPrefs("int", "EmptyTipCheckType")
  if checkType == 1 then
    Controller:SetCheckWeekTip(true)
  elseif checkType == 2 then
    Controller:SetCheckTip(true)
  else
    Controller:SetCheckTip(false)
    Controller:SetCheckWeekTip(false)
  end
  View.Btn_Go:SetActive(DataModel.notGoCity ~= true)
end

function Controller:SetCheckTip(checkTip)
  DataModel.CheckTip = checkTip
  View.Group_DayTip.Btn_Tip.Group_On:SetActive(checkTip)
  if checkTip then
    Controller:SetCheckWeekTip(false)
  end
end

function Controller:SetCheckWeekTip(checkTip)
  DataModel.CheckWeekTip = checkTip
  View.Group_WeekTip.Btn_Tip.Group_On:SetActive(checkTip)
  if checkTip then
    Controller:SetCheckTip(false)
  end
end

function Controller:SaveCheckType()
  local checkType = 0
  if DataModel.CheckWeekTip then
    checkType = 1
  elseif DataModel.CheckTip then
    checkType = 2
  end
  PlayerData:SetPlayerPrefs("int", "EmptyTipCheckType", checkType)
end

function Controller:SetTradeJudge(isJudge)
  DataModel.isTradeJudge = isJudge
  View.Group_Btn.Btn_Trade.Btn_Check.Group_Off:SetActive(not isJudge)
end

function Controller:SetPassengerJudge(isJudge)
  DataModel.isPassengerJudge = isJudge
  View.Group_Btn.Btn_Passenger.Btn_Check.Group_Off:SetActive(not isJudge)
end

return Controller
