local DataModel = {}
local TradeDataModel = require("UIHome/UIHomeTradeDataModel")

function DataModel.GetFormulaRedStateById(formulaId, furLv)
  local red = DataModel.HandleNewFormula(formulaId, furLv) > 0
  if red then
    return true
  end
  return false
end

function DataModel.GetFurFormulaRedState(furId)
  local furCA = PlayerData:GetFactoryData(furId, "HomeFurnitureFactory")
  for i, formulaCfg in pairs(furCA.formulaGroup) do
    local red = DataModel.HandleNewFormula(formulaCfg.id, furCA.Level) > 0
    if red then
      return true
    end
  end
  return false
end

function DataModel.HandleNewFormula(groupId, furLv)
  local cfg = PlayerData:GetFactoryData(groupId)
  local formulaList = cfg.condition
  local newCount = 0
  local newGet = PlayerData:GetPlayerPrefs("int", groupId) == 0
  if newGet == false then
    return 0
  end
  local isMake = false
  for k, v in pairs(formulaList) do
    local unLock = DataModel.FormulaIsUnLock(v.id, furLv)
    local newGet = PlayerData:GetPlayerPrefs("int", v.id) == 0
    local isEnough = DataModel.MaterialIsEnough(v.id)
    if isMake == false then
      isMake = isEnough and unLock
    end
    if newGet == false then
      PlayerData:SetPlayerPrefs("int", groupId, 1)
      return 1
    end
  end
  newCount = isMake and 1 or 0
  return newCount
end

function DataModel.Init(furniture)
  DataModel.furniture = furniture
  local fCfg = PlayerData:GetFactoryData(furniture.id)
  DataModel.furName = fCfg.name
  DataModel.furLevel = fCfg.Level
  local formulaGroup = fCfg.formulaGroup
  DataModel.formulaGroupList = {}
  for i, v in ipairs(formulaGroup) do
    local cfg = PlayerData:GetFactoryData(v.id)
    if cfg.unlock == -1 then
      local data = {
        id = v.id,
        newCount = 0,
        isOwn = true
      }
      data.newCount = DataModel.HandleNewFormula(v.id)
      table.insert(DataModel.formulaGroupList, data)
    else
      local ownList = PlayerData.ServerData.formula_items or {}
      local isOwn = false
      for k1, v1 in pairs(ownList) do
        if v1 == tostring(cfg.unlock) then
          local data = {
            id = v.id,
            newCount = 0,
            isOwn = true
          }
          data.newCount = DataModel.HandleNewFormula(v.id)
          table.insert(DataModel.formulaGroupList, data)
          isOwn = true
          break
        end
      end
      if isOwn == false then
        local data = {
          id = v.id,
          newCount = 0,
          isOwn = false
        }
        table.insert(DataModel.formulaGroupList, data)
      end
    end
  end
  table.sort(DataModel.formulaGroupList, function(t1, t2)
    if t1.newCount ~= t2.newCount then
      return t1.newCount > t2.newCount
    end
    if t1.isOwn ~= t2.isOwn then
      return t1.isOwn
    end
    return t1.id < t2.id
  end)
  DataModel.coreList = PlayerData:GetFactoryData(99900001).coreList
  DataModel.UpdateSelectGroupInfo(1)
  DataModel.nowPormulaId = -1
  DataModel.selectNum = 1
  DataModel.maxCompoundNum = 1
  DataModel.makeLv = PlayerData:GetHomeInfo().compound_lv
  DataModel.makeExp = PlayerData:GetHomeInfo().compound_exp
  local machiningExpList = PlayerData:GetFactoryData(99900173).MachiningExpList
  DataModel.extraRate = machiningExpList[DataModel.makeLv].AdditionalProbability + PlayerData:GetHomeSkillIncrease(EnumDefine.HomeSkillEnum.RiseWorkshopOutput)
  DataModel.jumpToExchangeElementIndex = nil
end

function DataModel.UpdateSelectGroupInfo(index)
  DataModel.selectGroupId = DataModel.formulaGroupList[index].id
  DataModel.selectGroupIdx = index
  local cfg = PlayerData:GetFactoryData(DataModel.formulaGroupList[index].id)
  DataModel.formulaList = cfg.condition
end

function DataModel.FormulaIsUnLock(formulaId, nowFurLv)
  local pormulaCfg = PlayerData:GetFactoryData(formulaId)
  local conditionList = pormulaCfg.unlockenergyCondition
  local engines = PlayerData.ServerData.engines
  local furLv = pormulaCfg.unlock
  local LvUnLock = true
  local coreUnlock = true
  local furLevel = nowFurLv and nowFurLv or DataModel.furLevel
  if furLv > furLevel then
    LvUnLock = false
  end
  for k, v in pairs(conditionList) do
    if v.num > engines[tostring(v.id)].lv then
      coreUnlock = false
    end
  end
  local UnLock = LvUnLock and coreUnlock
  return UnLock, LvUnLock, coreUnlock
end

function DataModel.MaterialIsEnough(id)
  local isMaterial = true
  local costList = PlayerData:GetFactoryData(id).drawForm
  for k, v in pairs(costList) do
    local ownNum = PlayerData:GetGoodsById(v.id).num
    ownNum = ownNum + DataModel.GetItemNumInPrisonMaterial(v.id)
    local needNum = v.num
    if ownNum < needNum then
      return false, isMaterial
    end
  end
  isMaterial = false
  local result = DataModel.CalExtraCost(id)
  if result.maxEnergyNum == 0 or result.maxGoldNum == 0 or result.maxMoveEnergyNum == 0 then
    return false, isMaterial
  end
  return true, isMaterial
end

function DataModel.CalExtraCost(nowPormulaId)
  local pormulaId = nowPormulaId or DataModel.nowPormulaId
  local pormulaCfg = PlayerData:GetFactoryData(pormulaId)
  local curMoveEnergy = PlayerData:GetUserInfo().move_energy
  local homeCommon = require("Common/HomeCommon")
  local result = {
    maxEnergyNum = -1,
    energyCost = -1,
    maxGoldNum = -1,
    goldCost = -1,
    maxMoveEnergyNum = -1,
    moveEnergyCost = -1
  }
  for i, v in ipairs(pormulaCfg.composeCondition) do
    if v.id == 11400039 then
      result.maxMoveEnergyNum = math.floor((homeCommon.GetMaxHomeEnergy() - curMoveEnergy) / v.num)
      result.maxMoveEnergyNum = result.maxMoveEnergyNum >= 0 and result.maxMoveEnergyNum or 0
      result.moveEnergyCost = v.num
    end
    if v.id == 11400001 then
      result.maxGoldNum = math.floor(PlayerData:GetUserInfo().gold / v.num)
      result.maxGoldNum = result.maxGoldNum >= 0 and result.maxGoldNum or 0
      result.goldCost = v.num
    end
    if v.id == 11400006 then
      result.maxEnergyNum = math.floor(PlayerData:GetUserInfo().energy / v.num)
      result.maxEnergyNum = result.maxEnergyNum >= 0 and result.maxEnergyNum or 0
      result.energyCost = v.num
    end
  end
  return result
end

function DataModel.CalMaxCompoundNum()
  local costList = DataModel.costList
  local maxCompoundNum = 1
  for i, v in ipairs(costList) do
    local ownNum = PlayerData:GetGoodsById(v.id).num
    ownNum = ownNum + DataModel.GetItemNumInPrisonMaterial(v.id)
    local needNum = v.num
    local CompoundNum = math.floor(ownNum / needNum)
    if i == 1 then
      maxCompoundNum = CompoundNum
    else
      maxCompoundNum = CompoundNum <= maxCompoundNum and CompoundNum or maxCompoundNum
    end
  end
  local result = DataModel.CalExtraCost()
  maxCompoundNum = result.maxMoveEnergyNum ~= -1 and maxCompoundNum > result.maxMoveEnergyNum and result.maxMoveEnergyNum or maxCompoundNum
  maxCompoundNum = result.maxGoldNum ~= -1 and maxCompoundNum > result.maxGoldNum and result.maxGoldNum or maxCompoundNum
  maxCompoundNum = result.maxEnergyNum ~= -1 and maxCompoundNum > result.maxEnergyNum and result.maxEnergyNum or maxCompoundNum
  DataModel.maxCompoundNum = maxCompoundNum
end

function DataModel.UpdateNowSelectNum(num, isSlider)
  if isSlider then
    DataModel.selectNum = math.modf(math.floor(num * DataModel.maxCompoundNum * 10000 + 0.5) / 10000)
    DataModel.selectNum = MathEx.Clamp(DataModel.selectNum, 1, DataModel.maxCompoundNum)
    return
  end
  DataModel.selectNum = MathEx.Clamp(num, 1, DataModel.maxCompoundNum)
end

function DataModel.UpdateNewFormula()
  local formulaGroup = DataModel.formulaGroupList[DataModel.selectGroupIdx]
  if formulaGroup.newCount > 0 then
    PlayerData:SetPlayerPrefs("int", formulaGroup.id, 1)
    DataModel.formulaGroupList[DataModel.selectGroupIdx].newCount = 0
  end
end

function DataModel.FormatNum(num)
  local num = math.floor(num * 10) / 10
  if num <= 0 then
    return 0
  else
    local t1, t2 = math.modf(num)
    if 0 < t2 then
      return num
    else
      return t1
    end
  end
end

function DataModel.UpadateMakeLV(formulaId, num)
  local machiningExpList = PlayerData:GetFactoryData(99900173).MachiningExpList
  if DataModel.makeLv == #machiningExpList then
    return
  end
  local machiningEXP = PlayerData:GetFactoryData(formulaId).machiningEXP
  local allAddExp = machiningEXP * num
  local count = #machiningExpList
  local nextLvExp = machiningExpList[DataModel.makeLv].LvUpExp - DataModel.makeExp
  for i = DataModel.makeLv, count do
    if 0 <= nextLvExp - allAddExp then
      DataModel.makeExp = DataModel.makeExp + allAddExp
      break
    end
    allAddExp = allAddExp - nextLvExp
    DataModel.makeLv = DataModel.makeLv + 1
    DataModel.makeExp = 0
    nextLvExp = machiningExpList[DataModel.makeLv].LvUpExp
    if DataModel.makeLv == count then
      break
    end
  end
  PlayerData:GetHomeInfo().compound_lv = DataModel.makeLv
  PlayerData:GetHomeInfo().compound_exp = DataModel.makeExp
  DataModel.extraRate = machiningExpList[DataModel.makeLv].AdditionalProbability + PlayerData:GetHomeSkillIncrease(EnumDefine.HomeSkillEnum.RiseWorkshopOutput)
end

function DataModel.GetNowIdx(productionId)
  local idx = -1
  for i, v in ipairs(DataModel.formulaGroupList) do
    if v.id == tonumber(productionId) then
      idx = i
      break
    end
  end
  return idx
end

function DataModel.GetItemNumInPrisonMaterial(id)
  local count = 0
  if not TradeDataModel.InTravel and TradeDataModel.EndCity == 83000017 and PlayerData.ServerData.user_prison_info then
    if PlayerData.ServerData.user_prison_info.raw_material[tostring(id)] then
      count = count + PlayerData.ServerData.user_prison_info.raw_material[tostring(id)].num
    end
    if PlayerData.ServerData.user_prison_info.product[tostring(id)] then
      count = count + PlayerData.ServerData.user_prison_info.product[tostring(id)].num
    end
  end
  return count
end

return DataModel
