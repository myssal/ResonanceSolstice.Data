local View = require("UIDialogEvent/UIDialogEventView")
local MonopolyManager = require("UIMonopoly/LuaMonopolyManager")
local monopolyDataModel = require("UIMonopoly/UIMonopolyDataModel")
local Controller = {
  TextContent = nil,
  CurEventConfig = nil,
  CurDialogConfig = nil,
  CurDialogInfo = nil,
  CurLv = 1,
  CurGridId = 1,
  isDoText = false,
  openSound = nil
}

function Controller.Init(dialogId, lv, eventId, gridId)
  Controller.CurGridId = gridId
  Controller.RefreshDialogShow(dialogId, lv, eventId)
  Controller.PlayOpenSound()
end

function Controller.Release()
end

function Controller.PlayOpenSound()
  local sound = SoundManager:CreateSound(30006378)
  if sound then
    sound:Play()
  end
end

function Controller.CloseDialogPanel()
  if Controller.isDoText then
    Controller.TextContent:CompleteTween()
  end
  UIManager:ClosePanel()
end

function Controller.RefreshDialogShow(dialogId, lv, eventId)
  Controller.CurLv = lv
  Controller.CurDialogConfig = PlayerData:GetFactoryData(dialogId, "MonopolyEventFactory")
  Controller.CurEventConfig = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
  if not Controller.CurDialogConfig or not Controller.CurEventConfig then
    Controller.CloseDialogPanel()
    return
  end
  local dialogList = Controller.CurDialogConfig.dialogList
  if not dialogList or #dialogList == 0 then
    Controller.CloseDialogPanel()
    return
  end
  Controller.CurDialogInfo = dialogList[1]
  if not Controller.CurDialogInfo then
    Controller.CloseDialogPanel()
    return
  end
  if not string.nilorempty(Controller.CurDialogInfo.tachiePath) then
    View.Img_BG.Spine_Character:SetActive(true)
    View.Img_BG.Spine_Character:SetData(Controller.CurDialogInfo.tachiePath, "")
    if not string.nilorempty(Controller.CurDialogInfo.anim) then
      View.Img_BG.Spine_Character:SetAction(Controller.CurDialogInfo.anim, false, true)
      View.self:StartC(LuaUtil.cs_generator(function()
        coroutine.yield(CS.UnityEngine.WaitForSeconds(1.5))
        View.Img_BG.Spine_Character:SetAction("dorm_stand", true, true)
      end))
    else
      View.Img_BG.Spine_Character:SetAction("dorm_stand", true, true)
    end
  else
    View.Img_BG.Spine_Character:SetActive(false)
  end
  if not string.nilorempty(Controller.CurDialogInfo.iconPath) then
    View.Img_BG.Img_Icon:SetActive(true)
    View.Img_BG.Img_Icon:SetSprite(Controller.CurDialogInfo.iconPath)
  else
    View.Img_BG.Img_Icon:SetActive(false)
  end
  if not string.nilorempty(Controller.CurDialogInfo.eventBG) then
    View.Img_BG.Img_Draw:SetActive(true)
    View.Img_BG.Img_Draw:SetSprite(Controller.CurDialogInfo.eventBG)
  else
    View.Img_BG.Img_Draw:SetActive(false)
  end
  View.Img_BG.Img_LV.Txt_LV:SetText(string.format(GetText(80609842), Controller.CurLv))
  if not string.nilorempty(Controller.CurDialogInfo.eventSpine) then
    View.Img_BG.Spine_Event:SetActive(true)
    View.Img_BG.Spine_Event:SetData(Controller.CurDialogInfo.eventSpine, "")
    View.Img_BG.Spine_Event:SetAction("idle", true, true)
  else
    View.Img_BG.Spine_Event:SetActive(false)
  end
  Controller.isDoText = true
  if Controller.CurDialogInfo.selection2 ~= "" then
    View.Img_BG.Group_OneOption:SetActive(false)
    View.Img_BG.Group_TwoOption:SetActive(true)
    Controller.RefreshLevelShow(View.Img_BG.Group_TwoOption)
    Controller.TextContent = View.Img_BG.Group_TwoOption.ScrollView_Text.Viewport.Content.TextHyperlink_Main
    View.Img_BG.Group_TwoOption.Btn_Option_000.Txt_:SetText(Controller.CurDialogInfo.selection1)
    View.Img_BG.Group_TwoOption.Btn_Option_001.Txt_:SetText(Controller.CurDialogInfo.selection2)
    View.Img_BG.Group_TwoOption.ScrollView_Text.Viewport.Content.TextHyperlink_Main:SetTweenContent(Controller.CurDialogInfo.dialogContent, function()
      Controller.isDoText = false
    end, 0.04)
  elseif Controller.CurDialogInfo.selection1 ~= "" then
    View.Img_BG.Group_OneOption:SetActive(true)
    Controller.RefreshLevelShow(View.Img_BG.Group_OneOption)
    View.Img_BG.Group_TwoOption:SetActive(false)
    Controller.TextContent = View.Img_BG.Group_OneOption.ScrollView_Text.Viewport.Content.TextHyperlink_Main
    View.Img_BG.Group_OneOption.Btn_Option_000.Txt_:SetText(Controller.CurDialogInfo.selection1)
    View.Img_BG.Group_OneOption.ScrollView_Text.Viewport.Content.TextHyperlink_Main:SetTweenContent(Controller.CurDialogInfo.dialogContent, function()
      Controller.isDoText = false
    end, 0.04)
  end
end

function Controller.RefreshLevelShow(view_levelInfo)
  if not view_levelInfo then
    return
  end
  local levelInfo = PlayerData:GetFactoryData(Controller.CurDialogConfig.showLevel, "LevelFactory")
  if levelInfo then
    view_levelInfo.ScrollView_Text.Viewport.Content.Img_LevelInfo:SetActive(true)
    view_levelInfo.ScrollView_Text.Viewport.Content.Img_LevelInfo.Img_Name.Txt_LV:SetText(string.format(GetText(80609843), levelInfo.recomGrade))
    view_levelInfo.ScrollView_Text.Viewport.Content.Img_LevelInfo.Group_Bottom.Group_Txt.Txt_Des:SetText(levelInfo.description)
    local bossInfo = PlayerData:GetFactoryData(levelInfo.bossId, "UnitFactory")
    if bossInfo then
      view_levelInfo.ScrollView_Text.Viewport.Content.Img_LevelInfo.Img_Name.Txt_Name:SetText(bossInfo.name)
      local viewInfo = PlayerData:GetFactoryData(bossInfo.viewId, "UnitViewFactory")
      if viewInfo then
        view_levelInfo.ScrollView_Text.Viewport.Content.Img_LevelInfo.Group_Bottom.Img_Head.Img_Mask.Img_Face:SetSprite(viewInfo.face)
      end
    end
  else
    view_levelInfo.ScrollView_Text.Viewport.Content.Img_LevelInfo:SetActive(false)
  end
end

function Controller.OnSelectClick(index)
  if not Controller.CurDialogInfo or not Controller.CurEventConfig then
    return
  end
  local nextId = -1
  if index == 1 then
    nextId = Controller.CurDialogInfo.selection1Next
  elseif index == 2 then
    nextId = Controller.CurDialogInfo.selection2Next
  end
  if nextId == -1 or nextId == 0 or nextId == nil then
    nextId = Controller.CurDialogInfo.next
  end
  if nextId == -1 then
    Controller.ReqCompleteGrid(Controller.CurDialogConfig.id)
  else
    Controller.DoDialogShowById(nextId)
  end
end

function Controller.DoDialogShowById(dialogId)
  local dialogInfo = PlayerData:GetFactoryData(dialogId, "MonopolyEventFactory")
  if not dialogInfo then
    return
  end
  local isHasReward = Controller.GetTableIsContainsValue(Controller.CurEventConfig.rewardDialogList, dialogId)
  if not isHasReward then
    if dialogInfo then
      if dialogInfo.mod == "\229\175\185\232\175\157" and (dialogInfo.rewardList == nil or table.count(dialogInfo.rewardList) == 0) and (dialogInfo.randomRewardList == nil or table.count(dialogInfo.randomRewardList) == 0) then
        Controller.RefreshDialogShow(dialogId, Controller.CurLv, Controller.CurEventConfig.id)
      else
        CommonTips.OpenTips(80608982)
      end
    end
  elseif dialogInfo.mod == "\229\175\185\232\175\157" then
    local function cbSuccess(json)
      local function dialogShow()
        Controller.RefreshDialogShow(dialogId, Controller.CurLv, Controller.CurEventConfig.id)
      end
      
      if json ~= nil and json.reward and json.reward.item and table.count(json.reward.item) > 0 then
        Controller.ShowJsonRewards(json.reward, dialogShow)
        MonopolyManager.RefreshMoneyNum()
      elseif json ~= nil and json.consumables and json.consumables.item and 0 < table.count(json.consumables.item) then
        Controller.ShowLoseRewards(json.consumables, dialogShow)
        MonopolyManager.RefreshMoneyNum()
      else
        dialogShow()
      end
    end
    
    local function cbFail(json)
      if json and json.rc and json.rc ~= "" then
        MonopolyManager.CheckTimeIsOverAndBack()
        Controller.CloseDialogPanel()
      end
    end
    
    Controller.ReqTriggerDialogEvent(tostring(dialogId), 0, cbSuccess, cbFail)
  elseif dialogInfo.mod == "\229\176\143\230\184\184\230\136\143" then
    local function cbSuccess(json)
      if json then
        local sValue = tonumber(dialogInfo.selectVal)
        
        local mValue = dialogInfo.maxLimit / 2
        local rValue = 1
        if json.info == 1 then
          if sValue == 0 then
            rValue = math.random(1, mValue)
          else
            rValue = math.random(mValue + 1, dialogInfo.maxLimit)
          end
        elseif sValue == 0 then
          rValue = math.random(mValue + 1, dialogInfo.maxLimit)
        else
          rValue = math.random(1, mValue)
        end
        View.Img_No:SetActive(true)
        View.Img_No.Spine_Dice:SetAction(tostring(rValue), false, true)
        
        local function doReward()
          View.Img_No:SetActive(false)
          if json.info == 1 then
            local function dialogShow()
              Controller.RefreshDialogShow(dialogInfo.sucid, Controller.CurLv, Controller.CurEventConfig.id)
            end
            
            if json ~= nil and json.reward and json.reward.item and table.count(json.reward.item) > 0 then
              Controller.ShowJsonRewards(json.reward, dialogShow)
              MonopolyManager.RefreshMoneyNum()
            else
              dialogShow()
            end
          else
            local function failDialogShow()
              Controller.RefreshDialogShow(dialogInfo.failid, Controller.CurLv, Controller.CurEventConfig.id)
            end
            
            if json ~= nil and json.consumables and json.consumables.item and 0 < table.count(json.consumables.item) then
              Controller.ShowLoseRewards(json.consumables, failDialogShow)
              MonopolyManager.RefreshMoneyNum()
            else
              failDialogShow()
            end
          end
        end
        
        View.self:StartC(LuaUtil.cs_generator(function()
          coroutine.yield(CS.UnityEngine.WaitForSeconds(1.5))
          doReward()
        end))
      end
    end
    
    local function cbFail(json)
      if json and json.rc and json.rc ~= "" then
        MonopolyManager.CheckTimeIsOverAndBack()
        Controller.CloseDialogPanel()
      end
    end
    
    Controller.ReqTriggerDialogEvent(tostring(dialogId), tonumber(dialogInfo.selectVal), cbSuccess, cbFail)
  elseif dialogInfo.mod == "\230\136\152\230\150\151\229\175\185\232\175\157" then
    Controller.CloseDialogPanel()
    local status = {
      levelId = dialogInfo.levelID,
      dialogId = dialogId,
      Current = "Monopoly",
      extraUIParamData = {scene = "Monopoly"}
    }
    PlayerData.BattleCallBackPage = "UI/Monopoly/Monopoly"
    UIManager:Open("UI/Squads/Squads", Json.encode(status))
  elseif dialogInfo.mod == "\233\129\147\229\133\183\229\149\134\229\186\151" then
    Controller.CloseDialogPanel()
    
    local function cbSuccess(json)
      if string.nilorempty(json.rc) and json.gridShop then
        local t = {
          gridShop = json.gridShop
        }
        UIManager:Open("UI/Monopoly/UI/BuyBuff/MonopolyBuyBuff", Json.encode(t))
      end
    end
    
    local function cbFail(json)
      if json and json.rc and json.rc ~= "" then
        MonopolyManager.CheckTimeIsOverAndBack()
      end
    end
    
    Controller.ReqTriggerDialogEvent(tostring(dialogId), 0, cbSuccess, cbFail)
  end
end

function Controller.ShowJsonRewards(items, cbFunc)
  if items and items.item and table.count(items.item) > 0 then
    for id, v in pairs(items.item) do
      if v then
        local itemCa = PlayerData:GetFactoryData(id, "ItemFactory")
        if itemCa then
          if itemCa.mod == "\229\164\167\229\175\140\231\191\129\229\143\175\228\189\191\231\148\168\233\129\147\229\133\183" then
            monopolyDataModel.AddBackItemNum(id, v.num)
          end
          if tostring(id) == "11400334" then
            MonopolyManager.AddTelecontrolDiceNum(v.num)
          end
          if tostring(id) == "11400335" then
            MonopolyManager.AddUserDiceNum(v.num)
          end
        end
      end
    end
    UIManager:Open("UI/Monopoly/UI/ShowItem/MonopolyShowItem", Json.encode({
      rewards = items,
      title = nil,
      ignoreCloseTime = true
    }), function()
      cbFunc()
    end)
  else
    cbFunc()
  end
end

function Controller.ShowLoseRewards(rewards, cbFunc)
  UIManager:Open("UI/Monopoly/UI/ShowItemBad", Json.encode({rewards = rewards}), cbFunc)
end

function Controller.ReqTriggerDialogEvent(dialogId, gameResult, cbSuccess, cbFail)
  Net:SendProto("monopoly.trigger_dialog_event", cbSuccess, dialogId, gameResult, cbFail)
end

function Controller.ReqCompleteGrid(dialogId)
  local function cbSuccess(json)
    MonopolyManager.SetGridCompleteState(tostring(Controller.CurGridId), 1)
    
    Controller.CloseDialogPanel()
    MonopolyManager.RefreshGridMenu()
  end
  
  local function cbFail(json)
    MonopolyManager.CheckTimeIsOverAndBack()
  end
  
  Net:SendProto("monopoly.com_grid", cbSuccess, dialogId, cbFail)
end

function Controller.GetTableIsContainsValue(tb, value)
  if not tb or table.count(tb) == 0 then
    return false
  end
  for _, v in pairs(tb) do
    if v.id == value then
      return true
    end
  end
  return false
end

return Controller
