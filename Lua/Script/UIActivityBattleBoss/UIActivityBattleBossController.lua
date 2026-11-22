local CommonItem = require("Common/BtnItem")
local View = require("UIActivityBattleBoss/UIActivityBattleBossView")
local DataModel = require("UIActivityBattleBoss/UIActivityBattleBossDataModel")
local Controller = {}

function Controller:Init(initParams)
  DataModel:Init(initParams)
  View.Group_Main.Group_Preview.self:SetActive(false)
  if DataModel.ActivityCA.rewardPreviewList and table.count(DataModel.ActivityCA.rewardPreviewList) > 0 then
    DataModel.NotJoinReward = {}
    for k, v in pairs(DataModel.ActivityCA.rewardPreviewList) do
      table.insert(DataModel.RewardList, v)
    end
    View.Group_Main.Txt_Name:SetActive(not CommonTips.IsResEN())
    View.Group_Main.Group_Preview.self:SetActive(true)
    View.Group_Main.Group_Preview.ScrollGrid_Reward.grid.self:SetDataCount(table.count(DataModel.RewardList))
    View.Group_Main.Group_Preview.ScrollGrid_Reward.grid.self:RefreshAllElement()
  end
  View.Group_Main.Btn_Plot.self:SetActive(PlayerData.plot_paragraph[tostring(DataModel.TurntableCA.FirstParagraphid)] ~= nil)
  local isOpen = PlayerData:GetPlayerLevel() >= DataModel.ActivityCA.openLv
  View.Group_Main.Btn_Open.self:SetActive(isOpen)
  View.Group_Main.Group_Lock.self:SetActive(not isOpen)
  View.Group_Main.Group_Lock.Txt_T:SetText(string.format(GetText(80611024), DataModel.ActivityCA.openLv))
  Net:SendProto("station.turntable_battle", function(json)
    DataModel.BatterInfo = json.ttb_level[tostring(DataModel.StationCA.id)]
    local progressAll = 0
    local progressAllMax = 0
    for i, v in ipairs(DataModel.TurntableCA.levelBossList) do
      local data = DataModel.TurntableCA.levelBossList[i]
      local levelList = PlayerData:GetFactoryData(data.id).levelList
      local levelCountMax = #levelList
      local progress = DataModel:GetCurrentLevelData(i - 1, levelCountMax)
      progressAll = progressAll + progress
      progressAllMax = progressAllMax + levelCountMax
    end
    local progress = PlayerData:GetPreciseDecimalFloor(progressAll / progressAllMax * 100, 0)
    View.Group_Main.Group_Progress.Txt_Num:SetText(progress .. "%" .. " (" .. progressAll .. "/" .. progressAllMax .. ")")
  end, DataModel.StationCA.id)
end

function DataModel:GetCurrentLevelData(index, max)
  local count = 0
  local currentInfo = DataModel.BatterInfo[tostring(index)]
  if currentInfo then
    count = currentInfo.cnt
  end
  return max < count and max or count
end

function Controller:RewardSetElemnt(element, elementIndex)
  local row = DataModel.RewardList[elementIndex]
  CommonItem:SetActivityPreviewItem(element.Group_Item, row)
  element.Group_Item.Btn_Item:SetClickParam(row.id)
end

function Controller:RewardClickElemnt(id)
  CommonTips.OpenPreRewardDetailTips(id)
end

function Controller:PlayDialog()
  local function callBack()
  end
  
  if DataModel.TurntableCA.clickParagraphid and DataModel.TurntableCA.clickParagraphid ~= "" and DataModel.TurntableCA.clickParagraphid > -1 then
    UIManager:Open("UI/Dialog/Dialog", Json.encode({
      id = DataModel.TurntableCA.clickParagraphid
    }), callBack, callBack)
  end
end

function Controller:OpenBattleBoss()
  UIManager:Open("UI/Chapter/Battle_Boss/Battle_Boss", Json.encode({
    stationId = DataModel.StationCA.id,
    turntableId = DataModel.StationCA.turntableId,
    isActivity = true,
    activityId = DataModel.ActivityId
  }))
end

function Controller:OpenBattleBossStore()
  local buildingCA = PlayerData:GetFactoryData(DataModel.StationCA.turnExchangeBuildId, "BuildingFactory")
  if PlayerData:GetUserInfo().lv < (buildingCA.playerLevel or 0) then
    return
  end
  local storeList = buildingCA.exchangeStoreList
  local storeId, remainTime, isOpen
  for i = 1, #storeList do
    isOpen, remainTime = PlayerData:IsStoreOpen(storeList[i].id)
    if isOpen then
      storeId = storeList[i].id
      break
    end
  end
  if not isOpen then
    return
  end
  Net:SendProto("shop.info", function(json)
    UIManager:Open(buildingCA.uiPath, Json.encode({
      buildingId = DataModel.StationCA.turnExchangeBuildId,
      isCityMapIn = false,
      name = buildingCA.name,
      initMode = "Exchange"
    }))
    PlayerData:TryPlayPlotByParagraphID(buildingCA.firstPlotId)
  end, storeId)
end

return Controller
