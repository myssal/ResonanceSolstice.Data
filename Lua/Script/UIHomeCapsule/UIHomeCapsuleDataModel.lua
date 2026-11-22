local DataModel = {
  pondInfo = {},
  curSelectIdx = 0,
  lastSelectView = nil,
  rencentlyTime = 0,
  rewardShow = {},
  viewType = 1,
  pickStatus = "none",
  NDAnimeTime = 0,
  NDAnimeTimeConfig = 0,
  quality = 0,
  QualityNode = nil,
  QualityOutEffect = nil,
  CapsuleOpenPer = 1,
  EggOpenTime = 1,
  EggUpTime = 1,
  pickSound = nil,
  CurrencyData = {}
}

function DataModel.GetSpritePath(cfg, path)
  if type(path) ~= "string" or path == "" or cfg == nil then
    return path
  end
  local prefix = cfg.spritePathPrefix
  local insert = cfg.spritePathInsert
  if type(prefix) ~= "string" or prefix == "" or type(insert) ~= "string" or insert == "" then
    return path
  end
  prefix = string.gsub(prefix, "/+$", "")
  insert = string.gsub(insert, "^/+", "")
  insert = string.gsub(insert, "/+$", "")
  if prefix == "" or insert == "" or string.sub(path, 1, #prefix) ~= prefix then
    return path
  end
  local remainder = string.sub(path, #prefix + 1)
  if remainder ~= "" and string.sub(remainder, 1, 1) ~= "/" then
    return path
  end
  remainder = string.gsub(remainder, "^/+", "")
  if remainder == "" then
    return prefix .. "/" .. insert
  end
  return prefix .. "/" .. insert .. "/" .. remainder
end

function DataModel.Init()
  DataModel.curSelectIdx = 0
  DataModel.lastSelectView = nil
  DataModel.pondInfo = {}
  local curTime = TimeUtil:GetServerTimeStamp()
  local homeConfig = PlayerData:GetFactoryData(99900014, "ConfigFactory")
  for k, v in pairs(homeConfig.capsuleList) do
    local extractCA = PlayerData:GetFactoryData(v.id, "ExtractFactory")
    local startTime = TimeUtil:TimeStamp(extractCA.startTime)
    if curTime > startTime then
      local endTime = 0
      if extractCA.endTime ~= "" then
        endTime = TimeUtil:TimeStamp(extractCA.endTime)
      end
      if endTime == 0 or curTime < endTime then
        local t = {}
        t.id = v.id
        t.startTime = startTime
        t.endTime = endTime
        t.limit = endTime ~= 0
        t.ca = extractCA
        t.capsuleList = Clone(extractCA.capsuleList)
        local isLimitCapsule = extractCA.type == "limitCapsule"
        if isLimitCapsule then
          t.totalRemainCount = 0
        end
        for i, v in pairs(t.capsuleList) do
          if v.quality == "Golden" then
            v.qualityLV = 4
          elseif v.quality == "Yellow" then
            v.qualityLV = 3
          elseif v.quality == "Purple" then
            v.qualityLV = 2
          elseif v.quality == "Blue" then
            v.qualityLV = 1
          else
            v.qualityLV = 0
          end
        end
        table.sort(t.capsuleList, function(a, b)
          if a.qualityLV < b.qualityLV then
            return true
          end
          return false
        end)
        for k1, v1 in pairs(t.capsuleList) do
          local factoryName = DataManager:GetFactoryNameById(v1.id)
          local qualityInt = 0
          local imagePath
          local ca = PlayerData:GetFactoryData(v1.id, factoryName)
          if factoryName == "HomeWeaponFactory" then
            qualityInt = ca.qualityInt
            imagePath = ca.imagePath
          elseif factoryName == "HomeFurnitureFactory" then
            qualityInt = ca.rarityInt
            imagePath = ca.iconPath
          else
            qualityInt = ca.qualityInt
            imagePath = ca.iconPath
          end
          v1.remainCount = v1.limitNum
          v1.qualityInt = v1.qualityLV + 1
          v1.imagePath = imagePath
          if isLimitCapsule then
            local serverData = PlayerData.ServerData.user_home_info.pool[tostring(v.id)]
            if serverData ~= nil then
              v1.remainCount = serverData[tostring(v1.id)] or 0
              t.totalRemainCount = t.totalRemainCount + v1.remainCount
            end
          end
        end
        DataModel.SortCapsuleList(t.capsuleList)
        table.insert(DataModel.pondInfo, t)
      end
    end
  end
  table.sort(DataModel.pondInfo, function(a, b)
    if a.ca.sort > b.ca.sort then
      return true
    end
    return false
  end)
  DataModel.CalcRencentlyTime()
end

function DataModel.SortCapsuleList(t)
  table.sort(t, function(a, b)
    if a.remainCount == 0 and b.remainCount > 0 then
      return false
    elseif a.remainCount > 0 and b.remainCount == 0 then
      return true
    elseif a.qualityInt > b.qualityInt then
      return true
    elseif a.qualityInt < b.qualityInt then
      return false
    elseif a.id > b.id then
      return true
    end
    return false
  end)
end

function DataModel.CalcRencentlyTime()
  DataModel.rencentlyTime = 0
  local curTime = TimeUtil:GetServerTimeStamp()
  local homeConfig = PlayerData:GetFactoryData(99900014, "ConfigFactory")
  for k, v in pairs(homeConfig.capsuleList) do
    local extractCA = PlayerData:GetFactoryData(v.id, "ExtractFactory")
    local startTime = TimeUtil:TimeStamp(extractCA.startTime)
    if curTime < startTime then
      if DataModel.rencentlyTime == 0 then
        DataModel.rencentlyTime = startTime
      elseif startTime < DataModel.rencentlyTime then
        DataModel.rencentlyTime = startTime
      end
    elseif extractCA.endTime ~= "" then
      local endTime = TimeUtil:TimeStamp(extractCA.endTime)
      if curTime < endTime then
        if DataModel.rencentlyTime == 0 then
          DataModel.rencentlyTime = endTime
        elseif endTime < DataModel.rencentlyTime then
          DataModel.rencentlyTime = endTime
        end
      end
    end
  end
end

function DataModel.InitCurrency()
  DataModel.CurrencyData = {}
  local cfg = DataModel.NDPool[DataModel.NDIndex].data
  for k, v in ipairs(cfg.goldenList) do
    local showBtn = v.showAdd and true
    local key = v.id
    DataModel.CurrencyData[k] = {
      id = v.id,
      key = key,
      showBtn = showBtn,
      imgBG = DataModel.GetSpritePath(cfg, cfg.currencyBg)
    }
  end
end

function DataModel.GetFurnitureMoney()
  return PlayerData:GetUserInfo().furniture_coins
end

function DataModel.GetYNMoney()
  return PlayerData:GetUserInfo().gold
end

function DataModel.CalcServerData(data, json)
  local extractCA = PlayerData:GetFactoryData(data.id, "ExtractFactory")
  if extractCA.type == "limitCapsule" then
    PlayerData.ServerData.user_home_info.pool = json.pool
    data.totalRemainCount = 0
    local findId = {}
    local reSort = false
    for k, v in pairs(json.pool[tostring(data.id)]) do
      if k ~= "num" then
        for k1, v1 in pairs(data.capsuleList) do
          if v1.id == tonumber(k) then
            findId[v1.id] = 1
            v1.remainCount = v
            data.totalRemainCount = data.totalRemainCount + v
          end
        end
      end
    end
    for k, v in pairs(data.capsuleList) do
      if findId[v.id] == nil then
        v.remainCount = 0
        reSort = true
      end
    end
    if reSort then
      DataModel.SortCapsuleList(data.capsuleList)
    end
  end
end

function DataModel:GetNDPool(poolList, index)
  self.NDPool = {}
  for k, v in ipairs(poolList) do
    local ca = PlayerData:GetFactoryData(v.id, "ExtractFactory")
    if ca then
      local totleWeight = 0
      for m, n in pairs(ca.capsuleList) do
        totleWeight = totleWeight + n.weight
      end
      table.insert(self.NDPool, {data = ca, totleWeight = totleWeight})
      local tools = require("UICubeRogueMain/CubeRoguePublicMethod")
      local GetRes = tools.GetTFunc(CS.ResManager, "GetRes", typeof(CS.UnityEngine.GameObject))
      DataModel.NDModel = CS.UnityEngine.GameObject.Instantiate(GetRes(ResManager, ca.modelPath, "#HomeCapsule"))
    end
  end
  table.sort(self.NDPool, function(a, b)
    if a.data.sort ~= b.data.sort then
      return a.data.sort > b.data.sort
    end
    return a.data.id > b.data.id
  end)
  PlayerData.TempCache.showCapsuleRedDot = nil
  for k, v in ipairs(self.NDPool) do
    Net:SendProto("recruit.cap_info", function(json)
      v.pool = json.pool.capsule or json.pool
      local goodsNum = 0
      for m, n in pairs(v.pool) do
        goodsNum = goodsNum + n
      end
      v.itemNum = goodsNum
      v.maxNum = json.pool.max_num
      PlayerData.SetSingleCapsuleData(v.data.id, json.pool)
    end, tostring(v.data.id))
  end
  self.NDPoolCount = #self.NDPool
  self.NDIndex = index or self.NDPoolCount > 0 and 1 or 0
end

function DataModel:PlaySound(soundId)
  local sound = SoundManager:CreateSound(soundId)
  if sound ~= nil then
    sound:Play()
  end
  return sound
end

return DataModel
