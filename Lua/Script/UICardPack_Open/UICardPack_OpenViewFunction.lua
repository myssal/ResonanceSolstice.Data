local View = require("UICardPack_Open/UICardPack_OpenView")
local DataModel = require("UICardPack_Open/UICardPack_OpenDataModel")

local function RefreshCardList(cardId, element)
  local data = PlayerData:GetFactoryData(cardId)
  element.Btn_Card:SetClickParam(cardId)
  local isOwn = DataModel.CardIsOwn(cardId)
  element.Btn_Card:SetActive(isOwn)
  element.Btn_Back:SetActive(not isOwn)
  if isOwn then
    element.Btn_Card.Img_CardFront:SetSprite(data.iconPath)
  else
    element.Btn_Back.Img_CardBack:SetSprite(DataModel.cardBackBg)
  end
end

local function RefreshOrder()
  if DataModel.page3Order then
    View.Drag_CardPack.Group_Left1:SetOrder(DataModel.page3Order)
    View.Drag_CardPack.Group_Left2:SetOrder(DataModel.page2Order)
    View.Drag_CardPack.Group_Right2:SetOrder(DataModel.page3Order)
    View.Drag_CardPack.Group_Right3:SetOrder(DataModel.page2Order)
  end
end

local function OpenCardInfoPanel(cardId)
  UIManager:Open("UI/CollectionCard/CollectionCard_Tips", Json.encode({cardId = cardId}), RefreshOrder)
end

local nowProcess = 0
local startPosx = 0
local aniIsPlaying = false
local animatorName = ""
local leftPage, rightPage
local ViewFunction = {
  CardPack_Open_Btn_Return_Click = function(btn, str)
    local animationName = DataModel.isCardBooklet and "CardPack_Open_Booklet_Out" or "CardPack_OpenOut"
    local animatorIdx = DataModel.GetAnimatorIdx()
    View.Drag_CardPack.Group_Left1:SetActive(animatorIdx == 1 or animatorIdx == 3)
    View.Drag_CardPack.Group_Left2:SetActive(animatorIdx == 2)
    View.Drag_CardPack.Group_Right1:SetActive(animatorIdx == 1)
    View.Drag_CardPack.Group_Right2:SetActive(animatorIdx == 2)
    View.Drag_CardPack.Group_Right3:SetActive(animatorIdx == 3)
    View.self:PlayAnim(animationName, function()
      UIManager:GoBack(false)
      View.self:Confirm()
    end)
  end,
  CardPack_Open_Drag_CardPack_BeginDrag = function(direction, dragPos)
    if DataModel.pageNum == 1 then
      return
    end
    if DataModel.ignoreDrag then
      return
    end
    startPosx = dragPos.x
    nowProcess = 0
    local animator = View.animator
    local camera = UIManager.UICamera
    local pos = Vector2(dragPos.x, dragPos.y)
    leftPage = CS.UnityEngine.RectTransformUtility.RectangleContainsScreenPoint(View.Drag_CardPack.Group_LeftArea.Rect, pos, camera)
    rightPage = CS.UnityEngine.RectTransformUtility.RectangleContainsScreenPoint(View.Drag_CardPack.Group_RightArea.Rect, pos, camera)
    local animatorIdx = DataModel.GetAnimatorIdx()
    local page2Order = View.self.CurrOrder
    local page3Order = View.self.CurrOrder
    if leftPage then
      animatorName = string.format("page%d-page%d", animatorIdx, animatorIdx + 1)
      if DataModel.pageIdx >= DataModel.pageNum then
        return
      end
      View.Drag_CardPack.Group_Right2:SetActive(true)
      View.Drag_CardPack.Group_Right3:SetActive(true)
      if animatorIdx == 2 then
        page2Order = View.self.CurrOrder + 1
        page3Order = View.self.CurrOrder
      end
      if animatorIdx == 3 or animatorIdx == 1 then
        page2Order = View.self.CurrOrder
        page3Order = View.self.CurrOrder + 1
      end
      local leftMaxNum, rightMaxNum = DataModel.GetPageCardNum(true)
      if animatorIdx == 3 or DataModel.pageIdx == 1 then
        View.Drag_CardPack.Group_Left2.ScrollGrid_CardList.grid.self:SetDataCount(leftMaxNum)
        View.Drag_CardPack.Group_Left2.ScrollGrid_CardList.grid.self:RefreshAllElement()
        View.Drag_CardPack.Group_Right2.ScrollGrid_CardList.grid.self:SetDataCount(rightMaxNum)
        View.Drag_CardPack.Group_Right2.ScrollGrid_CardList.grid.self:RefreshAllElement()
      end
      if animatorIdx == 2 then
        View.Drag_CardPack.Group_Left1.ScrollGrid_CardList.grid.self:SetDataCount(leftMaxNum)
        View.Drag_CardPack.Group_Left1.ScrollGrid_CardList.grid.self:RefreshAllElement()
        View.Drag_CardPack.Group_Right3.ScrollGrid_CardList.grid.self:SetDataCount(rightMaxNum)
        View.Drag_CardPack.Group_Right3.ScrollGrid_CardList.grid.self:RefreshAllElement()
      end
    end
    if rightPage then
      if DataModel.pageIdx == 1 then
        return
      end
      View.Drag_CardPack.Group_Right2:SetActive(true)
      View.Drag_CardPack.Group_Right3:SetActive(true)
      if animatorIdx == 2 or animatorIdx == 1 then
        page2Order = View.self.CurrOrder
        page3Order = View.self.CurrOrder + 1
      end
      if animatorIdx == 3 then
        page2Order = View.self.CurrOrder + 1
        page3Order = View.self.CurrOrder
      end
      local leftMaxNum, rightMaxNum = DataModel.GetPageCardNum(false)
      if DataModel.pageIdx == 2 then
        animatorName = "page2-page1"
        View.Drag_CardPack.Group_Left1.ScrollGrid_CardList.grid.self:SetDataCount(DataModel.pageCardMaxNum)
        View.Drag_CardPack.Group_Left1.ScrollGrid_CardList.grid.self:RefreshAllElement(DataModel.pageCardMaxNum)
      elseif animatorIdx == 2 then
        animatorName = "page3-page2"
        View.Drag_CardPack.Group_Left1.ScrollGrid_CardList.grid.self:SetDataCount(leftMaxNum)
        View.Drag_CardPack.Group_Left1.ScrollGrid_CardList.grid.self:RefreshAllElement()
        View.Drag_CardPack.Group_Right3.ScrollGrid_CardList.grid.self:SetDataCount(rightMaxNum)
        View.Drag_CardPack.Group_Right3.ScrollGrid_CardList.grid.self:RefreshAllElement()
      elseif animatorIdx == 3 then
        animatorName = "page4-page3"
        View.Drag_CardPack.Group_Left2.ScrollGrid_CardList.grid.self:SetDataCount(leftMaxNum)
        View.Drag_CardPack.Group_Left2.ScrollGrid_CardList.grid.self:RefreshAllElement()
        View.Drag_CardPack.Group_Right2.ScrollGrid_CardList.grid.self:SetDataCount(rightMaxNum)
        View.Drag_CardPack.Group_Right2.ScrollGrid_CardList.grid.self:RefreshAllElement()
      end
    end
    if rightPage or leftPage then
      DataModel.page2Order = page2Order
      DataModel.page3Order = page3Order
      RefreshOrder()
    end
    animator:Play(animatorName)
    animator.enabled = false
    aniIsPlaying = false
  end,
  CardPack_Open_Drag_CardPack_EndDrag = function(direction, dragPos)
    if aniIsPlaying or nowProcess <= 0 then
      return
    end
    local animator = View.animator
    if nowProcess < (animator:GetCurrentAnimatorStateInfo().length or 0.5) / 3 then
      animator.enabled = true
      local animatorIdx = DataModel.GetAnimatorIdx()
      if leftPage then
        animatorName = string.format("page%d-page%d", animatorIdx + 1, animatorIdx)
        if DataModel.pageIdx == 1 then
          animatorName = "page2-page1"
          View.Drag_CardPack.Group_Right2:SetActive(false)
          View.Drag_CardPack.Group_Right3:SetActive(false)
        elseif animatorIdx == 2 then
          animatorName = "page4-page3"
        elseif animatorIdx == 3 then
          animatorName = "page3-page2"
        end
      end
      if rightPage then
        animatorName = string.format("page%d-page%d", animatorIdx - 1, animatorIdx)
      end
      animator:Play(animatorName, 0, 1 - nowProcess / (animator:GetCurrentAnimatorStateInfo().length or 0.5))
    else
      animator.enabled = true
      aniIsPlaying = true
      DataModel.ignoreDrag = true
      View.self:PlayAnim(animatorName, function()
        DataModel.ignoreDrag = false
        local delta = leftPage and 1 or -1
        DataModel.SetPageIdx(DataModel.pageIdx + delta)
        if DataModel.pageIdx == 1 then
          View.Drag_CardPack.Group_Right2:SetActive(false)
          View.Drag_CardPack.Group_Right3:SetActive(false)
        end
      end)
      local process = MathEx.Clamp(nowProcess / (animator:GetCurrentAnimatorStateInfo().length or 0.5), 0, 0.5)
      animator:Play(animatorName, 0, process)
    end
  end,
  CardPack_Open_Drag_CardPack_OnDrag = function(direction, dragPos)
    if aniIsPlaying then
      return
    end
    local animator = View.animator
    local process = (dragPos.x - startPosx) / 600 * (animator:GetCurrentAnimatorStateInfo().length or 0.5)
    startPosx = dragPos.x
    if leftPage then
      nowProcess = process + nowProcess
      if DataModel.pageIdx >= DataModel.pageNum then
        process = 0
        nowProcess = 0
        return
      end
    end
    if rightPage then
      nowProcess = -process + nowProcess
      if DataModel.pageIdx == 1 then
        process = 0
        nowProcess = 0
        return
      end
    end
    if nowProcess <= 0 then
      process = 0
      nowProcess = 0
      return
    end
    if nowProcess >= (animator:GetCurrentAnimatorStateInfo().length or 0.5) / 2 then
      animator.enabled = true
      aniIsPlaying = true
      DataModel.ignoreDrag = true
      View.self:PlayAnim(animatorName, function()
        DataModel.ignoreDrag = false
        local delta = leftPage and 1 or -1
        DataModel.SetPageIdx(DataModel.pageIdx + delta)
        if DataModel.pageIdx == 1 then
          View.Drag_CardPack.Group_Right2:SetActive(false)
          View.Drag_CardPack.Group_Right3:SetActive(false)
        end
      end)
      return
    end
    animator:Update(leftPage and process or -process)
  end,
  CardPack_Open_Drag_CardPack_Group_Left1_ScrollGrid_CardList_SetGrid = function(element, elementIndex)
    local cardId = 86200002
    if DataModel.pageIdx == 1 then
      cardId = DataModel.cardList[elementIndex].id
    elseif leftPage then
      local realIdx = DataModel.pageIdx * 2 + 1
      cardId = DataModel.cardList[DataModel.pageCardMaxNum * (realIdx - 1) + elementIndex].id
    elseif rightPage then
      local realIdx = DataModel.pageIdx * 2 - 3
      cardId = DataModel.cardList[DataModel.pageCardMaxNum * (realIdx - 1) + elementIndex].id
    end
    RefreshCardList(cardId, element)
  end,
  CardPack_Open_Drag_CardPack_Group_Left1_ScrollGrid_CardList_Group_Item_Btn_Back_Click = function(btn, str)
    local cfg = PlayerData:GetFactoryData(DataModel.cardPackId)
    CommonTips.OpenTips(cfg.clue)
    RefreshOrder()
  end,
  CardPack_Open_Drag_CardPack_Group_Left1_ScrollGrid_CardList_Group_Item_Btn_Card_Click = function(btn, str)
    OpenCardInfoPanel(tonumber(str))
  end,
  CardPack_Open_Drag_CardPack_Group_Left2_ScrollGrid_CardList_SetGrid = function(element, elementIndex)
    local cardId = 86200002
    if leftPage then
      local realIdx = DataModel.pageIdx * 2 + 1
      cardId = DataModel.cardList[DataModel.pageCardMaxNum * (realIdx - 1) + elementIndex].id
    elseif rightPage then
      local realIdx = DataModel.pageIdx * 2 - 3
      cardId = DataModel.cardList[DataModel.pageCardMaxNum * (realIdx - 1) + elementIndex].id
    end
    RefreshCardList(cardId, element)
  end,
  CardPack_Open_Drag_CardPack_Group_Left2_ScrollGrid_CardList_Group_Item_Btn_Back_Click = function(btn, str)
    local cfg = PlayerData:GetFactoryData(DataModel.cardPackId)
    CommonTips.OpenTips(cfg.clue)
    RefreshOrder()
  end,
  CardPack_Open_Drag_CardPack_Group_Left2_ScrollGrid_CardList_Group_Item_Btn_Card_Click = function(btn, str)
    OpenCardInfoPanel(tonumber(str))
  end,
  CardPack_Open_Drag_CardPack_Group_Right2_ScrollGrid_CardList_SetGrid = function(element, elementIndex)
    local cardId = 86200002
    if leftPage then
      local realIdx = DataModel.pageIdx * 2
      cardId = DataModel.cardList[DataModel.pageCardMaxNum * (realIdx - 1) + elementIndex].id
    elseif rightPage then
      local realIdx = DataModel.pageIdx * 2 - 4
      cardId = DataModel.cardList[DataModel.pageCardMaxNum * (realIdx - 1) + elementIndex].id
    end
    RefreshCardList(cardId, element)
  end,
  CardPack_Open_Drag_CardPack_Group_Right2_ScrollGrid_CardList_Group_Item_Btn_Back_Click = function(btn, str)
    local cfg = PlayerData:GetFactoryData(DataModel.cardPackId)
    CommonTips.OpenTips(cfg.clue)
    RefreshOrder()
  end,
  CardPack_Open_Drag_CardPack_Group_Right2_ScrollGrid_CardList_Group_Item_Btn_Card_Click = function(btn, str)
    OpenCardInfoPanel(tonumber(str))
  end,
  CardPack_Open_Drag_CardPack_Group_Right3_ScrollGrid_CardList_SetGrid = function(element, elementIndex)
    local cardId = 86200002
    if leftPage then
      local realIdx = DataModel.pageIdx * 2
      cardId = DataModel.cardList[DataModel.pageCardMaxNum * (realIdx - 1) + elementIndex].id
    elseif rightPage then
      local realIdx = DataModel.pageIdx * 2 - 4
      cardId = DataModel.cardList[DataModel.pageCardMaxNum * (realIdx - 1) + elementIndex].id
    end
    RefreshCardList(cardId, element)
  end,
  CardPack_Open_Drag_CardPack_Group_Right3_ScrollGrid_CardList_Group_Item_Btn_Back_Click = function(btn, str)
    local cfg = PlayerData:GetFactoryData(DataModel.cardPackId)
    CommonTips.OpenTips(cfg.clue)
    RefreshOrder()
  end,
  CardPack_Open_Drag_CardPack_Group_Right3_ScrollGrid_CardList_Group_Item_Btn_Card_Click = function(btn, str)
    OpenCardInfoPanel(tonumber(str))
  end,
  CardPack_Open_Group_Cover_Btn_Cover_Click = function(btn, str)
  end,
  CardPack_Open_Drag_CardPack_Group_Right1_Btn_CardGet_Click = function(btn, str)
    Net:SendProto("book.top_card", function(json)
      for k, v in pairs(json.act_card or {}) do
        PlayerData.ServerData.books.card_pack[k] = v
      end
      UIManager:Open("UI/CollectionCard/CardDrawing", Json.encode({
        cardId = DataModel.extraCardId
      }), function()
        local data = DataModel.GetCardPackInfo(DataModel.cardPackId)
        View.Drag_CardPack.Group_Right1.Btn_Card:SetActive(data.extraCardStatus == 2)
        View.Drag_CardPack.Group_Right1.Btn_CardGet:SetActive(data.extraCardStatus == 1)
        View.Drag_CardPack.Group_Right1.Group_CardBackCommon.Img_Tips:SetActive(data.extraCardStatus ~= 2)
        View.Drag_CardPack.Group_Right1.Txt_Tips:SetActive(data.extraCardStatus == 0)
        local extraCardCfg = PlayerData:GetFactoryData(DataModel.extraCardId)
        View.Drag_CardPack.Group_Right1.Btn_Card.Img_Card:SetSprite(extraCardCfg.iconPath)
      end)
    end, DataModel.cardPackId)
  end,
  CardPack_Open_Drag_CardPack_Group_Right1_Btn_Card_Click = function(btn, str)
    UIManager:Open("UI/CollectionCard/CollectionCard_Tips", Json.encode({
      cardId = DataModel.extraCardId
    }), RefreshOrder)
  end
}
return ViewFunction
