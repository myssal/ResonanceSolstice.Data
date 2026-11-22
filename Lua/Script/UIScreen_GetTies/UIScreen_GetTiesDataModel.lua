local DataModel = {}

function DataModel.Init(data)
  DataModel.NewBuffList = {}
  for k, v in pairs(data) do
    local petInfo = PlayerData:GetHomeInfo().pet[k]
    local petCfg = PlayerData:GetFactoryData(petInfo.id)
    local buffCount = #petInfo.buff_list
    local startIdx = buffCount - v + 1
    if 0 < startIdx then
      for i = startIdx, buffCount do
        local data = {}
        local name = petInfo.name ~= "" and petInfo.name or petCfg.petName
        data.petName = name
        local roleName = PlayerData:GetFactoryData(petInfo.role_id).name
        data.roleName = roleName or ""
        local buffCA = PlayerData:GetFactoryData(petInfo.buff_list[i])
        local tiesName = buffCA.tiesName
        data.tiesName = tiesName or ""
        local addNum = 0
        if 0 < buffCA.atkNum then
          addNum = buffCA.atkNum
        elseif 0 < buffCA.defNum then
          addNum = buffCA.defNum
        elseif 0 < buffCA.hpNum then
          addNum = buffCA.hpNum
        end
        addNum = addNum * (1 + PlayerData:GetHomeSkillIncrease(EnumDefine.HomeSkillEnum.AddTieVal))
        addNum = math.floor(addNum + 0.5)
        data.tiesName = string.format(data.tiesName, addNum)
        table.insert(DataModel.NewBuffList, data)
      end
    end
  end
end

return DataModel
