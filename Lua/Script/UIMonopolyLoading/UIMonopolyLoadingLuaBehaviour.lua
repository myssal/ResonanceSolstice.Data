local View = require("UIMonopolyLoading/UIMonopolyLoadingView")
local DataModel = require("UIMonopolyLoading/UIMonopolyLoadingDataModel")
local ViewFunction = require("UIMonopolyLoading/UIMonopolyLoadingViewFunction")
local isLoadingFinish = false
local isPlayAni = false
local isLoopPlay = false

local function ShowLoadingPersent(percent)
  View.Group_Main:SetActive(true)
  View.Group_Txt:SetActive(false)
  View.Group_Main.Img_Loading.Txt_Num:SetText(math.floor(percent * 100))
end

local function PlayerAni()
  LoadingManager:CloseLoading()
end

local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    isLoadingFinish = false
    isLoopPlay = false
    View.Img_:SetActive(true)
    ShowLoadingPersent(0)
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if isLoadingFinish then
      if not isPlayAni then
        isPlayAni = true
        PlayerAni()
      end
      return
    end
    if LoadingManager.loadingPercent >= 1 then
      ShowLoadingPersent(1)
      isLoadingFinish = true
    else
      if LoadingManager.isLoadingInitAniFinish == true and not isLoopPlay then
        isLoopPlay = true
        View.self:PlayAnimOnce("MonopolyLoading_loop")
      end
      ShowLoadingPersent(LoadingManager.loadingPercent)
    end
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
    isLoadingFinish = false
    isPlayAni = false
    isLoopPlay = false
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
