local View = require("UITransportLvUp/UITransportLvUpView")
local DataModel = {}
DataModel.oldLv = 0
DataModel.nowLv = 0

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  if data.oldLv then
    DataModel.oldLv = data.oldLv
  end
  if data.nowLv then
    DataModel.nowLv = data.nowLv
  end
end

function DataModel.InitData()
end

function DataModel.RefreshOnShow()
  View.Img_TxtBg.Group_Txt.Txt_1:SetText(string.format(GetText(80607936), DataModel.oldLv))
  View.Img_TxtBg.Group_Txt.Txt_2:SetText(string.format(GetText(80607938), DataModel.nowLv))
end

return DataModel
