local View = require("UIVolleyBallMain/UIVolleyBallMainView")
local DataModel = require("UIVolleyBallMain/UIVolleyBallMainDataModel")
local Ctrl = require("UIVolleyBallMain/UIVolleyBallMainController")
local CommonItem = require("Common/BtnItem")
local ViewFunction = {
  VolleyBallMain_Group_Common_Btn_Return_Click = function(btn, str)
    if DataModel.WaitNetResult then
      CommonTips.OpenTips(GetText(80608434))
      return
    end
    if DataModel.IsPlayAnim then
      return
    end
    DataModel.VolleyGameManager.isGameStart = false
    View.Group_Common.Group_Pause:SetActive(true)
  end,
  VolleyBallMain_Group_Common_Group_Pause_Btn_Exit_Click = function(btn, str)
    View.Group_Common.Group_Pause:SetActive(false)
    Ctrl.ShowLose(true)
  end,
  VolleyBallMain_Group_Common_Group_Pause_Btn_Continue_Click = function(btn, str)
    DataModel.VolleyGameManager.isGameStart = true
    View.Group_Common.Group_Pause:SetActive(false)
  end,
  VolleyBallMain_Group_QTE_Btn_Click_Click = function(btn, str)
    if not DataModel.isStart or DataModel.PlayerQTE ~= nil then
      return
    end
    local player = DataModel.VolleyGameManager.playerTeam == 0 and View.Group_QTE.Img_LeftQTE or View.Group_QTE.Img_RightQTE
    local prate = player.Img.fillAmount
    DataModel.PlayerQTE = prate
  end,
  VolleyBallMain_Group_Over_Group_Btns_Btn_Over_Click = function(btn, str)
    if PlayerData.volleyBallData.playGroupBackParams then
      PlayerData.OpenToPlayground(PlayerData.volleyBallData.playGroupBackParams)
    else
      CBus:ChangeScene(PlayerData.volleyBallData.currentSceneName, function()
        UIManager:Open("UI/Activity/ActivityMain", Json.encode({id = 86000016}))
      end)
    end
  end,
  VolleyBallMain_Group_Over_Group_Btns_Btn_ReStartGame_Click = function(btn, str)
    if PlayerData.volleyBallData.gameMode == 0 then
      local cfgCA = PlayerData:GetFactoryData(DataModel.VolleyGameManager.ca.id)
      if PlayerData:GetHomeInfo().vb_num >= cfgCA.rewardNum then
        CommonTips.OpenTips(GetText(80607863))
        return
      end
    end
    if DataModel.VolleyGameManager.curRoleUI then
      DataModel.VolleyGameManager.curRoleUI.transform:SetParent(nil)
      DataModel.VolleyGameManager.curRoleUI.transform.position = Vector3(0, 10000, 0)
    end
    View.Group_Over:SetActive(false)
    UIManager:Open("UI/VolleyBall/VolleyBallChoose", Json.encode({
      gameMode = PlayerData.volleyBallData.gameMode,
      currentName = PlayerData.volleyBallData.currentSceneName,
      playGroupBackParams = PlayerData.volleyBallData.playGroupBackParams
    }))
  end,
  VolleyBallMain_Group_Over_Group_Result_Img_RewordBG_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  VolleyBallMain_Group_Over_Group_Result_Group_Players_Img_Photo1_Btn_ProfilePhoto1_Click = function(btn, str)
  end,
  VolleyBallMain_Group_Over_Group_Result_Group_Players_Img_Photo2_Btn_ProfilePhoto2_Click = function(btn, str)
  end,
  VolleyBallMain_Group_Over_Group_Result_Img_RewordBG_ScrollGrid__SetGrid = function(element, elementIndex)
    CommonItem:SetItem(element, DataModel.Rewards[elementIndex], EnumDefine.ItemType.Item)
  end,
  VolleyBallMain_Group_Over_Group_Result_Img_RewordBG_ScrollGrid__Group_Item_Btn_Item_Click = function(btn, str)
  end
}
return ViewFunction
