local View = require("UIHome_MachiningMenu/UIHome_MachiningMenuView")
local DataModel = {}
DataModel.allProductFur = {}
DataModel.curHaveProductFur = {}
DataModel.curHave = 0
DataModel.selectUpgradeIndex = nil
DataModel.furCtrs = {}

function DataModel.SetJsonData(json)
end

function DataModel.InitData()
  DataModel.allProductFur = {}
  DataModel.curHaveProductFur = {}
  DataModel.curHave = 0
  DataModel.furCtrs = {}
  DataModel.selectUpgradeIndex = nil
  local config = PlayerData:GetFactoryData(99900063, "ConfigFactory")
  local productFunType = {}
  for i, v in pairs(config.productionFurnitureList) do
    productFunType[v.id] = {cfg = v, menuIndex = i}
  end
  local fursData = PlayerData:GetFurniture()
  for ufid, v in pairs(fursData) do
    local furCA = PlayerData:GetFactoryData(v.id, "HomeFurnitureFactory")
    local manufactureType = furCA.manufactureType
    if manufactureType and productFunType[manufactureType] then
      DataModel.curHaveProductFur[manufactureType] = DataModel.curHaveProductFur[manufactureType] or {}
      table.insert(DataModel.curHaveProductFur[manufactureType], {ufid = ufid, furData = v})
      DataModel.curHave = DataModel.curHave + 1
    end
  end
  for funcType, cfg in pairs(productFunType) do
    if DataModel.curHaveProductFur[funcType] then
      for _, v in pairs(DataModel.curHaveProductFur[funcType]) do
        table.insert(DataModel.allProductFur, {productData = v, productCfg = cfg})
      end
    else
      table.insert(DataModel.allProductFur, {productData = nil, productCfg = cfg})
    end
  end
  
  local function GetSort(productFur)
    if not productFur.productData then
      return productFur.productCfg.menuIndex
    else
      return -1
    end
  end
  
  table.sort(DataModel.allProductFur, function(a, b)
    if a.productData and b.productData then
      return a.productCfg.menuIndex < b.productCfg.menuIndex
    else
      return GetSort(a) < GetSort(b)
    end
  end)
end

function DataModel.RefreshAfterUpgrade()
  if not DataModel.selectUpgradeIndex then
    return
  end
  local oldData = DataModel.allProductFur[DataModel.selectUpgradeIndex]
  if oldData and oldData.productData then
    local element = DataModel.furCtrs[DataModel.selectUpgradeIndex]
    local ufid = oldData.productData.ufid
    local furData = PlayerData:GetFurniture()[ufid]
    oldData.productData.furData = furData
    local furId = furData.id
    local furCA = PlayerData:GetFactoryData(furId, "HomeFurnitureFactory")
    element.Group_LV.Txt_Num:SetText(furCA.Level)
    element.Group_Able.Btn_Upgrade:SetActive(furCA.upgrade > 0)
  end
end

function DataModel.RefreshOnShow()
  local makeLv = PlayerData:GetHomeInfo().compound_lv
  View.Group_Decorate.Txt_1.Txt_:SetText("LV" .. makeLv)
  local makeExp = PlayerData:GetHomeInfo().compound_exp
  local totalExp = 0
  local makeCfg = PlayerData:GetFactoryData(99900173, "ConfigFactory")
  for i, v in pairs(makeCfg.MachiningExpList) do
    if v.MachiningLv == makeLv then
      totalExp = v.LvUpExp
      break
    end
  end
  local rate = totalExp == 0 and 0 or makeExp / totalExp
  View.Group_Decorate.Group_ProcessBar.Img_Process:SetFilledImgAmount(rate)
  local totalNum = table.count(DataModel.allProductFur)
  View.ScrollGrid_Furniture.grid.self:SetDataCount(totalNum)
  View.ScrollGrid_Furniture.grid.self:RefreshAllElement()
end

function DataModel.CheckUnlockFormula(id)
  local cfg = PlayerData:GetFactoryData(id, "ProductionFactory")
  if cfg.unlock == -1 then
    return true
  else
    local ownList = PlayerData.ServerData.formula_items or {}
    for k1, v1 in pairs(ownList) do
      if v1 == tostring(cfg.unlock) then
        return true
      end
    end
  end
  return false
end

function DataModel.GetFormulaRedState(furId)
  local homeMakeFurModel = require("UIHome_MachiningLathe/HomeMakeFurModel")
  local furCA = PlayerData:GetFactoryData(furId, "HomeFurnitureFactory")
  for i, formulaCfg in pairs(furCA.formulaGroup) do
    local unlock = DataModel.CheckUnlockFormula(formulaCfg.id)
    if unlock and homeMakeFurModel.GetFormulaRedStateById(formulaCfg.id, furCA.Level) then
      return true
    end
  end
  return false
end

function DataModel.GetRedPointState()
  for i, v in pairs(DataModel.allProductFur) do
    if v.productData then
      if not v.productData.furData.read or v.productData.furData.read == 0 then
        return true
      end
      if DataModel.GetFormulaRedState(v.productData.furData.id) then
        return true
      end
    end
  end
  return false
end

return DataModel
