local View = require("UIDictionary/UIDictionaryView")
local DataModel = require("UIDictionary/UIDictionaryDataModel")
local ViewFunction = require("UIDictionary/UIDictionaryViewFunction")
local customSV = require("Common/CustomSV")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    ViewFunction.SwitchTopTab(3)
    View.Group_Mechanism.ScrollView_:SetVerticalNormalizedPosition(1)
    View.Group_Tab.Btn_Card:SetLocalPositionY(140, 0)
    local data = initParams ~= nil and Json.decode(initParams) or {}
    View.Img_BG.Group_CommonTopLeft.Btn_Home:SetActive(data.hideHomeBtn == nil)
  end,
  awake = function()
    DataModel:init()
    DataModel.tabList = {
      {
        panel = View.Group_Card,
        selectImg = View.Group_Tab.Btn_Card.Img_On
      },
      {
        panel = View.Group_Tag,
        selectImg = View.Group_Tab.Btn_Tag.Img_On
      },
      {
        panel = View.Group_Mechanism,
        selectImg = View.Group_Tab.Btn_Mechanism.Img_On
      }
    }
    DataModel.affixTabList = {
      View.Group_Tag.Btn_Tech,
      View.Group_Tag.Btn_Control,
      View.Group_Tag.Btn_Defence
    }
    View.myCustomSV = customSV.New(View.Group_Card.Group_Selected.CustomScrollGrid_Desc.grid, true, function(element, index)
      element.Txt_CardDesc:SetActive(index == 1)
      element.Group_Tag:SetActive(index ~= 1)
      if index == 1 then
        element.Txt_CardDesc:SetText(DataModel.desAndTaglist[index].info)
        element.Txt_CardDesc:SetHeight(element.Txt_CardDesc:GetHeight())
      else
        local id = DataModel.desAndTaglist[index].info
        local tagConfig = PlayerData:GetFactoryData(id)
        element.Group_Tag.Img_:SetSprite(tagConfig.icon)
        element.Group_Tag.Txt_TagName:SetText(tagConfig.tagName)
        element.Group_Tag.Txt_TagDesc:SetText(tagConfig.detail)
        element.Group_Tag.Txt_TagDesc:SetHeight(element.Group_Tag.Txt_TagDesc:GetHeight())
      end
    end)
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
