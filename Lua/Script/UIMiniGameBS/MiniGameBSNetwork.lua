local Network = {}

function Network.GetRank(bossId)
  if not bossId then
    return
  end
  local boss = PlayerData:GetFactoryData(bossId, "LevelGroupFactory")
  local rankId = boss and tonumber(boss.miniGameRankId) or 0
  if not rankId or rankId <= 0 then
    return
  end
  local cfg = PlayerData:GetFactoryData(rankId, "RankFactory")
  if not cfg or cfg.rankType ~= "miniGameBSCount" or cfg.timeType ~= "forever" or cfg.gradeSectionList and 0 < #cfg.gradeSectionList then
    return
  end
  return rankId, cfg
end

function Network.QueryRank(cfg, cache, callback)
  Net:SendProto("main.roll_rank", callback, cfg.rankType, cfg.timeType, "", cfg.peopleNum, cache and cache.request_id or nil, cache and cache.next_index or nil)
end

return Network
