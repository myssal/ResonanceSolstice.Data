local View = require("UIKabaneriMain/UIKabaneriMainView")
local DataModel = require("UIKabaneriMain/UIKabaneriMainDataModel")
local Controller = require("UIKabaneriMain/UIKabaneriMainController")
local CommonItem = require("Common/BtnItem")
local ViewFunction = {
  KabaneriMain_Group_Common_Btn_Return_Click = function(btn, str)
    Controller.Pause(true)
  end,
  KabaneriMain_Group_Common_Group_Pause_Btn_Exit_Click = function(btn, str)
    Controller.GameOverStopTrain(false)
  end,
  KabaneriMain_Group_Common_Group_Pause_Btn_Continue_Click = function(btn, str)
    Controller.Pause(false)
  end,
  KabaneriMain_Group_Common_Group_MB_Btn_Electric_Click = function(btn, str)
  end,
  KabaneriMain_Group_Over_Group_Btns_Btn_ReStartGame_Click = function(btn, str)
    local activityCA = PlayerData:GetFactoryData(PlayerData.TempCache.kbActivityId)
    local listCA = PlayerData:GetFactoryData(activityCA.gameList)
    local elementIndex = PlayerData.TempCache.kbLevelIndex + 1
    if tonumber(str) == 0 or elementIndex > #listCA.kabanerList then
      elementIndex = elementIndex - 1
    end
    local levelId = listCA.kabanerList[elementIndex].id
    local levelCA = PlayerData:GetFactoryData(levelId)
    
    local function DoLevelGo()
      local user_info = PlayerData:GetUserInfo()
      local isUseEnergy = levelCA.fatigueStart > 0
      if isUseEnergy then
        local homeCommon = require("Common/HomeCommon")
        local maxEnergy = homeCommon.GetMaxHomeEnergy()
        if maxEnergy - user_info.move_energy < levelCA.fatigueStart then
          CommonTips.OpenTips(80609767)
          return
        end
      end
      local isUseItem = 0 < #levelCA.itemCost
      if isUseItem then
        local itemInfo = levelCA.itemCost[1]
        if PlayerData:GetGoodsById(itemInfo.id).num < itemInfo.num then
          CommonTips.OpenTips(80609768)
          return
        end
      end
      local needRepair = 1
      
      local function isAutoRe()
        if PlayerData.ServerData.kabaneri ~= nil then
          return PlayerData.ServerData.kabaneri.auto_repair
        end
        return false
      end
      
      if PlayerData:GetHomeInfo().station_info.is_arrived == 0 or not isAutoRe() then
        needRepair = 0
      end
      Net:SendProto("battle.start_challenge", function(json)
        if isUseItem then
          local useItem = {}
          useItem[levelCA.itemCost[1].id] = levelCA.itemCost[1].num
          PlayerData:RefreshUseItems(useItem)
        end
        PlayerData.TempCache.KabaneriKID = json.kidUid
        PlayerData.TempCache.kbLevelIndex = elementIndex
        Controller.RecycleAll()
        Controller.Pause(false)
        Controller.ClearData()
        View.Group_Over:SetActive(false)
        local activityCA = PlayerData:GetFactoryData(PlayerData.TempCache.kbActivityId)
        local gameMainUIPath = string.nilorempty(activityCA.gamePrefabUrl) and "UI/Kabaneri/KabaneriMain" or activityCA.gamePrefabUrl
        LoadingManager:OpenLoading("UI/Kabaneri/KabaneriLoading", Json.encode({
          mapID = levelCA.id
        }), function()
          LoadingManager.loadingPercent = 1
          UIManager:Open(gameMainUIPath, Json.encode({
            mapID = levelCA.id
          }))
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
        CommonTips.OpenTips(80609766)
      end
    end
    
    local isOn = false
    if PlayerData.ServerData.kabaneri ~= nil then
      isOn = PlayerData.ServerData.kabaneri.auto_repair
    end
    if isOn then
      if PlayerData:GetHomeInfo().station_info.is_arrived == 0 then
        JudgeRepairGo()
      else
        local serverRepairInfo = PlayerData:GetHomeInfo().readiness.repair
        local maxDurable = PlayerData.GetCoachMaxDurability()
        local delta = maxDurable - serverRepairInfo.current_durable
        local homeConfig = PlayerData:GetFactoryData(99900014, "ConfigFactory")
        local costInfo = homeConfig.repairpriceList[1]
        local cost = delta * costInfo.num
        cost = math.floor(cost * (1 - PlayerData:GetHomeSkillIncrease(EnumDefine.HomeSkillEnum.ReduceRepairCost)) + 0.5)
        if cost <= PlayerData:GetGoodsById(costInfo.id).num then
          DoLevelGo()
        else
          JudgeRepairGo()
        end
      end
    else
      JudgeRepairGo()
    end
  end,
  KabaneriMain_Group_Common_Btn_Accelerate_Click = function(btn, str)
    Controller.TrainRush()
  end,
  KabaneriMain_Group_Common_Group_Gear_Btn_R_Click = function(btn, str)
    if DataModel.beReadyMulRoad ~= 2 or DataModel.hasRight then
      Controller.SetPlayerDirShow(-1)
      Controller.SelectBuff(-1)
    end
  end,
  KabaneriMain_Group_Over_Img_RewordBG_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  KabaneriMain_Group_Over_Img_RewordBG_ScrollGrid__SetGrid = function(element, elementIndex)
    CommonItem:SetItem(element, DataModel.rewards[elementIndex], EnumDefine.ItemType.Item)
  end,
  KabaneriMain_Group_Over_Img_RewordBG_ScrollGrid__Group_Item_Btn_Item_Click = function(btn, str)
  end,
  KabaneriMain_Group_Common_Group_Gear_Btn_M_Click = function(btn, str)
    if DataModel.beReadyMulRoad ~= 2 or DataModel.hasMiddle then
      Controller.SetPlayerDirShow(0)
      Controller.SelectBuff(0)
    end
  end,
  KabaneriMain_Group_Common_Group_Gear_Btn_L_Click = function(btn, str)
    if DataModel.beReadyMulRoad ~= 2 or DataModel.hasLeft then
      Controller.SetPlayerDirShow(1)
      Controller.SelectBuff(1)
    end
  end,
  KabaneriMain_Group_Common_Group_Pause_Btn_Close_Click = function(btn, str)
    Controller.Pause(false)
  end,
  KabaneriMain_Group_Common_Slider_Shoot_Slider = function(slider, value)
    if KBTrainManager == nil or KBTrainManager.train == nil or KBTrainManager.train.gun == nil then
      return
    end
    DataModel.DragGunSlider = true
    if value == 0 then
      KBTrainManager.train.gun.AIPart.DOAttack = false
      View.Group_Common.Slider_Shoot.Img_On:SetActive(false)
    elseif value == 1 then
      KBTrainManager.train.gun.AIPart.DOAttack = true
      View.Group_Common.Slider_Shoot.Img_On:SetActive(true)
      Controller.CheckCanAtkStaticMons()
    end
  end,
  KabaneriMain_Group_Common_Slider_Shoot_SliderDown = function(slider)
  end,
  KabaneriMain_Group_Common_Slider_Shoot_SliderUp = function(slider)
  end,
  KabaneriMain_Group_Over_Btn_Close_Click = function(btn, str)
  end,
  KabaneriMain_Group_ForkRoadWarn_Group_Buff_Group_Buff1_Btn_Buff1_Click = function(btn, str)
    Controller.SetPlayerDirShow(1)
    Controller.SelectBuff(1)
  end,
  KabaneriMain_Group_ForkRoadWarn_Group_Buff_Group_Buff2_Btn_Buff2_Click = function(btn, str)
    Controller.SetPlayerDirShow(0)
    Controller.SelectBuff(0)
  end,
  KabaneriMain_Group_ForkRoadWarn_Group_Buff_Group_Buff3_Btn_Buff3_Click = function(btn, str)
    Controller.SetPlayerDirShow(-1)
    Controller.SelectBuff(-1)
  end,
  KabaneriMain_Group_Common_Group_MB_Group_Buff_Btn_Close_Click = function(btn, str)
    Controller:CloseBuffTip()
  end,
  KabaneriMain_Group_Common_Group_MB_Group_Buff_Group_Item_Group_List_Img_IconBg_Btn_BuffIcon_Click = function(btn, str)
  end,
  KabaneriMain_Group_Common_Group_MB_Group_Buff_StaticGrid_List_SetGrid = function(element, elementIndex)
    Controller:RefreshTimeLimitBuffElement(element, elementIndex)
  end,
  KabaneriMain_Group_Common_Group_MB_Group_Buff_StaticGrid_List_Group_Item_Group_List_Img_IconBg_Btn_BuffIcon_Click = function(btn, str)
    Controller:ShowBuffTip(tonumber(str))
  end,
  KabaneriMain_Group_Over_Group_Btns_Btn_CloseGame_Click = function(btn, str)
    Controller.RecycleAll()
    Controller.Pause(false)
    View.Group_Over:SetActive(false)
    PlayerData.OpenKabSettlelemt(PlayerData.TempCache.kbActivityId, nil, PlayerData.TempCache.kbUIPath)
    TimerHelper.Stop("KBAutoGame")
    PlayerData.TempCache.kbIsAuto = false
  end,
  KabaneriMain_Group_Common_Group_TrainOverview_Btn_All_Click = function(btn, str)
    Controller.InitTrainDetailShow(true)
  end,
  KabaneriMain_Group_Common_Group_TrainOverview_Btn_CloseOverview_Click = function(btn, str)
    Controller.InitTrainDetailShow(false)
  end,
  KabaneriMain_Group_TrainOverview_Btn_All_Click = function(btn, str)
    Controller.InitTrainDetailShow(true)
  end,
  KabaneriMain_Group_TrainOverview_Btn_CloseOverview_Click = function(btn, str)
    Controller.InitTrainDetailShow(false)
  end,
  KabaneriMain_Group_Common_Group_MB_Group_Buff_ScrollGrid_List_SetGrid = function(element, elementIndex)
    Controller:RefreshTimeLimitBuffElement(element, elementIndex)
  end,
  KabaneriMain_Group_Common_Group_MB_Group_Buff_ScrollGrid_List_Group_Item_Group_List_Img_IconBg_Btn_BuffIcon_Click = function(btn, str)
  end,
  KabaneriMain_Group_Common_Group_MB_Group_Buff_ScrollGrid_List_Group_Item_Group_List_Btn_BuffIcon_Click = function(btn, str)
    Controller:ShowBuffTip(tonumber(str))
  end,
  KabaneriMain_Group_Common_Group_MB_Group_Buff_Img_BuffDesc_Btn_Close_Click = function(btn, str)
    Controller:CloseBuffTip()
  end
}
return ViewFunction
