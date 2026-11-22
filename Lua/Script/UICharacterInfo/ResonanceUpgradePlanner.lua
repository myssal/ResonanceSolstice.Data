local M = {}
local blockedItems = {
  [11700245] = true,
  [11700246] = true
}

local function SortedItems(map)
  local result = {}
  for id, num in pairs(map) do
    if 0 < num then
      result[#result + 1] = {id = id, num = num}
    end
  end
  table.sort(result, function(a, b)
    return a.id < b.id
  end)
  return result
end

local function EncodeObject(map, encodeValue)
  local keys, parts = {}, {}
  for key in pairs(map) do
    keys[#keys + 1] = key
  end
  table.sort(keys, function(a, b)
    return tonumber(a) < tonumber(b)
  end)
  for _, key in ipairs(keys) do
    parts[#parts + 1] = Json.encode(tostring(key)) .. ":" .. encodeValue(map[key])
  end
  return "{" .. table.concat(parts, ",") .. "}"
end

function M.EncodeSkill(skill)
  return EncodeObject(skill, Json.encode)
end

function M.EncodeAttribute(attribute)
  return EncodeObject(attribute, M.EncodeSkill)
end

local function ReadCosts(materialList)
  local costs, seen, blocked = {}, {}, false
  for _, item in ipairs(materialList or {}) do
    local id = assert(tonumber(item.id), "Invalid resonance material ID")
    local num = assert(tonumber(item.num), "Invalid resonance material count")
    assert(0 <= num and num % 1 == 0, "Invalid resonance material count")
    if not seen[id] then
      seen[id] = true
      if 0 < num then
        costs[id] = num
        blocked = blocked or blockedItems[id] == true
      end
    end
  end
  return costs, blocked
end

function M.IsUnlocked(role, roleCA)
  local maxStage = #(roleCA.talentList or {})
  return 0 < maxStage and maxStage <= (tonumber(role.resonance_lv) or 0)
end

local function EmptyPlan(roleId)
  return {
    roleId = tostring(roleId),
    skill = {},
    attribute = {},
    items = {},
    upgrades = {},
    nodeCount = 0,
    levelCount = 0
  }
end

function M.Build(roleId, source)
  source = source or PlayerData
  local role = source:GetRoleById(roleId)
  assert(role and tonumber(role.lv), "Missing role data")
  local roleCA = assert(source:GetFactoryData(tonumber(roleId)), "Missing role config")
  local state = {
    unlocked = M.IsUnlocked(role, roleCA),
    completed = false,
    requiredItems = {},
    materialsEnough = false,
    conditionsEnough = false,
    canUpgrade = false,
    executable = EmptyPlan(roleId)
  }
  state.targetPlan = state.executable
  if not state.unlocked then
    return state
  end
  local cache = {}
  
  local function GetCA(id)
    assert(tonumber(id) and tonumber(id) > 0, "Invalid resonance config ID")
    local key = tostring(id)
    if not cache[key] then
      cache[key] = assert(source:GetFactoryData(id), "Missing resonance config: " .. key)
    end
    return cache[key]
  end
  
  local nodes = {}
  
  local function AddNode(kind, stage, attrIndex, level, grades, skillCA, prev)
    level = tonumber(level) or 0
    local node = {
      kind = kind,
      stage = stage,
      attrIndex = attrIndex,
      fromLevel = level,
      level = level,
      grades = grades,
      skillCA = skillCA,
      prev = prev,
      steps = {},
      target = level
    }
    nodes[#nodes + 1] = node
    return node
  end
  
  for stage = 1, math.min(tonumber(role.resonance_lv), #roleCA.talentList) do
    local talent = GetCA(roleCA.talentList[stage].talentId)
    local key = tostring(stage)
    local skillId = tonumber(talent.skillIntensify)
    if skillId and 0 < skillId then
      local skill = GetCA(skillId)
      AddNode("skill", stage, nil, (role.skill_info or {})[key], skill.attributeIntensify or {}, skill)
    end
    local levels = (role.attribute_info or {})[key] or {}
    local prev
    for index, entry in ipairs(talent.attributeIntensify or {}) do
      local list = GetCA(entry.id)
      prev = AddNode("attribute", stage, index, levels[tostring(index - 1)], list.attributeGradeList or {}, nil, prev)
    end
  end
  local required = {}
  state.completed = true
  for _, node in ipairs(nodes) do
    for level = node.level + 1, #node.grades do
      local skill, material
      if node.kind == "skill" then
        skill, material = node.skillCA, GetCA(node.grades[level].id)
      else
        skill = GetCA(node.grades[level].id)
        local entry = assert((skill.attributeIntensify or {})[1], "Missing attribute material config")
        material = GetCA(entry.id)
      end
      local costs, blocked = ReadCosts(material.materialList)
      if blocked then
        break
      end
      node.target = level
      node.steps[level] = {
        costs = costs,
        needLevel = tonumber(skill.playerLevel) or 1
      }
      for id, num in pairs(costs) do
        required[id] = (required[id] or 0) + num
      end
    end
    if node.target > node.level then
      state.completed = false
    end
  end
  state.requiredItems = SortedItems(required)
  state.materialsEnough = true
  for id, num in pairs(required) do
    local goods = source:GetGoodsById(id)
    if num > (tonumber(goods and goods.num) or 0) then
      state.materialsEnough = false
    end
  end
  state.conditionsEnough = true
  for _, node in ipairs(nodes) do
    if node.target > node.fromLevel then
      if node.prev and 0 >= node.prev.target then
        state.conditionsEnough = false
      end
      for level = node.fromLevel + 1, node.target do
        if tonumber(role.lv) < node.steps[level].needLevel then
          state.conditionsEnough = false
        end
      end
      state.executable.levelCount = state.executable.levelCount + node.target - node.fromLevel
      node.level = node.target
    end
  end
  local plan = state.executable
  for _, node in ipairs(nodes) do
    if node.level > node.fromLevel then
      local stage = tostring(node.stage)
      if node.kind == "skill" then
        plan.skill[stage] = node.level
      else
        plan.attribute[stage] = plan.attribute[stage] or {}
        plan.attribute[stage][tostring(node.attrIndex - 1)] = node.level
      end
      local costsByLevel = {}
      for level = node.fromLevel + 1, node.level do
        costsByLevel[level] = node.steps[level].costs
      end
      plan.upgrades[#plan.upgrades + 1] = {
        kind = node.kind,
        stage = node.stage,
        attrIndex = node.attrIndex,
        fromLevel = node.fromLevel,
        toLevel = node.level,
        costsByLevel = costsByLevel
      }
    end
  end
  plan.items, plan.nodeCount = state.requiredItems, #plan.upgrades
  state.targetPlan = plan
  state.canUpgrade = not state.completed and state.materialsEnough and state.conditionsEnough
  if not state.canUpgrade then
    state.executable = EmptyPlan(roleId)
  end
  return state
end

function M.IsSame(a, b)
  if not (a and b) or a.roleId ~= b.roleId or M.EncodeSkill(a.skill) ~= M.EncodeSkill(b.skill) or M.EncodeAttribute(a.attribute) ~= M.EncodeAttribute(b.attribute) or #a.upgrades ~= #b.upgrades or #a.items ~= #b.items then
    return false
  end
  for i, node in ipairs(a.upgrades) do
    local other = b.upgrades[i]
    if node.kind ~= other.kind or node.stage ~= other.stage or node.attrIndex ~= other.attrIndex or node.fromLevel ~= other.fromLevel or node.toLevel ~= other.toLevel then
      return false
    end
  end
  for i, item in ipairs(a.items) do
    if item.id ~= b.items[i].id or item.num ~= b.items[i].num then
      return false
    end
  end
  return true
end

function M.GetAppliedCosts(plan, role)
  local costs = {}
  for _, node in ipairs(plan.upgrades) do
    local stage = tostring(node.stage)
    local value
    if node.kind == "skill" then
      value = (role.skill_info or {})[stage]
    else
      value = (role.attribute_info or {})[stage] or {}[tostring(node.attrIndex - 1)]
    end
    local level = tonumber(value) or 0
    if level % 1 ~= 0 or level < node.fromLevel or level > node.toLevel then
      return nil, "Returned resonance level is outside the submitted range"
    end
    for upgradedLevel = node.fromLevel + 1, level do
      local step = node.costsByLevel and node.costsByLevel[upgradedLevel]
      if not step then
        return nil, "Missing submitted resonance cost snapshot"
      end
      for id, num in pairs(step) do
        costs[id] = (costs[id] or 0) + num
      end
    end
  end
  return costs
end

return M
