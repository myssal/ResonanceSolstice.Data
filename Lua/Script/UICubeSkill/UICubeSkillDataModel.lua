local DataModel = {
  cubeId = 89400002,
  lockState = {
    Unlocked = 1,
    UnlockAble = 2,
    Lock_NotEnoughCoin = 3,
    Lock_Ongoing = 4,
    Lock_PreSkillLocked = 5
  },
  indexPositionX = {
    [1] = 0,
    [2] = -911,
    [3] = -1822,
    [4] = -2853,
    [5] = -3860
  }
}

function DataModel.GetSkillList()
  local cubeConfig = PlayerData:GetFactoryData(DataModel.cubeId, "CubeRogueFactory")
  if not cubeConfig then
    return {}
  end
  return cubeConfig.skillList or {}
end

function DataModel.GetSkillLockState(skillInfo)
  if not skillInfo or not PlayerData.TempCache.CubeRogueData then
    return DataModel.lockState.Lock_PreSkillLocked
  end
  local rogueBuffInfo = PlayerData:GetFactoryData(skillInfo.id, "RogueBuffFactory")
  if not rogueBuffInfo then
    return DataModel.lockState.Lock_PreSkillLocked
  end
  local outside_buffs = PlayerData.TempCache.CubeRogueData.outside_buffs or {}
  local buffInfo = outside_buffs[tostring(skillInfo.id)]
  if buffInfo then
    return DataModel.lockState.Unlocked
  end
  local preSkills = rogueBuffInfo.preSkillList or {}
  local isPreSkillUnlock = true
  if 0 < #preSkills then
    for i = 1, #preSkills do
      local bInfo = outside_buffs[tostring(preSkills[i].id)]
      if not bInfo then
        isPreSkillUnlock = false
        break
      end
    end
  end
  if not isPreSkillUnlock then
    return DataModel.lockState.Lock_PreSkillLocked
  end
  local isGoing = DataModel.GetCubeIsGoing()
  if isGoing then
    return DataModel.lockState.Lock_Ongoing
  end
  local hasCount = DataModel.GetUseItemHasCount() or 0
  local requiredNum = skillInfo.requiredNum or 0
  if hasCount < requiredNum then
    return DataModel.lockState.Lock_NotEnoughCoin
  end
  return DataModel.lockState.UnlockAble
end

function DataModel.GetCubeIsGoing()
  if not PlayerData.TempCache or not PlayerData.TempCache.CubeRogueData then
    return false
  end
  if string.nilorempty(PlayerData.TempCache.CubeRogueData.cube_id) then
    return false
  end
  return true
end

function DataModel.MaxRoundNumAdd()
  local skills = {89500145, 89500161}
  local result = 0
  for i = 1, #skills do
    if DataModel.GetSkillLockState({
      id = skills[i]
    }) == DataModel.lockState.Unlocked then
      local buff = PlayerData:GetFactoryData(skills[i], "RogueBuffFactory")
      local order = PlayerData:GetFactoryData(buff.skillEffect, "RogueOrderFactory")
      result = result + order.param
    end
  end
  return result
end

function DataModel.IsRefreshBuffSelectUnlock()
  local result
  local skills = {89500144}
  for k, v in pairs(skills) do
    local isUnlock = DataModel.GetSkillLockState({id = v}) == DataModel.lockState.Unlocked
    if isUnlock then
      local rogueBuffInfo = PlayerData:GetFactoryData(v, "RogueBuffFactory")
      local orderCfg = PlayerData:GetFactoryData(rogueBuffInfo.skillEffect)
      result = result or 0
      result = result + orderCfg.param
    end
  end
  return result
end

function DataModel.ItemSlotNum()
  local skills = {89500021}
  local result = 0
  for i = 1, #skills do
    if DataModel.GetSkillLockState({
      id = skills[i]
    }) == DataModel.lockState.Unlocked then
      local buff = PlayerData:GetFactoryData(skills[i], "RogueBuffFactory")
      local order = PlayerData:GetFactoryData(buff.skillEffect, "RogueOrderFactory")
      result = result + order.param
    end
  end
  return result
end

function DataModel.GetUseItemConfigInfo()
  local cubeConfig = PlayerData:GetFactoryData(DataModel.cubeId, "CubeRogueFactory")
  if not cubeConfig then
    return nil
  end
  return PlayerData:GetFactoryData(cubeConfig.skillItem, "ItemFactory")
end

function DataModel.GetUseItemHasCount()
  local itemInfo = DataModel.GetUseItemConfigInfo()
  if not itemInfo then
    return 0
  end
  return PlayerData:GetGoodsById(itemInfo.id).num or 0
end

function DataModel.SetSkillIsUnlock(skillId)
  if string.nilorempty(skillId) then
    return
  end
  if not PlayerData.TempCache then
    return
  end
  PlayerData.TempCache.CubeRogueData = PlayerData.TempCache.CubeRogueData or {}
  PlayerData.TempCache.CubeRogueData.outside_buffs = PlayerData.TempCache.CubeRogueData.outside_buffs or {}
  PlayerData.TempCache.CubeRogueData.outside_buffs[tostring(skillId)] = 1
end

function DataModel.GetFirstOpenIndex()
  local index = 1
  if PlayerData.TempCache and PlayerData.TempCache.CubeRogueData and PlayerData.TempCache.CubeRogueData.outside_buffs and table.count(PlayerData.TempCache.CubeRogueData.outside_buffs) > 0 then
    for id, _ in pairs(PlayerData.TempCache.CubeRogueData.outside_buffs) do
      local tempIndex = DataModel.GetIndexById(id) or 1
      if index < tempIndex then
        index = tempIndex
      end
    end
  end
  return index
end

function DataModel.GetIndexById(id)
  local index = 1
  local cubeConfig = PlayerData:GetFactoryData(DataModel.cubeId, "CubeRogueFactory")
  if cubeConfig and cubeConfig.skillList then
    for i = 1, #cubeConfig.skillList do
      if tostring(id) == tostring(cubeConfig.skillList[i].id) then
        index = i
        break
      end
    end
  end
  return index
end

function DataModel.GetScrollContentPosByIndex(index)
  if index <= 6 then
    return DataModel.indexPositionX[1]
  end
  if index <= 11 then
    return DataModel.indexPositionX[2]
  end
  if index <= 16 then
    return DataModel.indexPositionX[3]
  end
  if index <= 24 then
    return DataModel.indexPositionX[4]
  end
  return DataModel.indexPositionX[5]
end

function DataModel.GetRedDotStatus()
  local skillList = DataModel.GetSkillList()
  if not skillList then
    return false
  end
  for i = 1, #skillList do
    local state = DataModel.GetSkillLockState(skillList[i])
    if state == DataModel.lockState.UnlockAble then
      return true
    end
  end
  return false
end

return DataModel
