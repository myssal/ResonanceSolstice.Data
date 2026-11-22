local View = require("UIGroup_ShowGuka/UIGroup_ShowGukaView")
local DataModel = {GuKaId = 0}

function DataModel.ShowGuKa()
  if tonumber(DataModel.GuKaId) > 0 then
    local cfg = PlayerData:GetFactoryData(DataModel.GuKaId)
    View.Img_.Txt_Name:SetText(cfg.name)
    View.Img_GuKaTips:SetSprite(cfg.tipsPath)
  end
end

return DataModel
