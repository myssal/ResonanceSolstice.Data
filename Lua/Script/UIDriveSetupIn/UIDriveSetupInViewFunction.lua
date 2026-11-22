local View = require("UIDriveSetupIn/UIDriveSetupInView")
local DataModel = require("UIDriveSetupIn/UIDriveSetupInDataModel")
local ViewFunction = {
  DriveSetupIn_Btn_BG_Click = function(btn, str)
    UIManager:GoBack(false)
  end,
  DriveSetupIn_Group_BuyRoad_Btn_BuyRoad_Click = function(btn, str)
    local trainCfg = PlayerData:GetFactoryData(99900064)
    if PlayerData:GetUserInfo().lv < trainCfg.autoBuyRoadLv then
      CommonTips.OpenTips(string.format(GetText(80602796), trainCfg.autoBuyRoadLv))
      return
    end
    local isAuto = PlayerData:GetHomeInfo().drive_setup.money == 0 and 1 or 0
    Net:SendProto("home.update_drive_setup", function(json)
      PlayerData:SetPlayerPrefs("int", "IsAutoBuyRoad", 0)
      PlayerData:GetHomeInfo().drive_setup.money = isAuto
      View.Group_BuyRoad.Btn_BuyRoad.Group_On.self:SetActive(PlayerData:GetHomeInfo().drive_setup.money == 1)
    end, "money", isAuto)
  end,
  DriveSetupIn_Group_Fight_Btn_Fight_Click = function(btn, str)
    local trainCfg = PlayerData:GetFactoryData(99900064)
    if PlayerData:GetUserInfo().lv < trainCfg.autoFightLv then
      CommonTips.OpenTips(string.format(GetText(80602796), trainCfg.autoFightLv))
      return
    end
    local isAuto = PlayerData:GetHomeInfo().drive_setup.bar == 0 and 1 or 0
    Net:SendProto("home.update_drive_setup", function(json)
      PlayerData:SetPlayerPrefs("int", "IsAutoFight", 0)
      PlayerData:GetHomeInfo().drive_setup.bar = isAuto
      View.Group_Fight.Btn_Fight.Group_On.self:SetActive(PlayerData:GetHomeInfo().drive_setup.bar == 1)
    end, "bar", isAuto)
  end,
  DriveSetupIn_Group_Balloon_Btn_Balloon_Click = function(btn, str)
    PlayerData:SetPlayerPrefs("int", "IsAutoBalloon", PlayerData:GetPlayerPrefs("int", "IsAutoBalloon") == 0 and 1 or 0)
    View.Group_Balloon.Btn_Balloon.Group_On.self:SetActive(PlayerData:GetPlayerPrefs("int", "IsAutoBalloon") == 1)
  end,
  DriveSetupIn_Group_Strike_Btn_Strike_Click = function(btn, str)
    local trainCfg = PlayerData:GetFactoryData(99900064)
    if PlayerData:GetUserInfo().lv < trainCfg.autoStrikeLv then
      CommonTips.OpenTips(string.format(GetText(80602796), trainCfg.autoStrikeLv))
      return
    end
    local isAuto = PlayerData:GetHomeInfo().drive_setup.assault == 0 and 1 or 0
    Net:SendProto("home.update_drive_setup", function(json)
      PlayerData:SetPlayerPrefs("int", "IsAutoStrike", 0)
      PlayerData:GetHomeInfo().drive_setup.assault = isAuto
      View.Group_Strike.Btn_Strike.Group_On.self:SetActive(PlayerData:GetHomeInfo().drive_setup.assault == 1)
    end, "assault", isAuto)
  end,
  DriveSetupIn_Group_Rush_Btn_Rush_Click = function(btn, str)
    local trainCfg = PlayerData:GetFactoryData(99900064)
    if PlayerData:GetUserInfo().lv < trainCfg.autoRushLv then
      CommonTips.OpenTips(string.format(GetText(80602796), trainCfg.autoRushLv))
      return
    end
    local isAuto = PlayerData:GetHomeInfo().drive_setup.rush == 0 and 1 or 0
    Net:SendProto("home.update_drive_setup", function(json)
      PlayerData:SetPlayerPrefs("int", "autoUseBullet", 0)
      PlayerData:GetHomeInfo().drive_setup.rush = isAuto
      View.Group_Rush.Btn_Rush.Group_On.self:SetActive(PlayerData:GetHomeInfo().drive_setup.rush == 1)
      local MainUIDataModel = require("UIMainUI/UIMainUIDataModel")
      MainUIDataModel.autoUseBullet = PlayerData:GetHomeInfo().drive_setup.rush ~= 0
    end, "rush", isAuto)
  end,
  DriveSetupIn_Group_EnterStation_Btn_EnterStation_Click = function(btn, str)
    local trainCfg = PlayerData:GetFactoryData(99900064)
    if PlayerData:GetUserInfo().lv < trainCfg.autoEnterStationLv then
      CommonTips.OpenTips(string.format(GetText(80602796), trainCfg.autoEnterStationLv))
      return
    end
    PlayerData:SetPlayerPrefs("int", "IsAutoEnterStation", PlayerData:GetPlayerPrefs("int", "IsAutoEnterStation") == 0 and 1 or 0)
    View.Group_EnterStation.Btn_EnterStation.Group_On.self:SetActive(PlayerData:GetPlayerPrefs("int", "IsAutoEnterStation") == 1)
  end,
  DriveSetupIn_Group_BuyRoad_Group_UnLock_Btn_UnLock_Click = function(btn, str)
    local trainCfg = PlayerData:GetFactoryData(99900064)
    if PlayerData:GetUserInfo().lv < trainCfg.autoBuyRoadLv then
      CommonTips.OpenTips(string.format(GetText(80602931), trainCfg.autoBuyRoadLv))
      return
    end
    local t = {}
    t.textId = 80602920
    t.cost = "autoBuyRoadUnLock"
    t.iconPath = PlayerData:GetFactoryData(99900064).autoBuyRoadPath
    t.setUpType = "money"
    UIManager:Open("UI/MainUI/DriveSetupUnlock", Json.encode(t))
  end,
  DriveSetupIn_Group_Rush_Group_UnLock_Btn_UnLock_Click = function(btn, str)
    local trainCfg = PlayerData:GetFactoryData(99900064)
    if PlayerData:GetUserInfo().lv < trainCfg.autoRushLv then
      CommonTips.OpenTips(string.format(GetText(80602931), trainCfg.autoRushLv))
      return
    end
    local t = {}
    t.textId = 80602609
    t.cost = "autoRushUnLock"
    t.iconPath = PlayerData:GetFactoryData(99900064).autoRushPath
    t.setUpType = "rush"
    UIManager:Open("UI/MainUI/DriveSetupUnlock", Json.encode(t))
  end,
  DriveSetupIn_Group_Strike_Group_UnLock_Btn_UnLock_Click = function(btn, str)
    local trainCfg = PlayerData:GetFactoryData(99900064)
    if PlayerData:GetUserInfo().lv < trainCfg.autoStrikeLv then
      CommonTips.OpenTips(string.format(GetText(80602931), trainCfg.autoStrikeLv))
      return
    end
    local t = {}
    t.textId = 80602921
    t.cost = "aautoStrikeUnLock"
    t.iconPath = PlayerData:GetFactoryData(99900064).autoStrikePath
    t.setUpType = "assault"
    UIManager:Open("UI/MainUI/DriveSetupUnlock", Json.encode(t))
  end,
  DriveSetupIn_Group_Fight_Group_UnLock_Btn_UnLock_Click = function(btn, str)
    local trainCfg = PlayerData:GetFactoryData(99900064)
    if PlayerData:GetUserInfo().lv < trainCfg.autoFightLv then
      CommonTips.OpenTips(string.format(GetText(80602931), trainCfg.autoFightLv))
      return
    end
    local t = {}
    t.textId = 80602919
    t.cost = "autoFightUnLock"
    t.iconPath = PlayerData:GetFactoryData(99900064).autoFightPath
    t.setUpType = "bar"
    UIManager:Open("UI/MainUI/DriveSetupUnlock", Json.encode(t))
  end,
  DriveSetupIn_Group_EnterStation_Group_UnLock_Btn_UnLock_Click = function(btn, str)
    local trainCfg = PlayerData:GetFactoryData(99900064)
    if PlayerData:GetUserInfo().lv < trainCfg.autoEnterStationLv then
      CommonTips.OpenTips(string.format(GetText(80602931), trainCfg.autoEnterStationLv))
      return
    end
    local t = {}
    t.textId = 80607588
    t.cost = "autoEnterStationUnLock"
    t.iconPath = PlayerData:GetFactoryData(99900064).autoEnterStationPath
    t.setUpType = "enter"
    UIManager:Open("UI/MainUI/DriveSetupUnlock", Json.encode(t))
  end
}
return ViewFunction
