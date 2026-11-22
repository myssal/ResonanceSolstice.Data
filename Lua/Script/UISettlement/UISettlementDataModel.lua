local View = require("UISettlement/UISettlementView")
local DataModel = {}
DataModel.user_info = {}
DataModel.before_roles = {}
DataModel.DropAwardList = {}
DataModel.InitPos = {
  isRecord = true,
  x = 0,
  y = 0,
  scale = 1
}
DataModel.IsReStart = false
DataModel.LevelCA = {}

function DataModel:CleanEffect()
  local Parent_1 = View.Group_Victory.Group_Score.Img_Bottom.Group_Effect.self
  local Parent_2 = View.Group_Victory.Group_Score.Img_Grade.Group_Effect.self
  Parent_1:HideDynamicGameObject()
  Parent_2:HideDynamicGameObject()
end

function DataModel.LoadSpineBg(viewId)
  local spineBg = View.Group_Victory.Group_Center.Img_SpineBG
  local viewCfg = PlayerData:GetFactoryData(viewId, "UnitViewFactory")
  if viewCfg.SpineBackground and viewCfg.SpineBackground ~= "" then
    spineBg:SetSprite(viewCfg.SpineBackground)
    local offsetX = viewCfg.SpineBGX and viewCfg.SpineBGX or 0
    local offsetY = viewCfg.SpineBGY and viewCfg.SpineBGY or 0
    local x = View.Group_Victory.Group_Center.SpineAnimation_Character.transform.localPosition.x - offsetX
    spineBg.transform.localPosition = Vector3(x, offsetY, 0)
    local scale = viewCfg.SpineBGScale or 1
    spineBg.transform.localScale = Vector3(scale, scale, 0)
  end
  spineBg:SetActive(viewCfg.SpineBackground and viewCfg.SpineBackground ~= "")
end

function DataModel:CheckCanArrest()
  if DataModel.LevelCA.isCatchPrison == true then
    return false
  end
  if PlayerData.ServerData.user_prison_info == nil then
    return false
  end
  if self.canArrestNum == nil or DataModel.canArrestEnemy == nil then
    local arrestNum = 0
    local enemyIds = self.DeadHero.enemy_Ids
    if enemyIds ~= nil then
      enemyIds = string.split(enemyIds, ",")
    end
    local bossMap = {}
    for i = 1, #enemyIds do
      local waveCA = PlayerData:GetFactoryData(enemyIds[i])
      for j = 1, #waveCA.enemyList do
        local enemyCA = PlayerData:GetFactoryData(waveCA.enemyList[j].id)
        local pNum = 0
        for k = 1, #enemyCA.prisonerDrop do
          local prisonerCA = PlayerData:GetFactoryData(enemyCA.prisonerDrop[k].id)
          if tonumber(prisonerCA.prisonerRarity) ~= 12601048 then
            pNum = pNum + 1
          elseif not self:IsPrisonerArrested(prisonerCA.id) and bossMap[prisonerCA.id] ~= true then
            pNum = pNum + 1
            bossMap[prisonerCA.id] = true
          end
        end
        arrestNum = arrestNum + pNum
      end
    end
    self.canArrestNum = arrestNum
  end
  return self.canArrestNum > 0, self.canArrestNum
end

function DataModel:IsPrisonerArrested(id)
  for k, v in pairs(PlayerData.ServerData.user_prison_info.carrying_backpack) do
    if tonumber(v.prisoner_id) == tonumber(id) then
      return true
    end
  end
  for k, v in pairs(PlayerData.ServerData.user_prison_info.prison_backpack) do
    if tonumber(v.prisoner_id) == tonumber(id) then
      return true
    end
  end
  for k, v in pairs(PlayerData.ServerData.user_prison_info.temporary_backpack) do
    if tonumber(v.prisoner_id) == tonumber(id) then
      return true
    end
  end
  return false
end

function DataModel:ShowPersonalLeaderboards()
  local levelCA = PlayerData:GetFactoryData(PlayerData.BattleInfo.battleStageId)
  if levelCA.isDisplayLeaderBoard == true then
    local level_record
    if PlayerData.ServerData.level_record[tostring(PlayerData.BattleInfo.battleStageId)] ~= nil then
      level_record = PlayerData.ServerData.level_record[tostring(PlayerData.BattleInfo.battleStageId)].records
    end
    local newIndex
    if level_record == nil then
      level_record = {}
    end
    if DataModel.JsonList.create_ts ~= nil then
      for i = 1, #level_record do
        if level_record[i].create_ts == nil then
          newIndex = i
          level_record[i].create_ts = DataModel.JsonList.create_ts
        end
      end
    end
    local params = {resultList = level_record, newIndex = newIndex}
    if levelCA.maxRecordNum <= 0 then
      params.tipText = 80610636
    end
    params.levelId = levelCA.id
    UIManager:Open("UI/Battle/PersonalLeaderboards/PersonalLeaderboards", Json.encode(params))
  end
end

function DataModel:GetPrisonerCellNum()
  local curNum = table.count(PlayerData.ServerData.user_prison_info.carrying_backpack)
  return PrisonData.GetPrisonerBagMaxCapacity() - curNum
end

function DataModel:TryArrest()
  if self.AutoSettlement then
    return
  end
  if self.arrestFlag then
    return
  end
  local canArrest, arrestNum = self:CheckCanArrest()
  if not canArrest then
    return
  end
  local itemId = PrisonData.GetPrisonCA().arrestItem
  local itemNum = PlayerData:GetGoodsById(itemId).num
  if itemNum <= 0 then
    local itemCA = PlayerData:GetFactoryData(itemId)
    CommonTips.OpenTips(string.format(GetText(80600149), itemCA.name))
    return
  end
  if 0 >= self:GetPrisonerCellNum() then
    CommonTips.OpenTips(GetText(80600201))
    return
  end
  arrestNum = math.min(arrestNum, itemNum)
  local enemyIds = self.DeadHero.enemy_Ids
  UIManager:Open("UI/Prison/ArrestPrisoner/ArrestTips", Json.encode({
    maxNum = arrestNum,
    wave_list = enemyIds,
    arrestItem = itemId
  }), function()
    self.arrestFlag = true
    View.Group_Victory.Btn_Arrest:SetActive(false)
  end)
end

function DataModel:GetMinRoleLvData()
  local lv, roleId
  local roleList = PlayerData.BattleInfo.BattleResult.roleInfoList
  for k, v in pairs(roleList) do
    local data = PlayerData:GetRoleById(k)
    if table.count(data) > 0 then
      if lv == nil then
        lv = data.lv
        roleId = k
      elseif lv > data.lv then
        lv = data.lv
        roleId = k
      end
    end
  end
  return roleId
end

function DataModel:GetMinRoleResonanceData()
  local resonance_lv, roleId
  local roleList = PlayerData.BattleInfo.BattleResult.roleInfoList
  for k, v in pairs(roleList) do
    local data = PlayerData:GetRoleById(k)
    if table.count(data) > 0 then
      if resonance_lv == nil then
        resonance_lv = data.resonance_lv
        roleId = k
      elseif resonance_lv > data.resonance_lv then
        resonance_lv = data.resonance_lv
        roleId = k
      end
    end
  end
  return roleId
end

function DataModel:GetSettlementCamera()
  local cameraParent
  local cameraManager = CBus:GetManager(CS.ManagerName.CameraManager)
  if cameraManager.MainCamera == nil then
    return nil
  end
  cameraParent = cameraManager.MainCamera.gameObject
  local cam = cameraParent:GetComponent(typeof(CS.UnityEngine.Camera))
  if cam == nil then
    return nil
  end
  return cam
end

return DataModel
