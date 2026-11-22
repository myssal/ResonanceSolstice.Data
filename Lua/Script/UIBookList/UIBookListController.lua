local DataModel = require("UIBookList/UIBookListDataModel")
local View = require("UIBookList/UIBookListView")
local BuffDataModel = require("UIBuff_Illustration/UIBuff_IllustrationDataModel")
local EventDataModel = require("UIEvent/UIEventDataModel")
local EquipDataModel = require("UIEquipment_Illustration/UIEquipment_IllustrationDataModel")
local ItemDataModel = require("UIItem_Illustration/UIItem_IllustrationDataModel")
local TeamDataModel = require("UITeam_Illustration/UITeam_IllustrationDataModel")
local Controller = {}

function Controller.Init()
  Net:SendProto("cube.books", function(json)
    if string.nilorempty(json.rc) then
      DataModel.UpdateBookServerInfo(json.cube_books)
    end
    Controller.RefreshContentShow()
  end, function()
    Controller.RefreshContentShow()
  end)
  View.Img_Title:SetSprite(PlayerData:GetFactoryData(88300218).filePath)
end

function Controller.RefreshContentShow()
  local cubeConfig = DataModel.GetCubeRogueConfig()
  if not cubeConfig then
    return
  end
  local bookTypeList = cubeConfig.bookTypeList
  if not bookTypeList or #bookTypeList == 0 then
    return
  end
  View.StaticGrid_List.grid.self:SetDataCount(#bookTypeList)
  View.StaticGrid_List.grid.self:RefreshAllElement()
end

function Controller.RefreshContentElement(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  local typeInfo = DataModel.GetCubeBookTypeConfig(elementIndex)
  if not typeInfo then
    return
  end
  element.Txt_Name:SetText(typeInfo.name)
  element.Img_Cover:SetSprite(typeInfo.cover)
  element.Btn_:SetClickParam(elementIndex)
  local isHasNew = false
  local isHasRed = false
  local unlockCount = 0
  local allCount = 0
  local isGotAll
  if typeInfo.id == DataModel.BookIds.buff then
    isHasNew = BuffDataModel.GetBookIsHasNewItem()
    isHasRed = BuffDataModel.GetProgressRewardRedState()
    unlockCount = BuffDataModel.GetAllUnlockCount()
    allCount = BuffDataModel.GetAllCount()
    isGotAll = BuffDataModel.GetIsAllStageRewardGot()
  elseif typeInfo.id == DataModel.BookIds.equip then
    isHasNew = EquipDataModel.GetBookIsHasNewItem()
    isHasRed = EquipDataModel.GetProgressRewardRedState()
    unlockCount = EquipDataModel.GetAllUnlockCount()
    allCount = EquipDataModel.GetAllCount()
    isGotAll = EquipDataModel.GetIsAllStageRewardGot()
  elseif typeInfo.id == DataModel.BookIds.event then
    isHasNew = EventDataModel.GetBookIsHasNewItem()
    isHasRed = EventDataModel.GetProgressRewardRedState()
    unlockCount = EventDataModel.GetAllUnlockCount()
    allCount = EventDataModel.GetAllCount()
    isGotAll = EventDataModel.GetIsAllStageRewardGot()
  elseif typeInfo.id == DataModel.BookIds.item then
    isHasNew = ItemDataModel.GetBookIsHasNewItem()
    isHasRed = ItemDataModel.GetProgressRewardRedState()
    unlockCount = ItemDataModel.GetAllUnlockCount()
    allCount = ItemDataModel.GetAllCount()
    isGotAll = ItemDataModel.GetIsAllStageRewardGot()
  elseif typeInfo.id == DataModel.BookIds.team then
    isHasNew = false
    isHasRed = false
    unlockCount = TeamDataModel.GetAllCount()
    allCount = TeamDataModel.GetAllCount()
    isGotAll = TeamDataModel.GetIsAllStageRewardGot()
  end
  if isHasRed then
    element.Img_New:SetActive(false)
    element.Group_RedPoint:SetActive(true)
  else
    element.Img_New:SetActive(isHasNew)
    element.Group_RedPoint:SetActive(false)
  end
  element.Group_Num.Txt_Now:SetText(tostring(unlockCount))
  element.Group_Num.Txt_Max:SetText(tostring(allCount))
  element.Group_AllClaimed:SetActive(isGotAll)
end

function Controller.OnItemClick(elementIndex)
  if not elementIndex then
    return
  end
  local typeInfo = DataModel.GetCubeBookTypeConfig(elementIndex)
  if not typeInfo then
    return
  end
  if string.nilorempty(typeInfo.showUI) then
    return
  end
  UIManager:Open(typeInfo.showUI, Json.encode({
    bookId = typeInfo.id,
    bookName = typeInfo.name
  }))
end

return Controller
