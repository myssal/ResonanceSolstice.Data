local DataModel = require("UIKabaneriMain/UIKabaneriMainDataModel")
local View = require("UIKabaneriMain/UIKabaneriMainView")
local Effect = require("UIKabaneriMain/UIKabaneriMainUIEffect")
local tempFollowAtkTime = 0
local followAtkTime, followExitTime
local bossTakeDamage = 0
local lastShowSpeed = 0
local targetPlayerDir = 0
local lastSelectBuffGroup, firstTrainSpline
local showSelectRoadDistance = 100
local curStaticMonster, curStaticMonHp
local gunHitEffects = {}
local baseMonsterHitTrain = {}
local Controller = {isInit = false}

local function ClearGunHitEffect()
  if gunHitEffects then
    for k, v in ipairs(gunHitEffects) do
      if v then
        v:SetParent(nil)
      end
    end
  end
  gunHitEffects = {}
end

local function AimStaticMonster()
  if not KBTrainManager.train.gun.AIPart.DOAttack or KBTrainManager.train.gun.curAmmo + KBTrainManager.train.gun.tempAmmo <= 0 then
    Controller.StopAtkStaticMons()
    return
  end
  local target = KBTrainManager.train.gun.target
  if target == nil or target.model == nil or 0 >= target.attrPart.curHp or not CS.Util.CheckOutOfDistance2D(target.model.transform.position, KBTrainManager.train.firstTrain.position, 3) then
    Controller.StopAtkStaticMons()
    return
  end
  local pos = target:GetTarget()
  if pos == nil then
    Controller.StopAtkStaticMons()
    return
  end
  local rotY = CS.UnityEngine.Quaternion.LookRotation(pos - KBTrainManager.train.gun.YNode.position)
  local rotX = CS.UnityEngine.Quaternion.LookRotation(pos - KBTrainManager.train.gun.XNode.position)
  KBTrainManager.train.gun:SetEular(rotX.eulerAngles.x, rotY.eulerAngles.y)
end

local RoadID = {
  [2] = {
    97100006,
    97100014,
    97100015,
    97100016,
    97100004,
    97100013,
    97100005,
    97100012
  },
  [3] = {
    97100007,
    97100010,
    97100011
  }
}

function Controller.InitData()
  DataModel.Reset()
  Controller.InitTrainDetailShow(false)
  Controller.SetTrainDetailAttr()
end

function Controller.ResetUI()
  View.Group_Common.Group_MB.Group_Buff.Btn_Close.Img_BuffDesc:SetActive(false)
  View.Group_Common.Img_Fixcircle.Txt_ShieldNum:SetText(0)
  View.Group_Common.Img_Fixcircle.Txt_ShieldNum:SetActive(false)
  View.Group_Common.Group_MainInfo.Group_Time.Txt_TimeNum:SetText("00:00")
  View.Group_Common.Group_MainInfo.Group_Point.Txt_Score:SetText(DataModel.score)
  Controller:RefreshTimeLimitBuff()
end

function Controller.Init()
  Controller.SetTrainProperty(EnumDefine.KabaneriEnum.HpMax, PlayerData.GetCoachMaxDurability())
  Controller.SetTrainProperty(EnumDefine.KabaneriEnum.CurHP, PlayerData:GetHomeInfo().readiness.repair.current_durable)
  Controller.ResetUI()
  KBTrainManager.train._viewFieldBase = 60
end

function Controller.InitShootState()
  if KBTrainManager.train.gun then
    View.Group_Common.Slider_Shoot:SetActive(true)
    View.Group_Common.Slider_Shoot.Img_On:SetActive(true)
    KBTrainManager.train.gun.AIPart.DOAttack = true
    View.Group_Common.Slider_Shoot:SetSliderValue(1)
  else
    View.Group_Common.Slider_Shoot:SetActive(false)
  end
end

function Controller.DestroyFactory()
  local fac = CBus:GetFactory("KabaneriMapGridFactory")
  if fac then
    fac.changeSceneOperation = CS.Enum_System.OperationType.Destroy
  end
  fac = CBus:GetFactory("TrainBattleBulletFactory")
  if fac then
    fac.changeSceneOperation = CS.Enum_System.OperationType.Destroy
  end
  fac = CBus:GetFactory("TrainBattleSkillFactory")
  if fac then
    fac.changeSceneOperation = CS.Enum_System.OperationType.Destroy
  end
  fac = CBus:GetFactory("TrainBattleUnitFactory")
  if fac then
    fac.changeSceneOperation = CS.Enum_System.OperationType.Destroy
  end
  fac = CBus:GetFactory("TrainBattleWeaponFactory")
  if fac then
    fac.changeSceneOperation = CS.Enum_System.OperationType.Destroy
  end
  fac = CBus:GetFactory("KBEffectFactory")
  if fac then
    fac.changeSceneOperation = CS.Enum_System.OperationType.Destroy
  end
  fac = CBus:GetFactory("KabaneriEventFactory")
  if fac then
    fac.changeSceneOperation = CS.Enum_System.OperationType.Destroy
  end
  fac = CBus:GetFactory("KabaneriBuffFactory")
  if fac then
    fac.changeSceneOperation = CS.Enum_System.OperationType.Destroy
  end
end

function Controller.InitMap(id)
  View.Group_Common.Group_Gear.Img_Gear.gameObject.transform.localRotation = CS.UnityEngine.Quaternion.identity
  View.Group_Common.Group_Gear.Btn_L.Group_Off:SetActive(true)
  View.Group_Common.Group_Gear.Btn_L.Group_On:SetActive(false)
  View.Group_Common.Group_Gear.Btn_M.Group_Off:SetActive(false)
  View.Group_Common.Group_Gear.Btn_M.Group_On:SetActive(true)
  View.Group_Common.Group_Gear.Btn_R.Group_Off:SetActive(true)
  View.Group_Common.Group_Gear.Btn_R.Group_On:SetActive(false)
  View.Group_ForkRoadWarn.Group_Buff.Group_Buff1.Img_Select:SetActive(false)
  View.Group_ForkRoadWarn.Group_Buff.Group_Buff2.Img_Select:SetActive(false)
  View.Group_ForkRoadWarn.Group_Buff.Group_Buff3.Img_Select:SetActive(false)
  View.Group_ForkRoadWarn:SetActive(false)
  View.Group_ForkRoadWarn.self:SetAlpha(1)
  Controller.DestroyFactory()
  KBEnvirManager = CBus:GetManager(CS.ManagerName.KBEnvirManager, true)
  KBEnvirManager:SetCamera("FreeCamera/Main_Camera")
  TrainBattleUnitManager = CBus:GetManager(CS.ManagerName.TrainBattleUnitManager, true)
  TrainBattleUnitManager.createUnitRangeX = DataModel.config.createUnitRangeX
  TrainBattleUnitManager.createUnitRangeY = DataModel.config.createUnitRangeY
  TrainBattleUnitManager.sideRandom = DataModel.config.sideRandom
  DataModel.mapCA = PlayerData:GetFactoryData(id, "KabaneriMapFactory")
  KBEnvirManager:LoadEnvir(DataModel.mapCA.weatherPool[math.random(1, table.count(DataModel.mapCA.weatherPool))].id)
  DataModel.gameTime = 0
  DataModel.mapType = DataModel.mapCA.mapType
  if DataModel.mapType == "LimitTime" then
    DataModel.gameLimit = DataModel.mapCA.gameTime
    View.Group_Common.Group_MainInfo.Group_Time.Txt_TimeNum:SetActive(true)
  else
    DataModel.gameLimit = -1
    View.Group_Common.Group_MainInfo.Group_Time.Txt_TimeNum:SetActive(false)
  end
  DataModel.isGameStart = true
  DataModel.FixedTime = Time.fixedUnscaledTime
  Controller.InitEvents(DataModel.mapCA.luaEventList)
  DataModel.InitBaseEnemy(DataModel.mapCA.monsterGenertor)
  KBEffectManager = CBus:GetManager(CS.ManagerName.KBEffectManager, true)
  KBEffectManager:Preload(72700001, 500)
  TrainBattleUnitManager = CBus:GetManager(CS.ManagerName.TrainBattleUnitManager, true)
  TrainBattleUnitManager:Start()
  KBTrainManager = CBus:GetManager(CS.ManagerName.KBTrainManager, true)
  ParticleManager = CBus:GetManager(CS.ManagerName.ParticleManager, true)
  KBTrainManager:InitBossStatus(View.self.gameObject.transform:Find("BossStatus"))
  Controller.ShowBossUI(false)
  local train1st = PlayerData.ServerData.user_home_info.coach[1].skin
  local train2rd = PlayerData.ServerData.user_home_info.coach[2].skin
  local weaponid = PlayerData.GetWeapon()
  local weaponUnitID = 0
  if weaponid ~= nil then
    local weaponCA = PlayerData:GetFactoryData(weaponid.id, "HomeWeaponFactory")
    weaponUnitID = weaponCA.TbUnit
  end
  KBTrainManager.CameraCtrl.transform:GetChild(0).gameObject:SetActive(true)
  KBTrainManager:InitTrain({train1st, train2rd}, weaponUnitID, tonumber(PlayerData.GetStrike().id))
  KBTrainManager.CameraCtrl.transform.localRotation = CS.UnityEngine.Quaternion.Euler(167, 180, 180)
  DataModel.armor = DataModel.GetTrainArmor()
  DataModel.GunAtk = TrainWeaponTag.GetWeaponTagAttributes(EnumDefine.TrainWeaponTagEnum.TrainWeaponAtk)[2]
  View.Txt_Debug:SetText("atk:" .. DataModel.drillAtk .. "|armor:" .. DataModel.armor)
  TrainEffectHelper:LoadEffect(1, TrainEffectHelper.Enum_TrainEffectType.Rune, true)
  Controller.InitBullet()
  Controller.InitShootState()
  Controller.RefreshFuel()
  KBTrainManager:InitStartMap(id)
  local nextG = KBTrainManager.map:GetMapGrid(KBTrainManager.map.GridIndex + 1)
  if nextG and nextG.playerSelection.Count == 1 then
    nextG.finalSelection = nextG.playerSelection[0]
  else
    nextG.finalSelection = CS.KBTrainManager.KBPlayerSelectDir.None
  end
  Controller.RefreshData()
  Controller.Preload()
  KBTrainManager.map:Preload(DataModel.config.perLoadMonsterPointCount, DataModel.config.firstPointLoadMonster)
  local trainCAID = KBTrainManager.train.train[0].ca.id
  DataModel.trainCA = PlayerData:GetFactoryData(trainCAID, "TrainBattleUnitFactory")
  curStaticMonHp = View.Group_StaticMonsHp.self.transform:GetComponent(typeof(CS.TBHPBar))
  showSelectRoadDistance = DataModel.config.choiceBuffval or 100
end

function Controller.ReStart()
  Controller.InitData()
  Controller.RefreshData()
  Controller.ClearData()
  TrainBattleUnitManager:ReStart()
  KBEffectManager:RecycleAll()
  KBTrainManager:ReStart()
  TrainEffectHelper:DisposeSingleEffects(11106473)
  KBEnvirManager:LoadEnvir(DataModel.mapCA.weatherPool[math.random(1, table.count(DataModel.mapCA.weatherPool))].id)
  DataModel.mapType = DataModel.mapCA.mapType
  if DataModel.mapType == "LimitTime" then
    DataModel.gameLimit = DataModel.mapCA.gameTime
    View.Group_Common.Group_MainInfo.Group_Time.Txt_TimeNum:SetActive(true)
  else
    DataModel.gameLimit = -1
    View.Group_Common.Group_MainInfo.Group_Time.Txt_TimeNum:SetActive(false)
  end
  Controller.Init()
  View.Group_Common.Group_MainInfo.Group_Time.Txt_TimeNum:SetText("00:00")
  View.Group_Common.Group_MainInfo.Group_Point.Txt_Score:SetText(DataModel.score)
  View.Group_Over:SetActive(false)
  DataModel.isGameStart = true
  TrainBattleUnitManager:RecycleFollowMonster()
  Controller.InitEvents(DataModel.mapCA.luaEventList)
  Controller.InitShootState()
  local TimerHelper = require("Common/Timer/TimerHelper")
  TimerHelper.Start("Delay", 1, function()
    KBTrainManager:SetTrainPos()
    KBTrainManager:StartGame()
    KBTrainManager.train:StartMove(PlayerData.GetTrainSpeed())
    KBTrainManager.train:SetSpeed(2.4)
    KBTrainManager.map:Preload(DataModel.config.perLoadMonsterPointCount, DataModel.config.firstPointLoadMonster)
    DataModel.isGameStart = true
    TimerHelper.Stop("Delay")
  end)
end

function Controller.InitBullet()
  if KBTrainManager.train.gun then
    local gunCA = KBTrainManager.train.gun.ca
    local realAmmo = 0
    for i = 0, gunCA.UseBullets.Count - 1 do
      local data = gunCA.UseBullets[i]
      realAmmo = realAmmo + PlayerData:GetGoodsById(data.goods.id).num * data.rate
    end
    KBTrainManager.train.gun.curAmmo = realAmmo
    KBTrainManager.train.gun.tempAmmo = 0
    Controller.RefreshAmmo(realAmmo, 0)
    if realAmmo == 0 then
      Controller.SetNoAmmoShow(true, true)
    else
      Controller.SetNoAmmoShow(false, true)
    end
  else
    Controller.RefreshAmmo(0, 0)
    Controller.SetNoAmmoShow(false, true)
  end
end

function Controller.InitTrainDetailShow(state)
  if DataModel.isShowTrainDetailAttr == state then
    return
  end
  DataModel.isShowTrainDetailAttr = state
  View.Group_Common.Group_TrainOverview.Btn_CloseOverview:SetActive(state)
  View.Group_Common.Group_TrainOverview.Group_Overview:SetActive(state)
end

function Controller.Pause(state)
  View.Group_Common.Group_Pause:SetActive(state)
  if state then
    View.self:PlayAnimOnce("KabaneriMain")
  end
  KBTrainManager:Pause(state)
  DataModel.isPause = state
end

function Controller.CostBullet()
  if KBTrainManager.train.gun then
    local gunCA = KBTrainManager.train.gun.ca
    local realAmmo = 0
    local rate = 1
    for i = 0, gunCA.UseBullets.Count - 1 do
      local data = gunCA.UseBullets[i]
      rate = data.rate
      realAmmo = realAmmo + PlayerData:GetGoodsById(data.goods).num * rate
    end
    local cost = math.floor(math.max(0, realAmmo - KBTrainManager.train.gun.curAmmo) / rate)
    if 0 < cost then
    end
  end
end

function Controller.Preload()
  local monsters = {}
  local len = table.count(DataModel.mapCA.monsterGenertor)
  for i = 1, len do
    if monsters[DataModel.mapCA.monsterGenertor[i].monsID] == nil then
      monsters[DataModel.mapCA.monsterGenertor[i].monsID] = DataModel.mapCA.monsterGenertor[i].endTime
    end
    local endTime = math.min(DataModel.mapCA.monsterGenertor[i].endTime, DataModel.gameTime)
    if endTime > monsters[DataModel.mapCA.monsterGenertor[i].monsID] then
      monsters[DataModel.mapCA.monsterGenertor[i].monsID.id] = endTime
    end
  end
  local loadMaxPointCount = DataModel.config.perLoadMonsterPointCount + 2
  for i, v in pairs(monsters) do
    local maxMonsCount = DataModel.mapCA.baseMonsterNum * loadMaxPointCount + 200
    TrainBattleUnitManager:SetPreload(i, maxMonsCount)
  end
  TrainBattleUnitManager:PreloadEffect(50)
end

function Controller.SetGameReady()
  KBTrainManager:SetTrainPos()
  KBTrainManager:StartGame()
  KBTrainManager:Start()
  KBTrainManager.train:StartMove(PlayerData.GetTrainSpeed())
  KBTrainManager.train:SetSpeed(2.4)
end

local function deepcopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == "table" then
    copy = {}
    for orig_key, orig_value in pairs(orig) do
      copy[deepcopy(orig_key)] = deepcopy(orig_value)
    end
  else
    copy = orig
  end
  return copy
end

function Controller.InitEvents(eventList)
  local timeEvents = {}
  local gridEvents = {}
  for i, v in pairs(eventList) do
    v.isStart = 1
    local data = deepcopy(v)
    if v.eventType == "grid" then
      if not gridEvents[v.eventVal] then
        gridEvents[v.eventVal] = {data}
      else
        table.insert(gridEvents[v.eventVal], data)
      end
    elseif v.eventType == "time" then
      if not timeEvents[v.eventVal] then
        timeEvents[v.eventVal] = {data}
      else
        table.insert(timeEvents[v.eventVal], data)
      end
    end
  end
  DataModel.timeEvents = timeEvents
  DataModel.gridEvents = gridEvents
end

function Controller.GameOver(sta)
  View.Group_Common.Group_MainInfo.Group_Time.Txt_TimeNum:SetText("00:00")
  DataModel.isGameStart = false
  KBTrainManager.isGameStart = not sta
  Controller.InitShootState()
  local goodsCost = 0
  local goodsID = 0
  local serverGoodsData = ""
  if KBTrainManager.train.gun then
    local gunCA = KBTrainManager.train.gun.ca
    local goodsData = gunCA.UseBullets[0]
    goodsID = goodsData.goods.id
    local curGoods = math.ceil(KBTrainManager.train.gun.curAmmo / goodsData.rate)
    goodsCost = PlayerData:GetGoodsById(goodsID).num - curGoods
    serverGoodsData = goodsID .. ":" .. goodsCost
  end
  local curHp = Controller.GetTrainProperty(EnumDefine.KabaneriEnum.CurHP)
  local tempDurable = PlayerData:GetHomeInfo().readiness.repair.current_durable - curHp
  local curFuel = math.min(PlayerData:GetHomeInfo().readiness.fuel.fuel_num, PlayerData.GetMaxFuelNum())
  Net:SendProto("battle.end_challenge", function(json)
    if goodsID ~= 0 then
      PlayerData:RefreshUseItems({
        [goodsID] = goodsCost
      })
    end
    PlayerData:GetHomeInfo().readiness.repair.current_durable = curHp
    Controller.ShowGameResult(sta, json.reward)
    if sta then
      PlayerData.ServerData.kabaneri = PlayerData.ServerData.kabaneri or {}
      PlayerData.ServerData.kabaneri.kab_level = PlayerData.ServerData.kabaneri.kab_level or {}
      PlayerData.ServerData.kabaneri.kab_level[tostring(DataModel.mapCA.id)] = {}
    end
  end, PlayerData.TempCache.KabaneriKID, DataModel.score, curHp, serverGoodsData, curFuel, math.ceil(DataModel.gameTime), function(json)
    if json and json.rc then
      Controller.GameOver(sta)
    end
  end)
end

function Controller.RefreshTrainStrikeAtk()
  local stirkePower = TrainWeaponTag.GetWeaponTagAttributes(EnumDefine.TrainWeaponTagEnum.TrainWeaponImpact, 0)
  stirkePower = math.ceil(stirkePower + KBTrainManager.train.ShowSpeed * DataModel.config.strikeAtkParam)
  TrainBattleUnitManager.strikerPower = stirkePower
end

function Controller.SetTrainDetailAttr()
  local stirkePower = TrainWeaponTag.GetWeaponTagAttributes(EnumDefine.TrainWeaponTagEnum.TrainWeaponImpact, 0)
  stirkePower = math.ceil(stirkePower)
  View.Group_Common.Group_TrainOverview.Group_Overview.Img_Glass.Img_Base.Group_Impact.Txt_Num:SetText(stirkePower)
  local gunAtk = TrainWeaponTag.GetWeaponTagAttributes(EnumDefine.TrainWeaponTagEnum.TrainWeaponAtk)[2]
  gunAtk = math.ceil(gunAtk)
  View.Group_Common.Group_TrainOverview.Group_Overview.Img_Glass.Img_Base.Group_Firepower.Txt_Num:SetText(gunAtk)
  local armor = DataModel.GetTrainArmor()
  armor = math.ceil(armor)
  View.Group_Common.Group_TrainOverview.Group_Overview.Img_Glass.Img_Base.Group_Armor.Txt_Num:SetText(armor)
  View.Group_Common.Group_TrainOverview.Group_Overview.Img_Glass.Img_Base.Group_All.Txt_Num:SetText(math.ceil(PlayerData.GetTrainSpeed()))
end

function Controller.Update()
  if KBTrainManager == nil then
    return
  end
  if DataModel.isGameStart == false or DataModel.isPause then
    return
  end
  if DataModel.AtkStaticMonster then
    AimStaticMonster()
  end
  Effect.Update()
  if DataModel.beReadyMulRoad == 1 then
    local tempDis = firstTrainSpline.Spline.Length - firstTrainSpline.Position
    if tempDis <= showSelectRoadDistance then
      Controller.ShowSelectRoad()
      DataModel.beReadyMulRoad = 2
    end
  elseif DataModel.beReadyMulRoad == 2 then
    local imgPercent = (firstTrainSpline.Spline.Length - firstTrainSpline.Position) / showSelectRoadDistance
    View.Group_ForkRoadWarn.Group_Progress.Img_ProgressLine:SetFilledImgAmount(imgPercent)
  end
  if KBTrainManager.train ~= nil and KBTrainManager.train._fieldViewBase == 0 then
    KBTrainManager.train._fieldViewBase = 56
  end
  DataModel.gameTime = KBTrainManager.gameTime
  Controller.RefreshTrainStrikeAtk()
  if DataModel.isWarning == true and DataModel.warningTime < DataModel.gameTime then
    Controller.CloseWarning()
  end
  if DataModel.gameLimit ~= -1 and DataModel.gameTime >= DataModel.gameLimit then
    Controller.GameOverStopTrain(true)
    return
  end
  View.Group_Common.Group_MainInfo.Group_Time.Txt_TimeNum:SetText(TimeUtil:SecondsToTimeFormat(DataModel.gameTime))
  Controller.TriggerEventTime(DataModel.gameTime)
  Controller.TriggerBuffTime(DataModel.gameTime)
  Controller.TriggerTickFunc(DataModel.gameTime)
  Controller.UpdateTimeLimitBuff()
  if 2 < math.abs(lastShowSpeed - KBTrainManager.train.ShowSpeed) or Time.fixedUnscaledTime >= DataModel.FixedTime + 1 then
    lastShowSpeed = KBTrainManager.train.ShowSpeed
    DataModel.FixedTime = Time.fixedUnscaledTime
    local currSpeed = math.max(0, math.random(-4, 4) + lastShowSpeed)
    Controller.ShowSpeed(currSpeed, true)
  end
  if followAtkTime then
    if Time.realtimeSinceStartup >= followExitTime then
      followAtkTime = nil
      followExitTime = nil
      tempFollowAtkTime = 0
      ClearGunHitEffect()
      TrainBattleUnitManager:FollowMonsterLeave()
      Controller.ShowBossUI(false)
    else
      tempFollowAtkTime = tempFollowAtkTime + Time.fixedDeltaTime
      if tempFollowAtkTime >= followAtkTime then
        tempFollowAtkTime = tempFollowAtkTime - followAtkTime
        TrainBattleUnitManager:FollowMonsterAttack()
      end
    end
  end
end

function Controller.InitBuffSelectInfo()
  local function showBuff(roadType, buffID)
    local buffGroup
    
    if roadType == CS.KBTrainManager.KBPlayerSelectDir.right then
      buffGroup = View.Group_ForkRoadWarn.Group_Buff.Group_Buff3
    elseif roadType == CS.KBTrainManager.KBPlayerSelectDir.middle then
      buffGroup = View.Group_ForkRoadWarn.Group_Buff.Group_Buff2
    elseif roadType == CS.KBTrainManager.KBPlayerSelectDir.left then
      buffGroup = View.Group_ForkRoadWarn.Group_Buff.Group_Buff1
    end
    if buffGroup == nil then
      return
    end
    buffGroup:SetActive(true)
    require("FactoryRegister/Propertys/KabaneriBuffFactory")
    local unitCA = PlayerData:GetFactoryData(buffID, "TrainBattleUnitFactory")
    local buffCA = PlayerData:GetFactoryData(unitCA.buff, "KabaneriBuffFactory")
    buffGroup.Img_BuffDesc:SetSprite(buffCA.choiceIcon)
    buffGroup.Img_Select.Img_BuffIcon:SetSprite(buffCA.choiceIcon)
    buffGroup.Img_BuffDesc.Txt_BuffName:SetText(buffCA.name)
    buffGroup.Img_Select.Txt_BuffName:SetText(buffCA.name)
  end
  
  local buffs = KBTrainManager.map.nextGridUnit
  local selects = KBTrainManager.map:GetMapGrid(KBTrainManager.map.GridIndex + 1).playerSelection
  View.Group_ForkRoadWarn.Group_Buff.Group_Buff1:SetActive(DataModel.hasLeft)
  View.Group_ForkRoadWarn.Group_Buff.Group_Buff2:SetActive(DataModel.hasMiddle)
  View.Group_ForkRoadWarn.Group_Buff.Group_Buff3:SetActive(DataModel.hasRight)
  local tempSelect = {}
  if selects:Contains(CS.KBTrainManager.KBPlayerSelectDir.left) then
    table.insert(tempSelect, CS.KBTrainManager.KBPlayerSelectDir.left)
  end
  if selects:Contains(CS.KBTrainManager.KBPlayerSelectDir.middle) then
    table.insert(tempSelect, CS.KBTrainManager.KBPlayerSelectDir.middle)
  end
  if selects:Contains(CS.KBTrainManager.KBPlayerSelectDir.right) then
    table.insert(tempSelect, CS.KBTrainManager.KBPlayerSelectDir.right)
  end
  for k, v in ipairs(tempSelect) do
    showBuff(v, buffs[k - 1])
  end
end

function Controller.ShowSelectRoad()
  View.Group_ForkRoadWarn:SetActive(true)
  local curDefaultSelect = targetPlayerDir
  if targetPlayerDir == -1 and not DataModel.hasRight then
    curDefaultSelect = 0
  elseif targetPlayerDir == 0 and not DataModel.hasMiddle then
    curDefaultSelect = -1
  elseif targetPlayerDir == 1 and not DataModel.hasLeft then
    curDefaultSelect = 0
  end
  Controller.SetPlayerDirShow(curDefaultSelect)
  Controller.SelectBuff(curDefaultSelect)
  View.Group_ForkRoadWarn.self:SelectPlayAnim("Group_ForkRoadWarn")
end

function Controller.DoAttack(_type)
  if DataModel.isGameStart == false then
    return
  end
  if _type == -1 then
    Controller.TrainTakeDamage(DataModel.BossAtk)
  elseif _type == -2 then
    local damage = DataModel.GunAtk
    local singleDeath = false
    bossTakeDamage = bossTakeDamage + damage
    if bossTakeDamage > DataModel.BossSingleHp then
      damage = damage - (bossTakeDamage - DataModel.BossSingleHp)
      bossTakeDamage = 0
      singleDeath = true
    end
    local persent = damage / DataModel.BossSingleHp
    local score = DataModel.BossScore * persent
    DataModel.score = math.ceil(DataModel.score + score)
    View.Group_Common.Group_MainInfo.Group_Point.Txt_Score:SetText(DataModel.score)
    DataModel.BossHp = math.max(DataModel.BossHp - damage, 0)
    KBTrainManager.bossStatus:SetHpPercent(DataModel.BossHp / DataModel.BossHpMax)
    if singleDeath then
      ClearGunHitEffect()
      DataModel.SubMonsNum = DataModel.SubMonsNum - 1
      TrainBattleUnitManager.followMonster:Death()
      if DataModel.SubMonsNum == 0 then
        Controller.ShowBossUI(false)
      end
    elseif KBTrainManager.train.gun then
      local gunca = GetCA(KBTrainManager.train.gun.ca.id, "TrainBattleUnitFactory")
      Controller.FollowMonsterAddEffect(gunca.beHitEffect)
    end
  elseif _type == -3 then
    local stMons = KBTrainManager.train.gun.target
    local damage = math.min(DataModel.GunAtk, stMons.attrPart.curHp)
    stMons.attrPart:TakeDamage(damage)
    local isDeath = 0 >= stMons.attrPart.curHp
    local persent = damage / stMons.attrPart.maxHp
    local score = stMons.attrPart:GetAttribute(CS.TrainBattle.TrainBattleEnum.TBUnitAttrType.Score) * persent
    DataModel.score = math.ceil(DataModel.score + score)
    View.Group_Common.Group_MainInfo.Group_Point.Txt_Score:SetText(DataModel.score)
    if curStaticMonHp then
      curStaticMonHp:RefreshHpBar(stMons.attrPart.curHp, stMons.attrPart.maxHp)
    end
    if isDeath then
      if curStaticMonster then
        curStaticMonster:Death()
        if curStaticMonster.ca.deathFx and 0 < curStaticMonster.ca.deathFx.id then
          KBEffectManager:ShowEffect(curStaticMonster:GetPosition(), curStaticMonster.ca.deathFx.id)
        end
        curStaticMonster.model.transform.position = TrainBattleUnitManager.FARMAX
        curStaticMonster = nil
      end
      if curStaticMonHp then
        curStaticMonHp.follow = nil
        curStaticMonHp.gameObject:SetActive(false)
      end
    else
      local gunca = GetCA(KBTrainManager.train.gun.ca.id, "TrainBattleUnitFactory")
      local partical = ParticleManager:Create(gunca.beHitEffect)
      partical:SetLocalPosition(0, 0, 0)
      partical:SetScale(1, 1, 1)
      local effca = GetCA(gunca.beHitEffect, "EffectFactory")
      partical._container.transform.localRotation = CS.UnityEngine.Quaternion.Euler(effca.eularX, effca.eularY, effca.eularZ)
      partical:PlayParticle()
      partical:Excute()
    end
  end
end

function Controller.FollowMonsterAddEffect(id, unit)
  local tempUnit = unit or TrainBattleUnitManager.followMonster
  if tempUnit == nil then
    return
  end
  local partical = ParticleManager:Create(id)
  partical:SetLocalPosition(0, 0, 0)
  partical:SetScale(1, 1, 1)
  local effca = GetCA(id, "EffectFactory")
  partical._container.transform.localRotation = CS.UnityEngine.Quaternion.Euler(effca.eularX, effca.eularY, effca.eularZ)
  partical:PlayParticle()
  partical:Excute()
  table.insert(gunHitEffects, partical)
end

function Controller.InitDirSelect(hasRight, hasMiddle, hasLeft)
  DataModel.hasLeft = hasLeft == 1
  DataModel.hasMiddle = hasMiddle == 1
  DataModel.hasRight = hasRight == 1
  if DataModel.hasRight and targetPlayerDir == -1 then
    KBTrainManager:SetPlayerSelectDir(CS.KBTrainManager.KBPlayerSelectDir.right)
  elseif DataModel.hasMiddle and targetPlayerDir == 0 then
    KBTrainManager:SetPlayerSelectDir(CS.KBTrainManager.KBPlayerSelectDir.middle)
  elseif DataModel.hasLeft and targetPlayerDir == 1 then
    KBTrainManager:SetPlayerSelectDir(CS.KBTrainManager.KBPlayerSelectDir.left)
  end
end

function Controller.SetPlayerDirShow(dir)
  if dir == targetPlayerDir then
    return
  end
  targetPlayerDir = dir
  DOTweenTools.Kill(View.Group_Common.Group_Gear.Img_Gear.gameObject.transform)
  DOTweenTools.DOLocalRotate(View.Group_Common.Group_Gear.Img_Gear.gameObject.transform, 0, 0, 60 * dir, 0.5)
  local isLeft = dir == 1
  View.Group_Common.Group_Gear.Btn_L.Group_Off:SetActive(not isLeft)
  View.Group_Common.Group_Gear.Btn_L.Group_On:SetActive(isLeft)
  local isMiddle = dir == 0
  View.Group_Common.Group_Gear.Btn_M.Group_Off:SetActive(not isMiddle)
  View.Group_Common.Group_Gear.Btn_M.Group_On:SetActive(isMiddle)
  local isRight = dir == -1
  View.Group_Common.Group_Gear.Btn_R.Group_Off:SetActive(not isRight)
  View.Group_Common.Group_Gear.Btn_R.Group_On:SetActive(isRight)
  if DataModel.hasRight and targetPlayerDir == -1 then
    KBTrainManager:SetPlayerSelectDir(CS.KBTrainManager.KBPlayerSelectDir.right)
  elseif DataModel.hasMiddle and targetPlayerDir == 0 then
    KBTrainManager:SetPlayerSelectDir(CS.KBTrainManager.KBPlayerSelectDir.middle)
  elseif DataModel.hasLeft and targetPlayerDir == 1 then
    KBTrainManager:SetPlayerSelectDir(CS.KBTrainManager.KBPlayerSelectDir.left)
  end
end

function Controller.SelectBuff(pos)
  if View.Group_ForkRoadWarn.gameObject.activeSelf == false then
    return
  end
  local buffGroup
  if pos == -1 then
    buffGroup = View.Group_ForkRoadWarn.Group_Buff.Group_Buff3
  elseif pos == 0 then
    buffGroup = View.Group_ForkRoadWarn.Group_Buff.Group_Buff2
  elseif pos == 1 then
    buffGroup = View.Group_ForkRoadWarn.Group_Buff.Group_Buff1
  end
  if buffGroup == nil then
    return
  end
  if lastSelectBuffGroup then
    lastSelectBuffGroup.Img_Select:SetActive(false)
  end
  lastSelectBuffGroup = buffGroup
  lastSelectBuffGroup.Img_Select:SetActive(true)
end

function Controller.FollowMonsterSubDeath()
  local temp = DataModel.BossSingleHp - bossTakeDamage
  bossTakeDamage = 0
  DataModel.BossHp = math.max(DataModel.BossHp - temp, 0)
  KBTrainManager.bossStatus:SetHpPercent(DataModel.BossHp / DataModel.BossHpMax)
  if 0 >= DataModel.BossHp then
    Controller.ShowBossUI(false)
  end
end

function Controller.ShowBossUI(state)
  KBTrainManager.bossStatus:SetActive(state)
  if state then
    KBTrainManager.bossStatus:SetHpPercent(1)
  end
  KBTrainManager.bossStatus:SetEnergyBarActive(false)
end

function Controller.ShowSpeed(currSpeed, isTween)
  if isTween then
    DOTweenTools.DoTextProgress(View.Group_Common.Group_MB.Img_Speed.Txt_Speed, tonumber(View.Group_Common.Group_MB.Img_Speed.Txt_Speed.Txt.text), currSpeed, 0.5, nil, nil, nil, true, "f0")
  else
    View.Group_Common.Group_MB.Img_Speed.Txt_Speed:SetText(math.floor(currSpeed))
  end
end

function Controller.RefreshData()
  DataModel.RefreshBaseEnemy()
  DataModel.RefreshBaseCount()
  DataModel.RefreshAtkParam()
end

function Controller.ShowGameResult(isWin, rewards)
  local soundID = isWin and 30006293 or 30006294
  local sound = SoundManager:CreateSound(soundID)
  CheckLoopSound(sound)
  View.Group_Over:SetActive(true)
  View.Group_Over.Group_Btns.Btn_ReStartGame:SetClickParam(isWin and 1 or 0)
  local resultGroup
  if isWin == true then
    View.Group_Over.Group_Victory:SetActive(true)
    View.Group_Over.Group_Victory.Img_Txt:SetSprite(GetResPath(88300128))
    View.Group_Over.Group_Defeat:SetActive(false)
    resultGroup = View.Group_Over.Group_Victory
  else
    View.Group_Over.Group_Victory:SetActive(false)
    View.Group_Over.Group_Defeat:SetActive(true)
    View.Group_Over.Group_Defeat.Img_Txt:SetSprite(GetResPath(88300129))
    resultGroup = View.Group_Over.Group_Defeat
  end
  resultGroup.Img_Point.Txt_Num:SetText(DataModel.score)
  resultGroup.Img_Time.Txt_Num:SetText(TimeUtil:SecondsToTimeFormat(DataModel.gameTime))
  if rewards and rewards ~= {} then
    View.Group_Over.Img_RewordBG:SetActive(true)
    View.Group_Over.Img_NoReward:SetActive(false)
    DataModel.InitRewards(rewards)
    View.Group_Over.Img_RewordBG.ScrollGrid_.grid.self:SetDataCount(#DataModel.rewards)
    View.Group_Over.Img_RewordBG.ScrollGrid_.grid.self:RefreshAllElement()
    View.Group_Over.Img_RewordBG.ScrollGrid_.grid.self:MoveToTop()
  else
    View.Group_Over.Img_RewordBG:SetActive(false)
    View.Group_Over.Img_NoReward:SetActive(true)
  end
  if not isWin then
    PlayerData.TempCache.kbIsAuto = false
  end
  View.Group_Over.Group_Btns.Txt_Auto:SetActive(PlayerData.TempCache.kbIsAuto)
  local animName = isWin and "KabaneriMain_Group_Victory" or "KabaneriMain_Group_Defeat"
  View.Group_Over.self:SelectPlayAnim(animName)
  if PlayerData.TempCache.kbIsAuto then
    View.Group_Over.Group_Btns.Txt_Auto:SetText(string.format("%s\231\167\146\229\144\142\232\135\170\229\138\168\229\188\128\229\167\139", 3))
    local tempTime = 3
    TimerHelper.Start("KBAutoGame", 1, function()
      tempTime = tempTime - 1
      if tempTime <= 0 then
        Controller.RecycleAll()
        Controller.Pause(false)
        View.Group_Over:SetActive(false)
        PlayerData.OpenKabSettlelemt(PlayerData.TempCache.kbActivityId, PlayerData.TempCache.kbLevelIndex, PlayerData.TempCache.kbUIPath)
        TimerHelper.Stop("KBAutoGame")
        return
      end
      View.Group_Over.Group_Btns.Txt_Auto:SetText(string.format("%s\231\167\146\229\144\142\232\135\170\229\138\168\229\188\128\229\167\139", tempTime))
    end)
  end
end

function Controller.UpdateGrid(grid)
  local nextG = KBTrainManager.map:GetMapGrid(KBTrainManager.map.GridIndex + 1)
  if nextG and nextG.playerSelection.Count == 1 then
    nextG.finalSelection = nextG.playerSelection[0]
  else
    nextG.finalSelection = CS.KBTrainManager.KBPlayerSelectDir.None
    Controller.InitBuffSelectInfo()
  end
  DataModel.gameGrid = DataModel.gameGrid + grid
  local val = DataModel.gridEvents[DataModel.gameGrid]
  if val ~= nil then
    for i, v in pairs(val) do
      Controller.TriggerEvent(DataModel.gameTime, v)
    end
  end
  if DataModel.DelayEvent then
    local e = DataModel.DelayEvent
    DataModel.DelayEvent = nil
    Controller.TriggerEvent(DataModel.gameTime, e)
  end
end

local baseMonsDeadSound = {
  30006286,
  30006299,
  30006300,
  30006301,
  30006285
}

function Controller.StrikeAry(scoreRate, damageRate)
  if DataModel.isGameStart == false then
    return
  end
  local score = DataModel.mapCA.baseMonsterSocre + DataModel.gameTime * DataModel.mapCA.scoreParam
  local tempScore = math.ceil(scoreRate * score)
  DataModel.score = DataModel.score + tempScore
  View.Group_Common.Group_MainInfo.Group_Point.Txt_Score:SetText(DataModel.score)
  if 0 < damageRate then
    local curBaseMonsHp = 0
    local firstTrain = KBTrainManager.train:GetFirstSplineController()
    if firstTrain then
      local speed = firstTrain.Speed
      speed = math.max(1, speed)
      if DataModel.PreLoadMonsDis == nil then
        DataModel.PreLoadMonsDis = 5 * DataModel.config.perLoadMonsterPointCount
      end
      local costTime = math.ceil(DataModel.PreLoadMonsDis / speed)
      local tempT = math.max(0, DataModel.gameTime - costTime)
      curBaseMonsHp = DataModel.mapCA.baseMonsterHp - DataModel.mapCA.baseMonsterHpP1 / tempT ^ (tempT / DataModel.mapCA.baseMonsterHpP2)
    else
      for k, v in pairs(DataModel.baseEnemyProperty) do
        curBaseMonsHp = v
        break
      end
    end
    if 0 < curBaseMonsHp then
      local singleRate = TrainBattleUnitManager.strikerPower / curBaseMonsHp
      local hitCount = math.ceil(damageRate / singleRate)
      local totleDamage = hitCount * (curBaseMonsHp - TrainBattleUnitManager.strikerPower)
      Controller.TrainTakeDamage(totleDamage)
    end
  else
    Controller.TrainTakeDamage(1)
  end
  local blood = 0
  if 0 < DataModel.unitGroupPlus then
    blood = DataModel.config.corpseTideBlood
  else
    blood = DataModel.config.commonBlood
  end
  if 0 < DataModel.unitGroupPlus then
  else
    KBTrainManager.CameraCtrl:Shake(DataModel.config.cameraShakeTime, DataModel.config.cameraShakeValX, DataModel.config.cameraShakeValY)
  end
  if DataModel.screenEffectLimit < DataModel.gameTime then
    if blood > math.random(0, 100) * 0.01 then
      local randomSound = baseMonsDeadSound[math.random(1, #baseMonsDeadSound)]
      local sound = SoundManager:CreateSound(randomSound)
      CheckLoopSound(sound)
      KBTrainManager.CameraCtrl:Shake(DataModel.config.cameraShakeExTime, DataModel.config.cameraShakeExValX, DataModel.config.cameraShakeExValY)
      local len = table.count(DataModel.config.bloodEffectList)
      if 0 < len then
        local scale = 1
        local offsetData = {
          position = {
            x = 0,
            y = 0,
            z = 0
          },
          scale = {
            x = scale,
            y = scale,
            z = scale
          },
          rotation = {
            x = 0,
            y = 0,
            z = 0
          }
        }
        local effectid = DataModel.config.bloodEffectList[math.random(1, len)].id
        Effect.ShowEffect(View.Group_Common.transform, effectid, offsetData, 1.5)
      end
      DataModel.screenEffectLimit = DataModel.gameTime + 1.5
    else
      KBTrainManager.CameraCtrl:Shake(DataModel.config.cameraShakeTime, DataModel.config.cameraShakeValX, DataModel.config.cameraShakeValY)
    end
  end
end

function Controller.RefreshAmmo(realAmmo, tempAmmo)
  if KBTrainManager.train.gun then
    View.Group_Common.Group_battery.Group_ammoNum.Txt_Num:SetText(realAmmo + tempAmmo)
    if realAmmo + tempAmmo == 0 then
      Controller.SetNoAmmoShow(true)
    end
  else
    View.Group_Common.Group_battery.Group_ammoNum.Txt_Num:SetText("--")
  end
end

function Controller.StrikeStaticMonster(score, damage)
  if DataModel.isGameStart == false then
    return
  end
  Controller.StopAtkStaticMons()
  if curStaticMonster then
    damage = curStaticMonster.attrPart.curHp
    local luaCa = GetCA(curStaticMonster.ca.id, "TrainBattleUnitFactory")
    if luaCa and luaCa.hitSound then
      local sound = SoundManager:CreateSound(luaCa.hitSound)
      CheckLoopSound(sound)
    end
    curStaticMonster:Death()
    if curStaticMonster.ca.deathFx and curStaticMonster.ca.deathFx.id > 0 then
      KBEffectManager:ShowEffect(curStaticMonster:GetPosition(), curStaticMonster.ca.deathFx.id)
    end
    curStaticMonster.model.transform.position = TrainBattleUnitManager.FARMAX
    curStaticMonster = nil
  end
  if curStaticMonHp then
    curStaticMonHp.follow = nil
    curStaticMonHp.gameObject:SetActive(false)
  end
  DataModel.score = DataModel.score + score
  View.Group_Common.Group_MainInfo.Group_Point.Txt_Score:SetText(DataModel.score)
  if 0 < damage then
    Controller.TrainTakeDamage(damage)
  end
end

function Controller.TrainTakeDamage(damage)
  if DataModel.whosyourdaddyTime > DataModel.gameTime then
    return
  end
  damage = math.max(1, math.ceil(damage - DataModel.armor))
  local curHp = Controller.GetTrainProperty(EnumDefine.KabaneriEnum.CurHP)
  if DataModel.shield > 0 then
    if damage < DataModel.shield then
      DataModel.shield = DataModel.shield - damage
      View.Group_Common.Img_Fixcircle.Txt_ShieldNum:SetActive(DataModel.shield > 0)
      View.Group_Common.Img_Fixcircle.Txt_ShieldNum:SetText(math.ceil(DataModel.shield))
      return
    else
      damage = damage - DataModel.shield
      DataModel.shield = 0
      View.Group_Common.Img_Fixcircle.Txt_ShieldNum:SetActive(false)
      View.Group_Common.Img_Fixcircle.Txt_ShieldNum:SetText(0)
    end
  end
  curHp = curHp - damage
  if curHp <= 0 then
    curHp = 0
    Controller.GameOverStopTrain(false)
  end
  Controller.SetTrainProperty(EnumDefine.KabaneriEnum.CurHP, curHp)
end

function Controller.GameOverStopTrain(result)
  if KBTrainManager.train.movePart.isRushing == true then
    KBTrainManager.train:OnRushEnd()
    KBTrainManager.train.movePart.isRushing = false
  end
  KBTrainManager.train.movePart.isMoving = false
  DOTweenTools.DoTweenFloatTO(function()
    return KBTrainManager.train.CurSpeed
  end, function(tempSpeed)
    KBTrainManager.train:SetSpeed(tempSpeed)
  end, 0, 2)
  Controller.GameOver(result)
  TrainEffectHelper:LoadSingleEffect(1, 11106473, true)
end

function Controller.RefreshVal(attr, val)
  if attr == EnumDefine.KabaneriEnum.Speed then
  elseif attr == EnumDefine.KabaneriEnum.CurHP then
    local hpMax = Controller.GetTrainProperty(EnumDefine.KabaneriEnum.HpMax)
    View.Group_Common.Img_Fixcircle.Txt_Durability:SetText(val .. "/" .. hpMax)
    DOTweenTools.DoImgProgressbar(View.Group_Common.Img_Fixcircle.Img_full, View.Group_Common.Img_Fixcircle.Img_full.Img.fillAmount, val / hpMax, 0.5)
  elseif attr == EnumDefine.KabaneriEnum.Shield then
  end
end

function Controller.SetTrainProperty(attr, val)
  if attr == EnumDefine.KabaneriEnum.CurHP then
    local hpMax = Controller.GetTrainProperty(EnumDefine.KabaneriEnum.HpMax)
    if val > hpMax then
      val = hpMax
    end
    val = math.floor(val)
  end
  DataModel.trainProperty[attr] = val
  Controller.RefreshVal(attr, val)
end

function Controller.GetTrainProperty(attr)
  return DataModel.trainProperty[attr]
end

function Controller.ChangeVal(attr, val)
  local v = Controller.GetTrainProperty(attr) or 0
  local finalV = v + val
  Controller.SetTrainProperty(attr, finalV)
end

function Controller.AddTimeLimitBuff(buffCA)
  local buffTable
  for i, v in pairs(DataModel.timeLimitBuff) do
    if v.ca.id == buffCA.id then
      buffTable = v
      v.time = DataModel.gameTime + buffCA.during
    end
  end
  if buffTable == nil then
    buffTable = {
      timeMax = buffCA.during,
      time = DataModel.gameTime + buffCA.during,
      ca = buffCA
    }
    table.insert(DataModel.timeLimitBuff, buffTable)
  end
  Controller:RefreshTimeLimitBuff()
end

function Controller.UpdateTimeLimitBuff()
  local buffTable = {}
  for i, v in pairs(DataModel.timeLimitBuff) do
    if v.time > DataModel.gameTime then
      table.insert(buffTable, v)
    elseif v.ca.id == DataModel.buffTipsBuffid then
      Controller:CloseBuffTip()
      DataModel.buffTipsBuffid = -1
    end
  end
  DataModel.timeLimitBuff = buffTable
  Controller:RefreshTimeLimitBuff()
end

function Controller:RefreshTimeLimitBuff()
  View.Group_Common.Group_MB.Group_Buff.StaticGrid_List.grid.self:SetDataCount(#DataModel.timeLimitBuff)
  View.Group_Common.Group_MB.Group_Buff.StaticGrid_List.grid.self:RefreshAllElement()
end

function Controller:RefreshTimeLimitBuffElement(element, elementIndex)
  local buff = DataModel.timeLimitBuff[elementIndex]
  element.Group_List.Img_IconBg.Btn_BuffIcon.Img_Icon:SetSprite(buff.ca.icon)
  element.Group_List.Txt_Time:SetText(math.ceil(buff.time - DataModel.gameTime))
  element.Group_List.Img_IconMask:SetFilledImgAmount(1 - (buff.time - DataModel.gameTime) / buff.timeMax)
  element.Group_List.Img_IconBg.Btn_BuffIcon:SetClickParam(elementIndex)
end

function Controller.RefreshFuel()
  local Btn_Accelerate = View.Group_Common.Btn_Accelerate
  local accelerate_num = PlayerData:GetHomeInfo().readiness.fuel.fuel_num
  local isHave = 0 < accelerate_num
  Btn_Accelerate.Group_On:SetActive(isHave)
  Btn_Accelerate.Group_Off:SetActive(not isHave)
  Btn_Accelerate.Group_On.Txt_Num:SetText(accelerate_num)
  Btn_Accelerate.Group_Off.Txt_Num:SetText(accelerate_num)
end

function Controller:ShowBuffTip(Index)
  local buff = DataModel.timeLimitBuff[Index]
  DataModel.buffTipsBuffid = buff.ca.id
  View.Group_Common.Group_MB.Group_Buff.Btn_Close:SetActive(true)
  View.Group_Common.Group_MB.Group_Buff.Btn_Close.Img_BuffDesc.Txt_BuffName:SetText(buff.ca.name)
  View.Group_Common.Group_MB.Group_Buff.Btn_Close.Img_BuffDesc.Txt_BuffTime:SetText(buff.timeMax .. "s")
  View.Group_Common.Group_MB.Group_Buff.Btn_Close.Img_BuffDesc.Txt_BuffDesc:SetText(buff.ca.des)
end

function Controller:CloseBuffTip()
  View.Group_Common.Group_MB.Group_Buff.Btn_Close:SetActive(false)
end

function Controller.TriggerBuff(id, time)
  local sound = SoundManager:CreateSound(30006287)
  CheckLoopSound(sound)
  local pos = KBTrainManager.train.firstTrain.position + KBTrainManager.train.firstTrain.forward * 5
  local offsetData = {
    position = {
      x = pos.x,
      y = pos.y,
      z = pos.z
    },
    scale = {
      x = 1,
      y = 1,
      z = 1
    },
    rotation = {
      x = 0,
      y = 0,
      z = 0
    }
  }
  Effect.ShowEffect(nil, 11107056, offsetData, 1)
  local buffCA = PlayerData:GetFactoryData(id, "KabaneriBuffFactory")
  if time == -1 then
    time = DataModel.gameTime
  end
  if buffCA.mod == "\230\149\176\229\128\188\230\148\185\229\143\152" then
    if buffCA.valType == EnumDefine.KabaneriEnum.Shield then
      DataModel.shield = DataModel.shield + buffCA.val
      if 0 >= DataModel.shield then
        DataModel.shield = 0
      end
      View.Group_Common.Img_Fixcircle.Txt_ShieldNum:SetActive(0 < DataModel.shield)
      View.Group_Common.Img_Fixcircle.Txt_ShieldNum:SetText(math.ceil(DataModel.shield))
    elseif buffCA.valType == "MinHp" then
      TrainBattleUnitManager.HitEnemyGroup(buffCA.val)
    else
      Controller.ChangeVal(buffCA.valType, buffCA.val)
    end
  elseif buffCA.mod == "\231\137\169\229\147\129\230\148\185\229\143\152" then
    if buffCA.item and 0 < buffCA.item then
      local max = PlayerData.GetMaxFuelNum()
      local cur = PlayerData:GetHomeInfo().readiness.fuel.fuel_num + buffCA.val
      cur = math.min(max, cur)
      PlayerData:GetHomeInfo().readiness.fuel.fuel_num = cur
    elseif buffCA.goods and 0 < buffCA.goods and KBTrainManager.train.gun then
      KBTrainManager.train.gun.tempAmmo = KBTrainManager.train.gun.tempAmmo + buffCA.val
      Controller.RefreshAmmo(KBTrainManager.train.gun.curAmmo, KBTrainManager.train.gun.tempAmmo)
      Controller.SetNoAmmoShow(false)
    end
  elseif buffCA.mod == "Buff\231\190\164" then
    for i, v in pairs(buffCA.createList) do
      for k = 0, v.num do
        Controller.TriggerBuff(buffCA.createList[k].id, time)
      end
    end
  elseif buffCA.mod == "\233\153\144\230\151\182\229\177\158\230\128\167" then
    Controller.AddTimeLimitBuff(buffCA)
    if buffCA.valType == "Speed" then
      KBTrainManager.train.movePart:SetTempRush(buffCA.val / DataModel.config.speedRatio)
      DataModel.speedPlus = DataModel.speedPlus + buffCA.val / DataModel.config.speedRatio
      TrainEffectHelper:LoadSingleEffect(1, buffCA.trainEffectPath, true)
      local tempSpeed = 0
      if KBTrainManager.train.movePart.isRushing then
        tempSpeed = KBTrainManager.train.movePart.rushSpeed2
      else
        tempSpeed = KBTrainManager.train.movePart.normalSpeed
      end
      tempSpeed = math.ceil(tempSpeed * DataModel.config.speedRatio)
      Controller.RefreshTrainDetailAttrValue(View.Group_Common.Group_TrainOverview.Group_Overview.Img_Glass.Img_Base.Group_All.Txt_Num, tempSpeed)
      if DataModel.hasRushClick == false then
        Controller.PlayTrainAnim("rush")
        TrainEffectHelper:LoadEffect(1, TrainEffectHelper.Enum_TrainEffectType.SkinEffect, true)
        KBTrainManager.train.movePart:RushEffect()
      end
      
      local function func()
        KBTrainManager.train.movePart:SetTempRush(-buffCA.val / DataModel.config.speedRatio)
        DataModel.speedPlus = DataModel.speedPlus - buffCA.val / DataModel.config.speedRatio
        TrainEffectHelper:DisposeSingleEffects(buffCA.trainEffectPath)
        if DataModel.hasRushClick == false then
          TrainEffectHelper:DisposeEffects(TrainEffectHelper.Enum_TrainEffectType.SkinEffect)
          Controller.PlayTrainAnim("rushover")
          KBTrainManager.train.movePart:RushEffectOver()
        end
        local tempSpeed2 = 0
        if KBTrainManager.train.movePart.isRushing then
          tempSpeed2 = KBTrainManager.train.movePart.rushSpeed2
        else
          tempSpeed2 = KBTrainManager.train.movePart.normalSpeed
        end
        tempSpeed2 = math.ceil(tempSpeed2 * DataModel.config.speedRatio)
        Controller.RefreshTrainDetailAttrValue(View.Group_Common.Group_TrainOverview.Group_Overview.Img_Glass.Img_Base.Group_All.Txt_Num, tempSpeed2)
      end
      
      Controller.AddTickFunc(time + buffCA.during, func)
    elseif buffCA.valType == EnumDefine.KabaneriEnum.WhosYourDaddy then
      DataModel.whosyourdaddyTime = DataModel.gameTime + buffCA.during
      TrainEffectHelper:LoadSingleEffect(1, buffCA.trainEffectPath, true)
      Controller.TrainAddMaterial("Kabaneri/mat_wudi")
      
      local function func()
        TrainEffectHelper:DisposeSingleEffects(buffCA.trainEffectPath)
        Controller.RemoveTrainMaterial()
      end
      
      Controller.AddTickFunc(time + buffCA.during, func)
    elseif buffCA.valType == EnumDefine.KabaneriEnum.Defence then
      DataModel.armor = DataModel.armor + buffCA.val
      Controller.RefreshTrainDetailAttrValue(View.Group_Common.Group_TrainOverview.Group_Overview.Img_Glass.Img_Base.Group_Armor.Txt_Num, DataModel.armor)
      TrainEffectHelper:LoadSingleEffect(1, buffCA.trainEffectPath, true)
      
      local function func()
        DataModel.armor = DataModel.armor - buffCA.val
        TrainEffectHelper:DisposeSingleEffects(buffCA.trainEffectPath)
        Controller.RefreshTrainDetailAttrValue(View.Group_Common.Group_TrainOverview.Group_Overview.Img_Glass.Img_Base.Group_Armor.Txt_Num, DataModel.armor)
      end
      
      Controller.AddTickFunc(time + buffCA.during, func)
    elseif buffCA.valType == "ColliderRange" then
      TrainBattleUnitManager.createUnitRangeX = buffCA.val
      TrainBattleUnitManager.createUnitRangeY = buffCA.val
      TrainEffectHelper:LoadSingleEffect(1, buffCA.trainEffectPath, true)
      
      local function func()
        TrainBattleUnitManager.createUnitRangeX = DataModel.config.createUnitRangeX
        TrainBattleUnitManager.createUnitRangeY = DataModel.config.createUnitRangeY
        TrainEffectHelper:DisposeSingleEffects(buffCA.trainEffectPath)
      end
      
      Controller.AddTickFunc(time + buffCA.during, func)
    else
      Controller.ChangeVal(buffCA.valType, buffCA.val)
      
      local function func()
        Controller.ChangeVal(buffCA.valType, -buffCA.val)
      end
      
      Controller.AddTickFunc(time + buffCA.during, func)
    end
  end
end

function Controller.TriggerEventTime(time)
  local keysToRemove = {}
  for i, v in pairs(DataModel.timeEvents) do
    if i <= time then
      for k, e in pairs(v) do
        Controller.TriggerEvent(i, e)
      end
      table.insert(keysToRemove, i)
    end
  end
  for _, i in ipairs(keysToRemove) do
    DataModel.timeEvents[i] = nil
  end
end

function Controller.TriggerBuffTime(time)
  local keysToRemove = {}
  for i, v in pairs(DataModel.buffEvents) do
    if i <= time then
      for k, e in pairs(v) do
        Controller.TriggerBuff(e, i)
      end
      table.insert(keysToRemove, i)
    end
  end
  for _, i in ipairs(keysToRemove) do
    DataModel.buffEvents[i] = nil
  end
end

function Controller.TriggerTickFunc(time)
  local keysToRemove = {}
  for i, v in pairs(DataModel.tickFunc) do
    if i <= time then
      for k, e in pairs(v) do
        e()
      end
      table.insert(keysToRemove, i)
    end
  end
  for _, i in ipairs(keysToRemove) do
    DataModel.tickFunc[i] = nil
  end
end

function Controller.CanLoadStaticMonster(dis)
  local sc = KBTrainManager.train:GetFirstSplineController()
  dis = sc.Position + dis
  local curvy = sc.Spline
  if dis > curvy.Length then
    local nextGrid = KBTrainManager.map:GetMapGrid(KBTrainManager.map.GridIndex + 1)
    if nextGrid and 1 < nextGrid.playerSelection.Count then
      return false
    end
  end
  return true
end

function Controller.GetMapGridByDistance(distance)
  local sc = KBTrainManager.train:GetFirstSplineController()
  distance = sc.Position + distance
  local curvy = sc.Spline
  local idx = KBTrainManager.map.GridIndex
  local map = KBTrainManager.map:GetMapGrid(idx)
  while distance > curvy.Length do
    distance = distance - curvy.Length
    idx = idx + 1
    map = KBTrainManager.map:GetMapGrid(idx)
    if map == nil then
      return nil
    end
  end
  return map, distance
end

function Controller.CheckCanAtkStaticMons()
  if curStaticMonster == nil or curStaticMonster.model == nil then
    curStaticMonster = nil
    return
  end
  if KBTrainManager.train.gun and View.Group_Common.Slider_Shoot.slider.value == 1 then
    CS.FRef.setProperty(KBTrainManager.train.gun.AIPart, "master", nil)
    KBTrainManager.train.gun.target = curStaticMonster
    DataModel.AtkStaticMonster = true
  end
end

function Controller.StopAtkStaticMons()
  if KBTrainManager.train.gun then
    CS.FRef.setProperty(KBTrainManager.train.gun.AIPart, "master", KBTrainManager.train.gun)
    DataModel.AtkStaticMonster = false
  end
end

function Controller.TriggerEvent(time, e)
  local val = e.isStart
  local eventCA = PlayerData:GetFactoryData(e.eventid, "KabaneriEventFactory")
  if eventCA.mod == "\231\148\159\230\136\144\229\141\149\228\189\141" then
    for i, v in pairs(eventCA.createList) do
      for k = 1, v.num do
        local ca = PlayerData:GetFactoryData(v.unit, "TrainBattleUnitFactory")
        if ca.mod == "MonsterUnit" then
          local canCreate = Controller.CanLoadStaticMonster(v.distance)
          if canCreate then
            local hpParam = math.ceil(v.hp + DataModel.gameTime * DataModel.mapCA.bossHpParam)
            local atkParam = math.ceil(v.atk + DataModel.gameTime * DataModel.mapCA.bossAtkParam)
            local scoreParam = math.ceil(v.score + DataModel.gameTime * DataModel.mapCA.scoreParam)
            local nextGrid = KBTrainManager.map:GetMapGrid(KBTrainManager.map.GridIndex)
            local unit = TrainBattleUnitManager:CreateUnit(v.unit, v.distance, hpParam, atkParam, scoreParam)
            if nextGrid then
              nextGrid.localUnit:Add(unit)
            end
            local monsPos = unit.model.transform.position
            local frontPos = KBTrainManager.map:GetNextDistancePos(v.distance - 1)
            unit.model.transform.rotation = CS.UnityEngine.Quaternion.LookRotation(frontPos - monsPos)
            curStaticMonster = unit
            Controller.CheckCanAtkStaticMons()
            curStaticMonHp.gameObject:SetActive(true)
            curStaticMonHp.follow = unit.model.transform
            curStaticMonHp.offset = Vector3(0, 1.5, 0)
            curStaticMonHp:RefreshHpBar(hpParam, hpParam)
            View.Group_StaticMonsHp.Txt_Name:SetText(ca.monsName)
          else
            DataModel.DelayEvent = e
            return
          end
        elseif ca.mod == "FollowMonster" then
          TrainBattleUnitManager:CreateFollowEnemy(v.unit)
          followAtkTime = v.atkCD
          tempFollowAtkTime = 0
          followExitTime = Time.realtimeSinceStartup + v.exitTime
          DataModel.SubMonsNum = v.subMonsterNum
          DataModel.BossSingleHp = math.ceil(v.hp + DataModel.gameTime * DataModel.mapCA.bossHpParam)
          DataModel.BossHp = DataModel.BossSingleHp * v.subMonsterNum
          DataModel.BossHpMax = DataModel.BossHp
          DataModel.BossAtk = math.ceil(v.atk + DataModel.gameTime * DataModel.mapCA.bossAtkParam)
          DataModel.BossScore = math.ceil(v.score + DataModel.gameTime * DataModel.mapCA.scoreParam)
          DataModel.GunAtk = TrainWeaponTag.GetWeaponTagAttributes(EnumDefine.TrainWeaponTagEnum.TrainWeaponAtk)[2]
          bossTakeDamage = 0
          Controller.ShowBossUI(true)
          local followCA = GetCA(v.unit, "TrainBattleUnitFactory")
          KBTrainManager.bossStatus:SetName(followCA.monsName)
        end
      end
    end
  elseif eventCA.mod == "\230\191\128\229\162\158\229\141\149\228\189\141" then
    DataModel.unitGroupPlus = DataModel.unitGroupPlus + eventCA.num
    TrainBattleUnitManager.createUnitRangeY = eventCA.createUnitRangeY
    
    local function func()
      TrainBattleUnitManager.createUnitRangeY = DataModel.config.createUnitRangeY
      DataModel.unitGroupPlus = DataModel.unitGroupPlus - eventCA.num
    end
    
    Controller.AddTickFunc(time + eventCA.duration, func)
  elseif eventCA.mod == "\229\178\148\232\183\175" then
    local road = RoadID[eventCA.junctionNum]
    local idx = math.random(1, #road)
    DataModel.buffList = eventCA.buffList
    local buffunit = DataModel.GetBuff(eventCA.junctionNum)
    KBTrainManager.map:NextJunction(road[idx], buffunit)
  end
  if eventCA.isWarn then
    Controller.ShowWarning(eventCA)
  end
  if e.isLoop == true and 0 < e.loopOver then
    e.loopOver = e.loopOver - 1
    e.eventVal = time + e.loopTime + math.random(-e.loopFloat, e.loopFloat)
    Controller.AddEvent(e.eventVal, e)
  end
end

function Controller.ShowWarning(ca)
  if DataModel.isWarning == true then
    return
  end
  local sound = SoundManager:CreateSound(30006292)
  CheckLoopSound(sound)
  View.Group_StaticMonsHp.self:SelectPlayAnim("Group_MonsterWarn")
  DataModel.isWarning = true
  DataModel.warningTime = DataModel.gameTime + ca.warnTime
  View.Group_MonsterWarn:SetActive(true)
  View.Group_MonsterWarn.Txt_WarnTxt:SetText(ca.warnDesc)
  View.Group_MonsterWarn.Txt_condition:SetText(ca.condition)
end

function Controller.CloseWarning()
  if DataModel.isWarning == false then
    return
  end
  DataModel.isWarning = false
  View.Group_MonsterWarn:SetActive(false)
end

function Controller.OnTrainReachPoint(pointIndex, totlePointNum)
  if DataModel.curPointIndex == pointIndex then
    return
  end
  DataModel.curPointIndex = pointIndex
  Controller.RefreshData()
  if DataModel.beReadyMulRoad == 2 and pointIndex == totlePointNum - 1 then
    DataModel.beReadyMulRoad = 0
    View.self:SelectPlayAnim(View.Group_ForkRoadWarn.self, "Group_ForkRoadWarn_over", function()
      View.Group_ForkRoadWarn.Group_Buff.Group_Buff1.Img_Select:SetActive(false)
      View.Group_ForkRoadWarn.Group_Buff.Group_Buff2.Img_Select:SetActive(false)
      View.Group_ForkRoadWarn.Group_Buff.Group_Buff3.Img_Select:SetActive(false)
      View.Group_ForkRoadWarn:SetActive(false)
      View.Group_ForkRoadWarn.self:SetAlpha(1)
    end)
    lastSelectBuffGroup = nil
  elseif DataModel.beReadyMulRoad == 0 then
    local next = KBTrainManager.map:GetMapGrid(KBTrainManager.map.GridIndex + 1)
    if next and 1 < next.playerSelection.Count then
      DataModel.beReadyMulRoad = 1
      firstTrainSpline = KBTrainManager.train.splineCtrls[0]
    end
  end
end

function Controller.AddEvent(time, e)
  if not DataModel.timeEvents[time] then
    DataModel.timeEvents[time] = {e}
  else
    table.insert(DataModel.timeEvents[time], e)
  end
end

function Controller.AddBuff(time, b)
  if not DataModel.buffEvents[time] then
    DataModel.buffEvents[time] = {b}
  else
    table.insert(DataModel.buffEvents[time], b)
  end
end

function Controller.AddTickFunc(time, b)
  if not DataModel.tickFunc[time] then
    DataModel.tickFunc[time] = {b}
  else
    table.insert(DataModel.tickFunc[time], b)
  end
end

function Controller.RefreshTrainDetailAttrValue(uiTxt, value)
  value = math.floor(value)
  if DataModel.isShowTrainDetailAttr then
    uiTxt:SetText(value)
  else
    uiTxt:SetText(value)
  end
end

function Controller.TrainRush()
  if DataModel.hasRushClick then
    return
  end
  if PlayerData:GetHomeInfo().readiness.fuel.fuel_num <= 0 then
    CommonTips.OpenTips(80600793)
    return
  end
  
  local function cb()
    DataModel.hasRushClick = true
    PlayerData:GetHomeInfo().readiness.fuel.fuel_num = PlayerData:GetHomeInfo().readiness.fuel.fuel_num - 1
    View.Group_Common.Btn_Accelerate.Group_Ing:SetActive(false)
    View.Group_Common.Btn_Accelerate.Group_Ing.Group_RushBuyBtn:SetActive(false)
    View.Group_Common.Btn_Accelerate.Group_On:SetActive(false)
    View.Group_Common.Btn_Accelerate.Group_Off:SetActive(true)
    local ca = PlayerData:GetFactoryData(99900054).trainCameraList
    local row = ca[PlayerData.FreeCameraIndex]
    local tempTime = TrainWeaponTag.GetWeaponTagAttributes(EnumDefine.TrainWeaponTagEnum.RiseRushUseTime)[2] or 0
    local totalTime = PlayerData:GetHomeInfo().readiness.fuel.acc_time + tempTime
    View.Group_Common.Group_MB.SpineNode_Rush:SetActive(true)
    DataModel.TushTime = totalTime
    DataModel.RushServerTime = totalTime + TimeUtil:GetServerTimeStamp()
    local speed = PlayerData.GetTrainSpeed() + DataModel.speedPlus
    local time2 = -1
    local speed2 = -1
    DataModel.LightTime = nil
    local value1 = TrainWeaponTag.GetWeaponTagAttributes(EnumDefine.TrainWeaponTagEnum.TrainAddSpeedBuff)
    if value1[1] ~= nil then
      local value2 = PlayerData:GetFactoryData(value1[1], "TrainWeaponSkillFactory").randomConstant
      value2 = value2 + TrainWeaponTag.GetWeaponTagAttributes(EnumDefine.TrainWeaponTagEnum.LightingTimeAdd, 0)
      if 0 < value2 then
        local lightNetData = PlayerData:GetBatteryByID(83100033)
        if lightNetData then
          time2 = value2
          DataModel.LightTime = time2
          local citiao = PlayerData:GetFactoryData(85100099, "TrainWeaponSkillFactory")
          local valueA = citiao.aNumMinP + lightNetData.lv * citiao.aUpgradeRangeP
          speed2 = (speed + PlayerData:GetHomeInfo().readiness.fuel.acc_speed) * (1 + valueA)
        end
      end
    end
    KBTrainManager.train.movePart:Rush(speed, speed + PlayerData:GetHomeInfo().readiness.fuel.acc_speed, totalTime, speed2, time2)
    if DataModel.LightTime then
      Controller.RefreshTrainDetailAttrValue(View.Group_Common.Group_TrainOverview.Group_Overview.Img_Glass.Img_Base.Group_All.Txt_Num, speed2)
    else
      Controller.RefreshTrainDetailAttrValue(View.Group_Common.Group_TrainOverview.Group_Overview.Img_Glass.Img_Base.Group_All.Txt_Num, speed + PlayerData:GetHomeInfo().readiness.fuel.acc_speed)
    end
  end
  
  cb()
end

function Controller.TrainRushEnter()
  Controller.PlayTrainAnim("rush")
  local isHave = TrainWeaponTag.IsWeaponedById(83100032)
  View.Group_Common.Group_MB.Group_Lighting.self:SetActive(true)
  if isHave then
    local cfg = PlayerData:GetFactoryData(83100032, "HomeWeaponFactory")
    View.Group_Common.Group_MB.Group_Lighting:SetDynamicGameObject(cfg.specialEffects, 0, 0)
  end
  View.Group_Common.Group_MB.Group_Lighting:SetDynamicGameObject(DataModel.TrainRushEffectPath, 0, 0)
  if DataModel.LightTime then
    TrainEffectHelper:LoadSingleEffect(1, 11106473, true)
  end
end

function Controller.TrainRushDelay()
  View.Group_Common.Group_Running.Group_RushEffect.self:SetActive(true)
  View.Group_Common.Group_Running.Group_RushEffect:SetDynamicGameObject(DataModel.MainRushEffectPath, 0, 0)
  TrainEffectHelper:LoadEffect(1, TrainEffectHelper.Enum_TrainEffectType.SkinEffect, true)
  local Btn_Accelerate = View.Group_Common.Btn_Accelerate
  Btn_Accelerate.Group_Ing:SetActive(true)
  Btn_Accelerate.Group_Ing.Group_RushTime:SetDynamicGameObject(DataModel.RushTimeBtnEffectPath, 0, 0)
  Btn_Accelerate.Group_Ing.Group_RushBuyBtn:SetDynamicGameObject(DataModel.RushBuyBtnEffectPath, 0, 0)
  Btn_Accelerate.Group_Ing.Group_RushBuyBtn:SetActive(true)
  Btn_Accelerate.Group_On:SetActive(false)
  Btn_Accelerate.Group_Off:SetActive(false)
end

function Controller.TrainRushEnd()
  DataModel.hasRushClick = false
  DataModel.lastRushNum = nil
  Controller.RefreshFuel()
  View.Group_Common.Group_MB.Group_Lighting.self:SetActive(false)
  TrainEffectHelper:DisposeEffects(TrainEffectHelper.Enum_TrainEffectType.SkinEffect)
  View.Group_Common.Group_Running.Group_RushEffect.self:SetActive(false)
  View.Group_Common.Btn_Accelerate.Group_Ing:SetActive(false)
  Controller.PlayTrainAnim("rushover")
  View.Group_Common.Group_TrainOverview.Group_Overview.Img_Glass.Img_Base.Group_All.Txt_Num:SetText(PlayerData.GetTrainSpeed())
end

function Controller.OnRush(remainTime, rushTime)
  if DataModel.LightTime and rushTime - remainTime >= DataModel.LightTime then
    TrainEffectHelper:DisposeSingleEffects(11106473)
    DataModel.LightTime = nil
    local speed = math.ceil(KBTrainManager.train.movePart.rushSpeed1 * KBTrainManager.train.SpeedRatio)
    Controller.RefreshTrainDetailAttrValue(View.Group_Common.Group_TrainOverview.Group_Overview.Img_Glass.Img_Base.Group_All.Txt_Num, speed)
  end
  local Btn_Accelerate = View.Group_Common.Btn_Accelerate
  if 0 < remainTime then
    local number = math.floor(remainTime)
    if DataModel.lastRushNum == nil then
      Btn_Accelerate.Group_Ing.Txt_Time:SetText(string.format("%02d", number))
      Btn_Accelerate.Group_Ing.Txt_Time2:SetText(string.format("%02d", number))
      DataModel.lastRushNum = number
    end
    if number < 0 then
      number = 0
    end
    if number < DataModel.lastRushNum then
      View.self:SelectPlayAnim(Btn_Accelerate.Group_Ing.self, "RushTime", function()
        Btn_Accelerate.Group_Ing.Txt_Time:SetText(string.format("%02d", number))
        Btn_Accelerate.Group_Ing.Txt_Time2:SetText(string.format("%02d", number))
      end)
      DataModel.lastRushNum = number
    end
  end
end

function Controller.PlayTrainAnim(anime, speed)
  local trains = KBTrainManager.train.train
  if trains then
    for i = 0, trains.Length - 1 do
      local v = trains[i]
      if v.Skin then
        local homeCoachSkinCA = PlayerData:GetFactoryData(v.Skin.ca.id, "HomeCoachSkinFactory")
        if homeCoachSkinCA.animeRoot and homeCoachSkinCA.animeRoot ~= "" then
          local animeRoot = v.Skin.view.transform:Find(homeCoachSkinCA.animeRoot)
          if animeRoot ~= nil then
            local animator = animeRoot:GetComponentInChildren(typeof(CS.UnityEngine.Animator))
            if animator then
              animator:Play(anime)
            end
          end
        end
      end
    end
  end
end

function Controller.SetNoAmmoShow(state, force)
  if state then
    View.Group_Common.Group_battery.Group_Noammo:SetActive(true)
    if force then
      View.Group_Common.Group_battery.Group_Noammo.self:SelectPlayAnim("kabaneri_ui_noAmmunition_loop")
    else
      View.Group_Common.Group_battery.Group_Noammo.self:SelectPlayAnim("kabaneri_ui_noAmmunition")
    end
  elseif force then
    View.Group_Common.Group_battery.Group_Noammo:SetActive(false)
  else
    View.self:SelectPlayAnim(View.Group_Common.Group_battery.Group_Noammo.self, "kabaneri_ui_noAmmunition_over", function()
      View.Group_Common.Group_battery.Group_Noammo:SetActive(false)
      View.Group_Common.Group_battery.Group_Noammo.self:SetAlpha(1)
    end)
  end
end

function Controller.TrainAddMaterial(mPath)
  do return end
  if mPath == nil then
    return
  end
  local train = KBTrainManager.train.train[0].Skin.view
  local meshs = train:GetComponentsInChildren(typeof(CS.UnityEngine.Renderer))
  local len = meshs.Length - 1
  local genFunc = xlua.get_generic_method(CS.ResManager, "GetRes")
  local realFunc = genFunc(typeof(CS.UnityEngine.Material))
  local material = realFunc(ResManager, mPath, "#KabaneriTrain")
  for i = 0, len do
    local old = meshs[i].sharedMaterials
    local oldLength = old.Length
    local matArry = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Material), oldLength + 1)
    for j = 0, oldLength - 1 do
      matArry[j] = old[j]
    end
    matArry[oldLength] = material
    meshs[i].sharedMaterials = matArry
  end
end

function Controller.RemoveTrainMaterial()
  do return end
  local train = KBTrainManager.train.train[0].Skin.view
  local meshs = train:GetComponentsInChildren(typeof(CS.UnityEngine.Renderer))
  local len = meshs.Length - 1
  for i = 0, len do
    local old = meshs[i].sharedMaterials
    local oldLength = old.Length
    if 1 < oldLength then
      local matArry = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Material), oldLength - 1)
      for j = 0, oldLength - 2 do
        matArry[j] = old[j]
      end
      meshs[i].sharedMaterials = matArry
    elseif oldLength == 1 then
      meshs[i].sharedMaterials[0] = nil
    end
  end
end

function Controller.ClearData()
  Effect.RecycleAll()
  tempFollowAtkTime = 0
  followAtkTime = nil
  followExitTime = nil
  bossTakeDamage = 0
  lastShowSpeed = 0
  targetPlayerDir = 0
  lastSelectBuffGroup = n
  firstTrainSpline = nil
  curStaticMonster = nil
  DataModel.AtkStaticMonster = nil
  if curStaticMonHp then
    curStaticMonHp.follow = nil
    curStaticMonHp.gameObject:SetActive(false)
    curStaticMonHp = nil
  end
  ClearGunHitEffect()
end

function Controller.RecycleAll()
  local effetList = CS.FRef.getProperty(ParticleManager, "list")
  if effetList then
    for i = 0, effetList.Count - 1 do
      effetList[i]:SetParent(nil)
    end
  end
  Controller.ClearData()
  DataModel.Reset()
  TrainEffectHelper:Dispose()
  TrainBattleUnitManager:Clear()
  TrainBattleUnitManager:ReStart()
  TrainBattleUnitManager.unitsLoopArray:Clear()
  TrainBattleUnitManager.finder:Clear()
  TrainBattleUnitManager.baseUnitHp:Clear()
  TrainBattleUnitManager.colliderTrainBattleDic:Clear()
  KBEffectManager:RecycleAll()
  KBTrainManager.CameraCtrl.transform:SetParent(nil)
  KBTrainManager.CameraCtrl.transform.rotation = CS.UnityEngine.Quaternion.identity
  if KBTrainManager.train ~= nil and KBTrainManager.train.splineCtrls ~= nil then
    KBTrainManager.train:ReStart()
  end
  KBTrainManager.map.unitGroupCount:Clear()
  KBTrainManager.map.nextGridID = -1
  local curGridIndex = KBTrainManager.map.GridIndex
  KBTrainManager.map.GridIndex = 0
  KBTrainManager.map.GameRunningTime = 0
  KBTrainManager.map.atkParam = 0
  KBTrainManager.map:RemoveMapGrid(curGridIndex - 1)
  KBTrainManager.map:RemoveMapGrid(curGridIndex)
  KBTrainManager.map:RemoveMapGrid(curGridIndex + 1)
  KBTrainManager.poolCtrl:Dispose()
  KBTrainManager.map.nextGridID = -1
  KBTrainManager.gameTime = 0
  KBTrainManager.isGameStart = false
  Controller.ShowBossUI(false)
  KBTrainManager.train.View = nil
  KBTrainManager.train.Skins = nil
  KBTrainManager.train.Offset = nil
  KBTrainManager.train.firstTrain = nil
  KBTrainManager.train.lastTrain = nil
  KBTrainManager.train.splineCtrls = nil
  KBTrainManager.train.strike = nil
  if KBTrainManager.train.gun then
    KBTrainManager.train.gun:Recycle()
    KBTrainManager.train.gun = nil
  end
  if KBTrainManager.train.drill then
    KBTrainManager.train.drill:Recycle()
    KBTrainManager.train.drill = nil
  end
  local trains = KBTrainManager.train.train
  if trains then
    for i = 0, trains.Length - 1 do
      if trains[i] then
        trains[i]:Recycle()
      end
    end
    KBTrainManager.train.train = nil
  end
end

function Controller.DealSkillSpecialEvent(eventType, param1, param2, param3)
  if eventType == "CameraShake" then
    local dur = (param1 == nil or param1 == "") and 0.5 or tonumber(param1)
    local strengthX = (param2 == nil or param2 == "") and 1 or tonumber(param2)
    local strengthY = (param3 == nil or param3 == "") and 0.5 or tonumber(param3)
    KBTrainManager.CameraCtrl:Shake(dur, strengthX, strengthY)
  elseif eventType == "UnattachTrain" then
    if TrainBattleUnitManager.followMonster then
      TrainBattleUnitManager.followMonster.target = nil
    end
  elseif eventType == "ShowEffect" then
    if param1 == "Follow" then
      local effID = param2 ~= nil and param2 ~= "" and tonumber(param2) or nil
      if effID then
        Controller.FollowMonsterAddEffect(effID)
      end
    end
  elseif eventType == "CheckStaticMonster" then
    if KBTrainManager.train.gun and KBTrainManager.train.gun.target and KBTrainManager.train.gun.target.ca.mod == "MonsterUnit" then
      Controller.DoAttack(-3)
    end
  elseif eventType == "ClearEvent" then
    ClearGunHitEffect()
  end
end

return Controller
