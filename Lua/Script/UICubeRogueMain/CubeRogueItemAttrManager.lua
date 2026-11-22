local Manager = {}
local this = Manager
Enum_RogueItemOrderType = {
  StepDistanceItem = "StepDistanceItem",
  SpinNumItem = "SpinNumItem",
  StepNumItem = "StepNumItem",
  ActionItem = "ActionItem",
  GetBuffNum = "GetBuffNum",
  GetCoinPercentItem = "GetCoinPercentItem",
  DecMonsterStepNum = "DecMonsterStepNum",
  DecMonsterSpinNum = "DecMonsterSpinNum"
}
Enum_RogueItemOnceBattleOrderType = {Skill = "Skill"}
Enum_RogueEventOrderType = {
  Action = "Action",
  StepNum = "StepNum",
  SpinNum = "SpinNum",
  StepDistance = "StepDistance"
}
Enum_RogueItemFunType = {
  Recover = "Recover",
  TpSpecial = "TpSpecial",
  TpBoss = "TpBoss"
}

function Manager.InitData()
  this.AttrDic = {}
  this.OnceBattleSkillDic = {}
  for orderId, v in pairs(PlayerData.TempCache.CubeRogueData.attribute) do
    local orderCA = PlayerData:GetFactoryData(orderId, "RogueOrderFactory")
    if Enum_RogueItemOrderType[orderCA.orderType] or Enum_RogueEventOrderType[orderCA.orderType] then
      if v.num then
        this.AttrDic[orderCA.orderType] = {
          orderId = orderId,
          num = v.num
        }
      end
    elseif Enum_RogueItemOnceBattleOrderType[orderCA.orderType] and v.num then
      local skillId = orderCA.skillId
      this.OnceBattleSkillDic[skillId] = {
        orderId = orderId,
        num = v.num
      }
    end
  end
end

function Manager.CheckHasSameEffect(orderId)
  local orderCA = PlayerData:GetFactoryData(orderId, "RogueOrderFactory")
  if this.AttrDic[orderCA.orderType] or this.OnceBattleSkillDic[orderCA.skillId] then
    return true
  end
  return false
end

function Manager.AddBuff(orderId, serverValue)
  local orderCA = PlayerData:GetFactoryData(orderId, "RogueOrderFactory")
  local orderType = orderCA.orderType
  if Enum_RogueItemOrderType[orderType] or Enum_RogueEventOrderType[orderCA.orderType] then
    if this.AttrDic[orderType] then
      if serverValue then
        local value = this.AttrDic[orderType].serverValue or 0
        this.AttrDic[orderType].serverValue = value + serverValue
      end
      this.AttrDic[orderType].num = this.AttrDic[orderType].num + 1
    else
      this.AttrDic[orderType] = {orderId = orderId, num = 1}
      if serverValue then
        this.AttrDic[orderType].serverValue = serverValue
      end
    end
  elseif Enum_RogueItemOnceBattleOrderType[orderType] then
    local skillId = orderCA.skillId
    if this.OnceBattleSkillDic[skillId] then
      if serverValue then
        local value = this.OnceBattleSkillDic[skillId].serverValue or 0
        this.OnceBattleSkillDic[skillId].serverValue = value + serverValue
      end
      this.OnceBattleSkillDic[skillId].num = this.OnceBattleSkillDic[skillId].num + 1
    else
      this.OnceBattleSkillDic[skillId] = {orderId = orderId, num = 1}
      if serverValue then
        this.OnceBattleSkillDic[skillId].serverValue = serverValue
      end
    end
  end
end

function Manager.GetAttr(orderType)
  if this.AttrDic[orderType] then
    if this.AttrDic[orderType].serverValue then
      return this.AttrDic[orderType].serverValue
    else
      local orderId = this.AttrDic[orderType].orderId
      local orderCA = PlayerData:GetFactoryData(orderId, "RogueOrderFactory")
      return orderCA.param * this.AttrDic[orderType].num
    end
  end
  return 0
end

function Manager.GetBattleSkill()
  local skill = {}
  for skillId, v in pairs(this.OnceBattleSkillDic) do
    if v.serverValue then
      skill[skillId] = v.serverValue
    else
      local orderId = v.orderId
      local orderCA = PlayerData:GetFactoryData(orderId, "RogueOrderFactory")
      skill[skillId] = orderCA.param * v.num
    end
  end
  return skill
end

function Manager.EffectRemoveAttr(orderType)
  if this.AttrDic[orderType] then
    this.AttrDic[orderType] = nil
  end
end

function Manager.AddEventAttr(orderId, serverValue)
  local orderCA = PlayerData:GetFactoryData(orderId, "RogueOrderFactory")
  local orderType = orderCA.orderType
  if Enum_RogueEventOrderType[orderType] then
    this.AddBuff(orderId, serverValue)
  end
end

function Manager.GetItem(itemId)
  table.insert(PlayerData.TempCache.CubeRogueData.inside_item, itemId)
end

function Manager.RemoveItem(index)
  table.remove(PlayerData.TempCache.CubeRogueData.inside_item, index)
end

function Manager.OnRoundEnd()
  this.EffectRemoveAttr(Enum_RogueItemOrderType.StepDistanceItem)
  this.EffectRemoveAttr(Enum_RogueItemOrderType.SpinNumItem)
  this.EffectRemoveAttr(Enum_RogueItemOrderType.StepNumItem)
  this.EffectRemoveAttr(Enum_RogueEventOrderType.StepNum)
  this.EffectRemoveAttr(Enum_RogueEventOrderType.SpinNum)
  this.EffectRemoveAttr(Enum_RogueItemOrderType.DecMonsterSpinNum)
  this.EffectRemoveAttr(Enum_RogueItemOrderType.DecMonsterStepNum)
end

function Manager.OnFaceEnd()
  this.EffectRemoveAttr(Enum_RogueItemOrderType.ActionItem)
  this.EffectRemoveAttr(Enum_RogueEventOrderType.Action)
end

function Manager.OnBattleEnd()
  this.OnceBattleSkillDic = {}
end

function Manager.Clear()
  this.AttrDic = {}
  this.OnceBattleSkillDic = {}
end

return Manager
