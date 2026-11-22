local Manager = {}
local gameCfg

function Manager:GetGameConfig()
  if not gameCfg then
    gameCfg = PlayerData:GetFactoryData(99900221, "ConfigFactory")
  end
  return gameCfg
end

function Manager:CameraMoveTo(trans)
  WasteLandManager.wasteLandCamera:MoveTo(trans)
end

function Manager:GameInit()
  self.train = nil
  self.trainMovePosList = {}
  self.trainMoveIndex = 1
  self.trainMove = false
  self.trainRotateTime = 0.2
  self.trainMoveSpeed = 3
  WastelandEntityManager:Init()
  WastelandEventManager:Init()
  WastelandSystemManager:Init()
  
  local function cb()
    CBus:ChangeScene("WasteLandMap", function()
      local obj = CS.UnityEngine.GameObject.Find("ClickEffectCanvas")
      if obj then
        obj:SetActive(false)
      end
      self:CreateTrain()
      self:CreateRails()
      self:CameraMoveTo(self.train:GetContainerTrans())
      UIManager:Open("UI/Wasteland/WasteLandMap")
    end)
  end
  
  CommonTips.OpenLoadingCB(cb)
end

function Manager:CreateTrain()
  local train = WastelandEntityManager:CreateEntity(91500058)
  train:SetPosition(1, -1, 0)
  self.train = train
end

function Manager:CreateRails()
  local configCA = PlayerData:GetFactoryData(99900097, "ConfigFactory")
  for _, tileInfo in pairs(configCA.wastelandMap) do
    if tileInfo.entityId > 0 then
      local rail = WastelandEntityManager:CreateEntity(tileInfo.entityId)
      rail:SetPosition(tileInfo.x, tileInfo.y, 0)
    end
  end
end

function Manager:QuitGame()
  self.train = nil
  WastelandEntityManager:Destroy()
  WastelandEventManager:Destroy()
  WastelandSystemManager:Destroy()
  
  local function cb()
    CBus:ChangeScene("Main")
  end
  
  CommonTips.OpenLoadingCB(cb)
end

function Manager:StartSearchGame()
  self.player = nil
  self.playerMove = false
  self.playerStep = 0
  self.playerGatherTargetId = nil
  self.playerGatherTimer = 0
  self.playerItems = {}
  self.playerItemIndex = 0
  self.playerEquip = nil
  self.curLevelIndex = 1
  self.playerMoveTarget = nil
  self.playerMoveSpeed = 5
  WastelandEntityManager:Init()
  WastelandEventManager:Init()
  WastelandSystemManager:Init()
  
  local function cb()
    CBus:ChangeScene("WasteLandSearch", function()
      local obj = CS.UnityEngine.GameObject.Find("ClickEffectCanvas")
      if obj then
        obj:SetActive(false)
      end
      self:LoadPlayer()
      self:LoadLevel()
      self:CameraMoveTo(self.player:GetContainerTrans())
      UIManager:Open("UI/Wasteland/WasteLandMain")
    end)
  end
  
  CommonTips.OpenLoadingCB(cb)
end

function Manager:SetPlayerStep(step)
  self.playerStep = step
  WastelandEventManager:Trigger(WastelandEnum.Event.OnPlayerStepChange)
end

function Manager:SetPlayerEquip(equip)
  if self.playerEquip and self.playerEquip == equip then
    return
  end
  if self.playerEquip then
    local attachments = WasteLandUtility.GetEquipAttachments(self.playerEquip)
    self.player:ChangeSpineAttachment(attachments, false)
  end
  if equip then
    local attachments = WasteLandUtility.GetEquipAttachments(equip)
    self.player:ChangeSpineAttachment(attachments, true)
  end
  self.playerEquip = equip
  WastelandEventManager:Trigger(WastelandEnum.Event.OnPlayerEquipChange)
end

function Manager:QuitSearchGame()
  self.player = nil
  self:GameInit()
end

function Manager:GetLevelConfig(levelIndex)
  local listCA = PlayerData:GetFactoryData(80308066, "ListFactory")
  local levelId = listCA.wastelandLevelList[levelIndex] and listCA.wastelandLevelList[levelIndex].id
  if levelId then
    return PlayerData:GetFactoryData(levelId, "ConfigFactory")
  end
end

function Manager:GetCurrentLevelConfig()
  return self:GetLevelConfig(self.curLevelIndex)
end

function Manager:LoadPlayer()
  local levelCA = self:GetCurrentLevelConfig()
  local startPos = levelCA.wastelandStartEnd[1]
  local player = WastelandEntityManager:CreateEntity(91500002)
  self.player = player
  player:SetPosition(startPos.x, startPos.y, 0)
end

function Manager:LoadLevel()
  local configCA = self:GetCurrentLevelConfig()
  for _, tileInfo in pairs(configCA.wastelandMap) do
    if tileInfo.cellId > 0 then
      local cellEntity = WastelandEntityManager:CreateEntity(tileInfo.cellId)
      cellEntity:SetPosition(tileInfo.x, tileInfo.y, 0)
    end
    if 0 < tileInfo.entityId then
      local resourceEntity = WastelandEntityManager:CreateEntity(tileInfo.entityId)
      resourceEntity:SetPosition(tileInfo.x, tileInfo.y, 0)
    end
    if 0 < tileInfo.itemId then
      local itemEntity = WastelandEntityManager:CreateEntity(tileInfo.itemId)
      itemEntity:SetPosition(tileInfo.x, tileInfo.y, 0)
    end
  end
  self:SetPlayerStep(configCA.initialStepNum)
end

function Manager:GetResourceEntity(x, y)
  local t = WastelandEntityManager:GetEntitiesByPos(x, y, WastelandEnum.EntityType.Resource)
  return t and t[1]
end

function Manager:GetItemEntity(x, y)
  local t = WastelandEntityManager:GetEntitiesByPos(x, y, WastelandEnum.EntityType.Item)
  return t and t[1]
end

return Manager
