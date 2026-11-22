local Utility = {}
local entityIdGenerator = 0

function Utility.GenerateEntityId()
  entityIdGenerator = entityIdGenerator + 1
  return entityIdGenerator
end

function Utility.GetEquipAttachments(equipId)
  local equipCA = PlayerData:GetFactoryData(equipId, "WasteLandEquipFactory")
  local attachmentsJsonTable = {}
  local info
  if #equipCA.attachments > 0 then
    info = {}
    for i, v in ipairs(equipCA.attachments) do
      info[tostring(i)] = {
        resPath = v.spineUrl,
        targetSlotName = v.slotName,
        targetAttachName = v.attachName,
        replaceSlotName = v.slotName,
        replaceAttachName = v.attachName:gsub("%d+$", "")
      }
    end
  end
  attachmentsJsonTable["1"] = info
  return attachmentsJsonTable
end

function Utility.ClickEntityUp(entityId)
  local entity = WastelandEntityManager:GetEntity(entityId)
  if entity then
    local entityType = entity.ca.entityType
    if entityType == WastelandEnum.EntityType.Cell then
      WastelandGameController:PlayerMove(entity)
    elseif entityType == WastelandEnum.EntityType.Resource then
      WastelandGameController:PlayerGather(entity)
    elseif entityType == WastelandEnum.EntityType.Rail then
      WastelandGameController:TrainMove(entity)
    elseif entityType == WastelandEnum.EntityType.TrainInteract then
      WastelandGameController:TrainInteract(entity)
    end
  end
end

function Utility.ClickEntityDown(entityId)
end

return Utility
