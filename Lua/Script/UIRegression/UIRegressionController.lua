local DataModel = require("UIRegression/UIRegressionDataModel")
local View = require("UIRegression/UIRegressionView")
local CommonItem = require("Common/BtnItem")
local ActivityMainController = require("UIActivityMain/UIActivityMainController")
local Controller = {}

function Controller:Init()
  if not DataModel.CheckHasReturn() then
    UIManager:GoHome()
    return
  end
  DataModel.InitData()
  local remainTime = DataModel.GetReturnRemainTime()
  local dayCount = remainTime // 86400
  View.Group_Menu.Img_Time.Txt_Text:SetText(string.format(GetText(80607603), dayCount))
  Controller:RefreshMenuElement()
  Controller:SwitchMenuTab(1, true)
  local plotId = DataModel.Config.joinPlotId
  local watched = PlayerData.plot_paragraph[tostring(plotId)] ~= nil
  if watched then
    Controller:ShowWelcomePanel()
  elseif plotId < 0 then
    Controller:ShowWelcomePanel()
  else
    UIManager:Open(UIPath.UIDialog, Json.encode({id = plotId}), function()
      Controller:ShowWelcomePanel()
    end)
  end
end

function Controller:SetMenuElement(element, elementIndex)
  local row = DataModel.MenuElementData[elementIndex]
  if row then
    element.Btn_UnSelect.Txt_:SetText(row.name)
    element.Img_Select.Txt_:SetText(row.name)
    element.Img_Select:SetActive(elementIndex == DataModel.CurMenuTab)
    element.Btn_UnSelect:SetActive(elementIndex ~= DataModel.CurMenuTab)
    View[row.panel]:SetActive(elementIndex == DataModel.CurMenuTab)
    element.Btn_UnSelect:SetClickParam(elementIndex)
  end
end

function Controller:RefreshMenuElement()
  View.Group_Menu.StaticGrid_Menu.grid.self:SetDataCount(4)
  View.Group_Menu.StaticGrid_Menu.grid.self:RefreshAllElement()
end

function Controller:SwitchMenuTab(idx, isInit)
  if DataModel.CurMenuTab == idx and not isInit then
    return
  end
  DataModel.CurMenuTab = idx
  Controller:RefreshMenuElement()
  local row = DataModel.MenuElementData[idx]
  if row then
    Controller[row.clickFunc]()
  end
end

function Controller:SetSignLastDayElement(element, elementIndex)
  local row = DataModel.SignInElementData[7].reward[elementIndex]
  if row then
    CommonItem:SetItem(element, {
      id = row.id,
      num = row.num
    })
    element.Btn_Item:SetClickParam(row.id)
    element.Img_SignedMask:SetActive(DataModel.SignInElementData[7].signState == DataModel.SignState.Signed)
  end
end

function Controller:SetSignInElement(element, elementIndex)
  local row = DataModel.SignInElementData[elementIndex]
  if row then
    element.Img_SignBG.Txt_Day:SetText(string.format("%02d", elementIndex))
    element.Img_SignedBG.Txt_Day:SetText(string.format("%02d", elementIndex))
    element.Img_SignedBG:SetActive(row.signState == DataModel.SignState.Signed)
    element.Img_SignBG:SetActive(row.signState == DataModel.SignState.NotInTime or row.signState == DataModel.SignState.CanSign)
    element.Group_SignRWItem.Img_ItemMask:SetActive(row.signState == DataModel.SignState.Signed)
    if row.signState == DataModel.SignState.Signed then
      element.Img_SignedBG.Txt_Day:SetText(string.format("%02d", elementIndex))
    elseif row.signState == DataModel.SignState.CanSign then
      element.Img_SignBG.Img_NotTime:SetActive(false)
      element.Img_SignBG.Btn_Sign.Txt_:SetText(GetText(80606905))
    else
      element.Img_SignBG.Img_NotTime:SetActive(true)
      element.Img_SignBG.Btn_Sign.Txt_:SetText(GetText(80606906))
    end
    local reward = row.reward
    CommonItem:SetItem(element.Group_SignRWItem, {
      id = reward[1].id,
      num = reward[1].num
    })
    element.Group_SignRWItem.Btn_Item:SetClickParam(reward[1].id)
    element.Img_SignBG.Btn_Sign:SetClickParam(elementIndex)
    LayoutRebuilder.ForceRebuildLayoutImmediate(element.Img_SignBG.Btn_Sign.Rect)
    LayoutRebuilder.ForceRebuildLayoutImmediate(element.Img_SignedBG.Btn_Sign.Rect)
  end
end

function Controller:RefreshSignInElement()
  View.Group_SignIn.StaticGrid_Sign.grid.self:SetDataCount(6)
  View.Group_SignIn.StaticGrid_Sign.grid.self:RefreshAllElement()
  local signData = PlayerData.ServerData.user_info.sign_info["40100010"]
  View.Group_SignIn.Group_Sign.Img_Mask:SetActive(signData.count + signData.need < 7)
  local lastDayRow = DataModel.SignInElementData[7].reward
  LayoutRebuilder.ForceRebuildLayoutImmediate(View.Group_SignIn.Group_Sign.Img_Mask.Rect)
  View.Group_SignIn.Group_Sign.Btn_SignIn:SetActive(signData and signData.count < 7 and signData.need > 0 and signData.status == 0)
  View.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForSeconds(0.01))
    View.Group_SignIn.Group_Sign.Img_ItemBG.ScrollGrid_Item.grid.self:SetDataCount(table.count(lastDayRow))
    View.Group_SignIn.Group_Sign.Img_ItemBG.ScrollGrid_Item.grid.self:RefreshAllElement()
  end))
end

function Controller:SetTaskRewardElement(element, elementIndex)
  local row = DataModel.TaskRewardElementData[elementIndex]
  if row then
    CommonItem:SetItem(element, {
      id = row.id,
      num = row.num
    })
    element.Btn_Item:SetClickParam(row.id)
    local taskData = DataModel.TaskElementData[DataModel.TaskElementTempIndex]
    element.Img_SignedMask:SetActive(taskData.status == DataModel.TaskState.Rewarded)
  end
end

function Controller:SetBottomTaskRewardElement(element, elementIndex)
  local row = DataModel.TaskProcessElementData[elementIndex]
  if row then
    element.Txt_Num:SetText(row.num)
    local returnScore = PlayerData:GetGoodsById(11400213).num
    element.Img_GiftLocked:SetActive(returnScore < row.num)
    element.Img_Gift:SetActive(returnScore >= row.num and row.recv == true)
    element.Img_RewardBG:SetActive(false)
    element.Group_Get:SetActive(returnScore >= row.num and row.recv == false)
    element.Btn_Check:SetClickParam(elementIndex)
    element.Group_Get.Btn_Get:SetClickParam(elementIndex)
  end
end

function Controller:ShowTaskBottomRewardDetailElement(elementIndex)
  if DataModel.TaskRewardDetailPanel then
    DataModel.TaskRewardDetailPanel:SetActive(false)
    DataModel.TaskRewardDetailPanel = nil
  end
  local element = View.Group_Task.Img_Bottom.Img_ProgressBar.StaticGrid_TaskReward.grid[elementIndex]
  if element then
    element.Img_RewardBG:SetActive(true)
    View.Group_Task.Btn_Close:SetActive(true)
    local rewardCfg = PlayerData:GetFactoryData(DataModel.Config.returnTaskRewards[elementIndex].rewards)
    if rewardCfg then
      local awardList = rewardCfg.awardList
      DataModel.BottomRewardDetailCfg = awardList
      element.Img_RewardBG.Img_ItemBG.ScrollGrid_Item.grid.self:SetDataCount(table.count(awardList))
      element.Img_RewardBG.Img_ItemBG.ScrollGrid_Item.grid.self:RefreshAllElement()
    end
    DataModel.TaskRewardDetailPanel = element.Img_RewardBG
  end
end

function Controller:SetTaskElement(element, elementIndex)
  local row = DataModel.TaskElementData[elementIndex]
  if row then
    local cfg = PlayerData:GetFactoryData(row.id)
    element.Group_ReWardItem.Group_TaskInfo.Txt_Task:SetText(cfg.describe)
    element.Group_ReWardItem.Group_TaskInfo.Txt_Progress:SetText(row.curNum .. "/" .. cfg.num)
    element.Img_UnFinish:SetActive(row.status == DataModel.TaskState.Going)
    element.Img_Finish:SetActive(row.status == DataModel.TaskState.CanReward or row.status == DataModel.TaskState.Rewarded)
    element.Img_Finish.Btn_Finish:SetActive(row.status == DataModel.TaskState.CanReward)
    element.Img_Finish.Btn_Finished:SetActive(row.status == DataModel.TaskState.Rewarded)
    DataModel.TaskRewardElementData = Clone(cfg.rewardsList)
    DataModel.TaskElementTempIndex = elementIndex
    local stampReward = DataModel.TaskRewardElementData[1]
    table.remove(DataModel.TaskRewardElementData, 1)
    element.Group_ReWardItem.StaticGrid_Item.grid.self:SetDataCount(table.count(DataModel.TaskRewardElementData))
    element.Group_ReWardItem.StaticGrid_Item.grid.self:RefreshAllElement()
    if stampReward then
      element.Group_ReWardItem.Group_TaskInfo.Img_Stamp.Txt_Num:SetText("X" .. stampReward.num)
    end
    element.Img_Finish.Btn_Finish:SetClickParam(elementIndex)
  end
end

function Controller:RefreshTaskElement()
  View.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForSeconds(0.01))
    View.Group_Task.NewScrollGrid_Task.grid.self:SetDataCount(table.count(DataModel.TaskElementData))
    View.Group_Task.NewScrollGrid_Task.grid.self:RefreshAllElement()
  end))
  View.Group_Task.Img_Bottom.Img_ProgressBar.StaticGrid_TaskReward.grid.self:SetDataCount(table.count(DataModel.Config.returnTaskRewards))
  View.Group_Task.Img_Bottom.Img_ProgressBar.StaticGrid_TaskReward.grid.self:RefreshAllElement()
  local returnScore = PlayerData:GetGoodsById(11400213).num
  View.Group_Task.Img_Bottom.Txt_Num:SetText(returnScore)
  local lastRewardStampNeed = DataModel.Config.returnTaskRewards[5].num
  View.Group_Task.Img_Bottom.Img_ProgressBar.Img_Progress:SetFilledImgAmount(returnScore / lastRewardStampNeed)
  View.Group_Task.Img_Bottom.Img_Decoration:SetActive(returnScore < 100)
end

function Controller:SetBuffElement(element, elementIndex)
  local row = DataModel.BuffElementData[elementIndex]
  if row then
    local cfg = PlayerData:GetFactoryData(row.id)
    element.Group_BuffDescribe.Txt_Nmae:SetText(cfg.name)
    element.Group_BuffDescribe.Txt_Describe:SetText(cfg.desc)
    element.Img_Mp3.Btn_Activate:SetClickParam(elementIndex)
    element.Img_Mp3.Img_ScreenOn:SetActive(row.state == DataModel.BuffState.Active)
    element.Img_Mp3.Img_ScreenOff:SetActive(row.state == DataModel.BuffState.Empty)
    element.Group_BuffDescribe.Img_NumBottome.Txt_Num:SetText(row.remainCount .. "/" .. cfg.param)
    element.Group_BuffDescribe.Img_NumBottome.Img_Battery.Img_Electricity:SetFilledImgAmount(row.remainCount / cfg.param)
    element.Group_BuffDescribe.SpineNode_Buff:SetActive(false)
    local actionName = DataModel.BuffSpineName[cfg.buffType] .. (row.state ~= DataModel.BuffState.Empty and "01" or "02")
    if row.state == DataModel.BuffState.NoActive then
      element.Group_BuffDescribe.SpineNode_Buff:SetActive(true)
      element.Group_BuffDescribe.SpineNode_Buff:SetAction(actionName, true, true)
      element.Group_BuffDescribe.SpineNode_Buff.enabled = false
    else
      element.Group_BuffDescribe.SpineNode_Buff.enabled = true
      element.Group_BuffDescribe.SpineNode_Buff:SetActive(true)
      element.Group_BuffDescribe.SpineNode_Buff:SetAction(actionName, true, true)
    end
    if row.state == DataModel.BuffState.Active then
      local remainTime = TimeUtil:GetFutureTime(1, 5) - TimeUtil:GetServerTimeStamp()
      local timeTable = TimeUtil:SecondToTable(remainTime)
      element.Img_Mp3.Img_ScreenOn.Img_On.Txt_Time:SetText(string.format(GetText(80607783), timeTable.hour))
    end
    element.Img_Mp3.Btn_Activate:SetClickParam(elementIndex)
  end
end

function Controller:RefreshBuffElement()
  View.Group_Buff.StaticGrid_Buff.grid.self:SetDataCount(table.count(DataModel.BuffElementData))
  View.Group_Buff.StaticGrid_Buff.grid.self:RefreshAllElement()
end

function Controller:RefreshNewsElement()
  local row = DataModel.NewsElementData[DataModel.CurNewsIdx]
  if row then
    View.Group_News.Img_NewsBG:SetSprite(row.data.newsBG)
    View.Group_News.Img_NewsBG.Img_Icon:SetSprite(row.data.newsIcon)
    View.Group_News.Img_NewsBG.Img_Title:SetSprite(row.data.newsTitle)
    View.Group_News.Group_Change.Btn_Left:SetActive(#DataModel.NewsElementData > 1)
    View.Group_News.Group_Change.Btn_Right:SetActive(#DataModel.NewsElementData > 1)
    View.Group_News.Group_Change.StaticGrid_Point.grid.self:SetDataCount(#DataModel.NewsElementData)
    View.Group_News.Group_Change.StaticGrid_Point.grid.self:RefreshAllElement()
  end
end

function Controller:SetWelcomeRewardElement(element, elementIndex)
  local row = DataModel.Config.returnRewards[elementIndex]
  if row then
    CommonItem:SetItem(element, {
      id = row.id,
      num = row.num
    })
    element.Btn_Item:SetClickParam(row.id)
  end
end

function Controller:ShowWelcomePanel()
  local isGet = PlayerData.ServerData.return_info.ret_reward
  if isGet then
    View.self:PlayAnimOnce("In")
    View.Group_Welcome:SetActive(false)
    return
  end
  View.self:PlayAnimOnce("Welcome_In")
  View.Group_Welcome:SetActive(true)
  View.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForSeconds(0.01))
    View.Group_Welcome.Img_BG.Img_Item.ScrollGrid_Item.grid.self:SetDataCount(table.count(DataModel.Config.returnRewards))
    View.Group_Welcome.Img_BG.Img_Item.ScrollGrid_Item.grid.self:RefreshAllElement()
  end))
end

function Controller:ClickSignIn()
  View.self:PlayAnimOnce("SignIn_In")
  Controller:RefreshSignInElement()
end

function Controller:ClickTask()
  View.self:PlayAnimOnce("Task_In")
  View.Group_Task.Btn_Close:SetActive(false)
  Controller:RefreshTaskElement()
end

function Controller:ClickBuff()
  View.self:PlayAnimOnce("Buff_In")
  Controller:RefreshBuffElement()
end

function Controller:ClickNews()
  View.self:PlayAnimOnce("News_In")
  Controller:RefreshNewsElement()
end

function Controller:ClickLeftNews()
  if table.count(DataModel.NewsElementData) == 1 then
    return
  end
  if DataModel.CurNewsIdx == 1 then
    DataModel.CurNewsIdx = table.count(DataModel.NewsElementData)
  else
    DataModel.CurNewsIdx = DataModel.CurNewsIdx - 1
  end
  View.self:PlayAnimOnce("Change")
  Controller:RefreshNewsElement()
end

function Controller:ClickRightNews()
  if table.count(DataModel.NewsElementData) == 1 then
    return
  end
  if DataModel.CurNewsIdx == table.count(DataModel.NewsElementData) then
    DataModel.CurNewsIdx = 1
  else
    DataModel.CurNewsIdx = DataModel.CurNewsIdx + 1
  end
  View.self:PlayAnimOnce("Change")
  Controller:RefreshNewsElement()
end

function Controller:TrySignIn(idx)
  local row = DataModel.SignInElementData[idx]
  if row then
    local serverSignData = PlayerData.ServerData.user_info.sign_info["40100010"]
    if serverSignData and (serverSignData.status == 1 or serverSignData.need == 0) then
      if idx <= serverSignData.count then
        CommonTips.OpenTips(80606907)
      else
        CommonTips.OpenTips(80606906)
      end
      return
    end
    Net:SendProto("main.sign_in", function(json)
      if json.reward then
        CommonTips.OpenShowItem(json.reward)
      end
      if json.sign_info then
        PlayerData.ServerData.user_info.sign_info["40100010"] = json.sign_info["40100010"]
      end
      DataModel.InitSignInData()
      Controller:RefreshSignInElement()
      ActivityMainController:RefreshLeftRedState()
    end, tostring(DataModel.Config.returnSignIn))
  end
end

function Controller:TryActivateBuff(idx)
  local row = DataModel.BuffElementData[idx]
  if row then
    Net:SendProto("activity.activate_buff", function(json)
      for bT, data in pairs(PlayerData.ServerData.return_info.ret_buff) do
        for k, v in pairs(data) do
          if tonumber(k) == tonumber(row.id) then
            PlayerData.ServerData.return_info.ret_buff[bT][k].act = 1
          end
        end
      end
      DataModel.InitBuffData()
      Controller:RefreshBuffElement()
      ActivityMainController:RefreshLeftRedState()
    end, tostring(DataModel.ConfigId), tostring(row.id))
  end
end

function Controller:TryGetTaskProcessReward(idx)
  Net:SendProto("activity.process_return", function(json)
    if json.reward then
      CommonTips.OpenShowItem(json.reward)
    end
    PlayerData.ServerData.return_info.tasks_reward[idx] = 0
    DataModel.InitTaskProcessData()
    View.Group_Task.Img_Bottom.Img_ProgressBar.StaticGrid_TaskReward.grid.self:SetDataCount(table.count(DataModel.Config.returnTaskRewards))
    View.Group_Task.Img_Bottom.Img_ProgressBar.StaticGrid_TaskReward.grid.self:RefreshAllElement()
    ActivityMainController:RefreshLeftRedState()
  end, tostring(DataModel.ConfigId), tostring(idx - 1))
end

function Controller:TryGetWelcomeReward()
  local isGet = PlayerData.ServerData.return_info and PlayerData.ServerData.return_info.ret_reward
  if isGet then
    return
  end
  Net:SendProto("activity.rec_return", function(json)
    if json.reward then
      CommonTips.OpenShowItem(json.reward)
    end
    PlayerData.ServerData.return_info.ret_reward = true
    View.Group_Welcome:SetActive(false)
    Controller:ShowWelcomePanel()
  end, tostring(DataModel.ConfigId))
end

return Controller
