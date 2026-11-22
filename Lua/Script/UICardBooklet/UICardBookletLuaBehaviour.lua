local View = require("UICardBooklet/UICardBookletView")
local DataModel = require("UICardBooklet/UICardBookletDataModel")
local ViewFunction = require("UICardBooklet/UICardBookletViewFunction")
local customSV = require("Common/CustomSV")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.Init(View.Group_Booklet.ScrollGrid_Booklet.grid.self)
    View.Group_Booklet.ScrollGrid_Booklet.grid.self:SetDataCount(DataModel.cardPackCount)
    View.Group_Booklet.ScrollGrid_Booklet.grid.self:RefreshAllElement()
    View.Group_BottomRight.Group_BookletFormat.Img_RedPoint:SetActive(DataModel.redInfo.count > 0)
    View.Group_BottomRight.Group_ListFormat.Img_RedPoint:SetActive(DataModel.redInfo.count > 0)
    View.Group_Booklet:SetActive(true)
    View.Group_BottomRight.Group_BookletFormat.Group_On:SetActive(true)
    View.Group_BottomRight.Group_ListFormat.Group_On:SetActive(false)
    View.CustomScrollGrid_List.self:SetActive(false)
    View.Group_BottomLeft.Group_Num.Txt_CollectedNum:SetText(DataModel.cardOwnCnt)
    View.Group_BottomLeft.Group_Num.Txt_AllNum:SetText(DataModel.cardAllCnt)
    DataModel.contentMaxPosX = (DataModel.itemSpacex + DataModel.itemWidth) * (DataModel.cardPackCount - 3)
    local width = View.Group_Booklet.ScrollGrid_Booklet.self.Rect.sizeDelta.x
    View.Group_Booklet.ScrollGrid_Booklet.grid.self.GridTransform.sizeDelta = Vector2(DataModel.contentMaxPosX + width, 0)
    DataModel.contentMaxPosX = View.Group_Booklet.ScrollGrid_Booklet.grid.self.GridTransform.sizeDelta.x - width
    local nowPosX = DataModel.itemSpacex + DataModel.itemWidth
    nowPosX = MathEx.Clamp(nowPosX, 0, DataModel.contentMaxPosX)
    local transform = View.Group_Booklet.ScrollGrid_Booklet.grid.self.GridTransform
    transform.localPosition = Vector3(-nowPosX, transform.localPosition.y, 0)
    View.Group_Booklet.ScrollGrid_Booklet.grid.self:HandleScrollEvent(Vector2(0, 0))
    View.CustomScrollGrid_List.self:SetLuaGrid(ViewFunction.CardBooklet_CustomScrollGrid_List_SetGrid)
  end,
  awake = function()
    View.myCustomSV = customSV.New(View.CustomScrollGrid_List.grid, true, function(element, index)
      local data = DataModel.cardDataList[index]
      element.Group_Title:SetActive(data.ShowTitle)
      DataModel.nowIndx = index
      element.StaticGrid_Card.grid.self:RefreshAllElement(#data.list)
      local cardPackId = data.cardPackId
      local cfg = PlayerData:GetFactoryData(cardPackId)
      element.Group_Title.Img_Rectangle:SetSprite(cfg.rectangle)
      element.Group_Title.Txt_SeriesName:SetText(cfg.seriesName)
    end)
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
    local transform = View.Group_Booklet.ScrollGrid_Booklet.grid.self.GridTransform
    DOTweenTools.Kill(transform)
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
