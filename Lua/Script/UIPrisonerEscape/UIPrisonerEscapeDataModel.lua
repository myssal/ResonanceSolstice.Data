local View = require("UIPrisonerEscape/UIPrisonerEscapeView")
local DataModel = {}
DataModel.escapeFailPrisoners = {}
DataModel.escapeSuccessPrisoners = {}
DataModel.escapePrisoners = {}

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.escapeFailPrisoners = data.escapeFailPrisoners or {}
  DataModel.escapeSuccessPrisoners = data.escapeSuccessPrisoners or {}
end

function DataModel.InitData()
  DataModel.escapePrisoners = {}
  for i, v in pairs(DataModel.escapeSuccessPrisoners) do
    table.insert(DataModel.escapePrisoners, {data = v, escape = true})
  end
  for i, v in pairs(DataModel.escapeFailPrisoners) do
    table.insert(DataModel.escapePrisoners, {data = v, escape = false})
  end
end

function DataModel.RefreshOnShow()
  local successNum = table.count(DataModel.escapeSuccessPrisoners)
  local escapeNum = table.count(DataModel.escapePrisoners)
  View.Group_Summary.Group_All.Img_.Txt_Num:SetText(string.format(GetText(80609216), escapeNum))
  local successTxt = ""
  if 0 < successNum then
    successTxt = string.format(GetText(80609216), successNum)
  else
    successTxt = GetText(80609217)
  end
  View.Group_Summary.Group_Success.Img_.Txt_Num:SetText(successTxt)
  View.ScrollGrid_List.grid.self:SetDataCount(escapeNum)
  View.ScrollGrid_List.grid.self:RefreshAllElement()
end

return DataModel
