local View = require("UIEndlessBattleStore/UIEndlessBattleStoreView")
local DataModel = require("UIRandomBattleStore/UIRandomBattleStoreDataModel")
local ViewFunction = require("UIEndlessBattleStore/UIEndlessBattleStoreViewFunction")
local NPCDialog = require("Common/NPCDialog")
local EndlessDataModel = require("UIActivityEndlessBattle/UIActivityEndlessBattleDataModel")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    params = initParams
    local data = Json.decode(initParams)
    DataModel.init(data.activityId, data.shopId)
    View.self:StartC(LuaUtil.cs_generator(function()
      coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
      View.Group_Right.NewScrollGrid_CommodityList.grid.self:SetDataCount(#DataModel.shopList)
      View.Group_Right.NewScrollGrid_CommodityList.grid.self:RefreshAllElement()
      View.Group_Right.NewScrollGrid_CommodityList.grid.self:MoveToTop()
    end))
    NPCDialog.SetNPC(View.Group_NPC, DataModel.npcId)
    NPCDialog.SetNPCTextByEnum(View.Group_NPC, DataModel.NPCDialogEnum.enterText)
    local configCA = PlayerData:GetFactoryData(data.activityId)
    local coinCA = PlayerData:GetFactoryData(configCA.endlessBattleCoinId)
    DataModel.coinCA = coinCA
    local coinNum = 0
    if EndlessDataModel.user_endless ~= nil then
      coinNum = EndlessDataModel.user_endless.coin or 0
    end
    View.Group_CommomBottomLeft.Group_Items.Img_Icon:SetSprite(coinCA.iconPath)
    View.Group_CommomBottomLeft.Group_Items.Txt_Num:SetText(coinNum)
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
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
