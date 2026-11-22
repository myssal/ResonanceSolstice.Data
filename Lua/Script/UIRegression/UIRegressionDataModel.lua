local DataModel = {
  CurMenuTab = -1,
  MenuElementData = {},
  SignInElementData = {},
  SignedDay = 0,
  SignInRewardElementData = {},
  TaskRewardElementData = {},
  TaskElementData = {},
  TaskProcessElementData = {},
  BuffElementData = {},
  NewsElementData = {},
  CurNewsIdx = 1,
  WelcomeElementData = {},
  StampCount = 0,
  ConfigId = "86000017",
  Config = {}
}
DataModel.SignState = {
  NotInTime = 1,
  CanSign = 2,
  Signed = 3
}
DataModel.TaskState = {
  Rewarded = 1,
  Going = 2,
  CanReward = 3
}
DataModel.BuffState = {
  NoActive = 1,
  Active = 2,
  Empty = 3
}
DataModel.BuffSpineName = {
  fight = "ZD",
  trade = "YJ",
  train = "SY"
}

function DataModel.TaskSort(a, b)
  if a.status == b.status then
    return a.index < b.index
  end
  return a.status > b.status
end

function DataModel.InitData()
  DataModel.CurNewsIdx = 1
  DataModel.Config = PlayerData:GetFactoryData(DataModel.ConfigId)
  DataModel.InitMenuData()
  DataModel.InitSignInData()
  DataModel.InitTaskData()
  DataModel.InitTaskProcessData()
  DataModel.InitBuffData()
  DataModel.InitNewsData()
  DataModel.InitWelcomeData()
end

function DataModel.InitMenuData()
  DataModel.MenuElementData = {
    [1] = {
      name = GetText(80607656),
      panel = "Group_SignIn",
      clickFunc = "ClickSignIn"
    },
    [2] = {
      name = GetText(80607657),
      panel = "Group_Task",
      clickFunc = "ClickTask"
    },
    [3] = {
      name = GetText(80607658),
      panel = "Group_Buff",
      clickFunc = "ClickBuff"
    },
    [4] = {
      name = GetText(80607659),
      panel = "Group_News",
      clickFunc = "ClickNews"
    }
  }
end

function DataModel.InitSignInData()
  DataModel.SignInElementData = {}
  local signInCfg = PlayerData:GetFactoryData(40100010).SigninRewardList
  local serverSignData = PlayerData.ServerData.user_info.sign_info["40100010"]
  DataModel.SignedDay = 0
  for i, v in ipairs(signInCfg) do
    local rewardCfg = PlayerData:GetFactoryData(v.id)
    local rewardList = rewardCfg.awardList
    local row = {
      reward = rewardList,
      signState = DataModel.SignState.NotInTime
    }
    if serverSignData then
      if i <= serverSignData.count then
        row.signState = DataModel.SignState.Signed
      elseif i >= serverSignData.count and i <= serverSignData.count + serverSignData.need then
        row.signState = DataModel.SignState.CanSign
      else
        row.signState = DataModel.SignState.NotInTime
      end
      DataModel.SignedDay = serverSignData.count
    end
    table.insert(DataModel.SignInElementData, row)
  end
end

function DataModel.InitTaskData()
  DataModel.TaskElementData = {}
  local taskList = PlayerData:GetFactoryData(DataModel.ConfigId).returnTask
  local serverActivityQuestData = PlayerData.ServerData.quests.activity_quests
  for i, v in ipairs(taskList) do
    local row = {
      status = DataModel.TaskState.Going,
      id = v.id,
      curNum = 0
    }
    local data = serverActivityQuestData[tostring(v.id)]
    if data then
      local questCfg = PlayerData:GetFactoryData(v.id)
      row.curNum = data.pcnt
      if 0 < data.recv then
        row.status = DataModel.TaskState.Rewarded
      elseif data.recv == 0 and data.pcnt >= questCfg.num then
        row.status = DataModel.TaskState.CanReward
      else
        row.status = DataModel.TaskState.Going
      end
    end
    table.insert(DataModel.TaskElementData, row)
  end
  table.sort(DataModel.TaskElementData, function(a, b)
    if a.status == b.status then
      return tonumber(a.id) < tonumber(b.id)
    end
    return a.status > b.status
  end)
end

function DataModel.InitTaskProcessData()
  DataModel.TaskProcessElementData = {}
  local processList = DataModel.Config.returnTaskRewards
  local serverProcessReward = PlayerData.ServerData.return_info.tasks_reward
  for i, v in ipairs(processList) do
    local row = {
      rewardsId = v.rewards,
      num = v.num,
      recv = serverProcessReward[i] ~= nil
    }
    table.insert(DataModel.TaskProcessElementData, row)
  end
end

function DataModel.InitBuffData()
  DataModel.BuffElementData = {}
  local buffList = PlayerData:GetFactoryData(DataModel.ConfigId).returnBuffList
  local serverBuffData = PlayerData.ServerData.return_info.ret_buff
  for i, v in ipairs(buffList) do
    local row = {
      id = v.id,
      state = DataModel.BuffState.NoActive,
      remainCount = 0
    }
    local cfg = PlayerData:GetFactoryData(row.id)
    if serverBuffData[cfg.buffType] and serverBuffData[cfg.buffType][tostring(row.id)] then
      local data = serverBuffData[cfg.buffType][tostring(row.id)]
      row.remainCount = data.param
      if data.param == 0 then
        row.state = DataModel.BuffState.Empty
      elseif data.act == 1 and 0 < data.param then
        row.state = DataModel.BuffState.Active
      elseif data.act == 0 then
        if data.param == 0 then
          row.state = DataModel.BuffState.Empty
        else
          row.state = DataModel.BuffState.NoActive
        end
      end
    end
    table.insert(DataModel.BuffElementData, row)
  end
end

function DataModel.InitNewsData()
  DataModel.NewsElementData = {}
  local newsList = DataModel.Config.returnNewsList
  for i, v in ipairs(newsList) do
    local row = {data = v}
    table.insert(DataModel.NewsElementData, row)
  end
end

function DataModel.InitWelcomeData()
end

function DataModel.GetReturnRemainTime()
  local startTime = PlayerData.ServerData.return_info.ret_ts
  local remainTime = DataModel.Config.continueTime * 24 * 60 * 60 - (TimeUtil:GetServerTimeStamp() - startTime)
  return remainTime
end

function DataModel.GetReturnRedPoint()
  if not DataModel.CheckHasReturn() then
    return false
  end
  if DataModel.GetSignInRedPoint() then
    return true
  end
  if DataModel.GetTaskRedPoint() then
    return true
  end
  if DataModel.GetBuffRedPoint() then
    return true
  end
  return false
end

function DataModel.GetSignInRedPoint()
  local serverSignData = PlayerData.ServerData.user_info.sign_info["40100010"]
  return serverSignData and serverSignData.need > 0
end

function DataModel.GetTaskRedPoint()
  local taskList = PlayerData:GetFactoryData(DataModel.ConfigId).returnTask
  local serverActivityQuestData = PlayerData.ServerData.quests.activity_quests
  for i, v in ipairs(taskList) do
    local row = {
      status = DataModel.TaskState.Going,
      id = v.id,
      curNum = 0
    }
    local data = serverActivityQuestData[tostring(v.id)]
    if data then
      local questCfg = PlayerData:GetFactoryData(v.id)
      row.curNum = data.pcnt
      if data and data.recv == 0 and data.pcnt >= questCfg.num then
        return true
      end
    end
  end
  local serverProcessReward = PlayerData.ServerData.return_info.tasks_reward
  local returnScore = PlayerData:GetGoodsById(11400213).num
  for i = 1, 5 do
    if returnScore >= i * 20 and serverProcessReward[i] == nil then
      return true
    end
  end
  return false
end

function DataModel.GetBuffRedPoint()
  local serverBuffData = PlayerData.ServerData.return_info.ret_buff
  for _, v in pairs(serverBuffData) do
    for _, buff in pairs(v) do
      if buff.act == 0 then
        return true
      end
    end
  end
  return false
end

function DataModel.CheckHasReturn()
  if not PlayerData.ServerData.return_info then
    return false
  end
  if PlayerData.ServerData.return_info.ret_ts == 0 then
    return false
  end
  local delayDay = PlayerData:GetFactoryData(86000017).continueTime
  if PlayerData.ServerData.return_info.ret_reward and PlayerData.ServerData.return_info.ret_ts + delayDay * 24 * 60 * 60 <= TimeUtil:GetServerTimeStamp() then
    return false
  end
  return true
end

return DataModel
