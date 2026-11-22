local View = require("UIHotelLevel/UIHotelLevelView")
local DataModel = require("UIHotelLevel/UIHotelLevelDataModel")
local ViewFunction = require("UIHotelLevel/UIHotelLevelViewFunction")
local Controller = require("UIHotelLevel/UIHotelLevelController")
local Luabehaviour = {
  serialize = function()
    local t = {}
    t.curPos = DataModel.curPos
    t.curLevelIdx = DataModel.curLevelIdx
    t.isBattleReturn = DataModel.initParams.isBattleReturn
    return Json.encode(t)
  end,
  deserialize = function(initParams)
    DataModel.initParams = {}
    if initParams then
      DataModel.initParams = Json.decode(initParams)
    end
    Controller:Init()
    View.Group_ShiftBtn.Btn_In.Img_:SetSprite(GetResPath(88300135))
    View.Group_ShiftBtn.Btn_Out.Img_:SetSprite(GetResPath(88300134))
    View.Group_BG.Group_1.Img_Icon:SetSprite(GetResPath(88300137))
    View.Group_BG.Group_2.Img_Icon:SetSprite(GetResPath(88300136))
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if DataModel.toPlayFirstPassAnim and DataModel.waitToShowComplete and not LoadingManager.isLoading then
      DataModel.toPlayFirstPassAnim = false
      Controller:DoFirstPassAnim()
    end
    if DataModel.hotelLevelAutoBattle then
      DataModel.remainAutoBattleTime = DataModel.remainAutoBattleTime - 0.02
      Controller:RefreshAutoBattleRemainTime()
    end
  end,
  ondestroy = function()
    if DataModel.cacheTweenTransform[DataModel.curPos] then
      DOTweenTools.Kill(DataModel.cacheTweenTransform[DataModel.curPos])
    end
    DataModel.cacheScrollRect = nil
    DataModel.cacheTweenTransform = nil
    PlayerData:SetPlayerPrefs("int", "HotelLevelPos", DataModel.curPos)
    DataModel.toPlayFirstPassAnim = false
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
