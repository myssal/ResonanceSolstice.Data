local Effect = {
  effectData = {},
  effectid = 0
}

local function IsCurrentEffect(entry)
  local model = entry.model
  return model ~= nil and not model.isRecycled and model.produceFrame == entry.produceFrame and model.produceIndex == entry.produceIndex
end

function Effect.ShowEffect(parent, id, data, t)
  local model = Effect.LoadEffect(parent, id, data)
  if model == nil then
    return nil
  end
  local e = {
    model = model,
    time = t,
    produceFrame = model.produceFrame,
    produceIndex = model.produceIndex,
    id = Effect.effectid
  }
  Effect.effectid = Effect.effectid + 1
  Effect.effectData[e.id] = e
  return e.id
end

function Effect.Update()
  local deltaTime = Time.deltaTime
  for i, v in pairs(Effect.effectData) do
    if not IsCurrentEffect(v) then
      Effect.effectData[i] = nil
    else
      v.time = v.time - deltaTime
      if v.time < 0 then
        Effect.effectData[i] = nil
        v.model:Recycle()
      end
    end
  end
end

function Effect.LoadEffect(parent, effectID, offsetData)
  if EffectFactory == nil then
    EffectFactory = CBus:GetF(CS.ManagerName.ParticleManager, true)
  end
  local effect = EffectFactory:Produce(effectID)
  if effect then
    effect:SetParent(parent)
    local container = effect._container
    container.transform.localPosition = container.transform.localPosition + Vector3(offsetData.position.x, offsetData.position.y, offsetData.position.z)
    container.transform.localScale = Vector3(offsetData.scale.x, offsetData.scale.y, offsetData.scale.z)
    container.transform.localEulerAngles = Vector3(offsetData.rotation.x, offsetData.rotation.y, offsetData.rotation.z)
    if effect.PlayParticle ~= nil then
      effect:PlayParticle()
      effect:Excute()
    end
  end
  return effect
end

function Effect.RecycleAll()
  local pending = Effect.effectData
  Effect.effectData = {}
  for i, v in pairs(pending) do
    if IsCurrentEffect(v) then
      v.model:Recycle()
    end
  end
end

return Effect
