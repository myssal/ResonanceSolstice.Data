local View = require("UISetting/UISettingView")
local ViewController = {}

function ViewController:InitView()
  self:InitGroupPC()
end

function ViewController:InitGroupPC()
  local Group_PC = View.Group_PC
  if Group_PC ~= nil then
    Group_PC:SetActive(false)
  end
end

return ViewController
