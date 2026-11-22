local DataModel = require("UIPrisonLevel/UIPrisonLevelDataModel")
local View = require("UIPrisonLevel/UIPrisonLevelView")
local CommonItem = require("Common/BtnItem")
local Controller = {}

function Controller:Init()
  DataModel.InitData()
  Controller:RefreshOverviewPanel()
  Controller:SelectLevel(DataModel.Level)
  View.Img_Level.ScrollGrid_Level.grid.self:MoveToPos(DataModel.Level)
end

function Controller:SetLevelElement(element, elementIndex)
  local isReachLevel = elementIndex <= DataModel.Level
  local isReward = DataModel.LevelRewardGetData[elementIndex]
  element.Group_Unlocked.Group_.Txt_LV:SetText(elementIndex)
  element.Group_Unlocked.Group_.Img_RedDot:SetActive(not DataModel.LevelRewardGetData[elementIndex])
  element.Group_Locked.Txt_LV:SetText(elementIndex)
  element.Group_Unlocked:SetActive(isReachLevel)
  element.Group_Locked:SetActive(not isReachLevel)
  element.Group_Choose:SetActive(DataModel.CurSelectLevel == elementIndex)
  element.Img_Received:SetActive(isReward)
  element.Btn_:SetClickParam(elementIndex)
end

function Controller:RefreshLevelListElement()
  View.Img_Level.ScrollGrid_Level.grid.self:SetDataCount(DataModel.MaxLevel)
  View.Img_Level.ScrollGrid_Level.grid.self:RefreshAllElement()
end

function Controller:SetRoomDeltaElement(element, elementIndex)
  local row = DataModel.DeltaData[elementIndex]
  if row.isLevelDelta then
    element.Txt_Title:SetText(row.text)
    if row.delta == 0 then
      element.Txt_Num:SetText("")
    else
      element.Txt_Num:SetText(string.format(GetText(80608238), row.delta))
    end
  elseif row.isMachineDelta then
    element.Txt_Title:SetText(row.text)
    element.Txt_Num:SetText(string.format(GetText(80608237), row.delta))
  else
    local roomCfg = PlayerData:GetFactoryData(row.roomId)
    element.Txt_Title:SetText(string.format(GetText(80608236), roomCfg.roomName))
    element.Txt_Num:SetText(string.format(GetText(80608237), row.unlockLevel))
  end
end

function Controller:SetRoomDeltaExpandElement(element, elementIndex)
  local row = DataModel.DeltaData[elementIndex]
  if row.isLevelDelta then
    element.Txt_Title:SetText(row.text)
    if row.delta == 0 then
      element.Txt_Num:SetText("")
    else
      element.Txt_Num:SetText(string.format(GetText(80608238), row.delta))
    end
  elseif row.isMachineDelta then
    element.Txt_Title:SetText(row.text)
    element.Txt_Num:SetText(string.format(GetText(80608237), row.delta))
  else
    local roomCfg = PlayerData:GetFactoryData(row.roomId)
    element.Txt_Title:SetText(string.format(GetText(80608236), roomCfg.roomName))
    element.Txt_Num:SetText(string.format(GetText(80608237), row.unlockLevel))
  end
end

function Controller:RefreshDeltaListElement()
  local levelDelta, record = DataModel.GetLevelDeltaData()
  local roomDelta = DataModel.GetRoomDeltaData()
  DataModel.DeltaData = {}
  for i, v in ipairs(levelDelta) do
    table.insert(DataModel.DeltaData, v)
  end
  for i, v in ipairs(roomDelta) do
    table.insert(DataModel.DeltaData, v)
  end
  local showExpand = not record.hasWorkShopNum and not record.hasSpaceNum and not record.hasCellNum and not record.hasRoomNum
  if showExpand then
    View.Img_Mask.Group_Right:SetActive(false)
    View.Img_Mask.Group_RightExpand:SetActive(true)
    View.Img_Mask.Group_RightExpand.ScrollGrid_Content.grid.self:SetDataCount(table.count(DataModel.DeltaData))
    View.Img_Mask.Group_RightExpand.ScrollGrid_Content.grid.self:RefreshAllElement()
  else
    View.Img_Mask.Group_Right:SetActive(true)
    View.Img_Mask.Group_RightExpand:SetActive(false)
    View.Img_Mask.Group_Right.StaticGrid_Pic.grid[1]:SetActive(record.hasWorkShopNum)
    View.Img_Mask.Group_Right.StaticGrid_Pic.grid[2]:SetActive(record.hasSpaceNum)
    View.Img_Mask.Group_Right.StaticGrid_Pic.grid[3]:SetActive(record.hasCellNum)
    View.Img_Mask.Group_Right.StaticGrid_Pic.grid[4]:SetActive(record.hasRoomNum)
    View.Img_Mask.Group_Right.ScrollGrid_Content.grid.self:SetDataCount(table.count(DataModel.DeltaData))
    View.Img_Mask.Group_Right.ScrollGrid_Content.grid.self:RefreshAllElement()
  end
end

function Controller:SetLevelRewardElement(element, elementIndex)
  local reward = DataModel.LevelRewardData[elementIndex]
  if reward then
    CommonItem:SetItem(element, {
      id = reward.id,
      num = reward.num
    })
    element.Btn_Item:SetClickParam(reward.id)
  end
end

function Controller:RefreshLevelReward()
  View.Img_Reward.ScrollGrid_Reward.grid.self:SetDataCount(table.count(DataModel.LevelRewardData))
  View.Img_Reward.ScrollGrid_Reward.grid.self:RefreshAllElement()
  View.Img_Reward.ScrollGrid_Reward.self:SetActive(false)
  View.Img_Reward.ScrollGrid_Reward.self:SetActive(true)
end

function Controller:SelectLevel(idx)
  DataModel.CurSelectLevel = idx
  Controller:RefreshLevelListElement()
  Controller:RefreshDeltaListElement()
  local reward = PlayerData:GetFactoryData(DataModel.GetPrisonLevelCfgByLevel(DataModel.CurSelectLevel).reward)
  DataModel.LevelRewardData = reward.rewardList
  Controller:RefreshLevelReward()
  Controller:RefreshAvailableBtn()
end

function Controller:RefreshOverviewPanel()
  local levelCfg = DataModel.GetPrisonLevelCfgByLevel(DataModel.Level)
  View.Group_Left.Group_Reputation.Txt_Grade:SetText("Lv" .. DataModel.Level)
  local curExp = DataModel.Exp
  local nextExp = math.floor(levelCfg.exp)
  View.Group_Left.Group_Reputation.Txt_Num:SetText(curExp .. "/" .. nextExp)
  View.Group_Left.Group_Reputation.Img_PB:SetFilledImgAmount(curExp / nextExp)
  DataModel.OverviewPanelData = {}
  for index, data in ipairs(DataModel.DesDefaultList) do
    local value = levelCfg[data.name] and levelCfg[data.name] or 0
    local text = data.text
    local row = {
      value = value,
      text = text,
      name = data.name
    }
    table.insert(DataModel.OverviewPanelData, row)
  end
  for i = 1, #DataModel.OverviewPanelData do
    local row = DataModel.OverviewPanelData[i]
    if row then
      View.Group_Left.Group_Content.ScrollView_Content.Viewport.Content.Img_2["Txt_" .. i]:SetText(row.text)
      if row.name == "workshopNum" then
        View.Group_Left.Group_Content.ScrollView_Content.Viewport.Content.Img_2.Txt_Workshop:SetText(row.value)
      elseif row.name == "SpaceNum" then
        View.Group_Left.Group_Content.ScrollView_Content.Viewport.Content.Img_2.Txt_Space:SetText(row.value)
      elseif row.name == "cellNum" then
        View.Group_Left.Group_Content.ScrollView_Content.Viewport.Content.Img_2.Txt_Accomodation:SetText(row.value)
      elseif row.name == "roomNum" then
        View.Group_Left.Group_Content.ScrollView_Content.Viewport.Content.Img_2.Txt_Room:SetText(row.value)
      elseif row.name == "materialWare" then
        View.Group_Left.Group_Content.ScrollView_Content.Viewport.Content.Img_2.Txt_CapacityYL:SetText(levelCfg.materialWare + levelCfg.extraMaterialWare)
      elseif row.name == "commodityWare" then
        View.Group_Left.Group_Content.ScrollView_Content.Viewport.Content.Img_2.Txt_CapacityCP:SetText(levelCfg.commodityWare + levelCfg.extraCommodityWare)
      end
    end
  end
end

function Controller:RefreshAvailableBtn()
  local idx = DataModel.CurSelectLevel or 1
  local levelEnough = DataModel.Level >= DataModel.CurSelectLevel
  local isRewarded = DataModel.LevelRewardGetData[idx] ~= nil
  View.Group_BtnReward.Btn_Unavailable:SetActive(not levelEnough or isRewarded)
  View.Group_BtnReward.Btn_Available:SetActive(levelEnough and not isRewarded)
  if not levelEnough then
    View.Group_BtnReward.Btn_Unavailable.Txt_:SetText(GetText(80608252))
  elseif not isRewarded then
    View.Group_BtnReward.Btn_Unavailable.Txt_:SetText(GetText(80608251))
  elseif isRewarded then
    View.Group_BtnReward.Btn_Unavailable.Txt_:SetText(GetText(80608250))
  end
end

function Controller:TryGetLevelReward()
  local targetLv = DataModel.CurSelectLevel
  Net:SendProto("prison.lv_awards", function(json)
    if json.reward then
      CommonTips.OpenShowItem(json.reward)
    end
    table.insert(PlayerData.ServerData.user_prison_info.lv_reward, targetLv)
    DataModel.LevelRewardGetData[targetLv] = true
    Controller:RefreshAvailableBtn()
    Controller:RefreshLevelListElement()
  end, targetLv)
end

return Controller
