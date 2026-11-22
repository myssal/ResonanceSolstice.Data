local TrainWeaponTag = {}
local WeaponTag2Enum = {
  [12600349] = EnumDefine.TrainWeaponTagEnum.ElectricCost,
  [12600368] = EnumDefine.TrainWeaponTagEnum.TrainSpeed,
  [12600708] = EnumDefine.TrainWeaponTagEnum.TrainSpeed,
  [12600361] = EnumDefine.TrainWeaponTagEnum.TrainSpeed,
  [12600711] = EnumDefine.TrainWeaponTagEnum.RiseSpaceLimited,
  [12600828] = EnumDefine.TrainWeaponTagEnum.RushSpeed,
  [12600371] = EnumDefine.TrainWeaponTagEnum.RiseRushLimited,
  [12600370] = EnumDefine.TrainWeaponTagEnum.RiseRushUseTime,
  [12600351] = EnumDefine.TrainWeaponTagEnum.RiseDurabilityLimited,
  [12600359] = EnumDefine.TrainWeaponTagEnum.RiseDurabilityLimited,
  [12600348] = EnumDefine.TrainWeaponTagEnum.AddColoudness,
  [12600831] = EnumDefine.TrainWeaponTagEnum.AddColoudness,
  [12601369] = EnumDefine.TrainWeaponTagEnum.AddColoudness,
  [12600344] = EnumDefine.TrainWeaponTagEnum.AddDeterrence,
  [12600832] = EnumDefine.TrainWeaponTagEnum.AddDeterrence,
  [12600350] = EnumDefine.TrainWeaponTagEnum.TrainHP,
  [12600829] = EnumDefine.TrainWeaponTagEnum.PassengerNum,
  [12600696] = EnumDefine.TrainWeaponTagEnum.TrainStartAddSpeed,
  [12600706] = EnumDefine.TrainWeaponTagEnum.TrainStoptAddSpeed,
  [12601296] = EnumDefine.TrainWeaponTagEnum.TrainStartAddSpeed,
  [12601295] = EnumDefine.TrainWeaponTagEnum.TrainStoptAddSpeed,
  [12600363] = EnumDefine.TrainWeaponTagEnum.MonsterClickDistance,
  [12600407] = EnumDefine.TrainWeaponTagEnum.BoxClickDistance,
  [12600345] = EnumDefine.TrainWeaponTagEnum.TrainWeaponImpact,
  [12600862] = EnumDefine.TrainWeaponTagEnum.TrainWeaponDurability,
  [12600709] = EnumDefine.TrainWeaponTagEnum.TrainAddSpeedBuff,
  [12600707] = EnumDefine.TrainWeaponTagEnum.TrainAddSpeedBuff,
  [12600365] = EnumDefine.TrainWeaponTagEnum.AutoPickGoods,
  [12600830] = EnumDefine.TrainWeaponTagEnum.TrainBattleBuff,
  [12601063] = EnumDefine.TrainWeaponTagEnum.TrainBattleBuff,
  [12601064] = EnumDefine.TrainWeaponTagEnum.TrainBattleBuff,
  [12601065] = EnumDefine.TrainWeaponTagEnum.TrainBattleBuff,
  [12601066] = EnumDefine.TrainWeaponTagEnum.TrainBattleBuff,
  [12601067] = EnumDefine.TrainWeaponTagEnum.TrainBattleBuff,
  [12600360] = EnumDefine.TrainWeaponTagEnum.TrainBattleBuff,
  [12601068] = EnumDefine.TrainWeaponTagEnum.TrainBattleBuff,
  [12600160] = EnumDefine.TrainWeaponTagEnum.TrainBattleBuff,
  [12600582] = EnumDefine.TrainWeaponTagEnum.TrainBattleBuff,
  [12600823] = EnumDefine.TrainWeaponTagEnum.TrainBattleBuff,
  [12600874] = EnumDefine.TrainWeaponTagEnum.TrainBattleBuff,
  [12600875] = EnumDefine.TrainWeaponTagEnum.TrainBattleBuff,
  [12600876] = EnumDefine.TrainWeaponTagEnum.TrainBattleBuff,
  [12600877] = EnumDefine.TrainWeaponTagEnum.TrainBattleBuff,
  [12601132] = EnumDefine.TrainWeaponTagEnum.TrainBattleBuff,
  [12601193] = EnumDefine.TrainWeaponTagEnum.TrainBattleBuff,
  [12601360] = EnumDefine.TrainWeaponTagEnum.TrainBattleBuff,
  [12601361] = EnumDefine.TrainWeaponTagEnum.TrainBattleBuff,
  [12601362] = EnumDefine.TrainWeaponTagEnum.TrainBattleBuff,
  [12601363] = EnumDefine.TrainWeaponTagEnum.TrainBattleBuff,
  [12601364] = EnumDefine.TrainWeaponTagEnum.TrainBattleBuff,
  [12601875] = EnumDefine.TrainWeaponTagEnum.TrainBattleBuff,
  [12601072] = EnumDefine.TrainWeaponTagEnum.AddBalloonSR,
  [12600710] = EnumDefine.TrainWeaponTagEnum.GoodsOverVal,
  [12601270] = EnumDefine.TrainWeaponTagEnum.EffectLineList,
  [12600829] = EnumDefine.TrainWeaponTagEnum.PrisonerBackPack,
  [12601401] = EnumDefine.TrainWeaponTagEnum.LightingTimeAdd,
  [12601412] = EnumDefine.TrainWeaponTagEnum.AsternSpeed,
  [12601477] = EnumDefine.TrainWeaponTagEnum.TrainWeaponAtk
}
local polluteTag2Enum = {
  [12600352] = EnumDefine.TrainWeaponTagEnum.AddColoudness,
  [12600353] = EnumDefine.TrainWeaponTagEnum.AddColoudness
}
local nonPolluteTag2Enum = {
  [12600355] = EnumDefine.TrainWeaponTagEnum.AddDeterrence
}
local nonBasePercentTag = {
  [12600831] = 1,
  [12600353] = 1
}

local function GetResult(param, initValue, enum)
  local value = 0
  if param[1] then
    value = math.floor(initValue * param[1] + 0.5)
  end
  if param[2] then
    if 1 <= math.abs(param[2]) then
      value = value + math.floor(param[2] + 0.5)
    else
      value = value + param[2]
    end
  end
  if param[3] then
    value = value + math.floor((value + initValue) * param[3] + 0.5)
  end
  if initValue then
  end
  return value
end

local function HandleOneAttributes(weaponSkillId, lv, tagId, calValue, typeParam)
  local tagEnum = WeaponTag2Enum[tagId]
  local param = {0, 0}
  if typeParam == nil then
    typeParam = {
      0,
      0,
      0
    }
  end
  if tagEnum then
    if calValue then
      param = TrainWeaponTag[tagEnum].param
    end
    if calValue then
      if tagEnum == EnumDefine.TrainWeaponTagEnum.TrainAddSpeedBuff then
        table.insert(param, weaponSkillId)
        return
      end
      if tagEnum == EnumDefine.TrainWeaponTagEnum.AutoPickGoods then
        TrainWeaponTag[tagEnum].param = true
        return
      end
      if tagEnum == EnumDefine.TrainWeaponTagEnum.TrainBattleBuff then
        local data = {
          tagId = tagId,
          weaponSkillId = weaponSkillId,
          lv = lv
        }
        table.insert(param, data)
        return
      end
      if tagEnum == EnumDefine.TrainWeaponTagEnum.EffectLineList then
        table.insert(param, weaponSkillId)
        return
      end
    end
  end
  if tagEnum == nil then
    tagEnum = polluteTag2Enum[tagId]
    if tagEnum then
      param = TrainWeaponTag.polluteTag[tagEnum].param
    end
  end
  if tagEnum == nil then
    tagEnum = nonPolluteTag2Enum[tagId]
    if tagEnum then
      param = TrainWeaponTag.nonPolluteTag[tagEnum].param
    end
  end
  local ca = PlayerData:GetFactoryData(weaponSkillId)
  local isAdd = PlayerData:GetFactoryData(tagId).addNum
  local param1 = isAdd == true and 1 or -1
  if ca.mod == "\229\155\186\229\174\154\232\175\141\230\157\161" then
    local value = ca.Constant * ca.CommonNum * param1
    param[2] = param[2] + value
    typeParam[2] = typeParam[2] + value
  elseif ca.mod == "\230\136\144\233\149\191\232\175\141\230\157\161" then
    if ca.aTypeInt == 1 then
      local valueA = ca.aNumMinP
      if ca.aDevelopment then
        valueA = (ca.aNumMinP + lv * ca.aUpgradeRangeP) * ca.aCommonNumP
      end
      local value = valueA * param1 / 100
      if nonBasePercentTag[tagId] then
        param[3] = param[3] + value
        typeParam[3] = typeParam[3] + value
      else
        param[1] = param[1] + value
        typeParam[1] = typeParam[1] + value
      end
    else
      local valueA = ca.aNumMin
      if ca.aDevelopment then
        valueA = (ca.aNumMin + lv * ca.aUpgradeRange) * ca.aCommonNum
      end
      local value = valueA * param1
      param[2] = param[2] + value
      typeParam[2] = typeParam[2] + value
    end
  end
end

function TrainWeaponTag.CalOneweaponAttributes(weaponId, lv, typeStr)
  local cfg = PlayerData:GetFactoryData(weaponId)
  local typeParam
  local normalEntryList = cfg.normalEntryList
  for i, v in ipairs(normalEntryList) do
    local weaponSkillId = v.id
    local tagId = PlayerData:GetFactoryData(weaponSkillId).entryTag
    local TagAttributes = TrainWeaponTag[WeaponTag2Enum[tagId]]
    if TagAttributes == nil then
      TagAttributes = TrainWeaponTag.polluteTag[polluteTag2Enum[tagId]]
    end
    if TagAttributes == nil then
      TagAttributes = TrainWeaponTag.nonPolluteTag[nonPolluteTag2Enum[tagId]]
    end
    if TagAttributes then
      if typeStr then
        typeParam = TagAttributes[typeStr]
      end
      HandleOneAttributes(weaponSkillId, lv, tagId, true, typeParam)
    end
  end
  local growUpEntryList = cfg.growUpEntryList
  for i, v in ipairs(growUpEntryList) do
    local weaponSkillId = v.id
    local tagId = PlayerData:GetFactoryData(weaponSkillId).entryTag
    local TagAttributes = TrainWeaponTag[WeaponTag2Enum[tagId]]
    if TagAttributes == nil then
      TagAttributes = TrainWeaponTag.polluteTag[polluteTag2Enum[tagId]]
    end
    if TagAttributes == nil then
      TagAttributes = TrainWeaponTag.nonPolluteTag[nonPolluteTag2Enum[tagId]]
    end
    if TagAttributes then
      if typeStr then
        typeParam = TagAttributes[typeStr]
      end
      HandleOneAttributes(weaponSkillId, lv, tagId, true, typeParam)
    end
  end
end

function TrainWeaponTag.CalTrainWeaponAllAttributes()
  for k, v in pairs(WeaponTag2Enum) do
    if TrainWeaponTag[v] then
      if v == EnumDefine.TrainWeaponTagEnum.TrainAddSpeedBuff then
        TrainWeaponTag[v].param = {}
      elseif v == EnumDefine.TrainWeaponTagEnum.AutoPickGoods then
        TrainWeaponTag[v].param = false
      elseif v == EnumDefine.TrainWeaponTagEnum.TrainBattleBuff then
        TrainWeaponTag[v].param = {}
      elseif v == EnumDefine.TrainWeaponTagEnum.EffectLineList then
        TrainWeaponTag[v].param = {}
      else
        TrainWeaponTag[v] = {
          param = {
            0,
            0,
            0
          },
          coach = {
            0,
            0,
            0
          },
          pendant = {
            0,
            0,
            0
          },
          accessories = {
            0,
            0,
            0
          }
        }
      end
    elseif v == EnumDefine.TrainWeaponTagEnum.TrainAddSpeedBuff then
      TrainWeaponTag[v] = {
        param = {}
      }
    elseif v == EnumDefine.TrainWeaponTagEnum.AutoPickGoods then
      TrainWeaponTag[v] = {param = false}
    elseif v == EnumDefine.TrainWeaponTagEnum.TrainBattleBuff then
      TrainWeaponTag[v] = {
        param = {}
      }
    elseif v == EnumDefine.TrainWeaponTagEnum.EffectLineList then
      TrainWeaponTag[v] = {
        param = {}
      }
    else
      TrainWeaponTag[v] = {
        param = {
          0,
          0,
          0
        },
        coach = {
          0,
          0,
          0
        },
        pendant = {
          0,
          0,
          0
        },
        accessories = {
          0,
          0,
          0
        }
      }
    end
  end
  if TrainWeaponTag.polluteTag == nil then
    TrainWeaponTag.polluteTag = {}
  end
  for k, v in pairs(polluteTag2Enum) do
    TrainWeaponTag.polluteTag[v] = {
      param = {
        0,
        0,
        0
      }
    }
  end
  if TrainWeaponTag.nonPolluteTag == nil then
    TrainWeaponTag.nonPolluteTag = {}
  end
  for k, v in pairs(nonPolluteTag2Enum) do
    TrainWeaponTag.nonPolluteTag[v] = {
      param = {
        0,
        0,
        0
      }
    }
  end
  local train_pendant = PlayerData:GetHomeInfo().train_pendant
  for k, v in pairs(train_pendant) do
    if v ~= "" and PlayerData:GetBattery() and PlayerData:GetBattery()[v] then
      local serverBatteryData = PlayerData:GetBattery()[v]
      local weaponId = serverBatteryData.id
      local lv = serverBatteryData.lv
      TrainWeaponTag.CalOneweaponAttributes(weaponId, lv, "pendant")
    end
  end
  local train_accessories = PlayerData:GetHomeInfo().train_accessories
  for k, v in pairs(train_accessories) do
    if v ~= "" and PlayerData:GetBattery() and PlayerData:GetBattery()[v] then
      local serverBatteryData = PlayerData:GetBattery()[v]
      local weaponId = serverBatteryData.id
      local lv = serverBatteryData.lv
      TrainWeaponTag.CalOneweaponAttributes(weaponId, lv, "accessories")
    end
  end
  local coach = PlayerData:GetHomeInfo().coach
  for i, v in ipairs(coach) do
    for i1, v1 in ipairs(v.battery) do
      if v1 ~= "" and PlayerData:GetBattery() and PlayerData:GetBattery()[v1] then
        local serverBatteryData = PlayerData:GetBattery()[v1]
        local weaponId = serverBatteryData.id
        local lv = serverBatteryData.lv
        TrainWeaponTag.CalOneweaponAttributes(weaponId, lv, "coach")
      end
    end
    local skin_house = v.skin_house or {}
    for k2, v2 in pairs(skin_house) do
      local skinId = v2
      if skinId and skinId ~= "" then
        local skinCfg = PlayerData:GetFactoryData(skinId)
        for i1, v1 in ipairs(skinCfg.normalEntryList) do
          local tagId = PlayerData:GetFactoryData(v1.id).entryTag
          HandleOneAttributes(v1.id, 1, tagId, true)
        end
      end
    end
  end
  local skinItemList = PlayerData:GetFactoryData(99900044).skinItemList
  for i, v in ipairs(skinItemList) do
    local num = PlayerData:GetGoodsById(v.id).num
    if 0 < num then
      local cfg = PlayerData:GetFactoryData(v.id)
      local skinId = cfg.skinID
      if 0 < skinId then
        local skinCfg = PlayerData:GetFactoryData(skinId)
        for i1, v1 in ipairs(skinCfg.normalEntryList) do
          local tagId = PlayerData:GetFactoryData(v1.id).entryTag
          HandleOneAttributes(v1.id, 1, tagId, true)
        end
      end
    end
  end
end

function TrainWeaponTag.GetWeaponTagAttributes(enum, initValue, specialType)
  local value = 0
  local TagAttributes = TrainWeaponTag[enum]
  if TagAttributes == nil then
    TagAttributes = TrainWeaponTag.polluteTag[enum]
  end
  if TagAttributes == nil then
    TagAttributes = TrainWeaponTag.nonPolluteTag[enum]
  end
  if TagAttributes then
    if initValue == nil then
      if specialType then
        return TagAttributes[specialType]
      else
        return TagAttributes.param
      end
    end
    if specialType then
      value = GetResult(TagAttributes[specialType], initValue, enum)
    else
      local param = TagAttributes.param
      local TradeDataModel = require("UIHome/UIHomeTradeDataModel")
      local isTravel = TradeDataModel.GetIsTravel()
      if isTravel then
        local pollute = TrainWeaponTag.LineInPollute()
        if pollute then
          local TagAttributes = TrainWeaponTag.polluteTag[enum]
          if TagAttributes then
            param = Clone(param)
            for i, v in ipairs(TagAttributes.param) do
              param[i] = param[i] + v
            end
          end
        else
          local TagAttributes = TrainWeaponTag.nonPolluteTag[enum]
          if TagAttributes then
            param = Clone(param)
            for i, v in ipairs(TagAttributes.param) do
              param[i] = param[i] + v
            end
          end
        end
      end
      value = GetResult(param, initValue, enum)
    end
  end
  return value
end

function TrainWeaponTag.GetOneCoachWeaponTagAttributes(enum, coachUid, initValue)
  local coach_store = PlayerData:GetHomeInfo().coach_store
  local t = {
    0,
    0,
    0
  }
  for i, v in pairs(coach_store) do
    if i == coachUid then
      for i1, v1 in pairs(v.battery) do
        if v1 ~= "" and PlayerData:GetBattery() and PlayerData:GetBattery()[v1] then
          local serverBatteryData = PlayerData:GetBattery()[v1]
          local weaponId = serverBatteryData.id
          local lv = serverBatteryData.lv
          local cfg = PlayerData:GetFactoryData(weaponId)
          local normalEntryList = cfg.normalEntryList
          for i2, v2 in ipairs(normalEntryList) do
            local weaponSkillId = v2.id
            local tagId = PlayerData:GetFactoryData(weaponSkillId).entryTag
            local tagEnum = WeaponTag2Enum[tagId]
            if tagEnum == enum then
              HandleOneAttributes(weaponSkillId, lv, tagId, false, t)
            end
          end
          local growUpEntryList = cfg.growUpEntryList
          for i2, v2 in ipairs(growUpEntryList) do
            local weaponSkillId = v2.id
            local tagId = PlayerData:GetFactoryData(weaponSkillId).entryTag
            local tagEnum = WeaponTag2Enum[tagId]
            if tagEnum == enum then
              HandleOneAttributes(weaponSkillId, lv, tagId, false, t)
            end
          end
        end
      end
    end
  end
  if initValue == nil then
    return t
  else
    return GetResult(t, initValue, enum)
  end
end

function TrainWeaponTag.GetOneWeaponTagAttributesByID(enum, weaponID, initValue)
  local cfg = PlayerData:GetFactoryData(weaponID)
  local lv = 1
  local typeParam = {0, 0}
  local normalEntryList = cfg.normalEntryList
  for i, v in ipairs(normalEntryList) do
    local weaponSkillId = v.id
    local tagId = PlayerData:GetFactoryData(weaponSkillId).entryTag
    local curEnum = WeaponTag2Enum[tagId]
    if curEnum == enum then
      HandleOneAttributes(weaponSkillId, lv, tagId, false, typeParam)
    end
  end
  local growUpEntryList = cfg.growUpEntryList
  for i, v in ipairs(growUpEntryList) do
    local weaponSkillId = v.id
    local tagId = PlayerData:GetFactoryData(weaponSkillId).entryTag
    local curEnum = WeaponTag2Enum[tagId]
    if curEnum == enum then
      HandleOneAttributes(weaponSkillId, lv, tagId, false, typeParam)
    end
  end
  if initValue == nil then
    return typeParam
  end
  return GetResult(typeParam, initValue, enum)
end

function TrainWeaponTag.GetOneWeaponTagAttributes(enum, weaponUid, initValue)
  local serverWeapon = PlayerData:GetBattery()[weaponUid]
  if serverWeapon == nil then
    if initValue == nil then
      return {0, 0}
    end
    return 0
  end
  local cfg = PlayerData:GetFactoryData(serverWeapon.id)
  local lv = serverWeapon.lv
  local typeParam = {0, 0}
  local normalEntryList = cfg.normalEntryList
  for i, v in ipairs(normalEntryList) do
    local weaponSkillId = v.id
    local tagId = PlayerData:GetFactoryData(weaponSkillId).entryTag
    local curEnum = WeaponTag2Enum[tagId]
    if curEnum == enum then
      HandleOneAttributes(weaponSkillId, lv, tagId, false, typeParam)
    end
  end
  local growUpEntryList = cfg.growUpEntryList
  for i, v in ipairs(growUpEntryList) do
    local weaponSkillId = v.id
    local tagId = PlayerData:GetFactoryData(weaponSkillId).entryTag
    local curEnum = WeaponTag2Enum[tagId]
    if curEnum == enum then
      HandleOneAttributes(weaponSkillId, lv, tagId, false, typeParam)
    end
  end
  if initValue == nil then
    return typeParam
  end
  return GetResult(typeParam, initValue, enum)
end

function TrainWeaponTag.GetTrainLight()
  local train_accessories = PlayerData:GetHomeInfo().train_accessories
  for k, v in pairs(train_accessories) do
    if v ~= "" then
      local serverBatteryData = PlayerData:GetBattery()[v]
      local weaponCA = PlayerData:GetFactoryData(serverBatteryData.id, "HomeWeaponFactory")
      if weaponCA.typeWeapon == 12600388 and weaponCA.specialEffects ~= nil and weaponCA.specialEffects ~= "" then
        return tonumber(serverBatteryData.id)
      end
    end
  end
  return 0
end

function TrainWeaponTag.GetTrainEffectsData(typeWeapon)
  local function insertDefaultEffectValue(_effectID, _result)
    local effectCA = PlayerData:GetFactoryData(_effectID, "EffectFactory")
    
    if effectCA then
      table.insert(_result, {
        position = {
          x = effectCA.offsetX,
          y = effectCA.offsetY,
          z = effectCA.offsetZ
        },
        scale = {
          x = effectCA.scaleX > 0 and effectCA.scaleX or 1,
          y = 0 < effectCA.scaleY and effectCA.scaleY or 1,
          z = 0 < effectCA.scaleZ and effectCA.scaleZ or 1
        },
        rotation = {
          x = effectCA.eularX,
          y = effectCA.eularY,
          z = effectCA.eularZ
        }
      })
    end
  end
  
  local function insertTrainSkinDatas(_listData, _result)
    if _listData == nil then
      return false
    end
    for k, v in pairs(_listData) do
      table.insert(_result, {
        position = {
          x = v.x,
          y = v.y,
          z = v.z
        },
        scale = {
          x = v.xs > 0 and v.xs or 1,
          y = 0 < v.ys and v.ys or 1,
          z = 0 < v.zs and v.zs or 1
        },
        rotation = {
          x = v.xx,
          y = v.yx,
          z = v.zx
        }
      })
    end
    return true
  end
  
  local function getOffsets(_trainSkinCA, _effectStyleType, _result)
    if _trainSkinCA == nil or _effectStyleType == nil then
      return false
    end
    return insertTrainSkinDatas(_trainSkinCA[_effectStyleType], _result)
  end
  
  local function dealServerData(_serverData, _battery, _trainSkinCA, _typeWeapon, _result)
    if not _serverData then
      return
    end
    for _, v in pairs(_serverData) do
      if v ~= "" and _battery ~= nil and _battery[v] ~= nil then
        local weaponCA = PlayerData:GetFactoryData(_battery[v].id, "HomeWeaponFactory")
        if weaponCA and (not _typeWeapon or weaponCA.typeWeapon == _typeWeapon) and weaponCA.effectTypeEffect > 0 then
          _result[weaponCA.typeWeapon] = _result[weaponCA.typeWeapon] or {}
          _result[weaponCA.typeWeapon][weaponCA.effectTypeEffect] = _result[weaponCA.typeWeapon][weaponCA.effectTypeEffect] or {}
          local isInsert = getOffsets(_trainSkinCA, weaponCA.effectStyleType, _result[weaponCA.typeWeapon][weaponCA.effectTypeEffect])
          if not isInsert then
            insertDefaultEffectValue(weaponCA.effectTypeEffect, _result[weaponCA.typeWeapon][weaponCA.effectTypeEffect])
          end
        end
      end
    end
  end
  
  local function dealDefault(_typeWeapon, _result, _trainSkinCA)
    for k, v in pairs(TrainEffectHelper.Enum_TrainEffectType) do
      if (_typeWeapon == nil or _typeWeapon == v) and _result[v] == nil and TrainEffectHelper.DefaultEffect[k] ~= nil then
        local effectID = TrainEffectHelper.DefaultEffect[k]
        local tempTypeWeapon = _typeWeapon or v
        _result[tempTypeWeapon] = {}
        _result[tempTypeWeapon][effectID] = {}
        local isInsert = getOffsets(_trainSkinCA, string.lower(k) .. "List", _result[tempTypeWeapon][effectID])
        if not isInsert then
          insertDefaultEffectValue(effectID, _result[tempTypeWeapon][effectID])
        end
        if _typeWeapon ~= nil then
          return
        end
      end
    end
  end
  
  local result = {}
  local trainSkinCA
  local train = TrainWeaponTag.GetRealFirstTrain()
  if train ~= nil and train.Skin ~= nil and train.Skin.ca ~= nil then
    trainSkinCA = PlayerData:GetFactoryData(train.Skin.ca.id, "HomeCoachSkinFactory")
  end
  local battery = PlayerData:GetBattery()
  local homeData = PlayerData:GetHomeInfo()
  if homeData then
    dealServerData(homeData.train_accessories, battery, trainSkinCA, typeWeapon, result)
    dealServerData(homeData.train_pendant, battery, trainSkinCA, typeWeapon, result)
  end
  dealDefault(typeWeapon, result, trainSkinCA)
  return result
end

function TrainWeaponTag.GetRealFirstTrain()
  if TrainWeaponTag.isKabaneri then
    if KBTrainManager.train == nil or KBTrainManager.train.train == nil or KBTrainManager.train.train.Length == 0 then
      return nil
    end
    return KBTrainManager.train.train[0]
  else
    local trains = CS.FRef.getProperty(TrainManager.TrainCtrl, "Trains")
    if trains then
      for i = 0, trains.Count - 1 do
        if trains[i] ~= nil then
          local index = CS.FRef.getProperty(trains[i], "Index")
          if index and index == 0 then
            return trains[i]
          end
        end
      end
    end
  end
  return nil
end

function TrainWeaponTag.GetTrainAccEffectData()
  local trainSkinCA
  local train = TrainWeaponTag.GetRealFirstTrain()
  if train ~= nil and train.Skin ~= nil and train.Skin.ca ~= nil then
    trainSkinCA = PlayerData:GetFactoryData(train.Skin.ca.id, "HomeCoachSkinFactory")
  end
  if trainSkinCA == nil or trainSkinCA.jetEffect <= 0 then
    return nil
  end
  local temp = {}
  for k, v in pairs(trainSkinCA.jetList) do
    table.insert(temp, {
      position = {
        x = v.x,
        y = v.y,
        z = v.z
      },
      scale = {
        x = 0 < v.xs and v.xs or 1,
        y = 0 < v.ys and v.ys or 1,
        z = 0 < v.zs and v.zs or 1
      },
      rotation = {
        x = v.xx,
        y = v.yx,
        z = v.zx
      }
    })
  end
  if #temp == 0 then
    return nil
  end
  local result = {
    [TrainEffectHelper.Enum_TrainEffectType.SkinEffect] = {
      [trainSkinCA.jetEffect] = temp
    }
  }
  return result
end

function TrainWeaponTag.GetTrainEffect()
  local path = {}
  local train_accessories = PlayerData:GetHomeInfo().train_pendant
  for k, v in pairs(train_accessories) do
    if v ~= "" and PlayerData:GetBattery() and PlayerData:GetBattery()[v] then
      local serverBatteryData = PlayerData:GetBattery()[v]
      local weaponCA = PlayerData:GetFactoryData(serverBatteryData.id, "HomeWeaponFactory")
      if weaponCA.effectType == "1" then
        table.insert(path, weaponCA.effectTypeEffect)
      end
    end
  end
  return path
end

function TrainWeaponTag.GetTrainTimelineList()
  local path = {}
  local train_pendant = PlayerData:GetHomeInfo().train_pendant
  for k, v in pairs(train_pendant) do
    if v ~= "" and PlayerData:GetBattery() and PlayerData:GetBattery()[v] then
      local serverBatteryData = PlayerData:GetBattery()[v]
      local weaponCA = PlayerData:GetFactoryData(serverBatteryData.id, "HomeWeaponFactory")
      if weaponCA.effectType == "3" then
        table.insert(path, weaponCA.timeLineEffect)
      end
    end
  end
  local train_accessories = PlayerData:GetHomeInfo().train_accessories
  for k, v in pairs(train_accessories) do
    if v ~= "" and PlayerData:GetBattery() and PlayerData:GetBattery()[v] then
      local serverBatteryData = PlayerData:GetBattery()[v]
      local weaponCA = PlayerData:GetFactoryData(serverBatteryData.id, "HomeWeaponFactory")
      if weaponCA.effectType == "3" then
        table.insert(path, weaponCA.timeLineEffect)
      end
    end
  end
  return path
end

function TrainWeaponTag.GetTrainSoundEffectList()
  local path = {}
  local train_pendant = PlayerData:GetHomeInfo().train_pendant
  for k, v in pairs(train_pendant) do
    if v ~= "" and PlayerData:GetBattery() and PlayerData:GetBattery()[v] then
      local serverBatteryData = PlayerData:GetBattery()[v]
      local weaponCA = PlayerData:GetFactoryData(serverBatteryData.id, "HomeWeaponFactory")
      if weaponCA.effectType == "4" then
        table.insert(path, weaponCA.effectTypeEffect)
      end
    end
  end
  local train_accessories = PlayerData:GetHomeInfo().train_accessories
  for k, v in pairs(train_accessories) do
    if v ~= "" and PlayerData:GetBattery() and PlayerData:GetBattery()[v] then
      local serverBatteryData = PlayerData:GetBattery()[v]
      local weaponCA = PlayerData:GetFactoryData(serverBatteryData.id, "HomeWeaponFactory")
      if weaponCA.effectType == "4" then
        table.insert(path, weaponCA.effectTypeEffect)
      end
    end
  end
  return path
end

function TrainWeaponTag.IsWeaponedById(id)
  id = tonumber(id)
  local train_pendant = PlayerData:GetHomeInfo().train_pendant
  for k, v in pairs(train_pendant) do
    if v ~= "" and PlayerData:GetBattery() and PlayerData:GetBattery()[v] then
      local serverBatteryData = PlayerData:GetBattery()[v]
      if tonumber(serverBatteryData.id) == id then
        return true
      end
    end
  end
  local train_accessories = PlayerData:GetHomeInfo().train_accessories
  for k, v in pairs(train_accessories) do
    if v ~= "" and PlayerData:GetBattery() and PlayerData:GetBattery()[v] then
      local serverBatteryData = PlayerData:GetBattery()[v]
      if tonumber(serverBatteryData.id) == id then
        return true
      end
    end
  end
  local coach = PlayerData:GetHomeInfo().coach
  for i, v in ipairs(coach) do
    for i1, v1 in ipairs(v.battery) do
      if v1 ~= "" and PlayerData:GetBattery() and PlayerData:GetBattery()[v] then
        local serverBatteryData = PlayerData:GetBattery()[v1]
        if tonumber(serverBatteryData.id) == id then
          return true
        end
      end
    end
  end
  return false
end

local function LineInPollute(lineId)
  local polluteInfo = PlayerData.pollute_areas or {}
  for k, v in pairs(polluteInfo) do
    if v.po_curIndex then
      local homeLineCA = PlayerData:GetFactoryData(k)
      local lineList = homeLineCA.LineList or {}
      for k1, v2 in pairs(lineList) do
        if v2.id == lineId then
          return true
        end
      end
    end
  end
  return false
end

function TrainWeaponTag.LineInPollute()
  local TradeDataModel = require("UIHome/UIHomeTradeDataModel")
  local isTravel = TradeDataModel.GetIsTravel()
  if isTravel == false then
    return false
  end
  local MapDataModel = require("UIHome/UIHomeMapDataModel")
  local stationList = TradeDataModel.GetDriveLine(PlayerData:GetHomeInfo().station_info)
  local lineList = {}
  local stationCount = #stationList - 1
  for i = 1, stationCount do
    if stationList[i] ~= nil and stationList[i + 1] ~= nil and MapDataModel.AllStationPathRecord[stationList[i].id] ~= nil and MapDataModel.AllStationPathRecord[stationList[i].id][stationList[i + 1].id] ~= nil then
      local lineId = MapDataModel.AllStationPathRecord[stationList[i].id][stationList[i + 1].id].id
      table.insert(lineList, lineId)
    end
  end
  for k, v in pairs(lineList) do
    local pullute = LineInPollute(v)
    if pullute then
      return true
    end
  end
  return false
end

return TrainWeaponTag
