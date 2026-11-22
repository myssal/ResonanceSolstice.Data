local View = require("UIHomePhoto_Common/UIHomePhoto_CommonView")
local DataModel = require("UIHomePhoto_Common/UIHomePhoto_CommonDataModel")
local ViewFunction = require("UIHomePhoto_Common/UIHomePhoto_CommonViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams then
      local info = Json.decode(initParams)
      DataModel.furId = info.furId
      DataModel.ufid = info.ufid
      local skinId = PosClickHandler.GetFurnitureSkinId(info.ufid)
      local skinCA = PlayerData:GetFactoryData(skinId, "HomeFurnitureSkinFactory")
      if skinCA.VideoUrl ~= "" then
        View.Group_Photos:SetActive(false)
        View.Group_Video:SetActive(true)
        View.Group_Video.Video_Show:Play(skinCA.VideoUrl, true, false, false)
      elseif skinCA.PictureUrl and skinCA.PictureUrl ~= "" then
        View.Group_Photos:SetActive(true)
        View.Group_Video:SetActive(false)
        View.Group_Photos.Img_Show:SetSprite(skinCA.PictureUrl)
      end
    end
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
