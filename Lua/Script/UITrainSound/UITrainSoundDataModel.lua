local DataModel = {}

function DataModel.InitData()
  DataModel.AllList = {}
  DataModel.AllDic = {}
  local bookCfg = GetCA(80900018)
  if bookCfg == nil then
    return
  end
  for k, v in pairs(bookCfg.trainSoundList) do
    local soundCfg = GetCA(v.id)
    local tempData = {
      Cfg = soundCfg,
      Index = k,
      Unlock = 0
    }
    table.insert(DataModel.AllList, tempData)
    DataModel.AllDic[v.id] = tempData
  end
  if PlayerData:GetHomeInfo().sound_list then
    for k, v in pairs(PlayerData:GetHomeInfo().sound_list) do
      local tempID = tonumber(v) or 0
      DataModel.UnlockTrainSound(tempID)
    end
  end
  local curUsing = tonumber(PlayerData:GetHomeInfo().train_sound) or 88100001
  table.sort(DataModel.AllList, function(a, b)
    if a.Cfg.id == curUsing then
      return true
    elseif b.Cfg.id == curUsing then
      return false
    elseif a.Unlock > b.Unlock then
      return true
    elseif a.Unlock < b.Unlock then
      return false
    else
      return a.Index < b.Index
    end
  end)
end

function DataModel.SaveToLocal(id)
  if PlayerData:GetHomeInfo().sound_list then
    table.insert(PlayerData:GetHomeInfo().sound_list, tostring(id))
  end
end

function DataModel.UnlockTrainSound(id)
  if DataModel.AllDic and DataModel.AllDic[id] then
    DataModel.AllDic[id].Unlock = 1
  end
end

function DataModel.GetTrainSoundData(id)
  if DataModel.AllDic and DataModel.AllDic[id] then
    return DataModel.AllDic[id]
  end
  return nil
end

return DataModel
