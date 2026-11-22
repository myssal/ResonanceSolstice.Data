local View = require("UIActivityMain/UIActivityMainView")
local DataModel = require("UIActivityMain/UIActivityMainDataModel")
local Controller = require("UIActivityMain/UIActivityMainController")
local ViewFunction = require("UIActivityMain/UIActivityMainViewFunction")
local Timer = require("Common/Timer")
local Luabehaviour = {
  serialize = function()
    local parms = {}
    parms.tabIndex = DataModel.TabIndex
    parms.index = DataModel.ChooseLeftIndex
    parms.id = DataModel.LeftActivityCA.id
    parms.backToHome = DataModel.backToHome
    parms.isGoback = true
    return Json.encode(parms)
  end,
  deserialize = function(initParams)
    if CommonTips.GuideAsset() then
      UIManager:GoBack()
      return
    end
    local index, id
    DataModel.Init()
    if initParams then
      local parms = Json.decode(initParams)
      index = parms.index
      id = parms.id
      DataModel.backToHome = parms.backToHome
      DataModel.isGoback = parms.isGoback
      DataModel.isCityMapIn = parms.isCityMapIn
      if parms.tabIndex then
        DataModel.TabIndex = parms.tabIndex
      end
    end
    DataModel.RefreshActivityData()
    Controller:Init(id)
    if DataModel.ActivitySignNextRefreshTimeStamp > 0 then
      View.timer = Timer.New(1, function()
        if DataModel.ActivitySignNextRefreshTimeStamp > 0 then
          if TimeUtil:GetServerTimeStamp() >= DataModel.ActivitySignNextRefreshTimeStamp then
            CommonTips.OpenTips(80609982)
            UIManager:GoHome()
            return
          end
        elseif View.timer then
          View.timer:Stop()
          View.timer = nil
        end
      end)
    end
    if View.timer then
      View.timer:Start()
    end
    if DataModel.LeftTimeList and table.count(DataModel.LeftTimeList) > 0 then
      View.timer_list = Timer.New(1, function(...)
        if DataModel.isRefresh == false then
          return
        end
        for k, v in pairs(DataModel.LeftTimeList) do
          if v.time > 0 then
            local berfore_Time = TimeUtil:SecondToTable(v.time)
            local berfore_Hour = berfore_Time.hour
            local berfore_Day = berfore_Time.day
            v.time = v.time - 1
            local current_Time = TimeUtil:SecondToTable(v.time)
            local current_Hour = current_Time.hour
            local current_Day = current_Time.day
            if 0 < berfore_Day then
              if berfore_Day ~= current_Day then
                Controller:RefreshLeftList(v.id)
                return
              end
            elseif berfore_Hour ~= current_Hour then
              Controller:RefreshLeftList(v.id)
              return
            end
          elseif v.time == 0 then
            v.time = v.time - 1
            Controller:RefreshLeftList(v.id)
            return
          end
        end
      end)
    end
    if View.timer_list then
      View.timer_list:Start()
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if View.timer ~= nil then
      View.timer:Update()
    end
    if View.timer_list ~= nil then
      View.timer_list:Update()
    end
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
    if View.timer ~= nil then
      View.timer:Stop()
      View.timer = nil
    end
    if View.timer_list ~= nil then
      View.timer_list:Stop()
      View.timer_list = nil
    end
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
