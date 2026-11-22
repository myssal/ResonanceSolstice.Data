local RubikCube = require("UICubeRogueMain/RubikCube")
local RubikRole = require("UICubeRogueMain/CubeRogueRoleCtrl")
local OutSideData = require("UICubeSkill/UICubeSkillDataModel")
local DataModel = {
  Enum_CubeType = {
    Boss = 12601541,
    Reward = 12601617,
    Recover = 12601615,
    HardBattle = 12601542,
    NormalBattle = 12601540,
    Event = 12601616,
    Shop = 12601614,
    SpecialShop = 12601699
  },
  Enum_PlayerPos = {
    None = 1,
    Center = 2,
    Side = 3,
    Corner = 4
  },
  cfg = nil,
  rubikCube = nil,
  faceUpTime = 0,
  rotCube = {},
  isHorizon = false,
  isAuto = false,
  rotDir = nil,
  rotAxle = "x",
  rotTarget = 1,
  rotSpeed = 2,
  isRotating = false,
  isResetRoting = false,
  rotStartRotation = nil,
  rotTargetRotation = nil,
  rotDuration = 3,
  rotElapsed = 0,
  resetSpeed = 2,
  hasConfirmRot = true,
  outlineWidth = 50
}

function DataModel:InitRubik(rotClick, onlyUI)
  local netdata = PlayerData.TempCache.CubeRogueData
  DataModel.mapID = tonumber(netdata.cube_id)
  DataModel.cfg = PlayerData:GetFactoryData(DataModel.mapID, "CubeRogueFactory")
  local temp
  local _color = DataModel.cfg.currentColor
  if _color ~= "" then
    temp = string.split(_color, ",")
    if #temp == 3 then
      DataModel.CurrentColor = Color(tonumber(temp[1]) / 255, tonumber(temp[2]) / 255, tonumber(temp[3]) / 255, 1)
    end
  end
  _color = DataModel.cfg.moveColor
  if _color ~= "" then
    temp = string.split(_color, ",")
    if #temp == 3 then
      DataModel.MoveColor = Color(tonumber(temp[1]) / 255, tonumber(temp[2]) / 255, tonumber(temp[3]) / 255, 1)
    end
  end
  _color = DataModel.cfg.spinSideColor
  if _color ~= "" then
    temp = string.split(_color, ",")
    if #temp == 3 then
      DataModel.SpinSideColor = Color(tonumber(temp[1]) / 255, tonumber(temp[2]) / 255, tonumber(temp[3]) / 255, 1)
    end
  end
  local netdata = PlayerData.TempCache.CubeRogueData
  DataModel.maxDescent = nil
  DataModel.rotSpeed = DataModel.cfg.rotSpeed
  DataModel.rotDuration = DataModel.cfg.rotTime
  DataModel.resetSpeed = DataModel.cfg.resetSpeed
  DataModel.outlineWidth = DataModel.cfg.outlineWidth
  DataModel.curMoveNum = netdata.move_cnt
  DataModel.maxMoveNum = 1
  DataModel.curRotNum = netdata.rotate_cnt
  DataModel.maxRotNum = 1
  DataModel.stepNum = netdata.round_cnt or 0
  DataModel.difficult = netdata.difficulty
  DataModel.allConfig = PlayerData:GetFactoryData(89400002, "CubeRogueFactory")
  DataModel.difficultInfo = DataModel.allConfig.rogueDifficultList[DataModel.difficult + 1]
  DataModel.teamCfg = GetCA(netdata.team, "RogueTeamFactory")
  DataModel.battleRoles = netdata.roles
  local centerPosition = Vector3.zero
  local cubeSize = 2
  local gap = 0.4
  DataModel.rubikCube = RubikCube.new(centerPosition, cubeSize, gap, DataModel.cfg.cubeSize, DataModel.mapID)
  DataModel.rubikCube:SetData(netdata.faces)
  if not onlyUI then
    DataModel.rubikCube:LoadModel()
    DataModel.rubikCube:ShowIcon()
  end
  local curPos
  if DataModel.rubikCube.bossCube then
    local bossCfg = GetCA(tonumber(DataModel.rubikCube.bossCube.netData), "ActivityListFactory")
    local bossTypeCfg = GetCA(bossCfg.typeId, "TagFactory")
    DataModel.bossCtrl = RubikRole.new(bossTypeCfg.model)
    DataModel.bossCtrl:Generate(DataModel.rubikCube.bossCube)
    DataModel.bossCtrl:SetOffset(Vector3(bossTypeCfg.offsetX, bossTypeCfg.offsetY, bossTypeCfg.offsetZ), nil, Vector3(bossTypeCfg.Scale, bossTypeCfg.Scale, bossTypeCfg.Scale))
  else
    DataModel.bossCtrl = RubikRole.new()
    curPos = string.split(netdata.boss_pos, ":")
    DataModel.bossCtrl.face = tonumber(curPos[3])
    DataModel.bossCtrl.x = tonumber(curPos[1])
    DataModel.bossCtrl.y = tonumber(curPos[2])
  end
  curPos = string.split(netdata.cur_lct, ":")
  DataModel.roleCtrl = RubikRole.new(DataModel.allConfig.playerModel)
  DataModel.playerCube = DataModel.rubikCube:GetCube(tonumber(curPos[3]), tonumber(curPos[1]), tonumber(curPos[2]))
  DataModel.curSelectCube = DataModel.playerCube
  if not onlyUI then
    DataModel.roleCtrl:Generate(DataModel.playerCube, rotClick)
    DataModel.roleCtrl:SetOffset(Vector3.forward)
    DataModel.ShowPlayerOutline()
    DataModel:RotateToFaceUp(DataModel.roleCtrl.face, true)
  else
    DataModel.roleCtrl.face = tonumber(curPos[3])
    DataModel.roleCtrl.x = tonumber(curPos[1])
    DataModel.roleCtrl.y = tonumber(curPos[2])
  end
end

function DataModel.GetBossBuff()
  local result = {
    boss = {
      lv = 0,
      skills = {}
    },
    all = {
      lv = 0,
      skills = {}
    }
  }
  if PlayerData.TempCache.CubeRogueData.bos_events == nil then
    return result
  end
  for k, v in pairs(PlayerData.TempCache.CubeRogueData.bos_events) do
    local eCfg = PlayerData:GetFactoryData(k, "ActivityListFactory")
    local tCfg = PlayerData:GetFactoryData(eCfg.typeId, "TagFactory")
    v.num = v.num or 1
    if tCfg.battleBuffType == "Boss\229\133\179\229\141\161\231\148\159\230\149\136" or tCfg.battleBuffType == "\230\137\128\230\156\137\229\133\179\229\141\161\231\148\159\230\149\136" then
      result.boss.lv = result.boss.lv + tCfg.gradeAdd * v.num
      if tCfg.skillBuff ~= nil and tCfg.skillBuff ~= "" and 0 < tCfg.skillBuff then
        result.boss.skills[tCfg.skillBuff] = result.boss.skills[tCfg.skillBuff] or 0
        result.boss.skills[tCfg.skillBuff] = result.boss.skills[tCfg.skillBuff] + v.num
      end
    end
    if tCfg.battleBuffType == "\230\137\128\230\156\137\229\133\179\229\141\161\231\148\159\230\149\136" then
      result.all.lv = result.all.lv + tCfg.gradeAdd * v.num
      if tCfg.skillBuff ~= nil and tCfg.skillBuff ~= "" and 0 < tCfg.skillBuff then
        result.all.skills[tCfg.skillBuff] = result.all.skills[tCfg.skillBuff] or 0
        result.all.skills[tCfg.skillBuff] = result.all.skills[tCfg.skillBuff] + v.num
      end
    end
  end
  return result
end

function DataModel.AddBossBuff(tp_id, num)
  num = num or 1
  local temp = PlayerData.TempCache.CubeRogueData.bos_events
  temp = temp or {}
  temp[tp_id] = temp[tp_id] or {}
  temp[tp_id].num = temp[tp_id].num or 0
  temp[tp_id].num = temp[tp_id].num + num
  PlayerData.TempCache.CubeRogueData.bos_events = temp
end

function DataModel.GetMaxRoundNum()
  return DataModel.cfg.actionNum + OutSideData.MaxRoundNumAdd() + DataModel.attrManager:GetAttr(Enum_AttrType.InitialAction) + DataModel.itemAttrManager.GetAttr(Enum_RogueEventOrderType.Action) + DataModel.itemAttrManager.GetAttr(Enum_RogueItemOrderType.ActionItem)
end

function DataModel.GetMaxStepNum()
  return DataModel.maxMoveNum + DataModel.itemAttrManager.GetAttr(Enum_RogueEventOrderType.StepNum) + DataModel.itemAttrManager.GetAttr(Enum_RogueItemOrderType.StepNumItem)
end

function DataModel.GetMaxRotNum()
  return DataModel.maxRotNum + DataModel.itemAttrManager.GetAttr(Enum_RogueItemOrderType.SpinNumItem) + DataModel.itemAttrManager.GetAttr(Enum_RogueEventOrderType.SpinNum)
end

function DataModel.GetMaxItemNum()
  local press = DataModel.GetDescentAttr("IntuitionMaxNum").value
  return 0 < press and press or DataModel.allConfig.instinctMaxNum + OutSideData.ItemSlotNum()
end

function DataModel.GetMaxItemNum_Slot()
  return DataModel.allConfig.instinctMaxNum + OutSideData.ItemSlotNum()
end

function DataModel.GetCurSpecialNum()
  if DataModel.rubikCube == nil then
    return 0
  end
  return DataModel.rubikCube:GetCurSpecialNum(DataModel.playerCube)
end

function DataModel.SelectAll()
  DataModel.rotCube = DataModel.rubikCube:GetAll()
  for i, v in pairs(DataModel.rotCube) do
    v.obj.transform:SetParent(DataModel.rubikCube.rot.transform)
  end
end

function DataModel.CanMove()
  if DataModel.isRotating == true then
    return false
  end
  if DataModel.isResetRoting == true then
    return false
  end
  return true
end

function DataModel.SelectCubeHorizontal(face, x, y)
  DataModel.isHorizon = true
  DataModel.rotCube = DataModel.rubikCube:GetHorizontalAffected(face, x, y)
  for i, v in pairs(DataModel.rotCube) do
    v.obj.transform:SetParent(DataModel.rubikCube.rot.transform)
  end
  DataModel.SetSelectEffect(DataModel.rotCube, true)
end

function DataModel.SelectCubeVertical(face, x, y)
  DataModel.isHorizon = false
  DataModel.rotCube = DataModel.rubikCube:GetVerticalAffected(face, x, y)
  for i, v in pairs(DataModel.rotCube) do
    v.obj.transform:SetParent(DataModel.rubikCube.rot.transform)
  end
  DataModel.SetSelectEffect(DataModel.rotCube, true)
end

local function SetCubeOutLine(cube, visible, color)
  local obj = cube.obj
  if obj == nil then
    print("Object not found: ")
    return
  end
  local renderer = obj:GetComponentInChildren(typeof(CS.UnityEngine.MeshRenderer))
  if renderer == nil then
    print("Renderer not found on object: ")
    return
  end
  local material = renderer.material
  if material == nil then
    print("Material not found on object: ")
    return
  end
  if visible then
    material:SetFloat("_OutlineSize", DataModel.outlineWidth)
    color = color or Color(1, 0.8, 0, 1)
    material:SetColor("_OutlineColor", color)
  else
    material:SetFloat("_OutlineSize", 0)
  end
end

function DataModel.ShowPlayerRotDir(value)
  DataModel.roleCtrl:ActiveRotBtns(value)
end

function DataModel.ShowPlayerOutline()
  if DataModel.playerCube then
    SetCubeOutLine(DataModel.playerCube, false)
  end
  DataModel.playerCube = DataModel.rubikCube:GetCube(DataModel.roleCtrl.face, DataModel.roleCtrl.x, DataModel.roleCtrl.y)
  SetCubeOutLine(DataModel.playerCube, true, DataModel.CurrentColor or Color.white)
end

function DataModel.GetPlayerPos()
  local pPosX = 0
  local pPosY = 0
  local cubeSize = 0
  if DataModel.playerCube == nil then
    local temp = string.split(PlayerData.TempCache.CubeRogueData.cur_lct)
    pPosX = tonumber(temp[1])
    pPosY = tonumber(temp[2])
    local cfg = PlayerData:GetFactoryData(PlayerData.TempCache.CubeRogueData.cube_id)
    cubeSize = cfg.cubeSize
  else
    pPosX = DataModel.playerCube.row
    pPosY = DataModel.playerCube.col
    cubeSize = DataModel.cfg.cubeSize
  end
  if (pPosX == 1 or pPosX == cubeSize) and (pPosY == 1 or pPosY == cubeSize) then
    return DataModel.Enum_PlayerPos.Corner
  elseif 1 < pPosX and pPosX < cubeSize and 1 < pPosY and pPosY < cubeSize then
    return DataModel.Enum_PlayerPos.Center
  else
    return DataModel.Enum_PlayerPos.Side
  end
end

local function getArrowRot(x, y)
  if DataModel.roleCtrl == nil then
    return 0
  end
  local _x = DataModel.roleCtrl.x
  local _y = DataModel.roleCtrl.y
  local face = DataModel.roleCtrl.face
  local result = 0
  if face == 1 then
    result = CS.UnityEngine.Vector2.SignedAngle(Vector2(_x - x, _y - y), Vector2.up)
  elseif face == 2 or face == 3 or face == 4 or face == 5 then
    result = CS.UnityEngine.Vector2.SignedAngle(Vector2(_x - x, _y - y), Vector2.down)
  elseif face == 6 then
    result = CS.UnityEngine.Vector2.SignedAngle(Vector2(_x - x, _y - y), Vector2.left)
  end
  return result
end

function DataModel.ShowCanMoveOutline(visible)
  if DataModel.canMoveCubes then
    for k, v in ipairs(DataModel.canMoveCubes) do
      v.moveBtn.gameObject:SetActive(false)
    end
    DataModel.canMoveCubes = {}
  end
  if not visible then
    return
  end
  DataModel.canMoveCubes = DataModel.canMoveCubes or {}
  local cubeSize = DataModel.cfg.cubeSize
  local curFace = DataModel.roleCtrl.face
  local curX = DataModel.roleCtrl.x
  local curY = DataModel.roleCtrl.y
  local maxDis = DataModel.cfg.initialDistance + DataModel.itemAttrManager.GetAttr(Enum_RogueItemOrderType.StepDistanceItem)
  for tempX = 1, cubeSize do
    for tempY = 1, cubeSize do
      local dis = math.abs(tempX - curX) + math.abs(tempY - curY)
      if 0 < dis and maxDis >= dis then
        local tempCube = DataModel.rubikCube:GetCube(curFace, tempX, tempY)
        if tempCube then
          table.insert(DataModel.canMoveCubes, tempCube)
        end
      end
    end
  end
  for k, v in ipairs(DataModel.canMoveCubes) do
    v.moveBtn.gameObject:SetActive(true)
  end
end

function DataModel.CanMoveToCube(face, x, y)
  if DataModel.canMoveCubes == nil then
    return false
  end
  for k, v in pairs(DataModel.canMoveCubes) do
    if v.face == face and v.row == x and v.col == y then
      return true
    end
  end
  return false
end

function DataModel.SetSelectEffect(cubes, isVisible)
  do return end
  for i, v in pairs(cubes) do
    SetCubeOutLine(v, isVisible, DataModel.SpinSideColor or Color.yellow)
  end
end

function DataModel:RotateToFaceUp(targetFace, direct)
  local faceFinal = {
    Vector3(0, 0, 0),
    Vector3(90, 0, 0),
    Vector3(0, 90, 90),
    Vector3(-90, 180, 0),
    Vector3(0, -90, -90),
    Vector3(180, -90, 0)
  }
  local targetEuler = faceFinal[targetFace]
  if not targetEuler then
    print("\233\148\153\232\175\175: \230\156\170\231\159\165\231\154\132\231\155\174\230\160\135\233\157\162 " .. tostring(targetFace))
    return
  end
  if direct then
    DataModel.rubikCube.obj.transform.rotation = Quaternion.Euler(targetEuler)
    return
  end
  local targetRotation = Quaternion.Euler(targetEuler.x, targetEuler.y, targetEuler.z)
  DataModel.resetRotStartRotation = DataModel.rubikCube.obj.transform.rotation
  DataModel.resetRotTargetRotation = targetRotation
  DataModel.rotElapsed = 0.0
  DataModel.isRotating = false
  DataModel.isResetRoting = true
end

function DataModel.SendRotateMsg(nextface, doRot)
  Net:SendProto("cube.rotate", function(json)
    doRot(json)
  end, nextface)
end

function DataModel.CheckRoundEnd()
  DataModel.needStartRound = DataModel.curMoveNum >= DataModel.GetMaxStepNum() and DataModel.curRotNum >= DataModel.GetMaxRotNum()
  DataModel.needTriggerRoundEnd = DataModel.needStartRound
end

function DataModel.RotHorizon(face, clockwise)
  local function cb()
    DataModel.isResetRoting = false
    
    DataModel.isRotating = true
    DataModel.rotElapsed = 0
    local axis
    if face == 1 then
      DataModel.rotAxle = "z"
      axis = Vector3(0, 0, 1)
    elseif face == 6 then
      DataModel.rotAxle = "x"
      axis = Vector3(1, 0, 0)
    else
      DataModel.rotAxle = "y"
      axis = Vector3(0, 1, 0)
    end
    DataModel.rotDir = axis * clockwise
    DataModel.rotStartRotation = DataModel.rubikCube.rot.transform.localRotation
    local angle = 90 * clockwise
    local deltaRotation = Quaternion.AngleAxis(angle, axis)
    DataModel.rotTargetRotation = DataModel.rotStartRotation * deltaRotation
    DataModel.clockwise = clockwise
    local sound = SoundManager:CreateSound(DataModel.allConfig.turnSound)
    if sound then
      sound:Play()
    end
  end
  
  cb()
end

function DataModel.RotVertical(face, clockwise)
  local function cb()
    DataModel.isResetRoting = false
    
    DataModel.isRotating = true
    DataModel.rotElapsed = 0
    local axis
    local sym = 1
    if face == 1 or face == 2 then
      DataModel.rotAxle = "x"
      axis = Vector3(1, 0, 0)
    elseif face == 4 then
      DataModel.rotAxle = "x"
      axis = Vector3(1, 0, 0)
      sym = -1
    elseif face == 3 or face == 6 then
      DataModel.rotAxle = "x"
      axis = Vector3(0, 0, 1)
      sym = 1
    else
      DataModel.rotAxle = "z"
      axis = Vector3(0, 0, 1)
      sym = -1
    end
    DataModel.rotStartRotation = DataModel.rubikCube.rot.transform.localRotation
    local angle = 90 * -clockwise * sym
    local deltaRotation = Quaternion.AngleAxis(angle, axis)
    DataModel.rotTargetRotation = DataModel.rotStartRotation * deltaRotation
    DataModel.clockwise = clockwise
    local sound = SoundManager:CreateSound(DataModel.allConfig.turnSound)
    if sound then
      sound:Play()
    end
  end
  
  cb()
end

function DataModel.AutoRot()
  DataModel.ReleaseCube()
  DataModel.roleCtrl.face = math.random(1, 6)
  DataModel.roleCtrl.x = math.random(1, 3)
  DataModel.roleCtrl.y = math.random(1, 3)
  local rot = 1
  local rotStr = ""
  if math.random(1, 2) == 1 then
    rot = 1
    rotStr = ",\233\161\186\230\151\182\233\146\136"
  else
    rot = -1
    rotStr = ",\233\128\134\230\151\182\233\146\136"
  end
  if math.random(1, 2) == 1 then
    DataModel.SelectCubeHorizontal(DataModel.roleCtrl.face, DataModel.roleCtrl.x, DataModel.roleCtrl.y)
    DataModel.RotHorizon(DataModel.roleCtrl.face, rot)
    Debug.Log("\233\157\162" .. DataModel.roleCtrl.face .. ",x" .. DataModel.roleCtrl.x .. ",y" .. DataModel.roleCtrl.y .. ",\230\176\180\229\185\179" .. rotStr)
  else
    DataModel.SelectCubeVertical(DataModel.roleCtrl.face, DataModel.roleCtrl.x, DataModel.roleCtrl.y)
    DataModel.RotVertical(DataModel.roleCtrl.face, rot)
    Debug.Log("\233\157\162" .. DataModel.roleCtrl.face .. ",x" .. DataModel.roleCtrl.x .. ",y" .. DataModel.roleCtrl.y .. ",\229\158\130\231\155\180" .. rotStr)
  end
end

function DataModel.ReleaseCube()
  if DataModel.rotCube == nil then
    return
  end
  DataModel.SetSelectEffect(DataModel.rotCube, false)
  DataModel.ReleaseRot()
  DataModel.rotCube = {}
end

function DataModel.ReleaseRot()
  DataModel.rubikCube:StopAnim()
  for i, v in pairs(DataModel.rotCube) do
    local rot = v.obj.transform.rotation
    v.obj.transform:SetParent(DataModel.rubikCube.rot.transform.parent)
    v.obj.transform.rotation = rot
  end
  DataModel.rubikCube.rot.transform.localEulerAngles = Vector3.zero
end

function DataModel.GetBossRotData(toFace)
  local isVer, isClo
  local bossCurFace = DataModel.bossCtrl.face
  if bossCurFace == 1 then
    if toFace == 2 then
      isVer = true
      isClo = 1
    elseif toFace == 3 then
      isVer = false
      isClo = -1
    elseif toFace == 4 then
      isVer = true
      isClo = -1
    else
      isVer = false
      isClo = 1
    end
  elseif bossCurFace == 2 then
    if toFace == 1 then
      isVer = true
      isClo = -1
    elseif toFace == 6 then
      isVer = true
      isClo = 1
    elseif toFace == 3 then
      isVer = false
      isClo = -1
    else
      isVer = false
      isClo = 1
    end
  elseif bossCurFace == 3 then
    if toFace == 1 then
      isVer = true
      isClo = -1
    elseif toFace == 6 then
      isVer = true
      isClo = 1
    elseif toFace == 2 then
      isVer = false
      isClo = 1
    else
      isVer = false
      isClo = -1
    end
  elseif bossCurFace == 4 then
    if toFace == 1 then
      isVer = true
      isClo = -1
    elseif toFace == 6 then
      isVer = true
      isClo = 1
    elseif toFace == 3 then
      isVer = false
      isClo = 1
    else
      isVer = false
      isClo = -1
    end
  elseif bossCurFace == 5 then
    if toFace == 1 then
      isVer = true
      isClo = -1
    elseif toFace == 6 then
      isVer = true
      isClo = 1
    elseif toFace == 2 then
      isVer = false
      isClo = -1
    else
      isVer = false
      isClo = 1
    end
  elseif toFace == 2 then
    isVer = false
    isClo = 1
  elseif toFace == 3 then
    isVer = true
    isClo = -1
  elseif toFace == 4 then
    isVer = false
    isClo = -1
  else
    isVer = true
    isClo = 1
  end
  return isVer, isClo
end

function DataModel.GetDescentAttr(dType)
  local descentAttr
  if DataModel.descentAttr then
    descentAttr = DataModel.descentAttr
  else
    descentAttr = {}
    for k, v in pairs(PlayerData.TempCache.CubeRogueData.debuff) do
      local buffCA = PlayerData:GetFactoryData(k)
      if buffCA then
        if descentAttr[buffCA.orderType] == nil then
          descentAttr[buffCA.orderType] = {}
        end
        if buffCA.orderType ~= "Battle" and buffCA.orderType ~= "BossBattle" and buffCA.orderType ~= "BanRevive" then
          descentAttr[buffCA.orderType].value = descentAttr[buffCA.orderType].value or 0
          descentAttr[buffCA.orderType].value = descentAttr[buffCA.orderType].value + buffCA.param
        else
          table.insert(descentAttr[buffCA.orderType], buffCA.id)
        end
      end
    end
    DataModel.descentAttr = descentAttr
  end
  return descentAttr[dType] or {value = 0}
end

function DataModel.ResetNetData()
  local temp = PlayerData.TempCache.CubeRogueData
  if DataModel.roleCtrl then
    temp.cur_lct = DataModel.roleCtrl.x .. ":" .. DataModel.roleCtrl.y .. ":" .. DataModel.roleCtrl.face
  end
  if DataModel.bossCtrl then
    temp.boss_pos = DataModel.bossCtrl.x .. ":" .. DataModel.bossCtrl.y .. ":" .. DataModel.bossCtrl.face
  end
  if DataModel.rubikCube then
    temp.faces = DataModel.rubikCube:ResetNetData()
  end
  temp.move_cnt = DataModel.curMoveNum
  temp.rotate_cnt = DataModel.curRotNum
  temp.round_cnt = DataModel.stepNum
end

return DataModel
