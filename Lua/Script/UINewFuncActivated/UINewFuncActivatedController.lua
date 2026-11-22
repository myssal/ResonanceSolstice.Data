local View = require("UINewFuncActivated/UINewFuncActivatedView")
local DataModel = require("UINewFuncActivated/UINewFuncActivatedDataModel")
local Controller = {}

function Controller:ShowUnlock()
  if #DataModel.ShowInfo == 0 then
    UIManager:GoBack(false)
    return
  end
  local info = DataModel.ShowInfo[1]
  table.remove(DataModel.ShowInfo, 1)
  if info.funcId then
    local funcConfig = PlayerData:GetFactoryData(99900047, "ConfigFactory")
    for k, v in ipairs(funcConfig.funcList) do
      if v.funcId == info.funcId then
        info = v
        break
      end
    end
  end
  if info.iconPath == nil or info.name == nil then
    UIManager:GoBack(false)
    return
  end
  View.Img_Icon:SetSprite(info.iconPath)
  View.Txt_Name:SetText(info.name)
  View.self:PlayAnimOnce("In")
end

return Controller
