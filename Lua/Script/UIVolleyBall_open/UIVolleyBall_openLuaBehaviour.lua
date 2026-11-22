local View = require("UIVolleyBall_open/UIVolleyBall_openView")
local DataModel = require("UIVolleyBall_open/UIVolleyBall_openDataModel")
local ViewFunction = require("UIVolleyBall_open/UIVolleyBall_openViewFunction")
local params
local Luabehaviour = {
  serialize = function()
    return params
  end,
  deserialize = function(initParams)
    local isActivity = false
    params = initParams
    if initParams then
      local data = Json.decode(initParams)
      isActivity = data.isActivity
    end
    DataModel.Init(isActivity)
    local gameModeIsStart = DataModel.GameModeIsStart()
    View.Img_Mask2:SetActive(not gameModeIsStart)
    View.Btn_2:SetActive(gameModeIsStart)
    View.Btn_2.Img_TimeBG.Txt_Time:SetText(DataModel.GetRemainTime())
    View.Btn_2.Img_Num.Txt_Num:SetText(string.format(GetText(80607860), DataModel.remainCnt, DataModel.maxCnt))
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
