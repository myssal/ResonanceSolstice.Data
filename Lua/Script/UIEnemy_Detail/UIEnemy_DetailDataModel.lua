local DataModel = {
  Content = {},
  EnemyCA = {},
  EnemyViewCA = {},
  EnemyCampCA = {},
  EnemyTypeCA = {},
  EnemySideCA = {},
  IdentityList = {},
  ResistanceList = {},
  WeaknessList = {},
  DropRewardList = {},
  ContentHight = 770
}
local atk_coefficient = 1
local def_coefficient = 1
local hp_coefficient = 1

function DataModel:CalculatePointX(num, max, type)
  local lengths = {}
  local weights = {}
  local start = 0
  local finish = max
  local weights_Hp = {
    10000,
    15000,
    20000,
    100000,
    200000
  }
  local weights_Atk = {
    55,
    61,
    68,
    76,
    86
  }
  local weights_Def = {
    55,
    60,
    65,
    75,
    85
  }
  if type == 1 then
    weights = weights_Hp
  elseif type == 2 then
    weights = weights_Atk
  else
    weights = weights_Def
  end
  lengths[1] = weights[1]
  for i = 2, #weights do
    lengths[i] = weights[i] - weights[i - 1]
  end
  lengths[#weights + 1] = finish - weights[#weights]
  local points = {}
  points[1] = start
  for i = 2, #lengths do
    points[i] = points[i - 1] + lengths[i - 1]
  end
  local input = num
  local segmentIndex = 1
  if input > points[#points] then
    segmentIndex = #points
  else
    for i = 2, #points do
      if input >= points[i - 1] and input <= points[i] then
        segmentIndex = i - 1
        break
      end
    end
  end
  local relativePosition = (input - points[segmentIndex]) / lengths[segmentIndex]
  local proportion = 1 / #weights * (segmentIndex - 1 + relativePosition)
  return 1 < proportion and 1 or proportion
end

function DataModel:SetVertices()
  local max_Hp = 600000
  local max_Def = 110
  local max_Atk = 110
  local hp = DataModel.EnemyCA.hp_SN
  local atk = DataModel.EnemyCA.atk_SN
  local def = DataModel.EnemyCA.def_SN
  hp_coefficient = DataModel:CalculatePointX(hp, max_Hp, 1)
  atk_coefficient = DataModel:CalculatePointX(atk, max_Atk, 2)
  def_coefficient = DataModel:CalculatePointX(def, max_Def, 3)
end

function DataModel:GetVertices()
  local vertices = {
    Vector3(0, 84, 0) * atk_coefficient,
    Vector3(73, -42, 0) * def_coefficient,
    Vector3(-73, -42, 0) * hp_coefficient
  }
  return vertices
end

return DataModel
