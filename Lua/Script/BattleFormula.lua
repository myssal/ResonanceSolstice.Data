local BattleFormula = {}
local isDevelopmentEnvironment

local function IsDevelopmentEnvironment()
  if isDevelopmentEnvironment ~= nil then
    return isDevelopmentEnvironment
  end
  isDevelopmentEnvironment = false
  local ok, isDev = pcall(function()
    local application = CS and CS.UnityEngine and CS.UnityEngine.Application or nil
    local unityDebug = CS and CS.UnityEngine and CS.UnityEngine.Debug or Debug
    return application ~= nil and application.isEditor == true or unityDebug ~= nil and unityDebug.isDebugBuild == true
  end)
  if ok and isDev == true then
    isDevelopmentEnvironment = true
  end
  return isDevelopmentEnvironment
end

local function CheckAtkDamage(funcName, atkSN)
  if GameSetting.fromRes ~= "EN" then
    return
  end
  if IsDevelopmentEnvironment() then
    return
  end
  local recordAtkSN = _G.atkDamage
  if recordAtkSN == nil then
    return
  end
  if recordAtkSN ~= atkSN then
    local diff = "\230\151\160\230\179\149\232\174\161\231\174\151"
    if type(recordAtkSN) == "number" and type(atkSN) == "number" then
      diff = tostring(atkSN - recordAtkSN)
    end
    Debug.LogError(string.format("\230\184\184\230\136\143\229\188\130\229\184\184", tostring(funcName), tostring(recordAtkSN), tostring(atkSN), diff))
  end
end

function BattleFormula.CountDamage(atkSN, skillRateSN, makeDamageUpSN, makeDamageDownSN, makeDamageMultiplierSN, makeDamageByTypeUpSN, makeDamageByTypeDownSN, makeDamageFinalUpSN, makeDamageFinalDownSN, defenceSN, getDamageUpSN, getDamageDownSN, getDamageMultiplierSN, getDamageByTypeUpSN, getDamageByTypeDownSN, getDamageFinalUpSN, getDamageFinalDownSN, blockSN, lvConstantSN, isStraightDamage, isIgnoreDefence)
  CheckAtkDamage("CountDamage", atkSN)
  local makeDmgSN = SafeMath.Multiplication(skillRateSN, makeDamageUpSN)
  makeDmgSN = SafeMath.Multiplication(makeDmgSN, makeDamageDownSN)
  makeDmgSN = SafeMath.Multiplication(makeDmgSN, makeDamageByTypeUpSN)
  makeDmgSN = SafeMath.Multiplication(makeDmgSN, makeDamageByTypeDownSN)
  local makeDmgFinalSN = SafeMath.Multiplication(makeDmgSN, makeDamageFinalUpSN)
  makeDmgFinalSN = SafeMath.Multiplication(makeDmgFinalSN, makeDamageFinalDownSN)
  local getDmgSN = SafeMath.Multiplication(getDamageUpSN, getDamageDownSN)
  getDmgSN = SafeMath.Multiplication(getDmgSN, getDamageMultiplierSN)
  getDmgSN = SafeMath.Multiplication(getDmgSN, getDamageByTypeUpSN)
  getDmgSN = SafeMath.Multiplication(getDmgSN, getDamageByTypeDownSN)
  local getDmgFinalSN = SafeMath.Multiplication(getDmgSN, getDamageFinalUpSN)
  getDmgFinalSN = SafeMath.Multiplication(getDmgFinalSN, getDamageFinalDownSN)
  local rtSN = 0
  if isStraightDamage then
    rtSN = atkSN
    rtSN = SafeMath.Multiplication(SafeMath.Multiplication(rtSN, makeDmgFinalSN), getDmgFinalSN)
  else
    if isIgnoreDefence then
      defenceSN = 0
    end
    if makeDamageMultiplierSN == 20000 then
      lvConstantSN = SafeMath.Multiplication(lvConstantSN, 8)
      local checkNum = SafeMath.Multiplication(lvConstantSN, SafeMath.Division(atkSN - defenceSN, atkSN))
      if checkNum < -SafeMath.safeNumberTime then
        rtSN = SafeMath.Division(atkSN, SafeMath.safeNumberTime * 10)
        rtSN = SafeMath.Multiplication(SafeMath.Multiplication(rtSN, makeDmgFinalSN), getDmgFinalSN)
      else
        rtSN = SafeMath.Multiplication(atkSN, SafeMath.safeNumberTime + checkNum)
        rtSN = rtSN + SafeMath.Division(atkSN, SafeMath.safeNumberTime * 10)
        rtSN = SafeMath.Multiplication(SafeMath.Multiplication(rtSN, makeDmgFinalSN), getDmgFinalSN)
      end
    else
      rtSN = SafeMath.Multiplication(atkSN, SafeMath.safeNumberTime + SafeMath.Division(atkSN - defenceSN, lvConstantSN))
      rtSN = SafeMath.Multiplication(SafeMath.Multiplication(rtSN, makeDmgFinalSN), getDmgFinalSN)
    end
  end
  rtSN = SafeMath.Floor(rtSN)
  rtSN = rtSN - blockSN
  if rtSN < SafeMath.safeNumberTime then
    rtSN = SafeMath.safeNumberTime
  end
  if 0 > SafeMath.SafeNumberToInt(rtSN) and PlayerPrefs.GetInt("damageFigue") ~= 1 then
    PlayerPrefs.SetInt("damageFigue", 1)
    PlayerPrefs.SetInt("damageFigueCallBack", 1)
  end
  return rtSN
end

function BattleFormula.CountRealDamage(atkSN, skillRateSN)
  CheckAtkDamage("CountRealDamage", atkSN)
  local rtSN = 0
  rtSN = SafeMath.Multiplication(atkSN, skillRateSN)
  rtSN = SafeMath.Floor(rtSN)
  if rtSN < SafeMath.safeNumberTime then
    rtSN = SafeMath.safeNumberTime
  end
  return rtSN
end

function BattleFormula.CountDefPercent(defSN)
  local rt = SafeMath.Division(defSN, defSN + SafeMath.IntToSafeNumber(200))
  return rt
end

function BattleFormula.CountHeal(atkSN, skillRateSN, makeHealUpSN, makeHealDownSN, makeHealMultiplierSN, getHealUpSN, getHealDownSN, getHealMultiplierSN)
  CheckAtkDamage("CountHeal", atkSN)
  local rtSN = 0
  rtSN = SafeMath.Multiplication(atkSN, skillRateSN)
  rtSN = SafeMath.Multiplication(rtSN, makeHealUpSN)
  rtSN = SafeMath.Multiplication(rtSN, makeHealDownSN)
  rtSN = SafeMath.Multiplication(rtSN, makeHealMultiplierSN)
  rtSN = SafeMath.Multiplication(rtSN, getHealUpSN)
  rtSN = SafeMath.Multiplication(rtSN, getHealDownSN)
  rtSN = SafeMath.Multiplication(rtSN, getHealMultiplierSN)
  rtSN = SafeMath.Floor(rtSN)
  if rtSN < 0 then
    rtSN = 0
  end
  rtSN = -rtSN
  return rtSN
end

function BattleFormula.CountShield(atkSN, skillRateFactorSN, damageTypeRateSN)
  local rtSN = 0
  local skillDamageRateSN = skillRateFactorSN
  rtSN = SafeMath.Multiplication(atkSN, skillDamageRateSN)
  rtSN = SafeMath.Multiplication(rtSN, damageTypeRateSN)
  rtSN = SafeMath.Floor(rtSN)
  if rtSN < SafeMath.safeNumberTime then
    rtSN = SafeMath.safeNumberTime
  end
  return rtSN
end

function BattleFormula.CountAtkSpeedInterval(atkSpeedSN, overMaxSpeed)
  if atkSpeedSN < GameSetting.atkSpeedMin_SN then
    atkSpeedSN = GameSetting.atkSpeedMin_SN
  end
  if overMaxSpeed ~= true and atkSpeedSN > GameSetting.atkSpeedMax_SN then
    atkSpeedSN = GameSetting.atkSpeedMax_SN
  end
  local rt = SafeMath.SafeNumberToInt(SafeMath.Division(GameSetting.atkSpeedBase_SN * GameSetting.fps, atkSpeedSN))
  return rt
end

return BattleFormula
