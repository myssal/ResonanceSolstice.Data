local View = require("UIHomeStickerPromptTimes/UIHomeStickerPromptTimesView")
local DataModel = require("UIHomeStickerPromptTimes/UIHomeStickerPromptTimesDataModel")
local ViewFunction = {
  HomeStickerPromptTimes_Btn_BG_Click = function(btn, str)
  end,
  HomeStickerPromptTimes_Btn_Min_Click = function(btn, str)
    DataModel:SetSelectNum(1)
  end,
  HomeStickerPromptTimes_Btn_Dec_Click = function(btn, str)
    DataModel:SetSelectNum(math.max(1, DataModel.curSelectNum - 1))
  end,
  HomeStickerPromptTimes_Group_Slider_Slider_Value_Slider = function(slider, value)
    DataModel:OnSliderValue(value)
  end,
  HomeStickerPromptTimes_Group_Slider_Slider_Value_SliderDown = function(slider)
  end,
  HomeStickerPromptTimes_Group_Slider_Slider_Value_SliderUp = function(slider)
  end,
  HomeStickerPromptTimes_Btn_Add_Click = function(btn, str)
    DataModel:SetSelectNum(math.max(1, math.min(DataModel.maxNum, DataModel.curSelectNum + 1)))
  end,
  HomeStickerPromptTimes_Btn_Max_Click = function(btn, str)
    DataModel:SetSelectNum(DataModel.maxNum)
  end,
  HomeStickerPromptTimes_Btn_Cancel_Click = function(btn, str)
    UIManager:GoBack(false)
  end,
  HomeStickerPromptTimes_Btn_Sale_Click = function(btn, str)
    UIManager:GoBack(false)
    DataModel:DoTakePhoto()
  end
}
return ViewFunction
