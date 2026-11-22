local View = require("UIItemPrompt/UIItemPromptView")
local DataModel = require("UIItemPrompt/UIItemPromptDataModel")
local CommonBtn = require("Common/BtnItem")
local ViewFunction = require("UIItemPrompt/UIItemPromptViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.params = Json.decode(initParams)
    if DataModel.params.yesTxt then
      View.Btn_Confirm.Group_.Txt_Confirm:SetText(DataModel.params.yesTxt)
    end
    if DataModel.params.noTxt then
      View.Btn_Cancel.Group_.Txt_Cancel:SetText(DataModel.params.noTxt)
    end
    View.Txt_Des:SetText(DataModel.params.content)
    CommonBtn:SetItem(View.Group_Item, {
      id = DataModel.params.itemId
    })
    View.Group_Item.Btn_Item:SetClickParam(DataModel.params.itemId)
    local useNumTxt = tostring(DataModel.params.useNum)
    local itemNumTxt = tostring(DataModel.params.itemNum)
    if DataModel.params.addUnit then
      local num = DataModel.params.useNum
      if 1000 <= num and num < 1000000 then
        useNumTxt = tostring(math.floor(num / 1000)) .. "K"
      elseif 1000000 <= num and num < 1000000000 then
        useNumTxt = tostring(math.floor(num / 1000000)) .. "M"
      elseif 1000000000 <= num then
        useNumTxt = tostring(math.floor(num / 1000000000)) .. "G"
      end
      num = DataModel.params.itemNum
      if 1000 <= num and num < 1000000 then
        itemNumTxt = tostring(math.floor(num / 1000)) .. "K"
      elseif 1000000 <= num and num < 1000000000 then
        itemNumTxt = tostring(math.floor(num / 1000000)) .. "M"
      elseif 1000000000 <= num then
        itemNumTxt = tostring(math.floor(num / 1000000000)) .. "G"
      end
    end
    View.Group_Need.Txt_Need:SetText(useNumTxt)
    View.Group_Need.Txt_Have:SetText(itemNumTxt)
    local color = UIConfig.Color.White
    if DataModel.params.itemNum < DataModel.params.useNum then
      color = UIConfig.Color.Red
    end
    View.Group_Need.Txt_Have:SetColor(color)
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
