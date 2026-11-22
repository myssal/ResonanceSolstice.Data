local View = require("UIPlayer/UIPlayerView")
local DataModel = require("UIPlayer/UIPlayerDataModel")
local ViewFunction = require("UIPlayer/UIPlayerViewFunction")
local Controller = require("UIPlayer/UIPlayerController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Controller:InitView()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if DataModel.isRequestPayResult then
      DataModel.timer = DataModel.timer + Time.deltaTime
      if DataModel.timer > DataModel.time then
        DataModel.timer = 0
        DataModel.index = DataModel.index + 1
        DataModel.isRequestPayResult = false
        if DataModel.times >= DataModel.index then
          Net:SendProto("pay.query_oid", function(json)
            UIManager:CloseTip("UI/Common/Waiting")
            local count = PlayerData:GetFactoryData(DataModel.Product.ProductID, "ValuableFactory").rewardList[1].num
            local reward = {
              bm_rock = {
                ["11400005"] = {num = count}
              }
            }
            CommonTips.OpenShowItem(reward)
            View.Img_Mask:SetActive(false)
          end, DataModel.OrderID, function(json)
            DataModel.isRequestPayResult = true
            DataModel.msg = json.msg
          end)
        else
          if DataModel.msg == nil then
            DataModel.msg = ""
          end
          CommonTips.OnPromptConfirmOnly(DataModel.msg .. ",\232\175\183\232\129\148\231\179\187\229\174\162\230\156\141(\230\156\170\231\191\187\232\175\145)", "\231\161\174\232\174\164", function()
            View.Img_Mask:SetActive(false)
          end, true)
        end
      end
    end
  end,
  ondestroy = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
