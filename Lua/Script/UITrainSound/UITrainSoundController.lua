local View = require("UITrainSound/UITrainSoundView")
local DataModel = require("UITrainSound/UITrainSoundDataModel")
local Ctrl = {}
local CurSoundData

local function ShowCurrent()
  local CurUsingSound = tonumber(PlayerData:GetHomeInfo().train_sound) or 88100001
  CurSoundData = DataModel.GetTrainSoundData(CurUsingSound)
  if CurSoundData ~= nil then
    View.Group_Current.Txt_Name:SetText(CurSoundData.Cfg.soundName)
    View.Group_Current.Txt_Des:SetText(CurSoundData.Cfg.soundDes)
  end
end

local function RefreshList(scrollToTop, InitData)
  DataModel.InitData()
  View.Group_SoundList.Img_Title:SetSprite(GetResPath(88300084))
  if scrollToTop then
    View.Group_SoundList.ScrollGrid_SoundList.grid.self.ScrollRect.verticalNormalizedPosition = 1
  end
  View.Group_SoundList.ScrollGrid_SoundList.grid.self:SetDataCount(#DataModel.AllList)
  View.Group_SoundList.ScrollGrid_SoundList.grid.self:RefreshAllElement()
end

local function InitPanel()
  DataModel.CurPlaying = nil
  DataModel.IsPause = false
  DataModel.Sliders = {}
  Ctrl.RefreshList(true)
  Ctrl.ShowCurrent()
end

local function ShowUnlockSuccess(soundName)
  View.Group_Success:SetActive(true)
  View.Group_Success.Txt_Name:SetText(string.format(GetText(80608873), soundName))
  View.self:PlayAnim("Animation_successIn", function()
    TimerHelper.Start("UnlockTrainSoundSuccess", 1.5, function()
      View.self:PlayAnim("Animation_successOut", function()
        View.Group_Success:SetActive(false)
      end)
      TimerHelper.Stop("UnlockTrainSoundSuccess")
    end)
  end)
end

Ctrl.InitPanel = InitPanel
Ctrl.RefreshList = RefreshList
Ctrl.ShowCurrent = ShowCurrent
Ctrl.ShowUnlockSuccess = ShowUnlockSuccess
return Ctrl
