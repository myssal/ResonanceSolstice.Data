local DataModel = {
  decodeParams = {},
  rolHeight = 152
}

local function CreatData(life_info)
  local data = {}
  data.isSkin = false
  data.id = life_info.id
  data.resonance_lv = life_info.resonanceLv
  local cfg = PlayerData:GetFactoryData(data.id)
  local desc = cfg.desc
  if cfg.isReplace then
    local param = cfg.param
    if DataModel.cachePreSkillParam[cfg.id] then
      param = param + DataModel.cachePreSkillParam[cfg.id]
    end
    if cfg.isPCT then
      param = param * 100
    else
      param = math.floor(param + 0.5)
    end
    desc = string.format(desc, param)
  end
  data.desc = desc
  return data
end

local function CreateSkinSkillData(viewCA)
  local data = {}
  data.isSkin = true
  data.id = viewCA.homeSkill
  data.skinName = viewCA.SkinName
  local cfg = PlayerData:GetFactoryData(data.id)
  local desc = cfg.desc
  if cfg.isReplace then
    local param = cfg.param
    if DataModel.cachePreSkillParam[cfg.id] then
      param = param + DataModel.cachePreSkillParam[cfg.id]
    end
    if cfg.isPCT then
      param = param * 100
    else
      param = math.floor(param + 0.5)
    end
    desc = string.format(desc, param)
  end
  data.desc = desc
  return data
end

function DataModel.init()
  local role_id = DataModel.decodeParams.roleId
  DataModel.life_list = {}
  DataModel.cachePreSkillParam = {}
  DataModel.resonance_lv = DataModel.decodeParams.resonance_lv and DataModel.decodeParams.resonance_lv or PlayerData:GetRoleById(role_id).resonance_lv or 0
  if not DataModel.decodeParams.noShowUnit then
    local unitCA = PlayerData:GetFactoryData(role_id)
    local homeSkillList = unitCA.homeSkillList
    for i, v in ipairs(homeSkillList) do
      local next_index = v.nextIndex or -1
      if 0 < next_index then
        table.insert(DataModel.life_list, {
          CreatData(v),
          count = 1
        })
        local count = #DataModel.life_list
        DataModel.life_list[count].unlock_level = v.resonanceLv <= DataModel.resonance_lv and 1 or 0
        local loop_count = 1
        local preId = v.id
        while homeSkillList[next_index] and loop_count < 20 do
          DataModel.cachePreSkillParam[homeSkillList[next_index].id] = PlayerData:GetFactoryData(preId).param
          table.insert(DataModel.life_list[count], CreatData(homeSkillList[next_index]))
          local now_unlock = DataModel.life_list[count].unlock_level
          DataModel.life_list[count].unlock_level = homeSkillList[next_index].resonanceLv <= DataModel.resonance_lv and now_unlock + 1 or now_unlock
          DataModel.life_list[count].count = DataModel.life_list[count].count + 1
          preId = homeSkillList[next_index].id
          next_index = homeSkillList[next_index].nextIndex
          loop_count = loop_count + 1
        end
      elseif next_index == 0 then
        table.insert(DataModel.life_list, {
          CreatData(v),
          count = 1
        })
        DataModel.life_list[#DataModel.life_list].unlock_level = v.resonanceLv <= DataModel.resonance_lv and 1 or 0
      end
    end
  end
  if PlayerData.IsSkinHomeSkillOpen() then
    local serverSkinList = PlayerData:GetRoleById(role_id).skin_list
    local cacheSkinDic = {}
    if serverSkinList then
      for skinId, v in pairs(serverSkinList) do
        cacheSkinDic[tonumber(skinId)] = 1
      end
    end
    local noHeroSkin = PlayerData.ServerData.skin_no_hero
    if noHeroSkin and noHeroSkin[tostring(DataModel.decodeParams.roleId)] then
      for i, tempSkinId in ipairs(noHeroSkin[tostring(DataModel.decodeParams.roleId)]) do
        cacheSkinDic[tonumber(tempSkinId)] = 1
      end
    end
    if DataModel.decodeParams.unitViewIdId then
      local viewCA = PlayerData:GetFactoryData(DataModel.decodeParams.unitViewIdId)
      if viewCA and viewCA.homeSkill and 0 < viewCA.homeSkill then
        table.insert(DataModel.life_list, {
          CreateSkinSkillData(viewCA),
          count = 1
        })
        DataModel.life_list[#DataModel.life_list].unlock_level = cacheSkinDic[DataModel.decodeParams.unitViewIdId] and 1 or 0
      end
    else
      local unitCA = PlayerData:GetFactoryData(role_id)
      local skinList = unitCA.skinList
      for i, v in ipairs(skinList) do
        local viewCA = PlayerData:GetFactoryData(v.unitViewId)
        if viewCA and viewCA.homeSkill and 0 < viewCA.homeSkill then
          table.insert(DataModel.life_list, {
            CreateSkinSkillData(viewCA),
            count = 1
          })
          DataModel.life_list[#DataModel.life_list].unlock_level = cacheSkinDic[v.unitViewId] and 1 or 0
        end
      end
    end
  end
end

return DataModel
