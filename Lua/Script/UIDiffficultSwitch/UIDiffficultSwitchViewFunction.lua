local View = require("UIDiffficultSwitch/UIDiffficultSwitchView")
local DataModel = require("UIDiffficultSwitch/UIDiffficultSwitchDataModel")
local Controller = require("UIDiffficultSwitch/UIDiffficultSwitchController")
local ViewFunction = {
  DiffficultSwitch_Slider_BG_Slider = function(slider, value)
    Controller:OnSliderViewValChanged(value)
  end,
  DiffficultSwitch_Slider_BG_SliderDown = function(slider)
  end,
  DiffficultSwitch_Slider_BG_SliderUp = function(slider)
  end,
  DiffficultSwitch_Slider_Difficulty_Slider = function(slider, value)
    Controller:SetSliderViewTargetValue(value)
  end,
  DiffficultSwitch_Slider_Difficulty_SliderDown = function(slider)
  end,
  DiffficultSwitch_Slider_Difficulty_SliderUp = function(slider)
    Controller:OnSliderUp(slider)
  end,
  DiffficultSwitch_Btn_Affirm_Click = function(btn, str)
    local oldDifficulty = PlayerData:GetLevelDifficulty(DataModel.levelId)
    local newDifficulty = DataModel.difficulty
    if oldDifficulty ~= newDifficulty then
      PlayerData:SetLevelDifficulty(DataModel.levelId, newDifficulty)
      View.self:Confirm()
    end
    UIManager:GoBack(false)
  end,
  DiffficultSwitch_Group_Item_Btn__Click = function(btn, str)
  end,
  DiffficultSwitch_StaticGrid_Select_SetGrid = function(element, elementIndex)
    Controller:OnSetStaticGrid(element, elementIndex)
  end,
  DiffficultSwitch_StaticGrid_Select_Group_Item_Btn__Click = function(btn, str)
    Controller:SetDifficulty(tonumber(str))
    View.Slider_Difficulty:SetSliderValue(DataModel.difficultyProgList[tonumber(str)])
  end
}
return ViewFunction
