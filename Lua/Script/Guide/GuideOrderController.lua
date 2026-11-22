local OrderStartBattle = require("Guide/OrderStartBattle")
local OrderDialog = require("Guide/OrderDialog")
local OrderFocus = require("Guide/OrderFocus")
local OrderCloseFocus = require("Guide/OrderCloseFocus")
local OrderTip = require("Guide/OrderTip")
local OrderCloseTip = require("Guide/OrderCloseTip")
local OrderOpenPanel = require("Guide/OrderOpenPanel")
local OrderChapterFocusLevel = require("Guide/OrderChapterFocusLevel")
local OrderClickButton = require("Guide/OrderClickButton")
local SetQuestTrace = require("Guide/SetQuestTrace")
local OrderUIFocus = require("Guide/OrderUIFocus")
local OrderRefreshGuideNo = require("Guide/OrderRefreshGuideNo")
local OrderSetPanel = require("Guide/OrderSetPanel")
local OrderDelay = require("Guide/OrderDelay")
local OrderWaitAnimatorTrigger = require("Guide/OrderWaitAnimatorTrigger")
local OrderCloseCurrentPanel = require("Guide/OrderCloseCurrentPanel")
local OrderGoHome = require("Guide/OrderGoHome")
local OrderCloseUIDrag = require("Guide/OrderCloseUIDrag")
local OrderClearGuideTriggerKeyCache = require("Guide/OrderClearGuideTriggerKeyCache")
local OrderSavePanelTriggerNo = require("Guide/OrderSavePanelTriggerNo")
local OrderCheckProtocolParam = require("Guide/OrderCheckProtocolParam")
local OrderConditionJumpIndex = require("Guide/OrderConditionJumpIndex")
local OrderRotateCamView = require("Guide/OrderRotateCamView")
local OrderCloseGuidanceRotation = require("Guide/OrderCloseGuidanceRotation")
local OrderPicture = require("Guide/OrderPicture")
local OrderTag = require("Guide/OrderTag")
local OrderForceDrive = require("Guide/OrderForceDrive")
local OrderCompleteQuest = require("Guide/OrderCompleteQuest")
local OrderFocusFurniture = require("Guide/OrderFocusFurniture")
local OrderUIFocusCharacter = require("Guide/OrderUIFocusCharacter")
local OrderUIFocusEmptySquads = require("Guide/OrderUIFocusEmptySquads")
local OrderCamera = require("Guide/OrderCamera")
local OrderUIFocusGoods = require("Guide/OrderUIFocusGoods")
local OrderUIFocusScrollView = require("Guide/OrderUIFocusScrollView")
local OrderNPCSounds = require("Guide/OrderNPCSounds")
local OrderFocusESC = require("Guide/OrderFocusESC")
local OrderAD = require("Guide/OrderAD")
local currentOrder
local currentGuideCAId = 0
local ClassEnum = {
  StartBattle = function()
    return OrderStartBattle
  end,
  Dialog = function()
    return OrderDialog
  end,
  Focus = function()
    return OrderFocus
  end,
  CloseFocus = function()
    return OrderCloseFocus
  end,
  Tip = function()
    return OrderTip
  end,
  CloseTip = function()
    return OrderCloseTip
  end,
  OpenPanel = function()
    return OrderOpenPanel
  end,
  ChapterFocusLevel = function()
    return OrderChapterFocusLevel
  end,
  ClickButton = function()
    return OrderClickButton
  end,
  SetQuestTrace = function()
    return SetQuestTrace
  end,
  UIFocus = function()
    return OrderUIFocus
  end,
  RefreshGuideNo = function()
    return OrderRefreshGuideNo
  end,
  SetPanel = function()
    return OrderSetPanel
  end,
  Delay = function()
    return OrderDelay
  end,
  WaitAnimatorTrigger = function()
    return OrderWaitAnimatorTrigger
  end,
  CloseCurrentPanel = function()
    return OrderCloseCurrentPanel
  end,
  GoHome = function()
    return OrderGoHome
  end,
  CloseUIDrag = function()
    return OrderCloseUIDrag
  end,
  ClearGuideTrigger = function()
    return OrderClearGuideTriggerKeyCache
  end,
  SavePanelTriggerNo = function()
    return OrderSavePanelTriggerNo
  end,
  CheckProtocolParam = function()
    return OrderCheckProtocolParam
  end,
  ConditionJumpIndex = function()
    return OrderConditionJumpIndex
  end,
  RotateCamView = function()
    return OrderRotateCamView
  end,
  CloseGuidanceRotation = function()
    return OrderCloseGuidanceRotation
  end,
  Picture = function()
    return OrderPicture
  end,
  Tag = function()
    return OrderTag
  end,
  ForceDrive = function()
    return OrderForceDrive
  end,
  CompleteQuest = function()
    return OrderCompleteQuest
  end,
  FocusFurniture = function()
    return OrderFocusFurniture
  end,
  UIFocusCharacter = function()
    return OrderUIFocusCharacter
  end,
  UIFocusEmptySquads = function()
    return OrderUIFocusEmptySquads
  end,
  Camera = function()
    return OrderCamera
  end,
  UIFocusGoods = function()
    return OrderUIFocusGoods
  end,
  UIFocusScrollView = function()
    return OrderUIFocusScrollView
  end,
  NPCSounds = function()
    return OrderNPCSounds
  end,
  FocusESC = function()
    return OrderFocusESC
  end,
  AD = function()
    return OrderAD
  end
}
local GuideOrderController = {
  ExcuteOrder = function(orderId)
    local orderCA = PlayerData:GetFactoryData(orderId, "GuideOrderFactory")
    currentOrder = nil
    if orderCA ~= nil then
      if orderCA.orderType == "None" then
        error("ExcuteOrderError : id : " .. orderCA.id .. " totalInfo : " .. Json.encode(orderCA))
      end
      currentOrder = ClassEnum[orderCA.orderType]()
      currentOrder:OnStart(orderCA)
    end
  end,
  IsCurrentOrderFinish = function()
    if currentOrder == nil then
      return true
    end
    return currentOrder:IsFinish()
  end,
  AnimatorTrigger = function(triggerKey)
    PlayerData.TempCache.GuideTriggerKey = triggerKey
    if currentOrder == nil then
      return true
    end
    if currentOrder.AnimatorTrigger ~= nil and currentOrder:AnimatorTrigger(triggerKey) then
      PlayerData.TempCache.GuideTriggerKey = nil
    end
  end,
  GetJumpToOrderId = function()
    if currentOrder == nil then
      return -1
    end
    local returnId = -1
    if currentOrder.GetJumpToOrderId ~= nil then
      returnId = currentOrder:GetJumpToOrderId()
    end
    currentOrder = nil
    return returnId
  end,
  LuaCheckCanExecute = function(guideId)
    currentGuideCAId = guideId
    local ca = PlayerData:GetFactoryData(guideId)
    local checkOk = true
    if ca.scene and ca.scene ~= "" then
      checkOk = checkOk and ca.scene == MainManager.bgSceneName
    end
    if ca.levelId and ca.levelId > 0 then
      checkOk = checkOk and ca.levelId == PlayerData.BattleInfo.battleStageId
    end
    return checkOk
  end
}

function GuideOrderController:CurrentOrderNotNil()
  return currentOrder ~= nil
end

function GuideOrderController:GetCurrentGuideCAId()
  return currentGuideCAId
end

return GuideOrderController
