local View = require("UIPlayer/UIPlayerView")
local DataModel = require("UIPlayer/UIPlayerDataModel")
local Controller = {}

function Controller.RefreshServiceBtn(hasReset)
  local count = PlayerData:GetUserInfo().red_dot_num
  if count and 0 < count then
    View.Group_Right.Btn_Service.Txt_Count:SetActive(not hasReset)
    if hasReset then
      PlayerData:GetUserInfo().red_dot_num = 0
    else
      View.Group_Right.Btn_Service.Txt_Count:SetText(tostring(count))
    end
  else
    View.Group_Right.Btn_Service.Txt_Count:SetActive(false)
  end
end

function Controller.OpenCDKey(hasOpen)
  View.Group_Right.Btn_CloseCDKey:SetActive(hasOpen)
  if hasOpen then
    View.Group_Right.Btn_CloseCDKey.InputField_CDKey.self:SetText("")
  end
end

function Controller.RedeemGift()
  local cdKey = View.Group_Right.Btn_CloseCDKey.InputField_CDKey.self:GetText()
  if cdKey == "" then
    CommonTips.OpenTips(GetText(80600225))
    return
  else
    GSDKManager:RedeemGift(cdKey, function(code)
      local hint = ""
      if code == 0 then
        hint = "\229\133\145\230\141\162\230\136\144\229\138\159"
      elseif code == -400001 then
        hint = "\229\143\130\230\149\176\233\148\153\232\175\175,\233\135\141\230\150\176\231\153\187\233\153\134\232\180\166\229\143\183"
      elseif code == -400006 then
        hint = "CdKey\229\183\178\231\187\143\232\162\171\228\189\191\231\148\168\232\191\135\228\186\134"
      elseif code == -400007 then
        hint = "\229\183\178\231\187\143\233\162\134\229\143\150\232\191\135\229\144\140\228\184\128\230\137\185\230\172\161\231\154\132CdKey"
      elseif code == -400008 then
        hint = "CdKey\230\156\170\229\188\128\230\148\190\233\162\134\229\143\150"
      elseif code == -400009 then
        hint = "CdKey\233\162\134\229\143\150\229\183\178\231\187\143\231\187\147\230\157\159"
      elseif code == -400010 then
        hint = "CdKey\228\184\141\229\173\152\229\156\168"
      elseif code == -400011 then
        hint = "\229\145\189\228\184\173\233\163\142\230\142\167"
      else
        hint = "\232\129\148\231\179\187\233\161\185\231\155\174\230\138\128\230\156\175\230\142\165\229\143\163\228\186\186"
      end
      hint = hint .. "(\230\156\170\231\191\187\232\175\145)"
      CommonTips.OpenTips(hint, true)
      if code == 0 then
        Controller.OpenCDKey(false)
      end
    end)
  end
end

function Controller.EntranceHost(sceneId, language)
  DataModel.EntranceHostData = {}
  GSDKManager:EntranceHost(sceneId, language, function(data)
  end, function(data)
  end)
end

function Controller.CheckQuestionnaire(callback)
  DataModel.QuestionnaireData = {}
  GSDKManager:CheckQuestionnaire(function(data)
    local info = Json.decode(data)
    if info.ec == 0 and 0 < info.data.unfinished_count then
      info = info.data
      local serverTime = TimeUtil:GetServerTimeStamp()
      local index = 1
      for k, v in pairs(info.survey_info) do
        if v.finished_flg == false and serverTime >= v.begin_time and serverTime <= v.end_time then
          DataModel.QuestionnaireData[index] = v.page_url
          index = index + 1
        end
      end
      if callback ~= nil and 0 < #DataModel.QuestionnaireData then
        callback()
      end
    end
  end, function(data)
    print_r("\233\151\174\229\141\183\228\191\161\230\129\175Error: " .. data)
  end)
end

function Controller.RefreshQuestionnaireBtn()
  Controller.OpenQuestionnaire(false)
  local count = #DataModel.QuestionnaireData
  View.Group_Right.Btn_Questionnaire:SetActive(0 < count)
  View.Group_Right.Btn_Questionnaire.Txt_Count:SetActive(0 < count)
  if 0 < count then
    View.Group_Right.Btn_Questionnaire.Txt_Count:SetText(tostring(count))
  end
end

function Controller.OpenQuestionnaire(hasOpen)
  View.Group_Right.Btn_CloseQuestionnaire:SetActive(hasOpen)
  if hasOpen then
    DataModel.HasQuestionnaire = true
    View.Group_Right.Btn_CloseQuestionnaire.ScrollGrid_Questionnaire.grid.self:SetDataCount(#DataModel.QuestionnaireData)
    View.Group_Right.Btn_CloseQuestionnaire.ScrollGrid_Questionnaire.grid.self:RefreshAllElement()
  end
end

function Controller.OpenStore(hasOpen)
  if hasOpen then
    if PlayerData.ProductList == nil then
      return
    end
    View.Group_Right.Btn_CloseQuestionnaire:SetActive(hasOpen)
    DataModel.HasQuestionnaire = false
    View.Group_Right.Btn_CloseQuestionnaire.ScrollGrid_Questionnaire.grid.self:SetDataCount(PlayerData.ProductList.Count)
    View.Group_Right.Btn_CloseQuestionnaire.ScrollGrid_Questionnaire.grid.self:RefreshAllElement()
  else
    View.Group_Right.Btn_CloseQuestionnaire:SetActive(hasOpen)
  end
end

function Controller.SetElement(element, elementIndex)
  local text = "\229\149\134\229\147\129"
  if DataModel.HasQuestionnaire then
    text = "\233\151\174\229\141\183"
  end
  element.Btn_Questionnaire.Txt_:SetText(text .. elementIndex)
end

function Controller.OnClickBtn(index)
  if DataModel.HasQuestionnaire then
    GSDKManager:Questionnaire(DataModel.QuestionnaireData[index], function()
      Controller.CheckQuestionnaire(function()
        Controller.RefreshQuestionnaireBtn()
      end)
      Controller.OpenQuestionnaire(false)
    end)
  else
    DataModel.isRequestPayResult = false
    DataModel.timer = DataModel.time
    DataModel.index = 0
    UIManager:Open("UI/Common/Waiting")
    View.Img_Mask:SetActive(true)
    DataModel.Product = PlayerData.ProductList[index - 1]
    PlayerData.PayProduct(DataModel.Product, function(orderID)
      if orderID ~= nil and orderID ~= "" then
        DataModel.OrderID = orderID
        DataModel.isRequestPayResult = true
      else
        UIManager:CloseTip("UI/Common/Waiting")
        View.Img_Mask:SetActive(false)
      end
    end)
  end
end

function Controller.UserInfo()
  local data = PlayerData:GetUserInfo()
  local url = "https://gsdk.dailygn.com/"
  if GSDKManager.AppService.EnableSandboxMode then
    url = "https://gsdk-sandbox.dailygn.com/"
  end
  MGameManager.WebView(GetText(80600182), url .. "h5/personal_protection/query?" .. "nickname=" .. data.role_name .. "&roleid=" .. PlayerPrefs.GetString("username") .. "&gamename=" .. data.role_name .. "&version=" .. HotfixSetting.clientAppVersion)
end

function Controller.OpenUrl(textId, url)
  MGameManager.WebView(GetText(textId), url)
end

function Controller.InitView()
  Controller.RefreshServiceBtn()
  Controller.RefreshQuestionnaireBtn()
  View.Img_Mask:SetActive(false)
  if UseGSDK and GSDKManager.AppService.ChannelOp ~= "bsdk" then
    View.Group_Right.Btn_Logout:SetActive(true)
  else
    View.Group_Right.Btn_Logout:SetActive(false)
  end
end

return Controller
