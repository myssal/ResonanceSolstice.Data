local View = require("UIVolleyBallMain_loading/UIVolleyBallMain_loadingView")
local DataModel = require("UIVolleyBallMain_loading/UIVolleyBallMain_loadingDataModel")
local ViewFunction = require("UIVolleyBallMain_loading/UIVolleyBallMain_loadingViewFunction")
local TimerHelper = require("Common/Timer/TimerHelper")
local currentSceneName
local waitTime = 0
local waitSwitch = false
local startSwitch = false
local readySwitch = false
local targetLoadingPercent, currentLoadingPercent
local loadingPercentMaxPerframe = 0.01

local function Switch()
  if not startSwitch then
    startSwitch = true
    local TimerHelper = require("Common/Timer/TimerHelper")
    TimerHelper.Start("VolleyballStartGame", 0.02, function()
      if UIManager:IsPanelOpened("UI/VolleyBall/VolleyBallMain") then
        local vbCtrl = require("UIVolleyBallMain/UIVolleyBallMainController")
        if vbCtrl then
          vbCtrl.ShowGameStart()
        end
        local vbDataModel = require("UIVolleyBallMain/UIVolleyBallMainDataModel")
        vbDataModel.VolleyGameManager.CameraCtrl.ViewDistance = 17
        vbDataModel.VolleyGameManager.CameraCtrl.SmoothTime = 0.05
        vbDataModel.VolleyGameManager.CameraCtrl.Custom_FovMaxSpeed = 10
        TimerHelper.Stop("VolleyballStartGame")
      end
    end)
    local sound = SoundManager:CreateSound(30005400)
    CheckLoopSound(sound)
    LoadingManager:CloseLoading()
    View.Txt_loading.self:SetActive(false)
  end
end

local function ShowLoadingPersent(percent)
  View.Img_LinkDown:SetFilledImgAmount(percent)
  View.Img_LinkUp:SetFilledImgAmount(percent)
  View.Txt_loading.Txt_percentage:SetText(math.floor(percent * 100) .. "%")
end

local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    currentSceneName = MainManager.bgSceneName
    waitSwitch = false
    waitTime = 0
    startSwitch = false
    readySwitch = false
    currentLoadingPercent = 0
    targetLoadingPercent = 0
    View.Txt_loading.self:SetActive(true)
    ShowLoadingPersent(0)
    local sound = SoundManager:CreateSound(30005399)
    CheckLoopSound(sound)
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if startSwitch then
      return
    end
    if readySwitch then
      if waitTime < 1 then
        waitTime = waitTime + Time.deltaTime
      else
        waitTime = 0
        Switch()
      end
      return
    end
    if 1 <= LoadingManager.loadingPercent then
      if currentSceneName == "VolleyBallScene" then
        if not waitSwitch then
          waitSwitch = true
          waitTime = 0
        end
        if waitSwitch then
          if waitTime < 1 then
            waitTime = waitTime + Time.deltaTime
            ShowLoadingPersent(waitTime)
          else
            waitSwitch = false
            waitTime = 0
            readySwitch = true
          end
        end
      else
        targetLoadingPercent = 1
        if currentLoadingPercent < targetLoadingPercent then
          currentLoadingPercent = currentLoadingPercent + loadingPercentMaxPerframe
        end
        if currentLoadingPercent > targetLoadingPercent then
          currentLoadingPercent = targetLoadingPercent
        end
        ShowLoadingPersent(currentLoadingPercent)
        if 1 <= currentLoadingPercent then
          readySwitch = true
          waitTime = 0
        end
      end
    else
      targetLoadingPercent = LoadingManager.loadingPercent
      if 0.89 <= targetLoadingPercent then
        targetLoadingPercent = 1
      end
      if currentLoadingPercent < targetLoadingPercent then
        currentLoadingPercent = currentLoadingPercent + loadingPercentMaxPerframe
      end
      if currentLoadingPercent > targetLoadingPercent then
        currentLoadingPercent = targetLoadingPercent
      end
      ShowLoadingPersent(currentLoadingPercent)
      if 1 <= currentLoadingPercent then
        readySwitch = true
        waitTime = 0
      end
    end
  end,
  ondestroy = function()
    startSwitch = false
  end,
  enable = function()
  end,
  disenable = function()
    startSwitch = false
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
