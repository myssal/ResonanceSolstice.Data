local View = require("UIWitchesTeaBuff/UIWitchesTeaBuffView")
local DataModel = {}
DataModel.eventId = nil

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.eventId = data.eventId
  DataModel.selectInfo = data.selectInfo
end

function DataModel.InitData()
end

function DataModel.RefreshOnShow()
  View.StaticGrid_BuffList.grid.self:SetDataCount(table.count(DataModel.selectInfo))
  View.StaticGrid_BuffList.grid.self:RefreshAllElement()
end

return DataModel
