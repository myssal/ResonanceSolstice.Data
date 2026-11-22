local View = require("UITrainSound/UITrainSoundView")
local DataModel = require("UITrainSound/UITrainSoundDataModel")
local ViewFunction = require("UITrainSound/UITrainSoundViewFunction")
local Controller = require("UITrainSound/UITrainSoundController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Controller.InitPanel()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if DataModel.IsPause then
      return
    end
    if DataModel.CurPlaySound then
      if DataModel.CurPlaySound.IsStop then
        DataModel.Sliders[DataModel.CurPlaying]:SetSliderValue(0)
        DataModel.CurPlaySound = nil
        DataModel.CurPlaying = nil
        DataModel.IsPause = false
        View.Group_SoundList.ScrollGrid_SoundList.grid.self:RefreshAllElement()
        return
      end
      if DataModel.CurPlaySound.audioSource and DataModel.CurPlaySound.audioSource.clip then
        local audioSource = DataModel.CurPlaySound.audioSource
        local persent = math.min(1, audioSource.time / audioSource.clip.length)
        DataModel.Sliders[DataModel.CurPlaying]:SetSliderValue(persent)
      end
    end
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
    if DataModel.CurPlaySound then
      DataModel.CurPlaySound:Stop()
      DataModel.CurPlaySound = nil
    end
    DataModel.CurPlaying = nil
    DataModel.IsPause = false
    DataModel.Sliders = nil
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
