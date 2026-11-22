local Engine = require("UIMiniGameBS/MiniGameBSEngine")
local DataModel = {}

function DataModel.Init(params)
  DataModel.params = {
    activityId = params.activityId,
    bossId = params.bossId
  }
  DataModel.state = Engine.New(params.snapshot)
  DataModel.rankOpen = false
  DataModel.held = {}
  DataModel.myHitCount, DataModel.totalHitCount = nil, nil
  DataModel.rankData = nil
end

function DataModel.ApplyRank(json)
  DataModel.rankData = json
  if json.my_rank then
    DataModel.myHitCount = math.max(DataModel.myHitCount or 0, tonumber(json.my_rank.val) or 0)
  end
  if json.total_hit_count ~= nil then
    DataModel.totalHitCount = math.max(DataModel.totalHitCount or 0, tonumber(json.total_hit_count) or 0)
  end
end

function DataModel.Serialize()
  if not DataModel.state then
    return nil
  end
  return Json.encode({
    activityId = DataModel.params.activityId,
    bossId = DataModel.params.bossId,
    snapshot = Engine.Snapshot(DataModel.state)
  })
end

return DataModel
