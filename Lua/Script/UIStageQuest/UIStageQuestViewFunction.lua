local CommonItem = require("Common/BtnItem")
local View = require("UIStageQuest/UIStageQuestView")
local Controller = require("UIStageQuest/UIStageQuestController")
local DataModel = require("UIStageQuest/UIStageQuestDataModel")
local ViewFunction = {
  StageQuest_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    if DataModel.IsBattleReturn then
      UIManager:GoHome()
    else
      UIManager:GoBack()
    end
  end,
  StageQuest_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  StageQuest_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  StageQuest_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  StageQuest_Btn_Daily_Click = function(btn, str)
    DataModel.TitleChoose = DataModel.TitleType.Daily
    Controller:ClickTopTitle()
  end,
  StageQuest_Btn_Stage_Click = function(btn, str)
    DataModel.TitleChoose = DataModel.TitleType.Stage
    Controller:ClickTopTitle()
  end,
  StageQuest_Group_Stage_Group_Quest_ScrollGrid_Quest_SetGrid = function(element, elementIndex)
    Controller:SetQuestGridElelment(element, elementIndex)
  end,
  StageQuest_Group_Stage_Group_Quest_ScrollGrid_Quest_Group_Item_Group_On_Btn_Get_Click = function(btn, str)
    Controller:QuestGet(tonumber(str))
  end,
  StageQuest_Group_Stage_Group_Quest_ScrollGrid_Quest_Group_Item_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  StageQuest_Group_Stage_Group_Quest_ScrollGrid_Quest_Group_Item_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:SetQuestGridRewardElelment(element, elementIndex)
  end,
  StageQuest_Group_Stage_Group_Quest_ScrollGrid_Quest_Group_Item_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  StageQuest_Group_Stage_Group_1_Group_Stage_Group_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  StageQuest_Group_Stage_Group_1_Group_Stage_Group_Reward_StaticGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:SetLeftGridRewardElelment(element, elementIndex)
  end,
  StageQuest_Group_Stage_Group_1_Group_Stage_Group_Reward_StaticGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  StageQuest_Group_Stage_Group_1_Group_Stage_Group_Reward_Btn_Get_Click = function(btn, str)
    Controller:StageGet(tonumber(str))
  end,
  StageQuest_Group_Stage_Group_1_Group_Stage_Btn_L_Click = function(btn, str)
    Controller:ChangeLeft()
  end,
  StageQuest_Group_Stage_Group_1_Group_Stage_Btn_R_Click = function(btn, str)
    Controller:ChangeRight()
  end,
  StageQuest_Group_Stage_Group_2_Group_Stage_Group_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  StageQuest_Group_Stage_Group_2_Group_Stage_Group_Reward_StaticGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:SetLeftGridRewardElelment(element, elementIndex)
  end,
  StageQuest_Group_Stage_Group_2_Group_Stage_Group_Reward_StaticGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  StageQuest_Group_Stage_Group_2_Group_Stage_Group_Reward_Btn_Get_Click = function(btn, str)
    Controller:StageGet(tonumber(str))
  end,
  StageQuest_Group_Stage_Group_2_Group_Stage_Btn_L_Click = function(btn, str)
    Controller:ChangeLeft()
  end,
  StageQuest_Group_Stage_Group_2_Group_Stage_Btn_R_Click = function(btn, str)
    Controller:ChangeRight()
  end,
  StageQuest_Group_Stage_Group_3_Group_Stage_Group_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  StageQuest_Group_Stage_Group_3_Group_Stage_Group_Reward_StaticGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:SetLeftGridRewardElelment(element, elementIndex)
  end,
  StageQuest_Group_Stage_Group_3_Group_Stage_Group_Reward_StaticGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  StageQuest_Group_Stage_Group_3_Group_Stage_Group_Reward_Btn_Get_Click = function(btn, str)
    Controller:StageGet(tonumber(str))
  end,
  StageQuest_Group_Stage_Group_3_Group_Stage_Btn_L_Click = function(btn, str)
    Controller:ChangeLeft()
  end,
  StageQuest_Group_Stage_Group_3_Group_Stage_Btn_R_Click = function(btn, str)
    Controller:ChangeRight()
  end,
  StageQuest_Group_Stage_Group_4_Group_Stage_Group_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  StageQuest_Group_Stage_Group_4_Group_Stage_Group_Reward_StaticGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:SetLeftGridRewardElelment(element, elementIndex)
  end,
  StageQuest_Group_Stage_Group_4_Group_Stage_Group_Reward_StaticGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  StageQuest_Group_Stage_Group_4_Group_Stage_Group_Reward_Btn_Get_Click = function(btn, str)
    Controller:StageGet(tonumber(str))
  end,
  StageQuest_Group_Stage_Group_4_Group_Stage_Btn_L_Click = function(btn, str)
    Controller:ChangeLeft()
  end,
  StageQuest_Group_Stage_Group_4_Group_Stage_Btn_R_Click = function(btn, str)
    Controller:ChangeRight()
  end,
  StageQuest_Group_Stage_Group_5_Group_Stage_Group_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  StageQuest_Group_Stage_Group_5_Group_Stage_Group_Reward_StaticGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:SetLeftGridRewardElelment(element, elementIndex)
  end,
  StageQuest_Group_Stage_Group_5_Group_Stage_Group_Reward_StaticGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  StageQuest_Group_Stage_Group_5_Group_Stage_Group_Reward_Btn_Get_Click = function(btn, str)
    Controller:StageGet(tonumber(str))
  end,
  StageQuest_Group_Stage_Group_5_Group_Stage_Btn_L_Click = function(btn, str)
    Controller:ChangeLeft()
  end,
  StageQuest_Group_Stage_Group_5_Group_Stage_Btn_R_Click = function(btn, str)
    Controller:ChangeRight()
  end,
  StageQuest_Group_Stage_Group_Btn_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  StageQuest_Group_Stage_Group_Btn_StaticGrid_TopList_SetGrid = function(element, elementIndex)
    Controller:SetTopGridElelment(element, elementIndex)
  end,
  StageQuest_Group_Stage_Group_Btn_StaticGrid_TopList_Group_Item_Btn_Item_Click = function(btn, str)
    Controller:ClickTopBtn(tonumber(str))
  end,
  StageQuest_Group_Daily_ScrollGrid_Quest_SetGrid = function(element, elementIndex)
    local row = DataModel.DailyQuestList[tonumber(elementIndex)]
    element.Group_On.Btn_Get:SetClickParam(elementIndex)
    element.Group_Off:SetActive(row.type == EnumDefine.EQuestState.Lock or row.type == EnumDefine.EQuestState.UnFinish)
    element.Group_On:SetActive(row.type == EnumDefine.EQuestState.Finish)
    element.Group_Got:SetActive(row.type == EnumDefine.EQuestState.Receive)
    element.Img_Mask:SetActive(row.type == EnumDefine.EQuestState.Receive)
    element.Txt_Des:SetText(row.des)
    element.Txt_Num:SetText("+" .. row.ap)
    element.Txt_Progress:SetText(row.numNow .. "/" .. row.numMax)
    element.Group_Off.Btn_Jump:SetActive(row.isSwitchUI)
    element.Group_Off.Btn_Jump:SetClickParam(elementIndex)
  end,
  StageQuest_Group_Daily_ScrollGrid_Quest_Group_Item_Group_On_Btn_Get_Click = function(btn, str)
    Controller:DailyQuestGet()
  end,
  StageQuest_Group_Daily_ScrollGrid_Quest_Group_Item_Group_Off_Btn_Jump_Click = function(btn, str)
    local row = DataModel.DailyQuestList[tonumber(str)]
    if row.isSwitchUI == false or row.switchUI == "" then
      return
    end
    if row.switchUI == "UI/RevenueOverview/RevenueOverview" then
      Net:SendProto("main.revenue_record", function(json)
        UIManager:Open(row.switchUI, Json.encode({
          incomeRecord = json.revenue_record
        }))
      end, PlayerData:GetUserInfo().uid)
      return
    end
    if row.switchUI == "UI/Depot/Depot" then
      UIManager:Open(row.switchUI, Json.encode(tonumber(row.switchParameter)))
      return
    end
    if row.switchParameter ~= "" then
      UIManager:Open(row.switchUI, Json.encode({
        switchParameter = row.switchParameter
      }))
      return
    end
    UIManager:Open(row.switchUI)
  end,
  StageQuest_Group_Daily_Group_Activity_Group_Progress_Group_Item_Btn_Get_Click = function(btn, str)
  end,
  StageQuest_Group_Daily_Group_Activity_Group_Progress_Group_Item_Btn_UnGet_Click = function(btn, str)
  end,
  StageQuest_Group_Daily_Group_Activity_Group_Progress_Group_Item_Btn_Got_Click = function(btn, str)
  end,
  StageQuest_Group_Daily_Group_Activity_Group_Progress_Group_Item_Group_Show_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  StageQuest_Group_Daily_Group_Activity_Group_Progress_StaticGrid_Reward_SetGrid = function(element, elementIndex)
    local row = DataModel.ApRewardList[tonumber(elementIndex)]
    local ap = row.ap
    element.Txt_Num:SetText(ap)
    element.Group_Show:SetActive(false)
    element.Btn_Get:SetClickParam(elementIndex)
    element.Btn_UnGet:SetClickParam(elementIndex)
    element.Btn_Got:SetClickParam(elementIndex)
    element.Group_Show.Group_Item.Btn_Item:SetClickParam(row.id)
    element.Btn_UnGet:SetActive(row.state == DataModel.DailyStateE.lock)
    element.Btn_Got:SetActive(row.state == DataModel.DailyStateE.receive)
    element.Btn_Get:SetActive(row.state == DataModel.DailyStateE.finish)
  end,
  StageQuest_Group_Daily_Group_Activity_Group_Progress_StaticGrid_Reward_Group_Item_Btn_Get_Click = function(btn, str)
    Controller:ClickDailyReward(tonumber(str))
  end,
  StageQuest_Group_Daily_Group_Activity_Group_Progress_StaticGrid_Reward_Group_Item_Btn_UnGet_Click = function(btn, str)
    Controller:ClickDailyReward(tonumber(str))
  end,
  StageQuest_Group_Daily_Group_Activity_Group_Progress_StaticGrid_Reward_Group_Item_Btn_Got_Click = function(btn, str)
    Controller:ClickDailyReward(tonumber(str))
  end,
  StageQuest_Group_Daily_Group_Activity_Group_Progress_StaticGrid_Reward_Group_Item_Group_Show_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(str)
  end,
  StageQuest_Btn_Battle_Click = function(btn, str)
    DataModel.TitleChoose = DataModel.TitleType.Battle
    Controller:ClickTopTitle()
  end,
  StageQuest_Group_Battle_Group_Left_ScrollGrid_Left_SetGrid = function(element, elementIndex)
    local row = DataModel.BattleList[elementIndex]
    element.Btn_Label:SetClickParam(elementIndex)
    element.Btn_Label.Group_On.Txt_T:SetText(row.nameText)
    element.Btn_Label.Group_Off.Txt_T:SetText(row.nameText)
    element.Btn_Label.Group_On.Txt_D:SetText(row.desText)
    element.Btn_Label.Group_Off.Txt_D:SetText(row.desText)
    element.Btn_Label.Group_On:SetActive(elementIndex == DataModel.BattleLeftIndex)
    element.Btn_Label.Group_Off:SetActive(elementIndex ~= DataModel.BattleLeftIndex)
  end,
  StageQuest_Group_Battle_Group_Left_ScrollGrid_Left_Group_Item_Btn_Label_Click = function(btn, str)
    if DataModel.BattleLeftIndex == tonumber(str) then
      return
    end
    Controller:ClickBattleLeftList(tonumber(str))
  end,
  StageQuest_Group_Battle_Group_Right_Group_Material_Group_Level_ScrollGrid_Level_SetGrid = function(element, elementIndex)
    local row = DataModel.ChooseLeftData[elementIndex]
    element.Btn_Enter:SetClickParam(elementIndex)
    element.Txt_Name:SetText(row.name)
    element.Img_Mask.Spine_Head:SetData(row.resDir)
    element.Img_Mask.Spine_Head.transform.localPosition = Vector3(row.spineX, row.spineY, 0)
    element.Img_Mask.Spine_Head:SetLocalScale(Vector3(row.spineScale, row.spineScale, 1))
    element.Group_Cost.Txt_Num:SetText("-" .. row.cost)
    element.Group_Reward.ScrollGrid_Reward.grid.self:SetParentParam(elementIndex)
    element.Group_Reward.ScrollGrid_Reward.grid.self:SetDataCount(table.count(row.rewardViewList))
    element.Group_Reward.ScrollGrid_Reward.grid.self:RefreshAllElement()
    element.Group_Reward.ScrollGrid_Reward.grid.self:MoveToTop()
    element.Group_Reward.ScrollGrid_Reward.grid.self.ScrollRect.enabled = true
    element.Group_Closed:SetActive(not row.isActivity)
    element.Group_Closed.Txt_Tip:SetText(GetText(row.closedTextId))
  end,
  StageQuest_Group_Battle_Group_Right_Group_Material_Group_Level_ScrollGrid_Level_Group_Item_Group_Reward_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local index = tonumber(element.ParentParam)
    local row = DataModel.ChooseLeftData[index]
    local rewardList = row.rewardViewList
    CommonItem:SetItem(element.Group_Item, {
      id = rewardList[elementIndex].id,
      num = rewardList[elementIndex].num
    }, EnumDefine.ItemType.Item)
    element.Group_Item.Btn_Item:SetClickParam(rewardList[elementIndex].id)
  end,
  StageQuest_Group_Battle_Group_Right_Group_Material_Group_Level_ScrollGrid_Level_Group_Item_Group_Reward_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  StageQuest_Group_Battle_Group_Right_Group_Material_Group_Level_ScrollGrid_Level_Group_Item_Btn_Enter_Click = function(btn, str)
    if DataModel.BattleList[DataModel.BattleLeftIndex].materialLevelTimes - DataModel.BattleCurrentNum <= 0 then
      CommonTips.OpenTips(80610269)
      return
    end
    local row = DataModel.BattleList[DataModel.BattleLeftIndex]
    local data = DataModel.ChooseLeftData[tonumber(str)]
    if data.isActivity == false then
      CommonTips.OpenTips(80610399)
      return
    end
    if CommonTips.GuideAsset() then
      return
    end
    DataModel.BattleRightIndex = tonumber(str)
    UIManager:Open(row.prefabPath, Json.encode({
      id = data.id,
      maxNum = row.materialLevelTimes,
      titleIndex = DataModel.TitleChoose,
      battleLeftIndex = DataModel.BattleLeftIndex
    }))
  end,
  StageQuest_Group_Battle_Group_Right_Group_EquipmentDay_Group_Level_ScrollGrid_Level_SetGrid = function(element, elementIndex)
    local row = DataModel.ChooseLeftData[elementIndex]
    element.Btn_Enter:SetClickParam(elementIndex)
    element.Txt_Name:SetText(row.name)
    element.Img_Mask.Spine_Head:SetData(row.resDir)
    element.Img_Mask.Spine_Head.transform.localPosition = Vector3(row.spineX, row.spineY, 0)
    element.Img_Mask.Spine_Head:SetLocalScale(Vector3(row.spineScale, row.spineScale, 1))
    element.Group_Cost.Txt_Num:SetText("-" .. row.cost)
    element.Group_Reward.ScrollGrid_Reward.grid.self:SetParentParam(elementIndex)
    element.Group_Reward.ScrollGrid_Reward.grid.self:SetDataCount(table.count(row.rewardViewList))
    element.Group_Reward.ScrollGrid_Reward.grid.self:RefreshAllElement()
    element.Group_Reward.ScrollGrid_Reward.grid.self:MoveToTop()
    element.Group_Reward.ScrollGrid_Reward.grid.self.ScrollRect.enabled = true
    element.Group_Closed:SetActive(not row.isActivity)
    element.Group_Closed.Txt_Tip:SetText(GetText(row.closedTextId))
  end,
  StageQuest_Group_Battle_Group_Right_Group_EquipmentDay_Group_Level_ScrollGrid_Level_Group_Item_Group_Reward_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local index = tonumber(element.ParentParam)
    local row = DataModel.ChooseLeftData[index]
    local rewardList = row.rewardViewList
    CommonItem:SetItem(element.Group_Item, {
      id = rewardList[elementIndex].id,
      num = rewardList[elementIndex].num
    }, EnumDefine.ItemType.Item)
    element.Group_Item.Btn_Item:SetClickParam(rewardList[elementIndex].id)
  end,
  StageQuest_Group_Battle_Group_Right_Group_EquipmentDay_Group_Level_ScrollGrid_Level_Group_Item_Group_Reward_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  StageQuest_Group_Battle_Group_Right_Group_EquipmentDay_Group_Level_ScrollGrid_Level_Group_Item_Btn_Enter_Click = function(btn, str)
    if DataModel.BattleList[DataModel.BattleLeftIndex].materialLevelTimes - DataModel.BattleCurrentNum <= 0 then
      CommonTips.OpenTips(80610269)
      return
    end
    local row = DataModel.BattleList[DataModel.BattleLeftIndex]
    local data = DataModel.ChooseLeftData[tonumber(str)]
    if data.isActivity == false then
      CommonTips.OpenTips(80610399)
      return
    end
    if CommonTips.GuideAsset() then
      return
    end
    DataModel.BattleRightIndex = tonumber(str)
    UIManager:Open(row.prefabPath, Json.encode({
      id = data.id,
      maxNum = row.materialLevelTimes,
      titleIndex = DataModel.TitleChoose,
      battleLeftIndex = DataModel.BattleLeftIndex
    }))
  end,
  StageQuest_Group_Battle_Group_Right_Group_EquipmentWeek_Group_Level_ScrollGrid_Level_SetGrid = function(element, elementIndex)
    local row = DataModel.ChooseLeftData[elementIndex]
    element.Btn_Enter:SetClickParam(elementIndex)
    element.Txt_Name:SetText(row.name)
    element.Img_Mask.Spine_Head:SetData(row.resDir)
    element.Img_Mask.Spine_Head.transform.localPosition = Vector3(row.spineX, row.spineY, 0)
    element.Img_Mask.Spine_Head:SetLocalScale(Vector3(row.spineScale, row.spineScale, 1))
    element.Group_Cost.Txt_Num:SetText("-" .. row.cost)
    element.Group_Reward.ScrollGrid_Reward.grid.self:SetParentParam(elementIndex)
    element.Group_Reward.ScrollGrid_Reward.grid.self:SetDataCount(table.count(row.rewardViewList))
    element.Group_Reward.ScrollGrid_Reward.grid.self:RefreshAllElement()
    element.Group_Reward.ScrollGrid_Reward.grid.self:MoveToTop()
    element.Group_Reward.ScrollGrid_Reward.grid.self.ScrollRect.enabled = true
    element.Group_Closed:SetActive(not row.isActivity)
    element.Group_Closed.Txt_Tip:SetText(GetText(row.closedTextId))
  end,
  StageQuest_Group_Battle_Group_Right_Group_EquipmentWeek_Group_Level_ScrollGrid_Level_Group_Item_Group_Reward_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local index = tonumber(element.ParentParam)
    local row = DataModel.ChooseLeftData[index]
    local rewardList = row.rewardViewList
    CommonItem:SetItem(element.Group_Item, {
      id = rewardList[elementIndex].id,
      num = rewardList[elementIndex].num
    }, EnumDefine.ItemType.Item)
    element.Group_Item.Btn_Item:SetClickParam(rewardList[elementIndex].id)
  end,
  StageQuest_Group_Battle_Group_Right_Group_EquipmentWeek_Group_Level_ScrollGrid_Level_Group_Item_Group_Reward_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  StageQuest_Group_Battle_Group_Right_Group_EquipmentWeek_Group_Level_ScrollGrid_Level_Group_Item_Btn_Enter_Click = function(btn, str)
    if DataModel.BattleList[DataModel.BattleLeftIndex].materialLevelTimes - DataModel.BattleCurrentNum <= 0 then
      CommonTips.OpenTips(80610269)
      return
    end
    local row = DataModel.BattleList[DataModel.BattleLeftIndex]
    local data = DataModel.ChooseLeftData[tonumber(str)]
    if data.isActivity == false then
      CommonTips.OpenTips(80610399)
      return
    end
    if CommonTips.GuideAsset() then
      return
    end
    DataModel.BattleRightIndex = tonumber(str)
    UIManager:Open(row.prefabPath, Json.encode({
      id = data.id,
      maxNum = row.materialLevelTimes,
      titleIndex = DataModel.TitleChoose,
      battleLeftIndex = DataModel.BattleLeftIndex
    }))
  end,
  StageQuest_Btn_Order_Click = function(btn, str)
    DataModel.TitleChoose = DataModel.TitleType.Order
    Controller:ClickTopTitle()
  end,
  StageQuest_Group_Order_Group_Right_Img_SingleOrder_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:SetOrderSingleRewardElement(element, elementIndex)
  end,
  StageQuest_Group_Order_Group_Right_Img_SingleOrder_ScrollGrid_Reward_Group_Item_Btn__Click = function(btn, str)
    CommonTips.OpenRewardDetail(tonumber(str))
  end,
  StageQuest_Group_Order_Group_Right_Img_SingleOrder_Group_BeforeGet_Btn_Get_Click = function(btn, str)
    Controller:TryGetMyOrder()
  end,
  StageQuest_Group_Order_Group_Right_Img_SingleOrder_Group_AfterGet_Img_Formula_ScrollGrid_Material_SetGrid = function(element, elementIndex)
    Controller:SetRightOrderMaterialElement(element, elementIndex)
  end,
  StageQuest_Group_Order_Group_Right_Img_SingleOrder_Group_AfterGet_Img_Formula_ScrollGrid_Material_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenItem({
      itemId = tonumber(str)
    })
  end,
  StageQuest_Group_Order_Group_Right_Img_SingleOrder_Group_AfterGet_Img_Formula_Btn_GoTo_Click = function(btn, str)
    Controller:OpenGetWayPanel(-250)
  end,
  StageQuest_Group_Order_Group_Right_Img_SingleOrder_Group_AfterGet_Btn_NotEnough_Click = function(btn, str)
  end,
  StageQuest_Group_Order_Group_Right_Img_SingleOrder_Group_AfterGet_Btn_Enough_Click = function(btn, str)
    Controller:TryDeliverSingleOrder()
  end,
  StageQuest_Group_Order_Group_Right_Img_TeamOrder_Group_BeforeGet_Btn_Get_Click = function(btn, str)
    Controller:TryGetMyOrder()
  end,
  StageQuest_Group_Order_Group_Right_Img_TeamOrder_Group_AfterGet_Img_Formula_ScrollGrid_Material_SetGrid = function(element, elementIndex)
    Controller:SetRightOrderMaterialElement(element, elementIndex)
  end,
  StageQuest_Group_Order_Group_Right_Img_TeamOrder_Group_AfterGet_Img_Formula_ScrollGrid_Material_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenRewardDetail(tonumber(str))
  end,
  StageQuest_Group_Order_Group_Right_Img_TeamOrder_Group_AfterGet_Img_Formula_Btn_GoTo_Click = function(btn, str)
  end,
  StageQuest_Group_Order_Group_Right_Img_TeamOrder_Group_AfterGet_Btn_NotEnough_Click = function(btn, str)
  end,
  StageQuest_Group_Order_Group_Right_Img_TeamOrder_Group_AfterGet_Btn_Enough_Click = function(btn, str)
    Controller:TryDeliverTeamOrder()
  end,
  StageQuest_Group_Order_Group_Left_Group_OrderOption_Group_OptionMine_Btn_Mine_Click = function(btn, str)
    Controller:SelectOrderTab(1)
  end,
  StageQuest_Group_Order_Group_Left_Group_OrderOption_Group_OptionOther_Btn_Other_Click = function(btn, str)
    Controller:SelectOrderTab(2)
  end,
  StageQuest_Group_Order_Group_Left_Btn_News_Click = function(btn, str)
    UIManager:Open("UI/Activity/ActivityMain", Json.encode({id = 86000010}))
  end,
  StageQuest_Group_Order_Group_Left_Btn_GoHall_Click = function(btn, str)
    if DataModel.compoundLv < 20 then
      return
    end
    UIManager:Open("UI/StageQuest/Order/OrderHall")
  end,
  StageQuest_Group_Order_Group_Left_Group_Order_Btn__Click = function(btn, str)
  end,
  StageQuest_Group_Order_Img_Bottom_Group_RefreshOrder_Btn_Tips_Click = function(btn, str)
    if View.Group_Order.Img_Bottom.Group_RefreshOrder.Img_Tips.gameObject.activeSelf then
      View.Group_Order.Img_Bottom.Group_RefreshOrder.Img_Tips:SetActive(false)
    else
      View.Group_Order.Img_Bottom.Group_RefreshOrder.Img_Tips:SetActive(true)
    end
  end,
  StageQuest_Group_Order_Group_Right_Img_SingleOrder_Group_AfterGet_Img_Formula_Btn_GoGet_Click = function(btn, str)
    Controller:GoToProduct()
  end,
  StageQuest_Group_Order_Group_Right_Img_TeamOrder_Group_BeforeGet_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:SetOrderTeamRewardElement(element, elementIndex)
  end,
  StageQuest_Group_Order_Group_Right_Img_TeamOrder_Group_BeforeGet_ScrollGrid_Reward_Group_Item_Btn__Click = function(btn, str)
    CommonTips.OpenRewardDetail(tonumber(str))
  end,
  StageQuest_Group_Order_Group_Right_Img_TeamOrder_Group_AfterGet_Img_Formula_Btn_GoGet_Click = function(btn, str)
    Controller:GoToProduct()
  end,
  StageQuest_Group_Order_Group_Right_Img_TeamOrder_Group_AfterGet_Group_Team_StaticGrid_Team_SetGrid = function(element, elementIndex)
    Controller:SetTeamMemberElement(element, elementIndex)
  end,
  StageQuest_Group_Order_Group_Right_Img_TeamOrder_Group_AfterGet_Group_Team_Btn_GotoTeam_Click = function(btn, str)
    Controller:ShowTeamOrderPanel()
  end,
  StageQuest_Group_Order_Group_Right_Img_TeamOrder_Group_AfterGet_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Controller:SetOrderTeamRewardElement(element, elementIndex)
  end,
  StageQuest_Group_Order_Group_Right_Img_TeamOrder_Group_AfterGet_ScrollGrid_Reward_Group_Item_Btn__Click = function(btn, str)
    CommonTips.OpenRewardDetail(tonumber(str))
  end,
  StageQuest_Group_Order_Group_TeamOrderWindow_Group_Public_Btn_NoPublic_Click = function(btn, str)
    if not DataModel.IsOrderOwner(DataModel.CurrentSelectOrderUId) then
      return
    end
    local orderCfg = DataModel.GetOrderInfo()
    if not orderCfg or next(orderCfg) == nil then
      return
    end
    if orderCfg.endTime and orderCfg.endTime > 0 and orderCfg.endTime < TimeUtil:GetServerTimeStamp() then
      CommonTips.OpenTips(80610824)
      return
    end
    Net:SendProto("future.open", function(json)
      PlayerData.ServerData.user_info.future_base_info.open_orders = json.open_orders
      View.Group_Order.Group_TeamOrderWindow.Group_Public.Btn_Public:SetActive(true)
      View.Group_Order.Group_TeamOrderWindow.Group_Public.Btn_NoPublic:SetActive(false)
    end, DataModel.CurrentSelectOrderUId, 1)
  end,
  StageQuest_Group_Order_Group_TeamOrderWindow_Group_Public_Btn_Public_Click = function(btn, str)
    if not DataModel.IsOrderOwner(DataModel.CurrentSelectOrderUId) then
      return
    end
    local orderCfg = DataModel.GetOrderInfo()
    if not orderCfg or next(orderCfg) == nil then
      return
    end
    if orderCfg.endTime and orderCfg.endTime > 0 and orderCfg.endTime < TimeUtil:GetServerTimeStamp() then
      CommonTips.OpenTips(80610824)
      return
    end
    Net:SendProto("future.open", function(json)
      PlayerData.ServerData.user_info.future_base_info.open_orders = json.open_orders
      View.Group_Order.Group_TeamOrderWindow.Group_Public.Btn_Public:SetActive(false)
      View.Group_Order.Group_TeamOrderWindow.Group_Public.Btn_NoPublic:SetActive(true)
    end, DataModel.CurrentSelectOrderUId, 0)
  end,
  StageQuest_Group_Order_Group_TeamOrderWindow_Btn_GoHall_Click = function(btn, str)
    UIManager:Open("UI/StageQuest/Order/OrderHall")
  end,
  StageQuest_Group_Order_Group_TeamOrderWindow_Group_Team_Img_Empty_Btn__Click = function(btn, str)
  end,
  StageQuest_Group_Order_Group_TeamOrderWindow_StaticGrid_Team_SetGrid = function(element, elementIndex)
    Controller:SetTeamOrderMemberElement(element, elementIndex)
  end,
  StageQuest_Group_Order_Group_TeamOrderWindow_StaticGrid_Team_Group_Team_Img_Empty_Btn__Click = function(btn, str)
    if DataModel.CurrentOrderTab == 2 then
      return
    end
    Controller:ShowTeamInvitePanel()
  end,
  StageQuest_Group_Order_Group_TeamArray_ScrollGrid_Friend_SetGrid = function(element, elementIndex)
    Controller:SetTeamInviteElement(element, elementIndex)
  end,
  StageQuest_Group_Order_Group_TeamArray_ScrollGrid_Friend_Group_Item_Btn__Click = function(btn, str)
    Controller:ChooseOrderFriend(tonumber(str))
  end,
  StageQuest_Group_Order_Group_TeamArray_Btn_GoHall_Click = function(btn, str)
    UIManager:Open("UI/StageQuest/Order/OrderHall")
  end,
  StageQuest_Group_Order_Group_TeamOrderWindow_Img_Mask_Btn__Click = function(btn, str)
    View.Group_Order.Group_TeamOrderWindow:SetActive(false)
  end,
  StageQuest_Group_Order_Group_TeamArray_Btn_Cancle_Click = function(btn, str)
    DataModel.OrderChooseFriendList = {}
    View.Group_Order.Group_TeamArray:SetActive(false)
  end,
  StageQuest_Group_Order_Group_TeamArray_Btn_Confirm_Click = function(btn, str)
    Controller:TryInviteFriend()
  end,
  StageQuest_Group_Order_Group_Right_Img_TeamOrder_Group_AfterGet_Group_GetReward_Btn_GetReward_Click = function(btn, str)
    Controller:TryGetTeamOrderReward()
  end,
  StageQuest_Group_Order_Group_Right_Group_RefreshOrder_GroupDiamond_Btn__Click = function(btn, str)
    DataModel.CurrentOrderResetSelect = 1
    Controller:RefreshResetPanel()
  end,
  StageQuest_Group_Order_Group_Right_Group_RefreshOrder_GroupItem_Btn__Click = function(btn, str)
    DataModel.CurrentOrderResetSelect = 2
    Controller:RefreshResetPanel()
  end,
  StageQuest_Group_Order_Group_Right_Group_RefreshOrder_Btn_Cancel_Click = function(btn, str)
    View.Group_Order.Group_Right.Group_RefreshOrder:SetActive(false)
  end,
  StageQuest_Group_Order_Group_Right_Group_RefreshOrder_Btn_GetNew_Click = function(btn, str)
    Controller:TryRefreshOrder()
  end,
  StageQuest_Group_Order_Group_Right_Img_SingleOrder_StaticGrid_Star_SetGrid = function(element, elementIndex)
    local order = DataModel.GetOrderInfo()
    local orderId = order.id
    local star = PlayerData:GetListFactory(orderId).rarity
    element:SetActive(elementIndex <= star)
  end,
  StageQuest_Group_Order_Group_Right_Img_TeamOrder_StaticGrid_Star_SetGrid = function(element, elementIndex)
    local order = DataModel.GetOrderInfo()
    local orderId = order.id
    local star = PlayerData:GetListFactory(orderId).rarity
    element:SetActive(elementIndex <= star)
  end,
  StageQuest_Group_Order_Group_Left_Group_Order_Group_Single_Img_bg_StaticGrid_Star_SetGrid = function(element, elementIndex)
    Controller:SetOrderStarElement(element, elementIndex)
  end,
  StageQuest_Group_Order_Group_Left_Group_Order_Group_Team_Img_bg_StaticGrid_Star_SetGrid = function(element, elementIndex)
    Controller:SetOrderStarElement(element, elementIndex)
  end,
  StageQuest_Group_Order_Group_Left_Group_Order_Group_Special_Img_bg_StaticGrid_Star_SetGrid = function(element, elementIndex)
    Controller:SetOrderStarElement(element, elementIndex)
  end,
  StageQuest_Group_Order_Group_Left_ScrollGrid_Order_SetGrid = function(element, elementIndex)
    Controller:SetLeftOrderElement(element, elementIndex)
  end,
  StageQuest_Group_Order_Group_Left_ScrollGrid_Order_Group_Order_Group_Single_Img_bg_StaticGrid_Star_SetGrid = function(element, elementIndex)
    Controller:SetOrderStarElement(element, elementIndex)
  end,
  StageQuest_Group_Order_Group_Left_ScrollGrid_Order_Group_Order_Group_Team_Img_bg_StaticGrid_Star_SetGrid = function(element, elementIndex)
    Controller:SetOrderStarElement(element, elementIndex)
  end,
  StageQuest_Group_Order_Group_Left_ScrollGrid_Order_Group_Order_Group_Special_Img_bg_StaticGrid_Star_SetGrid = function(element, elementIndex)
    Controller:SetOrderStarElement(element, elementIndex)
  end,
  StageQuest_Group_Order_Group_Left_ScrollGrid_Order_Group_Order_Btn__Click = function(btn, str)
    Controller:SelectOrder(tonumber(str))
  end,
  StageQuest_Group_Order_Group_Left_Group_OrderOption_Group_OptionSpecial_Btn_Other_Click = function(btn, str)
    Controller:SelectOrderTab(3)
  end,
  StageQuest_Group_Order_Group_Left_Btn_GoActivity_Click = function(btn, str)
    local orderInfo = DataModel.GetOrderInfo()
    if orderInfo and orderInfo.activityId then
      UIManager:Open("UI/Activity/ActivityMain", Json.encode({
        id = tonumber(orderInfo.activityId)
      }))
    else
      local activityList = PlayerData.ServerData.user_info.all_user_future_activity
      if not activityList or table.count(activityList) == 0 then
        return
      end
      local firstActivity = 0
      local orderActivityRead = PlayerData:GetPlayerPrefs("string", "OrderActivityRead")
      if orderActivityRead == "" then
        orderActivityRead = "{}"
      end
      local readList = Json.decode(orderActivityRead)
      readList = readList or {}
      for i, v in pairs(activityList) do
        if firstActivity == 0 then
          firstActivity = i
        end
        if not readList[tostring(i)] then
          readList[tostring(i)] = 1
        end
      end
      PlayerData:SetPlayerPrefs("string", "OrderActivityRead", Json.encode(readList))
      if tonumber(firstActivity) > 0 then
        UIManager:Open("UI/Activity/ActivityMain", Json.encode({
          id = tonumber(firstActivity)
        }))
      end
    end
  end,
  StageQuest_Group_Order_Group_Right_Img_TeamOrder_Group_Reresh_Btn_Refresh_Click = function(btn, str)
    Controller:ShowRefreshPanel()
  end,
  StageQuest_Group_Order_Group_Right_Img_SingleOrder_Group_Reresh_Btn_Refresh_Click = function(btn, str)
    Controller:ShowRefreshPanel()
  end,
  StageQuest_Group_Order_Group_Right_Img_SingleOrder_Group_BeforeGet_Img_Formula_ScrollGrid_Material_SetGrid = function(element, elementIndex)
    Controller:SetRightOrderMaterialElement(element, elementIndex)
  end,
  StageQuest_Group_Order_Group_Right_Img_SingleOrder_Group_BeforeGet_Img_Formula_ScrollGrid_Material_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenRewardDetail(tonumber(str))
  end,
  StageQuest_Group_Order_Group_Right_Img_SingleOrder_Group_BeforeGet_Img_Formula_Btn_GoTo_Click = function(btn, str)
    Controller:OpenGetWayPanel(-250)
  end,
  StageQuest_Group_Order_Group_Right_Img_TeamOrder_Group_BeforeGet_Img_Formula_ScrollGrid_Material_SetGrid = function(element, elementIndex)
    Controller:SetRightOrderMaterialElement(element, elementIndex)
  end,
  StageQuest_Group_Order_Group_Right_Img_TeamOrder_Group_BeforeGet_Img_Formula_ScrollGrid_Material_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenRewardDetail(tonumber(str))
  end,
  StageQuest_Group_Order_Group_Right_Img_TeamOrder_Group_BeforeGet_Img_Formula_Btn_GoTo_Click = function(btn, str)
    Controller:OpenGetWayPanel(-250)
  end,
  StageQuest_Group_Order_Group_TeamOrderWindow_Group_Team_Img_Info_Btn_Kick_Click = function(btn, str)
  end,
  StageQuest_Group_Order_Group_TeamOrderWindow_StaticGrid_Team_Group_Team_Img_Info_Btn_Kick_Click = function(btn, str)
    Controller:TryKickTeamMember(tonumber(str))
  end,
  StageQuest_Group_Order_Group_Right_Img_TeamOrder_Group_AfterGet_Group_LeaveTeam_Btn_GetReturnReward_Click = function(btn, str)
    Controller:TryGetKickOutReward()
  end,
  StageQuest_Group_Order_Group_Right_Group_RefreshOrder_Btn_Diamond_Click = function(btn, str)
    CommonTips.OpenStoreBuy()
  end,
  StageQuest_Group_Order_Group_TeamOrderWindow_Btn_Exit_Click = function(btn, str)
    Controller:TryExitTeam()
  end,
  StageQuest_Group_Stage_Btn_LevelReward_Click = function(btn, str)
    UIManager:Open("UI/Activity/ActivityMain", Json.encode({id = 86000004}))
  end,
  StageQuest_Group_Order_Group_Right_Img_OrderLock_Btn_Goto_Click = function(btn, str)
    UIManager:Open("UI/Home_MachiningMenu/Home_MachiningMenu")
  end,
  StageQuest_Group_Battle_Group_Left_Group_Safe_Btn__Click = function(btn, str)
    if CommonTips.GuideAsset() then
      return
    end
    UIManager:Open("UI/Activity/ActivityMain", Json.encode({id = 86000096}))
  end
}
return ViewFunction
