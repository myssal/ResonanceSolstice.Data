local View = require("UIGoodsTips/UIGoodsTipsView")
local DataModel = require("UIGoodsTips/UIGoodsTipsDataModel")
local ViewFunction = {
  GoodsTips_Btn_BG_Click = function(btn, str)
    View.self:CloseUI(true)
    View.self:Confirm()
  end,
  GoodsTips_Group_Show_Group_GetWay_Btn_Access_Click = function(btn, str)
    local data = {}
    data.itemID = DataModel.Id
    data.posX = 400
    data.posY = -40
    UIManager:Open("UI/Common/Group_GetWay", Json.encode(data))
  end,
  GoodsTips_Group_Show_Group_Lock_Btn_Unlock_Click = function(btn, str)
    Net:SendProto("station.update_goods_lock", function(json)
      PlayerData:GetHomeInfo().warehouse[tostring(DataModel.Id)].is_locked = 1
      View.Group_Show.Group_Lock.Btn_Lock:SetActive(true)
      View.Group_Show.Group_Lock.Btn_Unlock:SetActive(false)
    end, DataModel.Id, nil)
  end,
  GoodsTips_Group_Show_Group_Lock_Btn_Lock_Click = function(btn, str)
    Net:SendProto("station.update_goods_lock", function(json)
      PlayerData:GetHomeInfo().warehouse[tostring(DataModel.Id)].is_locked = 0
      View.Group_Show.Group_Lock.Btn_Lock:SetActive(false)
      View.Group_Show.Group_Lock.Btn_Unlock:SetActive(true)
    end, nil, DataModel.Id)
  end
}
return ViewFunction
