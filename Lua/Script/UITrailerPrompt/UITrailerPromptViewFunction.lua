local View = require("UITrailerPrompt/UITrailerPromptView")
local DataModel = require("UITrailerPrompt/UITrailerPromptDataModel")
local MapDataModel = require("UIHome/UIHomeMapDataModel")
local ViewFunction = {
  TrailerPrompt_Btn_BG_Click = function(btn, str)
    UIManager:GoBack(false)
  end,
  TrailerPrompt_Btn_Cancel_Click = function(btn, str)
    UIManager:GoBack(false)
  end,
  TrailerPrompt_Btn_Confirm_Click = function(btn, str)
    UIManager:GoBack(false)
    local MainController = require("UIMainUI/UIMainUIController")
    MainController.GoToNewCity(nil, nil, true, DataModel.type, DataModel.mileage)
  end,
  TrailerPrompt_Group_speedAdd_Btn_Confirm_Click = function(btn, str)
    local trailerLv = PlayerData:GetHomeInfo().back_lv
    local trailerConfig = PlayerData:GetFactoryData(99900060, "ConfigFactory")
    local trailerMaxLv = trailerConfig.trailerMaxLv
    if trailerLv == trailerMaxLv then
      CommonTips.OpenTips(80607076)
      return
    end
    UIManager:Open("UI/MainUI/TrailerSpeedAdd")
  end,
  TrailerPrompt_Group_Check_Btn_Gold_Click = function(btn, str)
    if DataModel.type ~= "gold" then
      DataModel.type = "gold"
      local gold = math.floor(DataModel.distance / DataModel.unit.dis * DataModel.unit.price + 0.5)
      DataModel.mileage = 0
      View.Group_Price.Txt_Price:SetText(DataModel.unit.price)
      View.Group_Free.self:SetActive(gold == 0)
      View.Group_Check.Btn_Mileage.Group_On.self:SetActive(false)
      View.Group_Check.Btn_Mileage.Group_Off.self:SetActive(true)
      View.Group_Check.Btn_Gold.Group_On.self:SetActive(true)
      View.Group_Check.Btn_Gold.Group_Off.self:SetActive(false)
    end
  end,
  TrailerPrompt_Group_Check_Btn_Mileage_Click = function(btn, str)
    if DataModel.type ~= "mileage" then
      DataModel.type = "mileage"
      local mileage = math.floor(DataModel.distance / DataModel.unit.dis * DataModel.unit.mileage + 0.5)
      DataModel.mileage = mileage
      View.Group_Price.Txt_Price:SetText(DataModel.unit.mileage)
      View.Group_Free.self:SetActive(mileage == 0)
      View.Group_Check.Btn_Mileage.Group_On.self:SetActive(true)
      View.Group_Check.Btn_Mileage.Group_Off.self:SetActive(false)
      View.Group_Check.Btn_Gold.Group_On.self:SetActive(false)
      View.Group_Check.Btn_Gold.Group_Off.self:SetActive(true)
    end
  end,
  TrailerPrompt_Btn_UseItem_Click = function(btn, str)
    local trailerConfig = PlayerData:GetFactoryData(99900060, "ConfigFactory")
    local t = {}
    t.itemId = trailerConfig.trailerItem
    t.itemNum = PlayerData:GetGoodsById(t.itemId).num
    t.useNum = 1
    if t.itemNum < t.useNum then
      CommonTips.OpenTips(80600488)
      return
    end
    local itemCA = PlayerData:GetFactoryData(t.itemId, "ItemFactory")
    CommonTips.OnItemPrompt(string.format(GetText(80607610), itemCA.name), t, function()
      UIManager:GoBack(false)
      local MainController = require("UIMainUI/UIMainUIController")
      MainController.GoToNewCity(nil, nil, true, DataModel.type, DataModel.mileage)
    end)
  end
}
return ViewFunction
