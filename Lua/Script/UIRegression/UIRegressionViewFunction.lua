local View = require("UIRegression/UIRegressionView")
local DataModel = require("UIRegression/UIRegressionDataModel")
local Controller = require("UIRegression/UIRegressionController")
local CommonItem = require("Common/BtnItem")
local ViewFunction = {
  Regression_Group_Menu_Group_MenuItem_Btn_UnSelect_Click = function(btn, str)
  end,
  Regression_Group_Menu_StaticGrid_Menu_SetGrid = function(element, elementIndex)
    Controller:SetMenuElement(element, elementIndex)
  end,
  Regression_Group_Menu_StaticGrid_Menu_Group_MenuItem_Btn_UnSelect_Click = function(btn, str)
    Controller:SwitchMenuTab(tonumber(str))
  end,
  Regression_Group_SignIn_Group_Item_Img_SignedBG_Btn_Sign_Click = function(btn, str)
  end,
  Regression_Group_SignIn_Group_Item_Img_SignBG_Btn_Sign_Click = function(btn, str)
  end,
  Regression_Group_SignIn_Group_Item_Group_SignRWItem_Btn_Item_Click = function(btn, str)
  end,
  Regression_Group_SignIn_StaticGrid_Sign_SetGrid = function(element, elementIndex)
    Controller:SetSignInElement(element, elementIndex)
  end,
  Regression_Group_SignIn_StaticGrid_Sign_Group_Item_Img_SignedBG_Btn_Sign_Click = function(btn, str)
  end,
  Regression_Group_SignIn_StaticGrid_Sign_Group_Item_Img_SignBG_Btn_Sign_Click = function(btn, str)
    Controller:TrySignIn(tonumber(str))
  end,
  Regression_Group_SignIn_StaticGrid_Sign_Group_Item_Group_SignRWItem_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  Regression_Group_SignIn_Group_Sign_Img_ItemBG_ScrollGrid_Item_SetGrid = function(element, elementIndex)
    Controller:SetSignLastDayElement(element, elementIndex)
  end,
  Regression_Group_SignIn_Group_Sign_Img_ItemBG_ScrollGrid_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  Regression_Group_SignIn_Group_Sign_Btn_SignIn_Click = function(btn, str)
    Controller:TrySignIn(7)
  end,
  Regression_Group_Task_NewScrollGrid_Task_SetGrid = function(element, elementIndex)
    Controller:SetTaskElement(element, elementIndex)
  end,
  Regression_Group_Task_NewScrollGrid_Task_Group_TaskItem_Img_UnFinish_StaticGrid_BG_SetGrid = function(element, elementIndex)
  end,
  Regression_Group_Task_NewScrollGrid_Task_Group_TaskItem_Img_UnFinish_Btn_UnFinish_Click = function(btn, str)
    UIManager:GoHome()
  end,
  Regression_Group_Task_NewScrollGrid_Task_Group_TaskItem_Img_Finish_StaticGrid_BG_SetGrid = function(element, elementIndex)
  end,
  Regression_Group_Task_NewScrollGrid_Task_Group_TaskItem_Img_Finish_Btn_Finish_Click = function(btn, str)
    local row = DataModel.TaskElementData[tonumber(str)]
    if row then
      Net:SendProto("quest.recv_rewards", function(json)
        if json.reward then
          CommonTips.OpenShowItem(json.reward)
        end
        PlayerData.ServerData.quests.activity_quests[tostring(row.id)].recv = 1
        DataModel.InitTaskData()
        Controller:RefreshTaskElement()
      end, row.id)
    end
  end,
  Regression_Group_Task_NewScrollGrid_Task_Group_TaskItem_Img_Finish_Btn_Finished_Click = function(btn, str)
  end,
  Regression_Group_Task_NewScrollGrid_Task_Group_TaskItem_Group_ReWardItem_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  Regression_Group_Task_NewScrollGrid_Task_Group_TaskItem_Group_ReWardItem_StaticGrid_Item_SetGrid = function(element, elementIndex)
    Controller:SetTaskRewardElement(element, elementIndex)
  end,
  Regression_Group_Task_NewScrollGrid_Task_Group_TaskItem_Group_ReWardItem_StaticGrid_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  Regression_Group_Task_Img_Bottom_Img_ProgressBar_Group_Item_Btn_Check_Click = function(btn, str)
  end,
  Regression_Group_Task_Img_Bottom_Img_ProgressBar_Group_Item_Group_Get_Btn_Get_Click = function(btn, str)
  end,
  Regression_Group_Task_Img_Bottom_Img_ProgressBar_Group_Item_Img_RewardBG_Img_ItemBG_ScrollGrid_Item_SetGrid = function(element, elementIndex)
  end,
  Regression_Group_Task_Img_Bottom_Img_ProgressBar_Group_Item_Img_RewardBG_Img_ItemBG_ScrollGrid_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  Regression_Group_Task_Img_Bottom_Img_ProgressBar_StaticGrid_TaskReward_SetGrid = function(element, elementIndex)
    Controller:SetBottomTaskRewardElement(element, elementIndex)
  end,
  Regression_Group_Task_Img_Bottom_Img_ProgressBar_StaticGrid_TaskReward_Group_Item_Btn_Check_Click = function(btn, str)
    Controller:ShowTaskBottomRewardDetailElement(tonumber(str))
  end,
  Regression_Group_Task_Img_Bottom_Img_ProgressBar_StaticGrid_TaskReward_Group_Item_Group_Get_Btn_Get_Click = function(btn, str)
    Controller:TryGetTaskProcessReward(tonumber(str))
  end,
  Regression_Group_Task_Img_Bottom_Img_ProgressBar_StaticGrid_TaskReward_Group_Item_Img_RewardBG_Img_ItemBG_ScrollGrid_Item_SetGrid = function(element, elementIndex)
    local row = DataModel.BottomRewardDetailCfg[elementIndex]
    if row then
      CommonItem:SetItem(element, {
        id = row.id,
        num = row.num
      })
      element.Btn_Item:SetClickParam(row.id)
    end
  end,
  Regression_Group_Task_Img_Bottom_Img_ProgressBar_StaticGrid_TaskReward_Group_Item_Img_RewardBG_Img_ItemBG_ScrollGrid_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  Regression_Group_Buff_Group_BuffItem_Img_Mp3_Btn_Activate_Click = function(btn, str)
  end,
  Regression_Group_Buff_StaticGrid_Buff_SetGrid = function(element, elementIndex)
    Controller:SetBuffElement(element, elementIndex)
  end,
  Regression_Group_Buff_StaticGrid_Buff_Group_BuffItem_Img_Mp3_Btn_Activate_Click = function(btn, str)
    Controller:TryActivateBuff(tonumber(str))
  end,
  Regression_Group_News_Btn_Join_Click = function(btn, str)
    local targetId = DataModel.NewsElementData[DataModel.CurNewsIdx].data.id
    local activityMainController = require("UIActivityMain/UIActivityMainController")
    activityMainController:ClickLeftActiveById(targetId)
  end,
  Regression_Group_News_Group_Change_Btn_Left_Click = function(btn, str)
    Controller:ClickLeftNews()
  end,
  Regression_Group_News_Group_Change_Btn_Right_Click = function(btn, str)
    Controller:ClickRightNews()
  end,
  Regression_Group_News_Group_Change_StaticGrid_Point_SetGrid = function(element, elementIndex)
    element.Img_Select:SetActive(DataModel.CurNewsIdx == elementIndex)
  end,
  Regression_Group_Welcome_Btn_Close_Click = function(btn, str)
    Controller:TryGetWelcomeReward()
    View.Group_Welcome:SetActive(false)
  end,
  Regression_Group_Welcome_Img_BG_Img_Item_Group_SignRWItem_Btn_Item_Click = function(btn, str)
  end,
  Regression_Group_Welcome_Img_BG_Img_Item_ScrollGrid_Item_SetGrid = function(element, elementIndex)
    Controller:SetWelcomeRewardElement(element, elementIndex)
  end,
  Regression_Group_Welcome_Img_BG_Img_Item_ScrollGrid_Item_Group_SignRWItem_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  Regression_Group_Welcome_Img_BG_Btn_Get_Click = function(btn, str)
    Controller:TryGetWelcomeReward()
  end,
  Regression_Group_Task_Btn_Close_Click = function(btn, str)
    if DataModel.TaskRewardDetailPanel then
      DataModel.TaskRewardDetailPanel:SetActive(false)
      View.Group_Task.Btn_Close:SetActive(false)
    end
  end
}
return ViewFunction
