local View = require("UIStore/UIStoreView")
local DataModel = require("UIStore/UIStoreDataModel")
local Controller = {
  valuableId = 0,
  valuableCa = nil,
  curScrollGroup = nil
}

function Controller.InitContentShow(valuableId)
  Controller.valuableId = valuableId
  Controller.valuableCa = PlayerData:GetFactoryData(Controller.valuableId, "ValuableFactory")
  if not Controller.valuableCa then
    return
  end
  local signState = DataModel.GetSignGiftRedDotState()
  if not signState then
    Controller.SetSignTopIndexNotRed()
  end
  Controller.ReqAndRefreshContentShow()
  TimerHelper.Stop("Store_SignGift_Remain_Timer")
  TimerHelper.Start("Store_SignGift_Remain_Timer", 1, function()
    Controller.RefreshTimerShow()
  end)
end

function Controller.SetSignTopIndexNotRed()
  PlayerData:SetPlayerPrefs("int", "StoreRed" .. Controller.valuableId, 1)
  DataModel.TypeList[DataModel.SignGiftShopId] = nil
  local element = View.ScrollGrid_TopButton.grid.self:GetElementByIndex(DataModel.TopIndex - 1)
  if element then
    element.Btn_Top.Img_RedPoint:SetActive(false)
  end
end

function Controller.SetSignTopIndexRed()
  PlayerData:SetPlayerPrefs("int", "StoreRed" .. Controller.valuableId, 0)
  DataModel.TypeList[DataModel.SignGiftShopId] = {}
  DataModel.TypeList[DataModel.SignGiftShopId].count = 1
  local element = View.ScrollGrid_TopButton.grid.self:GetElementByIndex(DataModel.TopIndex - 1)
  if element then
    element.Btn_Top.Img_RedPoint:SetActive(true)
  end
end

function Controller.Release()
  TimerHelper.Stop("Store_SignGift_Remain_Timer")
end

function Controller.RefreshContentShow()
  if not Controller.valuableCa then
    return
  end
  View.Group_SignGift.Btn_Medal.Txt_Num:SetText(PlayerData:GetGoodsById(11400005).num or 0)
  View.Group_SignGift.Group_Middle.Txt_Name:SetText(Controller.valuableCa.name)
  View.Group_SignGift.Group_Middle.Group_Btn.Group_Value.Txt_Value:SetText(string.format(GetText(80611347), Controller.valuableCa.superValue))
  local isBuy = DataModel.GetGoodIsBuy()
  if isBuy then
    View.Group_SignGift.Group_Middle.Group_Btn.Group_Can:SetActive(false)
    View.Group_SignGift.Group_Middle.Group_Btn.Group_Not:SetActive(true)
  else
    View.Group_SignGift.Group_Middle.Group_Btn.Group_Can:SetActive(true)
    View.Group_SignGift.Group_Middle.Group_Btn.Group_Not:SetActive(false)
    local productId = tostring(Controller.valuableId)
    local displayPrice = PayProductHelper.GetProductDisplayPrice(productId)
    View.Group_SignGift.Group_Middle.Group_Btn.Group_Can.Txt_Price:SetText(displayPrice)
  end
  Controller.RefreshTimerShow()
  local dayRewardList = Controller.valuableCa.dayRewardList or {}
  local rewardCount = #dayRewardList
  View.Group_SignGift.Group_Middle.Group_Tips.Txt_Tips:SetText(string.format(GetText(80611343), Controller.valuableCa.getContinueTime, rewardCount))
  View.Group_SignGift.Group_Middle.Group_7:SetActive(rewardCount == 7)
  View.Group_SignGift.Group_Middle.Group_6:SetActive(rewardCount == 6)
  View.Group_SignGift.Group_Middle.Group_5:SetActive(rewardCount == 5)
  View.Group_SignGift.Group_Middle.Group_4:SetActive(rewardCount == 4)
  View.Group_SignGift.Group_Middle.Group_3:SetActive(rewardCount == 3)
  Controller.curScrollGroup = View.Group_SignGift.Group_Middle["Group_" .. rewardCount]
  if Controller.curScrollGroup then
    Controller.curScrollGroup.StaticGrid_List.grid.self:SetDataCount(rewardCount)
    Controller.curScrollGroup.StaticGrid_List.grid.self:RefreshAllElement()
  end
end

function Controller.RefreshTimerShow()
  if not View.Group_SignGift.self.gameObject.activeSelf then
    return
  end
  if not Controller.valuableCa or not Controller.valuableId then
    return
  end
  local isBuy = DataModel.GetGoodIsBuy()
  local nowTime = TimeUtil:GetServerTimeStamp() or 0
  local buyTime = DataModel.GetGoodBuyTime()
  local remainTime = 0
  if Controller.valuableCa.isTime then
    View.Group_SignGift.Group_Middle.Group_Time:SetActive(true)
    if isBuy then
      remainTime = buyTime + Controller.valuableCa.getContinueTime * 24 * 60 * 60 - nowTime
    else
      local endTime = TimeUtil:TimeStamp(Controller.valuableCa.endTime) or 0
      remainTime = endTime - nowTime
    end
    remainTime = remainTime < 0 and 0 or remainTime
    local remainTable = TimeUtil:SecondToTable(remainTime)
    if remainTable.day > 1 then
      View.Group_SignGift.Group_Middle.Group_Time.Txt_Time:SetText(string.format(GetText(80611348), remainTable.day, remainTable.hour))
    else
      View.Group_SignGift.Group_Middle.Group_Time.Txt_Time:SetText(string.format(GetText(80611349), remainTable.hour, remainTable.minute))
    end
  elseif isBuy then
    View.Group_SignGift.Group_Middle.Group_Time:SetActive(true)
    remainTime = buyTime + Controller.valuableCa.getContinueTime * 24 * 60 * 60 - nowTime
    remainTime = remainTime < 0 and 0 or remainTime
    local remainTable = TimeUtil:SecondToTable(remainTime)
    if remainTable.day > 1 then
      View.Group_SignGift.Group_Middle.Group_Time.Txt_Time:SetText(string.format(GetText(80611351), remainTable.day, remainTable.hour))
    else
      View.Group_SignGift.Group_Middle.Group_Time.Txt_Time:SetText(string.format(GetText(80611350), remainTable.hour, remainTable.minute))
    end
  else
    View.Group_SignGift.Group_Middle.Group_Time:SetActive(false)
  end
  if Controller.valuableCa.isTime and remainTime <= 0 or Controller.valuableCa.isTime == false and isBuy and remainTime <= 0 then
    View.Group_SignGift:SetActive(false)
    Controller.OnTimerOverToRefreshTopList()
  end
end

function Controller.OnTimerOverToRefreshTopList()
  local mainStoreList = DataModel.InitAllMainStoreList() or {}
  if #mainStoreList == 0 then
    return
  end
  DataModel.mainStoreList = mainStoreList
  View.ScrollGrid_TopButton.self:SetActive(true)
  View.ScrollGrid_TopButton.grid.self:SetDataCount(table.count(mainStoreList))
  View.ScrollGrid_TopButton.grid.self:RefreshAllElement()
  View.ScrollGrid_TopButton.grid.self:MoveToTop()
  require("UIStore/UIStoreDataController").ChooseTopList(1)
end

function Controller.RefreshRewardElementItemShow(element, elementIndex)
  if not View.Group_SignGift.self.gameObject.activeSelf then
    return
  end
  if not element or not elementIndex then
    return
  end
  if not Controller.valuableCa or not Controller.valuableCa.dayRewardList then
    return
  end
  local rewardInfo = Controller.valuableCa.dayRewardList[elementIndex]
  if not rewardInfo then
    return
  end
  element.Txt_Day:SetText(elementIndex)
  local listCa = PlayerData:GetFactoryData(rewardInfo.id, "ListFactory")
  if not listCa or not listCa.rewardList then
    return
  end
  if #listCa.rewardList <= 2 then
    element.StaticGrid_Reward.grid.self:SetActive(true)
    element.ScrollGrid_Reward.grid.self:SetActive(false)
    element.StaticGrid_Reward.grid.self:SetParentParam(elementIndex)
    element.StaticGrid_Reward.grid.self:SetDataCount(#listCa.rewardList)
    element.StaticGrid_Reward.grid.self:RefreshAllElement()
  else
    element.StaticGrid_Reward.grid.self:SetActive(false)
    element.ScrollGrid_Reward.grid.self:SetActive(true)
    element.ScrollGrid_Reward.grid.self:SetParentParam(elementIndex)
    element.ScrollGrid_Reward.grid.self:SetDataCount(#listCa.rewardList)
    element.ScrollGrid_Reward.grid.self:RefreshAllElement()
  end
  local getState = DataModel.GetGoodItemGetState(elementIndex)
  element.Group_Not:SetActive(getState == DataModel.SignRewardGetState.canNotGet)
  element.Group_Already:SetActive(getState == DataModel.SignRewardGetState.hasGet)
  element.Group_Can:SetActive(getState == DataModel.SignRewardGetState.canGet)
  if getState == DataModel.SignRewardGetState.canGet then
    Controller.SetSignTopIndexRed()
  end
  element.Btn_:SetClickFunction(function()
    if getState == DataModel.SignRewardGetState.canNotGet or getState == DataModel.SignRewardGetState.hasGet then
      return
    end
    Net:SendProto("main.value_reward", function(json)
      if json and string.nilorempty(json.rc) then
        DataModel.GetSignGiftToUpdateProto(DataModel.GetCanGetMaxIndex())
        if json.reward then
          CommonTips.OpenShowItem(json.reward)
        end
        Controller.RefreshContentShow()
        Controller.SetSignTopIndexNotRed()
      end
    end, Controller.valuableId, elementIndex - 1, 1)
  end)
end

function Controller.RefreshItemElementShow(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  if not Controller.valuableCa or not Controller.valuableCa.dayRewardList then
    return
  end
  local index = tonumber(element.ParentParam)
  local rewardInfo = Controller.valuableCa.dayRewardList[index]
  if not rewardInfo then
    return
  end
  local listCa = PlayerData:GetFactoryData(rewardInfo.id, "ListFactory")
  if not listCa or not listCa.rewardList then
    return
  end
  local itemInfo = listCa.rewardList[elementIndex]
  if not itemInfo then
    return
  end
  element.Txt_Num:SetText(itemInfo.num)
  local itemCa = PlayerData:GetFactoryData(itemInfo.id, "ItemFactory")
  if not itemCa then
    return
  end
  element.Img_Icon:SetSprite(itemCa.tipsPath)
  element.Btn_:SetClickFunction(function()
    CommonTips.OpenPreRewardDetailTips(itemInfo.id)
  end)
  local itemState = DataModel.GetGoodItemGetState(index)
  if itemState == DataModel.SignRewardGetState.hasGet then
    element.Group_Already:SetActive(true)
  else
    element.Group_Already:SetActive(false)
  end
end

function Controller.ReqAndRefreshContentShow()
  Net:SendProto("main.sign_values", function(json)
    if json and string.nilorempty(json.rc) then
      if json.sign_award then
        for id, v in pairs(json.sign_award) do
          if id == tostring(Controller.valuableId) then
            DataModel.SignGiftProto = v
          end
        end
        PlayerData.ServerData = PlayerData.ServerData or {}
        if PlayerData.ServerData.sign_award and PlayerData.ServerData.sign_award[tostring(Controller.valuableId)] then
          PlayerData.ServerData.sign_award[tostring(Controller.valuableId)] = DataModel.SignGiftProto
        end
      end
      Controller.RefreshContentShow()
    end
  end)
end

function Controller.OnBuyGiftBtnClick()
  local isBuy = DataModel.GetGoodIsBuy()
  if isBuy then
    return
  end
  
  local function cb()
    PlayerData.RechargeGoods[tostring(DataModel.SignGiftShopId)] = PlayerData.RechargeGoods[tostring(DataModel.SignGiftShopId)] or {}
    local signGiftValId = DataModel.GetSignGiftValuableId() or 0
    PlayerData.RechargeGoods[tostring(DataModel.SignGiftShopId)][tostring(signGiftValId)] = PlayerData.RechargeGoods[tostring(DataModel.SignGiftShopId)][tostring(signGiftValId)] or {}
    PlayerData.RechargeGoods[tostring(DataModel.SignGiftShopId)][tostring(signGiftValId)].num = 1
    Controller.ReqAndRefreshContentShow()
  end
  
  PayHelper.BuyV2(Controller.valuableId, cb)
end

return Controller
