local DataModel = {}

function DataModel.init(data)
  PlayerData.volleyBallData = {
    team0 = {},
    team1 = {},
    first = 0,
    gameMode = data.gameMode,
    uFid = "",
    currentSceneName = data.currentName,
    playGroupBackParams = data.playGroupBackParams
  }
  PlayerData.volleyBallData.first = math.random(0, 1)
  local roleList = PlayerData:GetFactoryData(99900067).characterList
  DataModel.roleList = {}
  local removeId = PlayerData:GetUserInfo().gender == 1 and 72200002 or 72200001
  for i, v in ipairs(roleList) do
    if v.id ~= removeId then
      table.insert(DataModel.roleList, v)
    end
  end
  DataModel.nowSelectIdx = 1
  DataModel.status = 0
  DataModel.pTs = 10
  DataModel.aiTs = 10
  DataModel.startGameTs = 1
  DataModel.remainTime = DataModel.pTs
  DataModel.selectRoleList = {}
end

function DataModel.RoleIsSelect(roleId)
  local isPlayer = false
  for i, v in ipairs(DataModel.selectRoleList) do
    if v == roleId then
      isPlayer = i <= 2
      return true, isPlayer
    end
  end
  return false
end

function DataModel.FindNextSelectId(isRandom)
  DataModel.nowSelectIdx = 1
  local roleCnt = #DataModel.roleList
  if isRandom then
    DataModel.nowSelectIdx = math.random(1, roleCnt)
  end
  local roleId = DataModel.roleList[DataModel.nowSelectIdx].id
  if not DataModel.RoleIsSelect(roleId) then
    return
  end
  for i = DataModel.nowSelectIdx, roleCnt do
    local roleId = DataModel.roleList[i].id
    if not DataModel.RoleIsSelect(roleId) then
      DataModel.nowSelectIdx = i
      return
    end
  end
  for i = 1, DataModel.nowSelectIdx do
    local roleId = DataModel.roleList[i].id
    if not DataModel.RoleIsSelect(roleId) then
      DataModel.nowSelectIdx = i
      return
    end
  end
end

function DataModel.UpdateSelectRoleInfo(roleId)
  table.insert(DataModel.selectRoleList, roleId)
  if DataModel.status == 0 then
    table.insert(PlayerData.volleyBallData.team0, roleId)
    DataModel.remainTime = DataModel.pTs
    if #PlayerData.volleyBallData.team0 >= 2 then
      DataModel.status = 1
      DataModel.remainTime = DataModel.aiTs
      return
    end
  end
  if DataModel.status == 1 then
    table.insert(PlayerData.volleyBallData.team1, roleId)
    DataModel.remainTime = DataModel.aiTs
    if 2 <= #PlayerData.volleyBallData.team1 then
      DataModel.status = 2
      DataModel.remainTime = DataModel.startGameTs
    end
  end
end

function DataModel.PlaySound(soundId)
  local sound = SoundManager:CreateSound(soundId)
  if sound ~= nil then
    sound:Play()
  end
end

return DataModel
