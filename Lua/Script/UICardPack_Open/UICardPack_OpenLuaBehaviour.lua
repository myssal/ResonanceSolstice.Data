local View = require("UICardPack_Open/UICardPack_OpenView")
local DataModel = require("UICardPack_Open/UICardPack_OpenDataModel")
local ViewFunction = require("UICardPack_Open/UICardPack_OpenViewFunction")
local params
local nowX = 0
local nowY = 0
local Luabehaviour = {
  serialize = function()
    return params
  end,
  deserialize = function(initParams)
    params = initParams
    local data = Json.decode(initParams)
    DataModel.Init(data)
    if DataModel.isCardBooklet then
      View.self:PlayAnimOnce("CardPack_Open_Booklet_In")
    end
    local cfg = PlayerData:GetFactoryData(data.cardPackId)
    View.Drag_CardPack.Group_Left1.ScrollGrid_CardList.grid.self:SetDataCount(DataModel.pageCardMaxNum)
    View.Drag_CardPack.Group_Left1.ScrollGrid_CardList.grid.self:RefreshAllElement()
    View.Drag_CardPack.Group_Left1.Img_Left:SetSprite(cfg.leftPage)
    View.Drag_CardPack.Group_Left2.Img_Left:SetSprite(cfg.leftPage)
    View.Drag_CardPack.Group_Left1.Img_Middle:SetSprite(cfg.middlePage)
    View.Drag_CardPack.Group_Right1.Img_Middle:SetSprite(cfg.middlePage)
    View.Drag_CardPack.Group_Left2.Img_Middle:SetSprite(cfg.middlePage)
    View.Drag_CardPack.Group_Right2.Img_Middle:SetSprite(cfg.middlePage)
    View.Drag_CardPack.Group_Right2.Img_Right:SetSprite(cfg.rightPageNormalPage)
    View.Drag_CardPack.Group_Right3.Img_Middle:SetSprite(cfg.middlePage)
    View.Drag_CardPack.Group_Right3.Img_Right:SetSprite(cfg.rightPageNormalPage)
    View.Group_Cover.Btn_Cover.Img_Cover.Img_Middle:SetSprite(cfg.middlePage)
    View.Drag_CardPack.Group_Middle.Img_Middle:SetSprite(cfg.middlePage)
    View.Drag_CardPack.Group_Right1.Group_CardBackCommon.Img_Right:SetSprite(cfg.rightPage)
    View.Drag_CardPack.Group_Right1.Group_CardBackCommon.Img_Back:SetSprite(cfg.topCardBack)
    View.Drag_CardPack.Group_Right1.Group_CardBackCommon.Img_Tips:SetSprite(cfg.tipsBg)
    View.Drag_CardPack.Group_Right1.Img_Pic:SetSprite(cfg.pageDeco)
    View.Drag_CardPack.Group_Right1.Img_Pic:SetAnchoredPositionX(nowX + cfg.decoX)
    View.Drag_CardPack.Group_Right1.Img_Pic:SetAnchoredPositionY(nowY + cfg.decoY)
    View.Group_Cover.Btn_Cover.Img_Cover:SetSprite(cfg.cover)
    View.Drag_CardPack.Group_Right1.Txt_Tips:SetText("<Color=#" .. string.format(GetText(80611762), cfg.textColor) .. ">" .. GetText(80602694) .. "</Color>")
    local data = DataModel.GetCardPackInfo(DataModel.cardPackId)
    View.Drag_CardPack.Group_Right1.Btn_Card:SetActive(data.extraCardStatus == 2)
    View.Drag_CardPack.Group_Right1.Btn_CardGet:SetActive(data.extraCardStatus == 1)
    View.Drag_CardPack.Group_Right1.Group_CardBackCommon.Img_Tips:SetActive(data.extraCardStatus ~= 2)
    View.Drag_CardPack.Group_Right1.Txt_Tips:SetActive(data.extraCardStatus == 0)
    local extraCardCfg = PlayerData:GetFactoryData(DataModel.extraCardId)
    View.Drag_CardPack.Group_Right1.Btn_Card.Img_Card:SetSprite(extraCardCfg.iconPath)
    if data.extraCardStatus == 1 then
      View.Drag_CardPack.Group_Right1.Btn_CardGet.Group_Effect:SetDynamicGameObject(DataModel.effectPath)
    end
  end,
  awake = function()
    nowX = View.Drag_CardPack.Group_Right1.Img_Pic:GetAnchoredPositionX()
    nowY = View.Drag_CardPack.Group_Right1.Img_Pic:GetAnchoredPositionY()
    View.animator = View.self.transform:GetComponent(typeof(CS.UnityEngine.Animator))
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
  end,
  enable = function()
    View.animator.enabled = true
    View.Drag_CardPack.Group_Left1:SetActive(true)
    View.Drag_CardPack.Group_Left2:SetActive(true)
    View.Drag_CardPack.Group_Right1:SetActive(true)
    View.Drag_CardPack.Group_Right2:SetActive(false)
    View.Drag_CardPack.Group_Right3:SetActive(false)
  end,
  disenable = function()
    View.Drag_CardPack.Group_Right1.Btn_CardGet.Group_Effect:HideDynamicGameObject(DataModel.effectPath)
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
