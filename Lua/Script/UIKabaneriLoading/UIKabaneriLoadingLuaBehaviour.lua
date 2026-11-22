local View = require("UIKabaneriLoading/UIKabaneriLoadingView")
local DataModel = require("UIKabaneriLoading/UIKabaneriLoadingDataModel")
local ViewFunction = require("UIKabaneriLoading/UIKabaneriLoadingViewFunction")
local TimerHelper = require("Common/Timer/TimerHelper")
local currentSceneName
local waitTime = 0
local waitSwitch = false
local startSwitch = false
local readySwitch = false
local targetLoadingPercent, currentLoadingPercent
local loadingPercentMaxPerframe = 0.01
local mapID = 0

local function Switch()
  if not startSwitch then
    startSwitch = true
    local kbCtrl = require("UIKabaneriMain/UIKabaneriMainController")
    if kbCtrl then
      kbCtrl.SetGameReady()
    end
    local sound = SoundManager:CreateSound(30006297)
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

local function Preload()
  local kbCtrl = require("UIKabaneriMain/UIKabaneriMainController")
  if kbCtrl then
    kbCtrl.InitData()
    kbCtrl.InitMap(mapID)
    kbCtrl.Init()
  end
end

local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    mapID = Json.decode(initParams).mapID
    currentSceneName = MainManager.bgSceneName
    waitSwitch = false
    waitTime = 0
    startSwitch = false
    readySwitch = false
    currentLoadingPercent = 0
    targetLoadingPercent = 0
    View.Txt_loading.self:SetActive(true)
    ShowLoadingPersent(0)
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
      if currentSceneName == "Kabaneri" then
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
            Preload()
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
          Preload()
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
        Preload()
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
