local Order = {}
local jumpId = -1
local compareType = {
  LT = function(a, b)
    return a < b
  end,
  LE = function(a, b)
    return a <= b
  end,
  EQ = function(a, b)
    return a == b
  end,
  NE = function(a, b)
    return a ~= b
  end,
  GT = function(a, b)
    return b < a
  end,
  GE = function(a, b)
    return b <= a
  end
}

local function HeroNumInSquadsFunc(caInfo)
  local curSquadIdx = 1
  if UIManager:IsPanelOpened("UI/Squads/Squads") then
    local DataModel = require("UISquads/UISquadsDataModel")
    curSquadIdx = DataModel.curSquadIndex
  end
  local squadData = PlayerData.ServerData.squad[curSquadIdx]
  local count = 0
  if squadData and squadData.role_list then
    for k, v in pairs(squadData.role_list) do
      if type(v) == "table" and 0 < table.count(v) then
        count = count + 1
      end
    end
  end
  return count
end

local function GoodsNumFunc(caInfo)
  local value = math.modf(caInfo.val)
  local warehouse = PlayerData:GetHomeInfo().warehouse
  local goodInfo = warehouse[tostring(value)]
  if goodInfo then
    return goodInfo.num
  end
  return 0
end

local function BargainNumFunc(caInfo)
  if UIManager:IsPanelOpened("UI/HomeTrade/HomeTrade") then
    local DataModel = require("UIHomeTrade/UITradeDataModel")
    return DataModel.GetMaxBargainCount(true) - DataModel.CurCityGoodsInfo.b_num
  end
  return 0
end

local function RiseNumFunc(caInfo)
  if UIManager:IsPanelOpened("UI/HomeTrade/HomeTrade") then
    local DataModel = require("UIHomeTrade/UITradeDataModel")
    return DataModel.GetMaxBargainCount(false) - DataModel.CurCityGoodsInfo.r_num
  end
  return 0
end

local function GoodsCanBuyFunc(caInfo)
  if UIManager:IsPanelOpened("UI/HomeTrade/HomeTrade") then
    local DataModel = require("UIHomeTrade/UITradeDataModel")
    local value = tonumber(caInfo.val)
    local detailInfo = DataModel.IdToDetailInfo[value]
    if detailInfo then
      return detailInfo.num
    end
  end
  return 0
end

local function HomeEnergyFunc(caInfo)
  return PlayerData:GetUserInfo().move_energy or 0
end

local function IsActivated(caInfo)
  local isActivated = GuideManager:GetPanelUINodeIsActivated(caInfo.uiPath, caInfo.val)
  if isActivated then
    return 1
  end
  return 0
end

local function TradeLv(caInfo)
  return PlayerData:GetHomeInfo().trade_lv or 1
end

local function GoodsIndex(caInfo)
  if UIManager:IsPanelOpened("UI/HomeTrade/HomeTrade") then
    local DataModel = require("UIHomeTrade/UITradeDataModel")
    local value = math.modf(caInfo.val)
    local goodsTable = {}
    if DataModel.CurTradeType == DataModel.TradeType.Buy then
      goodsTable = DataModel.CurSellList
    elseif DataModel.CurTradeType == DataModel.TradeType.Sale then
      goodsTable = DataModel.CurAcquisitionList
    end
    for k, v in pairs(goodsTable) do
      if v.goodsId == value then
        return k
      end
    end
  end
  return -1
end

local function IsMale(caInfo)
  return PlayerData:GetUserInfo().gender
end

local function QuestCompleted(caInfo)
  local isComplete = PlayerData.IsQuestComplete(tonumber(caInfo.val))
  if isComplete then
    return 1
  end
  return 0
end

local function CaptainNumber(caInfo)
  local squadsDataModel = require("UISquads/UISquadsDataModel")
  local index = -1
  local curSquadInfo = PlayerData.ServerData.squad[squadsDataModel.curSquadIndex]
  if curSquadInfo then
    local headerId = curSquadInfo.header
    for k, v in pairs(curSquadInfo.role_list) do
      if tostring(v.id) == tostring(headerId) then
        index = k
        break
      end
    end
  end
  return index
end

local function IsInSquads(caInfo)
  local squadsDataModel = require("UISquads/UISquadsDataModel")
  local curSquadInfo = PlayerData.ServerData.squad[squadsDataModel.curSquadIndex]
  if curSquadInfo then
    for k, v in pairs(curSquadInfo.role_list) do
      if tostring(v.id) == tostring(caInfo.val) then
        return 1
      end
    end
  end
  return 0
end

local function CharacterLv(caInfo)
  local roleId = tostring(caInfo.val)
  local roleServerData = PlayerData.ServerData.roles[roleId]
  if roleServerData then
    return roleServerData.lv or 0
  end
  return 0
end

local function RemainingLoadage(caInfo)
  local now = PlayerData:GetUserInfo().space_info.now_train_goods_num or 0
  local max = PlayerData.GetMaxTrainGoodsNum()
  return max - now
end

local function IsArrived(caInfo)
  local TradeDataModel = require("UIHome/UIHomeTradeDataModel")
  if PlayerData:GetHomeInfo().station_info.is_arrived == 1 and tonumber(TradeDataModel.CurStayCity) == tonumber(caInfo.val) then
    return 1
  end
  return 0
end

local function ELECLevel(caInfo)
  return PlayerData:GetHomeInfo().electric_lv
end

local function AverageLevel(caInfo)
  local squadsDataModel = require("UISquads/UISquadsDataModel")
  local curSquadInfo = PlayerData.ServerData.squad[squadsDataModel.curSquadIndex]
  local lv = 0
  local cnt = 0
  if curSquadInfo then
    local roles = PlayerData.ServerData.roles
    for k, v in pairs(curSquadInfo.role_list) do
      if v.id then
        lv = lv + roles[tostring(v.id)].lv
        cnt = cnt + 1
      end
    end
  end
  if 0 < cnt then
    return math.floor(lv / cnt + 1.0E-5)
  end
  return 0
end

local function TrainLength(caInfo)
  return #PlayerData:GetHomeInfo().coach_template
end

local function AchievementCompleted(caInfo)
  local achieve_quests = PlayerData.ServerData.quests.achieve_quests or {}
  local quest = achieve_quests[tostring(caInfo.val)]
  if quest and quest.completed_ts and quest.completed_ts > 0 then
    return 1
  end
  return 0
end

local function QuestProgress(caInfo)
  local serverQuests = PlayerData.ServerData.quests
  local questCA = PlayerData:GetFactoryData(caInfo.val)
  local keyName
  if questCA.questType == "Main" then
    keyName = "mq_quests"
  elseif questCA.questType == "Side" then
    keyName = "branch_quests"
  elseif questCA.questType == "Home" then
    local stations = PlayerData:GetHomeInfo().stations
    if stations ~= nil then
      local quests = stations[tostring(questCA.startStation)].quests
      local curQuestInfo = quests ~= nil and quests.Buy and quests.Buy[caInfo.val] and quests.Buy[caInfo.val]
    end
  end
  if serverQuests[keyName] and serverQuests[keyName][caInfo.val] then
    return serverQuests[keyName][caInfo.val].pcnt or 0
  end
  return 0
end

local function IsHaveCOCQuest(caInfo)
  local function isHaveTargetStationQuest(quests, type, targetStationId)
    local typeQuests = quests[type]
    
    if typeQuests then
      for questId, questInfo in pairs(typeQuests) do
        if questInfo.time > 0 and tostring(questInfo.sid) == targetStationId then
          return true
        end
      end
    end
    return false
  end
  
  for stationId, stationInfo in pairs(PlayerData:GetHomeInfo().stations) do
    local quests = stationInfo.quests
    if quests then
      if isHaveTargetStationQuest(quests, "Passenger", caInfo.val) then
        return 1
      end
      if isHaveTargetStationQuest(quests, "Send", caInfo.val) then
        return 1
      end
    end
  end
  return 0
end

local function LevelCompleted(caInfo)
  if PlayerData:GetLevelPass(caInfo.val) then
    return 1
  end
  return 0
end

local function IsCanReso(caInfo)
  local roleId = tostring(caInfo.val)
  local roleServerData = PlayerData:GetRoleById(roleId)
  if roleServerData then
    local resonance_lv = roleServerData.resonance_lv
    local roleCA = PlayerData:GetFactoryData(roleId)
    if resonance_lv + 1 > #roleCA.awakeList then
      return 0
    end
    local awakeId = roleCA.awakeList[resonance_lv + 1].awakeId
    local data = PlayerData:GetFactoryData(awakeId, "AwakeFactory")
    for i, v in ipairs(data.materialList) do
      if PlayerData:GetGoodsById(v.id) < v.num then
        return 0
      end
    end
    return 1
  end
  return 0
end

local function IsCaptain(caInfo)
  local roleId = tostring(caInfo.val)
  local squadsDataModel = require("UISquads/UISquadsDataModel")
  local curSquadInfo = PlayerData.ServerData.squad[squadsDataModel.curSquadIndex]
  if curSquadInfo then
    local headerId = curSquadInfo.header
    if tostring(headerId) == roleId then
      return 1
    end
  end
  return 0
end

local function GuideNo(caInfo)
  return GuideManager:GetCurrentClientGuideNO()
end

local EnumFunc = {
  HeroNumInSquads = HeroNumInSquadsFunc,
  GoodsNum = GoodsNumFunc,
  BargainNum = BargainNumFunc,
  RiseNum = RiseNumFunc,
  GoodsCanBuy = GoodsCanBuyFunc,
  HomeEnergy = HomeEnergyFunc,
  IsActivated = IsActivated,
  TradeLv = TradeLv,
  GoodsIndex = GoodsIndex,
  IsMale = IsMale,
  QuestCompleted = QuestCompleted,
  CaptainNumber = CaptainNumber,
  IsInSquads = IsInSquads,
  CharacterLv = CharacterLv,
  RemainingLoadage = RemainingLoadage,
  IsArrived = IsArrived,
  ELECLevel = ELECLevel,
  AverageLevel = AverageLevel,
  TrainLength = TrainLength,
  AchievementCompleted = AchievementCompleted,
  QuestProgress = QuestProgress,
  IsHaveCOCQuest = IsHaveCOCQuest,
  LevelCompleted = LevelCompleted,
  IsCanReso = IsCanReso,
  IsCaptain = IsCaptain,
  GuideNo = GuideNo
}

local function GetKeyEnumData(caInfo)
  if EnumFunc[caInfo.key] then
    return EnumFunc[caInfo.key](caInfo)
  end
  return nil
end

local function checkFunc(ca)
  local checkOk = true
  for k, v in pairs(ca.keyList) do
    local data = GetKeyEnumData(v)
    local result = data and compareType[v.compareType](data, v.num) or false
    checkOk = checkOk and result
    if not result then
      break
    end
  end
  return checkOk
end

local caCache

function Order:OnStart(ca)
  caCache = ca
  jumpId = -1
  if not ca.isLoop then
    local checkOk = checkFunc(ca)
    if checkOk then
      jumpId = ca.trueLabel
    else
      jumpId = ca.falseLabel
    end
  end
end

function Order:GetJumpToOrderId()
  return jumpId
end

function Order:IsFinish()
  if caCache.isLoop then
    return checkFunc(caCache)
  else
    return true
  end
end

return Order
