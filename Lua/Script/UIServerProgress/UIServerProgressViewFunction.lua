local View = require("UIServerProgress/UIServerProgressView")
local DataModel = require("UIServerProgress/UIServerProgressDataModel")
local Controller = require("UIActivityMain/BlackTeaActivityController")
local CommonItem = require("Common/BtnItem")
local ViewFunction = {
  ServerProgress_Group_TopLeft_Btn_Personal_Click = function(btn, str)
    View.self:CloseUI()
    UIManager:Open("UI/Activity/BlackTea/PersonalProgress")
  end,
  ServerProgress_Group_Right_ScrollGrid_ProgressList_SetGrid = function(element, elementIndex)
    local info = DataModel.allStage[elementIndex]
    local questCfg = PlayerData:GetFactoryData(info.id, "QuestFactory")
    element.Img_BG.Group_Goal.Txt_Num:SetText(NumThousandsSplit(questCfg.num))
    local state = PlayerData.GetQuestState(info.id)
    local limitQuestState = PlayerData.GetQuestState(info.limit)
    local unAble = state == EnumDefine.EQuestState.Lock or state == EnumDefine.EQuestState.UnFinish or limitQuestState == EnumDefine.EQuestState.Lock or limitQuestState == EnumDefine.EQuestState.UnFinish
    local received = state == EnumDefine.EQuestState.Receive
    local canReceive = state == EnumDefine.EQuestState.Finish and (limitQuestState == EnumDefine.EQuestState.Finish or limitQuestState == EnumDefine.EQuestState.Receive)
    element.Img_BG.Btn_Award.Img_Unable:SetActive(unAble)
    element.Img_BG.Btn_Award.Img_Finished:SetActive(received)
    element.Img_BG.Btn_Award.Img_Able:SetActive(canReceive)
    element.Img_BG.Group_HomeSkill:SetActive(info.buff > 0)
    if info.buff > 0 then
      local buffCfg = PlayerData:GetFactoryData(info.buff, "HomeBuffFactory")
      element.Img_BG.Group_HomeSkill.Txt_Des:SetText(buffCfg.desc)
      local txt = string.format(GetText(80602520), DataModel.stageIndexMap[info.id])
      element.Img_BG.Group_HomeSkill.Txt_01:SetText(txt)
    end
    element.Img_BG.Group_Stage.Txt_Num:SetText(DataModel.stageIndexMap[info.id])
    element.Img_BG.Txt_Tips:SetText(string.format(GetText(80609063), PlayerData:GetFactoryData(info.limit, "QuestFactory").name))
    element.Img_BG.Btn_Award:SetClickParam(elementIndex)
    element.Img_BG.StaticGrid_RewardList.grid.self:SetParentParam(elementIndex)
    element.Img_BG.StaticGrid_RewardList.grid.self:SetDataCount(#questCfg.rewardsList)
    element.Img_BG.StaticGrid_RewardList.grid.self:RefreshAllElement()
  end,
  ServerProgress_Group_Right_ScrollGrid_ProgressList_Group_Item_Img_BG_Btn_Award_Click = function(btn, str)
    local info = DataModel.allStage[tonumber(str)]
    Controller.ClickReceiveSeverReward(info.id, info.limit)
  end,
  ServerProgress_Group_Right_ScrollGrid_ProgressList_Group_Item_Img_BG_StaticGrid_RewardList_SetGrid = function(element, elementIndex)
    local info = DataModel.allStage[tonumber(element.ParentParam)]
    local questCfg = PlayerData:GetFactoryData(info.id, "QuestFactory")
    local rewardInfo = questCfg.rewardsList[elementIndex]
    if rewardInfo then
      CommonItem:SetItem(element, rewardInfo)
      element.Btn_Item:SetClickParam(rewardInfo.id)
    end
  end,
  ServerProgress_Group_Right_ScrollGrid_ProgressList_Group_Item_Img_BG_StaticGrid_RewardList_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenRewardDetail(itemId)
  end,
  ServerProgress_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  ServerProgress_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  ServerProgress_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  ServerProgress_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  ServerProgress_Group_Left_Img_Door_Btn_Buff_Click = function(btn, str)
    UIManager:Open("UI/Activity/BlackTea/BuffTips")
  end
}
return ViewFunction
