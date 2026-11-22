local DataModel = require("UICubeRogueMain/UICubeRogueMainDataModel")
local EnumFunOrderType = {
  DiscardParam = "DiscardParam",
  Discard = "Discard",
  LevelUp = "LevelUp",
  Recover = "Recover"
}
Enum_AttrType = {
  Battle = "Battle",
  Price = "Price",
  IntensifyPrice = "IntensifyPrice",
  InitialAction = "InitialAction",
  Revive = "Revive",
  GetSpecialBoss = "GetSpecialBoss",
  GetCoinPercentBattle = "GetCoinPercentBattle",
  GetCoinPercentElse = "GetCoinPercentElse",
  GetCoinPercentBoss = "GetCoinPercentBoss",
  StartGetMultiple = "StartGetMultiple",
  IntuitionMaxNum = "IntuitionMaxNum",
  BanRevive = "BanRevive",
  BossBattle = "BossBattle"
}
Enum_TriggerTiming = {
  RoundStart = "RoundStart",
  RoundEnd = "RoundEnd",
  GetCoin = "GetCoin",
  LoseCoin = "LoseCoin",
  MoveEnd = "MoveEnd",
  Turn = "Turn",
  Enter = "Enter",
  GetWeapon = "GetWeapon",
  GetSpecial = "GetSpecial",
  LoseBuff = "LoseBuff",
  BattleVictory = "BattleVictory"
}
local ConditionAttrEquipList = {
  ["89600077"] = 1
}
local ConditionBattleSkillEquipList = {
  ["89600071"] = 1,
  ["89600045"] = 1,
  ["89600060"] = 1,
  ["89600032"] = 1
}
local BattleSkillEffectByAttrEquipList = {
  ["89600076"] = 1,
  ["89600074"] = 1
}
local manager = {}

function manager:InitData()
  self.attrDic = {}
  self.skillDic = {}
  self.triggerDic = {}
  for equipId, v in pairs(PlayerData.TempCache.CubeRogueData.equips) do
    if self:CheckEquipBuffActive(equipId) then
      self:AddEquipBuff(equipId)
    end
  end
end

local function CheckNeedClientDeal(effectOrderId)
  local effectOrderCA = PlayerData:GetFactoryData(effectOrderId, "RogueOrderFactory")
  if effectOrderCA.orderType == "Intensify" then
    return false
  elseif effectOrderCA.orderType == "Reward" then
    return false
  elseif effectOrderCA.orderType == "GetCoinCurrent" then
    return false
  end
  return true
end

function manager:MoveRefresh(typeId)
  typeId = tostring(typeId)
  for equipId, equipData in pairs(PlayerData.TempCache.CubeRogueData.equips) do
    local equipCA = PlayerData:GetFactoryData(equipId, "RogueEquipmentFactory")
    if not (not (equipCA.efficacyNum < 0) and equipData.use) or equipData.use < equipCA.efficacyNum then
      local conditionInfo = equipCA.conditionList[1]
      if conditionInfo and 0 < conditionInfo.conditionId and CheckNeedClientDeal(conditionInfo.effectId) then
        local conditionOrderCA = PlayerData:GetFactoryData(conditionInfo.conditionId, "RogueOrderFactory")
        if conditionOrderCA.orderType == "SameColor" then
          local sameColorList = {}
          for i, v in pairs(conditionOrderCA.typeId) do
            sameColorList[tostring(v.id)] = 1
          end
          if equipData.clientSameColorMoveNum then
            if sameColorList[typeId] then
              equipData.clientSameColorMoveNum = equipData.clientSameColorMoveNum + 1
            else
              equipData.clientSameColorMoveNum = 0
            end
          else
            local clientSameColorMoveNum = 0
            if sameColorList[typeId] then
              clientSameColorMoveNum = clientSameColorMoveNum + 1
            end
            if equipData and equipData.color then
              for i = #equipData.color, 1, -1 do
                if sameColorList[equipData.color[i]] then
                  clientSameColorMoveNum = clientSameColorMoveNum + 1
                else
                  break
                end
              end
            end
            equipData.clientSameColorMoveNum = clientSameColorMoveNum
          end
        end
      end
    end
  end
end

function manager:GetAttr(attrType)
  local num = 0
  for equipId, v in pairs(self.attrDic) do
    if v[attrType] then
      num = num + v[attrType]
    end
  end
  local attrList = self:GetEquipConditionAttr()
  if attrList[attrType] then
    num = num + attrList[attrType]
  end
  return num
end

function manager:GetBattleSkill()
  local skill = {}
  for equipId, v in pairs(self.skillDic) do
    for orderId, skillInfo in pairs(v) do
      if skillInfo.skillId ~= nil then
        skill[skillInfo.skillId] = skillInfo.val
      else
        logError("\230\156\170\233\133\141\231\189\174\230\138\128\232\131\189\231\154\132\230\136\152\230\150\151\230\140\135\228\187\164Id\239\188\154" .. orderId)
      end
    end
  end
  local conditionBattleSkill = self:GetEquipConditionBattleSkill()
  for skillId, value in pairs(conditionBattleSkill) do
    if skill[skillId] then
      skill[skillId] = skill[skillId] + value
    else
      skill[skillId] = value
    end
  end
  local effectByAttrBattleSkill = self:GetEquipEffectByAttrBattleSkill()
  for skillId, value in pairs(effectByAttrBattleSkill) do
    if skill[skillId] then
      skill[skillId] = skill[skillId] + value
    else
      skill[skillId] = value
    end
  end
  return skill
end

function manager:TriggerByTimingType(timingType, conditionArgs, serverValList, callBack)
  local uiTipData = {}
  for equipId, v in pairs(self.triggerDic) do
    local equipData = PlayerData.TempCache.CubeRogueData.equips[equipId]
    local equipCA = PlayerData:GetFactoryData(equipId, "RogueEquipmentFactory")
    local triggers = v[timingType]
    if triggers then
      for i, info in ipairs(triggers) do
        local effectOrderId = info.effectOrderId
        local conditionOrderId = info.conditionOrderId
        local effectOrderCA = PlayerData:GetFactoryData(effectOrderId, "RogueOrderFactory")
        if 0 < conditionOrderId then
          local conditionOrderCA = PlayerData:GetFactoryData(conditionOrderId, "RogueOrderFactory")
          conditionArgs = conditionArgs or {}
          conditionArgs.equipId = equipId
          local conditionOrderType = conditionOrderCA.orderType
          if conditionOrderType == "EveryGet" then
            conditionArgs.getNum = conditionArgs.getNum
            conditionArgs.effectId = effectOrderId
          elseif conditionOrderType == "EveryLose" then
            conditionArgs.loseNum = conditionArgs.loseNum
          end
        end
        local effectNum = self:CheckCondition(conditionOrderId, conditionArgs)
        if 0 < effectNum then
          if 0 < conditionOrderId then
            local conditionOrderCA = PlayerData:GetFactoryData(conditionOrderId, "RogueOrderFactory")
            local conditionOrderType = conditionOrderCA.orderType
            if conditionOrderType == "EveryGet" then
              local num = math.abs(effectOrderCA.param) * effectNum
              if not equipData.orders then
                equipData.orders = {}
              end
              if not equipData.orders[tostring(effectOrderId)] then
                equipData.orders[tostring(effectOrderId)] = {}
              end
              local orderData = equipData.orders[tostring(effectOrderId)]
              local oldNum = orderData and orderData.dirt_get or 0
              orderData.dirt_get = conditionArgs.getNum + oldNum - num
            elseif conditionOrderType == "EveryLose" then
              if not equipData.orders then
                equipData.orders = {}
              end
              if not equipData.orders[tostring(effectOrderId)] then
                equipData.orders[tostring(effectOrderId)] = {}
              end
              local orderData = equipData.orders[tostring(effectOrderId)]
              local oldNum = orderData.dirt_lose or 0
              orderData.dirt_lose = conditionArgs.loseNum + oldNum
            end
          end
          if EnumFunOrderType[effectOrderCA.orderType] then
            local data = self:DealFunOrder(equipId, effectOrderId, effectNum)
            if data then
              table.insert(uiTipData, data)
            end
          else
            local serverValData = serverValList and serverValList[tostring(effectOrderId)]
            local value = serverValData and serverValData.param or effectNum * effectOrderCA.param
            self:AddBuff(equipId, effectOrderId, value)
          end
          if 0 < equipCA.efficacyNum then
            if not equipData.use then
              equipData.use = 0
            end
            equipData.use = equipData.use + effectNum
            if equipData.use == equipData.efficacyNum then
              self.triggerDic[equipId] = nil
            end
          end
        end
      end
    end
  end
  if callBack then
    callBack(timingType, conditionArgs, serverValList)
  end
  return uiTipData
end

function manager:CheckCondition(conditionOrderId, conditionArgs)
  if conditionOrderId <= 0 then
    return 1
  end
  local conditionOrderCA = PlayerData:GetFactoryData(conditionOrderId, "RogueOrderFactory")
  local orderType = conditionOrderCA.orderType
  if orderType == "SameColor" then
    local equipData = PlayerData.TempCache.CubeRogueData.equips[conditionArgs.equipId]
    return equipData.clientSameColorMoveNum >= conditionOrderCA.param and 1 or 0
  elseif orderType == "EveryGet" then
    local getNum = conditionArgs and conditionArgs.getNum or 0
    local equipData = PlayerData.TempCache.CubeRogueData.equips[tostring(conditionArgs.equipId)]
    local orderData = equipData.orders and equipData.orders[tostring(conditionArgs.effectId)]
    local oldNum = orderData and orderData.dirt_get or 0
    return math.floor((getNum + oldNum) / conditionOrderCA.param)
  elseif orderType == "EveryLose" then
    local loseNum = conditionArgs and conditionArgs.loseNum or 0
    return math.floor(loseNum / conditionOrderCA.param)
  elseif orderType == "Center" then
    return DataModel.GetPlayerPos() == DataModel.Enum_PlayerPos.Center and 1 or 0
  elseif orderType == "Plane" then
    local cfg = DataModel.cfg or PlayerData:GetFactoryData(PlayerData.TempCache.CubeRogueData.cube_id)
    return cfg.faceIndex == conditionOrderCA.param and 1 or 0
  elseif orderType == "Hornblock" then
    return DataModel.GetPlayerPos() == DataModel.Enum_PlayerPos.Corner and 1 or 0
  elseif orderType == "Edge" then
    return DataModel.GetPlayerPos() == DataModel.Enum_PlayerPos.Side and 1 or 0
  elseif orderType == "IfCoinEnough" then
    local cubeRogueCA = PlayerData:GetFactoryData(89400002, "CubeRogueFactory")
    local itemId = cubeRogueCA.coinId
    return PlayerData:GetGoodsById(itemId).num >= conditionOrderCA.param and 1 or 0
  end
  return 1
end

function manager:GetEquipConditionAttr()
  local attrList = {}
  for equipId, _ in pairs(ConditionAttrEquipList) do
    local equipData = PlayerData.TempCache.CubeRogueData.equips[tostring(equipId)]
    if equipData then
      local equipCA = PlayerData:GetFactoryData(equipId, "RogueEquipmentFactory")
      local conditionInfo = equipCA.conditionList[1]
      if conditionInfo and self:CheckCondition(conditionInfo.conditionId) > 0 then
        local effectOrderCA = PlayerData:GetFactoryData(conditionInfo.effectId, "RogueOrderFactory")
        if not attrList[effectOrderCA.orderType] then
          attrList[effectOrderCA.orderType] = effectOrderCA.param
        else
          attrList[effectOrderCA.orderType] = attrList[effectOrderCA.orderType] + effectOrderCA.param
        end
      end
    end
  end
  return attrList
end

function manager:GetEquipConditionBattleSkill()
  local skillList = {}
  for equipId, _ in pairs(ConditionBattleSkillEquipList) do
    local equipData = PlayerData.TempCache.CubeRogueData.equips[tostring(equipId)]
    if equipData then
      local equipCA = PlayerData:GetFactoryData(equipId, "RogueEquipmentFactory")
      local conditionInfo = equipCA.conditionList[1]
      if conditionInfo and self:CheckCondition(conditionInfo.conditionId) > 0 then
        local effectOrderCA = PlayerData:GetFactoryData(conditionInfo.effectId, "RogueOrderFactory")
        if not skillList[effectOrderCA.skillId] then
          skillList[effectOrderCA.skillId] = effectOrderCA.param
        else
          skillList[effectOrderCA.skillId] = skillList[effectOrderCA.skillId] + effectOrderCA.param
        end
      end
    end
  end
  return skillList
end

function manager:GetEquipEffectByAttrBattleSkill()
  local skillList = {}
  for equipId, _ in pairs(BattleSkillEffectByAttrEquipList) do
    local equipData = PlayerData.TempCache.CubeRogueData.equips[tostring(equipId)]
    if equipData then
      local equipCA = PlayerData:GetFactoryData(equipId, "RogueEquipmentFactory")
      local conditionInfo = equipCA.conditionList[1]
      if conditionInfo then
        local effectOrderId = conditionInfo.effectId
        local effectOrderCA = PlayerData:GetFactoryData(effectOrderId, "RogueOrderFactory")
        local conditionOrderId = conditionInfo.conditionId
        if 0 < conditionOrderId then
          local conditionOrderCA = PlayerData:GetFactoryData(conditionOrderId, "RogueOrderFactory")
          local orderType = conditionOrderCA.orderType
          local skillValue = 0
          if orderType == "CurrentNum" then
            local cubeRogueCA = PlayerData:GetFactoryData(89400002, "CubeRogueFactory")
            local itemId = cubeRogueCA.coinId
            skillValue = math.floor(PlayerData:GetGoodsById(itemId).num / conditionOrderCA.param) * effectOrderCA.param
          end
          if not skillList[effectOrderCA.skillId] then
            skillList[effectOrderCA.skillId] = skillValue
          else
            skillList[effectOrderCA.skillId] = skillList[effectOrderCA.skillId] + skillValue
          end
        end
      end
    end
  end
  return skillList
end

function manager:AddEquipBuff(equipId)
  if ConditionAttrEquipList[equipId] or ConditionBattleSkillEquipList[equipId] or BattleSkillEffectByAttrEquipList[equipId] then
    return
  end
  equipId = tostring(equipId)
  local equipCA = PlayerData:GetFactoryData(equipId, "RogueEquipmentFactory")
  for i, conditionInfo in ipairs(equipCA.conditionList) do
    if CheckNeedClientDeal(conditionInfo.effectId) then
      if not self.triggerDic[equipId] then
        self.triggerDic[equipId] = {}
      end
      if not self.triggerDic[equipId][conditionInfo.opportunity] then
        self.triggerDic[equipId][conditionInfo.opportunity] = {}
      end
      table.insert(self.triggerDic[equipId][conditionInfo.opportunity], {
        conditionOrderId = conditionInfo.conditionId,
        effectOrderId = conditionInfo.effectId
      })
    end
  end
  for i, attributeInfo in ipairs(equipCA.attributeList) do
    local orderId = attributeInfo.id
    local effectOrderCA = PlayerData:GetFactoryData(orderId, "RogueOrderFactory")
    local value = effectOrderCA.param
    local equipData = PlayerData.TempCache.CubeRogueData.equips[tostring(equipId)]
    if equipData.effect then
      value = effectOrderCA.param * equipData.effect
    else
      local orderData = equipData.orders and equipData.orders[tostring(orderId)]
      if orderData and orderData.param then
        value = effectOrderCA.param
      end
    end
    self:AddBuff(equipId, orderId, value)
  end
end

function manager:AddBuff(equipId, effectId, value)
  if ConditionAttrEquipList[equipId] or ConditionBattleSkillEquipList[equipId] or BattleSkillEffectByAttrEquipList[equipId] then
    return
  end
  local effectOrderCA = PlayerData:GetFactoryData(effectId, "RogueOrderFactory")
  local orderType = effectOrderCA.orderType
  if Enum_AttrType[orderType] then
    if orderType == Enum_AttrType.Battle then
      if not self.skillDic[equipId] then
        self.skillDic[equipId] = {}
      end
      self.skillDic[equipId][effectId] = {
        skillId = effectOrderCA.skillId,
        val = -1
      }
    else
      if not self.attrDic[equipId] then
        self.attrDic[equipId] = {}
      end
      local curVal = self.attrDic[equipId][orderType] or 0
      self.attrDic[equipId][orderType] = curVal + value
    end
  elseif orderType == "Skill" then
    if not self.skillDic[equipId] then
      self.skillDic[equipId] = {}
    end
    if not self.skillDic[equipId][effectId] then
      self.skillDic[equipId][effectId] = {
        skillId = effectOrderCA.skillId,
        val = value
      }
    elseif orderType == "Skill" then
      self.skillDic[equipId][effectId].val = self.skillDic[equipId][effectId].val + value
    end
  end
end

function manager:RemoveEquip(equipId)
  self.triggerDic[equipId] = nil
  self:RemoveEquipBuff(equipId)
end

function manager:RemoveEquipBuff(equipId)
  local equipCA = PlayerData:GetFactoryData(equipId, "RogueEquipmentFactory")
  if equipCA.isSaveEffect then
    return
  end
  if self.attrDic[equipId] then
    self.attrDic[equipId] = nil
  end
  if self.skillDic[equipId] then
    self.skillDic[equipId] = nil
  end
end

function manager:RefreshEffectNumByAttrType(attrType)
  for equipId, v in pairs(self.attrDic) do
    local equipCA = PlayerData:GetFactoryData(equipId, "RogueEquipmentFactory")
    if equipCA.efficacyNum > 0 and v[attrType] then
      local equipData = PlayerData.TempCache.CubeRogueData.equips[tostring(equipId)]
      if not equipData.use then
        equipData.use = 0
      end
      equipData.use = equipData.use + 1
      if equipData.use == equipCA.efficacyNum and not equipCA.isSaveEffect then
        v[attrType] = 0
        if UIManager:IsPanelOpened("UICubeRogueMain/UICubeRoguewMainController") then
          local RogueController = require("UICubeRogueMain/UICubeRoguewMainController")
          RogueController.ShowEquips()
        end
      end
    end
  end
end

function manager:CheckEquipBuffActive(equipId)
  local equipCA = PlayerData:GetFactoryData(equipId, "RogueEquipmentFactory")
  if equipCA.efficacyNum < 0 then
    return true
  end
  local equipData = PlayerData.TempCache.CubeRogueData.equips[tostring(equipId)]
  if not equipData then
    return false
  end
  local useNum = equipData.use or 0
  return useNum < equipCA.efficacyNum
end

function manager:DealFunOrder(equipId, effectId, effectNum)
  equipId = tostring(equipId)
  local effectCA = PlayerData:GetFactoryData(effectId, "RogueOrderFactory")
  local orderType = effectCA.orderType
  if orderType == "LevelUp" then
    local allRoles = PlayerData.TempCache.CubeRogueData.roles
    for k, role in pairs(allRoles) do
      role.ex_lv = role.ex_lv or 0
      role.ex_lv = role.ex_lv + effectCA.param
    end
  elseif orderType == "Discard" then
    local useItems = {}
    local loseCoinData = {}
    local allCfg = DataModel.allConfig or PlayerData:GetFactoryData(89400002)
    for m, n in pairs(effectCA.discardList) do
      useItems[tostring(n.id)] = math.min(n.num, PlayerData:GetGoodsById(n.id).num)
      if n.id == allCfg.coinId then
        table.insert(loseCoinData, n)
        self:TriggerByTimingType(Enum_TriggerTiming.LoseCoin, {
          loseNum = n.num
        })
      end
    end
    PlayerData:RefreshUseItems(useItems)
    return {ptype = "lose_gold", data = loseCoinData}
  elseif orderType == "DiscardParam" then
    local useItems = {}
    local loseCoinData = {}
    local allCfg = DataModel.allConfig or PlayerData:GetFactoryData(89400002)
    local itemId = allCfg.coinId
    local num = math.abs(effectCA.param) * effectNum
    useItems[itemId] = num
    table.insert(loseCoinData, {id = itemId, num = num})
    PlayerData:RefreshUseItems(useItems)
    self:TriggerByTimingType(Enum_TriggerTiming.LoseCoin, {loseNum = num})
    return {ptype = "lose_gold", data = loseCoinData}
  elseif orderType == "Recover" then
    local RogueController = require("UICubeRogueMain/UICubeRoguewMainController")
    RogueController.SetRoleHp(effectCA.recoverType, effectCA.param * effectNum)
  end
end

return manager
