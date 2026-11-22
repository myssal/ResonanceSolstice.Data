local View = require("UIESC/UIESCView")
local Controller = {}

function Controller:InitElement(element)
  function EscUserCenterHelper.BindAccountSuccessListener1()
    local go = self.goElement
    
    if go ~= nil then
      element.Btn_Func.Img_Tip:SetActive(false)
    end
  end
  
  self:RefreshUserCenterRedPoint(element)
end

function Controller:RefreshUserCenterRedPoint(element)
  self.goElement = element
  local isShow = EscUserCenterHelper.IsShowRedPoint()
  element.Btn_Func.Img_Tip:SetActive(isShow)
end

return Controller
