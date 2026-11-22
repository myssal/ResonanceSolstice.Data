local DataModel = {
  GuKaList = {},
  CurSelectIdx = 0,
  IsSelect = false,
  IsOptional = false
}

function DataModel.Init()
  DataModel.IsSelect = false
  DataModel.CurSelectIdx = 0
end

function DataModel.SetGuKaList(list)
  DataModel.GuKaList = list
end

function DataModel.GetGuKaLevel(id)
  local guka = WitchData.GetWitchesData().guka
  local data = guka[tostring(id)]
  if data then
    return data.lv
  end
  return 1
end

function DataModel.GetGuKaAttrDesc(id)
  local gukaCfg = PlayerData:GetFactoryData(id)
  local lv = DataModel.GetGuKaLevel(id)
  if gukaCfg and table.count(gukaCfg.skillList) > 0 then
    local skillCfg = PlayerData:GetFactoryData(gukaCfg.skillList[1].skillId)
    if skillCfg then
      if skillCfg.isPercent then
        local value = skillCfg.minAttrSN + skillCfg.digitSN * (lv - 1)
        value = value * 100
        return string.format(skillCfg.description, value .. "%")
      else
        return string.format(skillCfg.description, skillCfg.minAttrSN + (lv - 1) * skillCfg.digitSN)
      end
    end
  end
  return ""
end

return DataModel
