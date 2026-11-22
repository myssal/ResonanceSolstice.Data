local View = require("UILogin/UILoginView")
local Controller = require("UILogin/UILoginController")
local ViewFunction = require("UILogin/UILoginViewFunction")
local DataModel = require("UILogin/UILoginDataModel")
local Listener = require("UILogin/UILoginListener")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Controller:InitView(ViewFunction)
    Listener:Start()
    PlayerData:SetSound()
    local text = HotfixSetting.serverPatchVersion
    if GameSetting.buildModeStr == "Debug" then
      text = "\229\185\179\229\143\176: " .. GameSetting.platform .. "\232\181\132\230\186\144\230\156\141\229\138\161\229\153\168: " .. GameSetting.fromRes .. [[

App: ]] .. HotfixSetting.clientAppVersion .. [[

Res: ]] .. text .. "\n\230\156\141\229\138\161\229\153\168: " .. GameSetting.serverAdress .. ":" .. GameSetting.serverPort
    else
      text = "App: " .. HotfixSetting.clientAppVersion .. [[

Res: ]] .. text
    end
    View.Txt_Version:SetText(text)
    local isShowUserCenter = LoginHelper.IsShowUserCenter()
    local isShowService = LoginHelper.IsShowService()
    Controller:SetActiveBtnUserCenter(isShowUserCenter)
    Controller:SetActiveBtnServices(isShowService)
    LoginHelper.BeforeLoginInit()
    if LoginHelper.IsUseChannelLogin() then
      PhoneIDLogin = false
      View.Group_LoginAndJoin:SetActive(false)
      LoginHelper.StartChannelLogin()
    else
      ViewFunction.Login_Btn_Login_Click()
    end
    local bgSoundId
    for k, v in pairs(PlayerData:GetFactoryData(99900002).uiBgmList) do
      if v.PrefabUrl == "UI\\Login\\Login" then
        bgSoundId = v.soundId
      end
    end
    if bgSoundId ~= nil then
      local sound = SoundManager:CreateSound(bgSoundId)
      if sound ~= nil then
        sound:Play()
      end
    end
    local titleId = PlayerData:GetFactoryData(99900002).loginMusicTitle
    View.Group_MusicTip.Txt_:SetText(string.format(GetText(titleId)))
    DataModel.IsDown = true
    DataModel.IsMaxData = 6
    DataModel.ChangeButtonState()
    PlayerData:RestData()
    DataModel.firstFrame = true
    View.Img_Logo:SetSprite(GetResPath(88300012))
    View.Btn_AgeTip:SetSprite(GetResPath(88300088))
    if SdkRegionHelper.IsRegionKR() and PlatformHelper.IsIPhone() then
      View.Btn_AgeTip:SetSprite(GetResPath(88300294))
    end
    View.Group_Account.Btn_Community:SetSprite(GetResPath(88300280))
    if GameSetting.isInOriginPack ~= nil and GameSetting.isInOriginPack == true then
      View.Group_Account.Btn_Notice:SetActive(false)
    else
    end
  end,
  awake = function()
  end,
  start = function()
    LoadingManager:CloseLoading()
  end,
  update = function()
    if DataModel.firstFrame then
      View.Video_Login:Play(GetResPath(88300002), true, false, false)
      DataModel.firstFrame = false
    end
  end,
  ondestroy = function()
    Listener:Stop()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
