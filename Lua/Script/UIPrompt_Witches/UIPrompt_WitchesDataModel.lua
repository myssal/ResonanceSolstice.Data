local View = require("UIPrompt_Witches/UIPrompt_WitchesView")
local Timer = require("Common/Timer")
local DataModel = {}
DataModel.content = ""
DataModel.yesTxt = ""
DataModel.noTxt = ""

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.content = data.content
  DataModel.yesTxt = data.yesTxt
  DataModel.noTxt = data.noTxt
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
  View.Group_Prompt.TextIcon_Prompt:SetActive(false)
  View.Group_Prompt.TextIcon_Prompt:SetText(content)
  DataModel.timer = Timer.New(0.3, function()
    View.Group_Prompt.TextIcon_Prompt:SetActive(true)
    DataModel.timer:Stop()
    DataModel.timer = nil
  end)
  DataModel.timer:Start()
  View.Btn_Confirm_Witches.Group_.Txt_Confirm:SetText(yesTxt)
  View.Btn_Cancel_Witches.Group_.Txt_Cancel:SetText(noTxt)
end

return DataModel
