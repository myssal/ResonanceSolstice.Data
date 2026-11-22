local View = require("UITrailerSpeedAdd/UITrailerSpeedAddView")
local DataModel = require("UITrailerSpeedAdd/UITrailerSpeedAddDataModel")
local ViewFunction = require("UITrailerSpeedAdd/UITrailerSpeedAddViewFunction")

local function Init()
  DataModel.use = {}
  local trailerLv = PlayerData:GetHomeInfo().back_lv
  local trailerConfig = PlayerData:GetFactoryData(99900060, "ConfigFactory")
  local trailerMaxLv = trailerConfig.trailerMaxLv
  local trailerList = trailerConfig.trailerList
  local trailer = trailerList[trailerLv + 1]
  View.Group_Lv.Txt_LvBefore:SetText(tostring(trailerLv))
  View.Group_Speed.Txt_SpeedNow:SetText(tostring(trailer.speedMax))
  View.Group_Count.Txt_CountNow:SetText(tostring(trailer.trailerExtra))
  if trailerLv < trailerMaxLv then
    local trailerNext = trailerList[trailerLv + 2]
    View.Group_Lv.Txt_LvAfter:SetText(tostring(trailerLv + 1))
    View.Group_Speed.Txt_SpeedAdd:SetText(tostring(trailerNext.speedMax))
    View.Group_Count.Txt_CountAdd:SetText(tostring(trailerNext.trailerExtra))
    local trailerUpgradeCost = trailerConfig.trailerUpgradeCost
    local listId = trailerUpgradeCost[trailerLv + 1].id
    local ListConfig = PlayerData:GetFactoryData(listId, "ListFactory")
    local costList = ListConfig.goodsList
    View.Group_List.ScrollGrid_List.grid.self:SetDataCount(#costList)
    View.Group_List.ScrollGrid_List.grid.self:RefreshAllElement()
  else
    View.Group_Lv.Txt_LvAfter:SetText("-")
    View.Group_Speed.Txt_SpeedAdd:SetText("-")
    View.Group_List.ScrollGrid_List.grid.self:SetDataCount(0)
    View.Group_List.ScrollGrid_List.grid.self:RefreshAllElement()
  end
end

local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Init()
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
