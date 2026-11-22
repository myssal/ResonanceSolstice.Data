local View = require("UIWitchesEnemy/UIWitchesEnemyView")
local DataModel = {}
DataModel.eventId = nil
DataModel.levelId = nil
DataModel.dropList = {}

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.eventId = data.eventId
end

function DataModel.InitData()
  local eventId = DataModel.eventId
  local eventCA = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
  local mod = eventCA.mod
  local levelId
  if mod == "\233\173\148\229\165\179\230\136\152\230\150\151\229\175\185\232\175\157" then
    levelId = eventCA.levelID
  elseif mod == "\233\173\148\229\165\179\232\191\158\230\136\152\228\186\148\229\133\179" then
    local witchesData = WitchData.GetWitchesData()
    local eventStrInfo
    if witchesData.end_events and table.count(witchesData.end_events) > 0 then
      eventStrInfo = witchesData.end_events[table.count(witchesData.end_events)]
    else
      eventStrInfo = witchesData.start_id
    end
    local split = string.split(eventStrInfo, ":")
    if #split == 1 then
      levelId = eventCA.levelIDList[1].id
    elseif #split == 3 then
      local curLevelIndex = tonumber(split[2]) + 1
      levelId = eventCA.levelIDList[curLevelIndex + 1].id
    end
  end
  DataModel.levelId = levelId
  local levelCA = PlayerData:GetFactoryData(levelId, "LevelFactory")
  DataModel.dropList = PlayerData:GetLevelDropList(levelCA)
end

function DataModel.RefreshOnShow()
  local eventId = DataModel.eventId
  local levelId = DataModel.levelId
  DataModel.RefreshLevel(eventId, levelId)
  View.Group_Stamina.Txt_Num:SetText(WitchData.GetStamina() .. "/" .. WitchData.GetStaminaMax())
  View.Group_Coin.Txt_Num:SetText(WitchData.GetCoin())
  local energy_content = string.format("%d/%d", PlayerData:GetUserInfo().energy, PlayerData:GetUserInfo().max_energy)
  View.Group_Energy.Txt_Num:SetText(energy_content)
  local gridData = WitchData.GetGridData(WitchData.GetGridId())
  local gridEventCA = PlayerData:GetFactoryData(gridData.event, "MonopolyEventFactory")
  local path = gridEventCA.belongArchi[1] and gridEventCA.belongArchi[1].archiPath
  if not string.nilorempty(path) then
    View.Img_LeftBG.Img_Building:SetSprite(path)
  end
  local gukaDataModel = require("UIGuKa/UIGuKaDataModel")
  local showRedPoint = gukaDataModel.CheckGuKaRedPoint()
  View.Btn_Guka.Img_RedPoint:SetActive(showRedPoint)
end

function DataModel.RefreshLevel(eventId, levelId)
  local eventCA = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
  local levelCA = PlayerData:GetFactoryData(levelId, "LevelFactory")
  local unitCA = PlayerData:GetFactoryData(levelCA.bossId, "UnitFactory")
  local isBoss = eventCA.battleType == "Boss"
  View.Img_RightBG.Img_Info:SetActive(not isBoss)
  View.Img_RightBG.Img_Btn_Common:SetActive(not isBoss)
  View.Img_RightBG.Btn_Fight:SetActive(not isBoss)
  View.Img_RightBG.Btn_Fight.Btn_FastPass:SetActive(not isBoss)
  View.Img_RightBG.Img_BossInfo:SetActive(isBoss)
  View.Img_RightBG.Btn_Boss:SetActive(isBoss)
  View.Img_Mask:SetActive(isBoss)
  View.Img_RightBG.Img_TxtBG.Txt_Des:SetText(levelCA.description)
  local scale = eventCA.levelScale
  View.Img_LeftBG.Img_Pedestal.Group_Live.Spine_Box:SetActive(false)
  View.Img_LeftBG.Img_Pedestal.Group_Live.Spine_Box:SetAnchoredPosition(Vector2(eventCA.levelPosX, eventCA.levelPosY))
  View.Img_LeftBG.Img_Pedestal.Group_Live.Spine_Box:SetLocalScale(Vector3(scale, scale, 1))
  local unitViewCA = PlayerData:GetFactoryData(unitCA.viewId, "UnitViewFactory")
  View.Img_LeftBG.Img_Pedestal.Group_Live.Spine_Box:SetData(unitViewCA.resDir, "stand")
  View.self:StartC(LuaUtil.cs_generator(function()
    coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
    View.Img_LeftBG.Img_Pedestal.Group_Live.Spine_Box:SetActive(true)
  end))
  local level = levelCA.recomGrade
  local gridCA = PlayerData:GetFactoryData(WitchData.GetGridId(), "ParkGridFactory")
  if gridCA.levelParam ~= -1 then
    level = gridCA.levelParam + PlayerData:GetUserInfo().lv
  end
  if isBoss then
    View.Img_RightBG.Img_BossInfo.Txt_Name:SetText(unitCA.name)
    View.Img_RightBG.Img_BossInfo.Img_Lv.Txt_LV:SetText(string.format(GetText(80609744), level))
    View.Img_RightBG.Btn_Boss.Img_Cost.Txt_Cost:SetText(levelCA.energyEnd)
  else
    View.Img_RightBG.Img_Info.Txt_Name:SetText(unitCA.name)
    View.Img_RightBG.Img_Info.Img_Lv.Txt_LV:SetText(string.format(GetText(80609744), level))
    View.Img_RightBG.Btn_Fight.Img_Cost.Txt_Cost:SetText(levelCA.energyEnd)
    local timeLimit = levelCA.timeLimit
    View.Img_RightBG.Img_Info.Txt_Time:SetActive(0 < timeLimit)
    if 0 < timeLimit then
      View.Img_RightBG.Img_Info.Txt_Time:SetActive(string.format(GetText(80610392), timeLimit / 3600))
    end
  end
  View.Btn_Rank:SetActive(isBoss)
  View.Img_RightBG.Img_BossRank:SetActive(isBoss)
  if isBoss then
    View.Img_RightBG.Img_BossRank.Txt_Num:SetText(WitchData.GetHistoryBossDamageMax())
  end
  View.Group_CommonTopLeft.Btn_Return:SetActive(not isBoss)
  View.Img_RightBG.Img_FightRewards.ScrollGrid_Reward.grid.self:SetDataCount(#DataModel.dropList)
  View.Img_RightBG.Img_FightRewards.ScrollGrid_Reward.grid.self:RefreshAllElement()
  local showFive = eventCA.mod == "\233\173\148\229\165\179\232\191\158\230\136\152\228\186\148\229\133\179"
  View.Img_RightBG.Btn_Fight.Group_Five:SetActive(showFive)
  if showFive then
    local index = 1
    for i, v in ipairs(eventCA.levelIDList) do
      if v.id == levelId then
        index = i
      end
    end
    View.Img_RightBG.Btn_Fight.Group_Five.Txt_Five:SetText(string.format(GetText(80610210), index, #eventCA.levelIDList))
  end
end

function DataModel.GoToFight()
  local eventId = DataModel.eventId
  local levelId = DataModel.levelId
  if CommonTips.OpenBuyEnergyTips(levelId) then
    return
  end
  local buffList = {}
  local witchesData = WitchData.GetWitchesData()
  local eventCA = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
  local ticketItemCA = PlayerData:GetFactoryData(witchesData.ticket_id, "ItemFactory")
  if ticketItemCA.mod == "\233\187\145\230\156\136\230\184\184\228\185\144\229\159\142\233\129\147\229\133\183" and ticketItemCA.parkItemType == "buffTicket" then
    local info = ticketItemCA.ticketBuff and ticketItemCA.ticketBuff[1]
    if info and info.buffType == "client" then
      table.insert(buffList, tostring(info.id))
    end
  end
  local restBuff = WitchData.GetRestBuffData()
  if not string.nilorempty(restBuff) then
    table.insert(buffList, restBuff)
  end
  local UIWitchMainDataModel = require("UIWitchMain/UIWitchMainDataModel")
  UIWitchMainDataModel.InitSealEffectData()
  local sealBuff = UIWitchMainDataModel.GetSealEffect()
  for i, v in pairs(sealBuff) do
    local cfg = PlayerData:GetFactoryData(v)
    if cfg.typeInfo == "A" then
      table.insert(buffList, tostring(cfg.skillId))
    else
      table.insert(buffList, tostring(cfg.combineSkillId))
    end
  end
  local GuKaDataModel = require("UIGuKa/UIGuKaDataModel")
  local gukaBuff = GuKaDataModel.GetGuKaBuffList()
  for i, v in pairs(gukaBuff) do
    local skillCA = PlayerData:GetFactoryData(i)
    local skillStr = tostring(i)
    if skillCA.mod == "\233\154\143\230\156\186\229\177\158\230\128\167\230\138\128\232\131\189" then
      skillStr = skillStr .. "," .. skillCA.tagName .. "," .. tostring((v - 1) * skillCA.digitSN + skillCA.minAttrSN)
    end
    table.insert(buffList, skillStr)
  end
  local enemyLevel
  local gridId = WitchData.GetGridId()
  local gridCA = PlayerData:GetFactoryData(gridId, "ParkGridFactory")
  if gridCA.levelParam ~= -1 then
    enemyLevel = PlayerData:GetUserInfo().lv + gridCA.levelParam
  end
  local status = {
    levelId = levelId,
    dialogId = eventId,
    activityId = WitchData.GetActivityId(),
    Current = "Chapter",
    headerExtraSkill = table.concat(buffList, "|"),
    enemyLevel = enemyLevel
  }
  status.extraUIParamData = {
    scene = WitchData.GetSceneName(),
    isWitchBattle = 1,
    backSceneName = UIWitchMainDataModel.backSceneName,
    backUI = UIWitchMainDataModel.backUI,
    backUIParams = UIWitchMainDataModel.backUIParams,
    witchBattleType = eventCA.battleType,
    witchSettleAccountPath = WitchData.GetUIPath("UI/Witches/Main/SettleAccount")
  }
  PlayerData.BattleCallBackPage = WitchData.GetUIPath("UI/Witches/Main/WitchMain")
  UIManager:Open("UI/Squads/Squads", Json.encode(status))
end

function DataModel.FastPassBattle()
  local squad = PlayerData.ServerData.squad[1]
  local roles = squad and squad.role_list
  if not roles or table.count(roles) == 0 then
    CommonTips.OpenTips(80611441)
    return
  end
  local parkMapCA = WitchData.GetParkMapCA()
  local fastPassItemId = parkMapCA.fastpassBattleItem
  local fastPassItemCA = PlayerData:GetFactoryData(fastPassItemId)
  local eventId = DataModel.eventId
  local levelId = DataModel.levelId
  local levelCA = PlayerData:GetFactoryData(levelId, "LevelFactory")
  local eventCA = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
  local mod = eventCA.mod
  if levelCA.mod == "\230\151\160\229\176\189\229\133\179\229\141\161" then
    CommonTips.OpenWitchTip(80610452)
    return
  end
  
  local function cb(json)
    local function yesFun()
      if mod == "\233\173\148\229\165\179\230\136\152\230\150\151\229\175\185\232\175\157" then
        UIManager:GoBack()
        
        eventId = eventCA.sucid
        local PlayerController = require("UIWitchMain/UIWitchMainPlayerController")
        PlayerController.DealEvent(eventId)
      elseif mod == "\233\173\148\229\165\179\232\191\158\230\136\152\228\186\148\229\133\179" then
        if levelId == eventCA.levelIDList[#eventCA.levelIDList].id then
          UIManager:GoBack()
          eventId = eventCA.sucid
          local PlayerController = require("UIWitchMain/UIWitchMainPlayerController")
          PlayerController.DealEvent(eventId)
        else
          local index = 1
          for i, v in ipairs(eventCA.levelIDList) do
            if v.id == levelId then
              index = i
              break
            end
          end
          levelId = eventCA.levelIDList[index + 1].id
          DataModel.levelId = levelId
          DataModel.RefreshLevel(eventId, levelId)
        end
      end
    end
    
    if json.reward and table.count(json.reward) > 0 then
      CommonTips.OpenShowItem(json.reward, yesFun)
    else
      yesFun()
    end
    View.Group_Stamina.Txt_Num:SetText(WitchData.GetStamina() .. "/" .. WitchData.GetStaminaMax())
    View.Group_Coin.Txt_Num:SetText(WitchData.GetCoin())
    local energy_content = string.format("%d/%d", PlayerData:GetUserInfo().energy, PlayerData:GetUserInfo().max_energy)
    View.Group_Energy.Txt_Num:SetText(energy_content)
  end
  
  local useItemId
  local num = WitchData.GetItemNumById(fastPassItemId)
  if num == 0 then
    local itemId = 11400716
    num = WitchData.GetItemNumById(itemId)
    if num == 0 then
      local buyFastPassItemInfo = parkMapCA.fastpassBattleItemCostList[1]
      local costItemId = buyFastPassItemInfo.id
      local haveNum = WitchData.GetItemNumById(costItemId)
      local costItemCA = PlayerData:GetFactoryData(costItemId)
      local costNum = buyFastPassItemInfo.num
      
      local function yesFun()
        if haveNum < costNum then
          CommonTips.OpenWitchTip(80600488)
          return
        end
        WitchData.ReqBuyAndUseFastPassItem(fastPassItemCA.playerParkItemType, eventId, levelId, cb)
      end
      
      CommonTips.OpenWitchPrompt(string.format(GetText(80610639), costNum, costItemCA.name, fastPassItemCA.name), nil, nil, yesFun)
    else
      useItemId = itemId
    end
  else
    useItemId = fastPassItemId
  end
  if useItemId then
    local function yesFun()
      WitchData.ReqUseFastPassItem(useItemId, 1, eventId, levelId, cb)
    end
    
    local useItemCA = PlayerData:GetFactoryData(useItemId, "ItemFactory")
    CommonTips.OpenWitchPrompt(string.format(GetText(80610454), useItemCA.name), nil, nil, yesFun)
  end
end

function DataModel.GiveUpBattle()
  local eventId = DataModel.eventId
  local levelId = DataModel.levelId
  local eventCA = PlayerData:GetFactoryData(eventId, "MonopolyEventFactory")
  
  local function cb(json)
    local function closeSealCallBack()
      if eventCA.failid > 0 then
        local PlayerController = require("UIWitchMain/UIWitchMainPlayerController")
        
        PlayerController.DealEvent(eventCA.failid)
      end
    end
    
    if json.reward then
      local sealId = WitchData.GetSealReward(json.reward)
      if sealId then
        WitchData.OpenShowItem(json.reward, closeSealCallBack)
      else
        CommonTips.OpenShowItem(json.reward)
        closeSealCallBack()
      end
    else
      closeSealCallBack()
    end
  end
  
  WitchData.ReqGiveUpBattle(eventId, levelId, cb)
  View.self:CloseUI()
end

return DataModel
