local View = require("UIHelpBook/UIHelpBookView")
local DataModel = require("UIHelpBook/UIHelpBookDataModel")
local ViewFunction = {
  HelpBook_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  HelpBook_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  HelpBook_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  HelpBook_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  HelpBook_Drag__BeginDrag = function(direction, dragPos)
    if DataModel.selectMoving or DataModel.dragMoving then
      return
    end
    DataModel.onDragLastPos = dragPos
    DataModel.rightItemPosX = DataModel.rightItem:GetAnchoredPositionX()
    DataModel.leftItemPosX = DataModel.leftItem:GetAnchoredPositionX()
    DataModel.quickDragDeltaX = 0
    DataModel.dragStartTime = os.time()
  end,
  HelpBook_Drag__EndDrag = function(direction, dragPos)
    if DataModel.selectMoving or not DataModel.onDragLastPos then
      return
    end
    if DataModel.curPage ~= DataModel.curSelectMenu then
      local oldSelectMenuItem = DataModel.selectMenuItems[DataModel.curSelectMenu]
      oldSelectMenuItem.Txt_NotSelect:SetActive(true)
      oldSelectMenuItem.Img_Select:SetActive(false)
      local newSelectMenuItem = DataModel.selectMenuItems[DataModel.curPage]
      newSelectMenuItem.Txt_NotSelect:SetActive(false)
      newSelectMenuItem.Img_Select:SetActive(true)
      DataModel.curSelectMenu = DataModel.curPage
    elseif DataModel.quickDragDeltaX ~= 0 and os.time() - DataModel.dragStartTime < 0.1 then
      local pageIndex = DataModel.quickDragDeltaX > 0 and DataModel.curPage + 1 or DataModel.curPage - 1
      if pageIndex > DataModel.totalPage then
        pageIndex = 1
      end
      if pageIndex < 1 then
        pageIndex = DataModel.totalPage
      end
      local deltaX = DataModel.quickDragDeltaX > 0 and 10 or -10
      while DataModel.curPage ~= pageIndex do
        DataModel.dragMoving = true
        DataModel.leftItem:SetAnchoredPositionX(DataModel.leftItem:GetAnchoredPositionX() - deltaX)
        DataModel.middleItem:SetAnchoredPositionX(DataModel.middleItem:GetAnchoredPositionX() - deltaX)
        DataModel.rightItem:SetAnchoredPositionX(DataModel.rightItem:GetAnchoredPositionX() - deltaX)
        if 0 < deltaX and DataModel.leftItem:GetAnchoredPositionX() - DataModel.leftItemPosX <= -DataModel.pageDistance * 0.5 then
          DataModel.leftItemPosX = DataModel.leftItem:GetAnchoredPositionX()
          DataModel.curPage = DataModel.curPage + 1
          if DataModel.curPage > DataModel.totalPage then
            DataModel.curPage = 1
          end
          DataModel.leftItem:SetAnchoredPositionX(DataModel.pageDistance + DataModel.rightItem:GetAnchoredPositionX())
          DataModel.RefreshPage(DataModel.leftItem, DataModel.curPage + 1)
          local item = DataModel.leftItem
          DataModel.leftItem = DataModel.middleItem
          DataModel.middleItem = DataModel.rightItem
          DataModel.rightItem = item
        end
        if deltaX < 0 and DataModel.rightItem:GetAnchoredPositionX() - DataModel.rightItemPosX >= DataModel.pageDistance * 0.5 then
          DataModel.rightItemPosX = DataModel.rightItem:GetAnchoredPositionX()
          DataModel.curPage = DataModel.curPage - 1
          if DataModel.curPage < 1 then
            DataModel.curPage = DataModel.totalPage
          end
          DataModel.rightItem:SetAnchoredPositionX(-DataModel.pageDistance + DataModel.leftItem:GetAnchoredPositionX())
          DataModel.RefreshPage(DataModel.rightItem, DataModel.curPage - 1)
          local item = DataModel.rightItem
          DataModel.rightItem = DataModel.middleItem
          DataModel.middleItem = DataModel.leftItem
          DataModel.leftItem = item
        end
      end
      local oldSelectMenuItem = DataModel.selectMenuItems[DataModel.curSelectMenu]
      oldSelectMenuItem.Img_Select:SetActive(false)
      oldSelectMenuItem.Txt_NotSelect:SetActive(true)
      local newSelectMenuItem = DataModel.selectMenuItems[DataModel.curPage]
      newSelectMenuItem.Img_Select:SetActive(true)
      newSelectMenuItem.Txt_NotSelect:SetActive(false)
      DataModel.curSelectMenu = DataModel.curPage
    end
    DataModel.dragEndBackCoroutine = View.self:StartC(LuaUtil.cs_generator(function()
      local leftPos = -View.Group_:GetAnchoredPositionX() - DataModel.pageDistance
      local middleIPos = -View.Group_:GetAnchoredPositionX()
      local rightPos = -View.Group_:GetAnchoredPositionX() + DataModel.pageDistance
      DOTweenTools.DOLocalMoveXCallback(DataModel.leftItem.transform, leftPos, 0.25)
      DOTweenTools.DOLocalMoveXCallback(DataModel.middleItem.transform, middleIPos, 0.25)
      DOTweenTools.DOLocalMoveXCallback(DataModel.rightItem.transform, rightPos, 0.25)
      coroutine.yield(CS.UnityEngine.WaitForSeconds(0.25))
      DataModel.dragMoving = false
    end))
    DataModel.onDragLastPos = nil
  end,
  HelpBook_Drag__OnDrag = function(direction, dragPos)
    if DataModel.selectMoving or not DataModel.onDragLastPos then
      return
    end
    DataModel.dragMoving = true
    local deltaX = DataModel.onDragLastPos.x - dragPos.x
    DataModel.quickDragDeltaX = deltaX
    DataModel.onDragLastPos = dragPos
    DataModel.leftItem:SetAnchoredPositionX(DataModel.leftItem:GetAnchoredPositionX() - deltaX)
    DataModel.middleItem:SetAnchoredPositionX(DataModel.middleItem:GetAnchoredPositionX() - deltaX)
    DataModel.rightItem:SetAnchoredPositionX(DataModel.rightItem:GetAnchoredPositionX() - deltaX)
    if 0 < deltaX and DataModel.leftItem:GetAnchoredPositionX() - DataModel.leftItemPosX <= -DataModel.pageDistance * 0.5 then
      DataModel.leftItemPosX = DataModel.leftItem:GetAnchoredPositionX()
      DataModel.curPage = DataModel.curPage + 1
      if DataModel.curPage > DataModel.totalPage then
        DataModel.curPage = 1
      end
      DataModel.leftItem:SetAnchoredPositionX(DataModel.pageDistance + DataModel.rightItem:GetAnchoredPositionX())
      DataModel.RefreshPage(DataModel.leftItem, DataModel.curPage + 1)
      local item = DataModel.leftItem
      DataModel.leftItem = DataModel.middleItem
      DataModel.middleItem = DataModel.rightItem
      DataModel.rightItem = item
    end
    if deltaX < 0 and DataModel.rightItem:GetAnchoredPositionX() - DataModel.rightItemPosX >= DataModel.pageDistance * 0.5 then
      DataModel.rightItemPosX = DataModel.rightItem:GetAnchoredPositionX()
      DataModel.curPage = DataModel.curPage - 1
      if DataModel.curPage < 1 then
        DataModel.curPage = DataModel.totalPage
      end
      DataModel.rightItem:SetAnchoredPositionX(-DataModel.pageDistance + DataModel.leftItem:GetAnchoredPositionX())
      DataModel.RefreshPage(DataModel.rightItem, DataModel.curPage - 1)
      local item = DataModel.rightItem
      DataModel.rightItem = DataModel.middleItem
      DataModel.middleItem = DataModel.leftItem
      DataModel.leftItem = item
    end
  end,
  HelpBook_StaticGrid_Select_SetGrid = function(element, elementIndex)
    element.Txt_NotSelect:SetText(elementIndex)
    element.Txt_NotSelect:SetActive(elementIndex ~= DataModel.curSelectMenu)
    element.Img_Select.Txt_:SetText(elementIndex)
    element.Img_Select:SetActive(elementIndex == DataModel.curSelectMenu)
    element.Btn_:SetClickParam(elementIndex)
    DataModel.selectMenuItems[elementIndex] = element
  end,
  HelpBook_StaticGrid_Select_Group_Select_Btn__Click = function(btn, str)
    if DataModel.curSelectMenu == tonumber(str) or DataModel.selectMoving or DataModel.dragMoving then
      return
    end
    if DataModel.selectCoroutine then
      View.self:StopC(DataModel.selectCoroutine)
      DataModel.selectCoroutine = nil
    end
    DataModel.selectMoving = true
    local leftMove = tonumber(str) > DataModel.curPage
    local deltaPageNum = math.abs(tonumber(str) - DataModel.curPage)
    local moveDistanceX = leftMove and deltaPageNum * -DataModel.pageDistance or deltaPageNum * DataModel.pageDistance
    local moveNum = 0
    local needMoveNum = deltaPageNum * 2
    local startMoveX = View.Group_:GetAnchoredPositionX()
    local lastMoveX = startMoveX
    local moveTime = 0
    local moveTotalTime = 0.25
    DataModel.selectCoroutine = View.self:StartC(LuaUtil.cs_generator(function()
      while moveNum < needMoveNum do
        if moveTime > moveTotalTime then
          moveTime = moveTotalTime
        end
        local curX = startMoveX + 2 * moveDistanceX * math.sqrt(moveTime)
        View.Group_:SetAnchoredPositionX(curX)
        local deltaMoveX = math.abs(curX - lastMoveX)
        if deltaMoveX >= DataModel.pageDistance * 0.5 then
          moveNum = moveNum + 1
          if leftMove then
            lastMoveX = startMoveX - DataModel.pageDistance * 0.5 * moveNum
          else
            lastMoveX = startMoveX + DataModel.pageDistance * 0.5 * moveNum
          end
          if moveNum % 2 ~= 0 then
            if leftMove then
              DataModel.curPage = DataModel.curPage + 1
              DataModel.leftItem:SetAnchoredPositionX(DataModel.pageDistance + DataModel.rightItem:GetAnchoredPositionX())
              DataModel.RefreshPage(DataModel.leftItem, DataModel.curPage + 1)
              local item = DataModel.leftItem
              DataModel.leftItem = DataModel.middleItem
              DataModel.middleItem = DataModel.rightItem
              DataModel.rightItem = item
            else
              DataModel.curPage = DataModel.curPage - 1
              DataModel.rightItem:SetAnchoredPositionX(-DataModel.pageDistance + DataModel.leftItem:GetAnchoredPositionX())
              DataModel.RefreshPage(DataModel.rightItem, DataModel.curPage - 1)
              local item = DataModel.rightItem
              DataModel.rightItem = DataModel.middleItem
              DataModel.middleItem = DataModel.leftItem
              DataModel.leftItem = item
            end
          end
        end
        coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
        moveTime = moveTime + Time.deltaTime
      end
      coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
      DataModel.selectMoving = false
    end))
    local oldSelectMenuItem = DataModel.selectMenuItems[DataModel.curSelectMenu]
    oldSelectMenuItem.Txt_NotSelect:SetActive(true)
    oldSelectMenuItem.Img_Select:SetActive(false)
    local newSelectMenuItem = DataModel.selectMenuItems[tonumber(str)]
    newSelectMenuItem.Txt_NotSelect:SetActive(false)
    newSelectMenuItem.Img_Select:SetActive(true)
    DataModel.curSelectMenu = tonumber(str)
  end
}
return ViewFunction
