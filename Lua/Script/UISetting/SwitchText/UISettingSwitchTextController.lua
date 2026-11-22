local View = require("UISetting/UISettingView")
local UISettingSwitchTextController = {}
local switchTextData = {}
local currentText

function UISettingSwitchTextController:Init()
  switchTextData = PlayerData:GetFactoryData(99900012, "ConfigFactory").languageTextList
  currentText = PlayerPrefs.GetString("LanguageType")
  if currentText == "" then
    currentText = GameSetting.currentTextLanguage
  end
  View.Group_Language.ScrollView_Image.Viewport.Content.Group_Main.Img_Bg.StaticGrid_LanguageList.grid.self:SetDataCount(#switchTextData)
  View.Group_Language.ScrollView_Image.Viewport.Content.Group_Main.Img_Bg.StaticGrid_LanguageList.grid.self:RefreshAllElement()
end

function UISettingSwitchTextController:ShowTips(index)
  if next(switchTextData) ~= nil then
    local data = switchTextData[index]
    if data.key ~= currentText then
      CommonTips.OnPrompt(data.tips, data.confirm, data.cancel, function()
        if data.key ~= "" then
          PlayerPrefs.SetString("LanguageType", data.key)
          CS.GameSetting.Quit()
        end
      end)
    end
  end
end

function UISettingSwitchTextController:SetElement(element, elementIndex)
  if next(switchTextData) ~= nil and switchTextData[elementIndex] ~= nil then
    element.Btn_LanguageSell:SetClickParam(elementIndex)
    element:SetActive(true)
    local data = switchTextData[elementIndex]
    local isActive = data.key == currentText
    element.Btn_LanguageSell.Img_On:SetActive(isActive)
    if isActive then
      element.Btn_LanguageSell.Img_On.Txt_Title:SetText(data.text)
    else
      element.Btn_LanguageSell.Img_Off.Txt_Title:SetText(data.text)
    end
  else
    element:SetActive(false)
  end
end

return UISettingSwitchTextController
