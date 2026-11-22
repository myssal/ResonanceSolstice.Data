local DataModel = require("UIBuff_Illustration/UIBuff_IllustrationDataModel")
local View = require("UIBuff_Illustration/UIBuff_IllustrationView")
local BookListController = require("UIBookList/UIBookListController")
local Controller = {
  curSelectTabIndex = 1,
  curBuffList = nil,
  curSelectBuffIndex = 1
}

function Controller.Init()
  Controller.OnTabClick(1)
  Controller.RefreshTabListShow()
  Controller.RefreshRewardsShow()
  View.Group_Title.Txt_Name:SetText(DataModel.GetBookName())
  EventMgr:AddEvent("event_cube_rogue_collection_close", Controller.RefreshProgressRewardRedState)
end

function Controller.Release()
  EventMgr:RemoveEvent("event_cube_rogue_collection_close", Controller.RefreshProgressRewardRedState)
end

function Controller.RefreshTabListShow()
  local tabList = DataModel.GetTabListInfo()
  if not tabList then
    return
  end
  View.ScrollGrid_Filter.grid.self:SetDataCount(#tabList)
  View.ScrollGrid_Filter.grid.self:RefreshAllElement()
end

function Controller.RefreshTabElement(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  local tabList = DataModel.GetTabListInfo(elementIndex)
  if not tabList or not tabList[elementIndex] then
    return
  end
  local rogueTeamInfo = PlayerData:GetFactoryData(tabList[elementIndex].id, "RogueTeamFactory")
  if not rogueTeamInfo then
    return
  end
  element.Group_Negative.Img_Icon:SetSprite(rogueTeamInfo.tabIconPath)
  element.Group_Active.Img_Icon:SetSprite(rogueTeamInfo.tabIconPath)
  if Controller.curSelectTabIndex == elementIndex then
    element.Group_Active:SetActive(true)
    element.Group_Negative:SetActive(false)
  else
    element.Group_Active:SetActive(false)
    element.Group_Negative:SetActive(true)
  end
  element.Btn_:SetClickFunction(function()
    Controller.OnTabClick(elementIndex)
  end)
end

function Controller.OnTabClick(elementIndex)
  Controller.curSelectTabIndex = elementIndex
  View.ScrollGrid_Filter.grid.self:RefreshAllElement()
  Controller.curBuffList = nil
  local tabList = DataModel.GetTabListInfo(elementIndex)
  if not tabList then
    return
  end
  local tabInfo = tabList[elementIndex]
  if not tabInfo then
    return
  end
  local buffList = DataModel.GetBuffListByTab(tabInfo.id)
  if not buffList then
    return
  end
  Controller.curBuffList = buffList
  View.ScrollGrid_List.grid.self:SetDataCount(#buffList)
  View.ScrollGrid_List.grid.self:MoveToTop()
  View.ScrollGrid_List.grid.self:RefreshAllElement()
  Controller.OnBuffClick(1)
  Controller.RefreshProgress(tabInfo.id)
end

function Controller.RefreshProgress(tabId)
  if not Controller.curBuffList then
    return
  end
  local allNum = #Controller.curBuffList
  local unlockNum = 0
  for i = 1, #Controller.curBuffList do
    local isUnlock = DataModel.GetBuffIsUnlock(Controller.curBuffList[i])
    if isUnlock then
      unlockNum = unlockNum + 1
    end
  end
  local rogueTeamInfo = PlayerData:GetFactoryData(tabId, "RogueTeamFactory")
  if not rogueTeamInfo then
    return
  end
  View.Group_Progress.Group_Txt.Txt_TacticsName:SetText(rogueTeamInfo.name)
  View.Group_Progress.Group_Txt.Txt_CurrentNum:SetText(tostring(unlockNum))
  View.Group_Progress.Group_Txt.Txt_AllNum:SetText(tostring(allNum))
end

function Controller.RefreshBuffElement(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  if not Controller.curBuffList then
    return
  end
  local buffId = Controller.curBuffList[elementIndex]
  local buffInfo = PlayerData:GetFactoryData(buffId, "RogueBuffFactory")
  if not buffInfo then
    return
  end
  element.Btn_Item.Txt_Name:SetText(buffInfo.name)
  element.Btn_Item.Img_Item:SetSprite(buffInfo.iconPath)
  element.Btn_Item.Img_Bg:SetSprite(DataModel.QualityColor[buffInfo.quality])
  element.Btn_Item.Img_New:SetActive(DataModel.GetBookItemIsNew(buffId))
  if Controller.curSelectBuffIndex == elementIndex then
    element.Btn_Item.Img_Active:SetActive(true)
  else
    element.Btn_Item.Img_Active:SetActive(false)
  end
  element.Btn_Item:SetClickFunction(function()
    Controller.OnBuffClick(elementIndex)
  end)
  local isUnlock = DataModel.GetBuffIsUnlock(buffId)
  if isUnlock then
    element.Btn_Item.Group_Locked:SetActive(false)
    element.Btn_Item.Txt_Name:SetActive(true)
  else
    element.Btn_Item.Group_Locked:SetActive(true)
    element.Btn_Item.Txt_Name:SetActive(false)
  end
end

function Controller.OnBuffClick(elementIndex)
  if not elementIndex then
    return
  end
  if not Controller.curBuffList then
    return
  end
  local buffId = Controller.curBuffList[elementIndex]
  
  local function refresh()
    Controller.curSelectBuffIndex = elementIndex
    View.ScrollGrid_List.grid.self:RefreshAllElement()
    Controller.RefreshBuffDetailInfo()
  end
  
  local isNew = DataModel.GetBookItemIsNew(buffId)
  if isNew then
    Net:SendProto("main.read", function(json)
      if string.nilorempty(json.rc) then
        DataModel.SetBookItemIsNotNew(tostring(buffId))
      end
      refresh()
    end, tostring(buffId), "rg_buff")
  else
    refresh()
  end
end

function Controller.RefreshBuffDetailInfo()
  if not Controller.curSelectBuffIndex then
    return
  end
  local buffId = Controller.curBuffList[Controller.curSelectBuffIndex]
  local buffInfo = PlayerData:GetFactoryData(buffId, "RogueBuffFactory")
  if not buffInfo then
    return
  end
  View.Group_Details.ScrollView_DefaultDes.Viewport.Content.Img_2:SetActive(buffInfo.quality ~= DataModel.quality.Orange)
  View.Group_Details.Img_Bg:SetSprite(DataModel.QualityDecoColor[buffInfo.quality])
  View.Group_Details.Img_Bg.Img_Bg:SetSprite(DataModel.QualityDecoColor[buffInfo.quality])
  View.Group_Details.Img_Bg.Img_Lock:SetSprite(DataModel.QualityDecoColor[buffInfo.quality])
  local teamInfo = PlayerData:GetFactoryData(buffInfo.correspondingTeam, "RogueTeamFactory")
  if teamInfo then
    View.Group_Details.Img_TypeIcon:SetSprite(teamInfo.shadePath)
    View.Group_Details.Img_Type:SetSprite(teamInfo.tabIconPath)
  end
  View.Group_Details.Img_Icon:SetSprite(buffInfo.iconPath)
  View.Group_Details.Txt_Name:SetText(buffInfo.name)
  View.Group_Details.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetText(buffInfo.des)
  View.Group_Details.ScrollView_DefaultDes.Viewport.Content.Txt_UpdateDes:SetText(buffInfo.intensifyDes)
  local isUnlock = DataModel.GetBuffIsUnlock(buffId)
  if isUnlock then
    View.Group_Details.Txt_Name:SetActive(true)
    View.Group_Details.ScrollView_DefaultDes:SetActive(true)
    View.Group_Details.Img_Bg.Img_Lock:SetActive(false)
    View.Group_Details.Img_Lock:SetActive(false)
    View.Group_Details.Group_Lock:SetActive(false)
  else
    View.Group_Details.Txt_Name:SetActive(false)
    View.Group_Details.ScrollView_DefaultDes:SetActive(false)
    View.Group_Details.Img_Bg.Img_Lock:SetActive(true)
    View.Group_Details.Img_Lock:SetActive(true)
    View.Group_Details.Group_Lock:SetActive(true)
  end
end

function Controller.RefreshRewardsShow()
  local stageList = DataModel.GetStageRewardList() or {}
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

function Controller.OnBuffRewardClick()
  UIManager:Open("UI/CubeRogue/Book/CollectionReward/CollectionReward", Json.encode({
    bookId = DataModel.bookId
  }))
end

function Controller.ReadAllBookItems()
  local isHasNew = DataModel.GetBookIsHasNewItem()
  if not isHasNew then
    return
  end
  Net:SendProto("main.read", function(json)
    if string.nilorempty(json.rc) then
      local allList = DataModel.GetAllBuffList() or {}
      for i = 1, #allList do
        local isUnlock = DataModel.GetBuffIsUnlock(allList[i].id)
        if isUnlock then
          DataModel.SetBookItemIsNotNew(allList[i].id)
        end
      end
    end
  end, "0", "rg_buff")
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
      local allList = DataModel.GetAllBuffList() or {}
      for i = 1, #allList do
        local isUnlock = DataModel.GetBuffIsUnlock(allList[i].id)
        if isUnlock then
          DataModel.SetBookItemIsNotNew(allList[i].id)
        end
      end
      BookListController.Init()
    end
    UIManager:ClosePanel()
  end, "0", "rg_buff", function()
    UIManager:ClosePanel()
  end)
end

return Controller
