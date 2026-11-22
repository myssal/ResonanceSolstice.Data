local DataModel = {
  Data = {},
  QuestIds = {},
  QuestInfo = {}
}

function DataModel.InitQuestInfo()
  DataModel.QuestInfo = {}
  for k, v in pairs(DataModel.QuestIds) do
    local t = {}
    t.id = v
    local questCA = PlayerData:GetFactoryData(v, "QuestFactory")
    if questCA.client > 0 then
      local photoFactory = PlayerData:GetFactoryData(questCA.client, "ProfilePhotoFactory")
      t.clientImagePath = photoFactory.imagePath
      t.clientName = photoFactory.name
    end
    local strLen, charLen, cacheCharLen = string.getLength(questCA.name)
    local questLimit = 24
    local specialCharLen = 0
    local curTrustLen = 0
    for k1, v1 in pairs(cacheCharLen) do
      local len = v1
      if len <= 2 then
        len = 1
      else
        len = 2
      end
      specialCharLen = specialCharLen + len
      curTrustLen = curTrustLen + v1
      if questLimit <= specialCharLen then
        break
      end
    end
    local questShowName
    if charLen > curTrustLen then
      questShowName = string.sub(questCA.name, 1, curTrustLen) .. ".."
    else
      questShowName = questCA.name
    end
    t.questName = questShowName
    t.reward = {}
    if questCA.rewardsList ~= nil then
      for k1, v1 in pairs(questCA.rewardsList) do
        local type = PlayerData:GetRewardType(v1.id)
        if type == "CardPackTips" and next(DataModel.Data.cardInfo) then
          table.insert(t.reward, {
            id = DataModel.Data.cardInfo[1],
            num = 1
          })
        else
          table.insert(t.reward, v1)
        end
      end
    end
    if questCA.reputationList ~= nil then
      for k1, v1 in pairs(questCA.reputationList) do
        table.insert(t.reward, v1)
      end
    end
    table.insert(DataModel.QuestInfo, t)
  end
end

return DataModel
