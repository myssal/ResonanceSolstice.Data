local View = require("UICharacterInfo/UICharacterInfoView")
local DataModel = require("UICharacterInfo/DataModel")
local Planner = require("UICharacterInfo/ResonanceUpgradePlanner")
local Loader = require("UICharacterInfo/ViewResonanceNew")
local BtnController = require("UICharacterInfo/Model_Btn")
local M = {}
local pending, needsSync, alive, generation, playDetailIn, account, serverData

function M.Initialize()
  if account ~= PlayerData.pid or serverData ~= PlayerData.ServerData then
    pending, needsSync = nil, false
  end
  account, serverData = PlayerData.pid, PlayerData.ServerData
  alive = true
  generation = (generation or 0) + 1
  DataModel.ResonanceDetailMode, DataModel.OneKeyResonancePlan = nil, nil
  View.self:SetRaycastBlock(true)
end

function M.Close()
  DataModel.ResonanceDetailMode, DataModel.OneKeyResonancePlan = nil, nil
  if View.Group_SkillTree.Group_Update.Img_resonanceselect then
    View.Group_SkillTree.Group_Update.Img_resonanceselect:SetActive(false)
  end
end

function M.Destroy()
  alive = false
  generation = (generation or 0) + 1
  DataModel.ResonanceDetailMode, DataModel.OneKeyResonancePlan = nil, nil
  DataModel.OneKeyResonanceItems = nil
  playDetailIn = nil
end

local function IsCurrent(request)
  return alive and request.generation == generation and tostring(PlayerData.pid) == request.pid and PlayerData.ServerData == request.serverData and tostring(DataModel.RoleId) == request.roleId
end

function M.Update()
  if pending and not pending.timedOut and Time.realtimeSinceStartup - pending.startedAt > 30 then
    pending.timedOut = true
    if alive and pending.generation == generation then
      View.self:SetRaycastBlock(true)
      if DataModel.ResonanceDetailMode == "oneKey" then
        M.Open()
      end
    end
  end
end

function M.Open(onDetailIn)
  if onDetailIn then
    playDetailIn = onDetailIn
  end
  UIManager:LoadSplitPrefab(View, "UI/CharacterInfo/CharacterInfo", "Group_SkillTree")
  DataModel.ResonanceDetailMode = "oneKey"
  DataModel.RightResonanceIndex = nil
  DataModel.isNextSkillShow = false
  DataModel.OneKeyResonancePlan = nil
  DataModel.OneKeyResonanceItems = {}
  local tree = View.Group_SkillTree
  local detail = tree.Group_AwakeDetails
  local upgrade = detail.Group_SkillUpgrade
  local grid = upgrade.ScrollGrid_Item.grid.self
  grid:SetParentParam("ResonanceOneKey")
  grid:SetDataCount(0)
  grid:RefreshAllElement()
  grid:SetActive(false)
  detail.self:SetActive(true)
  tree.Group_Update.Img_resonanceselect:SetActive(true)
  if playDetailIn then
    playDetailIn()
  end
  View.Group_Middle.Img_BlackMask:SetActive(true)
  detail.Group_Ding.Group_GoldCoin.Txt_Num:SetText(PlayerData:GetUserInfo().gold)
  detail.Txt_Name:SetText(GetText(80612922))
  detail.Txt_Grade:SetActive(false)
  detail.Txt_GradeMax:SetActive(false)
  detail.Txt_:SetActive(false)
  detail.Btn_Next:SetActive(false)
  detail.Group_Next:SetActive(false)
  detail.Group_LifeSkillDesc:SetActive(false)
  detail.Group_TalentLock:SetActive(false)
  detail.Group_Text.Group_Stage:SetActive(false)
  detail.Group_Text.Group_Skill:SetActive(false)
  detail.Group_Text.Group_Attribute:SetActive(false)
  detail.Group_Max.self:SetActive(false)
  upgrade.self:SetActive(true)
  upgrade.ScrollGrid_Item.self:SetActive(false)
  upgrade.Img_RewardsBG:SetActive(false)
  upgrade.Img_:SetActive(false)
  upgrade.Txt_1:SetActive(false)
  upgrade.Btn_Up.self:SetActive(false)
  upgrade.Btn_Lock.self:SetActive(true)
  local description = GetText(80612921)
  local lockText = GetText(80612920)
  if pending then
    lockText = "1"
  elseif needsSync then
    lockText = "2"
  elseif Planner.IsUnlocked(DataModel.RoleData, PlayerData:GetFactoryData(tonumber(DataModel.RoleId))) then
    local ok, state = pcall(Planner.Build, DataModel.RoleId)
    if not ok then
      lockText = "3"
    elseif state.completed then
      detail.Group_Max.self:SetActive(true)
      detail.Group_Max.Txt_WordMax:SetText(GetText(80600042))
      detail.Group_Max.Txt_Max:SetActive(false)
      upgrade.self:SetActive(false)
    else
      local plan = state.targetPlan
      DataModel.OneKeyResonancePlan = plan
      DataModel.OneKeyResonanceItems = state.requiredItems
      upgrade.ScrollGrid_Item.self:SetActive(true)
      upgrade.Img_RewardsBG:SetActive(true)
      upgrade.Img_:SetActive(true)
      upgrade.Txt_1:SetActive(true)
      grid:SetParentParam("ResonanceOneKey")
      grid:SetDataCount(#DataModel.OneKeyResonanceItems)
      grid:MoveToTop()
      grid:RefreshAllElement()
      grid:SetActive(true)
      if state.canUpgrade then
        upgrade.Btn_Lock.self:SetActive(false)
        upgrade.Btn_Up.self:SetActive(true)
        upgrade.Btn_Up.Txt_Up:SetText(GetText(80612922))
        upgrade.Btn_Up.Txt_Stage:SetActive(false)
        upgrade.Btn_Up:SetClickParam("ResonanceOneKey")
      else
        lockText = not state.materialsEnough and GetText(80612924) or "4"
        upgrade.Btn_Lock.self:SetActive(true)
        upgrade.Btn_Up.self:SetActive(false)
      end
    end
  end
  upgrade.Btn_Lock.Txt_Lock:SetText(lockText)
  local desc = detail.ScrollView_Describe.Viewport.Txt_Describe
  desc:SetText(description)
  if not CommonTips.IsResEN() then
    desc:OnTextChange()
  end
end

local function ApplyMaterialCosts(costs, json)
  local items = {}
  for id, num in pairs(costs) do
    local key = tostring(id)
    local updated = (not json.material or not json.material[key]) and (not json.items or not json.items[key]) and json.goods and json.goods[key]
    if id == 11400001 then
      if not updated and (not json.user_info or json.user_info.gold == nil) then
        local user = PlayerData:GetUserInfo()
        user.gold = user.gold - num
      end
    elseif not updated then
      items[id] = num
    end
  end
  if next(items) then
    PlayerData:RefreshUseItems(items)
  end
end

function M.Submit()
  if pending or needsSync or DataModel.ResonanceDetailMode ~= "oneKey" then
    return
  end
  local ok, state = pcall(Planner.Build, DataModel.RoleId)
  if not ok then
    print("One-key resonance planning failed: " .. tostring(state))
    M.Open()
    return
  end
  local plan = state.targetPlan
  if not state.canUpgrade or plan.nodeCount == 0 then
    M.Open()
    return
  end
  if not Planner.IsSame(DataModel.OneKeyResonancePlan, plan) then
    M.Open()
    return
  end
  local request = {
    roleId = plan.roleId,
    pid = tostring(PlayerData.pid),
    generation = generation,
    startedAt = Time.realtimeSinceStartup,
    serverData = PlayerData.ServerData
  }
  pending = request
  View.self:SetRaycastBlock(false)
  Net:SendProto("hero.resonance_one_key", function(json)
    if tostring(PlayerData.pid) ~= request.pid or PlayerData.ServerData ~= request.serverData or pending ~= request then
      return
    end
    pending = nil
    local hero = json.hero or (json.heros or {})[request.roleId] or (json.roles or {})[request.roleId]
    local role = PlayerData:GetRoleById(request.roleId)
    local validHero = type(hero) == "table" and (hero.id == nil or tostring(hero.id) == request.roleId)
    if validHero and hero == json.hero then
      for key, value in pairs(hero) do
        role[key] = value
      end
    end
    local costs, reason
    if validHero then
      costs, reason = Planner.GetAppliedCosts(plan, role)
    end
    needsSync = costs == nil
    if costs then
      ApplyMaterialCosts(costs, json)
    end
    if not IsCurrent(request) then
      return
    end
    View.self:SetRaycastBlock(true)
    local reopen = DataModel.ResonanceDetailMode == "oneKey"
    DataModel.RoleData = role
    DataModel.InitState = true
    DataModel:SetRoleAttributeCurrent()
    BtnController:SetSkillList()
    if reopen then
      Loader:Load(nil, false)
      M.Open()
    end
    CommonTips.OpenTips(80612957)
  end, request.roleId, Planner.EncodeSkill(plan.skill), Planner.EncodeAttribute(plan.attribute))
end

return M
