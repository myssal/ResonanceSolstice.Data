local TrainEffectHelper = {
  Enum_TrainEffectType = {
    Light = 12600388,
    Sonar = 12600289,
    Rune = 12600301,
    SkinEffect = 99999999
  },
  DefaultEffect = {Light = 11105430},
  EffectsCache = {},
  SingleEffectsCache = {}
}

local function LoadEffectByEffectID(effectID, offsetData)
  if ParticleManager == nil then
    ParticleManager = CBus:GetManager(CS.ManagerName.ParticleManager, true)
  end
  local effect = ParticleManager:Create(effectID)
  if effect then
    effect:SetParent(TrainEffectHelper.CurFirstTrain.Skin.view.transform)
    local container = effect._container
    container.transform.localPosition = container.transform.localPosition + Vector3(offsetData.position.x, offsetData.position.y, offsetData.position.z)
    container.transform.localScale = Vector3(offsetData.scale.x, offsetData.scale.y, offsetData.scale.z)
    container.transform.localEulerAngles = Vector3(offsetData.rotation.x, offsetData.rotation.y, offsetData.rotation.z)
    effect:PlayParticle()
    effect:Excute()
  end
  return effect
end

local function LoadEffectByTypeWeapon(typeWeapon, typeWeaponData, cache)
  TrainEffectHelper:DisposeEffects(typeWeapon)
  if cache then
    TrainEffectHelper.EffectsCache[typeWeapon] = TrainEffectHelper.EffectsCache[typeWeapon] or {}
  end
  for k, v in pairs(typeWeaponData) do
    if cache then
      TrainEffectHelper.EffectsCache[typeWeapon][k] = TrainEffectHelper.EffectsCache[typeWeapon][k] or {}
    end
    for m, n in ipairs(v) do
      local product = LoadEffectByEffectID(k, n)
      if cache and product then
        table.insert(TrainEffectHelper.EffectsCache[typeWeapon][k], product)
      end
    end
  end
end

function TrainEffectHelper:LoadEffect(trainType, typeWeapon, forceRefresh, cache)
  if not forceRefresh and self.EffectsCache[typeWeapon] then
    return true
  end
  if trainType == 1 then
    TrainWeaponTag.isKabaneri = true
  else
    TrainWeaponTag.isKabaneri = false
  end
  self.CurFirstTrain = TrainWeaponTag.GetRealFirstTrain()
  if self.CurFirstTrain == nil or self.CurFirstTrain.Skin == nil then
    return false
  end
  local effectsData
  if typeWeapon ~= self.Enum_TrainEffectType.SkinEffect then
    effectsData = TrainWeaponTag.GetTrainEffectsData(typeWeapon)
  else
    effectsData = TrainWeaponTag.GetTrainAccEffectData()
  end
  if not effectsData then
    return false
  end
  cache = cache == nil and true or cache
  for k, v in pairs(effectsData) do
    LoadEffectByTypeWeapon(k, v, cache)
  end
  self.CurFirstTrain = nil
  return true
end

function TrainEffectHelper:DisposeEffects(typeWeapon)
  if typeWeapon then
    if self.EffectsCache[typeWeapon] then
      for k, v in pairs(self.EffectsCache[typeWeapon]) do
        for m, n in ipairs(v) do
          n:Recycle()
        end
      end
      self.EffectsCache[typeWeapon] = nil
    end
  else
    for k, v in pairs(self.EffectsCache) do
      for m, n in pairs(v) do
        for a, b in ipairs(n) do
          b:Recycle()
        end
      end
    end
    self.EffectsCache = {}
  end
end

function TrainEffectHelper:SetEffectsActive(typeWeapon, value)
  if self.EffectsCache and self.EffectsCache[typeWeapon] then
    for k, v in pairs(self.EffectsCache[typeWeapon]) do
      for m, n in ipairs(v) do
        n:SetActive(value)
      end
    end
  end
end

function TrainEffectHelper:LoadSingleEffect(trainType, effectID, cache)
  if trainType == 1 then
    TrainWeaponTag.isKabaneri = true
  else
    TrainWeaponTag.isKabaneri = false
  end
  local Trains = TrainWeaponTag.GetRealFirstTrain()
  if Trains == nil then
    return
  end
  self.CurFirstTrain = Trains
  local effectCA = PlayerData:GetFactoryData(effectID, "EffectFactory")
  if effectCA == nil then
    return
  end
  local offsetData
  if Trains.Skin ~= nil and Trains.Skin.ca ~= nil then
    local skinCA = PlayerData:GetFactoryData(Trains.Skin.ca.id, "HomeCoachSkinFactory")
    if skinCA ~= nil and skinCA.xxxTransData ~= nil then
      local v = skinCA.xxxTransData
      offsetData = {
        position = {
          x = v.x,
          y = v.y,
          z = v.z
        },
        scale = {
          x = v.xs > 0 and v.xs or 1,
          y = 0 < v.ys and v.ys or 1,
          z = 0 < v.zs and v.zs or 1
        },
        rotation = {
          x = v.xx,
          y = v.yx,
          z = v.zx
        }
      }
    end
  end
  offsetData = offsetData or {
    position = {
      x = effectCA.offsetX,
      y = effectCA.offsetY,
      z = effectCA.offsetZ
    },
    scale = {
      x = 0 < effectCA.scaleX and effectCA.scaleX or 1,
      y = 0 < effectCA.scaleY and effectCA.scaleY or 1,
      z = 0 < effectCA.scaleZ and effectCA.scaleZ or 1
    },
    rotation = {
      x = effectCA.eularX,
      y = effectCA.eularY,
      z = effectCA.eularZ
    }
  }
  local product = LoadEffectByEffectID(effectID, offsetData)
  if cache then
    self.SingleEffectsCache[effectID] = self.SingleEffectsCache[effectID] or {}
    table.insert(self.SingleEffectsCache[effectID], product)
  end
  self.CurFirstTrain = nil
end

function TrainEffectHelper:DisposeSingleEffects(effectID)
  if not effectID then
    for k, v in pairs(self.SingleEffectsCache) do
      for m, n in ipairs(v) do
        n:Recycle()
      end
    end
    self.SingleEffectsCache = {}
  elseif self.SingleEffectsCache[effectID] ~= nil then
    for k, v in pairs(self.SingleEffectsCache[effectID]) do
      v:Recycle()
    end
    self.SingleEffectsCache[effectID] = nil
  end
end

function TrainEffectHelper:Dispose()
  self:DisposeEffects()
  self:DisposeSingleEffects()
  self.CurFirstTrain = nil
end

return TrainEffectHelper
