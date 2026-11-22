local DataModel = {}

local function FurIsOwn(manufactureType)
  local serverMakeFurs = HomeFurnitureCollection.GetFunctionByID(12600705)
  local own = false
  local furUid
  for k, v in pairs(serverMakeFurs) do
    local id = PlayerData:GetFurniture()[k].id
    local cfg = PlayerData:GetFactoryData(id)
    if cfg.manufactureType == manufactureType then
      furUid = k
      own = true
      break
    end
  end
  return own, furUid
end

local function CreateSaveFormulaInfo(furUid)
  local id = PlayerData:GetFurniture()[furUid].id
  local fCfg = PlayerData:GetFactoryData(id)
  local formulaGroup = fCfg.formulaGroup
  for i, v in ipairs(formulaGroup) do
    for i1, v1 in ipairs(DataModel.saveFormulaList) do
      if v.id == tonumber(v1) then
        local cfg = PlayerData:GetFactoryData(v.id)
        local formulaCfg = PlayerData:GetFactoryData(cfg.condition[1].id)
        local productId = formulaCfg.draw[1].id
        local uiPath = fCfg.interfaceUrl
        table.insert(DataModel.formulaList, {
          formulaId = v1,
          productId = productId,
          uiPath = uiPath,
          furUid = furUid
        })
        break
      end
    end
  end
end

function DataModel.Init()
  local str = PlayerData:GetPlayerPrefs("string", "saveFormulaList")
  DataModel.saveFormulaList = string.split(str, "|")
  if DataModel.saveFormulaList[1] == "" then
    DataModel.saveFormulaList = {}
  end
  DataModel.saveMaxCnt = 10
  DataModel.formulaList = {}
  local productionFurnitureList = PlayerData:GetFactoryData(99900063).productionFurnitureList
  for i, v in ipairs(productionFurnitureList) do
    local isOwn, furUid = FurIsOwn(v.id)
    if isOwn then
      CreateSaveFormulaInfo(furUid)
    end
  end
end

return DataModel
