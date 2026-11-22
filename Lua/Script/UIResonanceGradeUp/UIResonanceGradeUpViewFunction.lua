local View = require("UIResonanceGradeUp/UIResonanceGradeUpView")
local DataModel = require("UIResonanceGradeUp/UIResonanceGradeUpDataModel")
local ViewFunction = {
  ResonanceGradeUp_Btn__Click = function(btn, str)
    UIManager:CloseTip("UI/CharacterInfo/GradeUp/ResonanceGradeUp")
  end
}
return ViewFunction
