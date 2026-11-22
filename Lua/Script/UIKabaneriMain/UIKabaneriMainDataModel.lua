local DataModel = {
  config = nil,
  deltaTime = 0.2,
  mapType = "Limit",
  gameTime = 0,
  gameLimit = 0,
  screenEffectLimit = 0,
  warningTime = 0,
  isGameStart = false,
  gameGrid = 0,
  score = 0,
  timeEvents = {},
  gridEvents = {},
  buffEvents = {},
  timeLimitBuff = {},
  tickFunc = {},
  trainProperty = {},
  item = {},
  buffList = {},
  baseEnemyProperty = {},
  hpGrow = 0,
  mapCA = nil,
  unitGroupPlus = 0,
  speedPlus = 0,
  drillAtk = 0,
  armor = 0,
  shield = 0,
  whosyourdaddyTime = 0,
  buffTipsBuffid = -1,
  TrainRushEffectPath = "UI/UIEffect/particle/UI_train_rush_ele/UI_train_rush_ele_01",
  RushTimeBtnEffectPath = "UI/UIEffect/particle/UI_rushTimeBtn/UI_rushTimeBtn_01",
  RushBuyBtnEffectPath = "UI/UIEffect/particle/UI_rushBuyBtn/UI_rushBuyBtn",
  MainRushEffectPath = "UI/UIEffect/particle/UI_mainRush/UI_mainRush",
  TrainStrikeEffectPath = "UI/UIEffect/particle/UI_train_strike/UI_train_strike",
  WarningEffectPath = "UI/UIEffect/particle/UI_Warning/UI_Warning_Particle",
  beReadyMulRoad = 0,
  curPointIndex = 0,
  isPause = false,
  isShowTrainDetailAttr = false
}

function DataModel.Reset()
  DataModel.unitGroupPlus = 0
  DataModel.deltaTime = Time.deltaTime
  DataModel.gameTime = 0
  DataModel.screenEffectLimit = 0
  DataModel.gameGrid = 0
  DataModel.score = 0
  DataModel.beReadyMulRoad = 0
  DataModel.hasMiddle = nil
  DataModel.hasLeft = nil
  DataModel.hasRight = nil
  DataModel.curPointIndex = 0
  DataModel.isPause = false
  DataModel.speedPlus = 0
  DataModel.armor = 0
  DataModel.rewards = nil
  DataModel.isShowTrainDetailAttr = false
  DataModel.hasRushClick = false
  DataModel.lastRushNum = nil
  DataModel.config = PlayerData:GetFactoryData(99900084, "ConfigFactory")
  DataModel.tickFunc = {}
  DataModel.timeLimitBuff = {}
  DataModel.whosyourdaddyTime = 0
end

function DataModel.InitBaseEnemy(list)
  for i, v in pairs(list) do
    DataModel.baseEnemyProperty[v.monsID] = 0
  end
end

function DataModel.RefreshBaseEnemy()
  local baseHp = DataModel.mapCA.baseMonsterHp
  local p1 = DataModel.mapCA.baseMonsterHpP1
  local p2 = DataModel.mapCA.baseMonsterHpP2
  local randomHp = DataModel.mapCA.baseMonsterHpRandom
  for i, v in pairs(DataModel.baseEnemyProperty) do
    DataModel.baseEnemyProperty[i] = baseHp - p1 / DataModel.gameTime ^ (DataModel.gameTime / p2)
    TrainBattleUnitManager:SetBaseEnemeyHp(i, math.ceil(DataModel.baseEnemyProperty[i]), randomHp)
  end
end

function DataModel.RefreshBaseCount()
  local baseCount = DataModel.mapCA.baseMonsterNum
  local p1 = DataModel.mapCA.baseMonsterNumP1
  local p2 = DataModel.mapCA.baseMonsterNumP2
  baseCount = math.floor(baseCount - p1 / DataModel.gameTime ^ (DataModel.gameTime / p2))
  local totleWeight = 0
  local len = table.count(DataModel.mapCA.monsterGenertor)
  local data = {}
  for i = 1, len do
    if DataModel.gameTime >= DataModel.mapCA.monsterGenertor[i].startTime and DataModel.gameTime < DataModel.mapCA.monsterGenertor[i].endTime then
      totleWeight = totleWeight + DataModel.mapCA.monsterGenertor[i].Weight
      data[DataModel.mapCA.monsterGenertor[i].monsID] = DataModel.mapCA.monsterGenertor[i].Weight
    end
  end
  for i, v in pairs(data) do
    local num = math.floor(baseCount * (v / totleWeight) + DataModel.unitGroupPlus)
    KBTrainManager.map:SetBaseCount(i, num)
  end
end

function DataModel.RefreshAtkParam()
  KBTrainManager.map.atkParam = DataModel.mapCA.baseMonsterAtk
end

function DataModel.GetTrainArmor()
  local result = 0
  local coachIds = PlayerData:GetHomeInfo().coach_template
  for k, v in pairs(coachIds) do
    local coachInfo = PlayerData:GetHomeInfo().coach_store[v]
    local id = tonumber(coachInfo.id)
    local ca = PlayerData:GetFactoryData(id, "HomeCoachFactory")
    result = result + ca.Armor
  end
  result = result + TrainWeaponTag.GetWeaponTagAttributes(EnumDefine.TrainWeaponTagEnum.TrainHP, result)
  return result
end

function DataModel.GetItem(id)
end

function DataModel.SetItem(id, val)
end

function DataModel.GetBuff(num)
  if table.count(DataModel.buffList) == 0 then
    return
  end
  local buffunit = {}
  local totalWeight = 0
  for i, v in pairs(DataModel.buffList) do
    totalWeight = totalWeight + v.weight
  end
  local randomMax = 1000
  for i = 1, num do
    local isContinus = true
    while isContinus and 0 < randomMax do
      randomMax = randomMax - 1
      local randomWeight = math.random() * totalWeight
      local accumulatedWeight = 0
      for _, item in ipairs(DataModel.buffList) do
        accumulatedWeight = accumulatedWeight + item.weight
        if randomWeight <= accumulatedWeight then
          if DataModel.ContiansBuff(buffunit, item) == false then
            table.insert(buffunit, item.buff)
            isContinus = false
          end
          break
        end
      end
    end
  end
  return buffunit
end

function DataModel.ContiansBuff(buffunit, item)
  for _, v in pairs(buffunit) do
    if v == item then
      return true
    end
  end
  return false
end

function DataModel.InitRewards(rewards)
  DataModel.rewards = {}
  for _, list in pairs(rewards) do
    for k, v in pairs(list) do
      table.insert(DataModel.rewards, {
        id = k,
        num = v.num
      })
    end
  end
  table.sort(DataModel.rewards, function(a, b)
    local aCa = GetCA(a.id, "ItemFactory") or GetCA(a.id, "SourceMaterialFactory")
    local bCa = GetCA(b.id, "ItemFactory") or GetCA(b.id, "SourceMaterialFactory")
    return aCa.qualityInt > bCa.qualityInt
  end)
end

return DataModel
