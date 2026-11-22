local View = require("UIItemPrompt_Witches/UIItemPrompt_WitchesView")
local CommonBtn = require("Common/BtnItem")
local DataModel = {}
DataModel.content = ""
DataModel.yesTxt = ""
DataModel.noTxt = ""
DataModel.itemId = 11400663
DataModel.useNum = 1
DataModel.itemNum = 1

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.content = data.content
  DataModel.yesTxt = data.yesTxt
  DataModel.noTxt = data.noTxt
  DataModel.itemId = data.itemId
end

function DataModel.InitData()
  local yesTxt = DataModel.yesTxt
  local noTxt = DataModel.noTxt
  if string.nilorempty(yesTxt) then
    DataModel.yesTxt = GetText(80602603)
  end
  if string.nilorempty(noTxt) then
    DataModel.noTxt = GetText(80602602)
  end
end

function DataModel.RefreshOnShow()
  local content = DataModel.content
  local yesTxt = DataModel.yesTxt
  local noTxt = DataModel.noTxt
  View.Txt_Des:SetText(content)
  View.Btn_Confirm_Witches.Group_.Txt_Confirm:SetText(yesTxt)
  View.Btn_Cancel_Witches.Group_.Txt_Cancel:SetText(noTxt)
  local itemId = DataModel.itemId
  local useNum = DataModel.useNum
  local itemNum = DataModel.itemNum
  CommonBtn:SetItem(View.Group_Item, {id = itemId})
  View.Group_Item.Btn_Item:SetClickParam(itemId)
  View.Group_Need.Txt_Need:SetText(useNum)
  View.Group_Need.Txt_Have:SetText(itemNum)
  local color = UIConfig.Color.White
  if useNum > itemNum then
    color = UIConfig.Color.Red
  end
  View.Group_Need.Txt_Have:SetColor(color)
end

return DataModel
