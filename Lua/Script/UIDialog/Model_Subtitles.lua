local view = require("UIDialog/UIDialogView")
local base = require("UIDialog/Model_PlotBase")
local Subtitles = Class.New("PlotSubtitles", base)
local DataModel = require("UIDialog/UIDialogDataModel")
local finishSequence = false
local finishContent = false
local finish = false
local pause = false
local Txt_Subtitles, Img_Up, Img_Down, Img_Mask, data
local currentDelay = 0
local timer = 0
local lastEffect = ""
local sequence

function Subtitles:Ctor()
  view.Group_Subtitles:SetActive(true)
  Txt_Subtitles = view.Group_Subtitles.Txt_Subtitles
  Img_Up = view.Group_Subtitles.Img_Up
  Img_Down = view.Group_Subtitles.Img_Down
  Img_Mask = view.Group_Subtitles.Img_Mask
end

local function SetContent()
  local content = data.content or ""
  Txt_Subtitles:SetActive(true)
  Txt_Subtitles:SetLocalPosition(Vector3(data.X, data.Y, 0))
  Txt_Subtitles:SetTweenContent(content, function()
    finishContent = true
  end, DataModel.GetCurrentScaleValue(DataModel.perCharSpeed))
end

local function ExchangeEffect()
  local effect = data.exchangeEffect
  local fadeDuration = DataModel.GetCurrentScaleValue(data.fadeDuration)
  if lastEffect == effect then
    if effect == "Fadein" then
      SetContent()
    end
    finishSequence = true
    return
  end
  local isClose = effect == "Null"
  Img_Up:SetActive(not isClose)
  Img_Down:SetActive(not isClose)
  if isClose then
    Img_Mask:SetActive(false)
    finishSequence = true
    finishContent = true
    finish = true
    view.Group_Subtitles:SetActive(false)
  elseif effect == "Fadein" then
    Txt_Subtitles:SetAlpha(1)
    Img_Up:SetAlpha(0)
    Img_Down:SetAlpha(0)
    if sequence ~= nil then
      DOTweenTools.KillSequence(sequence)
    end
    sequence = DOTweenTools.NewSequence()
    sequence:Join(DOTweenTools.DOFadeCallback(Img_Up.transform, 0, 1, fadeDuration)):Join(DOTweenTools.DOFadeCallback(Img_Down.transform, 0, 1, fadeDuration)):OnComplete(function()
      Img_Mask:SetActive(true)
      SetContent()
      finishSequence = true
    end)
  elseif effect == "FadeOut" then
    if sequence ~= nil then
      DOTweenTools.KillSequence(sequence)
    end
    Img_Up:SetAlpha(1)
    Img_Down:SetAlpha(1)
    sequence = DOTweenTools.NewSequence()
    sequence:Join(DOTweenTools.DOFadeCallback(Img_Up.transform, 1, 0, fadeDuration)):Join(DOTweenTools.DOFadeCallback(Img_Down.transform, 1, 0, fadeDuration)):Join(Txt_Subtitles:SetTweenFade(0, fadeDuration, nil)):OnComplete(function()
      Img_Mask:SetActive(false)
      finishSequence = true
      finishContent = true
      finish = true
      view.Group_Subtitles:SetActive(false)
    end)
  end
  lastEffect = effect
end

function Subtitles:PauseTween()
  if Txt_Subtitles ~= nil and not finishContent then
    Txt_Subtitles:PauseTween()
    pause = true
  end
  if sequence ~= nil and not finishSequence then
    sequence:Pause()
    pause = true
  end
end

function Subtitles:ContinueTween()
  if Txt_Subtitles ~= nil and not finishContent then
    Txt_Subtitles:PlayTween()
    pause = false
  end
  if sequence ~= nil and not finishSequence then
    sequence:Play()
    pause = false
  end
end

function Subtitles:OnStart(ca)
  sequence = nil
  finishSequence = false
  finishContent = false
  pause = false
  finish = false
  timer = 0
  currentDelay = DataModel.GetCurrentScaleValue(DataModel.intervalTime)
  data = ca
  Txt_Subtitles:SetText("")
  ExchangeEffect()
end

function Subtitles.OnUpdate()
  if pause then
    return
  end
  if Input.GetMouseButtonDown(0) then
    if Txt_Subtitles.IsActive and not finishContent then
      Txt_Subtitles:CompleteTween()
    end
    if sequence ~= nil and not finishSequence then
      DOTweenTools.Complete(sequence)
    end
    if finishSequence and finishContent then
      finish = true
    end
  end
  if DataModel.GetIsAuto() and not finish and finishSequence and finishContent then
    timer = timer + Time.deltaTime
    if timer > currentDelay then
      finish = true
    end
  end
  if finish and DataModel.isAutoCloseSubtitles then
    view.Group_Subtitles:SetActive(false)
  end
  DataModel.SkipCurrentNode(function()
    if not finish then
      currentDelay = DataModel.GetCurrentScaleValue(DataModel.intervalTime)
      if sequence ~= nil then
        DOTweenTools.Complete(sequence)
      end
      if Txt_Subtitles ~= nil and not finishContent then
        Txt_Subtitles:CompleteTween()
      end
      view.Group_Subtitles:SetActive(false)
    end
  end)
end

function Subtitles.GetState()
  return finish
end

function Subtitles:Dtor()
  if sequence ~= nil then
    DOTweenTools.KillSequence(sequence)
    sequence = nil
  end
end

return Subtitles
