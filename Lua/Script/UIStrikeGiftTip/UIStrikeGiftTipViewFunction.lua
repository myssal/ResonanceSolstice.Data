local View = require("UIStrikeGiftTip/UIStrikeGiftTipView")
local DataModel = require("UIStrikeGiftTip/UIStrikeGiftTipDataModel")
local ViewFunction = {
  StrikeGiftTip_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(DataModel.id)
  end,
  StrikeGiftTip_Btn_Confirm_Click = function(btn, str)
    Net:SendProto("home.recv_train_weapon", function(json)
      for k, v in pairs(json.reward.battery) do
        PlayerData:GetHomeInfo().coach[1].battery[1] = k
        PlayerData:GetHomeInfo().weapon_gift.ram = 1
      end
      TrainWeaponTag.CalTrainWeaponAllAttributes()
    end, "ram")
    UIManager:ClosePanel(false)
  end
}
return ViewFunction
