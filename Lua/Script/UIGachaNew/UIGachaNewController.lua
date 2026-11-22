local DataModel = require("UIGachaNew/UIGachaNewDataModel")
local View = require("UIGachaNew/UIGachaNewView")
local Top
local Controller = {}
local CommonItem = require("Common/BtnItem")
local selectedTabX = 10

function Controller:Init()
  Top = {
    {
      id = 11400007,
      key = 11400007,
      view = View.Group_Currency.Group_Onepull
    },
    {
      id = 11400005,
      key = "bm_rock",
      view = View.Group_Currency.Group_Diamond
    }
  }
  selectedTabX = PlayerData:GetFactoryData(99900001).extractTabX or 10
  self.selectedTabX = selectedTabX
end

function Controller:RefreshTop()
  for i, v in ipairs(Top) do
    if i == 1 then
      local id = DataModel.CardPool[DataModel.TabIndex][DataModel.Index].data.id
      local costList = PlayerData:GetFactoryData(id).costList
      local itemId = costList[#costList].id
      local itemCA = PlayerData:GetFactoryData(itemId)
      local num = PlayerData:GetGoodsById(itemId).num
      v.view.Txt_Num:SetText(num)
      v.view.Img_Icon:SetSprite(itemCA.buyPath)
    else
      local num = PlayerData:GetSpecialCurrencyById(v.key)
      v.view.Txt_Num:SetText(num)
    end
  end
end

function Controller:GetIndex(id)
  DataModel:GetCardPool()
  id = tonumber(id)
  for i, v in ipairs(DataModel.CardPool) do
    for i1, v1 in ipairs(v) do
      if id == v1.data.id then
        return i, i1
      end
    end
  end
  return 1, 1
end

function Controller:RefreshTab(tabIndex, index)
  DataModel.Index = index
  DataModel.BgIndex = nil
  local data = DataModel.CardPool[tabIndex][index]
  if data == nil then
    return
  end
  DataModel.anecdoteQuestId = data.data.anecdoteQuestId
  if data.red then
    DataModel.SavePoolRedPoint(tabIndex, index)
    if data.data.isActBanner then
      DataModel:SetCardGachaRed(data.data.id, 10)
    end
  end
  local tabScroll, Img_Remind
  if tabIndex == DataModel.TabType.Activaty then
    tabScroll = View.ScrollView_Tab.Viewport.Content.ScrollGrid_Activaty
    Img_Remind = View.ScrollView_Tab.Viewport.Content.Btn_Activity.Img_Remind
  elseif tabIndex == DataModel.TabType.Plot then
    tabScroll = View.ScrollView_Tab.Viewport.Content.ScrollGrid_Plot
    Img_Remind = View.ScrollView_Tab.Viewport.Content.Btn_Plot.Img_Remind
  elseif tabIndex == DataModel.TabType.Permanent then
    tabScroll = View.ScrollView_Tab.Viewport.Content.ScrollGrid_Permanent
    Img_Remind = View.ScrollView_Tab.Viewport.Content.Btn_Permanent.Img_Remind
  end
  local tabGrid = tabScroll.grid.self
  local isShowRed = false
  for i, v in ipairs(DataModel.CardPool[tabIndex]) do
    isShowRed = isShowRed or v.red
  end
  Img_Remind:SetActive(isShowRed)
  tabGrid:RefreshAllElement()
  View.Img_BG:SetSprite(DataModel.CardPool[tabIndex][index].data.imageBg)
end

function Controller:OpenSelectRoleTip(index)
  local cardPool = DataModel.CardPool[DataModel.TabIndex][DataModel.Index]
  local data = cardPool.data
  local cfg = PlayerData:GetFactoryData(data.id, "ExtractFactory")
  local params = {
    id = cfg.btnList[index].id
  }
  CommonTips.OpenUnitDetail(params)
end

function Controller:ClickTabBtn(tabType, index, force)
  if not force and tabType == DataModel.TabIndex then
    tabType = tabType + 1
    if tabType > table.count(DataModel.TabType) then
      tabType = 1
    end
    while DataModel.CardPool[tabType] == nil or #DataModel.CardPool[tabType] == 0 do
      tabType = tabType + 1
      if tabType > table.count(DataModel.TabType) then
        tabType = 1
      end
      if tabType == DataModel.TabIndex then
        return
      end
    end
  end
  DataModel:GetCardPool()
  if tabType == nil then
    tabType = 1
    while DataModel.CardPool[tabType] ~= nil and #DataModel.CardPool[tabType] == 0 do
      tabType = tabType + 1
    end
    if DataModel.CardPool[tabType] == nil or #DataModel.CardPool[tabType] == 0 then
      CommonTips.OpenTips("Tab Data Error!")
      return
    end
  end
  View.ScrollView_Tab.Viewport.Content.Btn_Activity.Txt_Tab.Img_Selected:SetActive(tabType == DataModel.TabType.Activaty)
  View.ScrollView_Tab.Viewport.Content.Btn_Permanent.Txt_Tab.Img_Selected:SetActive(tabType == DataModel.TabType.Permanent)
  View.ScrollView_Tab.Viewport.Content.Btn_Plot.Txt_Tab.Img_Selected:SetActive(tabType == DataModel.TabType.Plot)
  if index == nil then
    index = 1
  end
  local count = #DataModel.CardPool[tabType]
  if index > count then
    index = count
  end
  self:RefreshMain(tabType, index)
  if 0 < count then
    View.NewPage_PoolList.grid.self:LocatElementImmediate(index - 1)
    Controller:PlayAnimeByIndex(tabType, index)
  end
end

function Controller:RefreshMain(tabIndex, index)
  local grid = View.NewPage_PoolList.grid.self
  DataModel.TabIndex = tabIndex
  DataModel.Index = index or 1
  local count = #DataModel.CardPool[tabIndex]
  View.ScrollView_Tab.Viewport.Content.ScrollGrid_Activaty.self:SetActive(tabIndex == DataModel.TabType.Activaty and 0 < count)
  View.ScrollView_Tab.Viewport.Content.ScrollGrid_Plot.self:SetActive(tabIndex == DataModel.TabType.Plot and 0 < count)
  View.ScrollView_Tab.Viewport.Content.ScrollGrid_Permanent.self:SetActive(tabIndex == DataModel.TabType.Permanent and 0 < count)
  View.NewPage_PoolList.self:SetActive(0 < count)
  if count <= 0 then
    return
  end
  grid:SetDataCount(count)
  grid:RefreshAllElement()
  local tabScroll
  if tabIndex == DataModel.TabType.Activaty then
    tabScroll = View.ScrollView_Tab.Viewport.Content.ScrollGrid_Activaty
  elseif tabIndex == DataModel.TabType.Plot then
    tabScroll = View.ScrollView_Tab.Viewport.Content.ScrollGrid_Plot
  elseif tabIndex == DataModel.TabType.Permanent then
    tabScroll = View.ScrollView_Tab.Viewport.Content.ScrollGrid_Permanent
  end
  local tabGrid = tabScroll.grid.self
  tabGrid:SetDataCount(count)
  tabGrid:MoveToTop()
  tabGrid:RefreshAllElement()
  if index > count then
    index = count
  end
  local maxHeight = 800
  local curHeight = 0
  if 0 < index then
    curHeight = count * 113
  end
  if maxHeight < curHeight then
    tabScroll.self:SetHeight(maxHeight)
    tabGrid.ScrollRect.enabled = true
  else
    tabScroll.self:SetHeight(curHeight)
    tabGrid.ScrollRect.enabled = false
  end
  self:RefreshTab(tabIndex, index)
  self:RefreshTop()
end

function Controller:RefreshBg(index)
  local data = DataModel.CardPool[DataModel.TabIndex][index]
  if data == nil then
    return
  end
  local spineUrl = data.data.spineBg
  View.SpineSecondMode_BG:SetActive(false)
  if spineUrl ~= "" then
    View.Img_BG:SetActive(false)
    View.SpineSecondMode_BG:SetPrefab(spineUrl)
    View.SpineSecondMode_BG:SetLocalScale(Vector3(1, 1, 1))
    View.SpineSecondMode_BG:SetLocalPosition(Vector3(DataModel.CardPool[DataModel.TabIndex][index].data.spineX, DataModel.CardPool[DataModel.TabIndex][index].data.spineY, 0))
    View.SpineSecondMode_BG:SetActive(true)
  else
    View.SpineSecondMode_BG:SetPrefab("")
    View.Img_BG:SetSprite(DataModel.CardPool[DataModel.TabIndex][index].data.imageBg)
    View.Img_BG:SetActive(true)
  end
end

function Controller:ShowBuyItem(type, data)
  local item = {}
  local isEnough, cost
  local cacheIndex = -1
  DataModel.ItemLimitTime = -1
  if type == EnumDefine.DrawCard.One then
    cost = data.costList
    cacheIndex = data.costIndex
  else
    cost = data.costTenList
    cacheIndex = data.costTenIndex
  end
  if cacheIndex then
    local v = cost[cacheIndex]
    local goodsInfo = PlayerData:GetGoodsById(v.id)
    if goodsInfo.endTime and goodsInfo.num < v.num then
      Controller:RefreshMain(DataModel.Index)
      CommonTips.OpenTips(80610009)
      return
    end
    if goodsInfo.num >= v.num and not isEnough then
      DataModel.ItemLimitTime = goodsInfo.endTime or -1
      item[v.id] = v.num
      isEnough = true
    end
    if not isEnough then
      item[v.id] = v.num
    end
  else
    for i, v in ipairs(cost) do
      if PlayerData:GetGoodsById(v.id).num >= v.num and not isEnough then
        item[v.id] = v.num
        isEnough = true
      end
      if i == #cost and not isEnough then
        item[v.id] = v.num
      end
    end
  end
  DataModel.CommodityId = data.commodityId
  DataModel.GachaType = type
  DataModel.DataIDPool = {
    id = tostring(data.id),
    item = item,
    name = data.name
  }
  DataModel.IsEnough = false
  if isEnough then
    DataModel.IsEnough = isEnough
    for i, v in pairs(item) do
      CommonItem:SetItem(View.Group_BuyItem.Group_Middle.Group_Item1, {
        id = i,
        num = PlayerData:GetGoodsById(i).num
      })
      CommonItem:SetItem(View.Group_BuyItem.Group_Middle.Group_Item2, {
        id = i,
        num = PlayerData:GetGoodsById(i).num - v
      })
      local commodity = PlayerData:GetFactoryData(i, "CommodityFactory")
      View.Group_BuyItem.Group_Middle.Txt_Des:SetText(StringFormat(GetText(80600520), v, commodity.name))
    end
    View.Group_BuyItem.Group_Middle.Txt_Have:SetActive(false)
  else
    for i, v in pairs(item) do
      local priceId = 11400005
      local needNum = v - PlayerData:GetGoodsById(i).num
      CommonItem:SetItem(View.Group_BuyItem.Group_Middle.Group_Item2, {id = i, num = needNum})
      local commodity = PlayerData:GetFactoryData(i, "CommodityFactory")
      local priceCfg = PlayerData:GetFactoryData(data.commodityId, "CommodityFactory")
      local price = priceCfg.moneyList[1].moneyNum * needNum
      DataModel.Price = price
      CommonItem:SetItem(View.Group_BuyItem.Group_Middle.Group_Item1, {
        id = priceId,
        num = DataModel.Price
      })
      DataModel.NeedNum = needNum
      DataModel.MoneyNum = PlayerData:GetGoodsById(priceId).num
      local item = PlayerData:GetFactoryData(priceId)
      View.Group_BuyItem.Group_Middle.Txt_Des:SetText(string.format(GetText(80600500), price, item.name, needNum, commodity.name))
    end
    View.Group_BuyItem.Group_Middle.Txt_Have:SetText(string.format(GetText(80600521), DataModel.MoneyNum))
    View.Group_BuyItem.Group_Middle.Txt_Have:SetActive(true)
  end
  View.Group_BuyItem.self:SetActive(true)
end

local function TimeFree(timeTable)
  if timeTable.hour > 0 then
    return string.format(GetText(80600002), timeTable.hour, timeTable.minute)
  end
  if 0 < timeTable.minute then
    return string.format(GetText(80600003), timeTable.minute)
  end
  if 0 < timeTable.second then
    return string.format(GetText(80600004), timeTable.second)
  end
  return "0"
end

function Controller:SetBasicPage(element, elementIndex)
  local cardPool = DataModel.CardPool[DataModel.TabIndex][elementIndex]
  local data = cardPool.data
  element.Group_Card.Group_Front.Group_Basic.Group_TenPulls.BtnPolygon_TenPulls.self:SetClickParam(elementIndex)
  element.Group_Card.Group_Front.Group_Basic.Group_OnePull.BtnPolygon_OnePull.self:SetClickParam(elementIndex)
  local Ten_Img_Cost = element.Group_Card.Group_Front.Group_Basic.Group_TenPulls.Img_Cost
  local len = #data.costTenList
  for i, v in ipairs(data.costTenList) do
    if PlayerData:GetGoodsById(v.id).num >= v.num or i == len then
      local item = PlayerData:GetFactoryData(v.id, "ItemFactory")
      Ten_Img_Cost.Img_Icon:SetSprite(item.buyPath)
      Ten_Img_Cost.Txt_Item:SetText("\195\151" .. v.num)
      data.costTenIndex = i
      break
    end
  end
  local Group_OnePull = element.Group_Card.Group_Front.Group_Basic.Group_OnePull
  if data.freeCD ~= 0 then
    if cardPool.server and (not cardPool.server.free_last_countdown or TimeUtil:GetServerTimeStamp() >= tonumber(cardPool.server.free_last_countdown)) then
      Group_OnePull.Img_Cost.self:SetActive(false)
      Group_OnePull.Img_Free.self:SetActive(true)
      if cardPool.detail.timeFunc1 ~= nil then
        EventManager:RemoveOnSecondEvent(cardPool.detail.timeFunc1)
        cardPool.detail.timeFunc1 = nil
      end
    else
      Group_OnePull.Img_Cost.self:SetActive(true)
      Group_OnePull.Img_Free.self:SetActive(false)
      if tonumber(cardPool.server.free_last_countdown) > TimeUtil:GetServerTimeStamp() then
        local function testFunc()
          if tonumber(cardPool.server.free_last_countdown) <= TimeUtil:GetServerTimeStamp() then
            Group_OnePull.Img_Cost.self:SetActive(false)
            
            Group_OnePull.Img_Free.self:SetActive(true)
            if cardPool.detail.timeFunc1 ~= nil then
              EventManager:RemoveOnSecondEvent(cardPool.detail.timeFunc1)
              cardPool.detail.timeFunc1 = nil
            end
            return
          end
          local time = TimeUtil:SecondToTable(tonumber(cardPool.server.free_last_countdown) - TimeUtil:GetServerTimeStamp())
          Group_OnePull.Img_Cost.Txt_Free:SetText(TimeFree(time))
        end
        
        if cardPool.detail.timeFunc1 == nil then
          cardPool.detail.timeFunc1 = testFunc
          EventManager:AddOnSecondEvent(cardPool.detail.timeFunc1)
        end
        Group_OnePull.Img_Cost.Txt_Free:SetActive(true)
      end
      local len = #data.costList
      for i, v in ipairs(data.costList) do
        if PlayerData:GetGoodsById(v.id).num >= v.num or i == len then
          local item = PlayerData:GetFactoryData(v.id, "ItemFactory")
          Group_OnePull.Img_Cost.Img_Icon:SetSprite(item.buyPath)
          Group_OnePull.Img_Cost.Txt_Item:SetText("\195\151" .. v.num)
          data.costIndex = i
          break
        end
      end
    end
  else
    Group_OnePull.Img_Cost.self:SetActive(true)
    Group_OnePull.Img_Free.self:SetActive(false)
    local len = #data.costList
    for i, v in ipairs(data.costList) do
      if PlayerData:GetGoodsById(v.id).num >= v.num or i == len then
        local item = PlayerData:GetFactoryData(v.id, "ItemFactory")
        Group_OnePull.Img_Cost.Img_Icon:SetSprite(item.buyPath)
        Group_OnePull.Img_Cost.Txt_Item:SetText("\195\151" .. v.num)
        data.costIndex = i
        break
      end
    end
  end
  element.Group_Card.Group_Front.Group_TimeLimit.self:SetActive(false)
  local startTime = ""
  local endTime = ""
  if cardPool.gachaServer and cardPool.gachaServer.deadline == "" and cardPool.gachaServer.start_ts == "" then
  elseif cardPool.gachaServer and cardPool.gachaServer.deadline > -1 then
    element.Group_Card.Group_Front.Group_TimeLimit.self:SetActive(true)
    startTime = os.date("*t", cardPool.gachaServer.start_ts)
    endTime = os.date("*t", cardPool.gachaServer.deadline)
    local str = string.format(GetText(80600005), startTime.year, startTime.month, startTime.day, startTime.hour .. ":" .. (startTime.min < 10 and "0" .. startTime.min or startTime.min), endTime.year, endTime.month, endTime.day, endTime.hour .. ":" .. (endTime.min < 10 and "0" .. endTime.min or endTime.min))
    element.Group_Card.Group_Front.Group_TimeLimit.Txt_CutOffTime:SetText(str)
  elseif data.endTime ~= "" then
    element.Group_Card.Group_Front.Group_TimeLimit.self:SetActive(true)
    startTime = TimeUtil:GetTimeTable(data.startTime)
    endTime = TimeUtil:GetTimeTable(data.endTime)
    local str = string.format(GetText(80600005), startTime.year, startTime.month, startTime.day, startTime.hour .. ":" .. startTime.minute, endTime.year, endTime.month, endTime.day, endTime.hour .. ":" .. endTime.minute)
    element.Group_Card.Group_Front.Group_TimeLimit.Txt_CutOffTime:SetText(str)
  end
  element.Group_Card.Group_Front.Group_Basic.Group_Normal.self:SetActive(data.endTime == "")
  if cardPool.detail.timeFunc == nil and data.endTime ~= "" then
    local function testFunc1(isFirst)
      local lastTime = ""
      
      local time = ""
      if cardPool.gachaServer and cardPool.gachaServer.deadline > -1 then
        lastTime = cardPool.gachaServer.deadline - TimeUtil:GetServerTimeStamp()
        time = TimeUtil:SecondToTable(lastTime)
      else
        lastTime = TimeUtil:LastTime(data.endTime)
        time = TimeUtil:SecondToTable(lastTime)
      end
      if DataModel.Index == elementIndex or isFirst then
        element.Group_Card.Group_Front.Group_TimeLimit.Txt_RemainingTime:SetText(TimeUtil:GetGachaDesc(time))
      end
      if lastTime == 0 and cardPool.detail.timeFunc ~= nil then
        EventManager:RemoveOnSecondEvent(cardPool.detail.timeFunc)
        cardPool.detail.timeFunc = nil
        if DataModel.Index == elementIndex then
          Controller:RefreshMain(DataModel.TabIndex, 1)
          View.NewPage_PoolList.grid.self:LocatElementImmediate(0)
          Controller:PlayAnimeByIndex(DataModel.TabIndex, 1)
        else
          local tabIndex, index = Controller:GetIndex(data.id)
          Controller:RefreshMain(tabIndex, index)
          View.NewPage_PoolList.grid.self:LocatElementImmediate(index - 1)
          Controller:PlayAnimeByIndex(tabIndex, index)
        end
      end
    end
    
    testFunc1(true)
    cardPool.detail.timeFunc = testFunc1
    EventManager:AddOnSecondEvent(cardPool.detail.timeFunc)
  end
  element.Group_Card.Group_Front.Group_Basic.Txt_Name:SetText(data.name)
end

function Controller:OnRecvDoRecruit(info, drawNum)
  info.drawNum = drawNum
  GachaGV:SetLastDrawInfos(info)
end

function Controller:SetNewbiePage(element, elementIndex)
  local cardPool = DataModel.CardPool[DataModel.TabIndex][elementIndex]
  local data = cardPool.data
  local groupNewbie = element.Group_Card.Group_Front.Group_Newbie
  local imgCost = groupNewbie.Img_Cost
  for i, v in ipairs(data.costTenList) do
    if PlayerData:GetGoodsById(v.id).num > 0 or i == #data.costTenList then
      local item = PlayerData:GetFactoryData(v.id, "ItemFactory")
      imgCost.Img_Icon:SetSprite(item.buyPath)
      imgCost.Txt_Item:SetText("\195\151" .. v.num)
      break
    end
  end
  local poolData = PlayerData.ServerData.cards[tostring(data.id)]
  local poolNum = 0
  if poolData ~= nil then
    poolNum = poolData.pool_num or 0
  end
  if data.closeNum == nil then
    error("\229\141\161\230\177\160id: " .. data.id .. " \233\133\141\231\189\174\231\188\186\229\176\145\229\173\151\230\174\181'closeNum'")
  end
  groupNewbie.Group_Num.Txt_Num:SetText(string.format(GetText(80602001), data.closeNum - poolNum, data.closeNum))
  groupNewbie.Btn_TenPulls.self:SetClickParam(elementIndex)
end

function Controller:OpenTryLevel(levelId)
  local status = {
    Current = "College",
    squadIndex = PlayerData.BattleInfo.squadIndex,
    hasOpenThreeView = false
  }
  PlayerData.BattleInfo.battleStageId = levelId
  PlayerData.BattleCallBackPage = "UI/Gacha/GachaNew"
  PlayerData.Last_GachaId = DataModel.CardPool[DataModel.TabIndex][DataModel.Index].data.id
  UIManager:Open("UI/Squads/Squads", Json.encode(status))
end

function Controller:PlayAnimeByIndex(tabIndex, index)
  local listX = View.NewPage_PoolList.self.pageNewController.ScrollRect.content.anchoredPosition.x
  for i = 1, #View.NewPage_PoolList.grid do
    local grid = View.NewPage_PoolList.grid[i]
    if grid.transform.anchoredPosition.x == -listX then
      grid.self:SelectPlayAnim("")
      grid.self:SelectPlayAnim(DataModel.CardPool[tabIndex][index].data.animName)
    end
  end
end

function Controller:RefreshTabElement(element, elementIndex)
  local data = DataModel.CardPool[DataModel.TabIndex][elementIndex].data
  local btn = element.Btn_Tab
  btn:SetClickParam(elementIndex)
  btn.Txt_Name:SetText(data.tabName)
  btn.self:SetSprite(data.tabPath)
  element.Btn_Tab.Img_Remind:SetActive(DataModel.CardPool[DataModel.TabIndex][elementIndex].red)
  if elementIndex == DataModel.Index then
    element.Btn_Tab.Img_Selected:SetActive(true)
    element.Btn_Tab.Img_Unselected:SetActive(false)
    element.Btn_Tab:SetAnchoredPositionX(Controller.selectedTabX)
  else
    element.Btn_Tab.Img_Selected:SetActive(false)
    element.Btn_Tab.Img_Unselected:SetActive(true)
    element.Btn_Tab:SetAnchoredPositionX(0)
  end
end

function Controller:ClickTabElement(btn, str)
  local elementIndex = tonumber(str)
  if elementIndex == DataModel.Index then
    return
  end
  local isAnime = elementIndex ~= DataModel.Index
  View.NewPage_PoolList.grid.self:LocatElementImmediate(elementIndex - 1)
  if isAnime then
    Controller:PlayAnimeByIndex(DataModel.TabIndex, elementIndex)
  end
end

function Controller:OpenAnecdoteView(btn, str)
  local anecdoteQuestId = DataModel.anecdoteQuestId
  if anecdoteQuestId ~= nil and 0 < anecdoteQuestId then
    UIManager:Open("UI/Quest/Anecdote/Anecdote", Json.encode({nowAnecdoteQuestId = anecdoteQuestId}))
  end
end

return Controller
