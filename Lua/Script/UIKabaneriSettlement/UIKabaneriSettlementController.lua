local View = require("UIKabaneriSettlement/UIKabaneriSettlementView")
local DataModel = require("UIKabaneriSettlement/UIKabaneriSettlementDataModel")
local BtnItem = require("Common/BtnItem")
local Controller = {}

function Controller:Init(isInit)
  Controller:RefreshTrainFix()
  Controller:RefreshTrainOil()
  Controller:RefreshBattery()
  Controller:SetTrainOverViewShow(false)
  Controller:RefreshAutoFixShow()
  local activityCA = DataModel.activityCA
  local listCA = PlayerData:GetFactoryData(activityCA.gameList)
  if listCA == nil then
    return
  end
  local levelGrid = View.ScrollView_Select.Viewport.Content.Group_Select.Group_Level.StaticGrid_Level
  levelGrid.grid.self:SetDataCount(#listCA.kabanerList)
  levelGrid.grid.self:RefreshAllElement()
  if isInit then
    Controller:HideParamInfo()
  else
    Controller:ShowParamInfo(DataModel.curIndex)
  end
  if DataModel.initIndex ~= nil then
    Controller:ShowParamInfo(DataModel.initIndex)
  else
    PlayerData.TempCache.kabaneriAutoBattle = false
    View.Group_Open:SetActive(true)
    View.Group_Open.Img_OpenTxt:SetSprite(GetResPath(88300127))
    View.self:PlayAnimOnce("Group_Open", function()
      View.Group_Open:SetActive(false)
    end)
  end
  Controller:RefreshAutoBtn(PlayerData.TempCache.kabaneriAutoBattle)
  self:RefreshRemainTime()
  View.Group_CommonTopLeft.Btn_Home:SetActive(MainManager.bgSceneName ~= "Kabaneri")
end

function Controller:RefreshBattery()
  local weaponid = PlayerData.GetWeapon()
  if weaponid == nil then
    View.Group_readiness.Group_battery.Img_batteryIcon:SetActive(false)
    View.Group_readiness.Group_battery.Group_ammoNum.Img_NumBg.Txt_Num:SetText("--")
  else
    local weaponCA = PlayerData:GetFactoryData(weaponid.id)
    View.Group_readiness.Group_battery.Img_batteryIcon:SetActive(true)
    View.Group_readiness.Group_battery.Img_batteryIcon:SetSprite(weaponCA.imagePath)
    local realAmmo = 0
    realAmmo = realAmmo + PlayerData:GetGoodsById(82900168).num * 30
    View.Group_readiness.Group_battery.Group_ammoNum.Img_NumBg.Txt_Num:SetText(realAmmo)
  end
end

function Controller:RefreshTrainFix()
  local serverRepairInfo = PlayerData:GetHomeInfo().readiness.repair
  local maxDurable = PlayerData.GetCoachMaxDurability()
  View.Group_readiness.Img_Fixcircle.Txt_Durability:SetText(serverRepairInfo.current_durable .. "/" .. maxDurable)
  View.Group_readiness.Img_Fixcircle.Img_full:SetFilledImgAmount(serverRepairInfo.current_durable / maxDurable)
  local delta = maxDurable - serverRepairInfo.current_durable
  local homeConfig = PlayerData:GetFactoryData(99900014, "ConfigFactory")
  local costInfo = homeConfig.repairpriceList[1]
  local cost = delta * costInfo.num
  cost = math.floor(cost * (1 - PlayerData:GetHomeSkillIncrease(EnumDefine.HomeSkillEnum.ReduceRepairCost)) + 0.5)
  View.Group_readiness.Group_FixButton.Group_Money.Txt_Money:SetText(cost)
  View.Group_readiness.Group_FixButton.Group_Money:SetActive(maxDurable > serverRepairInfo.current_durable)
  View.Group_readiness.Group_FixButton.Btn_Fix.Group_Close:SetActive(maxDurable <= serverRepairInfo.current_durable)
  DataModel.CostId = costInfo.id
  DataModel.CostCache = cost
end

function Controller:RefreshTrainOil()
  local curCount = PlayerData:GetHomeInfo().readiness.fuel.fuel_num
  local maxCount = PlayerData.GetMaxFuelNum()
  View.Group_readiness.Img_Oilcircle.Img_full:SetFilledImgAmount(curCount / maxCount)
  View.Group_readiness.Img_Oilcircle.Txt_oilnum:SetText(curCount .. "/" .. maxCount)
  local initConfig = PlayerData:GetFactoryData(99900007, "ConfigFactory")
  local costInfo = initConfig.trainRushBuyList[1]
  local cost = (maxCount - curCount) * costInfo.num
  View.Group_readiness.Group_OilButton.Group_Money.Txt_Money:SetText(cost)
  View.Group_readiness.Group_OilButton.Group_Money:SetActive(curCount < maxCount)
  View.Group_readiness.Group_OilButton.Btn_Oil.Group_Close:SetActive(curCount >= maxCount)
  DataModel.CostIdOil = costInfo.id
  DataModel.CostCacheOil = cost
  DataModel.oilBuyCount = maxCount - curCount
end

function Controller:TryOpenCarriageEditor()
  if PlayerData:GetHomeInfo().station_info.is_arrived == 0 then
    CommonTips.OpenTips(80609868)
    return
  end
  Controller:RefreshAutoBtn(false)
  local funcCommon = require("Common/FuncCommon")
  if not funcCommon.FuncActiveCheck(108, true) then
    return
  end
  CommonTips.OpenToHomeCarriageeditor()
end

function Controller:IsAutoRepair()
  if PlayerData.ServerData.kabaneri ~= nil then
    return PlayerData.ServerData.kabaneri.auto_repair
  end
  return false
end

function Controller:RefreshAutoFixShow()
  local isOn = Controller:IsAutoRepair()
  View.Group_readiness.Btn_Button.Img_ON:SetActive(isOn)
  View.Group_readiness.Btn_Button.Img_OFF:SetActive(not isOn)
end

function Controller:AutoFix()
  local isOn = Controller:IsAutoRepair()
  local num = 1
  if isOn then
    num = 0
  end
  Net:SendProto("battle.auto_repair", function()
    if PlayerData.ServerData.kabaneri == nil then
      PlayerData.ServerData.kabaneri = {}
    end
    PlayerData.ServerData.kabaneri.auto_repair = num == 1 and true or false
    Controller:RefreshAutoFixShow()
  end, num)
end

function Controller:ConfirmRepair()
  if DataModel.CostCache == 0 then
    return
  end
  if PlayerData:GetHomeInfo().station_info.is_arrived == 0 then
    CommonTips.OpenTips(80609869)
    return
  end
  if PlayerData:GetHomeInfo().station_info.is_arrived == 0 then
    CommonTips.OpenTips(80609869)
    return
  end
  CommonTips.OnPrompt(string.format(GetText(80601024), DataModel.CostCache), nil, nil, function()
    Controller:TryRepair()
  end)
end

function Controller:TryRepair(cb)
  local costId = DataModel.CostId
  local cost = DataModel.CostCache
  if PlayerData:GetGoodsById(DataModel.CostId).num < DataModel.CostCache then
    CommonTips.OpenTips(80601025)
    return false
  end
  Net:SendProto("home.repair", function(json)
    SdkReporter.TrackTrainMaint({
      repair = 1,
      costId = costId,
      cost = cost
    })
    Controller:RefreshTrainFix()
    if cb ~= nil then
      cb()
    end
  end)
  return true
end

function Controller:ConfirmOil()
  if DataModel.CostCacheOil == 0 then
    return
  end
  if PlayerData:GetHomeInfo().station_info.is_arrived == 0 then
    CommonTips.OpenTips(80609870)
    return
  end
  if PlayerData:GetHomeInfo().station_info.is_arrived == 0 then
    CommonTips.OpenTips(80609870)
    return
  end
  CommonTips.OnPrompt(string.format(GetText(80601038), DataModel.CostCacheOil, DataModel.oilBuyCount), nil, nil, function()
    Controller:TryRefule()
  end)
end

function Controller:TryRefule(cb)
  if PlayerData:GetGoodsById(DataModel.CostIdOil).num < DataModel.CostCacheOil then
    CommonTips.OpenTips(80601025)
    return false
  end
  Net:SendProto("home.refuel", function(json)
    Controller:RefreshTrainOil()
    if cb ~= nil then
      cb()
    end
  end, DataModel.oilBuyCount)
  return true
end

function Controller:SetLevelGrid(element, elementIndex)
  local activityCA = DataModel.activityCA
  local listCA = PlayerData:GetFactoryData(activityCA.gameList)
  if listCA == nil then
    return
  end
  if elementIndex > #listCA.kabanerList then
    return
  end
  local levelId = listCA.kabanerList[elementIndex].id
  local levelCA = PlayerData:GetFactoryData(levelId, "KabaneriMapFactory")
  if levelCA == nil then
    return
  end
  local isLevelPass = Controller:IsLevelPass(levelId)
  element.Img_afootLevel:SetActive(isLevelPass)
  element.Btn_Select:SetActive(Controller:IsLevelOpen(elementIndex))
  element.Img_undownLevel:SetActive(Controller:IsLevelOpen(elementIndex))
  element.Txt_Name:SetActive(Controller:IsLevelOpen(elementIndex))
  if levelCA.levelId then
    element.Txt_Name:SetText(levelCA.levelId)
  end
  element.Img_NowLevel:SetActive(DataModel.curIndex == elementIndex)
  if DataModel.curIndex == elementIndex then
    local animator = element.transform.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
    animator:Play("StaticGrid_Level", 0, 0)
  end
  element.Btn_Select:SetClickParam(elementIndex)
end

function Controller:ShowParamInfo(str)
  if str == nil then
    Controller:HideParamInfo()
    return
  end
  local index = tonumber(str)
  if not Controller:IsLevelOpen(index) then
    return
  end
  local activityCA = DataModel.activityCA
  local listCA = PlayerData:GetFactoryData(activityCA.gameList)
  if listCA == nil then
    return
  end
  if index > #listCA.kabanerList then
    return
  end
  DataModel.curIndex = index
  local levelId = listCA.kabanerList[index].id
  local levelCA = PlayerData:GetFactoryData(levelId, "KabaneriMapFactory")
  if levelCA == nil then
    return
  end
  View.Group_Right:SetActive(true)
  View.self:PlayAnimOnce("Group_Right")
  if levelCA.levelId then
    View.Group_Right.Img_infoPath.Txt_LevelId:SetText(levelCA.levelId)
  end
  if levelCA.levelName then
    View.Group_Right.Img_infoPath.Group_Info.Txt_Name:SetText(levelCA.levelName)
  end
  local rewardList = levelCA.completeAwardS
  View.Group_Right.Img_infoPath.Group_Drop.ScrollGrid_Item.grid.self:SetDataCount(#rewardList)
  View.Group_Right.Img_infoPath.Group_Drop.ScrollGrid_Item.grid.self:RefreshAllElement()
  View.Group_Right.Img_infoPath.Group_Drop.ScrollGrid_Item.grid.self:MoveToTop()
  View.Group_Right.Img_infoPath.Group_Fight.Btn_StartFight.Group_Energy:SetActive(true)
  View.Group_Right.Img_infoPath.Group_Fight.Btn_StartFight.Group_Energy.Txt_Cost:SetText("+" .. levelCA.fatigueStart)
  local isUseItem = #levelCA.itemCost > 0
  View.Group_Right.Img_infoPath.Group_Fight.Btn_StartFight.Group_Item:SetActive(isUseItem)
  View.Group_Right.Img_infoPath.Group_Cost.Group_Item:SetActive(isUseItem)
  if isUseItem then
    local itemInfo = levelCA.itemCost[1]
    local itemCA = PlayerData:GetFactoryData(itemInfo.id)
    View.Group_Right.Img_infoPath.Group_Fight.Btn_StartFight.Group_Item.Img_Icon:SetSprite(itemCA.iconPath)
    View.Group_Right.Img_infoPath.Group_Fight.Btn_StartFight.Group_Item.Txt_Cost:SetText("-" .. itemInfo.num)
    View.Group_Right.Img_infoPath.Group_Cost.Group_Item.Img_Icon:SetSprite(itemCA.iconPath)
    View.Group_Right.Img_infoPath.Group_Cost.Group_Item.Txt_Num:SetText(PlayerData:GetGoodsById(itemInfo.id).num)
  end
  View.Group_Right.Img_infoPath.Group_Auto:SetActive(Controller:IsLevelPass(levelId))
  Controller:UpdateEnergy()
  View.Group_Right.Img_infoPath.Group_WinDes.Txt_Desc:SetText(string.format(GetText(80609593), levelCA.gameTime))
end

function Controller:SetLevelRewardGrid(element, elementIndex)
  local activityCA = DataModel.activityCA
  local listCA = PlayerData:GetFactoryData(activityCA.gameList)
  if listCA == nil then
    return
  end
  local index = DataModel.curIndex
  local levelId = listCA.kabanerList[index].id
  local levelCA = PlayerData:GetFactoryData(levelId, "KabaneriMapFactory")
  if levelCA == nil then
    return
  end
  local rewardList = levelCA.completeAwardS
  local info = rewardList[elementIndex]
  BtnItem:SetItem(element.Group_Item, {
    id = info.id,
    num = info.num
  })
  element.Group_Item.Btn_Item:SetClickParam(info.id)
end

function Controller:HideParamInfo()
  DataModel.curIndex = nil
  View.Group_Right:SetActive(false)
end

function Controller:IsLevelPass(levelId)
  if PlayerData.ServerData.kabaneri ~= nil and PlayerData.ServerData.kabaneri.kab_level ~= nil then
    for k, v in pairs(PlayerData.ServerData.kabaneri.kab_level) do
      if tonumber(k) == tonumber(levelId) then
        return true
      end
    end
  end
  return false
end

function Controller:IsLevelOpen(levelIndex)
  local activityCA = DataModel.activityCA
  local listCA = PlayerData:GetFactoryData(activityCA.gameList)
  if listCA == nil then
    return false
  end
  return levelIndex <= 1 or Controller:IsLevelPass(listCA.kabanerList[levelIndex - 1].id)
end

function Controller:TryLevelGo(isAuto)
  local activityCA = DataModel.activityCA
  local listCA = PlayerData:GetFactoryData(activityCA.gameList)
  if listCA == nil then
    return
  end
  local elementIndex = DataModel.curIndex
  if elementIndex == nil or elementIndex > #listCA.kabanerList then
    return
  end
  local levelId = listCA.kabanerList[elementIndex].id
  local levelCA = PlayerData:GetFactoryData(levelId)
  if levelCA == nil then
    return
  end
  
  local function DoLevelGo()
    local user_info = PlayerData:GetUserInfo()
    local isUseEnergy = levelCA.fatigueStart > 0
    if isUseEnergy then
      local homeCommon = require("Common/HomeCommon")
      local maxEnergy = homeCommon.GetMaxHomeEnergy()
      if maxEnergy - user_info.move_energy < levelCA.fatigueStart then
        Controller:RefreshAutoBtn(false)
        CommonTips.OpenTips(80609767)
        return
      end
    end
    local isUseItem = 0 < #levelCA.itemCost
    if isUseItem then
      local itemInfo = levelCA.itemCost[1]
      if PlayerData:GetGoodsById(itemInfo.id).num < itemInfo.num then
        Controller:RefreshAutoBtn(false)
        CommonTips.OpenTips(80609768)
        return
      end
    end
    local needRepair = 1
    if PlayerData:GetHomeInfo().station_info.is_arrived == 0 or not Controller:IsAutoRepair() then
      needRepair = 0
    end
    Net:SendProto("battle.start_challenge", function(json)
      local useItem = {}
      useItem[levelCA.itemCost[1].id] = levelCA.itemCost[1].num
      PlayerData:RefreshUseItems(useItem)
      PlayerData.TempCache.KabaneriKID = json.kidUid
      PlayerData.TempCache.fromScene = MainManager.bgSceneName
      PlayerData.TempCache.kbActivityId = DataModel.activityCA.id
      PlayerData.TempCache.kbIsAuto = isAuto
      PlayerData.TempCache.kbLevelIndex = elementIndex
      PlayerData.TempCache.kbUIPath = nil
      local gameMainUIPath = string.nilorempty(DataModel.activityCA.gamePrefabUrl) and "UI/Kabaneri/KabaneriMain" or DataModel.activityCA.gamePrefabUrl
      LoadingManager:OpenLoading("UI/Kabaneri/KabaneriLoading", Json.encode({
        mapID = levelCA.id
      }), function()
        if MainManager.bgSceneName == "Kabaneri" then
          LoadingManager.loadingPercent = 1
          UIManager:Open(gameMainUIPath, Json.encode({
            mapID = levelCA.id,
            activityId = DataModel.activityCA.id
          }))
          return
        else
          SafeReleaseScene(false)
          CBus:ChangeScene("Kabaneri", function()
            UIManager:Open(gameMainUIPath, Json.encode({
              mapID = levelCA.id,
              activityId = DataModel.activityCA.id
            }))
          end)
        end
      end)
    end, levelCA.id, needRepair)
  end
  
  local function JudgeTrainRepair()
    local serverRepairInfo = PlayerData:GetHomeInfo().readiness.repair
    if serverRepairInfo.current_durable <= 0 then
      return false
    end
    return true
  end
  
  local function JudgeRepairGo()
    if JudgeTrainRepair() then
      DoLevelGo()
    else
      Controller:RefreshAutoBtn(false)
      CommonTips.OpenTips(80609766)
    end
  end
  
  local isOn = Controller:IsAutoRepair()
  if isOn then
    if PlayerData:GetHomeInfo().station_info.is_arrived == 0 then
      if isAuto ~= true then
        CommonTips.OnPrompt(80609852, "80600068", "80600067", function()
          JudgeRepairGo()
        end)
      else
        JudgeRepairGo()
      end
    elseif PlayerData:GetGoodsById(DataModel.CostId).num >= DataModel.CostCache then
      DoLevelGo()
    elseif isAuto ~= true then
      CommonTips.OnPrompt(80609852, "80600068", "80600067", function()
        JudgeRepairGo()
      end)
    else
      JudgeRepairGo()
    end
  else
    JudgeRepairGo()
  end
end

function Controller:SetTrainOverViewShow(isShow)
  View.Group_TrainOverview.Group_Overview.self:SetActive(isShow)
  if isShow then
    View.self:PlayAnimOnce("Group_TrainOverview")
    local stirkePower = TrainWeaponTag.GetWeaponTagAttributes(EnumDefine.TrainWeaponTagEnum.TrainWeaponImpact, 0)
    View.Group_TrainOverview.Group_Overview.Img_Glass.Img_Base.Group_Impact.Txt_Num:SetText(stirkePower)
    local gunAtk = TrainWeaponTag.GetWeaponTagAttributes(EnumDefine.TrainWeaponTagEnum.TrainWeaponAtk)[2]
    View.Group_TrainOverview.Group_Overview.Img_Glass.Img_Base.Group_Firepower.Txt_Num:SetText(math.floor(gunAtk))
    local trainDataModel = require("UIKabaneriMain/UIKabaneriMainDataModel")
    local armor = trainDataModel.GetTrainArmor()
    View.Group_TrainOverview.Group_Overview.Img_Glass.Img_Base.Group_Armor.Txt_Num:SetText(math.floor(armor))
    View.Group_TrainOverview.Group_Overview.Img_Glass.Img_Base.Group_All.Txt_Num:SetText(PlayerData.GetTrainSpeed())
  end
end

function Controller:UpdateEnergy()
  local user_info = PlayerData:GetUserInfo()
  local currEnergy = user_info.move_energy
  local homeCommon = require("Common/HomeCommon")
  local maxEnergy = homeCommon.GetMaxHomeEnergy()
  View.Group_Right.Img_infoPath.Group_Cost.Btn_Energy.Txt_Num:SetText(currEnergy .. "/" .. (maxEnergy or 0))
end

function Controller:OpenEnergyBuy()
  Controller:RefreshAutoBtn(false)
  local homeCommon = require("Common/HomeCommon")
  homeCommon.OpenMoveEnergyUseItem(function()
    Controller:UpdateEnergy()
  end)
end

function Controller:OnClickBtnAuto()
  local activityCA = DataModel.activityCA
  local listCA = PlayerData:GetFactoryData(activityCA.gameList)
  if listCA == nil then
    return
  end
  local elementIndex = DataModel.curIndex
  if elementIndex > #listCA.kabanerList then
    return
  end
  local levelId = listCA.kabanerList[elementIndex].id
  if not Controller:IsLevelPass(levelId) then
    return
  end
  local isAutoRepair = Controller:IsAutoRepair()
  if isAutoRepair and PlayerData:GetHomeInfo().station_info.is_arrived == 0 then
    CommonTips.OnPrompt(80609852, "80600068", "80600067", function()
      DataModel.remainAutoBattleTime = DataModel.constAutoBattleTime
      Controller:RefreshAutoBtn(not PlayerData.TempCache.kabaneriAutoBattle)
      self:RefreshRemainTime()
    end)
    return
  end
  DataModel.remainAutoBattleTime = DataModel.constAutoBattleTime
  Controller:RefreshAutoBtn(not PlayerData.TempCache.kabaneriAutoBattle)
  self:RefreshRemainTime()
end

function Controller:RefreshAutoBtn(isAuto)
  PlayerData.TempCache.kabaneriAutoBattle = isAuto
  DataModel.kabaneriAutoBattle = PlayerData.TempCache.kabaneriAutoBattle
  View.Group_Right.Img_infoPath.Group_Auto.Btn_Auto.Group_Off.self:SetActive(not DataModel.kabaneriAutoBattle)
  View.Group_Right.Img_infoPath.Group_Auto.Btn_Auto.Group_On.self:SetActive(DataModel.kabaneriAutoBattle)
  View.Group_Right.Img_infoPath.Group_Auto.Img_Time:SetActive(DataModel.kabaneriAutoBattle)
end

function Controller:RefreshRemainTime()
  if DataModel.remainAutoBattleTime <= 0 then
    DataModel.kabaneriAutoBattle = false
    DataModel.remainAutoBattleTime = DataModel.constAutoBattleTime
    Controller:TryLevelGo(true)
    return
  end
  View.Group_Right.Img_infoPath.Group_Auto.Img_Time.Txt_Time:SetText(string.format(GetText(80607112), math.ceil(DataModel.remainAutoBattleTime)))
end

return Controller
