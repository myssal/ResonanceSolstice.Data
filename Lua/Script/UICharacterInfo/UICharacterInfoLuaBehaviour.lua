local View = require("UICharacterInfo/UICharacterInfoView")
local ViewFunction = require("UICharacterInfo/UICharacterInfoViewFunction")
local DataModel = require("UICharacterInfo/DataModel")
local BtnController = require("UICharacterInfo/Model_Btn")
local EquipDataCache = require("UICharacterInfo/Data_EquipDataCache")
local Background = require("UICharacterInfo/ViewBackground")
local BreakThroughLoader = require("UICharacterInfo/ViewBreakThrough")
local AwakeLoader = require("UICharacterInfo/ViewAwake")
local InfoLoader = require("UICharacterInfo/ViewInfo")
local SkillLoader = require("UICharacterInfo/ViewSkill")
local ResonanceLoader = require("UICharacterInfo/ViewResonance")
local ResonanceOneKey = require("UICharacterInfo/ViewResonanceOneKey")
DataModel.SerializeData = {}
DataModel.openFilePanel = false
local Luabehaviour = {
  serialize = function()
    return Json.encode(DataModel.SerializeData)
  end,
  deserialize = function(initParams)
    ResonanceOneKey.Initialize()
    local param = {}
    if initParams ~= nil and initParams ~= "" then
      param = Json.decode(initParams)
    end
    DataModel.fromView = param.fromView
    DataModel.current = param.current
    DataModel.TableIndex = param.index or 1
    DataModel.sortType = param.sortType
    DataModel.IsSquad = param.IsSquad or false
    DataModel.SquadsRoleList = param.SquadsRoleList or {}
    View.self:PlayAnim("In", function()
    end)
    DataModel.SerializeData = param
    DataModel.openFilePanel = false
    DataModel.InitState = true
    DataModel.InitAnimatorState = true
    DataModel.isOpenSkin = false
    DataModel.RoleId = nil
    BtnController.InitSortRoles(param)
    if EquipDataCache.RoleId ~= DataModel.RoleId then
      EquipDataCache:Init(DataModel.RoleData)
    end
    ViewFunction.Init_Show_Active_Page()
    Background:Load()
    View.Group_TabAwake.Btn_CloseCheck:SetActive(false)
    View.Group_Middle.Img_BlackMask:SetActive(false)
    View.Group_SkillCheck.self:SetActive(false)
    View.Group_CommonTopLeft:SetActive(true)
    local showHomeBtn = not MapNeedleEventData.scene and not WitchData.inWitchMap
    View.Group_CommonTopLeft.Btn_Home:SetActive(showHomeBtn)
    local cfg = PlayerData:GetFactoryData(99900053, "ConfigFactory")
    local unitCA = PlayerData:GetFactoryData(DataModel.RoleId, "UnitFactory")
    View.Group_TabInfo.Group_TIBottomLeft.Btn_team:SetActive(cfg.wikiUzlUI and unitCA.teamUzlShow)
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    ResonanceOneKey.Update()
    if DataModel.lock_Add == true then
      DataModel.click_time = DataModel.click_time + Time.fixedDeltaTime
      if DataModel.click_time > 0.3 then
        DataModel.lock_Add = false
      end
    end
    DataModel.SpineBgFollow()
  end,
  ondestroy = function()
    ResonanceOneKey.Destroy()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
