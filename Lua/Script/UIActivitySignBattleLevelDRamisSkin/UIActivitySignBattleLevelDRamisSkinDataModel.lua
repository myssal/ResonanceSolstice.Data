local DataModel = {rewardState = 1, rewardState2 = 1}
DataModel.BtnEnm = {
  unFinish = 1,
  finish = 2,
  receive = 3
}

function DataModel:Init()
  DataModel.activityId = DataModel.initParams.activityId
  DataModel.activityCA = PlayerData:GetFactoryData(DataModel.activityId)
  DataModel.activityId2 = DataModel.activityCA.signChallengeActivityId
  DataModel.activityCA2 = PlayerData:GetFactoryData(DataModel.activityId2)
  DataModel.end_Ts = nil
end

function DataModel:GetRewardButtonIsActive(id)
  local activityCA = PlayerData:GetFactoryData(id)
  local cs_activity = DataModel.signBattleData
  local data = cs_activity[tostring(id)]
  if table.count(cs_activity) == 0 or data == nil or #data.pass_level_index ~= #activityCA.signLevelList then
    return DataModel.BtnEnm.unFinish
  end
  if #data.pass_level_index == #activityCA.signLevelList and data.reward == false then
    return DataModel.BtnEnm.finish
  end
  if data.reward == true then
    return DataModel.BtnEnm.receive
  end
end

function DataModel:SetSignBattleData(json)
  DataModel.signBattleData = json.cs_activity or {}
end

return DataModel
