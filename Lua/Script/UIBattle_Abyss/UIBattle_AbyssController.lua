local View = require("UIBattle_Abyss/UIBattle_AbyssView")
local DataModel = require("UIBattle_Abyss/UIBattle_AbyssDataModel")
local CommonItem = require("Common/BtnItem")
local Controller = {}

function Controller:Init()
  if DataModel.curPeriodId then
    local curPeriodCA = PlayerData:GetFactoryData(DataModel.curPeriodId)
    if TimeUtil:IsActive(curPeriodCA.startTime, curPeriodCA.endTime) then
      return
    end
  end
  local abyssCA = PlayerData:GetFactoryData(DataModel.turntableId)
  local abyssIdList = {}
  for i = 1, #abyssCA.abyssPeriodList do
    local periodCA = PlayerData:GetFactoryData(abyssCA.abyssPeriodList[i].id)
    if TimeUtil:IsActive(periodCA.startTime, periodCA.endTime) then
      for j = 1, #periodCA.abyssList do
        abyssIdList[#abyssIdList + 1] = periodCA.abyssList[j].id
        DataModel.curPeriodId = periodCA.id
      end
      break
    end
  end
  DataModel.abyssIdList = abyssIdList
  self:InitUI()
end

function Controller:InitUI()
  local count = View.Img_Mask.ScrollView_TV.Viewport.Content.Img_Bg.Group_Abyss.self.transform.childCount
  local length = math.min(#DataModel.abyssIdList, count)
  local maxStar = length * 3
  DataModel.curStarNum = 0
  local notPassIndex = -1
  for i = 1, length do
    local group = View.Img_Mask.ScrollView_TV.Viewport.Content.Img_Bg.Group_Abyss["Group_Abyss" .. i]
    group:SetActive(true)
    local point = View.Group_Finsh["Group_L0" .. i]
    point:SetActive(true)
    local isPass = false
    local abyssId = tostring(DataModel.abyssIdList[i])
    if PlayerData.ServerData.abyss_level[abyssId] ~= nil and PlayerData.ServerData.abyss_level[abyssId].stars ~= nil then
      for j = 1, #PlayerData.ServerData.abyss_level[abyssId].stars do
        if PlayerData.ServerData.abyss_level[abyssId].stars[j] ~= 0 then
          if j == 1 then
            isPass = true
          end
          group.Btn_Abyss.Group_On.Group_Star["Img_" .. j]:SetActive(true)
          DataModel.curStarNum = DataModel.curStarNum + 1
        else
          group.Btn_Abyss.Group_On.Group_Star["Img_" .. j]:SetActive(false)
        end
      end
    end
    if not isPass and notPassIndex < 0 then
      notPassIndex = i
    end
    group.Btn_Abyss.Group_On:SetActive(isPass)
    group.Btn_Abyss.Group_Off:SetActive(not isPass)
    point.Img_On:SetActive(isPass)
    point.Img_Off:SetActive(not isPass)
    group.Img_New:SetActive(notPassIndex == i)
  end
  for i = length + 1, count do
    View.Img_Mask.ScrollView_TV.Viewport.Content.Img_Bg.Group_Abyss["Group_Abyss" .. i]:SetActive(false)
    View.Group_Finsh["Group_L0" .. i]:SetActive(false)
  end
  local txtStar = View.Group_Star.Btn_Star.Txt_Star
  txtStar:SetText(DataModel.curStarNum .. "/" .. maxStar)
  View.Group_StarReward:SetActive(false)
  local starRed, rewardRed = PlayerData:GetAbyssRedPoint()
  View.Group_Star.Btn_Star.Img_Red:SetActive(rewardRed)
  Controller:RefreshTime()
end

function Controller:RefreshTime()
  if DataModel.curPeriodId == nil then
    return
  end
  local curPeriodCA = PlayerData:GetFactoryData(DataModel.curPeriodId)
  local endTime = curPeriodCA.endTime
  local remainTime = TimeUtil:LastTime(endTime)
  local remainTable = TimeUtil:SecondToTable(remainTime)
  if remainTable.day > 0 then
    View.Group_Time.Txt_Time:SetText(string.format(GetText(80607630), remainTable.day, remainTable.hour))
  elseif 0 < remainTable.hour then
    View.Group_Time.Txt_Time:SetText(string.format(GetText(80607631), remainTable.hour))
  else
    View.Group_Time.Txt_Time:SetText(string.format(GetText(80607632), remainTable.minute))
  end
end

function Controller:OpenTeam(index)
  if DataModel.curPeriodId then
    local curPeriodCA = PlayerData:GetFactoryData(DataModel.curPeriodId)
    if not TimeUtil:IsActive(curPeriodCA.startTime, curPeriodCA.endTime) then
      return
    end
  else
    return
  end
  if 1 < index then
    local preAbyssId = tostring(DataModel.abyssIdList[index - 1])
    if PlayerData.ServerData.abyss_level[preAbyssId] ~= nil then
      if PlayerData.ServerData.abyss_level[preAbyssId].stars == nil then
        return
      elseif PlayerData.ServerData.abyss_level[preAbyssId].stars[1] == 0 then
        return
      end
    else
      return
    end
  end
  UIManager:Open("UI/Chapter/Battle_Abyss/Team_Abyss", Json.encode({
    turntableId = DataModel.turntableId,
    abyssId = DataModel.abyssIdList[index],
    activityId = DataModel.activityId,
    periodId = DataModel.curPeriodId,
    teamKey = index
  }))
end

function Controller:OpenStarRewards()
  if DataModel.curPeriodId == nil then
    return
  end
  local curPeriodCA = PlayerData:GetFactoryData(DataModel.curPeriodId)
  View.Group_StarReward:SetActive(true)
  View.Group_StarReward.ScrollGrid_Level.grid.self:SetDataCount(#curPeriodCA.starReward)
  View.Group_StarReward.ScrollGrid_Level.grid.self:RefreshAllElement()
  View.Group_StarReward.ScrollGrid_Level.grid.self:MoveToTop()
end

function Controller:SetStarRewardGrid(element, elementIndex)
  if DataModel.curPeriodId == nil then
    return
  end
  local curPeriodCA = PlayerData:GetFactoryData(DataModel.curPeriodId)
  local rewardData = curPeriodCA.starReward[elementIndex]
  local isCompleted = DataModel.curStarNum >= rewardData.star
  element.Group_Not:SetActive(not isCompleted)
  if isCompleted then
    local claimData = PlayerData.ServerData.abyss_period[tostring(DataModel.curPeriodId)]
    local isClaimed = false
    if claimData ~= nil and claimData.reward ~= nil then
      for i = 1, #claimData.reward do
        if claimData.reward[i] + 1 == elementIndex then
          isClaimed = true
          break
        end
      end
    end
    element.Group_Can:SetActive(not isClaimed)
    element.Group_Complete:SetActive(isClaimed)
    element.Group_Mask:SetActive(isClaimed)
    if isClaimed then
      element.Group_Complete.Txt_Star:SetText(rewardData.star)
    else
      element.Group_Can.Txt_Star:SetText(rewardData.star)
      element.Group_Can.Btn_Click:SetClickParam(elementIndex)
    end
  else
    element.Group_Can:SetActive(false)
    element.Group_Complete:SetActive(false)
    element.Group_Mask:SetActive(false)
    element.Group_Not.Txt_Star:SetText(rewardData.star)
  end
  element.ScrollGrid_Reward.grid.self:SetParentParam(elementIndex)
  local itemCA = PlayerData:GetFactoryData(rewardData.id)
  element.ScrollGrid_Reward.grid.self:SetDataCount(#itemCA.rewardList)
  element.ScrollGrid_Reward.grid.self:RefreshAllElement()
  element.ScrollGrid_Reward.grid.self:MoveToTop()
end

function Controller:SetStarRewardsItemGrid(element, elementIndex)
  if DataModel.curPeriodId == nil then
    return
  end
  local index = tonumber(element.ParentParam)
  local curPeriodCA = PlayerData:GetFactoryData(DataModel.curPeriodId)
  local rewardData = curPeriodCA.starReward[index]
  local rewardList = PlayerData:GetFactoryData(rewardData.id).rewardList
  CommonItem:SetItem(element.Group_Item, {
    id = rewardList[elementIndex].id,
    num = rewardList[elementIndex].num
  })
  element.Group_Item.Btn_Item:SetClickParam(rewardList[elementIndex].id)
end

function Controller:TryClaimStarReward(str)
  if DataModel.curPeriodId == nil then
    return
  end
  local index = tonumber(str)
  local curPeriodCA = PlayerData:GetFactoryData(DataModel.curPeriodId)
  local rewardData = curPeriodCA.starReward[index]
  if DataModel.curStarNum < rewardData.star then
    return
  end
  Net:SendProto("battle.abyss_reward", function(json)
    local periodId = tostring(DataModel.curPeriodId)
    if PlayerData.ServerData.abyss_period[periodId] == nil then
      PlayerData.ServerData.abyss_period[periodId] = {}
    end
    if PlayerData.ServerData.abyss_period[periodId].reward == nil then
      PlayerData.ServerData.abyss_period[periodId].reward = {}
    end
    table.insert(PlayerData.ServerData.abyss_period[periodId].reward, index - 1)
    View.Group_StarReward.ScrollGrid_Level.grid.self:RefreshAllElement()
    CommonTips.OpenShowItem(json.reward)
    local starRed, rewardRed = PlayerData:GetAbyssRedPoint()
    View.Group_Star.Btn_Star.Img_Red:SetActive(rewardRed)
  end, DataModel.curPeriodId, index - 1)
end

return Controller
