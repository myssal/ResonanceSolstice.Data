local ViewController = {}
local View = require("UILinkPasswordSet/UILinkPasswordSetView")
local Controller = require("UILinkPasswordSet/UILinkPasswordSetController")

function ViewController:DeserializeView()
  self.linkId = ""
  self:SwitchGroup(1)
end

function ViewController:AwakeView()
end

function ViewController:CloseView()
  View.self:CloseUI()
end

function ViewController:SwitchGroup(groupIndex)
  View.Group_GoLink:SetActive(groupIndex == 1)
  View.Group_SetPassword:SetActive(groupIndex == 2)
  View.Group_SetSuccess:SetActive(groupIndex == 3)
  self:HideTip()
end

function ViewController:SwitchGroupToSet(id)
  self:SwitchGroup(2)
  View.Group_SetPassword.Group_ID.Txt_ID:SetText(id)
end

function ViewController:StartDataLink()
  local function callback(json)
    if json.rc and json.rc ~= "" then
      self:PopTip(json.msg)
      
      return
    end
    local id = json.username
    self.linkId = id
    self:SwitchGroupToSet(id)
  end
  
  Controller:StartDataLink(callback)
end

function ViewController:SetDataLinkPassword()
  local function callback(json)
    if json.rc and json.rc ~= "" then
      self:PopTip(json.msg)
      
      return
    end
    self:SwitchGroup(3)
  end
  
  local password = View.Group_SetPassword.Group_Password.InputField_Password:GetText()
  local password1 = View.Group_SetPassword.Group_PasswordDoubleCheck.InputField_Password:GetText()
  Controller:SetDataLinkPassword(callback, password, password1)
end

function ViewController:PopTip(tip)
  View.Btn_Tips3:SetActive(true)
  View.Btn_Tips3.Img_BG.Txt_Warm:SetText(tip)
end

function ViewController:HideTip()
  View.Btn_Tips3:SetActive(false)
end

function ViewController:OnBtnCopyLinkCode()
  CS.UnityEngine.GUIUtility.systemCopyBuffer = self.linkId
  CommonTips.OpenTips(GetText(80602254))
end

return ViewController
