local DataModel = require("UIEvent/UIEventDataModel")
local View = require("UIEvent/UIEventView")
local BookListController = require("UIBookList/UIBookListController")
local Controller = {curEventList = nil, curSelectEventIndex = 1}

function Controller.Init()
  Controller.OnTabClick(1)
  Controller.RefreshRewardProgress()
  View.Group_Title.Txt_Name:SetText(DataModel.GetBookName())
  EventMgr:AddEvent("event_cube_rogue_collection_close", Controller.RefreshProgressRewardRedState)
end

function Controller.Release()
  EventMgr:RemoveEvent("event_cube_rogue_collection_close", Controller.RefreshProgressRewardRedState)
end

function Controller.OnTabClick(index)
  DataModel.curTabIndex = index
  Controller.curEventList = {}
  Controller.RefreshTabBtnShow()
  local eventList = DataModel.GetEventListByTabIndex()
  if not eventList then
    return
  end
  Controller.curEventList = eventList
  View.ScrollGrid_EventList.grid.self:SetDataCount(#eventList)
  View.ScrollGrid_EventList.grid.self:MoveToTop()
  View.ScrollGrid_EventList.grid.self:RefreshAllElement()
  Controller.OnEventClick(1)
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

function Controller.RefreshEventElement(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  if not Controller.curEventList then
    return
  end
  local info = Controller.curEventList[elementIndex]
  if not info then
    return
  end
  local eventInfo = PlayerData:GetFactoryData(info.id, "RogueEventFactory")
  if not eventInfo then
    return
  end
  element.Btn_Event.Img_New:SetActive(DataModel.GetBookItemIsNew(info.id))
  local isUnlock = DataModel.GetEventIsUnlock(info.id)
  if isUnlock then
    element.Btn_Event.Group_Unlocked:SetActive(true)
    element.Btn_Event.Group_Locked:SetActive(false)
    element.Btn_Event.Group_Unlocked.Group_Negative.Txt_EventName:SetText(eventInfo.name)
    element.Btn_Event.Group_Unlocked.Group_Active.Txt_EventName:SetText(eventInfo.name)
  else
    element.Btn_Event.Group_Unlocked:SetActive(false)
    element.Btn_Event.Group_Locked:SetActive(true)
  end
  element.Btn_Event:SetClickFunction(function()
    Controller.OnEventClick(elementIndex)
  end)
  if Controller.curSelectEventIndex == elementIndex then
    if isUnlock then
      element.Btn_Event.Group_Unlocked.Group_Active:SetActive(true)
      element.Btn_Event.Group_Unlocked.Group_Negative:SetActive(false)
      element.Btn_Event.Group_Locked.Group_Active:SetActive(false)
    else
      element.Btn_Event.Group_Unlocked.Group_Active:SetActive(false)
      element.Btn_Event.Group_Locked.Group_Active:SetActive(true)
      element.Btn_Event.Group_Locked.Group_Negative:SetActive(false)
    end
  else
    element.Btn_Event.Group_Unlocked.Group_Active:SetActive(false)
    element.Btn_Event.Group_Locked.Group_Active:SetActive(false)
    if isUnlock then
      element.Btn_Event.Group_Unlocked.Group_Negative:SetActive(true)
    else
      element.Btn_Event.Group_Locked.Group_Negative:SetActive(true)
    end
  end
end

function Controller.OnEventClick(elementIndex)
  if not elementIndex then
    return
  end
  if not Controller.curEventList then
    return
  end
  local info = Controller.curEventList[elementIndex]
  if not info then
    return
  end
  
  local function refresh()
    Controller.curSelectEventIndex = elementIndex
    View.ScrollGrid_EventList.grid.self:RefreshAllElement()
    Controller.RefreshEventDetailShow()
  end
  
  local isNew = DataModel.GetBookItemIsNew(info.id)
  if isNew then
    Net:SendProto("main.read", function(json)
      if string.nilorempty(json.rc) then
        DataModel.SetBookItemIsNotNew(tostring(info.id))
      end
      refresh()
    end, tostring(info.id), "event")
  else
    refresh()
  end
end

function Controller.RefreshEventDetailShow()
  if not Controller.curEventList then
    return
  end
  local info = Controller.curEventList[Controller.curSelectEventIndex]
  if not info then
    return
  end
  local eventInfo = PlayerData:GetFactoryData(info.id, "RogueEventFactory")
  if not eventInfo then
    return
  end
  View.Group_Info.Txt_EventName:SetText(eventInfo.name)
  View.Group_Info.ScrollView_Des.Viewport.Content.Txt_Des:SetText(eventInfo.bookDes)
  local isUnlock = DataModel.GetEventIsUnlock(info.id)
  local bgPath = eventInfo.bgPath
  local npcId = eventInfo.npcId
  local isHasNpc = npcId ~= nil and npcId ~= 0 and npcId ~= -1
  if isHasNpc then
    local npcInfo = PlayerData:GetFactoryData(npcId, "NPCFactory")
    if npcInfo then
      View.Group_Bg.Group_Character.Spine_Character:SetData(npcInfo.spineUrl)
      View.Group_Bg.Group_Character.Spine_Character:SetAnchoredPosition(Vector2(npcInfo.spineOffsetX, npcInfo.spineOffsetY))
      View.Group_Bg.Group_Character.Spine_Character:SetLocalScale(npcInfo.spineScale, npcInfo.spineScale, npcInfo.spineScale)
    end
  else
    View.Group_Bg.Img_BG:SetSprite(bgPath)
  end
  if isUnlock then
    View.Group_Info:SetActive(true)
    View.Group_Bg.Group_Locked:SetActive(false)
    if isHasNpc then
      View.Group_Bg.Img_BG:SetActive(false)
      View.Group_Bg.Img_CharacterBG:SetActive(true)
      View.Group_Bg.Img_CharacterBG:SetMaterial(nil)
      View.Group_Bg.Group_Character:SetActive(true)
    else
      View.Group_Bg.Img_BG:SetActive(true)
      View.Group_Bg.Img_BG:SetMaterial(nil)
      View.Group_Bg.Img_CharacterBG:SetActive(false)
      View.Group_Bg.Group_Character:SetActive(false)
    end
  else
    View.Group_Info:SetActive(false)
    View.Group_Bg.Group_Locked:SetActive(true)
    if isHasNpc then
      View.Group_Bg.Img_BG:SetActive(false)
      View.Group_Bg.Img_CharacterBG:SetActive(true)
      View.Group_Bg.Img_CharacterBG:SetMaterial("Shader/UI/UI-ImageGray")
      View.Group_Bg.Group_Character:SetActive(false)
    else
      View.Group_Bg.Img_BG:SetActive(true)
      View.Group_Bg.Img_BG:SetMaterial("Shader/UI/UI-ImageGray")
      View.Group_Bg.Img_CharacterBG:SetActive(false)
      View.Group_Bg.Group_Character:SetActive(false)
    end
  end
end

function Controller.RefreshCollectProgress()
  local unlockNum = 0
  local allNum = 0
  if Controller.curEventList then
    allNum = #Controller.curEventList
    for i = 1, #Controller.curEventList do
      local isUnlock = DataModel.GetEventIsUnlock(Controller.curEventList[i].id)
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

function Controller.OnEventRewardClick(index)
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
      local allList = DataModel.GetAllEventList() or {}
      for i = 1, #allList do
        local isUnlock = DataModel.GetEventIsUnlock(allList[i].id)
        if isUnlock then
          DataModel.SetBookItemIsNotNew(allList[i].id)
        end
      end
      BookListController.Init()
    end
    UIManager:ClosePanel()
  end, "0", "event", function()
    UIManager:ClosePanel()
  end)
end

return Controller
