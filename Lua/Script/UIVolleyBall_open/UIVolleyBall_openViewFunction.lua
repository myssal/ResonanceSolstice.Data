local View = require("UIVolleyBall_open/UIVolleyBall_openView")
local DataModel = require("UIVolleyBall_open/UIVolleyBall_openDataModel")
local ViewFunction = {
  VolleyBall_open_Btn_Close_Click = function(btn, str)
    UIManager:GoBack()
  end,
  VolleyBall_open_Btn_1_Click = function(btn, str)
    UIManager:Open("UI/VolleyBall/VolleyBallChoose", Json.encode({
      gameMode = 1,
      currentName = DataModel.currentSceneName,
      playGroupBackParams = DataModel.playGroupBackParams
    }))
  end,
  VolleyBall_open_Btn_2_Click = function(btn, str)
    local isStart = DataModel.GameModeIsStart()
    if not isStart then
      View.Img_Mask2:SetActive(true)
      View.Btn_2:SetActive(false)
      return
    end
    if DataModel.remainCnt <= 0 then
      CommonTips.OpenTips(GetText(80607863))
      return
    end
    UIManager:Open("UI/VolleyBall/VolleyBallChoose", Json.encode({
      gameMode = 0,
      currentName = DataModel.currentSceneName,
      playGroupBackParams = DataModel.playGroupBackParams
    }))
  end,
  VolleyBall_open_Btn_2_Img_Num_Btn_Add_Click = function(btn, str)
    local itemId = 11400269
    local num = PlayerData:GetGoodsById(itemId).num
    if num <= 0 then
      CommonTips.OpenTips(80600488)
      return
    end
    local saleData = PlayerData:GetSaleItem(itemId, EnumDefine.Depot.Item)
    local params = {
      itemId = itemId,
      type = EnumDefine.OpenTip.Depot,
      saleData = saleData
    }
    CommonTips.OpenItem(params)
  end,
  VolleyBall_open_Btn_Help_Click = function(btn, str)
    local data = {helpId = 80304047}
    UIManager:Open("UI/VolleyBall/Group_Help", Json.encode(data))
  end
}
return ViewFunction
