local View = require("UIEntrust/UIEntrustView")
local DataModel = require("UIEntrust/UIEntrustDataModel")
local BtnItem = require("Common/BtnItem")
local Timer = require("Common/Timer")
local Controller = {}
local FastBattleDataModel = require("UIFastBattle/UIFastBattleDataModel")

function Controller:Init()
  if PlayerData.ServerData.entrust_sp and PlayerData.ServerData.entrust_sp > 0 then
    local targetTime = TimeUtil:GetNextSpecialTimeStamp(5)
    local curTime = TimeUtil:GetServerTimeStamp()
    local lastResetTime = PlayerData:GetPlayerPrefs("int", "EntrustReset")
    if lastResetTime == nil or lastResetTime <= 0 then
      lastResetTime = targetTime
      PlayerData:SetPlayerPrefs("int", "EntrustReset", targetTime)
    end
    if curTime > lastResetTime then
      PlayerData.ServerData.entrust_sp = 0
      PlayerData:SetPlayerPrefs("int", "EntrustReset", targetTime)
    end
  end
  DataModel.Init()
  DataModel.recommendLayout = View.Group_Left.Group_Queue.Group_Recommend.self:GetComponent(typeof(UI.HorizontalLayoutGroup))
  DataModel.InitRoleInfo()
  Controller:RefreshEntrustNum()
  Controller:RefreshEntrustList()
  Controller:ClickEntrustElement(1, true)
  Controller:RefreshEntrustFinishTime()
  Controller:RefreshOneKeyGetBtnShow()
  if DataModel.timer then
    DataModel.timer:Stop()
    DataModel.timer = nil
  end
  DataModel.timer = Timer.New(1, function()
    Controller:Update()
  end)
  DataModel.timer:Start()
  Controller:RefreshTopRewardUpIcon()
  Controller:RefreshScheduleShow()
end

function Controller:RefreshTopRewardUpIcon()
  View.Img_Icon:SetSprite(GetResPath(88300082))
  View.Img_IconNew:SetSprite(GetResPath(88300082))
end

function Controller:RefreshEntrustList()
  DataModel.showEntrustIdx = {}
  DataModel.toSaveEntrustUpdateIdx = true
  View.ScrollGrid_List.grid.self:SetDataCount(#DataModel.entrustList)
  View.ScrollGrid_List.grid.self:RefreshAllElement()
  DataModel.toSaveEntrustUpdateIdx = false
end

function Controller:RefreshOneKeyGetBtnShow()
  View.Btn_OneGet:SetActive(false)
  do return end
  local isShowBtn = false
  for i, v in ipairs(DataModel.entrustList) do
    if v.state == DataModel.entrustState.Complete then
      isShowBtn = true
      break
    end
  end
  View.Btn_OneGet:SetActive(isShowBtn)
end

function Controller:Update()
  Controller:UpdateEntrustedListAndBottom()
end

function Controller:UpdateEntrustedListAndBottom()
  local curTime = TimeUtil:GetServerTimeStamp()
  local isComplete = false
  local curSelectEntrustId = 0
  for i, idx in ipairs(DataModel.showEntrustIdx) do
    local info = DataModel.entrustList[idx]
    if info.state == DataModel.entrustState.Ing then
      if curTime >= info.endTime then
        info.state = DataModel.entrustState.Complete
        isComplete = true
        curSelectEntrustId = DataModel.entrustList[DataModel.curEntrustSelectIdx].id
        if DataModel.curEntrustSelectIdx == i then
          Controller:RefreshBottomTimeShow(DataModel.curEntrustSelectIdx)
          Controller:RefreshBottomBtnShow(DataModel.curEntrustSelectIdx)
          View.Group_Left.Group_On.Group_State.Group_On.self:SetActive(false)
          View.Group_Left.Group_On.Group_State.Group_Complete.self:SetActive(true)
        end
      end
      local element = View.ScrollGrid_List.grid.self:GetElementByIndex(idx - 1)
      if not isComplete and element then
        Controller:RefreshEntrustElement(element, idx)
      end
    end
  end
  if isComplete then
    DataModel.SortEntrustList()
    DataModel.RefreshCurSelectEntrustIdx(curSelectEntrustId)
    Controller:RefreshEntrustList()
    Controller:RefreshOneKeyGetBtnShow()
  end
  if 0 < DataModel.curEntrustSelectIdx and DataModel.curEntrustSelectIdx < #DataModel.entrustList then
    local info = DataModel.entrustList[DataModel.curEntrustSelectIdx]
    if info.state == DataModel.entrustState.Ing then
      if curTime >= info.endTime then
        info.state = DataModel.entrustState.Complete
        View.Group_Left.Group_On.Group_State.Group_On.self:SetActive(false)
        View.Group_Left.Group_On.Group_State.Group_Complete.self:SetActive(true)
      end
      Controller:RefreshBottomTimeShow(DataModel.curEntrustSelectIdx)
      Controller:RefreshBottomBtnShow(DataModel.curEntrustSelectIdx)
    end
  end
end

function Controller:UpdateRoleMove()
  if DataModel.curEntrustSelectIdx <= 0 or DataModel.curEntrustSelectIdx > #DataModel.entrustList then
    return
  end
  local info = DataModel.entrustList[DataModel.curEntrustSelectIdx]
  if info == nil or info.state == DataModel.entrustState.CanAccept then
    return
  end
  local rolesInfo = DataModel.cacheUpdateRoleMoveInfo[info.id]
  if rolesInfo then
    local yCompare = {}
    for i, roleInfo in ipairs(rolesInfo) do
      local roleElement = DataModel.cacheMoveRoleElement[i]
      if roleElement then
        if roleInfo.changeAction then
          roleInfo.changeAction = false
          roleElement:SetAction(roleInfo.action, true, true)
        end
        if roleInfo.changeFaceAngle then
          roleInfo.changeFaceAngle = false
          roleElement:SetLocalEulerAngles(Vector3(0, roleInfo.faceAngle, 0))
        end
        if roleInfo.move == 1 then
          roleElement:SetAnchoredPosition(Vector2(roleInfo.pos.x, roleInfo.pos.y))
        end
        if #yCompare == 0 then
          table.insert(yCompare, roleInfo.pos.y)
          roleElement.CachedTransform:SetSiblingIndex(0)
        else
          local setIdx = 0
          for i1, y in ipairs(yCompare) do
            if y < roleInfo.pos.y then
              setIdx = i1 - 1
              table.insert(yCompare, i1, roleInfo.pos.y)
              break
            else
              local next = yCompare[i1 + 1]
              if next == nil or next < roleInfo.pos.y then
                setIdx = i1
                table.insert(yCompare, i1 + 1, roleInfo.pos.y)
                break
              end
            end
          end
          roleElement.CachedTransform:SetSiblingIndex(setIdx)
        end
        DataModel.UpdateMove(roleInfo)
      end
    end
  end
end

function Controller:RefreshBottomShow(idx)
  Controller:RefreshBottomRewardShow()
  Controller:RefreshBottomRewardUpShow()
  Controller:RefreshBottomTimeShow(idx)
  Controller:RefreshBottomBtnShow(idx)
  Controller:RefreshBottomRolesShow(idx)
end

function Controller:RefreshBottomRewardShow(showEffect)
  DataModel.CalcRolesInfo(DataModel.curEntrustSelectIdx)
  View.Group_Right.Group_Reward.StaticGrid_List.grid.self:RefreshAllElement()
  if showEffect and DataModel.GetRolesCount(DataModel.curEntrustSelectIdx) >= DataModel.limitCharacter then
    View.Group_Effect.self:SetActive(false)
    View.Group_Effect.self:SetActive(true)
  else
    View.Group_Effect.self:SetActive(false)
  end
end

function Controller:RefreshBottomRewardUpShow()
  View.Group_Right.Group_Reward.Img_Icon:SetActive(DataModel.isRewardUp)
  if DataModel.isRewardUp then
    View.Group_Right.Group_Reward.Img_Icon:SetSprite(GetResPath(88300083))
  end
end

function Controller:RefreshBottomRolesShow(idx)
  local info = DataModel.entrustList[idx]
  View.Group_Left.Group_Queue.Img_Icon:SetSprite(info.notPath)
  View.Group_Left.Group_Queue.Txt_Name:SetText(info.name)
  View.Group_Left.Group_Queue.Txt_Dec:SetText(info.describe)
  View.Group_Left.Group_Queue.Group_Recommend.ScrollGrid_List.grid.self:SetDataCount(#info.recommendSideList)
  View.Group_Left.Group_Queue.Group_Recommend.ScrollGrid_List.grid.self:RefreshAllElement()
  DataModel.updateLayout = true
  View.Group_Left.Group_Queue.self:SetActive(info.state == DataModel.entrustState.CanAccept)
  View.Group_Left.Group_On.self:SetActive(info.state ~= DataModel.entrustState.CanAccept)
  if info.state == DataModel.entrustState.CanAccept then
    View.Group_Left.Group_Queue.StaticGrid_RoleList.grid.self:RefreshAllElement()
  else
    View.Group_Left.Group_On.Img_Bg:SetSprite(info.scenePath)
    DataModel.cacheMoveRoleElement = {}
    for i, roleId in ipairs(info.roles) do
      local roleElement = View.Group_Left.Group_On.Img_Bg["Spine_Role" .. i]
      if roleElement then
        DataModel.cacheMoveRoleElement[i] = roleElement
        local serverRoles = PlayerData.ServerData.roles[tostring(roleId)]
        if serverRoles then
          local skinId = serverRoles.current_skin and serverRoles.current_skin[1] or ""
          if string.nilorempty(skinId) then
            local unitCA = PlayerData:GetFactoryData(roleId)
            skinId = unitCA.viewId
          end
          local unitViewCA = PlayerData:GetFactoryData(skinId)
          roleElement:SetData(unitViewCA.HomeresDir)
          roleElement:SetActive(true)
        else
          roleElement:SetActive(false)
        end
      end
    end
    DataModel.InitRoleMoveInfo(idx)
    View.Group_Left.Group_On.Group_State.Group_On.self:SetActive(info.state == DataModel.entrustState.Ing)
    View.Group_Left.Group_On.Group_State.Group_Complete.self:SetActive(info.state == DataModel.entrustState.Complete)
  end
end

function Controller:RefreshBottomBtnShow(idx)
  local state, reason = DataModel.GetEntrustState(idx)
  View.Group_Right.Group_Btn.Group_Back.self:SetActive(false)
  View.Group_Right.Group_Btn.Group_GetNow.self:SetActive(state == DataModel.entrustState.Ing)
  View.Group_Right.Group_Btn.Group_Entrust.self:SetActive(state == DataModel.entrustState.CanAccept)
  View.Group_Right.Group_Btn.Group_Get.self:SetActive(state == DataModel.entrustState.Complete)
  View.Group_Right.Group_Btn.Group_Not.self:SetActive(state == DataModel.entrustState.Lock)
end

function Controller:RefreshBottomTimeShow(idx)
  local info = DataModel.entrustList[idx]
  View.Group_Right.Group_Time.Group_Select.self:SetActive(info.state == DataModel.entrustState.CanAccept)
  View.Group_Right.Group_Time.Group_On.self:SetActive(info.state ~= DataModel.entrustState.CanAccept)
  local count = #DataModel.timeList
  if info.state ~= DataModel.entrustState.CanAccept then
    View.Group_Right.Group_Time.Group_On.Group_Residue:SetActive(info.state == DataModel.entrustState.Ing)
    View.Group_Right.Group_Time.Group_On.Group_Complete:SetActive(info.state == DataModel.entrustState.Complete)
    View.Group_Right.Group_Time.Group_On.Group_Time.Txt_Time:SetText(string.format(GetText(80608595), math.modf(info.totalTime / 3600)))
    if info.state == DataModel.entrustState.Ing then
      local curTime = TimeUtil:GetServerTimeStamp()
      local remainTime = TimeUtil:SecondToTable(info.endTime - curTime)
      View.Group_Right.Group_Time.Group_On.Group_Residue.Txt_Num:SetText(string.format(GetText(80608594), remainTime.hour, remainTime.minute, remainTime.second))
      View.Group_Right.Group_Time.Group_On.Group_Residue.Img_Schedule:SetFilledImgAmount((curTime - info.startTime) / info.totalTime)
    elseif info.state == DataModel.entrustState.Complete then
    end
  else
    for i = 1, count do
      local element = View.Group_Right.Group_Time.Group_Select["Group_Time" .. i]
      local timeInfo = DataModel.timeList[i]
      if element and timeInfo then
        local isSelect = info.cacheTimeSelectIdx == i
        element.Group_Off.self:SetActive(not isSelect)
        element.Group_On.self:SetActive(isSelect)
        element.Group_Off.Txt_Time:SetText(timeInfo.time)
        element.Group_On.Txt_Time:SetText(timeInfo.time)
        element.Btn_:SetClickParam(i)
      end
    end
  end
end

function Controller:ClickTimeBtn(str)
  local idx = tonumber(str)
  local info = DataModel.entrustList[DataModel.curEntrustSelectIdx]
  info.cacheTimeSelectIdx = idx
  PlayerData:SetPlayerPrefs("int", "EntrustTimeSelected" .. info.id, idx)
  Controller:RefreshBottomTimeShow(DataModel.curEntrustSelectIdx)
  if #info.roles >= DataModel.limitCharacter then
    View.Group_Right.Group_Reward.StaticGrid_List.grid.self:RefreshAllElement()
  end
end

function Controller:CompleteImmediately()
  local defaultCfg = PlayerData:GetFactoryData(99900069)
  local alreadyCount = PlayerData.ServerData.entrust_sp or 0
  if alreadyCount >= defaultCfg.rewardMaxNum then
    CommonTips.OpenTips(80611874)
    return
  end
  local state, reason = DataModel.GetEntrustState(DataModel.curEntrustSelectIdx)
  local info = DataModel.entrustList[DataModel.curEntrustSelectIdx]
  if state == DataModel.entrustState.Ing then
    local costData1 = defaultCfg.timeCostList[1]
    local curTime = TimeUtil:GetServerTimeStamp()
    local timeCost = math.ceil((info.endTime - curTime) / defaultCfg.timeLimit) * costData1.num
    local baseCost = defaultCfg.timeCostBaseList[1].num
    local totleCost = timeCost + baseCost
    CommonTips.OnPrompt(string.format(GetText(80611869), totleCost), nil, nil, function()
      if info.state == DataModel.entrustState.Complete then
        CommonTips.OpenTips(80607981)
        return
      end
      if PlayerData:GetGoodsById(costData1.id).num < totleCost then
        CommonTips.OpenTips(80600335)
        return
      end
      Net:SendProto("building.recall_entrust", function(json)
        PlayerData:RefreshUseItems({
          [costData1.id] = totleCost
        })
        info.endTime = curTime
        PlayerData.ServerData.entrust_sp = alreadyCount + 1
        if PlayerData.ServerData.entrust[tostring(info.id)] ~= nil then
          PlayerData.ServerData.entrust[tostring(info.id)].end_ts = curTime
        end
      end, info.id)
    end)
  end
end

function Controller:ClickEntrustBtn()
  local state, reason = DataModel.GetEntrustState(DataModel.curEntrustSelectIdx)
  local info = DataModel.entrustList[DataModel.curEntrustSelectIdx]
  if state == DataModel.entrustState.Lock then
    if reason == 1 then
      CommonTips.OpenTips(80608598)
    elseif reason == 3 then
      CommonTips.OpenTips(80609543)
    else
      CommonTips.OpenTips(80608599)
    end
  elseif state == DataModel.entrustState.CanAccept then
    local cacheRoleId = {}
    local roles = ""
    local rolesCount = #info.roles
    for i, v in ipairs(info.roles) do
      cacheRoleId[v] = i
      roles = roles .. v
      if i ~= rolesCount then
        roles = roles .. ","
      end
    end
    for i, entrustInfo in ipairs(DataModel.entrustList) do
      if entrustInfo.state ~= DataModel.entrustState.CanAccept then
        for i1, roleId in ipairs(entrustInfo.roles) do
          if cacheRoleId[roleId] ~= nil then
            info.roles[cacheRoleId[roleId]] = -1
            Controller:RefreshBottomShow(DataModel.curEntrustSelectIdx)
            CommonTips.OpenTips(80608602)
            return
          end
        end
      end
    end
    Net:SendProto("building.entrust", function(json)
      CommonTips.OpenTips(80608597)
      for k, v in pairs(json.entrust) do
        PlayerData.ServerData.entrust[k] = v
      end
      DataModel.curEntrustedCount = DataModel.curEntrustedCount + 1
      info.queueIdx = DataModel.curEntrustedCount
      DataModel.RefreshEntrustInfoByIdx(DataModel.curEntrustSelectIdx)
      DataModel.RefreshRolesInfo(DataModel.curEntrustSelectIdx)
      DataModel.SortEntrustList()
      DataModel.RefreshCurSelectEntrustIdx(info.id)
      Controller:RefreshEntrustList()
      Controller:RefreshBottomShow(DataModel.curEntrustSelectIdx)
      Controller:RefreshEntrustNum()
    end, info.id, info.cacheTimeSelectIdx - 1, roles)
  elseif state == DataModel.entrustState.Ing then
    CommonTips.OnPrompt(80608596, nil, nil, function()
      if info.state == DataModel.entrustState.Complete then
        CommonTips.OpenTips(80607981)
        return
      end
      Net:SendProto("building.cancel_entrust", function(json)
        PlayerData.ServerData.entrust[tostring(info.id)] = nil
        DataModel.curEntrustedCount = DataModel.curEntrustedCount - 1
        local oldQueueIdx = info.queueIdx
        info.queueIdx = -1
        for i, v in ipairs(DataModel.entrustList) do
          if oldQueueIdx < v.queueIdx then
            v.queueIdx = v.queueIdx - 1
          end
        end
        DataModel.RefreshEntrustInfoByIdx(DataModel.curEntrustSelectIdx)
        DataModel.RefreshRolesInfo(DataModel.curEntrustSelectIdx)
        DataModel.SortEntrustList()
        DataModel.RefreshCurSelectEntrustIdx(info.id)
        Controller:RefreshEntrustList()
        Controller:RefreshBottomShow(DataModel.curEntrustSelectIdx)
        Controller:RefreshEntrustNum()
      end, info.id)
    end)
  elseif state == DataModel.entrustState.Complete then
    Controller:ClickOneKeyGetBtn()
    do return end
    Net:SendProto("building.rec_entrust", function(json)
      PlayerData.ServerData.entrust[tostring(info.id)] = nil
      DataModel.curEntrustedCount = DataModel.curEntrustedCount - 1
      local oldQueueIdx = info.queueIdx
      info.queueIdx = -1
      for i, v in ipairs(DataModel.entrustList) do
        if oldQueueIdx < v.queueIdx then
          v.queueIdx = v.queueIdx - 1
        end
      end
      local t = DataModel.EntrustToReward(DataModel.curEntrustSelectIdx)
      DataModel.RefreshEntrustInfoByIdx(DataModel.curEntrustSelectIdx)
      DataModel.RefreshRolesInfo(DataModel.curEntrustSelectIdx)
      DataModel.SortEntrustList()
      DataModel.RefreshCurSelectEntrustIdx(info.id)
      Controller:RefreshEntrustList()
      Controller:RefreshBottomShow(DataModel.curEntrustSelectIdx)
      Controller:RefreshEntrustNum()
      Controller:RefreshOneKeyGetBtnShow()
      local toReport = {t}
      DataModel.SetReportIsRewardUp(toReport, json.reward)
      UIManager:Open("UI/Entrust/Report", Json.encode(toReport), function()
        DataModel.curEntrustedCount = DataModel.curEntrustedCount + 1
        info.queueIdx = DataModel.curEntrustedCount
        DataModel.RefreshEntrustInfoByIdx(DataModel.curEntrustSelectIdx)
        DataModel.RefreshRolesInfo(DataModel.curEntrustSelectIdx)
        DataModel.SortEntrustList()
        DataModel.RefreshCurSelectEntrustIdx(info.id)
        Controller:RefreshEntrustList()
        Controller:RefreshBottomShow(DataModel.curEntrustSelectIdx)
        Controller:RefreshEntrustNum()
        Controller:RefreshOneKeyGetBtnShow()
      end)
    end, info.id)
  end
end

function Controller:ClickOneKeyGetBtn()
  local ids = ""
  local completeIdxs = {}
  for i, v in ipairs(DataModel.entrustList) do
    if v.state == DataModel.entrustState.Complete then
      table.insert(completeIdxs, i)
      if ids == "" then
        ids = v.id
      else
        ids = ids .. "," .. v.id
      end
    end
  end
  Net:SendProto("building.rec_entrust", function(json)
    local isRefreshCur = false
    local toReport = {}
    for i, idx in ipairs(completeIdxs) do
      local info = DataModel.entrustList[idx]
      local id = info.id
      PlayerData.ServerData.entrust[tostring(id)] = nil
      DataModel.curEntrustedCount = DataModel.curEntrustedCount - 1
      DataModel.CalcRolesInfo(idx)
      toReport[i] = DataModel.EntrustToReward(idx)
      DataModel.RefreshEntrustInfoByIdx(idx)
      DataModel.RefreshRolesInfo(idx)
      if idx == DataModel.curEntrustSelectIdx then
        isRefreshCur = true
      end
    end
    local curId = DataModel.entrustList[DataModel.curEntrustSelectIdx].id
    DataModel.SortEntrustList()
    DataModel.RefreshCurSelectEntrustIdx(curId)
    Controller:RefreshEntrustList()
    if isRefreshCur then
      Controller:RefreshBottomShow(DataModel.curEntrustSelectIdx)
    end
    Controller:RefreshEntrustNum()
    Controller:RefreshOneKeyGetBtnShow()
    DataModel.SetReportIsRewardUp(toReport, json.reward)
    UIManager:Open("UI/Entrust/Report", Json.encode(toReport), function()
      local idsTable = string.split(ids, ",")
      for i, id in ipairs(idsTable) do
        id = tonumber(id)
        local idx = 0
        local info
        for i1, v in ipairs(DataModel.entrustList) do
          if v.id == id then
            idx = i1
            info = v
            break
          end
        end
        DataModel.curEntrustedCount = DataModel.curEntrustedCount + 1
        info.queueIdx = DataModel.curEntrustedCount
        DataModel.RefreshEntrustInfoByIdx(idx)
        DataModel.RefreshRolesInfo(idx)
        if idx == DataModel.curEntrustSelectIdx then
          isRefreshCur = true
        end
      end
      curId = DataModel.entrustList[DataModel.curEntrustSelectIdx].id
      DataModel.SortEntrustList()
      DataModel.RefreshCurSelectEntrustIdx(curId)
      Controller:RefreshEntrustList()
      if isRefreshCur then
        Controller:RefreshBottomShow(DataModel.curEntrustSelectIdx)
      end
      Controller:RefreshEntrustNum()
      Controller:RefreshOneKeyGetBtnShow()
    end)
  end, ids)
end

function Controller:ClickEntrustElement(str, force)
  Controller:RefreshEntrustFinishTime()
  local idx = tonumber(str)
  if idx == DataModel.curEntrustSelectIdx and not force then
    return
  end
  local oldIdx = DataModel.curEntrustSelectIdx
  DataModel.curEntrustSelectIdx = idx
  Controller:RefreshBottomShow(idx)
  local lastElement = View.ScrollGrid_List.grid.self:GetElementByIndex(oldIdx - 1)
  if lastElement then
    Controller:RefreshEntrustElement(lastElement, oldIdx)
  end
  local curElement = View.ScrollGrid_List.grid.self:GetElementByIndex(idx - 1)
  if curElement then
    Controller:RefreshEntrustElement(curElement, idx)
  end
end

function Controller:ClickRole()
  View.Group_Select.self:SetActive(true)
  DataModel.SortRoles()
  View.Group_Select.ScrollGrid_RoleList.grid.self:SetDataCount(#DataModel.roles)
  View.Group_Select.ScrollGrid_RoleList.grid.self:MoveToTop()
  View.Group_Select.ScrollGrid_RoleList.grid.self:RefreshAllElement()
end

function Controller:ClickSelectRoleElement(str)
  local idx = tonumber(str)
  local info = DataModel.roles[idx]
  local oldCount = DataModel.GetRolesCount(DataModel.curEntrustSelectIdx)
  local curSelectEntrustId = DataModel.entrustList[DataModel.curEntrustSelectIdx].id
  if 5 <= oldCount and info.entrustId ~= curSelectEntrustId then
    CommonTips.OpenTips(80607962)
    return
  end
  if info.entrusted then
    if info.entrustId == curSelectEntrustId then
      local roleBottomIdx = DataModel.RemoveRoleToEntrust(DataModel.curEntrustSelectIdx, info.id)
      info.entrustId = -1
      DataModel.cacheRolesInEntrustId[info.id] = nil
      if 0 < roleBottomIdx then
        local roleElement = View.Group_Left.Group_Queue.StaticGrid_RoleList.grid[roleBottomIdx]
        Controller:RefreshRoleElement(roleElement, roleBottomIdx)
      end
    end
    CommonTips.OpenTips(80608602)
    return
  end
  local roleBottomIdx = -1
  if info.entrustId == curSelectEntrustId then
    roleBottomIdx = DataModel.RemoveRoleToEntrust(DataModel.curEntrustSelectIdx, info.id)
    info.entrustId = -1
    DataModel.cacheRolesInEntrustId[info.id] = nil
  else
    local entrustId = DataModel.cacheRolesInEntrustId[info.id]
    if entrustId and 0 < entrustId then
      DataModel.RemoveRoleToEntrust(entrustId, info.id)
    end
    roleBottomIdx = DataModel.SaveRoleToEntrust(DataModel.curEntrustSelectIdx, info.id)
    info.entrustId = curSelectEntrustId
    DataModel.cacheRolesInEntrustId[info.id] = curSelectEntrustId
  end
  local element = View.Group_Select.ScrollGrid_RoleList.grid.self:GetElementByIndex(idx - 1)
  Controller:RefreshSelectPanelRoleElement(element, idx)
  if 0 < roleBottomIdx then
    local roleElement = View.Group_Left.Group_Queue.StaticGrid_RoleList.grid[roleBottomIdx]
    Controller:RefreshRoleElement(roleElement, roleBottomIdx)
  end
  local newCount = DataModel.GetRolesCount(DataModel.curEntrustSelectIdx)
  if oldCount >= DataModel.limitCharacter or newCount >= DataModel.limitCharacter then
    Controller:RefreshBottomRewardShow(true)
    Controller:RefreshBottomBtnShow(DataModel.curEntrustSelectIdx)
  end
end

function Controller:CloseSelectRoleView()
  View.Group_Select.self:SetActive(false)
end

function Controller:RefreshRecommendElement(element, elementIndex)
  local info = DataModel.entrustList[DataModel.curEntrustSelectIdx]
  local recommendSide = info.recommendSideList[elementIndex]
  local tagCA = PlayerData:GetFactoryData(recommendSide.id)
  element.Img_Camp:SetSprite(tagCA.recommendPath)
end

function Controller:RefreshRoleElement(element, elementIndex)
  local info = DataModel.entrustList[DataModel.curEntrustSelectIdx]
  local roleId = info.roles[elementIndex]
  local isHaveRole = roleId and 0 < roleId
  element.Group_Off.self:SetActive(not isHaveRole)
  element.Group_On.self:SetActive(isHaveRole)
  if isHaveRole then
    local serverRoles = PlayerData.ServerData.roles[tostring(roleId)]
    local skinId = serverRoles.current_skin and serverRoles.current_skin[1] or ""
    if string.nilorempty(skinId) then
      local unitCA = PlayerData:GetFactoryData(roleId)
      skinId = unitCA.viewId
    end
    local unitViewCA = PlayerData:GetFactoryData(skinId)
    element.Group_On.Spine_Role:SetData(unitViewCA.resDir)
    local lv = serverRoles.lv
    element.Group_On.Txt_Grade:SetText(string.format(GetText(80608600), lv))
  end
  element.Btn_Click:SetClickParam(elementIndex)
end

function Controller:RefreshSelectPanelRoleElement(element, elementIndex)
  local info = DataModel.roles[elementIndex]
  element.Img_Head:SetSprite(info.face)
  element.Txt_Lv:SetText(string.format(GetText(80608600), info.lv))
  element.Txt_Name:SetText(info.name)
  element.Group_Camp.Img_Camp:SetSprite(info.sideIconPath)
  local color = "#FFFFFF"
  local isRecommendSide = DataModel.recommendSideDic[info.sideId] ~= nil
  if isRecommendSide then
    color = "#ADCC49"
  end
  element.Img_Recommend:SetActive(isRecommendSide)
  element.Group_Camp.Img_Camp:SetColor(color)
  local isSelect = info.entrustId == DataModel.entrustList[DataModel.curEntrustSelectIdx].id
  element.Img_Select:SetActive(isSelect)
  element.Group_Team.self:SetActive(info.entrusted or isSelect)
  if info.entrusted then
    local entrustInfo
    for i, v in ipairs(DataModel.entrustList) do
      if v.id == info.entrustId then
        entrustInfo = DataModel.entrustList[i]
        break
      end
    end
    element.Group_Team.Txt_Team:SetText(string.format(GetText(80608601), entrustInfo.queueIdx))
  elseif isSelect then
    element.Group_Team.Txt_Team:SetText(string.format(GetText(80608601), DataModel.curEntrustedCount + 1))
  end
  element.Btn_Click:SetClickParam(elementIndex)
end

function Controller:RefreshEntrustElement(element, elementIndex)
  Controller:RefreshEntrustFinishTime()
  if DataModel.toSaveEntrustUpdateIdx then
    table.insert(DataModel.showEntrustIdx, elementIndex)
  elseif elementIndex <= DataModel.showEntrustIdx[1] - 1 then
    if elementIndex == DataModel.showEntrustIdx[1] - 1 then
      DataModel.showEntrustIdx[#DataModel.showEntrustIdx] = nil
    end
    table.insert(DataModel.showEntrustIdx, 1, elementIndex)
  elseif elementIndex >= DataModel.showEntrustIdx[#DataModel.showEntrustIdx] + 1 then
    if elementIndex == DataModel.showEntrustIdx[#DataModel.showEntrustIdx] + 1 then
      table.remove(DataModel.showEntrustIdx, 1)
    end
    table.insert(DataModel.showEntrustIdx, elementIndex)
  end
  local info = DataModel.entrustList[elementIndex]
  element.Group_List.Img_Bg:SetSprite(info.bgPath)
  element.Group_List.Txt_Name:SetText(info.name)
  element.Group_List.Group_Reward.StaticGrid_List.grid.self:SetParentParam(elementIndex)
  element.Group_List.Group_Reward.StaticGrid_List.grid.self:RefreshAllElement()
  element.Group_List.Group_Wei.self:SetActive(info.state == DataModel.entrustState.CanAccept)
  element.Group_List.Group_On.self:SetActive(info.state == DataModel.entrustState.Ing)
  element.Group_List.Txt_Name:SetActive(info.state ~= DataModel.entrustState.Ing)
  element.Group_List.Group_Complete.self:SetActive(info.state == DataModel.entrustState.Complete)
  if info.state == DataModel.entrustState.CanAccept then
    element.Group_List.Group_Wei.Img_Icon:SetSprite(info.notPath)
  elseif info.state == DataModel.entrustState.Ing then
    element.Group_List.Group_On.Img_Icon:SetSprite(info.onPath)
    local curTime = TimeUtil:GetServerTimeStamp()
    if curTime < info.endTime then
      local t = TimeUtil:SecondToTable(info.endTime - curTime)
      element.Group_List.Group_On.Txt_Time:SetText(string.format(GetText(80608594), t.hour, t.minute, t.second))
      element.Group_List.Group_On.Group_Schedule.Img_Schedule:SetFilledImgAmount((curTime - info.startTime) / info.totalTime)
    end
  elseif info.state == DataModel.entrustState.Complete then
    element.Group_List.Group_Complete.Img_Icon:SetSprite(info.completePath)
  end
  element.Group_List.Img_Select:SetActive(elementIndex == DataModel.curEntrustSelectIdx)
  element.Group_List.Btn_:SetClickParam(elementIndex)
end

function Controller:RefreshEntrustRewardElement(element, elementIndex)
  local info = DataModel.entrustList[tonumber(element.ParentParam)]
  local rewardInfo = info.rewardList[elementIndex]
  element:SetActive(rewardInfo ~= nil)
  if rewardInfo ~= nil then
    element.Txt_Eng:SetText(string.format(GetText(80608593), elementIndex))
    element.Img_Icon:SetSprite(rewardInfo.png)
  end
end

function Controller:RefreshDetailRewardElement(element, elementIndex)
  local info = DataModel.entrustList[DataModel.curEntrustSelectIdx]
  local rewardInfo = info.rewardList[elementIndex]
  element:SetActive(rewardInfo ~= nil)
  if rewardInfo ~= nil then
    BtnItem:SetItem(element.Group_Item, {
      id = rewardInfo.id
    })
    element.Group_Item.Btn_Item:SetClickParam(rewardInfo.id)
    local num = DataModel.CalcRewardIncrease(DataModel.curEntrustSelectIdx, elementIndex)
    element.Group_Num.Group_Num.Txt_Num:SetText(num)
  end
end

function Controller:ClickRewardItem(str)
  local id = tonumber(str)
  CommonTips.OpenPreRewardDetailTips(id)
end

function Controller:RefreshEntrustNum()
  View.Group_Top.Txt_Num:SetText(string.format(GetText(80608592), DataModel.curEntrustedCount, DataModel.maxEntrustedCount))
end

function Controller:ClickSchedule()
  UIManager:Open("UI/Activity/ActivityMain", Json.encode({id = 86000096}))
end

function Controller:ClickHelp()
  UIManager:Open("UI/Common/Group_Help", Json.encode({helpId = 80304066}))
end

function Controller:Return()
  UIManager:GoBack()
end

function Controller:Home()
  UIManager:GoHome()
end

function Controller:UpdateRefreshRewardUp()
  local curTime = TimeUtil:GetServerTimeStamp()
  if curTime >= DataModel.nextRewardUpRefreshTime then
    Controller:RefreshBottomRewardUpShow()
    DataModel.CheckIsRewardUp()
  end
end

function Controller:RefreshScheduleShow()
  View.Btn_Schedule.Img_RedPoint:SetActive(FastBattleDataModel.GetAllLeverRewardRedDotState())
end

function Controller:RefreshEntrustFinishTime()
  local alreadyCount = PlayerData.ServerData.entrust_sp or 0
  local defaultCfg = PlayerData:GetFactoryData(99900069)
  local totalCount = defaultCfg.rewardMaxNum
  local time = totalCount - alreadyCount
  if time < 0 then
    time = 0
    Debug.Log("\230\180\190\233\129\163\229\138\160\233\128\159\230\172\161\230\149\176\229\176\143\228\186\1420")
  end
  View.Group_Right.Group_Btn.Group_GetNow.Txt_:SetText(string.format(GetText(80611901), time))
end

return Controller
