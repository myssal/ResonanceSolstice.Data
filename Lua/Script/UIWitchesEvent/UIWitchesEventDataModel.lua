local View = require("UIWitchesEvent/UIWitchesEventView")
local DataModel = {}
DataModel.eventId = nil
DataModel.dialogInfo = {}
DataModel.textContent = nil
DataModel.doText = false
DataModel.isEndingEvent = false

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.eventId = data.eventId
end

function DataModel.InitData()
  DataModel.isEndingEvent = false
end

function DataModel.RefreshOnShow()
  DataModel.RefreshDialog(DataModel.eventId)
end

function DataModel.RefreshDialog(eventId)
  local parkMapCA = WitchData.GetParkMapCA()
  local eventCA = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
  local dialogInfo = eventCA.dialogList[1] or {}
  local showBack = eventCA.isBack == true
  View.Group_CommonTopLeft:SetActive(showBack)
  View.Group_Coin:SetActive(showBack)
  if showBack then
    local dreamCoin = parkMapCA.dreamCoin or {}
    local coinInfo = dreamCoin[1]
    if coinInfo then
      local coinCA = PlayerData:GetFactoryData(coinInfo.id, "ItemFactory")
      if coinCA then
        View.Group_Coin.Img_Money:SetSprite(coinCA.buyPath or "")
      end
    end
    View.Group_Coin.Txt_Num:SetText(WitchData.GetCoin())
  end
  local showBg = dialogInfo.eventBG ~= ""
  View.Img_BG.SoftMask_Character.Img_Bg:SetActive(showBg)
  if showBg then
    View.Img_BG.SoftMask_Character.Img_Bg:SetSprite(dialogInfo.eventBG)
  end
  local showNpc = dialogInfo.eventNPC > 0
  View.Img_BG.SoftMask_Character.Img_Source:SetActive(showNpc)
  if showNpc then
    local npcCA = PlayerData:GetFactoryData(dialogInfo.eventNPC, "NPCFactory")
    local showSpine = npcCA.spineUrl ~= ""
    if showSpine then
      local scale = npcCA.spineScale
      View.Img_BG.SoftMask_Character.Img_Source.Spine_Character:SetLocalScale(Vector3(scale, scale, 1))
      View.Img_BG.SoftMask_Character.Img_Source.Spine_Character:SetAnchoredPosition(Vector2(npcCA.spineOffsetX, npcCA.spineOffsetY))
      View.Img_BG.SoftMask_Character.Img_Source.Spine_Character:SetActive(false)
      View.Img_BG.SoftMask_Character.Img_Source.Spine_Character:SetData(npcCA.spineUrl, "idle")
      View.self:StartC(LuaUtil.cs_generator(function()
        coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
        View.Img_BG.SoftMask_Character.Img_Source.Spine_Character:SetActive(true)
      end))
      View.Img_BG.SoftMask_Character.Img_Source.Img_Character:SetActive(false)
    else
      local showImg = npcCA.resUrl ~= ""
      View.Img_BG.SoftMask_Character.Img_Source.Img_Character:SetActive(showImg)
      if showImg then
        View.Img_BG.SoftMask_Character.Img_Source.Img_Character:SetAnchoredPosition(Vector2(npcCA.offsetX, npcCA.offsetY))
        View.Img_BG.SoftMask_Character.Img_Source.Img_Character:SetSprite(npcCA.resUrl)
      end
      View.Img_BG.SoftMask_Character.Img_Source.Spine_Character:SetActive(false)
    end
  end
  local showIcon = dialogInfo.iconPath ~= ""
  View.Img_BG.Img_Icon:SetActive(showIcon)
  if showIcon then
    View.Img_BG.Img_Icon:SetSprite(dialogInfo.iconPath)
  end
  if eventCA.isCar then
    local gridEventCA = PlayerData:GetFactoryData(parkMapCA.carEvent, "MonopolyEventFactory")
    View.Img_BG.Img_Title.Txt_:SetText(gridEventCA.name)
  else
    local gridData = WitchData.GetGridData(WitchData.GetGridId())
    local gridEventCA = PlayerData:GetFactoryData(gridData.event, "MonopolyEventFactory")
    View.Img_BG.Img_Title.Txt_:SetText(gridEventCA.name)
  end
  local showOne = false
  local showTwo = not string.nilorempty(dialogInfo.selection1) and not string.nilorempty(dialogInfo.selection2)
  if not showTwo then
    showOne = not string.nilorempty(dialogInfo.selection1)
  end
  View.Img_BG.Group_OneOption:SetActive(showOne)
  View.Img_BG.Group_TwoOption:SetActive(showTwo)
  if showOne then
    DataModel.doText = true
    DataModel.textContent = View.Img_BG.Group_OneOption.ScrollView_Text.Viewport.Content.TextHyperlink_Main
    View.Img_BG.Group_OneOption.Btn_Option_000.Txt_:SetText(dialogInfo.selection1)
    View.Img_BG.Group_OneOption.ScrollView_Text.Viewport.Content.TextHyperlink_Main:SetTweenContent(dialogInfo.dialogContent, function()
      DataModel.doText = false
    end, 0.04)
  elseif showTwo then
    DataModel.doText = true
    DataModel.textContent = View.Img_BG.Group_TwoOption.ScrollView_Text.Viewport.Content.TextHyperlink_Main
    View.Img_BG.Group_TwoOption.Btn_Option_000.Txt_:SetText(dialogInfo.selection1)
    View.Img_BG.Group_TwoOption.Btn_Option_001.Txt_:SetText(dialogInfo.selection2)
    View.Img_BG.Group_TwoOption.ScrollView_Text.Viewport.Content.TextHyperlink_Main:SetTweenContent(dialogInfo.dialogContent, function()
      DataModel.doText = true
    end, 0.04)
  end
end

function DataModel.GetSelectDialogEventId(optionIndex)
  local eventId = DataModel.eventId
  local eventCA = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
  local dialogInfo = eventCA.dialogList[1] or {}
  local selectDialogEventId
  if optionIndex == 1 then
    selectDialogEventId = dialogInfo.selection1Next
  elseif optionIndex == 2 then
    selectDialogEventId = dialogInfo.selection2Next
  end
  if selectDialogEventId and selectDialogEventId <= 0 then
    selectDialogEventId = nil
  end
  return selectDialogEventId
end

function DataModel.SelectOption(optionIndex)
  local eventId = DataModel.eventId
  local eventCA = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
  local selectDialogEventId = DataModel.GetSelectDialogEventId(optionIndex)
  if selectDialogEventId then
    DataModel.DealEvent(selectDialogEventId)
  elseif eventCA.isCar then
    local gridData = WitchData.GetGridData(WitchData.GetGridId())
    if gridData then
      gridData.com = 1
    end
    DataModel.CloseDialog()
  else
    DataModel.CloseDialog()
    WitchData.ReqEndOverEvent(eventId)
  end
end

function DataModel.ReturnEvent()
  if DataModel.isEndingEvent then
    return
  end
  DataModel.isEndingEvent = true
  WitchData.ReqEndOverEvent(DataModel.eventId)
  DataModel.CloseDialog()
end

local function isCostEnough(costList)
  for _, costInfo in ipairs(costList or {}) do
    if WitchData.GetItemNumById(costInfo.id) < costInfo.num then
      return false
    end
  end
  return true
end

local function openChangeSealEvent(eventId, sealEventType)
  UIManager:Open(WitchData.GetUIPath("UI/Witches/Event/ChangeSealEvent"), Json.encode({eventId = eventId, sealEventType = sealEventType}))
end

function DataModel.DealEvent(eventId)
  local eventCA = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
  local mod = eventCA.mod
  if mod == "\233\173\148\229\165\179\229\175\185\232\175\157" then
    local needDeal = WitchData.IsEventNeedDeal(eventId)
    if needDeal then
      local function cb(json)
        DataModel.eventId = eventId
        
        DataModel.RefreshDialog(eventId)
        if json.reward then
          WitchData.OpenShowItem(json.reward)
        end
      end
      
      WitchData.ReqDealEvent(eventId, cb)
    else
      DataModel.eventId = eventId
      DataModel.RefreshDialog(eventId)
    end
  elseif mod == "\233\173\148\229\165\179\233\129\147\229\133\183\229\149\134\229\186\151" then
    local function cb(json)
      if json.temp_select then
        UIManager:Open(WitchData.GetUIPath("UI/Witches/Event/WitchesShop"), Json.encode({
          eventId = eventId,
          
          selectInfo = json.temp_select.shop
        }))
      end
    end
    
    WitchData.ReqDealEvent(eventId, cb)
    DataModel.CloseDialog()
  elseif mod == "\233\173\148\229\165\179\232\140\182\230\173\135\228\186\139\228\187\182" then
    local function cb(json)
      if json.temp_select then
        UIManager:Open(WitchData.GetUIPath("UI/Witches/Event/WitchesTeaBuff"), Json.encode({
          eventId = eventId,
          
          selectInfo = json.temp_select.rest
        }))
      end
    end
    
    WitchData.ReqDealEvent(eventId, cb)
    DataModel.CloseDialog()
  elseif mod == "\233\173\148\229\165\179\230\137\171\230\138\138\228\186\139\228\187\182" then
    if eventCA.moveType == "Option" then
      DataModel.CloseDialog()
      local DataController = require("UIWitchMain/UIWitchMainDataController")
      DataController.CalculateNextTriggers(eventId)
    else
      local function cb(json)
        if json.terminus_grid then
          local gridId = json.terminus_grid
          
          local UIWitchMainDataModel = require("UIWitchMain/UIWitchMainDataModel")
          local gridData = UIWitchMainDataModel.gridList[tonumber(gridId)]
          local DataController = require("UIWitchMain/UIWitchMainDataController")
          DataController.DealBroomEventMove(gridData, json.dialogEvent)
        end
      end
      
      WitchData.ReqDealBroomEvent(eventId, nil, cb)
      DataModel.CloseDialog()
    end
  elseif mod == "\233\173\148\229\165\179\230\145\169\229\164\169\232\189\174\228\186\139\228\187\182" then
    DataModel.CloseDialog()
    UIManager:Open("UI/Activity/ActivitySignBattle/ActivitySignBattleLevelWensheng", Json.encode({
      eventId = eventId,
      activityId = PlayerData:GetFactoryData(eventId).ferrisWheelEntrance
    }))
    PlayerData:SetPlayerPrefs("int", "WitchWheelDialog", 1)
  elseif mod == "\229\146\149\229\141\161\229\175\185\232\175\157" then
    local function cb(json)
      if json.temp_select then
        UIManager:Open(WitchData.GetUIPath("UI/Witches/Guka/GuKaChoose"), Json.encode({rewardType = "guka"}))
      end
    end
    
    WitchData.ReqDealEvent(eventId, cb)
    DataModel.CloseDialog()
  elseif mod == "\233\173\148\229\165\179\229\136\183\229\174\157\231\159\179\228\186\139\228\187\182" then
    if not isCostEnough(eventCA.CostList) then
      CommonTips.OpenWitchTip(80600488)
      return
    end
    if eventCA.sealEventType == "refreshSealToFull" then
      WitchData.ReqDealEvent(eventId, function(json)
        for _, costInfo in ipairs(eventCA.CostList or {}) do
          WitchData.RefreshUseItems({
            [costInfo.id] = costInfo.num
          })
        end
        WitchData.GetWitchesData().user_seal = json.user_seal or {}
        openChangeSealEvent(eventId, eventCA.sealEventType)
      end, nil)
    elseif eventCA.sealEventType == "copyOneSeal" then
      openChangeSealEvent(eventId, eventCA.sealEventType)
    end
  end
end

function DataModel.CloseDialog()
  if DataModel.doText then
    DataModel.textContent:CompleteTween()
    DataModel.textContent = nil
    DataModel.doText = false
  end
  UIManager:GoBack()
end

return DataModel
