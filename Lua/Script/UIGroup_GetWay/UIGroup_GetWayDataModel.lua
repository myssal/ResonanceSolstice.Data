local DataModel = {}

function DataModel:init(params)
  local data = Json.decode(params)
  local ItemID = data.itemID
  self.isTrainWeapon = DataManager:GetFactoryNameById(ItemID) == "HomeWeaponFactory"
  self.getwayList = PlayerData:GetFactoryData(ItemID).Getway
  self.posX = data.posX
  self.posY = data.posY
  self.goback_num = data.goback_num
end

function DataModel.GetMakeFurSkipInfo(formulaId)
  local serverMakeFurs = HomeFurnitureCollection.GetFunctionByID(12600705) or {}
  local furUid
  local find = false
  for k, v in pairs(serverMakeFurs) do
    local id = PlayerData:GetFurniture()[k].id
    local cfg = PlayerData:GetFactoryData(id)
    local formulaList = cfg.formulaGroup or {}
    for i, v in ipairs(formulaList) do
      if v.id == formulaId then
        find = true
        break
      end
    end
    if find then
      furUid = k
      break
    end
  end
  if find == false then
    return {notfind = true}
  end
  local lock = true
  local id = PlayerData:GetFurniture()[furUid].id
  local cfg = PlayerData:GetFactoryData(formulaId)
  if cfg.unlock == -1 then
    lock = false
  else
    local ownList = PlayerData.ServerData.formula_items or {}
    for k1, v1 in pairs(ownList) do
      if v1 == tostring(cfg.unlock) then
        lock = false
        break
      end
    end
  end
  if lock then
    return {
      lock = true,
      ufid = furUid,
      furId = id
    }
  end
  local t = {
    ufid = furUid,
    furId = id,
    productionId = formulaId
  }
  return t
end

return DataModel
