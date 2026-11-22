local View = require("UIKeepsakeTips/UIKeepsakeTipsView")
local DataModel = require("UIKeepsakeTips/UIKeepsakeTipsDataModel")
local ViewFunction = require("UIKeepsakeTips/UIKeepsakeTipsViewFunction")
local Luabehaviour = {
  serialize = function()
    return Json.encode(DataModel.Back)
  end,
  deserialize = function(initParams)
    local params = Json.decode(initParams)
    DataModel.Id = tonumber(params.itemId)
    DataModel.ItemInfo = PlayerData:GetFactoryData(DataModel.Id)
    local characterCA = PlayerData:GetFactoryData(DataModel.ItemInfo.characterId)
    View.Group_Show.Txt_Name:SetText(DataModel.ItemInfo.name)
    View.Group_Show.Txt_Character:SetText(string.format(GetText(80607266), characterCA.name))
    View.Group_Show.Img_Icon:SetSprite(DataModel.ItemInfo.tipsPath)
    local getwayList = PlayerData:GetFactoryData(params.itemId).Getway
    local des = DataModel.ItemInfo.des or DataModel.ItemInfo.describe
    View.Group_Show.Btn_Access:SetActive(next(getwayList or {}))
    View.Group_Show.Btn_Access.Img_On:SetActive(false)
    View.Group_Show.ScrollView_Describe.Viewport.Txt_Describe:SetText(des)
    DataModel.Back = {}
    DataModel.Back.itemId = DataModel.Id
    DataModel.Back.type = params.type and params.type or 0
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
