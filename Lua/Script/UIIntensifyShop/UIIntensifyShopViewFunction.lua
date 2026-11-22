local View = require("UIIntensifyShop/UIIntensifyShopView")
local DataModel = require("UIIntensifyShop/UIIntensifyShopDataModel")
local Controller = require("UIIntensifyShop/UIIntensifyShopController")
local RogueData = require("UICubeRogueMain/UICubeRogueMainDataModel")
local ViewFunction = {
  IntensifyShop_Group_Coin_Btn_GoldCoin_Click = function(btn, str)
    local allCfg = PlayerData:GetFactoryData(89400002, "CubeRogueFactory")
    CommonTips.OpenCubeRogueItemDetails({
      id = allCfg.coinId
    })
  end,
  IntensifyShop_Btn_Back_Click = function(btn, str)
    UIManager:GoBack(false)
  end,
  IntensifyShop_Group_Info_Group_Lv1_Group_BuffBefore_Btn__Click = function(btn, str)
  end,
  IntensifyShop_Group_Info_Group_Lv1_Group_BuffAfter_Btn__Click = function(btn, str)
  end,
  IntensifyShop_Group_Info_Group_Lv1_Btn_Intensify_Click = function(btn, str)
    Controller.ConfirmClick()
  end,
  IntensifyShop_Group_Info_Group_Lv2_Group_BuffAfter_Btn__Click = function(btn, str)
  end,
  IntensifyShop_Group_Buff_ScrollGrid_Buff_SetGrid = function(element, elementIndex)
    local data = DataModel.DataList[elementIndex]
    if data == nil then
      return
    end
    element.Img_Selected:SetActive(elementIndex == DataModel.CurSelect)
    if DataModel.onlyRefreshSelect then
      return
    end
    element.Img_Quality:SetSprite("UI/CubeRogue/QualityBG/Buff/Tiny/" .. data.quality)
    element.Txt_Name.Txt_:SetText(data.name)
    element.Img_Icon:SetSprite(data.icon)
    element.Group_LV.Img_Lv1:SetActive(not data.intensify)
    element.Group_LV.Img_Lv2:SetActive(data.intensify)
    element.Img_Recommend:SetActive(data.isRec == 1 and not data.intensify)
    element.Btn_Click:SetClickParam(elementIndex)
    local cfg = GetCA(data.id, "RogueBuffFactory")
    local liupaiCfg = GetCA(cfg.correspondingTeam, "RogueTeamFactory")
    element.Img_Type.Img_Type:SetSprite(liupaiCfg.shadePath)
  end,
  IntensifyShop_Group_Buff_ScrollGrid_Buff_Group_Buff_Btn_Click_Click = function(btn, str)
    local index = tonumber(str)
    Controller.Select(index)
    DataModel.onlyRefreshSelect = true
    View.Group_Buff.ScrollGrid_Buff.grid.self:RefreshAllElement()
    DataModel.onlyRefreshSelect = nil
  end
}
return ViewFunction
