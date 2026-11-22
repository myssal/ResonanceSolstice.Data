local View = require("UIRapidMaking/UIRapidMakingView")
local DataModel = require("UIRapidMaking/UIRapidMakingDataModel")

local function JumpFur()
  local data = DataModel.makeFurList[DataModel.tabIdx]
  local formulaId = -1
  if DataModel.tabIdx == 1 then
    data = DataModel.makeFurList[1][DataModel.nowProductIdx]
    if data == nil then
      return
    end
    formulaId = data.formulaId
  else
    if data.unLockList[DataModel.nowProductIdx] == nil then
      return
    end
    formulaId = data.unLockList[DataModel.nowProductIdx].formulaId
  end
  if DataModel.isFurOpen then
    UIManager:GoBack(false)
  end
  local furId = PlayerData:GetFurniture()[data.furUid].id
  local t = {
    ufid = data.furUid,
    furId = furId,
    productionId = formulaId
  }
  UIManager:Open(data.uiPath, Json.encode(t))
end

local function GetItemIcon(itemId)
  local factoryName = DataManager:GetFactoryNameById(itemId)
  local caData = PlayerData:GetFactoryData(itemId, factoryName)
  local iconPath = ""
  if factoryName == "UnitFactory" then
    local unit = PlayerData:GetFactoryData(caData.viewId)
    iconPath = unit.face
  elseif factoryName == "HomeCoachFactory" then
    iconPath = caData.thumbnailone
  elseif factoryName == "UnitViewFactory" then
    iconPath = caData.iconPath
  else
    iconPath = caData.iconPath or caData.imagePath
  end
  return iconPath
end

local ViewFunction = {
  RapidMaking_Btn_Close_Click = function(btn, str)
    View.self:CloseUI()
  end,
  RapidMaking_Group_Left_ScrollGrid_Item_SetGrid = function(element, elementIndex)
    local productId = -1
    local name = ""
    local formulaId = -1
    if DataModel.tabIdx == 1 then
      local data = DataModel.makeFurList[1][elementIndex]
      productId = data.productId
      formulaId = data.formulaId
    else
      local list = DataModel.makeFurList[DataModel.tabIdx].unLockList
      local data = list[elementIndex]
      productId = data.productId
      formulaId = data.formulaId
    end
    name = PlayerData:GetFactoryData(productId).name
    element.Btn_ChangBtn.Group_Item.Img_Item:SetSprite(GetItemIcon(productId))
    element.Btn_ChangBtn.Group_Item.Txt_Name:SetText(name)
    element.Btn_ChangBtn.Img_Choose:SetActive(DataModel.nowProductIdx == elementIndex)
    element.Btn_ChangBtn:SetClickParam(elementIndex)
    local save = DataModel.FormulaIsSave(formulaId)
    element.Btn_ChangBtn.Group_Item.Img_Icon:SetActive(save)
    if DataModel.nowProductIdx == elementIndex then
      local content = save and GetText(80609366) or GetText(80609118)
      View.Group_Left.Group_Bottum.Btn_sc.Group_.Txt_:SetText(content)
    end
  end,
  RapidMaking_Group_Left_ScrollGrid_Item_Group_Item_Btn_ChangBtn_Click = function(btn, str)
    if tonumber(str) == DataModel.nowProductIdx then
      JumpFur()
      return
    end
    DataModel.nowProductIdx = tonumber(str)
    View.Group_Left.ScrollGrid_Item.grid.self:RefreshAllElement()
  end,
  RapidMaking_Group_Left_Group_Bottum_Btn_zz_Click = function(btn, str)
    JumpFur()
  end,
  RapidMaking_Group_Left_Group_Bottum_Btn_sc_Click = function(btn, str)
    local formulaId = -1
    local furUid = -1
    if DataModel.tabIdx == 1 then
      local data = DataModel.makeFurList[1]
      if data[DataModel.nowProductIdx] == nil then
        return
      end
      formulaId = data[DataModel.nowProductIdx].formulaId
      furUid = data[DataModel.nowProductIdx].furUid
      DataModel.nowProductIdx = 1
    else
      local data = DataModel.makeFurList[DataModel.tabIdx]
      if data.unLockList[DataModel.nowProductIdx] == nil then
        return
      end
      formulaId = data.unLockList[DataModel.nowProductIdx].formulaId
      furUid = data.furUid
    end
    DataModel.SaveFormula(formulaId, furUid)
    local data = DataModel.makeFurList[DataModel.tabIdx]
    local cnt = DataModel.tabIdx == 1 and #data or #data.unLockList
    View.Group_Left.ScrollGrid_Item.grid.self:SetDataCount(cnt)
    View.Group_Left.ScrollGrid_Item.grid.self:RefreshAllElement()
    if DataModel.tabIdx == 1 then
      View.Group_Left.ScrollGrid_Item.grid.self:MoveToTop()
    end
    View.Group_Left.Group_Bottum:SetActive(0 < cnt)
  end,
  RapidMaking_ScrollGrid__SetGrid = function(element, elementIndex)
    local name = ""
    local icon = ""
    if elementIndex == 1 then
      name = GetText(80609118)
      icon = "UI/Home_MachiningLathe/RapidMaking/Pic/RapidUI/Right/CollectIcon"
    else
      local data = DataModel.makeFurList[elementIndex]
      local id = PlayerData:GetFurniture()[data.furUid].id
      local cfg = PlayerData:GetFactoryData(id)
      name = cfg.name
      icon = data.icon
    end
    element.Btn_.Img_Unchoose.Group_.Txt_:SetText(name)
    element.Btn_.Img_Choose.Group_.Txt_:SetText(name)
    element.Btn_:SetClickParam(elementIndex)
    element.Btn_.Img_Choose:SetActive(elementIndex == DataModel.tabIdx)
    element.Btn_.Img_Unchoose:SetActive(elementIndex ~= DataModel.tabIdx)
    element.Btn_.Img_Choose.Group_.Img_:SetSprite(icon)
    element.Btn_.Img_Unchoose.Group_.Img_:SetSprite(icon)
  end,
  RapidMaking_ScrollGrid__Group_Item_Btn__Click = function(btn, str)
    DataModel.tabIdx = tonumber(str)
    DataModel.GetUnLockFormulas(DataModel.tabIdx)
    local data = DataModel.makeFurList[DataModel.tabIdx]
    local cnt = DataModel.tabIdx == 1 and #DataModel.makeFurList[1] or #data.unLockList
    DataModel.nowProductIdx = 1
    View.Group_Left.ScrollGrid_Item.grid.self:SetDataCount(cnt)
    View.Group_Left.ScrollGrid_Item.grid.self:RefreshAllElement()
    View.Group_Left.ScrollGrid_Item.grid.self:MoveToTop()
    View.Group_Left.Group_Bottum:SetActive(0 < cnt)
    View.ScrollGrid_.grid.self:RefreshAllElement()
  end
}
return ViewFunction
