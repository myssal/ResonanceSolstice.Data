local View = require("UITrailerSpeedAdd/UITrailerSpeedAddView")
local DataModel = require("UITrailerSpeedAdd/UITrailerSpeedAddDataModel")
local CommonItem = require("Common/BtnItem")
local ViewFunction = {
  TrailerSpeedAdd_Btn_Close_Click = function(btn, str)
    UIManager:GoBack()
  end,
  TrailerSpeedAdd_Btn_Cancel_Click = function(btn, str)
    UIManager:GoBack()
  end,
  TrailerSpeedAdd_Btn_LevelUp_Click = function(btn, str)
    local trailerLv = PlayerData:GetHomeInfo().back_lv
    local trailerConfig = PlayerData:GetFactoryData(99900060, "ConfigFactory")
    local trailerMaxLv = trailerConfig.trailerMaxLv
    if trailerLv == trailerMaxLv then
      CommonTips.OpenTips(80607076)
      return
    end
    Net:SendProto("home.upgrade_back", function(json)
      PlayerData:RefreshUseItems(DataModel.use)
      PlayerData:GetHomeInfo().back_lv = PlayerData:GetHomeInfo().back_lv + 1
      local mainController = require("UIMainUI/UIMainUIController")
      mainController:InitCommonShow()
      if PlayerData:GetHomeInfo().back_lv == trailerMaxLv then
        UIManager:GoBack(false)
      end
      UIManager:Open("UI/MainUI/TrailerSpeedAddSuccess")
    end)
  end,
  TrailerSpeedAdd_Group_List_ScrollGrid_List_SetGrid = function(element, elementIndex)
    local trailerLv = PlayerData:GetHomeInfo().back_lv
    local trailerConfig = PlayerData:GetFactoryData(99900060, "ConfigFactory")
    local trailerUpgradeCost = trailerConfig.trailerUpgradeCost
    local listId = trailerUpgradeCost[trailerLv + 1].id
    local ListConfig = PlayerData:GetFactoryData(listId, "ListFactory")
    local costList = ListConfig.goodsList
    local itemId = costList[tonumber(elementIndex)].id
    local itemNum = costList[tonumber(elementIndex)].num
    CommonItem:SetItem(element.Group_Item, {id = itemId}, EnumDefine.ItemType.Material)
    local haveItem = PlayerData:GetGoodsById(itemId)
    local haveNum = haveItem.num or 0
    if itemId == 11400001 then
      element.Group_Cost.Txt_Need:SetText(PlayerData:NumToFormatString(itemNum, 1))
      element.Group_Cost.Txt_Have:SetText(PlayerData:NumToFormatString(haveNum, 1))
    else
      element.Group_Cost.Txt_Need:SetText(itemNum)
      element.Group_Cost.Txt_Have:SetText(haveNum)
    end
    if itemNum <= haveNum then
      element.Group_Cost.Txt_Have:SetColor(UIConfig.Color.White)
    else
      element.Group_Cost.Txt_Have:SetColor(UIConfig.Color.Red)
    end
    element.Group_Item.Btn_Item:SetClickParam(itemId)
    DataModel.use[itemId] = itemNum
  end,
  TrailerSpeedAdd_Group_List_ScrollGrid_List_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenRewardDetail(tonumber(str))
  end
}
return ViewFunction
