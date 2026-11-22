local DataModel = require("UIMonopoly/UIMonopolyDataModel")
local View = require("UIMonopoly/UIMonopolyView")
local LuaMonopolyManager = {
  roleGO = nil,
  roleHeadInfo = nil,
  roleCtrl = nil,
  roleStatus = 0,
  roleAni = nil,
  diceAni = nil,
  moveDir = Vector3(0, 0, 0),
  targetPos = Vector3(0, 0, 0),
  inputCtrl = nil,
  lastDir = -1,
  nextDir = -1,
  lastStep = 0,
  nextGridId = nil,
  lastSelectDir = nil,
  godRefreshTime = nil,
  pathGridIds = {},
  mapGridBubbles = {},
  nextRefreshTime = 0,
  buffGodObj = nil,
  boxBoss = {obj = nil, gridId = nil},
  bossLevel = nil,
  smallBoxBoss = {},
  isMoveFail = false,
  curInstructionObj = nil,
  investItem = 0,
  investList = nil,
  curSelectItemObj = nil,
  curSelectPlayerObj = nil,
  itemId_Dice = 11400335,
  CurDragSelectObj = nil,
  tipsShowC = nil,
  isClickUI = false,
  cameraCtrl = nil,
  firstInitC = nil
}

local function _init()
  LuaMonopolyManager.Release()
  Net:SendProto("monopoly.mpy_refresh")
  TimerHelper.Stop("Monopoly_RefreshGridOutput_Req_Timer")
  TimerHelper.Start("Monopoly_RefreshGridOutput_Req_Timer", DataModel.refreshGridOutputTimerInterval, function()
    if DataModel.GetInterfaceIsfull() == 0 then
      LuaMonopolyManager.ReqLookGridOutput()
    end
    LuaMonopolyManager.RefreshDiceDayShow()
  end)
  LuaMonopolyManager.ReqMonopolyMap()
  DataModel.InitDayRefreshTime()
end

function LuaMonopolyManager.Init()
  _init()
end

local function roleMove()
  if LuaMonopolyManager.roleGO ~= nil then
    if LuaMonopolyManager.roleStatus == 1 then
      LuaMonopolyManager.roleGO.transform.localPosition = LuaMonopolyManager.roleGO.transform.localPosition + LuaMonopolyManager.moveDir * 0.1
      if 0.1 > (LuaMonopolyManager.targetPos - LuaMonopolyManager.roleGO.transform.localPosition).sqrMagnitude then
        LuaMonopolyManager.roleStatus = 0
        LuaMonopolyManager.roleGO.transform.localPosition = LuaMonopolyManager.targetPos
        LuaMonopolyManager.OnArrive()
      end
    elseif LuaMonopolyManager.roleStatus == 2 then
      LuaMonopolyManager.roleGO.transform.localPosition = LuaMonopolyManager.roleGO.transform.localPosition + LuaMonopolyManager.moveDir * 0.1
      if 0.1 > (LuaMonopolyManager.targetPos - LuaMonopolyManager.roleGO.transform.localPosition).sqrMagnitude then
        LuaMonopolyManager.roleStatus = 0
        LuaMonopolyManager.roleGO.transform.localPosition = LuaMonopolyManager.targetPos
        LuaMonopolyManager.OnAutoMoveArrive()
      end
    end
  end
end

local function checkBossIsClick()
  if Input.GetMouseButtonDown(0) then
    local isArrowShow = LuaMonopolyManager.GetArrowIsShow()
    local isMoving = LuaMonopolyManager.roleStatus == 1
    if not isArrowShow and not isMoving then
      local uiObj = PlotManager:GetRaycastHitObj(Input.mousePosition)
      if uiObj == nil then
        local obj = PlotManager:GetRayHitObj(Input.mousePosition)
        if obj ~= nil then
          local curPanel = UIManager:GetCurrentPanelURL()
          if curPanel == "UI/Monopoly/Monopoly" and curPanel ~= "UI/Monopoly/UI/Boss/BossMenu" then
            local pathList = string.split(obj.name, "|")
            if pathList and pathList[1] == "MONOPOLY_BOX_BOSS" then
              LuaMonopolyManager.OnClickBoxBoss(pathList[2], false)
            end
          end
        end
      end
    end
  end
end

local function updateInput()
  if LuaMonopolyManager.inputCtrl ~= nil then
    if Input.GetMouseButtonDown(0) then
      local uiObj = PlotManager:GetRaycastHitObj(Input.mousePosition)
      if uiObj then
        LuaMonopolyManager.isClickUI = true
      end
    end
    if Input.GetMouseButtonUp(0) then
      LuaMonopolyManager.isClickUI = false
    end
    if not LuaMonopolyManager.isClickUI then
      if GameSetting.platform == "Harmony" or GameSetting.platform == "Android" or GameSetting.platform == "IOS" then
        if LuaMonopolyManager.HarmonyInputCtrl then
          LuaMonopolyManager.HarmonyInputCtrl.OnUpdate()
        end
      else
        LuaMonopolyManager.inputCtrl:OnUpdate()
      end
    end
  end
end

local function updateItemDrag()
  LuaMonopolyManager.OnItemDragging()
  if Input.GetMouseButtonUp(0) then
    LuaMonopolyManager.OnItemDragEnd()
  end
end

function LuaMonopolyManager.OnUpdate()
  roleMove()
  checkBossIsClick()
  updateInput()
  DataModel.OtherPlayerUpdate()
  LuaMonopolyManager.DayRefreshOrderPanel()
  updateItemDrag()
  LuaMonopolyManager.UpdatePlayerHeadBuffGodShow()
end

function LuaMonopolyManager.Release()
  DataModel.mainCamera = nil
  LuaMonopolyManager.cameraCtrl = nil
  TimerHelper.Stop("Monopoly_RefreshGridOutput_Req_Timer")
  LuaMonopolyManager.inputCtrl = nil
  LuaMonopolyManager.diceAni = nil
  LuaMonopolyManager.DestroyInstantiate()
  DataModel.curSelectItemId = 0
  DataModel.curSelectItemIndex = 0
  LuaMonopolyManager.curSelectItemObj = nil
  LuaMonopolyManager.curSelectPlayerObj = nil
  DataModel.lastMoneyNum = nil
  DataModel.moveSuccessJson = nil
  if LuaMonopolyManager.tipsShowC then
    View.self:StopC(LuaMonopolyManager.tipsShowC)
    LuaMonopolyManager.tipsShowC = nil
  end
  if LuaMonopolyManager.firstInitC then
    View.self:StopC(LuaMonopolyManager.firstInitC)
    LuaMonopolyManager.firstInitC = nil
  end
  DataModel.ReleaseSound()
end

function LuaMonopolyManager.DestroyInstantiate()
  if LuaMonopolyManager.roleGO then
    Object.Destroy(LuaMonopolyManager.roleGO)
    LuaMonopolyManager.roleGO = nil
  end
  if LuaMonopolyManager.roleHeadInfo and LuaMonopolyManager.roleHeadInfo.headObj then
    Object.Destroy(LuaMonopolyManager.roleHeadInfo.headObj)
    LuaMonopolyManager.roleHeadInfo = nil
  end
  LuaMonopolyManager.RemoveBuffGod()
  if LuaMonopolyManager.boxBoss then
    if LuaMonopolyManager.boxBoss.obj then
      Object.Destroy(LuaMonopolyManager.boxBoss.obj)
    end
    LuaMonopolyManager.boxBoss = nil
  end
  if DataModel.mapGridObjs then
    for _, obj in pairs(DataModel.mapGridObjs) do
      Object.Destroy(obj)
    end
    DataModel.mapGridObjs = {}
  end
  if LuaMonopolyManager.mapGridBubbles then
    for _, v in pairs(LuaMonopolyManager.mapGridBubbles) do
      if v and v.obj then
        Object.Destroy(v.obj)
      end
    end
    LuaMonopolyManager.mapGridBubbles = {}
  end
  DataModel.DestroyAllOtherPlayers()
  if LuaMonopolyManager.smallBoxBoss then
    for _, v in pairs(LuaMonopolyManager.smallBoxBoss) do
      if v.obj then
        Object.Destroy(v.obj)
      end
    end
    LuaMonopolyManager.smallBoxBoss = {}
  end
  if LuaMonopolyManager.CurDragSelectObj then
    Object.Destroy(LuaMonopolyManager.CurDragSelectObj)
    LuaMonopolyManager.CurDragSelectObj = nil
  end
  if DataModel.buffEffectObjs then
    for _, v in pairs(DataModel.buffEffectObjs) do
      if v.obj then
        Object.Destroy(v.obj)
      end
    end
    DataModel.buffEffectObjs = {}
  end
end

function LuaMonopolyManager.CheckTimeIsOverAndBack()
  DataModel.CheckTimeIsOverAndBack()
end

function LuaMonopolyManager.InitMap()
  if not DataModel.userMonopolyData then
    return
  end
  local mp = PlayerData:GetFactoryData(DataModel.userMonopolyData.monopoly_id, "MonopolyGameMapFactory")
  if mp then
    DataModel.SetGridList(mp.gridList)
    LuaMonopolyManager.investItem = mp.investItem
    LuaMonopolyManager.investList = mp.investList
    if not string.nilorempty(mp.godRefreshTime) then
      local hour = tonumber(string.sub(mp.godRefreshTime, 1, 2))
      local min = tonumber(string.sub(mp.godRefreshTime, 4, 5))
      local sec = tonumber(string.sub(mp.godRefreshTime, 7, 8))
      DataModel.godRefreshTime = {
        hour = hour,
        minute = min,
        second = sec
      }
    end
  end
  if not DataModel.serverMonopolyData then
    return
  end
  DataModel.mainCamera = CS.UnityEngine.GameObject.Find("Main Camera")
  DataModel.mapGridObjs = {}
  LuaMonopolyManager.buffGodObj = nil
  local gridPar = CS.UnityEngine.GameObject.Find("MONOPOLY_GRIDS_PAR")
  if gridPar and gridPar.transform.childCount == 0 and DataModel.userMonopolyData.map then
    for gridId, _ in pairs(DataModel.userMonopolyData.map) do
      local eventInfo, buffGod, boxBoss, boxGw, trap = DataModel.GetGridEventInfo(gridId)
      eventInfo = eventInfo or PlayerData:GetFactoryData(88800082, "MonopolyEventFactory")
      if eventInfo then
        local obj = View.self:GetRes(eventInfo.basePath, gridPar.transform)
        if obj then
          local mapInfo = DataModel.GetMapGridInfo(tonumber(gridId))
          if mapInfo then
            obj.transform.localPosition = Vector3(mapInfo.x, -0.06, mapInfo.y)
          end
          obj.gameObject.name = DataModel.objNamePrefix.GRID .. "|" .. gridId
          obj.transform.localScale = Vector3(0.9, 0.9, 0.9)
          local bubblePar = View.self:GetRes("UI/Monopoly/UI/Menu/BubblePar", obj.transform)
          if bubblePar then
            bubblePar.transform.localPosition = Vector3(0, 1, 0)
            bubblePar.transform.localScale = Vector3(0.6, 0.6, 0.6)
          end
          DataModel.mapGridObjs[gridId] = obj
        else
          print("***\230\160\188\229\173\144\233\162\132\229\136\182\228\189\147\232\183\175\229\190\132\228\184\186\231\169\186\239\188\154" .. tostring(gridId))
        end
      end
      if buffGod then
        DataModel.SetBuffGodInfo(buffGod, nil, nil)
        LuaMonopolyManager.CreateBuffGodOnGridId(tostring(gridId))
      end
      if boxGw then
        LuaMonopolyManager.CreateSmallBoxBoss(tostring(gridId), boxGw)
      end
      if trap then
        DataModel.CreateMapBuffEffectObj(tostring(gridId), trap.id, trap.time)
      end
    end
  end
  if DataModel.userMonopolyData.buff and DataModel.userMonopolyData.buff.god then
    for buffId, getTime in pairs(DataModel.userMonopolyData.buff.god) do
      DataModel.SetBuffGodInfo(buffId, PlayerData:GetUserInfo().role_name, PlayerData:GetUserInfo().uid, getTime)
    end
  end
  LuaMonopolyManager.RefreshSmallBoxMainUIShow()
  LuaMonopolyManager.CreateBoxBoss()
  LuaMonopolyManager.RefreshBoxBossMainUIShow()
  LuaMonopolyManager.ShowBuffGodTips()
end

function LuaMonopolyManager.ShowBuffGodTips()
  local content = DataModel.GetBuffGodTipsContent()
  LuaMonopolyManager.ShowTips(content, 5)
end

function LuaMonopolyManager.ShowTips(content, stayTime)
  if LuaMonopolyManager.tipsShowC then
    View.self:StopC(LuaMonopolyManager.tipsShowC)
    LuaMonopolyManager.tipsShowC = nil
  end
  View.Group_Tips:SetActive(true)
  View.self:PlayAnimOnce("TipsIn")
  View.Group_Tips.Img_TipsBG.Txt_:SetText(content)
  LuaMonopolyManager.tipsShowC = View.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForSeconds(stayTime))
    View.self:PlayAnimOnce("TipsOut")
  end))
end

function LuaMonopolyManager.InitCharacter()
  if not DataModel.userMonopolyData then
    return
  end
  local roleClone = CS.UnityEngine.GameObject.Find("MONOPOLY_ROLE")
  if roleClone then
    return
  end
  LuaMonopolyManager.nextGridId = tonumber(DataModel.userMonopolyData.loc)
  LuaMonopolyManager.pathGridIds = {}
  table.insert(LuaMonopolyManager.pathGridIds, LuaMonopolyManager.nextGridId)
  local gridInfo = DataModel.GetMapGridInfo(LuaMonopolyManager.nextGridId)
  if not gridInfo then
    return
  end
  local role = View.self:GetRes("UI/Monopoly/monopolyTrain")
  if role then
    local ainObj = role.transform:Find("M_Monopoly_Train_WYH_01_animation")
    if ainObj then
      LuaMonopolyManager.roleAni = ainObj:GetComponent(typeof(CS.UnityEngine.Animator))
    end
    local headPar = role.transform:Find("HeadPar")
    local headInfo = LuaMonopolyManager.CreateRoleHead(true, headPar, PlayerData:GetUserInfo().role_name or "", PlayerData:GetUserInfo().avatar)
    LuaMonopolyManager.roleHeadInfo = headInfo
    LuaMonopolyManager.roleAni:Play("wait")
    DataModel.PlayTrainIdleSound()
    local roleCtrl = CS.Monopoly.MonopolyRoleCtrl()
    if roleCtrl then
      roleCtrl.Skeleton.gameObject:SetActive(false)
      CS.FRef.setProperty(MonopolyManager, "RoleCtrl", roleCtrl)
      role.gameObject.name = DataModel.objNamePrefix.ROLE .. "|" .. PlayerData:GetUserInfo().uid
      role.transform:SetParent(roleCtrl.GO.transform)
      roleCtrl.GO.transform.localPosition = Vector3(gridInfo.x, 0.2, gridInfo.y)
      roleCtrl.GO.gameObject.name = "MONOPOLY_ROLE"
      local freeCamera = CS.UnityEngine.GameObject.Find("FreeCamera2")
      if freeCamera then
        LuaMonopolyManager.cameraCtrl = freeCamera:GetComponent(typeof(CS.Gaia.FreeCamera2))
      end
      if LuaMonopolyManager.cameraCtrl then
        LuaMonopolyManager.cameraCtrl:SetViewTarget(role.transform)
      end
      LuaMonopolyManager.inputCtrl = CS.Monopoly.MonopolyInput(MonopolyManager)
      LuaMonopolyManager.HarmonyInputCtrl = require("UIMonopoly/HarmonyInputCtrl")
      LuaMonopolyManager.HarmonyInputCtrl.MonoManager = MonopolyManager
      CS.FRef.setProperty(MonopolyManager, "InputCtrl", LuaMonopolyManager.inputCtrl)
      LuaMonopolyManager.roleCtrl = roleCtrl
      LuaMonopolyManager.roleGO = roleCtrl.GO
    end
    if not string.nilorempty(DataModel.userMonopolyData.lt_loc) then
      LuaMonopolyManager.lastSelectDir = DataModel.GetDirByNowAndLastId(tonumber(DataModel.userMonopolyData.loc), tonumber(DataModel.userMonopolyData.lt_loc))
      LuaMonopolyManager.SetRoleAngles(LuaMonopolyManager.lastSelectDir)
    else
      local randomDir = DataModel.GetADirGridByNowId(DataModel.userMonopolyData.loc)
      LuaMonopolyManager.SetRoleAngles(randomDir)
    end
  end
end

function LuaMonopolyManager.InitUI()
  local diceObj = View.Group_Model.transform:Find("M_Monopoly_Dice")
  if diceObj then
    LuaMonopolyManager.diceAni = diceObj:GetComponent(typeof(CS.UnityEngine.Animator))
  end
  if not DataModel.userMonopolyData then
    return
  end
  LuaMonopolyManager.RefreshDiceNum()
  LuaMonopolyManager.RefreshTelecontrolDiceNum()
  LuaMonopolyManager.RefreshRemainingNum()
  LuaMonopolyManager.RefreshMoneyNum()
  LuaMonopolyManager.RefreshGridMenu()
  LuaMonopolyManager.RefreshMainUIBuffList()
  LuaMonopolyManager.RefreshMonopolyLv()
end

function LuaMonopolyManager.InitSelect()
  if DataModel.GetInitStep() > 0 then
    LuaMonopolyManager.OnDiceOver()
  end
end

function LuaMonopolyManager.InitEventDialog()
  if not DataModel.userMonopolyData then
    return nil
  end
  local state = DataModel.GetGridCompleteState(tostring(LuaMonopolyManager.nextGridId))
  if state == 1 then
    return nil
  end
  if DataModel.userMonopolyData.end_events ~= nil and #DataModel.userMonopolyData.end_events > 0 then
    local endEventsCount = #DataModel.userMonopolyData.end_events
    local lsDialogStr = DataModel.userMonopolyData.end_events[endEventsCount]
    local lsDialogTb = string.split(lsDialogStr, ":") or {}
    local lsDialogId = 0
    local result
    lsDialogId = lsDialogTb[1]
    if lsDialogTb[2] == "shop" then
      Net:SendProto("monopoly.com_grid", nil, lsDialogId, nil)
      return nil
    end
    if table.count(lsDialogTb) == 2 then
      result = lsDialogTb[2] == "win" and 1 or 0
    end
    if result ~= nil then
      local dialogInfo = PlayerData:GetFactoryData(lsDialogId, "MonopolyEventFactory")
      if result == 0 then
        lsDialogId = dialogInfo.failid
      else
        lsDialogId = dialogInfo.sucid
      end
    end
    local locGridId = DataModel.userMonopolyData.loc
    local lv = DataModel.userMonopolyData.map[tostring(locGridId)] and DataModel.userMonopolyData.map[tostring(locGridId)].lv + 1 or 1
    LuaMonopolyManager.OpenDialog(lsDialogId, lv, DataModel.serverMonopolyData.map[locGridId].event, locGridId)
    return lsDialogId
  end
  return nil
end

function LuaMonopolyManager.SetDirToMove(dir, step)
  LuaMonopolyManager.lastStep = step
  LuaMonopolyManager.lastDir = dir
  LuaMonopolyManager.MoveOneStep()
end

function LuaMonopolyManager.MoveOneStep()
  if not DataModel.userMonopolyData then
    return
  end
  if LuaMonopolyManager.lastDir == -1 then
    DataModel.beforeMoveInfo.gridId = LuaMonopolyManager.nextGridId
    DataModel.beforeMoveInfo.moveDir = LuaMonopolyManager.lastSelectDir
    DataModel.beforeMoveInfo.step = DataModel.userMonopolyData.step
    print("***\231\167\187\229\138\168\229\188\128\229\167\139\239\188\129\239\188\129\239\188\129")
  end
  if LuaMonopolyManager.lastDir == -1 or DataModel.CheckDirSelect(LuaMonopolyManager.nextGridId) then
    local isRank = false
    local ca = PlayerData:GetFactoryData(LuaMonopolyManager.nextGridId, "MonopolyGameGridFactory")
    if ca then
      isRank = ca.isRank
    end
    local rel, onlyOne, autoDir = LuaMonopolyManager.GetDirExist()
    local isHasRandomArrowBuff = DataModel.GetIsHasBuffItemByType(DataModel.buffType.randomArrow)
    if isHasRandomArrowBuff then
      LuaMonopolyManager.CtlSelectDir(DataModel.GetARandomDir(rel))
    elseif not onlyOne or isRank or LuaMonopolyManager.isMoveFail then
      LuaMonopolyManager.FocusRoleTrain()
      LuaMonopolyManager.OnDirSelect(rel[1], rel[2], rel[3], rel[4])
    else
      LuaMonopolyManager.CtlSelectDir(autoDir)
    end
    return
  end
  LuaMonopolyManager.SelectDir(LuaMonopolyManager.nextDir)
  LuaMonopolyManager.lastSelectDir = LuaMonopolyManager.nextDir
end

function LuaMonopolyManager.OnDirSelect(up, right, down, left)
  View.Group_Arrow:SetActive(true)
  View.Group_Arrow.Btn_UP:SetActive(up)
  View.Group_Arrow.Btn_Left:SetActive(left)
  View.Group_Arrow.Btn_Down:SetActive(down)
  View.Group_Arrow.Btn_Right:SetActive(right)
end

function LuaMonopolyManager.GetArrowIsShow()
  if not View.Group_Arrow.gameObject.activeSelf then
    return false
  end
  if View.Group_Arrow.Btn_UP.gameObject.activeSelf then
    return true
  end
  if View.Group_Arrow.Btn_Left.gameObject.activeSelf then
    return true
  end
  if View.Group_Arrow.Btn_Down.gameObject.activeSelf then
    return true
  end
  if View.Group_Arrow.Btn_Right.gameObject.activeSelf then
    return true
  end
  return false
end

function LuaMonopolyManager.FocusRoleTrain()
  if LuaMonopolyManager.cameraCtrl then
    LuaMonopolyManager.cameraCtrl.SoftMove = false
    LuaMonopolyManager.cameraCtrl.ViewTarget = MonopolyManager.RoleCtrl.GO.transform
  end
end

function LuaMonopolyManager.SelectDir(dir)
  LuaMonopolyManager.lastDir = dir
  LuaMonopolyManager.nextGridId = LuaMonopolyManager.GetDirTile(dir)
  if LuaMonopolyManager.nextGridId == nil then
    return
  end
  table.insert(LuaMonopolyManager.pathGridIds, LuaMonopolyManager.nextGridId)
  LuaMonopolyManager.SetRoleAngles(LuaMonopolyManager.nextDir)
  local gridInfo = DataModel.GetMapGridInfo(LuaMonopolyManager.nextGridId)
  if not gridInfo then
    return
  end
  if not LuaMonopolyManager.roleGO then
    return
  end
  LuaMonopolyManager.Move(Vector3(gridInfo.x, LuaMonopolyManager.roleGO.transform.position.y, gridInfo.y), 1)
end

function LuaMonopolyManager.SetRoleAngles(dir)
  if not LuaMonopolyManager.roleGO or not dir then
    return
  end
  LuaMonopolyManager.roleGO.transform.localEulerAngles = Vector3(0, (dir - 1) * 90, 0)
  local rolePath = DataModel.objNamePrefix.ROLE .. "|" .. tostring(PlayerData:GetUserInfo().uid)
  local buffGodPar = LuaMonopolyManager.roleGO.transform:Find(rolePath .. "/BuffGodPar")
  if LuaMonopolyManager.roleHeadInfo then
    DataModel.SetObjRotationByDir(LuaMonopolyManager.roleHeadInfo.headObj, dir)
    DataModel.SetObjRotationByDir(buffGodPar, dir)
  end
end

function LuaMonopolyManager.Move(v, roleStatus, lastPathId, pathId)
  if not LuaMonopolyManager.roleGO then
    return
  end
  if lastPathId and pathId then
    local dir = DataModel.GetDirByNowAndLastId(tonumber(pathId), tonumber(lastPathId))
    LuaMonopolyManager.SetRoleAngles(dir)
  end
  LuaMonopolyManager.targetPos = v
  LuaMonopolyManager.roleStatus = roleStatus
  LuaMonopolyManager.moveDir = (v - LuaMonopolyManager.roleGO.transform.position).normalized
  LuaMonopolyManager.roleAni:Play("move")
  DataModel.PlayTrainMoveSound()
end

function LuaMonopolyManager.GetDirExist()
  local ca = PlayerData:GetFactoryData(LuaMonopolyManager.nextGridId, "MonopolyGameGridFactory")
  if not ca then
    return {
      false,
      false,
      false,
      false
    }, false, 0
  end
  local showCount = 0
  local autoDir = 0
  local showUp = LuaMonopolyManager.GetDirArrowCanShow(ca.upGrid, 1, ca.isTurnRound, ca.mod)
  if showUp then
    showCount = showCount + 1
    autoDir = 1
  end
  local showRight = LuaMonopolyManager.GetDirArrowCanShow(ca.rightGrid, 2, ca.isTurnRound, ca.mod)
  if showRight then
    showCount = showCount + 1
    autoDir = 2
  end
  local showDown = LuaMonopolyManager.GetDirArrowCanShow(ca.downGrid, 3, ca.isTurnRound, ca.mod)
  if showDown then
    showCount = showCount + 1
    autoDir = 3
  end
  local showLeft = LuaMonopolyManager.GetDirArrowCanShow(ca.leftGrid, 4, ca.isTurnRound, ca.mod)
  if showLeft then
    showCount = showCount + 1
    autoDir = 4
  end
  return {
    showUp,
    showRight,
    showDown,
    showLeft
  }, showCount == 1, autoDir
end

function LuaMonopolyManager.GetDirArrowCanShow(aroundTile, index, isTurnRound, mod)
  if aroundTile == nil or aroundTile == -1 then
    return false
  end
  local isHasBackBuff = DataModel.GetIsHasBuffItemByType(DataModel.buffType.back)
  if LuaMonopolyManager.lastSelectDir and not DataModel.GetIsDieRoad(LuaMonopolyManager.nextGridId) then
    if LuaMonopolyManager.lastDir == -1 and (mod == "\232\189\166\231\171\153" or isHasBackBuff) then
      return true
    end
    if LuaMonopolyManager.lastSelectDir == 1 and not isTurnRound then
      return index ~= 3
    end
    if LuaMonopolyManager.lastSelectDir == 2 and not isTurnRound then
      return index ~= 4
    end
    if LuaMonopolyManager.lastSelectDir == 3 and not isTurnRound then
      return index ~= 1
    end
    if LuaMonopolyManager.lastSelectDir == 4 and not isTurnRound then
      return index ~= 2
    end
  end
  return true
end

function LuaMonopolyManager.GetDirTile(dir)
  local ca = PlayerData:GetFactoryData(LuaMonopolyManager.nextGridId, "MonopolyGameGridFactory")
  if not ca then
    return nil
  end
  if dir == 1 and ca.upGrid ~= -1 and ca.upGrid ~= nil then
    LuaMonopolyManager.nextDir = 1
    return ca.upGrid
  end
  if dir == 2 and ca.rightGrid ~= -1 and ca.rightGrid ~= nil then
    LuaMonopolyManager.nextDir = 2
    return ca.rightGrid
  end
  if dir == 3 and ca.downGrid ~= -1 and ca.downGrid ~= nil then
    LuaMonopolyManager.nextDir = 3
    return ca.downGrid
  end
  if dir == 4 and ca.leftGrid ~= -1 and ca.leftGrid ~= nil then
    LuaMonopolyManager.nextDir = 4
    return ca.leftGrid
  end
  local existNum = 0
  local notNilTile
  local notNilDir = -1
  if ca.upGrid ~= -1 and ca.upGrid ~= nil then
    existNum = existNum + 1
    notNilTile = ca.upGrid
    notNilDir = 1
  end
  if ca.rightGrid ~= -1 and ca.rightGrid ~= nil then
    existNum = existNum + 1
    notNilTile = ca.rightGrid
    notNilDir = 2
  end
  if ca.downGrid ~= -1 and ca.downGrid ~= nil then
    existNum = existNum + 1
    notNilTile = ca.downGrid
    notNilDir = 3
  end
  if ca.leftGrid ~= -1 and ca.leftGrid ~= nil then
    existNum = existNum + 1
    notNilTile = ca.leftGrid
    notNilDir = 4
  end
  if existNum == 1 then
    LuaMonopolyManager.nextDir = notNilDir
    return notNilTile
  end
  local neDir = DataModel.GetNegaDirNum(dir)
  if neDir ~= 1 and ca.upGrid ~= -1 and ca.upGrid ~= nil then
    LuaMonopolyManager.nextDir = 1
    return ca.upGrid
  end
  if neDir ~= 2 and ca.rightGrid ~= -1 and ca.rightGrid ~= nil then
    LuaMonopolyManager.nextDir = 2
    return ca.rightGrid
  end
  if neDir ~= 3 and ca.downGrid ~= -1 and ca.downGrid ~= nil then
    LuaMonopolyManager.nextDir = 3
    return ca.downGrid
  end
  if neDir ~= 4 and ca.leftGrid ~= -1 and ca.leftGrid ~= nil then
    LuaMonopolyManager.nextDir = 4
    return ca.leftGrid
  end
  LuaMonopolyManager.nextDir = -1
  return nil
end

function LuaMonopolyManager.RollDiceEnd()
  LuaMonopolyManager.OnDiceOver()
end

function LuaMonopolyManager.OnArrive()
  local gridInfo = DataModel.GetMapGridInfo(LuaMonopolyManager.nextGridId)
  if not gridInfo then
    return
  end
  LuaMonopolyManager.lastStep = LuaMonopolyManager.lastStep - 1
  local isTrap = 0
  local isTriggerStop = DataModel.CheckIsTrapTrigger_Stop(tostring(LuaMonopolyManager.nextGridId))
  local isTriggerReturn = DataModel.CheckIsTrapTrigger_Return(tostring(LuaMonopolyManager.nextGridId))
  local isTriggerGo = DataModel.CheckIsTrapTrigger_Go(tostring(LuaMonopolyManager.nextGridId))
  if isTriggerStop or isTriggerReturn or isTriggerGo then
    isTrap = 1
    LuaMonopolyManager.lastStep = 0
    CommonTips.OpenTips(80609985)
  end
  if LuaMonopolyManager.lastStep <= 0 then
    LuaMonopolyManager.roleAni:Play("cease")
    DataModel.PlaySound(DataModel.soundIds.trainStop)
    View.self:StartC(LuaUtil.cs_generator(function()
      coroutine.yield(CS.UnityEngine.WaitForSeconds(0.7))
      DataModel.PlayTrainIdleSound()
    end))
    local pathIdsStr = ""
    LuaMonopolyManager.pathGridIds = LuaMonopolyManager.pathGridIds or {}
    local pathCount = #LuaMonopolyManager.pathGridIds
    for i = 1, pathCount do
      pathIdsStr = i == pathCount and pathIdsStr .. tostring(LuaMonopolyManager.pathGridIds[i]) or pathIdsStr .. tostring(LuaMonopolyManager.pathGridIds[i]) .. ";"
    end
    DataModel.moveSuccessJson = nil
    LuaMonopolyManager.ReqMovePosition(pathIdsStr, isTrap)
    return
  else
    LuaMonopolyManager.OnPass(LuaMonopolyManager.nextGridId)
  end
  LuaMonopolyManager.MoveOneStep()
end

function LuaMonopolyManager.OnAutoMoveArrive()
  DataModel.autoPathIds = DataModel.autoPathIds or {}
  local ltId = DataModel.autoPathIds[1]
  table.remove(DataModel.autoPathIds, 1)
  DataModel.MinusBuffTrapTime(tostring(ltId))
  if #DataModel.autoPathIds == 0 then
    LuaMonopolyManager.pathGridIds = {}
    table.insert(LuaMonopolyManager.pathGridIds, ltId)
    LuaMonopolyManager.roleStatus = 0
    LuaMonopolyManager.nextGridId = ltId
    DataModel.userMonopolyData.loc = ltId
    if not DataModel.itemEvents or #DataModel.itemEvents == 0 then
      if DataModel.moveSuccessJson then
        LuaMonopolyManager.DoMoveFinishLogic(ltId, DataModel.moveSuccessJson)
      end
    else
      local lastEvent = DataModel.itemEvents[1]
      table.remove(DataModel.itemEvents, 1)
      local nextEvent = DataModel.itemEvents[1]
      if #DataModel.itemEvents == 0 then
        if DataModel.moveSuccessJson and DataModel.moveSuccessJson.itemEvents then
          for i = 1, #DataModel.moveSuccessJson.itemEvents do
            DataModel.MinusBuffTrapTime(tostring(DataModel.moveSuccessJson.itemEvents[i][1]))
          end
        end
        if lastEvent then
          local finalItemId = lastEvent[2]
          LuaMonopolyManager.DoItemBuffById(finalItemId, DataModel.moveSuccessJson, ltId)
        end
      else
        local autoPathIds = DataModel.FindPathBFS(ltId, tonumber(nextEvent[1]))
        if autoPathIds then
          DataModel.autoPathIds = autoPathIds
          local gridInfo = DataModel.GetMapGridInfo(autoPathIds[1])
          if gridInfo then
            LuaMonopolyManager.Move(Vector3(gridInfo.x, LuaMonopolyManager.roleGO.transform.position.y, gridInfo.y), 2, ltId, autoPathIds[1])
          end
        end
      end
    end
  else
    local gridInfo = DataModel.GetMapGridInfo(DataModel.autoPathIds[1])
    if gridInfo then
      LuaMonopolyManager.Move(Vector3(gridInfo.x, LuaMonopolyManager.roleGO.transform.position.y, gridInfo.y), 2, ltId, DataModel.autoPathIds[1])
    end
  end
end

function LuaMonopolyManager.OnReach(dialogId, lv, eventId, gridId)
  DataModel.MinusOneStep()
  LuaMonopolyManager.RefreshRemainingNum()
  local isCom = DataModel.GetGridCompleteState(tostring(gridId))
  if isCom == 1 then
    return
  end
  local ca = PlayerData:GetFactoryData(dialogId, "MonopolyEventFactory")
  if ca then
    LuaMonopolyManager.OpenDialog(dialogId, lv, eventId, gridId)
  end
end

function LuaMonopolyManager.OnPass()
  DataModel.MinusOneStep()
  LuaMonopolyManager.RefreshRemainingNum()
end

function LuaMonopolyManager.OnDiceOver()
  LuaMonopolyManager.RefreshRemainingNum()
  LuaMonopolyManager.SetDirToMove(-1, DataModel.userMonopolyData.step)
end

function LuaMonopolyManager.CtlSelectDir(dir)
  View.Group_Arrow:SetActive(false)
  LuaMonopolyManager.FocusRoleTrain()
  LuaMonopolyManager.lastSelectDir = dir
  LuaMonopolyManager.SelectDir(dir)
end

function LuaMonopolyManager.ReqMonopolyMap(onlyRefreshDice)
  local function cbSuccess(json)
    if json then
      if not onlyRefreshDice then
        DataModel.SetUserMonopolyData(json.user_monopoly)
        
        DataModel.SetServerMonopolyData(json.server_monopoly)
        DataModel.SetInterfaceData(json.interface)
        DataModel.SetInterfaceIsfull(json.isFull)
        DataModel.isInRefreshCDing = false
        DataModel.refreshBtnInCD = false
        PlayerData.SetUserMonopolyRankRec(json.user_monopoly.mpy_rank_recv)
        PlayerData.SetMonopolySignMpy(1)
        LuaMonopolyManager.InitMap()
        LuaMonopolyManager.InitCharacter()
        LuaMonopolyManager.InitUI()
        LuaMonopolyManager.smallBoxBoss = LuaMonopolyManager.smallBoxBoss or {}
        local curGridId = DataModel.userMonopolyData.loc
        if LuaMonopolyManager.smallBoxBoss[tostring(curGridId)] and LuaMonopolyManager.smallBoxBoss[tostring(curGridId)].eventId and LuaMonopolyManager.GetFightNumIsEnough() then
          UIManager:Open("UI/Monopoly/UI/BoxEnemy/BoxEnemy", Json.encode({
            gridId = curGridId,
            eventId = LuaMonopolyManager.smallBoxBoss[tostring(curGridId)].eventId,
            difficulty = DataModel.GetSmallBoxDifficulty(),
            dialogEvent = json.dialogEvent,
            isInit = true
          }))
        else
          LuaMonopolyManager.InitEventDialog()
        end
        LuaMonopolyManager.InitSelect()
        LuaMonopolyManager.InitGridBubbles()
        LuaMonopolyManager.RefreshDiceDayShow()
        LuaMonopolyManager.RefreshPlayHeadBuffGodShow(PlayerData:GetUserInfo().uid)
        LuaMonopolyManager.CreateOtherPlayer()
        local isBoxFight, isHelpBoss = LuaMonopolyManager.GetBoxBossFightState()
        if isBoxFight then
          LuaMonopolyManager.OnClickBoxBoss(LuaMonopolyManager.bossLevel, isHelpBoss)
          LuaMonopolyManager.SetBoxBossFightState(false, false)
        end
      end
      if json.add_dice and json.add_dice > 0 then
        local curPanel = UIManager:GetCurrentPanelURL()
        if curPanel == "UI/Monopoly/Monopoly" then
          DataModel.OpenDiceRewardPanel(json.add_dice, LuaMonopolyManager.itemId_Dice)
        end
      end
    end
  end
  
  local function cbFail(json)
    LuaMonopolyManager.CheckTimeIsOverAndBack()
  end
  
  Net:SendProto("monopoly.monopoly_map", cbSuccess, cbFail)
end

function LuaMonopolyManager.ReqMovePosition(pathIdsStr, isTrap)
  if not DataModel.userMonopolyData then
    return
  end
  
  local function cbSuccess(json)
    if json then
      LuaMonopolyManager.isMoveFail = false
      DataModel.userMonopolyData.step = 0
      LuaMonopolyManager.RefreshRemainingNum()
      LuaMonopolyManager.MinusBuffTimeByTime(DataModel.buffType.back)
      LuaMonopolyManager.MinusBuffTimeByTime(DataModel.buffType.randomArrow)
      local isHasReturn = false
      if json.itemEvents and 0 < #json.itemEvents then
        local itemId = json.itemEvents[#json.itemEvents][2]
        local itemInfo = PlayerData:GetFactoryData(itemId, "ItemFactory")
        if itemInfo.playerItemType == DataModel.buffType.return_ then
          isHasReturn = true
        end
      end
      local ltId = LuaMonopolyManager.pathGridIds[#LuaMonopolyManager.pathGridIds]
      DataModel.userMonopolyData.loc = ltId
      if not isHasReturn then
        LuaMonopolyManager.MinusBuffTimeByTime(DataModel.buffType.investNum)
        DataModel.ResetItemUseTime()
        LuaMonopolyManager.SetGridCompleteState(tostring(LuaMonopolyManager.pathGridIds[1]), 0)
        DataModel.ResetGridInvestNum(tostring(LuaMonopolyManager.pathGridIds[1]))
        DataModel.SetSmallBoxDifficulty(0)
        DataModel.SetSmallBoxFightNum(0)
      end
      LuaMonopolyManager.pathGridIds = {}
      table.insert(LuaMonopolyManager.pathGridIds, ltId)
      if not string.nilorempty(json.curLoc) then
        CommonTips.OpenTips(80610258)
        DataModel.moveSuccessJson = json
        if not string.nilorempty(json.ltLoc) then
          LuaMonopolyManager.lastSelectDir = DataModel.GetDirByNowAndLastId(tonumber(json.curLoc), tonumber(json.ltLoc))
        end
        if json.itemEvents and 0 < #json.itemEvents then
          local gridId = json.itemEvents[1][1]
          local itemId = json.itemEvents[1][2]
          local itemCa = PlayerData:GetFactoryData(itemId, "ItemFactory")
          if #json.itemEvents == 1 then
            DataModel.MinusBuffTrapTime(tostring(gridId))
            DataModel.itemEvents = {}
            LuaMonopolyManager.DoItemBuffById(itemId, json, ltId)
          else
            DataModel.itemEvents = {}
            table.insert(DataModel.itemEvents, json.itemEvents[1])
            table.insert(DataModel.itemEvents, json.itemEvents[#json.itemEvents])
            if itemCa and itemCa.playerItemType == DataModel.buffType.go then
              local autoPathIds = DataModel.FindPathBFS(ltId, tonumber(gridId))
              if autoPathIds then
                DataModel.autoPathIds = autoPathIds
                local gridInfo = DataModel.GetMapGridInfo(autoPathIds[1])
                if gridInfo then
                  LuaMonopolyManager.Move(Vector3(gridInfo.x, LuaMonopolyManager.roleGO.transform.position.y, gridInfo.y), 2, ltId, autoPathIds[1])
                end
              end
            end
          end
        end
      else
        LuaMonopolyManager.DoMoveFinishLogic(ltId, json)
      end
    end
  end
  
  local function cbFail(json)
    if json.rc and json.rc ~= "" then
      LuaMonopolyManager.isMoveFail = true
      LuaMonopolyManager.CheckTimeIsOverAndBack()
      DataModel.userMonopolyData.step = DataModel.beforeMoveInfo.step
      LuaMonopolyManager.RefreshRemainingNum()
      local gridInfo = DataModel.GetMapGridInfo(DataModel.beforeMoveInfo.gridId)
      if gridInfo and LuaMonopolyManager.roleGO then
        LuaMonopolyManager.roleGO.transform.localPosition = Vector3(gridInfo.x, 0, gridInfo.y)
      end
      LuaMonopolyManager.lastSelectDir = DataModel.beforeMoveInfo.moveDir
      LuaMonopolyManager.SetRoleAngles(LuaMonopolyManager.lastSelectDir)
      LuaMonopolyManager.nextGridId = DataModel.beforeMoveInfo.gridId
      LuaMonopolyManager.pathGridIds = {}
      table.insert(LuaMonopolyManager.pathGridIds, LuaMonopolyManager.nextGridId)
      LuaMonopolyManager.InitSelect()
    end
  end
  
  Net:SendProto("monopoly.move_position", cbSuccess, pathIdsStr, isTrap, cbFail)
end

function LuaMonopolyManager.DoItemBuffById(itemId, json, ltId)
  local itemCa = PlayerData:GetFactoryData(itemId, "ItemFactory")
  if not itemCa then
    return
  end
  if itemCa.playerItemType == DataModel.buffType.go then
    local autoPathIds = DataModel.FindPathBFS(ltId, tonumber(json.curLoc) or 0)
    if autoPathIds then
      DataModel.autoPathIds = autoPathIds
      local gridInfo = DataModel.GetMapGridInfo(autoPathIds[1])
      if gridInfo then
        LuaMonopolyManager.SetGridCompleteState(tostring(ltId), 0)
        LuaMonopolyManager.Move(Vector3(gridInfo.x, LuaMonopolyManager.roleGO.transform.position.y, gridInfo.y), 2, ltId, autoPathIds[1])
      end
    end
  elseif itemCa.playerItemType == DataModel.buffType.stop then
    LuaMonopolyManager.roleStatus = 0
    LuaMonopolyManager.nextGridId = ltId
    LuaMonopolyManager.DoMoveFinishLogic(ltId, json)
  elseif itemCa.playerItemType == DataModel.buffType.return_ then
    LuaMonopolyManager.MoveToGrid(json.curLoc)
  end
end

function LuaMonopolyManager.MoveToGrid(curLoc)
  local curLocId = tonumber(curLoc) or 0
  local gridInfo = DataModel.GetMapGridInfo(curLocId)
  if not gridInfo then
    return
  end
  if DataModel.userMonopolyData.loc == curLocId then
    return
  end
  if gridInfo then
    LuaMonopolyManager.roleGO.transform.localPosition = Vector3(gridInfo.x, LuaMonopolyManager.roleGO.transform.position.y, gridInfo.y)
  end
  LuaMonopolyManager.roleStatus = 0
  LuaMonopolyManager.nextGridId = curLocId
  DataModel.userMonopolyData.loc = curLocId
  LuaMonopolyManager.pathGridIds = {}
  table.insert(LuaMonopolyManager.pathGridIds, curLocId)
end

function LuaMonopolyManager.DoMoveFinishLogic(ltId, json)
  if not ltId or not json then
    return
  end
  
  local function smallBoxFunc()
    LuaMonopolyManager.smallBoxBoss = LuaMonopolyManager.smallBoxBoss or {}
    if LuaMonopolyManager.smallBoxBoss[tostring(ltId)] and LuaMonopolyManager.smallBoxBoss[tostring(ltId)].eventId and LuaMonopolyManager.GetFightNumIsEnough() then
      UIManager:Open("UI/Monopoly/UI/BoxEnemy/BoxEnemy", Json.encode({
        gridId = ltId,
        eventId = LuaMonopolyManager.smallBoxBoss[tostring(ltId)].eventId,
        difficulty = 0,
        dialogEvent = json.dialogEvent,
        isInit = false
      }))
    else
      LuaMonopolyManager.DoDialogEvent(ltId, json.dialogEvent)
    end
  end
  
  local function reqOutputFunc()
    local outputNum = LuaMonopolyManager.GetCityGridOutputNum(tostring(ltId)) or 0
    if 0 < outputNum then
      LuaMonopolyManager.ReqGetGridOutput(ltId, smallBoxFunc)
    else
      smallBoxFunc()
    end
  end
  
  if not string.nilorempty(json.buffGod) then
    DataModel.SetBuffGodInfo(json.buffGod, PlayerData:GetUserInfo().role_name, PlayerData:GetUserInfo().uid, TimeUtil:GetServerTimeStamp())
    LuaMonopolyManager.RemoveBuffGod()
    LuaMonopolyManager.RefreshPlayHeadBuffGodShow(PlayerData:GetUserInfo().uid)
    DataModel.reqOutputFunc = reqOutputFunc
    LuaMonopolyManager.OpenBuffGodGetPanel(json.buffGod)
  else
    reqOutputFunc()
  end
end

function LuaMonopolyManager.DoDialogEvent(gridId, dialogEvent)
  local eventId = -1
  local lv = DataModel.userMonopolyData.map[tostring(gridId)] and DataModel.userMonopolyData.map[tostring(gridId)].lv + 1 or 1
  if not DataModel.serverMonopolyData.map[tostring(gridId)] then
    DataModel.userMonopolyData.map[tostring(gridId)] = {com = 1, lv = 0}
  else
    eventId = DataModel.serverMonopolyData.map[tostring(gridId)].event
  end
  if string.nilorempty(dialogEvent) then
    LuaMonopolyManager.SetGridCompleteState(tostring(gridId), 1)
    LuaMonopolyManager.RefreshGridMenu()
  end
  LuaMonopolyManager.OnReach(dialogEvent, lv, eventId, gridId)
  LuaMonopolyManager.RefreshGridMenu()
end

function LuaMonopolyManager.ReqLookGridOutput()
  Net:SendProto("monopoly.grid_output", function(json)
    if json and json.interface then
      DataModel.SetInterfaceIsfull(json.isFull)
      DataModel.SetInterfaceData(json.interface)
      LuaMonopolyManager.mapGridBubbles = LuaMonopolyManager.mapGridBubbles or {}
      for gridId, v in pairs(LuaMonopolyManager.mapGridBubbles) do
        LuaMonopolyManager.RefreshAGridBubble(gridId)
      end
    end
  end, 0, function(json)
    LuaMonopolyManager.CheckTimeIsOverAndBack()
  end)
end

function LuaMonopolyManager.ReqGetGridOutput(gridId, eventDialogFunc, getCallBack)
  local outputNum = LuaMonopolyManager.GetCityGridOutputNum(tostring(gridId)) or 0
  if outputNum <= 0 then
    return
  end
  Net:SendProto("monopoly.grid_output", function(json)
    if json and string.nilorempty(json.rc) then
      DataModel.SetCityGridOutputNum(tostring(gridId), 0)
      LuaMonopolyManager.RefreshAGridBubble(gridId)
      if eventDialogFunc then
        eventDialogFunc()
      end
      LuaMonopolyManager.RefreshMoneyNum()
      DataModel.SetInterfaceIsfull(0)
      if getCallBack then
        getCallBack()
      end
    end
  end, 1, function(json)
    LuaMonopolyManager.CheckTimeIsOverAndBack()
  end)
end

function LuaMonopolyManager.RefreshDiceNum()
  if not DataModel.userMonopolyData then
    return
  end
  View.Group_Dice.Btn_Dice.Img_Num.Txt_Num:SetText(tostring(DataModel.GetUserDiceNum()))
end

function LuaMonopolyManager.GetUserDiceNum()
  return DataModel.GetUserDiceNum()
end

function LuaMonopolyManager.AddUserDiceNum(num)
  DataModel.AddUserDiceNum(num)
  LuaMonopolyManager.RefreshDiceNum()
end

function LuaMonopolyManager.SetGridCompleteState(gridId, state)
  DataModel.SetGridCompleteState(gridId, state)
end

function LuaMonopolyManager.GetGridInvestNum(gridId)
  return DataModel.GetGridInvestNum(gridId)
end

function LuaMonopolyManager.GetMaxInvestTime()
  return DataModel.GetInvestMaxTime()
end

function LuaMonopolyManager.AddGridInvestNum(gridId)
  DataModel.AddGridInvestNum(gridId)
end

function LuaMonopolyManager.GetGridInvestMoney(gridId)
  return DataModel.GetGridInvestMoney(gridId)
end

function LuaMonopolyManager.AddGridInvestMoney(gridId, money)
  DataModel.AddGridInvestMoney(gridId, money)
end

function LuaMonopolyManager.GetCityGridOutputNum(gridId)
  return DataModel.GetCityGridOutputNum(gridId)
end

function LuaMonopolyManager.GetTelecontrolDiceNum()
  return DataModel.GetTelecontrolDiceNum()
end

function LuaMonopolyManager.RefreshTelecontrolDiceNum()
  View.Group_Dice.Btn_Control.Img_Num.Txt_Num:SetText(tostring(DataModel.GetTelecontrolDiceNum()))
end

function LuaMonopolyManager.AddTelecontrolDiceNum(num)
  DataModel.AddTelecontrolDiceNum(num)
  LuaMonopolyManager.RefreshTelecontrolDiceNum()
end

function LuaMonopolyManager.RefreshMoneyNum()
  local nowNum = PlayerData:GetGoodsById(LuaMonopolyManager.investItem).num or 0
  if DataModel.lastMoneyNum then
    View.self:PlayAnimOnce("GainMoney")
    if nowNum > DataModel.lastMoneyNum then
      View.Group_Money.Img_Money.Group_GainMoneyIcon:SetActive(false)
      View.Group_Money.Img_Money.Group_GainMoneyIcon:SetActive(true)
      View.Group_GainMoney:SetActive(false)
      View.Group_GainMoney:SetActive(true)
      DataModel.PlaySound(DataModel.soundIds.getGold)
    end
  end
  View.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForSeconds(2))
    View.Group_Money.Img_Money.Group_GainMoneyIcon:SetActive(false)
    View.Group_GainMoney:SetActive(false)
  end))
  DataModel.lastMoneyNum = DataModel.lastMoneyNum or 0
  DOTweenTools.DoTextProgress(View.Group_Money.Img_Money.Txt_Num, DataModel.lastMoneyNum, nowNum, 3, nil, nil, nil, true, "f0")
  DataModel.lastMoneyNum = nowNum
  LuaMonopolyManager.RefreshMonopolyLv()
end

function LuaMonopolyManager.RefreshMonopolyLv()
  DataModel.RefreshMapGradeInfo()
  local lv = PlayerData.GetUserMonopolyLv() or 1
  View.Group_ItemHide.Group_LV.Img_BG.Txt_Num:SetText(tostring(lv))
end

function LuaMonopolyManager.RefreshGridMenu()
  local ca = PlayerData:GetFactoryData(LuaMonopolyManager.nextGridId, "MonopolyGameGridFactory")
  if not ca or not ca.isRank then
    View.Group_ItemHide.Btn_GridMenu:SetActive(false)
    return
  end
  if DataModel.GetGridCompleteState(tostring(LuaMonopolyManager.nextGridId)) == 0 then
    View.Group_ItemHide.Btn_GridMenu:SetActive(false)
    return
  end
  View.Group_ItemHide.Btn_GridMenu:SetActive(true)
end

function LuaMonopolyManager.OnGridMenuBtnClick()
  local ca = PlayerData:GetFactoryData(LuaMonopolyManager.nextGridId, "MonopolyGameGridFactory")
  if not ca then
    return
  end
  if DataModel.GetGridCompleteState(tostring(LuaMonopolyManager.nextGridId)) == 0 then
    CommonTips.OpenTips(80608982)
    return
  end
  UIManager:Open("UI/Monopoly/UI/Menu/GridMenu", Json.encode({
    gridId = LuaMonopolyManager.nextGridId,
    mapId = DataModel.userMonopolyData.monopoly_id
  }))
end

function LuaMonopolyManager.RefreshRemainingNum()
  View.Group_Dice.Txt_RemainingSteps.Txt_Num:SetText(tostring(DataModel.GetInitStep()))
end

function LuaMonopolyManager.OpenDialog(dialogId, lv, eventId, gridId)
  local dialogInfo = PlayerData:GetFactoryData(dialogId, "MonopolyEventFactory")
  if not dialogInfo then
    return
  end
  UIManager:Open("UI/DialogSelect/DialogEvent", Json.encode({
    dialogId = dialogId,
    level = lv,
    eventId = eventId,
    gridId = gridId
  }))
end

function LuaMonopolyManager.RefreshBuffGodShow()
  local needRefresh, timeStr = LuaMonopolyManager.GetBuffGodRefreshRemainTime()
  if needRefresh then
    DataModel.isInRefreshCDing = false
    LuaMonopolyManager.RefreshCDingState()
  end
  View.Btn_BuffGod.Txt_Time:SetText(timeStr)
end

function LuaMonopolyManager.GetBuffGodRefreshRemainTime()
  if DataModel.godRefreshTime == nil then
    return false, ""
  end
  local lgTimeTable = TimeUtil:GetLogicServerDayTable()
  if not lgTimeTable then
    return false, ""
  end
  local lHour = lgTimeTable.hour or 0
  local lMin = lgTimeTable.minute or 0
  local lSec = lgTimeTable.second or 0
  local totalSecondsA = DataModel.godRefreshTime.hour * 3600 + DataModel.godRefreshTime.minute * 60 + DataModel.godRefreshTime.second
  local totalSecondsNow = lHour * 3600 + lMin * 60 + lSec
  if totalSecondsA < totalSecondsNow then
    totalSecondsA = totalSecondsA + 86400
  end
  local diffSeconds = math.abs(totalSecondsA - totalSecondsNow)
  local diffHour = math.floor(diffSeconds / 3600)
  diffSeconds = diffSeconds % 3600
  local diffMin = math.floor(diffSeconds / 60)
  local diffSec = diffSeconds % 60
  local timeFor = ""
  if diffHour <= 0 then
    timeFor = string.format("%.2d:%.2d", diffMin, diffSec)
  else
    timeFor = string.format("%.2d:%.2d", diffHour, diffMin)
  end
  local needRefresh = false
  if diffHour == 0 and diffMin == 0 and diffSec == 0 then
    needRefresh = true
  end
  return needRefresh, timeFor
end

function LuaMonopolyManager.OnBuffGodClick()
  if not DataModel.buffGodInfo or not DataModel.buffGodInfo.buffId then
    CommonTips.OpenTips(80609264)
    return
  end
  local eventInfo = PlayerData:GetFactoryData(DataModel.buffGodInfo.buffId, "MonopolyEventFactory")
  if not eventInfo then
    View.Group_BuffTips:SetActive(false)
    return
  end
  View.Group_BuffTips:SetActive(true)
  View.Group_BuffTips.Txt_Name:SetText(eventInfo.name)
  if eventInfo.buffList then
    local buffDesc = ""
    for _, v in pairs(eventInfo.buffList) do
      local buffInfo = PlayerData:GetFactoryData(v.id, "HomeBuffFactory")
      if buffInfo then
        buffDesc = buffDesc .. buffInfo.desc .. "\n"
      end
    end
    View.Group_BuffTips.Txt_Des:SetText(buffDesc)
  end
  if not string.nilorempty(DataModel.buffGodInfo.belong) then
    View.Group_BuffTips.Group_Possession.Group_Yes:SetActive(true)
    local nameStr = PlayerData:GetFactoryData(80609335, "TextFactory").text
    if not string.nilorempty(nameStr) then
      View.Group_BuffTips.Group_Possession.Group_Yes.Txt_Name:SetText(string.format(nameStr, DataModel.buffGodInfo.belong))
    end
    View.Group_BuffTips.Group_Possession.Group_Not:SetActive(false)
  else
    View.Group_BuffTips.Group_Possession.Group_Yes:SetActive(false)
    View.Group_BuffTips.Group_Possession.Group_Not:SetActive(true)
  end
end

function LuaMonopolyManager.CreateBuffGod(par, scale)
  if not (par and DataModel.buffGodInfo) or not DataModel.buffGodInfo.buffId then
    return
  end
  local eventInfo = PlayerData:GetFactoryData(DataModel.buffGodInfo.buffId, "MonopolyEventFactory")
  if not eventInfo then
    return
  end
  if not LuaMonopolyManager.buffGodObj then
    LuaMonopolyManager.buffGodObj = {}
    local obj = View.self:GetRes("UI/Monopoly/UI/BuffGod", par.transform)
    if obj then
      LuaMonopolyManager.buffGodObj.obj = obj
      LuaMonopolyManager.buffGodObj.spineAni = obj.transform:Find("SpineAnimation_God"):GetComponent(typeof(CS.Seven.UISpineAnimation))
    end
  end
  if LuaMonopolyManager.buffGodObj then
    LuaMonopolyManager.buffGodObj.obj.transform:SetParent(par.transform)
    LuaMonopolyManager.buffGodObj.obj.transform.localPosition = Vector3(0, 0, 0)
    LuaMonopolyManager.buffGodObj.obj.transform.localEulerAngles = Vector3(0, 0, 0)
    scale = scale or Vector3(1, 1, 1)
    LuaMonopolyManager.buffGodObj.obj.transform.localScale = scale
    if LuaMonopolyManager.buffGodObj.spineAni then
      LuaMonopolyManager.buffGodObj.spineAni:SetData(eventInfo.buffSpineUrl, "")
      LuaMonopolyManager.buffGodObj.spineAni:SetAction(eventInfo.buffSpineAct, true, true)
    end
  end
end

function LuaMonopolyManager.RemoveBuffGod()
  if LuaMonopolyManager.buffGodObj then
    if LuaMonopolyManager.buffGodObj.obj then
      Object.Destroy(LuaMonopolyManager.buffGodObj.obj)
    end
    LuaMonopolyManager.buffGodObj = nil
  end
end

function LuaMonopolyManager.CreateBuffGodOnGridId(gridId)
  if not DataModel.buffGodInfo or not DataModel.buffGodInfo.buffId then
    return
  end
  local eventInfo = PlayerData:GetFactoryData(DataModel.buffGodInfo.buffId, "MonopolyEventFactory")
  if not eventInfo then
    return
  end
  DataModel.mapGridObjs = DataModel.mapGridObjs or {}
  local par = DataModel.mapGridObjs[gridId]
  if not par then
    return
  end
  LuaMonopolyManager.CreateBuffGod(par, Vector3(0.7, 0.7, 0.7))
end

function LuaMonopolyManager.CreateBuffGodOnPlayerTrain()
  if not (DataModel.buffGodInfo and DataModel.buffGodInfo.buffId) or not DataModel.buffGodInfo.uid then
    return
  end
  local eventInfo = PlayerData:GetFactoryData(DataModel.buffGodInfo.buffId, "MonopolyEventFactory")
  if not eventInfo then
    return
  end
  local par
  if PlayerData:GetUserInfo().uid == DataModel.buffGodInfo.uid then
    if not LuaMonopolyManager.roleGO then
      return
    end
    local rolePath = DataModel.objNamePrefix.ROLE .. "|" .. tostring(PlayerData:GetUserInfo().uid)
    par = LuaMonopolyManager.roleGO.transform:Find(rolePath .. "/BuffGodPar")
  else
    if not DataModel.otherPlayers[DataModel.buffGodInfo.uid] then
      return
    end
    par = DataModel.otherPlayers[DataModel.buffGodInfo.uid].roleGO.transform:Find("BuffGodPar").transform
  end
  if not par then
    return
  end
  LuaMonopolyManager.CreateBuffGod(par)
end

function LuaMonopolyManager.RefreshPlayHeadBuffGodShow(uid)
  local headInfo
  if PlayerData:GetUserInfo().uid == uid then
    headInfo = LuaMonopolyManager.roleHeadInfo
  elseif DataModel.otherPlayers and DataModel.otherPlayers[uid] and DataModel.otherPlayers[uid].headInfo then
    headInfo = DataModel.otherPlayers[uid].headInfo
  end
  headInfo.buffGodObj.gameObject:SetActive(false)
  if not headInfo then
    return
  end
  if not (DataModel.buffGodInfo and DataModel.buffGodInfo.buffId) or not DataModel.buffGodInfo.uid then
    return
  end
  if DataModel.buffGodInfo.uid ~= uid then
    return
  end
  LuaMonopolyManager.RefreshABuffGodShow(headInfo)
end

function LuaMonopolyManager.RefreshABuffGodShow(headInfo)
  if not headInfo then
    return
  end
  local eventInfo = PlayerData:GetFactoryData(DataModel.buffGodInfo.buffId, "MonopolyEventFactory")
  if not eventInfo then
    return
  end
  if not eventInfo.buffList then
    return
  end
  headInfo.buffGodObj.gameObject:SetActive(true)
  local ratio = 0
  for i = 1, #eventInfo.buffList do
    local buffInfo = PlayerData:GetFactoryData(eventInfo.buffList[i].id, "HomeBuffFactory")
    if buffInfo and buffInfo.buffType == "StationEarning" then
      ratio = ratio + buffInfo.param
    end
  end
  if 0 < ratio then
    headInfo.luckBuffObj.gameObject:SetActive(true)
    headInfo.unLuckBuff.gameObject:SetActive(false)
  else
    headInfo.luckBuffObj.gameObject:SetActive(false)
    headInfo.unLuckBuff.gameObject:SetActive(true)
  end
  local needRefresh, timeStr = LuaMonopolyManager.GetBuffGodRefreshRemainTime()
  if needRefresh then
    headInfo.buffGodObj.gameObject:SetActive(false)
  else
    headInfo.buffGodTime.text = timeStr
  end
end

function LuaMonopolyManager.UpdatePlayerHeadBuffGodShow()
  if not (DataModel.buffGodInfo and DataModel.buffGodInfo.buffId) or not DataModel.buffGodInfo.uid then
    return
  end
  local uid = DataModel.buffGodInfo.uid
  local headInfo
  if PlayerData:GetUserInfo().uid == uid then
    headInfo = LuaMonopolyManager.roleHeadInfo
  elseif DataModel.otherPlayers and DataModel.otherPlayers[uid] and DataModel.otherPlayers[uid].headInfo then
    headInfo = DataModel.otherPlayers[uid].headInfo
  end
  if not headInfo then
    return
  end
  LuaMonopolyManager.RefreshABuffGodShow(headInfo)
end

function LuaMonopolyManager.OpenBuffGodGetPanel(id)
  local eventInfo = PlayerData:GetFactoryData(id, "MonopolyEventFactory")
  if not eventInfo then
    return
  end
  local ratio = 0
  local buffDesc = ""
  if eventInfo.buffList then
    for _, v in pairs(eventInfo.buffList) do
      local buffInfo = PlayerData:GetFactoryData(v.id, "HomeBuffFactory")
      if buffInfo then
        buffDesc = buffDesc .. buffInfo.desc .. "\n"
        ratio = ratio + buffInfo.param
      end
    end
  end
  if 0 < ratio then
    View.Group_BuffGodTips:SetActive(true)
    View.Group_BuffGodTipsBad:SetActive(false)
    View.Group_BuffGodTips.Group_Show.Img_Bottom.Txt_Name:SetText(eventInfo.name)
    View.Group_BuffGodTips.Group_Show.Img_Bottom.Txt_Des:SetText(buffDesc)
    DataModel.PlaySound(DataModel.soundIds.getBuff)
  else
    View.Group_BuffGodTips:SetActive(false)
    View.Group_BuffGodTipsBad:SetActive(true)
    View.Group_BuffGodTipsBad.Group_Show.Img_Bottom.Txt_Name:SetText(eventInfo.name)
    View.Group_BuffGodTipsBad.Group_Show.Img_Bottom.Txt_Des:SetText(buffDesc)
    DataModel.PlaySound(DataModel.soundIds.getDeBuff)
  end
end

function LuaMonopolyManager.GetMyBuffGodId()
  if not DataModel.buffGodInfo then
    return nil
  end
  if DataModel.buffGodInfo.uid == PlayerData:GetUserInfo().uid then
    return DataModel.buffGodInfo.buffId
  end
  return nil
end

function LuaMonopolyManager.RefreshDiceDayShow()
  local hasRedDot = DataModel.GetDiceDayRedDotState()
  View.Group_ItemHide.Btn_DiceDay.Img_Red:SetActive(hasRedDot)
end

function LuaMonopolyManager.OnSubsidyChanged(index, num)
  if not DataModel.userMonopolyData then
    return
  end
  DataModel.userMonopolyData.daily_subsidy = DataModel.userMonopolyData.daily_subsidy or {}
  if not table.contains(DataModel.userMonopolyData.daily_subsidy, index) then
    table.insert(DataModel.userMonopolyData.daily_subsidy, index)
    LuaMonopolyManager.AddUserDiceNum(num)
  end
  LuaMonopolyManager.RefreshDiceDayShow()
end

function LuaMonopolyManager.DayRefreshOrderPanel()
  if TimeUtil:GetServerTimeStamp() > DataModel.nextRefreshTime then
    DataModel.InitDayRefreshTime()
    LuaMonopolyManager.ReqMonopolyMap(true)
  end
end

function LuaMonopolyManager.InitGridBubbles()
  if not DataModel.userMonopolyData then
    return
  end
  LuaMonopolyManager.mapGridBubbles = {}
  if DataModel.userMonopolyData.map then
    for gridId, _ in pairs(DataModel.userMonopolyData.map) do
      local ca = PlayerData:GetFactoryData(gridId, "MonopolyGameGridFactory")
      if ca and ca.mod == "\232\189\166\231\171\153" then
        LuaMonopolyManager.CreateAGridBubble(gridId)
      end
    end
  end
end

function LuaMonopolyManager.UpdateMapGridBubbles()
  if not DataModel.mainCamera or not LuaMonopolyManager.mapGridBubbles then
    return
  end
  for _, v in pairs(LuaMonopolyManager.mapGridBubbles) do
    DataModel.FaceToMainCamera(DataModel.mainCamera, v.obj)
  end
end

function LuaMonopolyManager.CreateAGridBubble(gridId)
  LuaMonopolyManager.mapGridBubbles = LuaMonopolyManager.mapGridBubbles or {}
  if LuaMonopolyManager.mapGridBubbles[gridId] then
    return
  end
  DataModel.mapGridObjs = DataModel.mapGridObjs or {}
  local gridObj = DataModel.mapGridObjs[gridId]
  if not gridObj then
    return
  end
  local par = gridObj.transform:Find("BubblePar(Clone)")
  if not par then
    return
  end
  local obj = View.self:GetRes("UI/Monopoly/UI/Menu/GetBubble", par.transform)
  if obj then
    obj.transform.localPosition = Vector3(0, 0, 0)
    local temp = {}
    temp.obj = obj
    temp.notFull = obj.transform:Find("NotFull")
    temp.full = obj.transform:Find("Full")
    LuaMonopolyManager.mapGridBubbles[gridId] = temp
    LuaMonopolyManager.RefreshAGridBubble(gridId)
  end
end

function LuaMonopolyManager.RefreshAGridBubble(gridId)
  LuaMonopolyManager.mapGridBubbles = LuaMonopolyManager.mapGridBubbles or {}
  local bubble = LuaMonopolyManager.mapGridBubbles[tostring(gridId)]
  if not bubble then
    return
  end
  local ca = PlayerData:GetFactoryData(gridId, "MonopolyGameGridFactory")
  if not ca or ca.mod ~= "\232\189\166\231\171\153" then
    bubble.obj.gameObject:SetActive(false)
    return
  end
  local stationGradeList = ca.stationGradeList or {}
  local outputNum = LuaMonopolyManager.GetCityGridOutputNum(tostring(gridId)) or 0
  if outputNum <= 0 then
    bubble.obj.gameObject:SetActive(false)
  else
    bubble.obj.gameObject:SetActive(true)
    local lv = LuaMonopolyManager.GetGridInvestInfo(gridId)
    local outputMax = 0
    if stationGradeList[lv] then
      outputMax = stationGradeList[lv].saveMax
    end
    local isOutputMax = outputNum >= outputMax
    if isOutputMax then
      bubble.notFull.gameObject:SetActive(false)
      bubble.full.gameObject:SetActive(true)
    else
      bubble.notFull.gameObject:SetActive(true)
      bubble.full.gameObject:SetActive(false)
    end
  end
end

function LuaMonopolyManager.GetGridInvestInfo(gridId)
  local ca = PlayerData:GetFactoryData(gridId, "MonopolyGameGridFactory")
  if not ca or ca.mod ~= "\232\189\166\231\171\153" then
    return 0, 0, 0
  end
  local coin = LuaMonopolyManager.GetGridInvestMoney(tostring(gridId)) or 0
  local tempCoin = coin
  local lv = 1
  local nextCost = 0
  local stationGradeList = ca.stationGradeList or {}
  for i = 1, #stationGradeList do
    nextCost = nextCost + stationGradeList[i].investNum
    if coin >= stationGradeList[i].investNum then
      coin = coin - stationGradeList[i].investNum
      if 0 <= coin then
        lv = lv + 1
      end
    else
      break
    end
  end
  lv = lv >= #stationGradeList and #stationGradeList or lv
  local isFull = lv >= #stationGradeList
  return lv, tempCoin, nextCost, isFull
end

function LuaMonopolyManager.CreateAOtherPlayer(roleId, paths, name, avatar)
  DataModel.otherPlayers = DataModel.otherPlayers or {}
  local otherRole = DataModel.otherPlayers[roleId]
  if not otherRole then
    local trainPar = CS.UnityEngine.GameObject.Find("MONOPOLY_OTHER_PLAYER_PAR")
    if trainPar then
      local obj = View.self:GetRes("UI/Monopoly/monopolyTrain", trainPar.transform)
      if obj then
        local roleAni
        local ainObj = obj.transform:Find("M_Monopoly_Train_WYH_01_animation")
        if ainObj then
          roleAni = ainObj:GetComponent(typeof(CS.UnityEngine.Animator))
          roleAni:Play("wait")
        end
        obj.gameObject.name = DataModel.objNamePrefix.ROLE .. "|" .. tostring(roleId)
        local headPar = obj.transform:Find("HeadPar")
        local headInfo = LuaMonopolyManager.CreateRoleHead(false, headPar, name or "", avatar)
        local t = {}
        t.roleId = roleId
        t.roleGO = obj
        t.roleAni = roleAni
        t.paths = paths
        t.curGridId = paths[1]
        t.headInfo = headInfo
        DataModel.otherPlayers[t.roleId] = t
      end
    end
  else
    otherRole.paths = paths
  end
  if 0 < #paths then
    local gridInfo = DataModel.GetMapGridInfo(tonumber(paths[1]))
    DataModel.otherPlayers[roleId].roleGO.transform.localPosition = Vector3(gridInfo.x, 0, gridInfo.y)
    LuaMonopolyManager.MoveByPaths(roleId, paths)
  end
end

function LuaMonopolyManager.CreateRoleHead(isMySelf, hearPar, name, avatar)
  local headObj = View.self:GetRes("UI/Monopoly/UI/Game/Head", hearPar.transform)
  local headInfo = {}
  if headObj then
    headObj.transform.localPosition = Vector3(0, 0, 0)
    headObj.transform.localScale = Vector3(1, 1, 1)
    headObj.transform:Find("NameBGSelf").gameObject:SetActive(isMySelf)
    headObj.transform:Find("NameBGOther").gameObject:SetActive(not isMySelf)
    headObj.transform:Find("Name"):GetComponent(typeof(CS.UnityEngine.TextMesh)).text = name
    headInfo.headObj = headObj
    headInfo.buffGodObj = headObj.transform:Find("BuffGod")
    headInfo.buffGodObj.gameObject:SetActive(false)
    headInfo.luckBuffObj = headObj.transform:Find("BuffGod/LuckBuff")
    headInfo.unLuckBuff = headObj.transform:Find("BuffGod/UnluckBuff")
    headInfo.buffGodTime = headObj.transform:Find("BuffGod/Time"):GetComponent(typeof(CS.UnityEngine.TextMesh))
    headInfo.face = headObj.transform:Find("Face"):GetComponent(typeof(CS.Seven.UISprite))
    headInfo.face.root = View.self
    if avatar then
      local photoCA = PlayerData:GetFactoryData(avatar, "ProfilePhotoFactory")
      if photoCA and not string.nilorempty(photoCA.imagePath) then
        headInfo.face:SetSprite(photoCA.imagePath)
      end
    end
  end
  return headInfo
end

function LuaMonopolyManager.MoveByPaths(playerId, pathIds)
  local otherPlayer = DataModel.otherPlayers[playerId]
  if not otherPlayer then
    return
  end
  if not pathIds or table.count(pathIds) == 0 then
    return
  end
  otherPlayer.pathIds = pathIds
  DataModel.MoveByPathId(playerId, pathIds[1], 0)
end

function LuaMonopolyManager.CreateOtherPlayer()
  if DataModel.serverMonopolyData and DataModel.serverMonopolyData.user and table.count(DataModel.serverMonopolyData.user) > 0 then
    DataModel.SetOtherPlayers({})
    for uid, v in pairs(DataModel.serverMonopolyData.user) do
      if not string.nilorempty(v.loc) then
        LuaMonopolyManager.CreateAOtherPlayer(uid, {
          tonumber(v.loc)
        }, v.role_name, v.avatar)
      end
      if not string.nilorempty(v.buffGod) then
        DataModel.SetBuffGodInfo(v.buffGod, v.role_name, uid)
      end
      LuaMonopolyManager.RefreshPlayHeadBuffGodShow(uid)
    end
  end
end

function LuaMonopolyManager.RefreshOtherUserInfo(user, serverMap, boss)
  DataModel.serverMonopolyData = DataModel.serverMonopolyData or {}
  DataModel.serverMonopolyData.user = user
  DataModel.serverMonopolyData.boss = boss
  DataModel.serverMonopolyData.map = serverMap
  if serverMap then
    DataModel.serverMonopolyData.map = serverMap
    if DataModel.userMonopolyData and DataModel.userMonopolyData.map then
      for gridId, _ in pairs(DataModel.userMonopolyData.map) do
        local eventInfo, buffGod, boss, smallBox, trap = DataModel.GetGridEventInfo(gridId)
        if buffGod then
          DataModel.SetBuffGodInfo(buffGod, nil, nil)
          LuaMonopolyManager.CreateBuffGodOnGridId(tostring(gridId))
        end
        if smallBox then
          LuaMonopolyManager.CreateSmallBoxBoss(tostring(gridId), smallBox)
        else
          LuaMonopolyManager.RemoveSmallBoxBoss(tostring(gridId))
        end
        if trap then
          DataModel.CreateMapBuffEffectObj(tostring(gridId), trap.id, trap.time)
        else
          DataModel.RemoveMapBuffEffectObj(tostring(gridId))
        end
      end
    end
  end
  if DataModel.serverMonopolyData.user and table.count(DataModel.serverMonopolyData.user) > 0 then
    for uid, v in pairs(DataModel.serverMonopolyData.user) do
      local playerInfo = DataModel.otherPlayers[uid]
      if not playerInfo then
        LuaMonopolyManager.CreateAOtherPlayer(uid, {
          tonumber(v.loc)
        }, v.role_name, v.avatar)
      elseif not string.nilorempty(v.loc) and tonumber(v.loc) ~= playerInfo.curGridId then
        LuaMonopolyManager.MoveByPaths(uid, DataModel.FindPathBFS(playerInfo.curGridId, tonumber(v.loc)))
      end
      if not string.nilorempty(v.buffGod) then
        DataModel.SetBuffGodInfo(v.buffGod, v.role_name, uid)
        LuaMonopolyManager.RemoveBuffGod()
        LuaMonopolyManager.RefreshPlayHeadBuffGodShow(uid)
      end
    end
  end
  LuaMonopolyManager.RefreshSmallBoxMainUIShow()
  LuaMonopolyManager.CreateBoxBoss()
  LuaMonopolyManager.RefreshBoxBossMainUIShow()
end

function LuaMonopolyManager.RefreshCDingState()
  if DataModel.isInRefreshCDing then
    return
  end
  DataModel.isInRefreshCDing = true
  LuaMonopolyManager.ReqGetRoomData()
  View.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForSeconds(DataModel.refreshInterval))
    DataModel.isInRefreshCDing = false
  end))
end

function LuaMonopolyManager.OnRefreshBtnClick()
  LuaMonopolyManager.FocusRoleTrain()
  if DataModel.refreshBtnInCD then
    CommonTips.OpenTips(80609571)
    return
  end
  LuaMonopolyManager.ReqGetRoomData()
  local info = PlayerData:GetFactoryData(PlayerData.GetMonopolyControlId(), "MapControlFactory")
  if info then
    DataModel.refreshBtnInCD = true
    View.self:StartC(LuaUtil.cs_generator(function()
      coroutine.yield(CS.UnityEngine.WaitForSeconds(info.refreshLimit))
      DataModel.refreshBtnInCD = false
    end))
  end
end

function LuaMonopolyManager.ReqGetRoomData()
  Net:SendProto("monopoly.monopoly_room", function(json)
    if json and json.server_monopoly then
      LuaMonopolyManager.RefreshOtherUserInfo(json.server_monopoly.user, json.server_monopoly.map, json.boss)
      DataModel.userMonopolyData = DataModel.userMonopolyData or {}
      DataModel.userMonopolyData.effect_items = json.user_monopoly.effect_items
      LuaMonopolyManager.RefreshMainUIBuffList()
    end
  end, function(json)
    LuaMonopolyManager.CheckTimeIsOverAndBack()
  end)
end

function LuaMonopolyManager.CreateBoxBoss()
  local bossInfo = DataModel.GetBoxBossServerInfo()
  if not bossInfo or not bossInfo.bossId then
    return
  end
  local par = CS.UnityEngine.GameObject.Find("MONOPOLY_BOX_BOSS_PAR")
  if not par then
    return
  end
  LuaMonopolyManager.boxBoss = LuaMonopolyManager.boxBoss or {}
  if LuaMonopolyManager.boxBoss.obj == nil then
    LuaMonopolyManager.boxBoss.obj = View.self:GetRes("Monopoly/Environment/Model/Prefab/M_Monopoly_box_02", par.transform)
  end
  if LuaMonopolyManager.boxBoss.obj then
    LuaMonopolyManager.boxBoss.obj.gameObject.name = "MONOPOLY_BOX_BOSS|" .. tostring(bossInfo.bossId)
    LuaMonopolyManager.boxBoss.obj.transform:SetParent(par.transform)
    LuaMonopolyManager.boxBoss.obj.transform.localPosition = Vector3(0, 0, 0)
    LuaMonopolyManager.boxBoss.obj.transform.localEulerAngles = Vector3(0, 0, 0)
    LuaMonopolyManager.bossLevel = bossInfo.bossId
  end
end

function LuaMonopolyManager.OnClickBoxBoss(bossLevel, isHelpBoss)
  if not (not string.nilorempty(bossLevel) and DataModel.userMonopolyData) or not LuaMonopolyManager.boxBoss then
    return
  end
  UIManager:Open("UI/Monopoly/UI/Boss/BossMenu", Json.encode({
    bossLevel = bossLevel,
    monopolyId = DataModel.userMonopolyData.monopoly_id,
    isHelpBoss = isHelpBoss
  }))
end

function LuaMonopolyManager.SetBoxBossFightState(isFighting, isHelpBoss)
  DataModel.isBoxBossFighting = isFighting
  DataModel.isHelpBoss = isHelpBoss
end

function LuaMonopolyManager.GetBoxBossFightState()
  return DataModel.isBoxBossFighting, DataModel.isHelpBoss
end

function LuaMonopolyManager.RefreshBoxBossMainUIShow()
  local bossInfo = DataModel.GetBoxBossServerInfo()
  if not bossInfo or not bossInfo.bossId then
    return
  end
  if bossInfo.hp > 0 then
    View.Group_ItemHide.Group_Target.Btn_Health.Group_Dead:SetActive(false)
    View.Group_ItemHide.Group_Target.Btn_Health.Group_Alive:SetActive(true)
    local maxHp = DataModel.GetBossMaxHp() or 0
    local ratio = math.ceil(bossInfo.hp / maxHp * 100)
    View.Group_ItemHide.Group_Target.Btn_Health.Group_Alive.Img_HP.Txt_Alive:SetText(tostring(ratio))
    View.Group_ItemHide.Group_Target.Btn_Health.Img_RedPoint:SetActive(0 < bossInfo.time)
  else
    View.Group_ItemHide.Group_Target.Btn_Health.Group_Dead:SetActive(true)
    View.Group_ItemHide.Group_Target.Btn_Health.Group_Alive:SetActive(false)
    View.Group_ItemHide.Group_Target.Btn_Health.Group_Alive.Img_HP.Txt_Alive:SetText(false)
    local isRecv = false
    if DataModel.userMonopolyData and DataModel.userMonopolyData.boss_recv and 0 < table.count(DataModel.userMonopolyData.boss_recv) then
      isRecv = true
    end
    View.Group_ItemHide.Group_Target.Btn_Health.Img_RedPoint:SetActive(not isRecv)
  end
end

function LuaMonopolyManager.CreateSmallBoxBoss(gridId, eventId)
  LuaMonopolyManager.smallBoxBoss = LuaMonopolyManager.smallBoxBoss or {}
  if LuaMonopolyManager.smallBoxBoss[gridId] then
    return
  end
  DataModel.mapGridObjs = DataModel.mapGridObjs or {}
  local par = DataModel.mapGridObjs[gridId]
  if not par then
    return
  end
  local eventCa = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
  if not eventCa then
    return
  end
  local t = {}
  t.obj = View.self:GetRes(eventCa.threeDPrefab, par.transform)
  t.obj.transform:SetParent(par.transform)
  t.obj.transform.localPosition = Vector3(0, 0, 0)
  t.obj.transform.localEulerAngles = Vector3(0, -90, 0)
  t.gridId = gridId
  t.eventId = eventId
  LuaMonopolyManager.smallBoxBoss[gridId] = t
end

function LuaMonopolyManager.RemoveSmallBoxBoss(gridId)
  LuaMonopolyManager.smallBoxBoss = LuaMonopolyManager.smallBoxBoss or {}
  if not LuaMonopolyManager.smallBoxBoss[gridId] then
    return
  end
  if LuaMonopolyManager.smallBoxBoss[gridId].obj then
    Object.Destroy(LuaMonopolyManager.smallBoxBoss[gridId].obj)
  end
  LuaMonopolyManager.smallBoxBoss[gridId] = nil
end

function LuaMonopolyManager.GetFightNumIsEnough()
  return DataModel.GetFightNumIsEnough()
end

function LuaMonopolyManager.SetFightNumIsMax()
  DataModel.SetFightNumIsMax()
end

function LuaMonopolyManager.RefreshSmallBoxMainUIShow()
  LuaMonopolyManager.smallBoxBoss = LuaMonopolyManager.smallBoxBoss or {}
  local exitsCount = table.count(LuaMonopolyManager.smallBoxBoss)
  local limitCount = DataModel.GetBoxEnemyLimitExistCount()
  View.Group_ItemHide.Group_Target.Group_Num.Img_AliveNum.Txt_Alive:SetText(tostring(exitsCount))
  View.Group_ItemHide.Group_Target.Group_Num.Img_AliveNum.Txt_Max:SetText(tostring(limitCount))
end

function LuaMonopolyManager.MinusBuffTimeByTime(typeStr)
  local needRefresh = DataModel.MinusABuffTime(typeStr)
  if needRefresh then
    LuaMonopolyManager.RefreshMainUIBuffList()
  end
end

function LuaMonopolyManager.OnItemBackpackBtnClick()
  DataModel.PlaySound(DataModel.soundIds.uiOpen)
  LuaMonopolyManager.RefreshItemBackTestShow()
  View.self:PlayAnimOnce("ItemIn", function()
  end)
end

function LuaMonopolyManager.RefreshItemBackpack()
  View.Group_ItemBackpack:SetActive(true)
  View.Group_ItemBackpack.Group_ChooseCharacter:SetActive(false)
  DataModel.curSelectItemIndex = 0
  DataModel.curSelectItemId = 0
  if not DataModel.userMonopolyData then
    return
  end
  View.Group_ItemBackpack.Img_Count.Txt_Present:SetText(tostring(DataModel.GetItemUseRemainTime()))
  View.Group_ItemBackpack.Img_Count.Txt_Max:SetText(tostring(DataModel.GetItemUseLimitTime()))
  local list = DataModel.GetBackItemsList()
  if not list then
    return
  end
  if #list <= 5 then
    View.Group_ItemBackpack.NewScrollGrid_BuffList.grid.self.gameObject:SetActive(false)
    View.Group_ItemBackpack.StaticGrid_BuffList.grid.self.gameObject:SetActive(true)
    View.Group_ItemBackpack.StaticGrid_BuffList.grid.self:SetDataCount(#list)
    View.Group_ItemBackpack.StaticGrid_BuffList.grid.self:RefreshAllElement()
  else
    View.Group_ItemBackpack.StaticGrid_BuffList.grid.self.gameObject:SetActive(false)
    View.Group_ItemBackpack.NewScrollGrid_BuffList.grid.self.gameObject:SetActive(true)
    View.Group_ItemBackpack.NewScrollGrid_BuffList.grid.self:SetDataCount(#list)
    View.Group_ItemBackpack.NewScrollGrid_BuffList.grid.self:RefreshAllElement()
  end
end

function LuaMonopolyManager.OnBackpackUseBtnClick()
  if DataModel.GetItemUseRemainTime() <= 0 then
    CommonTips.OpenTips(80609568)
    return
  end
  local list = DataModel.GetBackItemsList()
  if not list then
    return
  end
  local info = list[DataModel.curSelectItemIndex]
  if not info then
    return
  end
  if 0 >= info.num then
    CommonTips.OpenTips(80600488)
    return
  end
  local ca = PlayerData:GetFactoryData(info.id, "ItemFactory")
  if not ca then
    return
  end
  DataModel.curSelectItemId = info.id
  if ca.useRange == DataModel.useRange.oneSelf then
    LuaMonopolyManager.OnPlayerUseBtnClick(PlayerData:GetUserInfo().uid)
  else
    LuaMonopolyManager.ShowSelectPlayerPanel()
  end
end

function LuaMonopolyManager.ShowSelectPlayerPanel()
  View.Group_ItemBackpack:SetActive(true)
  View.Group_ItemBackpack.Group_ChooseCharacter:SetActive(true)
  local playerList = DataModel.GetPlayerList()
  if not playerList then
    return
  end
  if 0 < #playerList then
    View.Group_ItemBackpack.Group_ChooseCharacter.StaticGrid_Character.grid.self.gameObject:SetActive(true)
    View.Group_ItemBackpack.Group_ChooseCharacter.StaticGrid_Character.grid.self:SetDataCount(#playerList)
    View.Group_ItemBackpack.Group_ChooseCharacter.StaticGrid_Character.grid.self:RefreshAllElement()
  else
    View.Group_ItemBackpack.Group_ChooseCharacter.StaticGrid_Character.grid.self.gameObject:SetActive(false)
  end
end

function LuaMonopolyManager.OnPlayerUseBtnClick(uid, bossId)
  if string.nilorempty(uid) and string.nilorempty(bossId) then
    return
  end
  
  local function cbSuccess(json)
    if string.nilorempty(json.rc) then
      local ca = PlayerData:GetFactoryData(DataModel.curSelectItemId, "ItemFactory")
      if ca then
        CommonTips.OpenTips(string.format(GetText(80609558), ca.name))
        if ca.useRange == DataModel.useRange.grid then
          DataModel.CreateMapBuffEffectObj(tostring(DataModel.userMonopolyData.loc), DataModel.curSelectItemId, ca.itemValidNum)
        end
      end
      if json.user_monopoly then
        DataModel.userMonopolyData.effect_items = json.user_monopoly.effect_items
      end
      if json.grid_add_info then
        for gridId, v in pairs(json.grid_add_info) do
          LuaMonopolyManager.CreateSmallBoxBoss(tostring(gridId), v.boxGw)
          LuaMonopolyManager.RefreshSmallBoxMainUIShow()
        end
      end
      DataModel.AddItemUseTime()
      DataModel.EditBackItemNum(DataModel.curSelectItemId, -1)
      LuaMonopolyManager.RefreshItemBackTestShow()
      LuaMonopolyManager.RefreshMainUIBuffList()
      DataModel.curSelectItemId = 0
    end
  end
  
  local function cbFail()
    LuaMonopolyManager.CheckTimeIsOverAndBack()
    DataModel.curSelectItemId = 0
  end
  
  Net:SendProto("monopoly.use_items", cbSuccess, 1, DataModel.curSelectItemId, tostring(uid), bossId, cbFail)
end

function LuaMonopolyManager.RefreshItemBackTestShow()
  local list = DataModel.GetBackItemsList()
  if not list then
    return
  end
  View.Group_ItemTest:SetActive(true)
  View.Group_ItemHide:SetActive(false)
  View.Group_Money:SetActive(false)
  View.Group_Dice:SetActive(false)
  View.Group_CommonTopLeft:SetActive(false)
  View.Group_ItemTest.Img_Count.Txt_Present:SetText(tostring(DataModel.GetItemUseRemainTime()))
  View.Group_ItemTest.Img_Count.Txt_Max:SetText(tostring(DataModel.GetItemUseLimitTime()))
  View.Group_ItemTest.Btn_TestClose.Img_Num.Txt_Own:SetText(tostring(DataModel.GetAllItemsCount()))
  View.Group_ItemTest.Btn_TestClose.Img_Num.Txt_Max:SetText(tostring(DataModel.GetItemHasLimitCount()))
  View.Group_ItemTest.NewScrollGrid_BuffList.grid.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
    View.Group_ItemTest.NewScrollGrid_BuffList.grid.self:SetDataCount(#list)
    View.Group_ItemTest.NewScrollGrid_BuffList.grid.self:RefreshAllElement()
  end))
end

function LuaMonopolyManager.OnItemLongPressed(index)
  DataModel.curSelectItemIndex = index
  LuaMonopolyManager.OnItemDragBegin()
end

function LuaMonopolyManager.OnItemDragBegin()
  local list = DataModel.GetBackItemsList()
  if not list then
    return
  end
  local info = list[DataModel.curSelectItemIndex]
  if not info then
    return
  end
  if info.num <= 0 then
    CommonTips.OpenTips(80600488)
    return
  end
  local ca = PlayerData:GetFactoryData(info.id, "ItemFactory")
  if not ca then
    return
  end
  DataModel.isDrag = true
  View.Group_ItemTest.Group_Drag.self:SetLocalPosition(DataModel.GetMousePos())
  View.Group_ItemTest.Group_Drag:SetActive(true)
  View.Group_ItemTest.NewScrollGrid_BuffList.self:SetEnable(false)
  DataModel.curSelectItemId = info.id
  View.Group_ItemTest.Group_Drag.Img_Drag:SetSprite(ca.iconPath)
  DataModel.ShowDragBuffInfo()
end

function LuaMonopolyManager.OnItemDragging()
  if not DataModel.isDrag then
    return
  end
  View.Group_ItemTest.Group_Drag.self:SetLocalPosition(DataModel.GetMousePos())
  local obj = PlotManager:GetRayHitObj(Input.mousePosition)
  if obj ~= nil then
    local pathList = string.split(obj.name, "|")
    if not pathList or #pathList < 2 then
      return
    end
    local prefix = pathList[1]
    local id = pathList[2]
    local isValid = DataModel.CheckItemUseRangeIsValid(DataModel.curSelectItemId, id, prefix)
    if not isValid then
      return
    end
    DataModel.ShowPlayerSelectEffect(obj, id)
    LuaMonopolyManager.CurDragSelectObj = obj
  else
    DataModel.ResetPlayerSelectEffect(LuaMonopolyManager.CurDragSelectObj)
  end
end

function LuaMonopolyManager.OnItemDragEnd()
  if not DataModel.isDrag then
    return
  end
  if DataModel.curSelectItemId == nil or DataModel.curSelectItemId == 0 then
    return
  end
  DataModel.isDrag = false
  DataModel.ResetPlayerSelectEffect(LuaMonopolyManager.CurDragSelectObj)
  View.Group_ItemTest.Group_Drag:SetActive(false)
  View.Group_ItemTest.NewScrollGrid_BuffList.self:SetEnable(true)
  local obj = PlotManager:GetRayHitObj(Input.mousePosition)
  if obj ~= nil then
    LuaMonopolyManager.DoItemUseByObj(obj)
  end
  LuaMonopolyManager.HideDragBuffInfo()
end

function LuaMonopolyManager.HideDragBuffInfo()
  View.Group_ItemTest.Group_Drag.Group_BuffInfo:SetActive(false)
end

function LuaMonopolyManager.DoItemUseByObj(obj)
  if not obj then
    return
  end
  if DataModel.GetItemUseRemainTime() <= 0 then
    CommonTips.OpenTips(80609568)
    return
  end
  local ca = PlayerData:GetFactoryData(DataModel.curSelectItemId, "ItemFactory")
  if not ca then
    return
  end
  local pathList = string.split(obj.name, "|")
  if not pathList or #pathList < 2 then
    return
  end
  local prefix = pathList[1]
  local id = pathList[2]
  local isValid = DataModel.CheckItemUseRangeIsValid(DataModel.curSelectItemId, id, prefix)
  if not isValid then
    CommonTips.OpenTips(80609876)
    return
  end
  if ca.playerItemType == DataModel.buffType.refreshBox then
    LuaMonopolyManager.smallBoxBoss = LuaMonopolyManager.smallBoxBoss or {}
    local exitsCount = table.count(LuaMonopolyManager.smallBoxBoss)
    local limitCount = DataModel.GetBoxEnemyLimitExistCount() or 0
    local addNum = ca.playerItemValue or 0
    if limitCount < addNum + exitsCount then
      CommonTips.OpenTips(80610266)
      return
    end
  end
  if prefix == DataModel.objNamePrefix.ROLE then
    LuaMonopolyManager.OnPlayerUseBtnClick(id)
  elseif prefix == DataModel.objNamePrefix.GRID then
    LuaMonopolyManager.OnPlayerUseBtnClick(id)
  elseif prefix == DataModel.objNamePrefix.BOSS then
    LuaMonopolyManager.OnPlayerUseBtnClick(nil, id)
  end
end

function LuaMonopolyManager.ResetDragObjState()
  if LuaMonopolyManager.CurDragSelectObj then
    LuaMonopolyManager.CurDragSelectObj.transform.localScale = Vector3(1, 1, 1)
  end
end

function LuaMonopolyManager.RefreshMainUIBuffList()
  local list = DataModel.GetBuffList() or {}
  local count = 20 < #list and 20 or #list
  if 0 < count then
    View.Group_ItemHide.StaticGrid_BuffBar.grid.self.gameObject:SetActive(true)
    View.Group_ItemHide.StaticGrid_BuffBar.grid.self:SetDataCount(count)
    View.Group_ItemHide.StaticGrid_BuffBar.grid.self:RefreshAllElement()
  else
    View.Group_ItemHide.StaticGrid_BuffBar.grid.self.gameObject:SetActive(false)
  end
end

function LuaMonopolyManager.RefreshBuffListShow()
  View.Group_Buff:SetActive(true)
  DataModel.PlaySound(DataModel.soundIds.uiOpen)
  local list = DataModel.GetBuffList() or {}
  if 0 < #list then
    if #list <= 5 then
      View.Group_Buff.StaticGrid_BuffList.grid.self.gameObject:SetActive(true)
      View.Group_Buff.NewScrollGrid_BuffList.grid.self.gameObject:SetActive(false)
      View.Group_Buff.StaticGrid_BuffList.grid.self:SetDataCount(#list)
      View.Group_Buff.StaticGrid_BuffList.grid.self:RefreshAllElement()
    else
      View.Group_Buff.StaticGrid_BuffList.grid.self.gameObject:SetActive(false)
      View.Group_Buff.NewScrollGrid_BuffList.grid.self.gameObject:SetActive(true)
      View.Group_Buff.NewScrollGrid_BuffList.grid.self:SetDataCount(#list)
      View.Group_Buff.NewScrollGrid_BuffList.grid.self:RefreshAllElement()
    end
  else
    View.Group_Buff:SetActive(false)
  end
end

return LuaMonopolyManager
