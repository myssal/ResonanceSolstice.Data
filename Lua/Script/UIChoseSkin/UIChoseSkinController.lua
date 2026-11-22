local View = require("UIChoseSkin/UIChoseSkinView")
local DataModel = require("UIChoseSkin/UIChoseSkinDataModel")
local Controller = {}

function Controller:Init()
  DataModel.ChooseIndex = nil
  View.Group_SkinCho.ScrollGrid_List.grid.self:SetActive(false)
  DataModel:InitSkinList()
  local itemData = DataModel.ItemData
  if itemData.chosekind == DataModel.EnumSkinType.RoleSkin then
    View.Group_SkinTitle.Txt_1:SetText(GetText(80607947))
  elseif itemData.chosekind == DataModel.EnumSkinType.CarSkin then
    View.Group_SkinTitle.Txt_1:SetText(GetText(80610428))
  end
  if DataModel.SkinList ~= nil and table.count(DataModel.SkinList) ~= 0 then
    View.Group_SkinCho.ScrollGrid_List.grid.self:SetActive(true)
    View.Group_SkinCho.ScrollGrid_List.grid.self:SetDataCount(table.count(DataModel.SkinList))
    View.Group_SkinCho.ScrollGrid_List.grid.self:RefreshAllElement()
    View.Group_SkinCho.ScrollGrid_List.grid.self:MoveToTop()
    Controller:ClickSkin(1)
  end
  View.Btn_Cancel:SetActive(DataModel.showSelectDetail == 0)
  View.Btn_Sale:SetActive(DataModel.showSelectDetail == 0)
end

function Controller:SetElement(element, elementIndex)
  local row = DataModel.SkinList[tonumber(elementIndex)]
  local ca = PlayerData:GetFactoryData(row.skin)
  local itemType = DataModel.ItemData.chosekind
  if itemType == DataModel.EnumSkinType.RoleSkin then
    element.Txt_Name:SetText(ca.SkinName)
  elseif itemType == DataModel.EnumSkinType.CarSkin then
    element.Txt_Name:SetText(ca.name)
  end
  element.Img_Role:SetSprite(row.skinrole)
  element.Img_cho:SetActive(elementIndex == DataModel.ChooseIndex)
  element.Btn_:SetClickParam(elementIndex)
  element.Img_Have:SetActive(row.isHave)
end

function Controller:ClickSkin(index)
  if index and index == DataModel.ChooseIndex then
    return
  end
  if DataModel.ChooseIndex then
    local element = View.Group_SkinCho.ScrollGrid_List.grid.self:GetElementByIndex(DataModel.ChooseIndex - 1)
    if element then
      element.Img_cho:SetActive(false)
    end
  end
  DataModel.ChooseIndex = index
  local element = View.Group_SkinCho.ScrollGrid_List.grid.self:GetElementByIndex(DataModel.ChooseIndex - 1)
  element.Img_cho:SetActive(true)
  DataModel.CurrentData = DataModel.SkinList[DataModel.ChooseIndex]
  View.Group_Show.Img_Gift:SetSprite(DataModel.CurrentData.skinshow)
  View.Group_Show.Img_jianbian:SetActive(DataModel.CurrentData.isHave)
end

return Controller
