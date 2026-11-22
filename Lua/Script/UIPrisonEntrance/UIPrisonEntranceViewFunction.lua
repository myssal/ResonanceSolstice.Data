local View = require("UIPrisonEntrance/UIPrisonEntranceView")
local DataModel = require("UIPrisonEntrance/UIPrisonEntranceDataModel")
local ViewFunction = {
  PrisonEntrance_Group_EntranceWindows_Group_Entrance_Btn_Overview_Click = function(btn, str)
  end,
  PrisonEntrance_Group_EntranceWindows_Group_Entrance_Btn_Order_Click = function(btn, str)
    Net:SendProto("prison.orders", function(json)
      UIManager:Open("UI/Prison/HYOrderStation/Record/HYOrderRecord", Json.encode({
        prison_orders = json.prison_orders
      }))
    end)
  end,
  PrisonEntrance_Group_EntranceWindows_Group_Entrance_Btn_PurchaseMachine_Click = function(btn, str)
    local prisonCA = PlayerData:GetFactoryData(86800014, "PrisonFactory")
    local shopList = {}
    for i, v in ipairs(prisonCA.prisonStoreList) do
      table.insert(shopList, v.id)
    end
    local shopIds = table.concat(shopList, ",")
    Net:SendProto("shop.info", function(json)
      PlayerData:RefreshShops(json.shops)
      UIManager:Open("UI/Prison/PrisonShop/PrisonShop")
    end, shopIds)
  end,
  PrisonEntrance_Group_EntranceWindows_Group_Entrance_Btn_PurchaseMaterial_Click = function(btn, str)
    local function callBack()
      UIManager:Open("UI/Prison/PurchaseOrder/PurchaseOrder")
    end
    
    PrisonData.PrisonRefresh(callBack)
  end,
  PrisonEntrance_Group_EntranceWindows_Group_Entrance_Btn_Warehouse_Click = function(btn, str)
    UIManager:Open("UI/Prison/PrisonWarehouse/PrisonWarehouse")
  end,
  PrisonEntrance_Group_EntranceWindows_Group_Entrance_Btn_Buiding_Click = function(btn, str)
  end,
  PrisonEntrance_Group_EntranceWindows_Group_Entrance_Btn_Investment_Click = function(btn, str)
  end,
  PrisonEntrance_Group_EntranceWindows_Group_Entrance_Btn_PrisonerList_Click = function(btn, str)
    UIManager:Open("UI/Prison/PrisonerList/PrisonerList", Json.encode({Mode = "Prison"}))
  end,
  PrisonEntrance_Group_EntranceWindows_Group_Entrance_Btn_Dormitory_Click = function(btn, str)
  end,
  PrisonEntrance_Btn_Close_Click = function(btn, str)
    View.self:CloseUI()
  end
}
return ViewFunction
