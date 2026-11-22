local View = require("UICharacterTips/UICharacterTipsView")
local DataModel = require("UICharacterTips/UICharacterTipsDataModel")
local ViewFunction = require("UICharacterTips/UICharacterTipsViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel:SetUIScript("UICharacterTips/UICharacterTipsView")
    local row = Json.decode(initParams)
    DataModel.RoleId = row.id
    DataModel.Type = row.type and row.type or 0
    DataModel.IsGoback = row.isGoback or false
    DataModel.IsBook = row.isBook or false
    if DataModel.IsBook and row.content then
      DataModel.BookRoleData = row.content
    end
    DataModel:SetSelectPos({
      [1] = -300,
      [2] = 0,
      [3] = 300
    })
    DataModel:SetSize(60, 166, 916, 980)
    DataModel:SetSpaceRight(0)
    DataModel:SetIsSetHeight(true)
    DataModel.live2D = false
    View.self:PlayAnim("TipsIn")
    View.Btn_Close:SetActive(false)
    DataModel:Reset()
    DataModel:Clear()
    DataModel:SetRole(row.id)
    local Img_Live2dBg = View.Group_Information.Img_Live2dBg
    if DataModel.live2D then
      Img_Live2dBg.Img_On.transform.localPosition = Vector3(24, 0, 0)
      Img_Live2dBg:SetSprite("UI/CharacterInfo/Skin/onbg")
    else
      Img_Live2dBg.Img_On.transform.localPosition = Vector3(-24, 0, 0)
      Img_Live2dBg:SetSprite("UI/CharacterInfo/Skin/offbg")
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
    View.Group_CharacterSkin.ScrollView_Skin.Viewport.Content.Group_Spine.SpineAnimation_Character:SetData("")
    View.Group_CharacterSkin.ScrollView_Skin.Viewport.Content.Group_Spine.SpineAnimation_Character.transform:GetComponent(typeof(CS.UnityEngine.MeshRenderer)).material = nil
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
