local View = require("UIVoltageValue/UIVoltageValueView")
local DataModel = require("UIVoltageValue/UIVoltageValueDataModel")

local function UpdateVoltVal(isInit)
  local BattleControlManager = CBus:GetManager(CS.ManagerName.BattleControlManager)
  local roleList = BattleControlManager.teamDataDic[1].roleList
  local roleCount = roleList.Count
  local val = 0
  for i = 0, roleCount - 1 do
    local buffSys = roleList[i].buffSystem
    val = val + buffSys:GetBuffLevel(10413732) * 500
  end
  if val % 1000 == 0 then
    val = math.floor(val / 1000)
  else
    val = val / 1000
  end
  local group, lastGroup
  if val <= 99 then
    group = View.Group_VoltLevel0
  elseif 99 < val and val <= 999 then
    group = View.Group_VoltLevel1
    if 0 <= DataModel.lastVal and 99 >= DataModel.lastVal then
      lastGroup = View.Group_VoltLevel0
    end
  else
    group = View.Group_VoltLevel2
    if 99 < DataModel.lastVal and 999 >= DataModel.lastVal then
      lastGroup = View.Group_VoltLevel1
    end
  end
  group.self:SetActive(true)
  if lastGroup ~= nil then
    View.self:SelectPlayAnim(lastGroup.self, "Disappear", function()
      lastGroup.self:SetActive(false)
    end)
    View.self:SelectPlayAnim(group.self, "LvUp", function()
      View.self:SelectPlayAnim(group.self, "Loop")
    end)
  elseif isInit then
    View.self:SelectPlayAnim(group.self, "LvUp", function()
      View.self:SelectPlayAnim(group.self, "Loop")
    end)
  end
  DataModel.lastVal = val
  local valStr = ""
  local str = tostring(val)
  for i = 1, #str do
    local subVal = string.sub(str, i, i)
    if tonumber(subVal) == nil then
      valStr = valStr .. "<sprite=11>"
    else
      valStr = valStr .. "<sprite=" .. subVal .. ">"
    end
  end
  valStr = valStr .. "<sprite=10>"
  if group.Group_Num.CardCost_Nums then
    group.Group_Num.CardCost_Nums.Tmp.text = valStr
  end
end

local ViewFunction = {
  UpdateVoltVal = function(isInit)
    UpdateVoltVal(isInit)
  end
}
return ViewFunction
