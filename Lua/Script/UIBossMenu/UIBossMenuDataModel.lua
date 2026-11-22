local DataModel = {
  levelId = nil,
  monopolyId = nil,
  bossSerInfo = {},
  askFriendList = {},
  askBossTime = 0,
  helpBossTime = 0,
  hadAskedList = {},
  helpFriendList = {},
  myBossKillRewIsRec = false
}

function DataModel.SetBossLevelId(levelId, monopolyId)
  DataModel.levelId = levelId
  DataModel.monopolyId = monopolyId
end

function DataModel.SetBossSerInfo(bossHp, bossTime)
  DataModel.bossSerInfo.bossHp = bossHp
  DataModel.bossSerInfo.bossTime = bossTime
end

function DataModel.GetBossSerInfo()
  return DataModel.bossSerInfo
end

function DataModel.GetBossLevelId()
  return DataModel.levelId
end

function DataModel.GetBossUnitConfig()
  local levelConfig = PlayerData:GetFactoryData(DataModel.levelId, "LevelFactory")
  if not levelConfig then
    return nil
  end
  return PlayerData:GetFactoryData(levelConfig.bossId, "unitFactory")
end

function DataModel.GetBossMaxHp()
  local mp = PlayerData:GetFactoryData(DataModel.monopolyId, "MonopolyGameMapFactory") or {}
  return mp.bossHP or 0
end

function DataModel.GetBossKillRewardList()
  local mp = PlayerData:GetFactoryData(DataModel.monopolyId, "MonopolyGameMapFactory") or {}
  return mp.bossRewardList
end

function DataModel.GetBossIcon()
  return "UI/Monopoly/UI/Boss/Img/Help/Boss"
end

function DataModel.GetAskHelpLimit()
  local mp = PlayerData:GetFactoryData(DataModel.monopolyId, "MonopolyGameMapFactory") or {}
  return mp.askHelpLimit or 0
end

function DataModel.GetHelpFightLimit()
  local mp = PlayerData:GetFactoryData(DataModel.monopolyId, "MonopolyGameMapFactory") or {}
  return mp.helpFightLimit or 0
end

function DataModel.GetFightRewardList()
  local levelConfig = PlayerData:GetFactoryData(DataModel.levelId, "LevelFactory")
  if not levelConfig then
    return nil
  end
  if not levelConfig.stageList or table.count(levelConfig.stageList) == 0 then
    return nil
  end
  local listId = levelConfig.stageList[#levelConfig.stageList].id
  local listCfg = PlayerData:GetFactoryData(listId, "ListFactory") or {}
  return listCfg.leveldropList
end

function DataModel.LevelDesc()
  local levelConfig = PlayerData:GetFactoryData(DataModel.levelId, "LevelFactory")
  if not levelConfig then
    return ""
  end
  return levelConfig.description or ""
end

function DataModel.SetAskFriendList(friendList)
  DataModel.askFriendList = {}
  if friendList then
    local notCanList = {}
    local canList = {}
    for uid, v in pairs(friendList) do
      v.uid = uid
      local t = v
      local canAsk, desc = DataModel.GetAskFriendHelpState(v)
      if canAsk then
        table.insert(canList, t)
      else
        table.insert(notCanList, t)
      end
    end
    for i = 1, #canList do
      table.insert(DataModel.askFriendList, canList[i])
    end
    for i = 1, #notCanList do
      table.insert(DataModel.askFriendList, notCanList[i])
    end
  end
end

function DataModel.GetAskFriendList()
  return DataModel.askFriendList or {}
end

function DataModel.SetAskBossTime(time)
  time = time or 0
  if time < 0 then
    time = 0
  end
  DataModel.askBossTime = time
end

function DataModel.GetAskBossTime()
  return DataModel.askBossTime or 0
end

function DataModel.SetHelpBossTime(time)
  time = time or 0
  if time < 0 then
    time = 0
  end
  DataModel.helpBossTime = time
end

function DataModel.GetHelpBossTime()
  return DataModel.helpBossTime or 0
end

function DataModel.GetHelpBossLimitTime()
  local mp = PlayerData:GetFactoryData(DataModel.monopolyId, "MonopolyGameMapFactory") or {}
  return mp.bossHelpLimit or 0
end

function DataModel.SetHadAskedList(hadAskedList)
  DataModel.hadAskedList = hadAskedList
end

function DataModel.SetHadAskedByUid(uid)
  DataModel.hadAskedList = DataModel.hadAskedList or {}
  table.insert(DataModel.hadAskedList, tostring(uid))
end

function DataModel.GetIsHadAsked(uid)
  if not DataModel.hadAskedList then
    return false
  end
  for i = 1, #DataModel.hadAskedList do
    if DataModel.hadAskedList[i] == tostring(uid) then
      return true
    end
  end
  return false
end

function DataModel.GetAskFriendHelpState(friendInfo)
  if not friendInfo then
    return false, ""
  end
  local canAsk = true
  local desc = ""
  if DataModel.GetIsHadAsked(friendInfo.uid) then
    canAsk = false
    desc = GetText(80609760)
  elseif friendInfo.is_sign == 0 then
    canAsk = false
    desc = GetText(80609761)
  end
  return canAsk, desc
end

function DataModel.SetHelpFriendList(helpFriendList)
  DataModel.helpFriendList = {}
  if helpFriendList then
    for uid, v in pairs(helpFriendList) do
      local t = v
      v.uid = uid
      table.insert(DataModel.helpFriendList, t)
    end
  end
end

function DataModel.GetHelpFriendList()
  return DataModel.helpFriendList or {}
end

return DataModel
