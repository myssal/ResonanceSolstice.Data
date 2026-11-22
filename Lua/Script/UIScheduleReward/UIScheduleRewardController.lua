local View = require("UIScheduleReward/UIScheduleRewardView")
local DataModel = require("UIScheduleReward/UIScheduleRewardDataModel")
local BtnItem = require("Common/BtnItem")
local FastBattle_DataModel = require("UIFastBattle/UIFastBattleDataModel")
local Controller = {}

function Controller:Init()
  Controller.InitPanelShow()
end

function Controller.InitPanelShow()
  local allBuildList = DataModel.GetAllSafeStationList()
  if not allBuildList then
    return
  end
  DataModel.allBuildList = allBuildList
  View.ScrollGrid_Tab.grid.self:SetDataCount(#DataModel.allBuildList)
  View.ScrollGrid_Tab.grid.self:RefreshAllElement()
  Controller.OnBuildTabClick(DataModel.curBuildId)
end

function Controller.RefreshBuildTabElement(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  if not DataModel.allBuildList then
    return
  end
  local buildInfo = DataModel.allBuildList[elementIndex]
  if not buildInfo then
    return
  end
  local buildCa = PlayerData:GetFactoryData(buildInfo.id, "BuildingFactory")
  if buildCa then
    local stationCa = PlayerData:GetFactoryData(buildCa.stationId, "BuildingFactory")
    if stationCa then
      element.Group_Off.Txt_Name:SetText(stationCa.name)
      element.Group_On.Txt_Name:SetText(stationCa.name)
    end
  end
  element.Img_RedPoint:SetActive(FastBattle_DataModel.GetLeverRewardRedDotState(buildInfo.id))
  if DataModel.curBuildId == buildInfo.id then
    element.Group_On:SetActive(true)
    element.Group_Off:SetActive(false)
  else
    element.Group_On:SetActive(false)
    element.Group_Off:SetActive(true)
  end
  element.Btn_:SetClickFunction(function()
    Controller.OnBuildTabClick(buildInfo.id)
  end)
end

function Controller.OnBuildTabClick(buildId)
  if not buildId then
    return
  end
  DataModel.curBuildId = buildId
  View.ScrollGrid_Tab.grid.self:RefreshAllElement()
  Controller.RefreshBuildContentShow()
end

function Controller.RefreshBuildContentShow()
  if not DataModel.curBuildId then
    return
  end
  local buildingCA = PlayerData:GetFactoryData(DataModel.curBuildId)
  if not buildingCA then
    return
  end
  DataModel.curPondList = {}
  if buildingCA and buildingCA.createQuestList then
    DataModel.curPondList = buildingCA.createQuestList or {}
  end
  View.StaticGrid_Tab.grid.self:SetDataCount(#DataModel.curPondList)
  View.StaticGrid_Tab.grid.self:RefreshAllElement()
  local openPondId
  if #DataModel.curPondList > 0 then
    openPondId = DataModel.curPondList[1].id
    for i = 1, #DataModel.curPondList do
      if DataModel.curPondList[i].id == DataModel.curPondId then
        openPondId = DataModel.curPondId
      end
    end
  end
  if openPondId then
    Controller.OnPondTabItemClick(openPondId)
  end
end

function Controller.RefreshPondTabElement(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  DataModel.curPondList = DataModel.curPondList or {}
  local pondInfo = DataModel.curPondList[elementIndex]
  if not pondInfo then
    return
  end
  local levelCfg = PlayerData:GetFactoryData(pondInfo.id, "ListFactory")
  if levelCfg then
    element.Group_Off.Img_Bg.Txt_Name:SetText(levelCfg.seriesName)
    element.Group_On.Img_Bg.Txt_Name:SetText(levelCfg.seriesName)
  end
  element.Img_RedPoint:SetActive(FastBattle_DataModel.GetLeverRewardRedDotStateById(DataModel.curBuildId, pondInfo.id))
  if pondInfo.id == DataModel.curPondId then
    element.Group_On:SetActive(true)
    element.Group_Off:SetActive(false)
  else
    element.Group_On:SetActive(false)
    element.Group_Off:SetActive(true)
  end
  element.Btn_:SetClickFunction(function()
    Controller.OnPondTabItemClick(pondInfo.id)
  end)
end

function Controller.OnPondTabItemClick(pondId)
  if not pondId then
    return
  end
  DataModel.curPondId = pondId
  View.StaticGrid_Tab.grid.self:RefreshAllElement()
  local buildingCA = PlayerData:GetFactoryData(DataModel.curBuildId)
  if not buildingCA then
    return
  end
  if not PlayerData.ServerData or not PlayerData.ServerData.security_levels then
    return
  end
  local serverInfo = PlayerData.ServerData.security_levels[tostring(DataModel.curBuildId)]
  if not serverInfo then
    return
  end
  local pondServerInfo = serverInfo[tostring(DataModel.curPondId)]
  local stationCA = PlayerData:GetFactoryData(buildingCA.stationId)
  local pondCA = PlayerData:GetFactoryData(DataModel.curPondId)
  View.Txt_CityName:SetText(stationCA.name)
  View.Txt_SeriesName:SetText(string.format(GetText(80602075), pondCA.seriesName))
  View.Txt_Name:SetText(GetText(pondCA.sequenceName))
  local percent = pondServerInfo.expel_num / pondCA.expelNum
  View.Txt_ExpelNum:SetText(string.format(GetText(80602074), math.floor(percent * 100 + 1.0E-4)))
  View.Img_ScheduleDi:SetFilledImgAmount(percent)
  View.Img_ScheduleDi.Img_Pointer:SetAnchoredPositionX(374 * percent - 7)
  DataModel.RefreshRewardInfo()
  DataModel.rewardInfo = DataModel.rewardInfo or {}
  View.ScrollGrid_List.grid.self:SetDataCount(#DataModel.rewardInfo)
  View.ScrollGrid_List.grid.self:RefreshAllElement()
end

function Controller:SetElement(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  local info = DataModel.rewardInfo[elementIndex]
  if not info then
    return
  end
  element.Group_Not:SetActive(info.received or not info.canGet)
  element.Group_Can:SetActive(not info.received and info.canGet)
  element.Group_Can.Btn_Click:SetClickParam(elementIndex)
  element.Group_Complete:SetActive(info.received)
  element.Group_Complete.Txt_EN:SetActive(not CommonTips.IsResEN())
  element.Group_Not.Txt_ExpelNum:SetText(string.format(GetText(80602074), info.expelPercent))
  element.Group_Can.Txt_ExpelNum:SetText(string.format(GetText(80602074), info.expelPercent))
  element.Group_Reward.ScrollGrid_Reward.grid.self:SetParentParam(elementIndex)
  element.Group_Reward.ScrollGrid_Reward.grid.self:SetDataCount(#info.rewardItems)
  element.Group_Reward.ScrollGrid_Reward.grid.self:RefreshAllElement()
end

function Controller:SetRewardItemElement(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  local parentIndex = tonumber(element.ParentParam)
  if not parentIndex then
    return
  end
  local info = DataModel.rewardInfo[parentIndex]
  if not info then
    return
  end
  local rewardItem = info.rewardItems[elementIndex]
  if not rewardItem then
    return
  end
  BtnItem:SetItem(element.Group_Item, {
    id = rewardItem.id,
    num = rewardItem.num
  })
  element.Group_Item.Btn_Item:SetClickParam(rewardItem.id)
end

function Controller:ClickRewardItem(str)
  local id = tonumber(str)
  CommonTips.OpenPreItemTips({itemId = id})
end

function Controller:ClickReward(str)
  local idx = tonumber(str)
  local info = DataModel.rewardInfo[idx]
  Net:SendProto("building.expel_reward", function(json)
    if json and string.nilorempty(json.rc) then
      local serverInfo = PlayerData.ServerData.security_levels[tostring(DataModel.curBuildId)]
      local pondServerInfo = serverInfo[tostring(DataModel.curPondId)]
      local rewards = pondServerInfo.rewards or {}
      table.insert(rewards, info.idx - 1)
      pondServerInfo.rewards = rewards
      info.received = true
      DataModel.Sort()
      View.ScrollGrid_List.grid.self:RefreshAllElement()
      CommonTips.OpenShowItem(json.reward, function()
        CommonTips.OpenRepLvUp()
      end)
      local isAllReceived = true
      for k, v in pairs(DataModel.rewardInfo) do
        if v.canGet and not v.received then
          isAllReceived = false
          break
        end
      end
      if isAllReceived then
        RedpointTree:ChangeRedpointCnt(RedPointNodeStr.RedPointNodeStr.HomeSafeLevel .. DataModel.curBuildId .. "|" .. DataModel.curPondId, -1)
      end
      View.StaticGrid_Tab.grid.self:RefreshAllElement()
      View.ScrollGrid_Tab.grid.self:RefreshAllElement()
    end
  end, DataModel.curPondId, info.idx - 1)
end

return Controller
