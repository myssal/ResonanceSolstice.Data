local View = require("UIDiceDay/UIDiceDayView")
local MonopolyManager = require("UIMonopoly/LuaMonopolyManager")
local Controller = {
  dailSubsidy = {},
  monopolyInfo = nil,
  timeList = nil,
  curSelectIndex = 0,
  activityId = 86000020,
  activityCA = nil,
  itemId_Dice = 11400335,
  itemId_SuperDice = 11400334,
  storeId = 0
}

function Controller.Init(daily_subsidy)
  local monopolyInfo = PlayerData:GetFactoryData(PlayerData.GetMonopolyControlId(), "MapControlFactory")
  if not monopolyInfo then
    return
  end
  local timeList
  if PlayerData.AdministrationsAddictionHolidays == true then
    timeList = monopolyInfo.diceTimeWeekendNum
  else
    timeList = monopolyInfo.diceTimeNum
  end
  if not timeList then
    return
  end
  Controller.timeList = timeList
  Controller.dailSubsidy = daily_subsidy or {}
  Controller.OnRewardBtnClick()
  TimerHelper.Stop("Monopoly_RefreshDiceDayView_Timer")
  TimerHelper.Start("Monopoly_RefreshDiceDayView_Timer", 5, function()
    Controller.RefreshContentShow()
  end)
  local sound = SoundManager:CreateSound(30006378)
  if sound then
    sound:Play()
  end
  EventMgr:AddEvent("event_monopoly_buy_dice_success", Controller.OnBuySuccess)
end

function Controller.Release()
  EventMgr:RemoveEvent("event_monopoly_buy_dice_success", Controller.OnBuySuccess)
  TimerHelper.Stop("Monopoly_RefreshDiceDayView_Timer")
end

function Controller.RefreshContentShow()
  if Controller.curSelectIndex ~= 1 then
    return
  end
  if not Controller.timeList then
    return
  end
  local t1 = Controller.timeList[1]
  if t1 then
    View.Group_Reward.Group_Afternoon.Txt_Time:SetText(t1.startTime .. "~" .. t1.endTime)
    local itemCA = PlayerData:GetFactoryData(Controller.itemId_Dice, "ItemFactory")
    if itemCA then
      View.Group_Reward.Group_Afternoon.Btn_Icon:SetClickParam(Controller.itemId_Dice)
      View.Group_Reward.Group_Afternoon.Btn_Icon:SetSprite(itemCA.iconPath)
      View.Group_Reward.Group_Afternoon.Group_Des.Txt_Name:SetText(itemCA.name)
    else
      View.Group_Reward.Group_Afternoon.Btn_Icon:SetActive(false)
    end
    View.Group_Reward.Group_Afternoon.Group_Des.Txt_Num:SetText(t1.num)
    local getType = Controller.GetGetBtnStateTypeByTime(0, t1.startTime, t1.endTime)
    Controller.SetRewardTimeShow(getType, View.Group_Reward.Group_Afternoon)
  end
  local t2 = Controller.timeList[2]
  if t2 then
    View.Group_Reward.Group_Night.Txt_Time:SetText(t2.startTime .. "~" .. t2.endTime)
    local itemCA = PlayerData:GetFactoryData(Controller.itemId_Dice, "ItemFactory")
    if itemCA then
      View.Group_Reward.Group_Night.Btn_Icon:SetClickParam(Controller.itemId_Dice)
      View.Group_Reward.Group_Night.Btn_Icon:SetSprite(itemCA.iconPath)
      View.Group_Reward.Group_Night.Group_Des.Txt_Name:SetText(itemCA.name)
    else
      View.Group_Reward.Group_Night.Btn_Icon:SetActive(false)
    end
    View.Group_Reward.Group_Night.Group_Des.Txt_Num:SetText(t2.num)
    local getType2 = Controller.GetGetBtnStateTypeByTime(1, t2.startTime, t2.endTime)
    Controller.SetRewardTimeShow(getType2, View.Group_Reward.Group_Night)
  end
end

function Controller.GetGetBtnStateTypeByTime(index, startTime, endTime)
  if Controller.dailSubsidy and table.contains(Controller.dailSubsidy, index) then
    return 1
  end
  local lgTimeTable = TimeUtil:GetLogicServerDayTable()
  local hour = lgTimeTable.hour
  local min = lgTimeTable.minute
  local startHour = tonumber(string.sub(startTime, 1, 2))
  local startMin = tonumber(string.sub(startTime, 4, 5))
  local endHour = tonumber(string.sub(endTime, 1, 2))
  local endMin = tonumber(string.sub(endTime, 4, 5))
  if hour < startHour or hour == startHour and min < startMin then
    return 2
  end
  if hour > endHour or hour == endHour and min > endMin then
    return 3
  end
  return 4
end

function Controller.ReqGetSubsidy(index)
  if not Controller.timeList then
    return
  end
  local t = Controller.timeList[index + 1]
  if not t then
    return
  end
  local getType = Controller.GetGetBtnStateTypeByTime(index, t.startTime, t.endTime)
  if getType == 1 then
    CommonTips.OpenTips(80607129)
    return
  elseif getType == 2 or getType == 3 then
    CommonTips.OpenTips(80609489)
    return
  end
  Net:SendProto("monopoly.get_subsidy", function(json)
    if string.nilorempty(json.rc) and Controller.timeList and t then
      MonopolyManager.OnSubsidyChanged(index, t.num or 0)
      table.insert(Controller.dailSubsidy, index)
      UIManager:ClosePanel()
      local itemId = Controller.itemId_Dice
      UIManager:Open("UI/Monopoly/UI/Dice/DiceReward", Json.encode({
        diceNum = t.num or 0,
        itemId = itemId
      }))
    end
  end, index, function(json)
    MonopolyManager.CheckTimeIsOverAndBack()
  end)
end

function Controller.OnQuitBtnClick()
  if Controller.curSelectIndex == 1 then
    View.self:PlayAnim("DiceDay_Group_Reward_over", function()
      UIManager:ClosePanel()
    end)
  elseif Controller.curSelectIndex == 2 then
    View.self:PlayAnim("DiceDay_Group_Shop_over", function()
      UIManager:ClosePanel()
    end)
  end
end

function Controller.OnRewardBtnClick()
  View.self:PlayAnim("DiceDay_Group_Reward")
  Controller.curSelectIndex = 1
  View.Group_Reward:SetActive(true)
  View.Group_Shop:SetActive(false)
  View.Group_SwitchButton.Btn_Reward.Img_Active:SetActive(true)
  View.Group_SwitchButton.Btn_Shop.Img_Active:SetActive(false)
  Controller.RefreshContentShow()
end

function Controller.SetRewardTimeShow(getType, group)
  if not group then
    return
  end
  if getType == 1 then
    group.Group_Mask:SetActive(true)
    group.Group_Mask.Img_Received:SetActive(true)
    group.Group_Mask.Img_WrongTime:SetActive(false)
    group.Btn_Get.Img_Able:SetActive(false)
    group.Btn_Get.Img_Unable:SetActive(true)
    group.Btn_Get.Img_Unable.Txt_0:SetText(GetText(80607129))
  elseif getType == 2 then
    group.Group_Mask:SetActive(true)
    group.Group_Mask.Img_Received:SetActive(false)
    group.Group_Mask.Img_WrongTime:SetActive(true)
    group.Btn_Get.Img_Able:SetActive(false)
    group.Btn_Get.Img_Unable:SetActive(true)
    group.Btn_Get.Img_Unable.Txt_0:SetText(GetText(80609489))
  elseif getType == 3 then
    group.Group_Mask:SetActive(true)
    group.Group_Mask.Img_Received:SetActive(false)
    group.Group_Mask.Img_WrongTime:SetActive(true)
    group.Btn_Get.Img_Able:SetActive(false)
    group.Btn_Get.Img_Unable:SetActive(true)
    group.Btn_Get.Img_Unable.Txt_0:SetText(GetText(80609489))
  elseif getType == 4 then
    group.Group_Mask:SetActive(false)
    group.Btn_Get.Img_Able:SetActive(true)
    group.Btn_Get.Img_Unable:SetActive(false)
  end
end

function Controller.OnShopBtnClick()
  View.self:PlayAnim("DiceDay_Group_Shop")
  Controller.curSelectIndex = 2
  View.Group_Reward:SetActive(false)
  View.Group_Shop:SetActive(true)
  View.Group_SwitchButton.Btn_Reward.Img_Active:SetActive(false)
  View.Group_SwitchButton.Btn_Shop.Img_Active:SetActive(true)
  Controller.activityCA = PlayerData:GetFactoryData(Controller.activityId, "ActivityFactory")
  if not Controller.activityCA then
    return
  end
  local activityStoreList = Controller.activityCA.activityStoreList
  if not activityStoreList then
    return
  end
  local storeInfo = activityStoreList[1]
  local storeCA = PlayerData:GetFactoryData(storeInfo.id, "StoreFactory")
  if not storeCA then
    return
  end
  Controller.storeId = storeInfo.id
  Net:SendProto("shop.info", function(json)
    Controller.RefreshShopContent()
  end, Controller.storeId)
end

function Controller.RefreshShopContent()
  if not Controller.activityCA then
    return
  end
  local activityStoreList = Controller.activityCA.activityStoreList
  if not activityStoreList then
    return
  end
  local storeInfo = activityStoreList[1]
  local storeCA = PlayerData:GetFactoryData(storeInfo.id, "StoreFactory")
  if not storeCA then
    return
  end
  local shopList = storeCA.shopList or {}
  local normalDice = shopList[1]
  local superDice = shopList[2]
  if normalDice then
    local maxNum = Controller.GetNormalDiceLimitNum()
    View.Group_Shop.Img_Dice.Txt_Num:SetText(string.format(GetText(80609837), MonopolyManager.GetUserDiceNum(), maxNum))
    Controller.RefreshAShopItem(normalDice.id, View.Group_Shop.Img_Dice, 1, Controller.storeId)
  end
  if superDice then
    View.Group_Shop.Img_SuperDice.Txt_Num:SetText(string.format(GetText(80609835), MonopolyManager.GetTelecontrolDiceNum()))
    Controller.RefreshAShopItem(superDice.id, View.Group_Shop.Img_SuperDice, 2, Controller.storeId)
  end
end

function Controller.RefreshAShopItem(comId, viewGroup, index, storeId)
  local comCA = PlayerData:GetFactoryData(comId, "CommodityFactory")
  if comCA then
    viewGroup.Btn_Buy.Img_Icon:SetSprite(comCA.monetaryView)
    local costNum = 0
    local moneyList = comCA.moneyList or {}
    local info = moneyList[1]
    if info then
      costNum = info.moneyNum
    end
    viewGroup.Btn_Buy.Txt_Num:SetText(Controller.FormatNum(costNum))
    local itemList = comCA.commodityItemList or {}
    if itemList[1] then
      local itemCA = PlayerData:GetFactoryData(itemList[1].id, "ItemFactory")
      viewGroup.Img_Icon.Btn_Check:SetClickParam(itemList[1].id)
      viewGroup.Btn_Buy:SetClickFunction(function()
        Controller.OnBuyBtnClick(comId, index, storeId)
      end)
      if itemCA then
        viewGroup.Img_Icon:SetSprite(itemCA.iconPath)
        viewGroup.Txt_Name:SetText(itemCA.name)
      end
    end
    if comCA.purchase then
      local StoreDataModel = require("UIStore/UIStoreDataModel")
      local maxNum = StoreDataModel:GetPurchaseNum(comCA)
      local remainTime = maxNum - Controller.GetBuyCountByItemId(comId)
      viewGroup.Txt_Limit:SetText(string.format(GetText(80609836), remainTime, maxNum))
    else
      viewGroup.Txt_Limit:SetText("")
    end
  end
end

function Controller.FormatNum(num)
  if 10000 <= num then
    return tostring(math.floor(num / 1000)) .. "k"
  end
  return tostring(num)
end

function Controller.GetBuyCountByItemId(comId)
  if not Controller.activityCA then
    return 0
  end
  if PlayerData.ServerData.shops ~= nil then
    local shops = PlayerData.ServerData.shops[tostring(Controller.storeId)]
    if shops and shops.items then
      for c, d in pairs(shops.items) do
        if tonumber(d.id) == tonumber(comId) then
          return d.py_cnt
        end
      end
    end
  end
  return 0
end

function Controller.OnBuyBtnClick(comId, index, shopId)
  local comCA = PlayerData:GetFactoryData(comId, "CommodityFactory")
  if not comCA then
    return
  end
  local buyCount = Controller.GetBuyCountByItemId(comId) or 0
  local StoreDataModel = require("UIStore/UIStoreDataModel")
  local maxNum = StoreDataModel:GetPurchaseNum(comCA)
  local remainTime = maxNum - buyCount
  local isResidual = remainTime <= 0
  if isResidual then
    CommonTips.OpenTips(80602917)
    return
  end
  if index == 1 then
    local maxNum = Controller.GetNormalDiceLimitNum()
    local hasNum = MonopolyManager.GetUserDiceNum()
    local canNum = maxNum - hasNum
    remainTime = remainTime < canNum and remainTime or canNum
    if canNum <= 0 then
      CommonTips.OpenTips(80609906)
      return
    end
  end
  local parmas = {}
  parmas.index = index - 1
  parmas.shopid = shopId
  parmas.id = comId
  parmas.residue = 0 <= remainTime and remainTime or 0
  parmas.isMonopoly = true
  
  local function callBack()
    Controller.RefreshShopContent()
  end
  
  CommonTips.OpenBuyTips(parmas, callBack)
end

function Controller.OnBuySuccess(index, num)
  if index == 0 then
    MonopolyManager.AddUserDiceNum(num)
  elseif index == 1 then
    MonopolyManager.AddTelecontrolDiceNum(num)
  end
end

function Controller.GetNormalDiceLimitNum()
  local maxNum = 0
  local monopolyInfo = PlayerData:GetFactoryData(PlayerData.GetMonopolyControlId(), "MapControlFactory")
  if monopolyInfo then
    maxNum = monopolyInfo.diceLimit or 0
  end
  return maxNum
end

return Controller
