local View = require("UICardBooklet/UICardBookletView")
local DataModel = require("UICardBooklet/UICardBookletDataModel")
local ViewFunction = {
  CardBooklet_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  CardBooklet_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  CardBooklet_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  CardBooklet_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  CardBooklet_Group_Booklet_ScrollGrid_Booklet_SetGrid = function(element, elementIndex)
    local realIdx = elementIndex - 1
    local data = DataModel.cardPackList[realIdx]
    element.Group_Booklet.Group_Series.Group_Num.Txt_CollectedNum:SetText(realIdx)
    element.Group_Booklet:SetActive(false)
    if data then
      element.Group_Booklet:SetActive(true)
      element.Group_Booklet.Btn_:SetClickParam(elementIndex)
      element.Group_Booklet.Group_Series.Group_Num.Txt_CollectedNum:SetText(data.ownCount)
      element.Group_Booklet.Group_Series.Group_Num.Txt_AllNum:SetText(data.allCount)
      local cfg = PlayerData:GetFactoryData(data.id)
      element.Group_Booklet.Group_Series.Txt_SeriesName:SetText(cfg.seriesName)
      element.Group_Booklet.Group_Series.Img_Series:SetSprite(cfg.series)
      element.Group_Booklet.Img_Cover:SetSprite(cfg.cover)
      element.Group_Booklet.Img_All:SetActive(data.ownCount == data.allCount)
      element.Group_Booklet.Img_RedPoint:SetActive(DataModel.redInfo[data.id])
    end
  end,
  CardBooklet_Group_Booklet_ScrollGrid_Booklet_Group_Item_Group_Booklet_Btn__Click = function(btn, str)
    local realIdx = tonumber(str) - 1
    local data = DataModel.cardPackList[realIdx]
    local nowPosX = (DataModel.itemSpacex + DataModel.itemWidth) * (realIdx - 1)
    nowPosX = MathEx.Clamp(nowPosX, 0, DataModel.contentMaxPosX)
    local transform = View.Group_Booklet.ScrollGrid_Booklet.grid.self.GridTransform
    DOTweenTools.Kill(transform)
    local delay = math.abs(transform.localPosition.x + nowPosX) / (DataModel.itemSpacex + DataModel.itemWidth) * 0.5
    DOTweenTools.DOLocalMoveXCallback(transform, -nowPosX, delay, nil, function()
      btn.transform.parent.gameObject:SetActive(false)
      UIManager:Open("UI/CollectionCard/CardPack_Open", Json.encode({
        cardPackId = data.id,
        isCardBooklet = true
      }), function()
        btn.transform.parent.gameObject:SetActive(true)
        if not DataModel.redInfo[data.id] then
          return
        end
        DataModel.UpdateNowPack(realIdx)
        if data.allCount == data.ownCount then
          DataModel.redInfo[data.id] = false
          DataModel.redInfo.count = DataModel.redInfo.count - 1
          View.Group_Booklet.ScrollGrid_Booklet.grid.self:RefreshAllElement()
          View.Group_BottomLeft.Group_Num.Txt_CollectedNum:SetText(DataModel.cardOwnCnt)
          View.Group_BottomRight.Group_BookletFormat.Img_RedPoint:SetActive(DataModel.redInfo.count > 0)
          View.Group_BottomRight.Group_ListFormat.Img_RedPoint:SetActive(DataModel.redInfo.count > 0)
        end
      end)
    end)
  end,
  CardBooklet_CustomScrollGrid_List_SetGrid = function(element, elementIndex)
    View.myCustomSV:SetItemShowAndHide(View.CustomScrollGrid_List.self.currentPosXOrY)
  end,
  CardBooklet_CustomScrollGrid_List_Group_Item_StaticGrid_Card_SetGrid = function(element, elementIndex)
    local cardList = DataModel.cardDataList[DataModel.nowIndx].list
    local cardId = cardList[elementIndex]
    if cardId == nil then
      element:SetActive(false)
      return
    end
    element:SetActive(true)
    local isOWn = DataModel.CardIsOwn(cardId)
    local cardCfg = PlayerData:GetFactoryData(cardId)
    element.Btn_Card:SetActive(isOWn)
    element.Btn_CardBack:SetActive(not isOWn)
    if isOWn then
      element.Btn_Card.Img_Card:SetSprite(cardCfg.iconPath)
      element.Btn_Card:SetClickParam(cardId)
    else
      local cardPackId = DataModel.cardDataList[DataModel.nowIndx].cardPackId
      local cfg = PlayerData:GetFactoryData(cardPackId)
      local cardBackBg = cfg.topCard == cardId and cfg.topCardBack or cfg.cardBack
      element.Btn_CardBack.Img_CardBack:SetSprite(cardBackBg)
      element.Btn_CardBack:SetClickParam(cardId)
      element.Btn_CardBack.Group_RedPoint:SetActive(false)
      if cfg.topCard == cardId then
        element.Btn_CardBack.Group_RedPoint:SetActive(DataModel.redInfo[cardPackId])
      end
    end
  end,
  CardBooklet_CustomScrollGrid_List_Group_Item_StaticGrid_Card_Group_Card_Btn_Card_Click = function(btn, str)
    local cardId = tonumber(str)
    UIManager:Open("UI/CollectionCard/CollectionCard_Tips", Json.encode({cardId = cardId}))
  end,
  CardBooklet_CustomScrollGrid_List_Group_Item_StaticGrid_Card_Group_Card_Btn_CardBack_Click = function(btn, str)
    local cardId = tonumber(str)
    local cardInfo = PlayerData:GetFactoryData(cardId)
    local packId = cardInfo.correspondingPack
    local cfg = PlayerData:GetFactoryData(packId)
    if cardId == cfg.topCard then
      local extraCardStatus = DataModel.GetCardPackInfo(packId).extraCardStatus
      if extraCardStatus == 1 then
        Net:SendProto("book.top_card", function(json)
          for k, v in pairs(json.act_card or {}) do
            PlayerData.ServerData.books.card_pack[k] = v
          end
          UIManager:Open("UI/CollectionCard/CardDrawing", Json.encode({cardId = cardId}), function()
            local packData = DataModel.FindCardPackDataByPackId(packId)
            if packData then
              packData.ownCount = packData.ownCount + 1
              DataModel.cardOwnCnt = DataModel.cardOwnCnt + 1
            end
            DataModel.redInfo[packId] = false
            DataModel.redInfo.count = DataModel.redInfo.count - 1
            View.Group_BottomLeft.Group_Num.Txt_CollectedNum:SetText(DataModel.cardOwnCnt)
            View.Group_BottomRight.Group_BookletFormat.Img_RedPoint:SetActive(DataModel.redInfo.count > 0)
            View.Group_BottomRight.Group_ListFormat.Img_RedPoint:SetActive(DataModel.redInfo.count > 0)
            View.myCustomSV:RefreshAllElement()
          end)
        end, packId)
        return
      end
    end
    local tipContent = cardId == cfg.topCard and GetText(80602694) or cfg.clue
    CommonTips.OpenTips(tipContent)
  end,
  CardBooklet_Group_BottomRight_Group_BookletFormat_Btn_Switch_Click = function(btn, str)
    local nowPosX = DataModel.itemSpacex + DataModel.itemWidth
    nowPosX = MathEx.Clamp(nowPosX, 0, DataModel.contentMaxPosX)
    local transform = View.Group_Booklet.ScrollGrid_Booklet.grid.self.GridTransform
    transform.localPosition = Vector3(-nowPosX, transform.localPosition.y, 0)
    View.Group_Booklet.ScrollGrid_Booklet.grid.self:HandleScrollEvent(Vector2(0, 0))
    View.Group_Booklet.ScrollGrid_Booklet.grid.self:RefreshAllElement()
    View.Group_Booklet:SetActive(true)
    View.Group_BottomRight.Group_BookletFormat.Group_On:SetActive(true)
    View.Group_BottomRight.Group_ListFormat.Group_On:SetActive(false)
    View.CustomScrollGrid_List.self:SetActive(false)
  end,
  CardBooklet_Group_BottomRight_Group_ListFormat_Btn_Switch_Click = function(btn, str)
    View.Group_Booklet:SetActive(false)
    View.Group_BottomRight.Group_BookletFormat.Group_On:SetActive(false)
    View.Group_BottomRight.Group_ListFormat.Group_On:SetActive(true)
    View.CustomScrollGrid_List.self:SetActive(true)
    DataModel.SetCardList()
    View.CustomScrollGrid_List.self:UpdateGridWidthOrHeight(DataModel.height)
    View.myCustomSV:RefreshData(DataModel.cardDataList, View.CustomScrollGrid_List.self.viewportCount)
    View.CustomScrollGrid_List.self.scrollRect.verticalNormalizedPosition = 1
    View.myCustomSV:RefreshAllElement()
  end
}
return ViewFunction
