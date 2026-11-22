local View = require("UIHelpBook/UIHelpBookView")
local DataModel = {}
DataModel.pageDistance = 2014
DataModel.curPage = 1
DataModel.totalPage = 7
DataModel.leftItem = nil
DataModel.middleItem = nil
DataModel.rightItem = nil
DataModel.curSelectMenu = 1
DataModel.selectMenuItems = {}
DataModel.selectMoving = false

function DataModel.InitData()
  local CA = PlayerData:GetFactoryData(80303719, "ListFactory")
  DataModel.curPage = 1
  DataModel.totalPage = #CA.helpbookList
  DataModel.curSelectMenu = 1
end

function DataModel.RefreshOnShow()
  DataModel.selectMenuItems = {}
  DataModel.selectMoving = false
  View.Group_.Group_Item1:SetAnchoredPositionX(-DataModel.pageDistance)
  DataModel.RefreshPage(View.Group_.Group_Item1, DataModel.curPage - 1)
  DataModel.leftItem = View.Group_.Group_Item1
  View.Group_.Group_Item2:SetAnchoredPositionX(0)
  DataModel.RefreshPage(View.Group_.Group_Item2, DataModel.curPage)
  DataModel.middleItem = View.Group_.Group_Item2
  View.Group_.Group_Item3:SetAnchoredPositionX(DataModel.pageDistance)
  DataModel.RefreshPage(View.Group_.Group_Item3, DataModel.curPage + 1)
  DataModel.rightItem = View.Group_.Group_Item3
  View.Group_:SetAnchoredPositionX(0)
  View.StaticGrid_Select.grid.self:SetDataCount(DataModel.totalPage)
  View.StaticGrid_Select.grid.self:RefreshAllElement()
  if DataModel.dragEndBackCoroutine then
    View.self:StopC(DataModel.dragEndBackCoroutine)
    DataModel.dragEndBackCoroutine = nil
  end
  if DataModel.selectCoroutine then
    View.self:StopC(DataModel.selectCoroutine)
    DataModel.selectCoroutine = nil
  end
end

function DataModel.RefreshPage(item, pageIndex)
  local CA = PlayerData:GetFactoryData(80303719, "ListFactory")
  if pageIndex > DataModel.totalPage then
    pageIndex = 1
  end
  if pageIndex < 1 then
    pageIndex = DataModel.totalPage
  end
  local cfg = CA.helpbookList[pageIndex]
  if cfg then
    item.Img_Cover:SetSprite(cfg.imgPath)
  end
end

return DataModel
