local View = require("UIRandomBattleStore/UIRandomBattleStoreView")
local DataModel = require("UIRandomBattleStore/UIRandomBattleStoreDataModel")
local ViewFunction = require("UIRandomBattleStore/UIRandomBattleStoreViewFunction")
local NPCDialog = require("Common/NPCDialog")
local params
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
    local configCA = PlayerData:GetFactoryData(99900113)
    local coinCA = PlayerData:GetFactoryData(configCA.randomBattleCoinId)
    DataModel.coinCA = coinCA
    local coinNum = math.min(PlayerData:GetGoodsById(coinCA.id).num, 9999)
    View.Group_CommomBottomLeft.Group_Items.Img_Icon:SetSprite(coinCA.iconPath)
    View.Group_CommomBottomLeft.Group_Items.Txt_Num:SetText(string.format("%04d", coinNum))
    View.Img_Icon:SetSprite(GetResPath(88300153))
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
