local CommonItem = require("Common/BtnItem")
local View = require("UIPrisonActivity/UIPrisonActivityView")
local DataModel = require("UIPrisonActivity/UIPrisonActivityDataModel")
local ActivityMainController = require("UIActivityMain/UIActivityMainController")
local CardPackDataModel = require("UICardPack_Open/UICardPack_OpenDataModel")
local Controller = {}

function Controller:Init(initParams)
  DataModel.InitData(initParams)
  View.Group_Join.self:SetActive(DataModel.IsOpen)
  View.Group_NotJoin.self:SetActive(not DataModel.IsOpen)
  View.Group_Join.Img_:SetSprite(GetResPath(88300090))
  View.Group_NotJoin.Img_:SetSprite(GetResPath(88300090))
  View.Group_Join.Group_Exchange.Img_:SetSprite(GetResPath(88300091))
  Controller:SetScrollText()
  if not DataModel.IsOpen then
    if DataModel.ActivityCA.rewardPreviewList and table.count(DataModel.ActivityCA.rewardPreviewList) > 0 then
      DataModel.NotJoinReward = {}
      for k, v in pairs(DataModel.ActivityCA.rewardPreviewList) do
        table.insert(DataModel.RewardList, v)
      end
      View.Group_NotJoin.Group_Preview.self:SetActive(true)
      View.Group_NotJoin.Group_Preview.ScrollGrid_Reward.grid.self:SetDataCount(table.count(DataModel.RewardList))
      View.Group_NotJoin.Group_Preview.ScrollGrid_Reward.grid.self:RefreshAllElement()
    end
    View.Group_NotJoin.Group_Add.Group_Can.self:SetActive(true)
    local cfg = PrisonData.GetPrisonCA()
    local limitLevel = cfg.initialTradeLevel
    View.Group_NotJoin.Group_Limited.Txt_Num:SetText(limitLevel)
    local tradeLv = PlayerData:GetHomeInfo().trade_lv or 0
    View.Group_NotJoin.Group_Limited:SetActive(limitLevel > tradeLv)
    View.Group_NotJoin.Group_Add:SetActive(limitLevel <= tradeLv)
  else
    Controller:RefreshConstructionJoinPage()
  end
end

function Controller:SetScrollText()
  local content = GetText(80608707)
  View.Group_Bottom.Img_Mask.Txt_Circle:SetText(content)
  local startposx = View.Group_Bottom.Rect.rect.width
  local txtWidth = View.Group_Bottom.Img_Mask.Txt_Circle:GetWidth()
  View.Group_Bottom.Img_Mask.Txt_Circle:SetAnchoredPositionX((startposx - txtWidth) / 2)
  if startposx < txtWidth then
    local scrollSpeed = 0.2
    scrollSpeed = scrollSpeed * string.getLength(content)
    View.Group_Bottom.Img_Mask.Txt_Circle:SetLocalPositionX(0)
    View.Group_Bottom.Img_Mask.Txt_Circle:SetText(content .. "    " .. content)
    local spaceWidth = math.floor(View.Group_Bottom.Img_Mask.Txt_Circle.Txt.fontSize / 5) + 1
    local spaceNum = 4
    local txtWidth = View.Group_Bottom.Img_Mask.Txt_Circle:GetWidth()
    local endposx = txtWidth / 2 + spaceWidth * spaceNum / 2
    DOTweenTools.DOLocalMoveX(View.Group_Bottom.Img_Mask.Txt_Circle.transform, -endposx, scrollSpeed):SetLoops(-1):SetEase(CS.DG.Tweening.Ease.Linear)
  end
end

function Controller:SetRewardElement(element, elementIndex)
  local row = DataModel.RewardList[elementIndex]
  CommonItem:SetActivityPreviewItem(element.Group_Item, row)
  element.Group_Item.Btn_Item:SetClickParam(row.id)
end

function Controller:RefreshConstructionJoinPage()
  View.Group_Join.self:SetActive(DataModel.IsOpen)
  View.Group_NotJoin.self:SetActive(not DataModel.IsOpen)
  Controller:RefreshCard()
  Controller:RefreshExchange()
  Controller:RefreshSkip()
  View.Group_Join.Group_Quest.Img_RedPoint:SetActive(DataModel.IsOpen and PrisonData.IsHaveCanReceiveQuest())
  View.Group_Join.Group_Skip.Btn_:SetBtnInteractable(true)
end

function Controller:OpenPrison()
  if not DataModel.IsOpen then
    Controller:SkipStation(DataModel.ActivityCA.skipStationStart)
    return
  end
  View.Group_Join.Group_Skip.Btn_:SetBtnInteractable(false)
  PrisonController.OpenPrisonBuildUI()
end

function Controller:OpenCardPage()
  local cardPackId = DataModel.ActivityCA.activityCardPack
  local activityName = DataModel.ActivityCA.name
  
  local function callBack()
    Controller:RefreshCard()
    ActivityMainController:RefreshLeftRedState()
  end
  
  UIManager:Open("UI/CollectionCard/CardPack_Open", Json.encode({cardPackId = cardPackId, activityName = activityName}), callBack)
end

function Controller:RefreshCard()
  View.Group_Join.Group_Card.self:SetActive(false)
  if DataModel.ActivityCA.activityCardPack <= 0 then
    return
  end
  DataModel.CardPackInfo = CardPackDataModel.GetCardPackInfo(DataModel.ActivityCA.activityCardPack)
  View.Group_Join.Group_Card.self:SetActive(true)
  View.Group_Join.Group_Card.Img_RedPoint:SetActive(DataModel.CardPackInfo.extraCardStatus == 1)
  View.Group_Join.Group_Card.Txt_Num:SetText(string.format(GetText(80607795), DataModel.CardPackInfo.ownCount, DataModel.CardPackInfo.allCount))
end

function Controller:RefreshExchange()
end

function Controller:RefreshQuest()
end

function Controller:SkipStation(stationId)
  local parms = {}
  parms.index = DataModel.ChooseLeftIndex
  parms.id = DataModel.ActivityCA.id
  UIManager:Open("UI/MainUI/MainUI", Json.encode({isActivity = true}), function()
    UIManager:Open("UI/Activity/ActivityMain", Json.encode(parms))
  end)
  local MapController = require("UIHome/UIHomeMapController")
  MapController:AutoToClickStation(stationId, true)
end

function Controller:RefreshSkip()
  View.Group_Join.Group_Skip.self:SetActive(true)
end

function Controller:AddActivity()
  Controller:SkipStation(DataModel.ActivityCA.skipStationStart)
end

return Controller
