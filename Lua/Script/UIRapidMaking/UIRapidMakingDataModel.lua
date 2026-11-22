local DataModel = {}

local function FurIsOwn(manufactureType)
  local serverMakeFurs = HomeFurnitureCollection.GetFunctionByID(12600705) or {}
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
        DataModel.makeFurList[1][i1] = {
          formulaId = v.id,
          productId = productId,
          uiPath = uiPath,
          furUid = furUid
        }
        break
      end
    end
  end
end

function DataModel.Init(isFurOpen)
  DataModel.isFurOpen = isFurOpen
  local productionFurnitureList = PlayerData:GetFactoryData(99900063).productionFurnitureList
  DataModel.makeFurList = {}
  DataModel.tabIdx = 1
  DataModel.nowProductIdx = 1
  local str = PlayerData:GetPlayerPrefs("string", "saveFormulaList")
  DataModel.saveFormulaList = string.split(str, "|")
  if DataModel.saveFormulaList[1] == "" then
    DataModel.saveFormulaList = {}
  end
  DataModel.makeFurList[1] = {}
  for i, v in ipairs(productionFurnitureList) do
    local isOwn, furUid = FurIsOwn(v.id)
    if isOwn then
      table.insert(DataModel.makeFurList, {
        furUid = furUid,
        uiPath = v.UIName,
        icon = v.UIPicture,
        unLockList = {}
      })
      CreateSaveFormulaInfo(furUid)
    end
  end
  DataModel.saveMaxCnt = 10
end

local function FindUnLockProducts(furUid)
  local id = PlayerData:GetFurniture()[furUid].id
  local fCfg = PlayerData:GetFactoryData(id)
  local formulaGroup = fCfg.formulaGroup
  local productList = {}
  for i, v in ipairs(formulaGroup) do
    local cfg = PlayerData:GetFactoryData(v.id)
    if cfg.unlock == -1 then
      local formulaCfg = PlayerData:GetFactoryData(cfg.condition[1].id)
      local productId = formulaCfg.draw[1].id
      table.insert(productList, {
        productId = productId,
        formulaId = v.id
      })
    else
      local ownList = PlayerData.ServerData.formula_items or {}
      for k1, v1 in pairs(ownList) do
        if v1 == tostring(cfg.unlock) then
          local formulaCfg = PlayerData:GetFactoryData(cfg.condition[1].id)
          local productId = formulaCfg.draw[1].id
          table.insert(productList, {
            productId = productId,
            formulaId = v.id
          })
          break
        end
      end
    end
  end
  return productList
end

function DataModel.GetUnLockFormulas(idx)
  if idx == 1 then
    return DataModel.makeFurList[idx]
  end
  local list = DataModel.makeFurList[idx].unLockList
  if not next(list) then
    local furUid = DataModel.makeFurList[idx].furUid
    list = FindUnLockProducts(furUid)
  end
  DataModel.makeFurList[idx].unLockList = list
  return list
end

function DataModel.FormulaIsSave(formulaId)
  local save = false
  for i, v in ipairs(DataModel.saveFormulaList) do
    if tonumber(v) == formulaId then
      save = true
      break
    end
  end
  return save
end

function DataModel.SaveFormula(formulaId, furUid)
  local save = DataModel.FormulaIsSave(formulaId)
  if not save then
    if #DataModel.saveFormulaList >= DataModel.saveMaxCnt then
      CommonTips.OpenTips(80609367)
      return
    end
    local saveId = formulaId
    if type(formulaId) == "number" then
      saveId = tostring(formulaId)
    end
    table.insert(DataModel.saveFormulaList, saveId)
    local id = PlayerData:GetFurniture()[furUid].id
    local fCfg = PlayerData:GetFactoryData(id)
    local formulaGroup = fCfg.formulaGroup
    for i, v in ipairs(formulaGroup) do
      if v.id == formulaId then
        local cfg = PlayerData:GetFactoryData(v.id)
        local formulaCfg = PlayerData:GetFactoryData(cfg.condition[1].id)
        local productId = formulaCfg.draw[1].id
        local uiPath = fCfg.interfaceUrl
        table.insert(DataModel.makeFurList[1], {
          formulaId = formulaId,
          productId = productId,
          uiPath = uiPath,
          furUid = furUid
        })
        break
      end
    end
  else
    local idx = -1
    for i, v in ipairs(DataModel.saveFormulaList) do
      if tonumber(v) == formulaId then
        idx = i
        break
      end
    end
    if -1 < idx then
      table.remove(DataModel.saveFormulaList, idx)
      table.remove(DataModel.makeFurList[1], idx)
    end
  end
  local str = table.concat(DataModel.saveFormulaList, "|")
  PlayerData:SetPlayerPrefs("string", "saveFormulaList", str)
end

return DataModel
