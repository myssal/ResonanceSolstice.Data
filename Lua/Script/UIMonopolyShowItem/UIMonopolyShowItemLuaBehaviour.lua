local View = require("UIMonopolyShowItem/UIMonopolyShowItemView")
local DataModel = require("UIMonopolyShowItem/UIMonopolyShowItemDataModel")
local ViewFunction = require("UIMonopolyShowItem/UIMonopolyShowItemViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local status = {}
    if initParams ~= nil and initParams ~= "" then
      status = Json.decode(initParams)
    end
    DataModel.ignoreCloseTime = status.ignoreCloseTime
    DataModel.stepClose = 0
    local cfg
    if status.cfgId then
      cfg = PlayerData:GetFactoryData(status.cfgId or 80500001, "ExtractFactory")
    end
    DataModel.cfg = cfg
    DataModel.Data = {}
    if status.prisonProductRewards then
      for itemId, v in pairs(status.prisonProductRewards) do
        if 0 < v.normal then
          table.insert(DataModel.Data, {
            id = itemId,
            num = v.normal
          })
        end
        if 0 < v.extra then
          table.insert(DataModel.Data, {
            id = itemId,
            num = v.extra,
            product_extra = true
          })
        end
        if 0 < v.buff then
          table.insert(DataModel.Data, {
            id = itemId,
            num = v.buff,
            product_buff = true
          })
        end
      end
    else
      DataModel.Data = PlayerData:SortShowItem(status.rewards)
    end
    if table.count(DataModel.Data) <= 15 then
      View.ScrollGrid_Items.self:SetEnable(false)
      View.ScrollGrid_Items.grid.self:SetStartCorner("Center")
    else
      View.ScrollGrid_Items.self:SetEnable(true)
      View.ScrollGrid_Items.grid.self:SetStartCorner("Left")
    end
    View.self:StartC(LuaUtil.cs_generator(function()
      coroutine.yield(CS.UnityEngine.WaitForSeconds(0.2))
      View.ScrollGrid_Items.grid.self:SetDataCount(table.count(DataModel.Data))
      View.ScrollGrid_Items.grid.self:RefreshAllElement()
      local row = View.ScrollGrid_Items.grid.self:GetRow()
      View.Group_300:SetActive(false)
      View.Group_580:SetActive(false)
      View.Group_800:SetActive(false)
      View.Group_890:SetActive(false)
      if row == 1 then
        View.Group_300:SetActive(true)
      elseif row == 2 then
        View.Group_580:SetActive(true)
      elseif row == 3 then
        View.Group_800:SetActive(true)
      else
        View.Group_890:SetActive(true)
      end
    end))
    if status.title then
      View.Group_300.Group_Title.Txt_Title:SetText(status.title)
    else
      View.Group_300.Group_Title.Txt_Title:SetText(GetText(80601874))
    end
    if cfg then
      View.Group_580.Group_Title.Img_Title:SetActive(cfg.isShowTitleImg)
      View.Group_300.Group_Title.Img_Title:SetActive(cfg.isShowTitleImg)
      if cfg.isShowTitleImg then
        View.Group_300.Group_Title.Img_Title:SetSprite(cfg.showTitlePath)
        View.Group_580.Group_Title.Img_Title:SetSprite(cfg.showTitlePath)
      end
      View.Group_300.Group_Title.Txt_Title:SetAnchoredPosition(Vector2(cfg.showTitleTxtX, cfg.showTitleTxtY))
      View.Group_300.Group_Title.Txt_Title:SetColor(cfg.showTitleTxtColor)
      View.Group_580.Group_Title.Txt_Title:SetAnchoredPosition(Vector2(cfg.showTitleTxtX, cfg.showTitleTxtY))
      View.Group_580.Group_Title.Txt_Title:SetColor(cfg.showTitleTxtColor)
      if cfg.showTitleTxtSize ~= -1 then
        View.Group_300.Group_Title.Txt_Title:SetTxtFontSize(cfg.showTitleTxtSize)
        View.Group_580.Group_Title.Txt_Title:SetTxtFontSize(cfg.showTitleTxtSize)
      end
      View.Group_300.Img_B:SetSprite(cfg.showBgPath)
      View.Group_300.Img_B:SetAnchoredPosition(Vector2(cfg.showBgX, cfg.showBgY))
      View.Group_580.Img_B:SetSprite(cfg.showBgPath)
      View.Group_580.Img_B:SetAnchoredPosition(Vector2(cfg.showBg580X, cfg.showBg580Y))
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
