local DataModel = require("UIItem_Illustration/UIItem_IllustrationDataModel")
local View = require("UIItem_Illustration/UIItem_IllustrationView")
local BookListController = require("UIBookList/UIBookListController")
local Controller = {
  curItemList = {},
  curSelectItemIndex = 1
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
  Controller.RefreshItemGridShow()
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

function Controller.RefreshItemGridShow()
  Controller.curItemList = {}
  local itemList = DataModel.GetItemListByTabIndex() or {}
  Controller.curItemList = itemList
  View.ScrollGrid_List.grid.self:SetDataCount(#itemList)
  View.ScrollGrid_List.grid.self:MoveToTop()
  View.ScrollGrid_List.grid.self:RefreshAllElement()
  Controller.OnItemClick(1)
end

function Controller.RefreshItemElement(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  if not Controller.curItemList then
    return
  end
  local info = Controller.curItemList[elementIndex]
  if not info then
    return
  end
  local itemInfo = PlayerData:GetFactoryData(info.id, "ItemFactory")
  if not itemInfo then
    return
  end
  element.Btn_Item.Img_Bg:SetSprite(DataModel.qualityBg[itemInfo.quality])
  element.Btn_Item.Txt_Name:SetText(itemInfo.name)
  element.Btn_Item.Img_Item:SetSprite(itemInfo.iconPath)
  element.Btn_Item.Img_New:SetActive(DataModel.GetBookItemIsNew(info.id))
  element.Btn_Item:SetClickFunction(function()
    Controller.OnItemClick(elementIndex)
  end)
  if Controller.curSelectItemIndex == elementIndex then
    element.Btn_Item.Img_Active:SetActive(true)
  else
    element.Btn_Item.Img_Active:SetActive(false)
  end
  local isUnlock = DataModel.GetItemIsUnlock(info.id)
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

function Controller.OnItemClick(elementIndex)
  if not elementIndex then
    return
  end
  if not Controller.curItemList then
    return
  end
  local info = Controller.curItemList[elementIndex]
  if not info then
    return
  end
  
  local function refresh()
    Controller.curSelectItemIndex = elementIndex
    View.ScrollGrid_List.grid.self:RefreshAllElement()
    Controller.RefreshItemDetailShow()
  end
  
  local isNew = DataModel.GetBookItemIsNew(info.id)
  if isNew then
    Net:SendProto("main.read", function(json)
      if string.nilorempty(json.rc) then
        DataModel.SetBookItemIsNotNew(tostring(info.id))
      end
      refresh()
    end, tostring(info.id), "inside_item")
  else
    refresh()
  end
end

function Controller.RefreshItemDetailShow()
  if not Controller.curItemList then
    return
  end
  local info = Controller.curItemList[Controller.curSelectItemIndex]
  if not info then
    return
  end
  local itemInfo = PlayerData:GetFactoryData(info.id, "ItemFactory")
  if not itemInfo then
    return
  end
  View.Group_Details.Img_Bg:SetSprite(DataModel.qualityDetailBg[itemInfo.quality])
  View.Group_Details.Img_Bg.Img_Bg:SetSprite(DataModel.qualityDetailBg[itemInfo.quality])
  View.Group_Details.Img_Bg.Img_Lock:SetSprite(DataModel.qualityDetailBg[itemInfo.quality])
  View.Group_Details.Img_Icon:SetSprite(itemInfo.iconPath)
  View.Group_Details.Txt_Name:SetText(itemInfo.name)
  View.Group_Details.ScrollView_DefaultDes.Viewport.Content.Txt_Des:SetText(itemInfo.des)
  local isUnlock = DataModel.GetItemIsUnlock(info.id)
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

function Controller.RefreshCollectProgress()
  local unlockNum = 0
  local allNum = 0
  if Controller.curItemList then
    allNum = #Controller.curItemList
    for i = 1, #Controller.curItemList do
      local isUnlock = DataModel.GetItemIsUnlock(Controller.curItemList[i].id)
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

function Controller.OnItemRewardClick(index)
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
      local allList = DataModel.GetAllItemList() or {}
      for i = 1, #allList do
        local isUnlock = DataModel.GetItemIsUnlock(allList[i].id)
        if isUnlock then
          DataModel.SetBookItemIsNotNew(allList[i].id)
        end
      end
      BookListController.Init()
    end
    UIManager:ClosePanel()
  end, "0", "inside_item", function()
    UIManager:ClosePanel()
  end)
end

return Controller
