local Controller = {}
local GameManager = WastelandGameManager

local function TrainWalkableCb(worldPos)
  local t = WastelandEntityManager:GetEntitiesByPos(worldPos.x, worldPos.y, WastelandEnum.EntityType.Rail)
  return t[1] ~= nil
end

local function TrainMovementCostCb(currentWorldPos, targetWorldPos)
  return 1
end

function Controller:TrainMove(entity)
  if GameManager.trainMove then
    return
  end
  WastelandGameManager:StartSearchGame()
end

local rotation
local rotateTime = 0

function Controller:UpdateTrainMove()
  if not GameManager.train then
    return
  end
  if not GameManager.trainMove then
    return
  end
  local posInfo = GameManager.trainMovePosList[GameManager.trainMoveIndex]
  if not posInfo then
    GameManager.trainMove = false
    return
  end
  local targetPos = Vector3(posInfo.x, posInfo.y, 0)
  local dir = targetPos - GameManager.train:GetPosition()
  if not rotation then
    local angle = Vector3.Angle(GameManager.train:GetContainerTrans().up, dir.normalized)
    if angle ~= 0 then
      rotation = GameManager.train:GetContainerTrans().rotation * Quaternion.Euler(0, 0, angle)
      rotateTime = 0
    end
  end
  if rotation and rotateTime < GameManager.trainRotateTime then
    rotateTime = rotateTime + Time.deltaTime
    GameManager.train:GetContainerTrans().rotation = Quaternion.Slerp(GameManager.train:GetContainerTrans().rotation, rotation, math.min(rotateTime / GameManager.trainRotateTime, 1))
  else
    rotation = nil
    rotateTime = 0
    local distance = Vector3.Distance(GameManager.train:GetPosition(), targetPos)
    if 0.1 < distance then
      local position = Vector3.MoveTowards(GameManager.train:GetPosition(), targetPos, GameManager.trainMoveSpeed * Time.deltaTime)
      GameManager.train:SetPosition(position)
    else
      GameManager.trainMoveIndex = GameManager.trainMoveIndex + 1
      GameManager.train:SetPosition(targetPos)
    end
  end
end

function Controller.TrainInteract(entity)
  local entityCA = entity:GetCa()
  local interactType = entityCA.interactType
  if interactType == "Adv" then
    WastelandGameManager:StartSearchGame()
  elseif interactType == "Box" then
  elseif interactType == "Repair" then
  elseif interactType == "Build" then
  elseif interactType == "PVE" then
  elseif interactType == "Obstacle" then
  elseif interactType == "Event" then
  end
end

function Controller:PlayerMove(target)
  if GameManager.playerMove then
    return
  end
  if GameManager.playerStep == 0 or GameManager.playerMoveTarget then
    return
  end
  GameManager:SetPlayerStep(GameManager.playerStep - 1)
  GameManager.playerMoveTarget = target:GetPosition()
  GameManager.player:PlaySpineAnim("dorm_run")
  GameManager.playerMove = true
end

function Controller:UpdatePlayerMove()
  if not GameManager.player then
    return
  end
  if not GameManager.playerMove then
    return
  end
  if not GameManager.playerMoveTarget then
    return
  end
  local scale = GameManager.player:GetViewTrans().localScale
  scale.x = GameManager.playerMoveTarget.x - GameManager.player:GetPosition().x
  GameManager.player:GetViewTrans().localScale = scale
  local distance = Vector3.Distance(GameManager.player:GetPosition(), GameManager.playerMoveTarget)
  if 0.1 < distance then
    local position = Vector3.MoveTowards(GameManager.player:GetPosition(), GameManager.playerMoveTarget, GameManager.playerMoveSpeed * Time.deltaTime)
    GameManager.player:SetPosition(position)
  else
    GameManager.player:SetPosition(GameManager.playerMoveTarget)
    GameManager.playerMoveTarget = nil
    GameManager.playerMove = false
    self:PlayerMoveCompleted()
  end
end

function Controller:PlayerMoveCompleted()
  local levelCA = GameManager:GetCurrentLevelConfig()
  local endPos = levelCA.wastelandStartEnd[2]
  local pos = GameManager.player:GetPosition()
  if pos.x == endPos.x and pos.y == endPos.y then
    GameManager.player = nil
    WastelandEntityManager:RecycleEntities()
    GameManager.curLevelIndex = GameManager.curLevelIndex + 1
    GameManager:LoadPlayer()
    GameManager:LoadLevel()
    return
  end
  local itemEntity = GameManager:GetItemEntity(pos.x, pos.y)
  if itemEntity then
    local ca = itemEntity:GetCa()
    if ca.stepNum > 0 then
      GameManager:SetPlayerStep(ca.stepNum)
    end
    if 0 < ca.equip then
      table.insert(GameManager.playerItems, itemEntity:GetCaId())
    end
  end
  GameManager.player:PlaySpineAnim("dorm_stand")
end

function Controller:PlayerGather(entity)
  if GameManager.playerGatherTargetId or not GameManager.playerEquip then
    return
  end
  local resourceCA = entity.ca
  local canGather = false
  local playerEquip = GameManager.playerEquip
  local equipCA = PlayerData:GetFactoryData(playerEquip, "WasteLandEquipFactory")
  for i, v in ipairs(equipCA.gatherList) do
    if v.id == entity:GetCaId() then
      canGather = true
    end
  end
  if not canGather then
    return
  end
  GameManager.playerGatherTargetId = entity:GetEntityId()
  GameManager.playerGatherTimer = 0
  GameManager.player:PlaySpineAnim(resourceCA.gatherAnim)
end

function Controller:UpdatePlayerGather()
  if not GameManager.playerGatherTargetId then
    return
  end
  local gatherEntity = WastelandEntityManager:GetEntity(GameManager.playerGatherTargetId)
  if not gatherEntity then
    return
  end
  local attrComp = GameManager.player:GetAttrComp()
  GameManager.playerGatherTimer = GameManager.playerGatherTimer + attrComp:GetAttr(WastelandEnum.Attr.GatherSpeed) * Time.deltaTime
  if GameManager.playerGatherTimer >= 1 then
    GameManager.playerGatherTimer = 0
    local damage = attrComp:GetAttr(WastelandEnum.Attr.Attack)
    if GameManager.playerEquip then
      damage = damage + PlayerData:GetFactoryData(GameManager.playerEquip, "WasteLandEquipFactory").damage
    end
    local hp = gatherEntity:GetAttrComp():GetAttr(WastelandEnum.Attr.Hp) - damage
    gatherEntity:GetAttrComp():SetAttr(WastelandEnum.Attr.Hp, hp)
    if hp == 0 then
      WastelandEntityManager:RecycleEntity(gatherEntity)
      GameManager.playerGatherTargetId = nil
      GameManager.player:PlaySpineAnim("dorm_stand")
    end
  end
end

function Controller.CreateEffect(id)
  local effect = WasteLandManager:CreateEffect(id)
  effect:SetSortOrder(300)
  return effect
end

return Controller
