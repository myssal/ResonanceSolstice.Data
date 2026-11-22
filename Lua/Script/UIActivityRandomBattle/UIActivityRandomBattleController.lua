local View = require("UIActivityRandomBattle/UIActivityRandomBattleView")
local DataModel = require("UIActivityRandomBattle/UIActivityRandomBattleDataModel")
local BtnItem = require("Common/BtnItem")
local Controller = {}

function Controller:Init(param)
  if param then
    DataModel.activityCA = PlayerData:GetFactoryData(param.activityId)
  end
  View.Group_Main.Img_Logo:SetSprite(GetResPath(88300126))
  View.Group_Main.Btn_Shop:SetSprite(GetResPath(88300153))
  local configCA = PlayerData:GetFactoryData(99900113)
  DataModel.configCA = configCA
  local needLv = configCA.randomBattleLv
  local isLvRecive = needLv <= PlayerData:GetPlayerLevel()
  View.Group_Main.Group_Lv.self:SetActive(not isLvRecive)
  if not isLvRecive then
    View.Group_Main.Group_Lv.Txt_Num:SetText(needLv)
  end
  local isInTime = Controller:JudgeInTime()
  View.Group_Main.Group_Out.self:SetActive(isLvRecive and not isInTime)
  if isLvRecive and isInTime then
    DataModel.RandomData = nil
    Net:SendProto("battle.melee", function(json)
      if json ~= nil and json.melee ~= nil and next(json.melee) ~= nil and json.melee.rb_id ~= nil and json.melee.rb_id ~= "" then
        local melee = json.melee
        Controller:InitServerData(melee)
        View.Group_Main.Btn_Enter:SetActive(true)
        View.Group_Main.Btn_Start:SetActive(false)
        local passCount = 0
        for i = 1, #melee.pre_levels do
          if melee.pre_levels[i].status == 1 then
            passCount = passCount + 1
          end
        end
        PlayerData.ServerData.rb_id = melee.rb_id
        View.Group_Main.Btn_Enter.Txt_Num:SetText(passCount .. "/" .. #melee.pre_levels)
      else
        if json ~= nil and json.melee ~= nil and json.melee.item_cnt ~= nil then
          local melee = json.melee
          Controller:InitServerData(melee)
        end
        View.Group_Main.Btn_Enter:SetActive(false)
        View.Group_Main.Btn_Start:SetActive(true)
      end
    end)
    local isTicketGet = TimeUtil:GetServerTimeStamp() >= (tonumber(PlayerData:GetPlayerPrefs("string", "RandBattleTicket_timeStamp", true)) or 0)
    if isTicketGet then
      PlayerData:SetPlayerPrefs("string", "RandBattleTicket_timeStamp", tostring(TimeUtil:GetNextSpecialTimeStamp(5, 0, 0, TimeUtil:GetServerTimeStamp())), true)
      CommonTips.OpenShowItem({
        items = {
          [tostring(DataModel.configCA.randomBattleTicketId)] = {num = 1}
        }
      }, nil, nil, true)
      if PlayerData.TempCache.rbTicketRefresh == nil then
        PlayerData.TempCache.rbTicketRefresh = PlayerData.ServerData.login_time
      end
      local refreshTime = TimeUtil:GetNextSpecialTimeStamp(5, 0, 0, PlayerData.TempCache.rbTicketRefresh)
      if refreshTime <= TimeUtil:GetServerTimeStamp() then
        PlayerData.TempCache.rbTicketRefresh = TimeUtil:GetServerTimeStamp()
        local useItem = {
          [DataModel.configCA.randomBattleTicketId] = -1
        }
        PlayerData:RefreshUseItems(useItem)
        Controller:RefreshCoin()
      end
    end
  else
    View.Group_Main.Btn_Enter:SetActive(false)
    View.Group_Main.Btn_Start:SetActive(false)
  end
  View.Group_Cost.self:SetActive(false)
  local coinCA = PlayerData:GetFactoryData(configCA.randomBattleCoinId)
  local coinNum = math.min(PlayerData:GetGoodsById(coinCA.id).num, 9999)
  View.Group_Main.Group_CommomBottomLeft.Group_Score.Img_Icon:SetSprite(coinCA.iconPath)
  View.Group_Main.Group_CommomBottomLeft.Group_Score.Txt_Num:SetText(string.format("%04d", coinNum))
  Controller:RefreshCoin()
  DataModel.previewRewardList = DataModel.activityCA.rewardPreviewList
  View.Group_Main.Group_Preview.ScrollGrid_Reward.grid.self:SetDataCount(#DataModel.previewRewardList)
  View.Group_Main.Group_Preview.ScrollGrid_Reward.grid.self:RefreshAllElement()
end

function Controller:RefreshCoin()
  local ticketCA = PlayerData:GetFactoryData(DataModel.configCA.randomBattleTicketId)
  local ticketNum = math.min(PlayerData:GetGoodsById(ticketCA.id).num, 9999)
  View.Group_Main.Group_CommomBottomLeft.Group_Ticket.Img_Icon:SetSprite(ticketCA.iconPath)
  View.Group_Main.Group_CommomBottomLeft.Group_Ticket.Txt_Num:SetText(string.format("%04d", ticketNum))
end

function Controller:OnSetPreviewGrid(element, elementIndex)
  local data = DataModel.previewRewardList[elementIndex]
  BtnItem:SetActivityPreviewItem(element.Group_Item, data)
  element.Group_Item.Btn_Item:SetClickParam(data.id)
end

function Controller:RewardClickElemnt(id)
  CommonTips.OpenPreRewardDetailTips(id)
end

function Controller:JudgeInTime()
  local curTime = TimeUtil:GetServerTimeStamp()
  for k, v in pairs(PlayerData:GetFactoryData(99900013).holidayList) do
    local timeStamp = TimeUtil:TimeStamp(v.day .. " 05:00:00")
    if 0 < curTime - timeStamp and curTime - timeStamp <= 86400 then
      return true
    end
  end
  return false
end

function Controller:InitServerData(melee)
  DataModel.RandomData = melee
end

function Controller:GetServerData()
  return DataModel.RandomData
end

function Controller:GetServerChoiceData()
  local rt = {}
  if DataModel.RandomData ~= nil and DataModel.RandomData.choice ~= nil then
    rt = DataModel.RandomData.choice
  end
  return rt
end

function Controller:OnBtnEnter()
  if not Controller:JudgeInTime() then
    Controller:Init()
    return
  end
  Controller:OpenLevelPanel()
end

function Controller:OnBtnStart()
  if not Controller:JudgeInTime() then
    Controller:Init()
    return
  end
  if PlayerData:GetGoodsById(DataModel.configCA.randomBattleTicketId).num >= DataModel.configCA.randomBattleTicketCost or DataModel.configCA.randomBattleCostCount > Controller:GetRemainCostTime() then
    Controller:OpenGroupStart()
  else
    CommonTips.OpenTips(80610005)
  end
end

function Controller:OpenGroupStart()
  View.Group_Start.self:SetActive(true)
  local ticketNum = math.tointeger(math.floor(PlayerData:GetGoodsById(DataModel.configCA.randomBattleTicketId).num / DataModel.configCA.randomBattleTicketCost))
  local remainCostTime = DataModel.configCA.randomBattleCostCount - Controller:GetRemainCostTime()
  local maxCostTime = remainCostTime
  for i = 1, #DataModel.configCA.randomBattleCost do
    local costData = DataModel.configCA.randomBattleCost[i]
    if PlayerData:GetGoodsById(costData.id).num > costData.num then
      local curNum = math.tointeger(math.floor(PlayerData:GetGoodsById(costData.id).num / costData.num))
      maxCostTime = math.min(maxCostTime, curNum)
    end
  end
  local maxNum = ticketNum + maxCostTime
  maxNum = math.min(maxNum, DataModel.configCA.randomBattleTicketMax)
  View.Group_Start.Group_Slider.Group_Num.Txt_Possess:SetText(maxNum)
  View.Group_Start.Group_Slider.Slider_Value:SetMinAndMaxValue(1, maxNum)
  if maxNum <= 0 then
    CommonTips.OpenTips(80609595)
    return
  end
  DataModel.ticketNum = ticketNum
  DataModel.remainCostTime = remainCostTime
  DataModel.maxTime = maxNum
  DataModel.curCostNum = 1
  Controller:RefreshGroupStart()
end

function Controller:RefreshGroupStart()
  if DataModel.curCostNum == nil or DataModel.ticketNum == nil then
    return
  end
  View.Group_Start.Group_Slider.Group_Num.Txt_Select:SetText(DataModel.curCostNum)
  View.Group_Start.Group_Slider.Slider_Value:SetSliderValue(DataModel.curCostNum)
  if DataModel.curCostNum > DataModel.ticketNum then
    View.Group_Start.Group_Middle.self:SetActive(true)
    View.Group_Start.Group_Middle.Txt_Count:SetText(string.format(GetText(80609974), DataModel.remainCostTime))
    View.Group_Start.Group_Middle.ScrollGrid_Dikuang.grid.self:SetDataCount(#DataModel.configCA.randomBattleCost)
    View.Group_Start.Group_Middle.ScrollGrid_Dikuang.grid.self:RefreshAllElement()
  else
    View.Group_Start.Group_Middle.self:SetActive(false)
  end
end

function Controller:CloseGroupStart()
  View.Group_Start.self:SetActive(false)
end

function Controller:AddNum()
  DataModel.curCostNum = math.min(DataModel.curCostNum + 1, DataModel.maxTime)
  Controller:RefreshGroupStart()
end

function Controller:SubNum()
  DataModel.curCostNum = math.max(DataModel.curCostNum - 1, 1)
  Controller:RefreshGroupStart()
end

function Controller:MaxNum()
  DataModel.curCostNum = DataModel.maxTime
  Controller:RefreshGroupStart()
end

function Controller:MinNum()
  DataModel.curCostNum = 1
  Controller:RefreshGroupStart()
end

function Controller:SetNum(num)
  DataModel.curCostNum = num
  Controller:RefreshGroupStart()
end

function Controller:GetRemainCostTime()
  if DataModel.RandomData == nil then
    return 0
  end
  return DataModel.RandomData.item_cnt
end

function Controller:ShowCostPanel()
  View.Group_Cost.self:SetActive(true)
  View.Group_Cost.Group_Middle.ScrollGrid_Dikuang.grid.self:SetDataCount(#DataModel.configCA.randomBattleCost)
  View.Group_Cost.Group_Middle.ScrollGrid_Dikuang.grid.self:RefreshAllElement()
  View.Group_Cost.Group_Middle.Txt_Count:SetText(string.format(GetText(80609974), DataModel.configCA.randomBattleCostCount - Controller:GetRemainCostTime()))
end

function Controller:OnSetCostGrid(element, elementIndex)
  local costData = DataModel.configCA.randomBattleCost[elementIndex]
  BtnItem:SetItem(element.Img_Dikuang.Group_Item, {
    id = costData.id,
    num = 1,
    isfirst = false
  })
  local haveNum = PlayerData:GetGoodsById(costData.id).num
  local needNum = costData.num * (DataModel.curCostNum - DataModel.ticketNum)
  element.Img_Dikuang.Group_Cost.Txt_Have:SetText(PlayerData:NumToFormatString(haveNum, 1))
  element.Img_Dikuang.Group_Cost.Txt_Need:SetText(PlayerData:NumToFormatString(needNum, 1))
  if haveNum < needNum then
    element.Img_Dikuang.Group_Cost.Txt_Have:SetColor(UIConfig.Color.Red)
  else
    element.Img_Dikuang.Group_Cost.Txt_Have:SetColor(UIConfig.Color.White)
  end
end

function Controller:OpenLevelPanel()
  UIManager:Open("UI/Activity/ActivityRandomBattle/RandomLevel", Json.encode(DataModel.RandomData))
end

function Controller:OnBtnCostConfirm()
  for i = 1, #DataModel.configCA.randomBattleCost do
    local costData = DataModel.configCA.randomBattleCost[i]
    if PlayerData:GetGoodsById(costData.id).num < costData.num then
      CommonTips.OpenTips(80609595)
      return
    end
  end
  Controller:OnInitMeleeAndOpenChoose(1)
end

function Controller:OnInitMeleeAndOpenChoose()
  Net:SendProto("battle.init_melee", function(json)
    local useItem = {}
    useItem[DataModel.configCA.randomBattleTicketId] = DataModel.configCA.randomBattleTicketCost * math.min(DataModel.curCostNum, DataModel.ticketNum)
    if DataModel.curCostNum > DataModel.ticketNum then
      for i = 1, #DataModel.configCA.randomBattleCost do
        local costData = DataModel.configCA.randomBattleCost[i]
        useItem[costData.id] = costData.num * (DataModel.curCostNum - DataModel.ticketNum)
      end
    end
    PlayerData:RefreshUseItems(useItem)
    local melee = json.melee
    PlayerData.ServerData.rb_id = melee.rb_id
    Controller:InitServerData(melee)
    Controller:OpenLevelPanel()
  end, DataModel.curCostNum)
end

function Controller:OnBtnCostCancle()
  View.Group_Cost.self:SetActive(false)
end

function Controller:OpenRandomBattleStore()
  local parms = {}
  parms.activityId = 86000037
  local activityCA = PlayerData:GetFactoryData(parms.activityId)
  parms.shopId = activityCA.activityStoreList[1].id
  Net:SendProto("shop.info", function(json)
    UIManager:Open("UI/Activity/ActivityRandomBattle/RandomBattleStore", Json.encode(parms))
  end)
end

return Controller
