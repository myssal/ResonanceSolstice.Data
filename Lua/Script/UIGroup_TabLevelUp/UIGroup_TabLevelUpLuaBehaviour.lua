local View = require("UIGroup_TabLevelUp/UIGroup_TabLevelUpView")
local DataModel = require("UIGroup_TabLevelUp/UIGroup_TabLevelUpDataModel")
local ViewFunction = require("UIGroup_TabLevelUp/UIGroup_TabLevelUpViewFunction")
local Controller = require("UIGroup_TabLevelUp/UIGroup_TabLevelUpController")
local params
local Luabehaviour = {
  serialize = function()
    return params
  end,
  deserialize = function(initParams)
    params = initParams
    local data = Json.decode(initParams)
    DataModel.RoleId = data.roleId
    DataModel.RoleData = PlayerData:GetRoleById(data.roleId)
    DataModel.RoleCA = PlayerData:GetFactoryData(data.roleId)
    DataModel.AwakeMaxLevel = math.min(PlayerData:GetRoleLvMax(data.roleId))
    DataModel.ShowUI = data.ui
    DataModel.Index = data.index or 1
    if data.squad then
      DataModel.curSquad = {}
      for i = 1, #data.squad do
        if not data.squad[i].isHelpRole and not data.squad[i].isLevelRole and data.squad[i].lv and data.squad[i].lv < DataModel.AwakeMaxLevel then
          DataModel.curSquad[#DataModel.curSquad + 1] = data.squad[i].unitId
        end
      end
    else
      DataModel.curSquad = nil
    end
    Controller:Load()
    if data.isBreak then
      Controller:OpenLvCapBreak()
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if DataModel.lock_Add == true then
      DataModel.click_time = DataModel.click_time + Time.fixedDeltaTime
      if DataModel.click_time > 0.3 then
        DataModel.lock_Add = false
      end
    end
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
