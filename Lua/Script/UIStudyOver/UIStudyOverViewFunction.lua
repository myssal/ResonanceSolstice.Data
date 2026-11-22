local View = require("UIStudyOver/UIStudyOverView")
local DataModel = require("UIStudyOver/UIStudyOverDataModel")
local ViewFunction = {
  StudyOver_Btn_Close_Click = function(btn, str)
    View.self:CloseUI()
  end
}
return ViewFunction
