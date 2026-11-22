local DataModel = {
  Data = nil,
  EngineCoreCount = 5,
  EngineCoreType = {
    Electric = 1,
    Ice = 2,
    Reverberation = 3,
    Negative = 4,
    Fire = 5
  },
  EngineCoreTypeToCAId = {
    [1] = 85300004,
    [2] = 85300005,
    [3] = 85300006,
    [4] = 85300002,
    [5] = 85300001
  },
  EngineCoreTypeToLeftElementName = {
    [1] = "Group_Electric",
    [2] = "Group_Ice",
    [3] = "Group_Reverberation",
    [4] = "Group_Negative",
    [5] = "Group_Fire"
  },
  rotateSpeedRatio = 0.3,
  comebackSpeed = 5,
  startY = 0,
  endY = -100,
  GearDefaultAngleZ = 0,
  CoreDefaultAngleZ = 72,
  PerAngle = 72.0,
  Dragging = false,
  ComeBack = false,
  DeltaCachePos = nil,
  CachePos = nil,
  NowElement = nil,
  NextElement = nil,
  CurCoreAngleZ = 0,
  CurGearAngleZ = 0,
  NowHeight = 0,
  NextHeight = 0,
  CacheRotateAngle = 0,
  BeginDragAngle = 0,
  CurEngineCoreType = 0,
  NextEngineCoreType = 0,
  DragScreenCenterPos = nil,
  EngineCoreInfo = {},
  BreakEffectPath = "UI/EngineCore/Group_BreakEffect",
  BreakEffectObj = nil,
  coreSelectSoundId = 0,
  coreSelectSoundInstance = nil,
  coreRotateSoundId = 0,
  coreRotateSoundInstance = nil
}

function DataModel.Init()
  DataModel.EngineCoreInfo = {}
  for i, caId in ipairs(DataModel.EngineCoreTypeToCAId) do
    local t = DataModel.InitDataByCaId(caId)
    DataModel.EngineCoreInfo[i] = t
  end
  local uiSoundConfig = PlayerData:GetFactoryData(99900002, "ConfigFactory")
  DataModel.coreSelectSoundId = uiSoundConfig.coreSelect
  DataModel.coreRotateSoundId = uiSoundConfig.coreRotate
end

function DataModel.InitDataByCaId(caId)
  local t = {}
  local ca = PlayerData:GetFactoryData(caId)
  local serverInfo = PlayerData.ServerData.engines[tostring(caId)]
  t.caId = caId
  t.redName = RedpointTree.NodeNames.Core .. "|" .. caId
  t.isUnlock = ca.electricLimit <= PlayerData:GetHomeInfo().electric_lv
  t.unlockLv = ca.electricLimit
  t.num = serverInfo.num
  t.lv = serverInfo.lv
  t.breakCnt = 0
  t.canBreak = false
  t.effectPath = ""
  local cnt = #ca.coreExpList
  if t.isUnlock then
    for k = 1, t.lv - 1 do
      local info = ca.coreExpList[k]
      if info.effects ~= "" then
        t.effectPath = info.effects
      end
      if info.isBreak then
        t.breakCnt = t.breakCnt + 1
      end
    end
    for k = t.lv, cnt do
      local info = ca.coreExpList[k]
      if info.isBreak then
        if t.breakLv == nil then
          t.breakLv = k
          t.breakId = info.id
        else
          t.nextBreakLv = k
          break
        end
      end
    end
    t.canBreak = t.lv == t.breakLv
    if t.breakLv == nil then
      t.breakLv = cnt
    end
    if t.nextBreakLv == nil then
      t.nextBreakLv = cnt
    end
    t.nextNum = 0
    if cnt >= t.lv + 1 then
      t.nextNum = ca.coreExpList[t.lv + 1].num
    end
    cnt = #ca.coreLevelList
    for k = 1, cnt do
      local info = ca.coreLevelList[k]
      if t.lv <= info.grade then
        t.battleId = info.id
        t.unitId = info.profileId
        break
      end
    end
    if 0 < t.unitId then
      local unitCA = PlayerData:GetFactoryData(t.unitId)
      t.conditionTxt = string.format(GetText(ca.challengeTips), unitCA.name, t.nextNum)
    end
    if t.effectPath == "" then
      t.effectPath = ca.coreExpList[1].effects
    end
  else
    t.breakLv = 0
  end
  return t
end

local function innerEndSelectSound()
  DataModel.coreSelectSoundInstance = nil
end

function DataModel.PlaySelectSound()
  if DataModel.coreSelectSoundInstance == nil and DataModel.coreSelectSoundId > 0 then
    DataModel.coreSelectSoundInstance = SoundManager:CreateSound(DataModel.coreSelectSoundId)
    if DataModel.coreSelectSoundInstance ~= nil then
      DataModel.coreSelectSoundInstance:SetEndCallBack(innerEndSelectSound)
      DataModel.coreSelectSoundInstance:Play()
    end
  end
end

function DataModel.StopSelectSound()
  if DataModel.coreSelectSoundInstance then
    DataModel.coreSelectSoundInstance:Stop()
    DataModel.coreSelectSoundInstance = nil
  end
end

local function innerEndRotateSound()
  DataModel.coreRotateSoundInstance = nil
end

function DataModel.PlayRotateSound()
  if DataModel.coreRotateSoundInstance ~= nil and DataModel.coreRotateSoundInstance.isPause then
    DataModel.coreRotateSoundInstance:Pause(false)
    return
  end
  if DataModel.coreRotateSoundInstance == nil and DataModel.coreRotateSoundId > 0 then
    DataModel.coreRotateSoundInstance = SoundManager:CreateSound(DataModel.coreRotateSoundId)
    if DataModel.coreRotateSoundInstance ~= nil then
      DataModel.coreRotateSoundInstance:SetEndCallBack(innerEndRotateSound)
      DataModel.coreRotateSoundInstance:SetIsLoop(true)
      DataModel.coreRotateSoundInstance:Play()
    end
  end
end

function DataModel.PauseRotateSound()
  if DataModel.coreRotateSoundInstance then
    DataModel.coreRotateSoundInstance:Pause(true)
  end
end

function DataModel.StopRotateSound()
  if DataModel.coreRotateSoundInstance then
    DataModel.coreRotateSoundInstance:Stop()
    DataModel.coreRotateSoundInstance = nil
  end
end

return DataModel
