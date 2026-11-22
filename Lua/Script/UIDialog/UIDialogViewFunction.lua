local View = require("UIDialog/UIDialogView")
local CheckBox = require("UIDialog/Model_CheckBox")
local PlotText = require("UIDialog/Model_PlotText")
local Subtitles = require("UIDialog/Model_Subtitles")
local Controller = require("UIDialog/Model_PlotController")
local DataModel = require("UIDialog/UIDialogDataModel")
local Gender = require("UIDialog/Model_SelectGender")
local TimeLine = require("Common/TimeLine")
local Item = require("UIDialog/Model_PlotItem")
local PlotReviewDataModel = require("UIPlotReview/UIPlotReviewDataModel")

local function OpenTips(hasOpen, isAnimator01)
  local tips = View.Group_Tips
  DataModel.Pause(hasOpen)
  tips:SetActive(hasOpen)
  local AutoChapterState = PlotReviewDataModel.GetAutoChapterState()
  local showAutoChapter = DataModel.isReview and AutoChapterState
  View.Group_Tips.Group_Play:SetActive(showAutoChapter)
  if hasOpen then
    tips.Group_Prompt.Txt_Prompt:SetText(GetText(80600069))
    tips.Txt_Outline:SetText(DataModel.Ca.outline)
    local animationName = "TipsIn"
    if DataModel.Ca.outline == "" or isAnimator01 then
      animationName = "TipsIn_1"
    end
    View.self:PlayAnim(animationName, function()
    end)
    tips.Btn_Confirm.Txt_Confirm:SetText(GetText(80600068))
    tips.Btn_Cancel.Txt_Cancel:SetText(GetText(80600067))
    PlotText.PauseTween()
    Subtitles.PauseTween()
  else
    PlotText.ContinueTween()
    Subtitles.ContinueTween()
  end
end

local objectState = {}

local function Hide(isHide)
  local transform = View.self.transform
  local count = transform.childCount - 1
  local gameObject
  if isHide then
    objectState = {}
    local isActive = View.Group_Shake.self.IsActive
    for i = 0, count do
      gameObject = transform:GetChild(i).gameObject
      if gameObject.activeInHierarchy then
        objectState[i] = i
        gameObject:SetActive(false)
      end
    end
    View.Group_Shake:SetActive(isActive)
    View.Btn_CancelHide:SetActive(true)
  else
    for k, v in pairs(objectState) do
      transform:GetChild(v).gameObject:SetActive(true)
    end
    View.Btn_CancelHide:SetActive(false)
  end
  DataModel.Pause(isHide)
end

local function HandleSkip2Box()
  local mod = DataModel.plotList[DataModel.plotIndex].mod
  if mod == "\229\164\141\233\128\137\230\161\134" then
    return true
  end
  local handle_mods = {
    ["\232\131\140\230\153\175"] = 1,
    ["\229\133\168\229\177\143\233\129\174\231\189\169"] = 1,
    ["\230\150\135\230\156\172\229\137\167\230\131\133"] = 1
  }
  local last_mods = {}
  local has_box = false
  local role_count = 0
  local show_role_data = {}
  for i, v in ipairs(DataModel.plotList) do
    if handle_mods[v.mod] then
      last_mods[v.mod] = {ca = v, idx = i}
    end
    if v.mod == "\231\171\139\231\187\152\231\167\187\229\138\168" then
      local old_data = show_role_data[v.portraitIndex]
      if old_data then
        show_role_data[v.targetPortraitIndex] = old_data
        show_role_data[v.targetPortraitIndex][2] = v
        if v.targetPortraitIndex ~= v.portraitIndex then
          show_role_data[v.portraitIndex] = nil
        end
      end
    elseif v.mod == "\232\167\146\232\137\178\229\138\168\231\148\187" then
      if v.exchangeEffect == "Fadein" or v.exchangeEffect == "Null" then
        if show_role_data[v.fromIndex] == nil then
          role_count = role_count + 1
          v.now_order = role_count
        else
          v.now_order = show_role_data[v.fromIndex][1].now_order
        end
        show_role_data[v.fromIndex] = {
          [1] = v
        }
      elseif v.exchangeEffect == "FadeOut" then
        show_role_data[v.fromIndex] = nil
        role_count = role_count - 1
      end
    elseif v.mod == "\231\171\139\231\187\152\231\138\182\230\128\129" then
      if show_role_data[v.index] then
        show_role_data[v.index][3] = v
      end
    elseif v.mod == "\229\137\167\230\131\133\230\160\145" then
      for i, v in ipairs(v.plotIdList) do
        local plot_id = v.plotID
        local plotCA = PlayerData:GetFactoryData(plot_id, "PlotFactory")
        if plotCA.mod == "\231\171\139\231\187\152\231\167\187\229\138\168" then
          local old_data = show_role_data[plotCA.portraitIndex]
          if old_data then
            show_role_data[plotCA.targetPortraitIndex] = old_data
            show_role_data[plotCA.targetPortraitIndex][2] = plotCA
            if plotCA.targetPortraitIndex ~= plotCA.portraitIndex then
              show_role_data[plotCA.portraitIndex] = nil
            end
          end
        elseif plotCA.mod == "\232\167\146\232\137\178\229\138\168\231\148\187" then
          if plotCA.exchangeEffect == "Fadein" or plotCA.exchangeEffect == "Null" then
            if show_role_data[plotCA.fromIndex] == nil then
              role_count = role_count + 1
              plotCA.now_order = role_count
            else
              plotCA.now_order = show_role_data[plotCA.fromIndex][1].now_order
            end
            show_role_data[plotCA.fromIndex] = {
              [1] = plotCA
            }
          elseif plotCA.exchangeEffect == "FadeOut" then
            show_role_data[plotCA.fromIndex] = nil
            role_count = role_count - 1
          end
        elseif plotCA.mod == "\231\171\139\231\187\152\231\138\182\230\128\129" and show_role_data[plotCA.index] then
          show_role_data[plotCA.index][3] = plotCA
        end
      end
    end
    if not (i < DataModel.plotIndex) then
      if v.mod == "\229\164\141\233\128\137\230\161\134" then
        has_box = true
        Controller.JumpPlot(i)
        break
      elseif v.mod == "\229\164\141\233\128\137\230\161\134\230\140\137\233\146\174\229\155\158\232\176\131" then
        local state = PlayerData:GetPlayerPrefs("int", "BattleSkipState")
        if state < 1 then
          DataModel.CallBackIndex = i
          break
        end
        has_box = true
        Controller.JumpPlot(i)
        break
      elseif v.mod == "\232\131\140\230\153\175" and (v.animName == "#pause" or v.isSkipStop) then
        has_box = true
        Controller.JumpPlot(i)
        break
      end
    end
  end
  if has_box then
    for k, v in pairs(last_mods) do
      local classMod = Controller.GetClassModName(v.ca.mod)
      if v.ca.mod == "\230\150\135\230\156\172\229\137\167\230\131\133" then
        classMod.SetLastValue(v.ca)
      else
        classMod:OnStart(v.ca, v.idx)
      end
    end
    for k, v in pairs(DataModel.PaintData) do
      if v.posIndex ~= -1 then
        v.spine:SetActive(false)
        v.posIndex = -1
      end
    end
    for k, v in pairs(show_role_data) do
      for k1, v1 in pairs(v) do
        local classMod = Controller.GetClassModName(v1.mod)
        if v1.mod == "\232\167\146\232\137\178\229\138\168\231\148\187" then
          classMod:LoadRole(v1)
        elseif v1.mod == "\231\171\139\231\187\152\231\167\187\229\138\168" then
          classMod.Move2TargetPos(v1)
        else
          classMod:OnStart(v1)
        end
      end
    end
    return true
  end
  return false
end

local ViewFunction = {
  Dialog_Btn_Skip_Click = function(str)
    if DataModel.Video.isPlaying then
      if DataModel.Video.isSkip then
        if DataModel.Video.isOnlySkipVideo or DataModel.isReview then
          local state = PlayerData:GetPlayerPrefs("int", "BattleSkipState")
          if state < 1 then
            OpenTips(true, true)
          else
            View.Video_BG:VideoOver()
          end
          return
        end
      else
        return
      end
    end
    if DataModel.TimeLine.isPlaying then
      if DataModel.TimeLine.isSkip then
        if DataModel.TimeLine.isOnlySkipTimeLine then
          local state = PlayerData:GetPlayerPrefs("int", "BattleSkipState")
          if state < 1 then
            OpenTips(true, true)
          else
            TimeLine.RemoveTimeLine(DataModel.TimeLine.id)
          end
          return
        end
      else
        return
      end
    end
    if HandleSkip2Box() then
      return
    end
    local state = PlayerData:GetPlayerPrefs("int", "BattleSkipState")
    if state < 1 then
      DataModel.isTrue = false
      View.Group_Tips.Group_Tip.Btn_Tip.Group_Off:SetActive(not DataModel.isTrue)
      View.Group_Tips.Group_Tip.Btn_Tip.Group_On:SetActive(DataModel.isTrue)
      OpenTips(true)
    else
      Controller.OnEnd()
    end
  end,
  Dialog_Btn_Dialog_Click = function(str)
  end,
  Dialog_Group_Option_Btn_Option01_Click = function(str)
    CheckBox:Finish(1)
  end,
  Dialog_Group_Option_Btn_Option02_Click = function(str)
    CheckBox:Finish(2)
  end,
  Dialog_Group_Option_Btn_Option03_Click = function(str)
    CheckBox:Finish(3)
  end,
  Dialog_Group_Tips_Btn_BG_Click = function(btn, str)
    PlayerData:SetPlayerPrefs("int", "BattleSkipState", 0)
    OpenTips(false)
  end,
  Dialog_Group_Tips_Btn_Confirm_Click = function(btn, str)
    OpenTips(false)
    if DataModel.isTrue then
      PlayerData:SetPlayerPrefs("int", "BattleSkipState", 1)
    else
      PlayerData:SetPlayerPrefs("int", "BattleSkipState", 0)
    end
    if DataModel.Video.isPlaying then
      View.Video_BG:VideoOver()
      if DataModel.Video.isOnlySkipVideo then
        return
      end
    end
    if DataModel.TimeLine.isPlaying then
      TimeLine.RemoveTimeLine(DataModel.TimeLine.id)
      if DataModel.TimeLine.isOnlySkipTimeLine then
        return
      end
    end
    if DataModel.CallBackIndex > -1 then
      Controller.JumpPlot(DataModel.CallBackIndex)
      DataModel.CallBackIndex = -1
      return
    end
    Controller.OnEnd()
  end,
  Dialog_Group_Tips_Btn_Cancel_Click = function(btn, str)
    PlayerData:SetPlayerPrefs("int", "BattleSkipState", 0)
    OpenTips(false)
  end,
  Dialog_Group_Gender_Btn_nan_Click = function(btn, str)
    Gender.Girl(false)
    Gender.Boy(true)
  end,
  Dialog_Group_Gender_Btn_nv_Click = function(btn, str)
    Gender.Boy(false)
    Gender.Girl(true)
  end,
  Dialog_Group_Gender_Btn_affirm_Click = function(btn, str)
    Gender.Confirm()
  end,
  Dialog_Group_Tips_Group_Tip_Btn_Tip_Click = function(btn, str)
    local group_off = View.Group_Tips.Group_Tip.Btn_Tip.Group_Off
    local group_on = View.Group_Tips.Group_Tip.Btn_Tip.Group_On
    if group_on.self.IsActive == true then
      DataModel.isTrue = false
      group_on.self:SetActive(false)
      group_off.self:SetActive(true)
    else
      group_on.self:SetActive(true)
      group_off.self:SetActive(false)
      DataModel.isTrue = true
    end
  end,
  Dialog_Video_BG_Skip_Click = function(btn, str)
  end,
  Dialog_Btn_Auto_Click = function(btn, str)
    DataModel.SetAutoBtn()
  end,
  Dialog_Btn_Log_Click = function(btn, str)
    UIManager:Open("UI/Dialog/DialogReview")
    DataModel.isPause = true
    if DataModel.isAuto then
      DataModel.Speed = 2
      DataModel.SetAutoBtn()
    end
    for i, v in ipairs(DataModel.PaintData) do
      v.spine:SetOrder(v.spine.order + i, false)
    end
  end,
  Dialog_Btn_Hide_Click = function(btn, str)
    Hide(true)
  end,
  Dialog_Btn_CancelHide_Click = function(btn, str)
    Hide(false)
  end,
  Dialog_Group_Item_Group_Clues_Group_Clue01_Btn_Clue_Click = function(btn, str)
    Item.ShowClue(1)
  end,
  Dialog_Group_Item_Group_Clues_Group_Clue02_Btn_Clue_Click = function(btn, str)
    Item.ShowClue(2)
  end,
  Dialog_Group_Item_Group_Clues_Group_Clue03_Btn_Clue_Click = function(btn, str)
    Item.ShowClue(3)
  end,
  Dialog_Group_Item_Group_Clues_Group_Clue04_Btn_Clue_Click = function(btn, str)
    Item.ShowClue(4)
  end,
  Dialog_Btn_TimeLine_Click = function(btn, str)
    if DataModel.TimeLineEventID > 0 then
      local event = PlayerData:GetFactoryData(DataModel.TimeLineEventID, "AFKEventFactory")
      local status = {
        Current = "Chapter",
        squadIndex = PlayerData.BattleInfo.squadIndex,
        hasOpenThreeView = false,
        levelChainId = nil,
        eventId = DataModel.TimeLineEventID
      }
      PlayerData.BattleInfo.battleStageId = event.levelId
      PlayerData.BattleCallBackPage = ""
      UIManager:Open("UI/Squads/Squads", Json.encode(status))
    end
  end,
  Dialog_Btn_PlayIcon_Click = function(btn, str)
    local newContinueState = not PlotReviewDataModel.GetAutoChapterState()
    PlotReviewDataModel.SetAutoChapter(newContinueState)
    Controller.FreshAutoChapterBtn()
  end
}
return ViewFunction
