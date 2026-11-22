local View = require("UIRoleDetail/UIRoleDetailView")
local DataModel = require("UIRoleDetail/UIRoleDetailDataModel")
local ViewFunction = require("UIRoleDetail/UIRoleDetailViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local param = Json.decode(initParams)
    DataModel.CA = PlayerData:GetFactoryData(param.id)
    DataModel.Role = PlayerData:GetRoleById(param.id)
    DataModel.AttributeData = {}
    DataModel.SkillList = {}
    local SkillList = {}
    SkillList = PlayerData:GetCardDes(DataModel.CA.id)
    for k, v in pairs(SkillList) do
      local ca = PlayerData:GetFactoryData(v.id)
      v.ExSkillList = ca.ExSkillList
      table.insert(DataModel.SkillList, {
        id = v.id,
        des = v.des,
        isEx = false,
        num = DataModel.CA.skillList[k].num
      })
      for c, d in pairs(v.ExSkillList) do
        local skill = DataManager:GetCardDes(d.ExSkillName)
        local skillList = Json.decode(skill)
        d.description = skillList.des
        d.ca = skill
        table.insert(DataModel.SkillList, {
          id = d.ExSkillName,
          des = d.description,
          ca = skill,
          isEx = true
        })
      end
    end
    local temp_data = {}
    local role = DataModel.Role
    temp_data.tHp, temp_data.tDef, temp_data.tAtk, temp_data.tCri, temp_data.tCriDamage, temp_data.tSpeed, temp_data.tBlock, temp_data.tBlockRate, temp_data.tPDamageUp, temp_data.tMDamageUp, temp_data.tFReduce, temp_data.tGetPDamageDown, temp_data.tGetMDamageDown, temp_data.tGetFDamageDown, temp_data.tGetHealUp, temp_data.tGetShieldUp, temp_data.tSummonAtkUp, temp_data.tFireDamageUp = PlayerData:CountRoleAttributeById(role.id, role.skills[1] and role.skills[1].lv or 1, role.skills[2] and role.skills[2].lv or 1, role.skills[2] and role.skills[2].lv or 1, role.lv, role.awake_lv, role.resonance_lv, role.trust_lv or 1)
    DataModel.AttributeData = temp_data
    DataModel:RefreshRoleData()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
