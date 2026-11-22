local View = require("UIStamina/UIStaminaView")
local DataModel = {}
DataModel.selectElementList = {}
DataModel.curSelectIndex = nil

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
end

function DataModel.InitData()
  DataModel.ParkMapCA = WitchData.GetParkMapCA()
  DataModel.curSelectIndex = nil
  DataModel.selectElementList = {}
end

function DataModel.RefreshOnShow()
  local parkMapCA = DataModel.ParkMapCA
  View.StaticGrid_Option.grid.self:SetDataCount(#parkMapCA.initialEnergyList)
  View.StaticGrid_Option.grid.self:RefreshAllElement()
  View.Btn_Energy.Txt_Num:SetText(PlayerData:GetUserInfo().energy .. "/" .. PlayerData:GetUserInfo().max_energy)
  local itemCA = PlayerData:GetFactoryData(11400005, "ItemFactory")
  View.Btn_Medal.Img_Icon:SetSprite(itemCA.buyPath)
  View.Btn_Medal.Txt_Num:SetText(PlayerData:GetGoodsById(11400005).num)
end

return DataModel
