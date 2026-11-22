local View = require("UIDriveSetupIn/UIDriveSetupInView")
local DataModel = require("UIDriveSetupIn/UIDriveSetupInDataModel")
local ViewFunction = require("UIDriveSetupIn/UIDriveSetupInViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local trainCfg = PlayerData:GetFactoryData(99900064)
    local playerLv = PlayerData:GetUserInfo().lv
    local buyRoadLv = trainCfg.autoBuyRoadLv
    View.Group_BuyRoad.Group_UnLock.Txt_UnLock:SetText(string.format(GetText(80603018), buyRoadLv))
    View.Group_BuyRoad.Group_UnLock.self:SetActive(PlayerData:GetUserInfo().functional_status.money ~= 1)
    View.Group_BuyRoad.Btn_BuyRoad.Group_On.self:SetActive(PlayerData:GetHomeInfo().drive_setup.money == 1)
    local rushLv = trainCfg.autoRushLv
    View.Group_Rush.Group_UnLock.Txt_UnLock:SetText(string.format(GetText(80603018), rushLv))
    View.Group_Rush.Group_UnLock.self:SetActive(PlayerData:GetUserInfo().functional_status.rush ~= 1)
    View.Group_Rush.Btn_Rush.Group_On.self:SetActive(PlayerData:GetHomeInfo().drive_setup.rush == 1)
    local strikeLv = trainCfg.autoStrikeLv
    View.Group_Strike.Group_UnLock.Txt_UnLock:SetText(string.format(GetText(80603018), strikeLv))
    View.Group_Strike.Group_UnLock.self:SetActive(PlayerData:GetUserInfo().functional_status.assault ~= 1)
    View.Group_Strike.Btn_Strike.Group_On.self:SetActive(PlayerData:GetHomeInfo().drive_setup.assault == 1)
    local fightLv = trainCfg.autoFightLv
    View.Group_Fight.Group_UnLock.Txt_UnLock:SetText(string.format(GetText(80603018), fightLv))
    View.Group_Fight.Group_UnLock.self:SetActive(PlayerData:GetUserInfo().functional_status.bar ~= 1)
    View.Group_Fight.Btn_Fight.Group_On.self:SetActive(PlayerData:GetHomeInfo().drive_setup.bar == 1)
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
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
