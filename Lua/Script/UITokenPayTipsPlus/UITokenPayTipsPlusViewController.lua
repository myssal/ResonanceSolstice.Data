local View = require("UITokenPayTipsPlus/UITokenPayTipsPlusView")
local ViewController = {}

function ViewController:Deserialize(initParams)
  self.toggleNoPrompt = false
  if Net.overseas_priority_ocweb_recharge_pop == 0 then
    self:Cancel()
  end
  if PlayerData:GetNoPrompt("TokenPayTipsPlus", 1) then
    self:Cancel()
  end
end

function ViewController:Confirm()
  self:SetToggleTodayNoPrompt()
  View.self:CloseUI()
  View.self:Confirm()
end

function ViewController:Cancel()
  self:SetToggleTodayNoPrompt()
  View.self:CloseUI()
  View.self:Cancel()
end

function ViewController:ToggleTodayNoPrompt()
  self.toggleNoPrompt = not self.toggleNoPrompt
  View.Group_Toggle.Btn_toggle.Img_Off:SetActive(not self.toggleNoPrompt)
  View.Group_Toggle.Btn_toggle.Img_On:SetActive(self.toggleNoPrompt)
end

function ViewController:SetToggleTodayNoPrompt()
  if self.toggleNoPrompt == nil or self.toggleNoPrompt == false then
    return
  end
  PlayerData:SetNoPrompt("TokenPayTipsPlus", 1, self.toggleNoPrompt)
end

return ViewController
