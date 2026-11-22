local View = require("UIGroup_Income/UIGroup_IncomeView")
local DataModel = require("UIGroup_Income/UIGroup_IncomeDataModel")
local ViewFunction = {
  Group_Income_Group_TapBattle_Group_TicketProfit_Btn_on_Click = function(btn, str)
  end,
  Group_Income_Group_TapBattle_Group_TicketProfit_Btn_off_Click = function(btn, str)
    DataModel.RefreshRevenue()
  end,
  Group_Income_Group_TapBattle_Group_Investment_Btn_on_Click = function(btn, str)
  end,
  Group_Income_Group_TapBattle_Group_Investment_Btn_off_Click = function(btn, str)
    DataModel.RefreshInvest()
  end,
  Group_Income_Group_TapBattle_GroupGold_Btn_Add_Click = function(btn, str)
  end,
  Group_Income_Group_TicketProfit_Group_Reward_Btn__Click = function(btn, str)
    if DataModel.curIncome <= 0 then
      CommonTips.OpenTips(80602090)
      return
    end
    Net:SendProto("playground.park_reward", function(json)
      if json.reward then
        CommonTips.OpenShowItem(json.reward)
      end
      DataModel.playGroundData.earnings = DataModel.playGroundData.earnings + DataModel.curIncome
      DataModel.curIncome = 0
      View.Group_TicketProfit.Group_Reward.Img_ticketprofit.Group_profit.Txt_money:SetText(0)
      View.Group_TapBattle.GroupGold.Txt_Num:SetText(PlayerData:GetUserInfo().gold)
      PlayerData:SetPlayerPrefs("int", "PlayGroundGetReward", TimeUtil:GetServerTimeStamp())
      if UIManager:IsPanelOpened("UI/Playground/Playground") then
        local UIPlaygroundView = require("UIPlayground/UIPlaygroundView")
        UIPlaygroundView.Img_LV.Group_Reward:SetActive(false)
      end
    end, 1, 87300002)
  end,
  Group_Income_Group_Investment_ScrollGrid_List_SetGrid = function(element, elementIndex)
    local pondCfg = PlayerData:GetFactoryData(DataModel.pond[elementIndex], "PondFactory")
    local rewardItemCfg, obj
    element.Img_bottom.Btn_inverstment:SetClickParam(elementIndex)
    local tagCfg = PlayerData:GetFactoryData(pondCfg.type, "TagFactory")
    element.Img_bottom.Img_icon:SetSprite(tagCfg.icon)
    element.Img_bottom.Txt_Title:SetText(tagCfg.investName)
    local itemCfg = PlayerData:GetFactoryData(pondCfg.item[1].id, "ItemFactory")
    element.Img_bottom.Txt_content:SetText(string.format(GetText(80608633), pondCfg.item[1].num, itemCfg.name))
    element.Img_bottom.Img_resources:SetSprite(itemCfg.buyPath)
    element.Img_bottom.Img_resources.Txt_:SetText(pondCfg.item[1].num)
    for i = 1, element.Img_bottom.Group_tx.transform.childCount do
      element.Img_bottom.Group_tx.transform:GetChild(i - 1).gameObject:SetActive(false)
    end
    for i = 1, element.Img_bottom.Group_tx.transform.childCount do
      local child = element.Img_bottom.Group_tx.transform:GetChild(i - 1)
      if child.name == tagCfg.investEffect then
        child.gameObject:SetActive(true)
        break
      end
    end
    local mode = "UI/HomeBattleCenter/Group_Reward"
    local parent = element.Img_bottom.Group_Reward.Group_RewardList.transform
    for rewardIndex, reward in ipairs(pondCfg.build) do
      obj = DataModel.investRewardItemObjList[elementIndex] and DataModel.investRewardItemObjList[elementIndex][rewardIndex]
      if not obj then
        DataModel.investRewardItemObjList[elementIndex] = DataModel.investRewardItemObjList[elementIndex] or {}
        obj = View.self:GetRes(mode, parent)
        table.insert(DataModel.investRewardItemObjList[elementIndex], obj)
      end
      obj.gameObject:SetActive(true)
      rewardItemCfg = PlayerData:GetFactoryData(reward.id, "ItemFactory")
      obj.transform:Find("Img_reward"):GetComponent(typeof(CS.Seven.UIImg)):SetSprite(rewardItemCfg.iconPath)
      obj.transform:Find("Txt_reward"):GetComponent(typeof(CS.Seven.UITxt)):SetText(reward.num .. rewardItemCfg.name)
    end
    local divideStr = tostring(pondCfg.divide * 100)
    element.Img_bottom.Group_Reward.Group_RewardOther.Txt_Divide:SetActive(pondCfg.divide ~= 0)
    element.Img_bottom.Group_Reward.Group_RewardOther.Txt_Divide:SetText(string.format(GetText(80607862), ClearFollowZero(pondCfg.divide * 100) .. "%"))
    element.Img_bottom.Group_Reward.Group_RewardOther.Txt_Rate:SetActive(pondCfg.tax ~= 0)
    element.Img_bottom.Group_Reward.Group_RewardOther.Txt_Rate:SetText(string.format(GetText(80607864), ClearFollowZero(pondCfg.tax * 100) .. "%"))
    element.Img_bottom.Group_Reward.Group_RewardOther.Txt_Ticket:SetActive(pondCfg.ticket ~= 0)
    element.Img_bottom.Group_Reward.Group_RewardOther.Txt_Ticket:SetText(string.format(GetText(80607861), tostring(pondCfg.ticket)))
  end,
  Group_Income_Group_Investment_ScrollGrid_List_Group_pond_Img_bottom_Btn_inverstment_Click = function(btn, str)
    DataModel.Invest(tonumber(str))
  end,
  Group_Income_Group_StageReward_Group_InvestReward_Btn_Close_Click = function(btn, str)
    View.Group_StageReward:SetActive(false)
  end,
  Group_Income_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  Group_Income_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    CommonCoachData.GoHome()
  end,
  Group_Income_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Group_Income_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end
}
return ViewFunction
