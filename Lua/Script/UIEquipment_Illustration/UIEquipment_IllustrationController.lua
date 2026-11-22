local DataModel = require("UIEquipment_Illustration/UIEquipment_IllustrationDataModel")
local View = require("UIEquipment_Illustration/UIEquipment_IllustrationView")
local BookListController = require("UIBookList/UIBookListController")
local Controller = {
  isFilterOn = false,
  curEquipList = {},
  curSelectEquipIndex = 1
}

function Controller.Init()
  Controller.OnTabBtnClick(1)
  Controller.RefreshRewardProgress()
  View.Group_Title.Txt_Name:SetText(DataModel.GetBookName())
  EventMgr:AddEvent("event_cube_rogue_collection_close", Controller.RefreshProgressRewardRedState)
end

function Controller.Release()
  EventMgr:RemoveEvent("event_cube_rogue_collection_close", Controller.RefreshProgressRewardRedState)
end

function Controller.OnTabBtnClick(index)
  DataModel.curTabIndex = index
  Controller.RefreshTabBtnShow()
  Controller.RefreshEquipGridShow()
  Controller.RefreshCollectProgress()
end

function Controller.RefreshTabBtnShow()
  View.Group_Filter.Btn_All.Group_Active:SetActive(DataModel.curTabIndex == 1)
  View.Group_Filter.Btn_All.Group_Negative:SetActive(DataModel.curTabIndex ~= 1)
  View.Group_Filter.Btn_Unlock.Group_Active:SetActive(DataModel.curTabIndex == 2)
  View.Group_Filter.Btn_Unlock.Group_Negative:SetActive(DataModel.curTabIndex ~= 2)
  View.Group_Filter.Btn_Lock.Group_Active:SetActive(DataModel.curTabIndex == 3)
  View.Group_Filter.Btn_Lock.Group_Negative:SetActive(DataModel.curTabIndex ~= 3)
end

function Controller.RefreshEquipGridShow()
  Controller.curEquipList = {}
  local equipList = DataModel.GetEquipListByTabIndex() or {}
  Controller.curEquipList = equipList
  View.ScrollGrid_List.grid.self:SetDataCount(#equipList)
  View.ScrollGrid_List.grid.self:MoveToTop()
  View.ScrollGrid_List.grid.self:RefreshAllElement()
  Controller.OnEquipItemClick(1)
end

function Controller.RefreshEquipElement(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  if not Controller.curEquipList then
    return
  end
  local info = Controller.curEquipList[elementIndex]
  if not info then
    return
  end
  local equipInfo = PlayerData:GetFactoryData(info.id, "RogueEquipmentFactory")
  if not equipInfo then
    return
  end
  element.Btn_Item.Img_Bg:SetSprite(equipInfo.isNegative and DataModel.qualityBg.isNegative or DataModel.qualityBg[equipInfo.quality])
  element.Btn_Item.Txt_Name:SetText(equipInfo.name)
  element.Btn_Item.Img_Item:SetSprite(equipInfo.iconPath)
  element.Btn_Item.Img_New:SetActive(DataModel.GetBookItemIsNew(info.id))
  element.Btn_Item:SetClickFunction(function()
    Controller.OnEquipItemClick(elementIndex)
  end)
  if Controller.curSelectEquipIndex == elementIndex then
    element.Btn_Item.Img_Active:SetActive(true)
  else
    element.Btn_Item.Img_Active:SetActive(false)
  end
  local isUnlock = DataModel.GetEquipIsUnlock(info.id)
  if isUnlock then
    element.Btn_Item.Group_Locked:SetActive(false)
    element.Btn_Item.Txt_Name:SetActive(true)
    element.Btn_Item.Img_Item:SetMaterial(nil)
  else
    element.Btn_Item.Group_Locked:SetActive(true)
    element.Btn_Item.Txt_Name:SetActive(false)
    element.Btn_Item.Img_Item:SetMaterial("Shader/UI/UI-ImageGray")
  end
end

function Controller.OnEquipItemClick(elementIndex)
  if not elementIndex then
    return
  end
  if not Controller.curEquipList then
    return
  end
  local info = Controller.curEquipList[elementIndex]
  if not info then
    return
  end
  
  local function refresh()
    Controller.curSelectEquipIndex = elementIndex
    View.ScrollGrid_List.grid.self:RefreshAllElement()
    Controller.RefreshEquipDetailShow()
  end
  
  local isNew = DataModel.GetBookItemIsNew(info.id)
  if isNew then
    Net:SendProto("main.read", function(json)
      if string.nilorempty(json.rc) then
        DataModel.SetBookItemIsNotNew(tostring(info.id))
      end
      refresh()
    end, tostring(info.id), "rg_equip")
  else
    refresh()
  end
end

function Controller.RefreshEquipDetailShow()
  if not Controller.curEquipList then
    return
  end
  local info = Controller.curEquipList[Controller.curSelectEquipIndex]
  if not info then
    return
  end
  local equipInfo = PlayerData:GetFactoryData(info.id, "RogueEquipmentFactory")
  if not equipInfo then
    return
  end
  View.Group_Details.Img_Bg:SetSprite(equipInfo.isNegative and DataModel.qualityDetailBg.isNegative or DataModel.qualityDetailBg[equipInfo.quality])
  View.Group_Details.Img_Bg.Img_Bg:SetSprite(equipInfo.isNegative and DataModel.qualityDetailBg.isNegative or DataModel.qualityDetailBg[equipInfo.quality])
  View.Group_Details.Img_Bg.Img_Lock:SetSprite(equipInfo.isNegative and DataModel.qualityDetailBg.isNegative or DataModel.qualityDetailBg[equipInfo.quality])
  View.Group_Details.Img_Icon:SetSprite(equipInfo.iconPath)
  View.Group_Details.Txt_Name:SetText(equipInfo.name)
  View.Group_Details.ScrollView_DefaultDes.Viewport.Content.Txt_Des:SetText(equipInfo.des)
  local isUnlock = DataModel.GetEquipIsUnlock(info.id)
  if isUnlock then
    View.Group_Details.Txt_Name:SetActive(true)
    View.Group_Details.ScrollView_DefaultDes:SetActive(true)
    View.Group_Details.Img_Bg.Img_Lock:SetActive(false)
    View.Group_Details.Img_Lock:SetActive(false)
    View.Group_Details.Img_Icon:SetMaterial(nil)
    View.Group_Details.Group_Lock:SetActive(false)
  else
    View.Group_Details.Txt_Name:SetActive(false)
    View.Group_Details.ScrollView_DefaultDes:SetActive(false)
    View.Group_Details.Img_Bg.Img_Lock:SetActive(true)
    View.Group_Details.Group_Lock:SetActive(true)
    View.Group_Details.Img_Lock:SetActive(true)
    View.Group_Details.Img_Icon:SetMaterial("Shader/UI/UI-ImageGray")
  end
end

function Controller.OnFilterBtnClick()
  if Controller.isFilterOn then
    Controller.SetFilterState(false)
  else
    Controller.SetFilterState(true)
    Controller.RefreshFilterListShow()
  end
end

function Controller.SetFilterState(state)
  View.Group_Filter.Group_Quality.Btn_Off:SetActive(state)
  View.Group_Filter.Group_Quality.Group_Active:SetActive(state)
  Controller.isFilterOn = state
end

function Controller.OnCloseFilterBtnClick()
  Controller.SetFilterState(false)
end

function Controller.OnQualitySelectClick(index)
  DataModel.curSelectQuaIndex = index
  Controller.SetFilterState(false)
  Controller.RefreshFilterTitleShow()
  Controller.RefreshEquipGridShow()
  Controller.RefreshCollectProgress()
end

function Controller.RefreshFilterTitleShow()
  if not DataModel.curSelectQuaIndex then
    return
  end
  View.Group_Filter.Group_Quality.Txt_Selected:SetText(GetText(DataModel.qualityTxt[DataModel.curSelectQuaIndex]))
end

function Controller.RefreshFilterListShow()
  Controller.SetFilterListElement(View.Group_Filter.Group_Quality.Group_Active.Btn_All, 0)
  Controller.SetFilterListElement(View.Group_Filter.Group_Quality.Group_Active.Btn_Blue, 1)
  Controller.SetFilterListElement(View.Group_Filter.Group_Quality.Group_Active.Btn_Purple, 2)
  Controller.SetFilterListElement(View.Group_Filter.Group_Quality.Group_Active.Btn_Golden, 3)
  Controller.SetFilterListElement(View.Group_Filter.Group_Quality.Group_Active.Btn_Orange, 4)
  Controller.SetFilterListElement(View.Group_Filter.Group_Quality.Group_Active.Btn_Debuff, 5)
end

function Controller.SetFilterListElement(btn, index)
  if not btn or not index then
    return
  end
  btn.Img_Selected:SetActive(DataModel.curSelectQuaIndex == index)
  btn.Txt_Quality:SetColor(DataModel.curSelectQuaIndex == index and "#FFFFFF" or "#ADADAD")
  btn.Txt_Quality:SetTxtFontSize(DataModel.curSelectQuaIndex == index and 32 or 28)
end

function Controller.RefreshCollectProgress()
  local unlockNum = 0
  local allNum = 0
  if Controller.curEquipList then
    allNum = #Controller.curEquipList
    for i = 1, #Controller.curEquipList do
      local isUnlock = DataModel.GetEquipIsUnlock(Controller.curEquipList[i].id)
      if isUnlock then
        unlockNum = unlockNum + 1
      end
    end
  end
  View.Group_Progress.Group_Txt.Txt_0:SetText(DataModel.GetBookTypeName())
  View.Group_Progress.Group_Txt.Txt_CurrentNum:SetText(tostring(unlockNum))
  View.Group_Progress.Group_Txt.Txt_AllNum:SetText(tostring(allNum))
end

function Controller.RefreshRewardProgress()
  local stageList = DataModel.GetStageList() or {}
  local nowNum = DataModel.GetFinishedProgressNum() or 0
  View.Btn_Rewards.Group_Num.Txt_Now:SetText(tostring(nowNum))
  View.Btn_Rewards.Group_Num.Txt_Max:SetText(tostring(#stageList))
  Controller.RefreshProgressRewardRedState(DataModel.bookId)
end

function Controller.RefreshProgressRewardRedState(bookId)
  if bookId ~= DataModel.bookId then
    return
  end
  View.Btn_Rewards.Group_RedPoint:SetActive(DataModel.GetProgressRewardRedState())
end

function Controller.OnEquipRewardClick(index)
  UIManager:Open("UI/CubeRogue/Book/CollectionReward/CollectionReward", Json.encode({
    bookId = DataModel.bookId
  }))
end

function Controller.Close()
  local isHasNew = DataModel.GetBookIsHasNewItem()
  if not isHasNew then
    BookListController.Init()
    UIManager:ClosePanel()
    return
  end
  Net:SendProto("main.read", function(json)
    if string.nilorempty(json.rc) then
      local allList = DataModel.GetAllEquipList() or {}
      for i = 1, #allList do
        local isUnlock = DataModel.GetEquipIsUnlock(allList[i].id)
        if isUnlock then
          DataModel.SetBookItemIsNotNew(allList[i].id)
        end
      end
      BookListController.Init()
    end
    UIManager:ClosePanel()
  end, "0", "rg_equip", function()
    UIManager:ClosePanel()
  end)
end

return Controller
