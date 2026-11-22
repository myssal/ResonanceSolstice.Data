local ViewController = {}
local View = require("UILinkLogin/UILinkLoginView")
local Controller = require("UILinkLogin/UILinkLoginController")

function ViewController:DeserializeView()
  self:SwitchGroup(1)
end

function ViewController:CloseView()
  View.self:CloseUI()
end

function ViewController:StartLogin()
  local id = View.Group_Login.Group_ID.InputField_Password:GetText()
  local password = View.Group_Login.Group_Password.InputField_Password:GetText()
  
  local function callback(json)
    if json.rc and json.rc ~= "" then
      self:PopTip(json.msg)
      return
    end
    self:SwitchGroup(2)
  end
  
  Controller:StartLogin(callback, id, password)
end

function ViewController:StartLoginAfter()
  self:CloseView()
end

function ViewController:SwitchGroup(groupIndex)
  View.Group_Login:SetActive(groupIndex == 1)
  View.Group_LoginSuccess:SetActive(groupIndex == 2)
  self:HideTip()
end

function ViewController:PopTip(tip)
  View.Btn_Tips3:SetActive(true)
  View.Btn_Tips3.Img_BG.Txt_Warm:SetText(tip)
end

function ViewController:HideTip()
  View.Btn_Tips3:SetActive(false)
end

return ViewController
