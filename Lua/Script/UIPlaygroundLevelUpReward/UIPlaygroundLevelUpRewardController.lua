local View = require("UIPlaygroundLevelUpReward/UIPlaygroundLevelUpRewardView")
local DataModel = require("UIPlaygroundLevelUpReward/UIPlaygroundLevelUpRewardDataModel")
local Controller = {}

function Controller:Init()
  View.Img_Title.Txt_:SetText(string.format(GetText(80608302), #DataModel.initParams))
  View.StaticGrid_List.grid.self:RefreshAllElement()
end

function Controller:RefreshElement(element, elementIndex)
  local info = DataModel.initParams[elementIndex]
  element:SetActive(info ~= nil)
  if info ~= nil then
    local ca = PlayerData:GetFactoryData(info.id)
    element.Group_Passenger.Img_CientF.Img_ClientMask.Img_Client:SetSprite(ca.resUrl)
    element.Group_Passenger.Txt_Num:SetText(info.num)
  end
end

function Controller:Close()
  View.self:CloseUI()
end

return Controller
