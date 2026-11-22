local View = require("UILanguageSwitch/UILanguageSwitchView")
local DataModel = require("UILanguageSwitch/UILanguageSwitchDataModel")
local ViewFunction = require("UILanguageSwitch/UILanguageSwitchViewFunction")
local LanguageCtrl = require("UISetting/UISettingLanguageController")
local isText, isSV, language

local function Finish()
  if isText then
    PlayerPrefs.SetString("LanguageType", language)
    GameSetting.currentTextLanguage = language
    TranslateManager:SetTextLanguage(language)
    CommonTips.OnPromptConfirmOnly("80607171", "80600068", function()
      LanguageCtrl:GetCurrentLanguage()
      LanguageCtrl:RefreshTextList()
      LanguageCtrl:ShowCurrentText()
      LanguageCtrl:HideTextList()
      CS.GameSetting.Quit()
    end, false)
  end
  if isSV then
    PlayerPrefs.SetString("LanguageSVType", language)
    GameSetting.currentSVLanguage = language
    TranslateManager:SetSVLanguage(language)
    CommonTips.OnPromptConfirmOnly("80607170", "80600068", function()
      LanguageCtrl:GetCurrentLanguage()
      LanguageCtrl:RefreshSound()
    end, false)
  end
end

local function StartDownload()
  TranslateManager:StartDownloadRes(isText, isSV, Finish)
end

local isDownloadInfoShow = false

local function HideAll()
  View.Group_Confirm:SetActive(false)
  View.Group_DownLoad:SetActive(false)
  View.Img_Mask:SetActive(false)
  isDownloadInfoShow = false
end

local function ShowDownloadInfo()
  View.Group_DownLoad:SetActive(true)
  View.Img_Mask:SetActive(true)
  isDownloadInfoShow = true
  local p = TranslateManager.progress
  if 1 < p then
    p = 1
  end
  if p < 0 then
    p = 0
  end
  View.Group_DownLoad.Group_Slider.Img_Progress_Bar:SetFilledImgAmount(p)
end

local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    isText = false
    isSV = false
    language = nil
    if initParams ~= nil then
      local data = Json.decode(initParams)
      if data then
        if data.isText ~= nil then
          isText = data.isText
        end
        if data.isSV ~= nil then
          isSV = data.isSV
        end
        if data.language ~= nil then
          language = data.language
        end
      end
    end
    HideAll()
    if language ~= nil then
      if isText then
        GameSetting.targetTextLanguage = language
        if GameSetting.isTextAutoHotfix then
          Finish()
        else
          StartDownload()
        end
      elseif isSV then
        GameSetting.targetSVLanguage = language
        StartDownload()
      end
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if TranslateManager.progress > 0 then
      ShowDownloadInfo()
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
