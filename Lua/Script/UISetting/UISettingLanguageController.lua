local View = require("UISetting/UISettingView")
local LanguageController = {}
local currentTextLanguage = "?"
local textList = {}
local currentSoundLanguage = "?"
local soundList = {}

function LanguageController:SetTextList(element, elementIndex)
  if elementIndex <= #textList then
    local languageType = textList[elementIndex].languageType
    local language = textList[elementIndex].languageDetail
    element.Img_Activated.Txt_Language:SetText(language)
    element.Btn_Activate.Txt_Language:SetText(language)
    if language == currentTextLanguage then
      element.Img_Activated.self:SetActive(true)
    else
      element.Img_Activated.self:SetActive(false)
    end
    element.Btn_Activate.self:SetClickParam(languageType)
  end
end

function LanguageController:RefreshTextList()
  View.Group_Language.ScrollView_Image.Viewport.Content.Group_Txt.ScrollGrid_LanguageList.grid.self:SetDataCount(table.count(textList))
  View.Group_Language.ScrollView_Image.Viewport.Content.Group_Txt.ScrollGrid_LanguageList.grid.self:RefreshAllElement()
end

function LanguageController:ShowTextList()
  self:RefreshTextList()
  View.Group_Language.ScrollView_Image.Viewport.Content.Group_Txt.Group_Main.Btn_Change.Group_State.Img_Folded:SetActive(true)
  View.Group_Language.ScrollView_Image.Viewport.Content.Group_Txt.Group_Main.Btn_Change.Group_State.Img_Expanded:SetActive(false)
  View.Group_Language.ScrollView_Image.Viewport.Content.Group_Txt.ScrollGrid_LanguageList.self:SetActive(true)
  self:SetHideTextListBGActive(true)
end

function LanguageController:HideTextList()
  View.Group_Language.ScrollView_Image.Viewport.Content.Group_Txt.Group_Main.Btn_Change.Group_State.Img_Folded:SetActive(false)
  View.Group_Language.ScrollView_Image.Viewport.Content.Group_Txt.Group_Main.Btn_Change.Group_State.Img_Expanded:SetActive(true)
  View.Group_Language.ScrollView_Image.Viewport.Content.Group_Txt.ScrollGrid_LanguageList.self:SetActive(false)
  self:SetHideTextListBGActive(false)
end

function LanguageController:ShowCurrentText()
  View.Group_Language.ScrollView_Image.Viewport.Content.Group_Txt.Group_Main.Btn_Change.Txt_Language:SetText(currentTextLanguage)
end

function LanguageController:ChangeText(language)
  UIManager:Open("UI/Common/LanguageSwitch/LanguageSwitch", "{\"isText\":true,\"isSV\":false,\"language\":\"" .. language .. "\"}")
end

function LanguageController:SetHideTextListBGActive(isActive)
  View.Group_Language.ScrollView_Image.Viewport.Content.Group_Txt.Btn_BG.self:SetActive(isActive)
end

function LanguageController:ShowSoundState(element, elementIndex)
  if elementIndex <= #soundList then
    local languageType = soundList[elementIndex].languageType
    local language = soundList[elementIndex].languageDetail
    element.Txt_Name:SetText(language)
    element.Group_State.Btn_Download.self:SetActive(false)
    if currentSoundLanguage == language then
      element.Group_State.Btn_Activate.self:SetActive(false)
      element.Group_State.Img_Activated.self:SetActive(true)
    else
      element.Group_State.Btn_Activate.self:SetActive(true)
      element.Group_State.Img_Activated.self:SetActive(false)
    end
    element.Group_State.Btn_Activate.self:SetClickParam(languageType)
  end
end

function LanguageController:ChangeSound(language)
  UIManager:Open("UI/Common/LanguageSwitch/LanguageSwitch", "{\"isText\":false,\"isSV\":true,\"language\":\"" .. language .. "\"}")
end

function LanguageController:RefreshSound()
  View.Group_Language.ScrollView_Image.Viewport.Content.Group_Sound.Img_Bg.StaticGrid_LanguageList.self:SetDataCount(table.count(soundList))
  View.Group_Language.ScrollView_Image.Viewport.Content.Group_Sound.Img_Bg.StaticGrid_LanguageList.self:RefreshAllElement()
end

function LanguageController:GetCurrentLanguage()
  local tCA = PlayerData:GetFactoryData(99900026)
  textList = tCA.list
  soundList = tCA.soundList
  currentTextLanguage = TranslateManager.languagePackDir
  currentSoundLanguage = TranslateManager.SVPackDir
  for k, v in ipairs(textList) do
    if v.languageType == currentTextLanguage then
      currentTextLanguage = v.languageDetail
      break
    end
  end
  for k, v in ipairs(soundList) do
    if v.languageType == currentSoundLanguage then
      currentSoundLanguage = v.languageDetail
      break
    end
  end
end

function LanguageController:Init()
  self:GetCurrentLanguage()
  self:ShowCurrentText()
  self:HideTextList()
  self:RefreshSound()
end

return LanguageController
