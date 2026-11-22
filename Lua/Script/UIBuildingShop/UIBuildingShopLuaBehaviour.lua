local View = require("UIBuildingShop/UIBuildingShopView")
local DataModel = require("UIBuildingShop/UIBuildingShopDataModel")
local Controller = require("UIBuildingShop/UIBuildingShopController")
local ViewFunction = require("UIBuildingShop/UIBuildingShopViewFunction")
local NPCDialog = require("Common/NPCDialog")

local function PlayNPCTalk(npcId, talk_type)
  local npcConfig = PlayerData:GetFactoryData(npcId, "NPCFactory")
  local textTable = npcConfig[talk_type]
  if textTable then
    NPCDialog.SetNPCText(View.Group_NPC, textTable, talk_type)
  end
end

local Luabehaviour = {
  serialize = function()
    return Json.encode(DataModel.initParams)
  end,
  deserialize = function(initParams)
    DataModel.initParams = Json.decode(initParams)
    Controller:Init()
    local buildCfg = PlayerData:GetFactoryData(DataModel.initParams.buildId)
    View.Img_BG:SetSprite(buildCfg.bgPath)
    View.Group_Store.Img_BG.Img_:SetSprite(buildCfg.pagePath)
    View.Group_Store.Img_Fornitureicon:SetSprite(buildCfg.storePath)
    View.Group_Store.Img_LittleTittle:SetSprite(buildCfg.storeTag)
    View.Group_Store.Txt_Title:SetText(buildCfg.storeName)
    View.Group_Store.Group_StoreTab.Img_BG:SetSprite(buildCfg.tabPath)
    View.Group_NPC.self:SetActive(true)
    NPCDialog.SetNPC(View.Group_NPC, buildCfg.npcId)
    PlayNPCTalk(buildCfg.npcId, "enterText")
    local stationConfig = PlayerData:GetFactoryData(DataModel.stationId, "HomeStationFactory")
    View.Group_NpcInfo.Group_Station.Txt_Station:SetText(stationConfig.name)
    View.Group_NpcInfo.Img_Icon:SetSprite(stationConfig.buildingIconPath)
    View.Group_NpcInfo.Txt_Title:SetText(buildCfg.name)
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
