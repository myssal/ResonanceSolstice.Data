local View = require("UISpecialOrder/UISpecialOrderView")
local CommonItem = require("Common/BtnItem")
local DataModel = {
  ActivityId = "86000072",
  ServerLevy = 0,
  SelfLevy = 0,
  ServerBuffList = {},
  SelfBuffList = {},
  CurServerBuffLevel = 0,
  CurSelfBuffLevel = 0,
  ServerBuffTotalLevel = 0,
  SelfBuffTotalLevel = 0,
  ReceivedRewardIndex = {}
}

function DataModel.Init()
  if not PlayerData.ServerData.user_info.user_future_activity then
    return
  end
  DataModel.GetSelfLevyCount()
  DataModel.GetServerLevyCount()
  DataModel.InitBuffList()
  View.Group_BuffInfo:SetActive(false)
  local cfg = PlayerData:GetFactoryData(DataModel.ActivityId)
  View.Group_Time.Txt_EndTime:SetText(string.format(GetText(80610924), cfg.startTime))
  View.Group_Bg.Img_Title:SetSprite(GetResPath(88300241))
  DataModel.RefreshPanel()
end

function DataModel.RefreshPanel()
  View.Group_Progress.Btn_Personal.Txt_Num:SetText(DataModel.SelfLevy)
  View.Group_Progress.Btn_All.Txt_Num:SetText(DataModel.ServerLevy)
  local cfg = PlayerData:GetFactoryData(DataModel.ActivityId)
  local itemId = cfg.requiredMaterials[1].id
  local itemCfg = PlayerData:GetFactoryData(itemId)
  View.Group_Formula.Group_Formula.Img_Item:SetSprite(itemCfg.iconPath or itemCfg.imagePath)
  local isUnlock = false
  local orderCfg = PlayerData:GetFactoryData(cfg.orderList[1].id)
  local productionCfg = PlayerData:GetFactoryData(orderCfg.requireProduction)
  if productionCfg.unlock and productionCfg.unlock > 0 then
    local ownList = PlayerData.ServerData.formula_items or {}
    for k, v in pairs(ownList) do
      if v == tostring(productionCfg.unlock) then
        isUnlock = true
      end
    end
  else
    isUnlock = true
  end
  View.Group_Formula.Btn_GetFormula:SetActive(not isUnlock)
  View.Group_Formula.Group_Formula:SetActive(isUnlock)
  if not isUnlock then
    local requireItemId = cfg.getProductionCost[1].id
    local requireItemNum = cfg.getProductionCost[1].num
    local requireItemHave = PlayerData:GetGoodsById(requireItemId).num
    local cfgItem = PlayerData:GetFactoryData(requireItemId)
    View.Group_Formula.Btn_GetFormula.Img_:SetSprite(itemCfg.iconPath or itemCfg.imagePath)
    View.Group_Formula.Btn_GetFormula.Group_Cost.Img_Icon:SetSprite(cfgItem.iconPath)
    View.Group_Formula.Btn_GetFormula.Group_Cost.Txt_:SetText(requireItemHave .. "/" .. requireItemNum)
    View.Group_Formula.Btn_GetFormula.Group_Cost.Txt_:SetColor(requireItemNum <= requireItemHave and "#D6D6D6" or "#E50000")
    local _tempCfg = PlayerData:GetFactoryData(cfg.getProduction[1].id)
    View.Group_Formula.Btn_GetFormula.Img_.Txt_:SetText(_tempCfg.name)
    View.Group_Formula.Btn_GetFormula.Img_1.Txt_:SetText(_tempCfg.name)
    local ShowMask = false
    local txtId
    if requireItemNum > requireItemHave then
      ShowMask = true
      txtId = 80611873
    end
    local makeLv = PlayerData:GetHomeInfo().compound_lv
    local requireLevel = cfg.getProductionPremise
    if not ShowMask and makeLv < requireLevel then
      ShowMask = true
      txtId = 80611877
    end
    View.Group_Formula.Btn_GetFormula.Img_Mask:SetActive(ShowMask)
    if txtId then
      View.Group_Formula.Btn_GetFormula.Img_Mask.Txt_tip:SetText(GetText(txtId))
    end
  end
  View.Group_Progress.Btn_Personal.Txt_Percent:SetText(math.floor(DataModel.CurSelfBuffLevel / DataModel.SelfBuffTotalLevel * 100) .. "%")
  View.Group_Progress.Btn_All.Txt_Percent:SetText(math.floor(DataModel.CurServerBuffLevel / DataModel.ServerBuffTotalLevel * 100) .. "%")
end

function DataModel.GetSelfLevyCount(activityId)
  activityId = activityId or DataModel.ActivityId
  local cfg = PlayerData:GetFactoryData(activityId)
  local itemId = cfg.requiredMaterials[1].id
  local data = PlayerData.ServerData.user_info.user_future_activity.levy
  DataModel.SelfLevy = tonumber(data[tostring(itemId)]) or 0
  return DataModel.SelfLevy
end

function DataModel.GetServerLevyCount(activityId)
  activityId = activityId or DataModel.ActivityId
  local cfg = PlayerData:GetFactoryData(activityId)
  local itemId = cfg.requiredMaterials[1].id
  local data = PlayerData.ServerData.user_info.user_future_activity.server_levy
  DataModel.ServerLevy = tonumber(data[tostring(itemId)]) or 0
  return DataModel.ServerLevy
end

function DataModel.InitBuffList(activityId)
  DataModel.ServerBuffList = {}
  DataModel.CurServerBuffLevel = 0
  activityId = activityId or DataModel.ActivityId
  local cfg = PlayerData:GetFactoryData(activityId)
  local buffList = cfg.allLevyList
  for i, data in ipairs(buffList) do
    table.insert(DataModel.ServerBuffList, {
      num = data.levyNum,
      buffTxt = PlayerData:GetFactoryData(data.id).desc
    })
    if DataModel.ServerLevy >= data.levyNum then
      DataModel.CurServerBuffLevel = i
    end
  end
  DataModel.ServerBuffTotalLevel = #DataModel.ServerBuffList
  DataModel.SelfBuffList = {}
  DataModel.CurSelfBuffLevel = 0
  activityId = activityId or DataModel.ActivityId
  local selfBuffList = cfg.personalLevyList
  for i, data in ipairs(selfBuffList) do
    table.insert(DataModel.SelfBuffList, {
      num = data.levyNum,
      buffTxt = PlayerData:GetFactoryData(data.id).desc,
      reward = cfg.personalRewardList[i]
    })
    if DataModel.SelfLevy >= data.levyNum then
      DataModel.CurSelfBuffLevel = i
    end
  end
  DataModel.SelfBuffTotalLevel = #DataModel.SelfBuffList
  DataModel.ReceivedRewardIndex = {}
  if PlayerData.ServerData.user_info.user_future_activity and PlayerData.ServerData.user_info.user_future_activity.rec_pos_list then
    for i, data in ipairs(PlayerData.ServerData.user_info.user_future_activity.rec_pos_list) do
      DataModel.ReceivedRewardIndex[tonumber(i)] = true
    end
  end
end

function DataModel.SetServerBuffElement(element, elementIndex)
  element.Group_Common.Txt_Num:SetText(DataModel.ServerBuffList[elementIndex].num)
  element.Group_Common.Txt_Buff:SetText(DataModel.ServerBuffList[elementIndex].buffTxt)
  element.Group_Current.Txt_Num:SetText(DataModel.ServerBuffList[elementIndex].num)
  element.Group_Current.Txt_Buff:SetText(DataModel.ServerBuffList[elementIndex].buffTxt)
  element.Group_Current:SetActive(DataModel.CurServerBuffLevel == elementIndex)
  element.Group_Common:SetActive(DataModel.CurServerBuffLevel ~= elementIndex)
end

function DataModel.RefreshServerBuffPanel()
  View.Group_BuffInfo.Group_All.ScrollGrid_Buff.grid.self:SetDataCount(#DataModel.ServerBuffList)
  View.Group_BuffInfo.Group_All.ScrollGrid_Buff.grid.self:RefreshAllElement()
end

function DataModel.SetSelfBuffElement(element, elementIndex)
  element.Group_Common.Txt_Num:SetText(DataModel.SelfBuffList[elementIndex].num)
  element.Group_Common.Txt_Buff:SetText(DataModel.SelfBuffList[elementIndex].buffTxt)
  element.Group_Current.Txt_Num:SetText(DataModel.SelfBuffList[elementIndex].num)
  element.Group_Current.Txt_Buff:SetText(DataModel.SelfBuffList[elementIndex].buffTxt)
  element.Group_Current:SetActive(DataModel.CurSelfBuffLevel == elementIndex)
  element.Group_Common:SetActive(DataModel.CurSelfBuffLevel ~= elementIndex)
  element.Group_Current.Btn_Get:SetActive(DataModel.ReceivedRewardIndex[elementIndex] == nil)
  element.Group_Common.Btn_Get:SetActive(DataModel.ReceivedRewardIndex[elementIndex] == nil)
  element.Group_Current.Img_Mask:SetActive(DataModel.ReceivedRewardIndex[elementIndex] ~= nil)
  element.Group_Common.Img_Mask:SetActive(DataModel.ReceivedRewardIndex[elementIndex] ~= nil)
  local reward = DataModel.SelfBuffList[elementIndex].reward
  local rewardCfg = PlayerData:GetFactoryData(reward.id)
  local caData = PlayerData:GetFactoryData(reward.id)
  local quality_int
  if caData.qualityInt ~= nil then
    quality_int = caData.qualityInt + 1
  elseif caData.rarityInt ~= nil then
    quality_int = caData.rarityInt + 1
  else
    quality_int = 1
  end
  element.Group_Current.Img_Bottom:SetSprite(UIConfig.BottomConfig[quality_int - 1] and UIConfig.BottomConfig[quality_int - 1] or UIConfig.BottomConfig[1])
  element.Group_Common.Img_Bottom:SetSprite(UIConfig.BottomConfig[quality_int - 1] and UIConfig.BottomConfig[quality_int - 1] or UIConfig.BottomConfig[1])
  element.Group_Current.Img_Item:SetSprite(rewardCfg.iconPath or rewardCfg.imagePath)
  element.Group_Common.Img_Item:SetSprite(rewardCfg.iconPath or rewardCfg.imagePath)
  element.Group_Common.Img_ItemNum.Txt_:SetText(reward.num)
  element.Group_Current.Img_ItemNum.Txt_:SetText(reward.num)
  element.Group_Common.Btn_Get:SetClickParam(elementIndex)
  element.Group_Current.Btn_Get:SetClickParam(elementIndex)
end

function DataModel.RefreshSelfBuffPanel()
  View.Group_BuffInfo.Group_Personal.ScrollGrid_Buff.grid.self:SetDataCount(#DataModel.SelfBuffList)
  View.Group_BuffInfo.Group_Personal.ScrollGrid_Buff.grid.self:RefreshAllElement()
end

function DataModel.TryGetReward(index)
  if DataModel.ReceivedRewardIndex[index] then
    return
  end
  if index > DataModel.CurSelfBuffLevel then
    CommonTips.OpenTips(80610957)
    return
  end
  Net:SendProto("future.levy_rec", function(json)
    if json.reward then
      CommonTips.OpenShowItem(json.reward)
    end
    DataModel.ReceivedRewardIndex[index] = true
    DataModel.RefreshSelfBuffPanel()
  end, DataModel.ActivityId, index - 1)
end

function DataModel.SwitchBuffTab(index)
  View.Group_BuffInfo.Group_Personal:SetActive(index == 1)
  View.Group_BuffInfo.Group_All:SetActive(index == 2)
  if index == 1 then
    View.Group_BuffInfo.Group_Personal.ScrollGrid_Buff.grid.self:SetDataCount(#DataModel.SelfBuffList)
    View.Group_BuffInfo.Group_Personal.ScrollGrid_Buff.grid.self:RefreshAllElement()
  else
    View.Group_BuffInfo.Group_All.ScrollGrid_Buff.grid.self:SetDataCount(#DataModel.ServerBuffList)
    View.Group_BuffInfo.Group_All.ScrollGrid_Buff.grid.self:RefreshAllElement()
  end
end

function DataModel.GetBuyBuff(activityId)
  if not activityId then
    return 0
  end
  if not PlayerData.ServerData.user_info.all_user_future_activity then
    return 0
  end
  local data = PlayerData.ServerData.user_info.all_user_future_activity[tostring(activityId)]
  if not data then
    return 0
  end
  local activityCfg = PlayerData:GetFactoryData(activityId)
  local requireItemId = activityCfg.requiredMaterials[1].id
  local buffId = 0
  local curDev = data.levy[tostring(requireItemId)] or 0
  local buffList = PlayerData:GetFactoryData(activityId).personalLevyList
  for i, v in ipairs(buffList) do
    if curDev >= v.levyNum then
      buffId = v.id
    end
  end
  if 0 < buffId then
    local cfg = PlayerData:GetFactoryData(buffId)
    return cfg.param
  end
  return 0
end

return DataModel
