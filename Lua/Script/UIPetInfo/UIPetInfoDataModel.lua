local DataModel = {}

local function CalPetScores(petInfo)
  local petScoresConfig = PlayerData:GetFactoryData(99900022).petScoresConfig
  local scores = PlayerData:GetFactoryData(petInfo.id).petBaseScore
  for i, v in ipairs(petScoresConfig) do
    if petInfo.lv < v.level then
      break
    end
    scores = scores + v.scores
  end
  if petInfo.u_fid and petInfo.u_fid ~= "" then
    local buffName = EnumDefine.HomeSkillEnum.AddPetScores
    local furData = CommonCoachData.GetFurData()[petInfo.u_fid]
    local furBuff = PlayerData.GetFurSkillFur(furData.id)
    local carriageBuff = PlayerData.GetFurSkillCarriage(furData.u_cid)
    local furBuffAdd = furBuff[buffName] or 0
    local carriageBuffAdd = carriageBuff[buffName] or 0
    local trainBuffAdd = PlayerData.GetFurSkillTrainByName(buffName)
    local homeBuffAdd = PlayerData:GetHomeSkillIncrease(buffName)
    scores = scores * (1 + furBuffAdd + carriageBuffAdd + trainBuffAdd + homeBuffAdd)
  end
  return scores
end

function DataModel:GetDay()
  local time = PlayerData:GetSeverTime() - DataModel.currPet.serverData.obtain_time
  local day = math.floor(time / 3600 / 24)
  return day
end

local function GetNextLevelFavor(lv)
  local petScoresConfig = PlayerData:GetFactoryData(99900022).petScoresConfig
  local max = #petScoresConfig
  DataModel.maxLevel = #petScoresConfig + 1
  if lv > max then
    return petScoresConfig[max].Favorability
  end
  return petScoresConfig[lv].Favorability
end

local function Init(data)
  DataModel.petList = data.petList
  DataModel.selectIndex = tonumber(data.selectIndex)
  DataModel.petCount = #data.petList
  DataModel.pet_uid = DataModel.petList[DataModel.selectIndex]
  DataModel.feedMax = PlayerData:GetFactoryData(99900022).feedCount
  DataModel.extraAdd = PlayerData:GetFactoryData(99900022).feedAddition
  local petInfo = DataModel.GetServerPetData()[DataModel.pet_uid]
  local petCfg = PlayerData:GetFactoryData(petInfo.id)
  DataModel.petVarity = petCfg.petVarity
  DataModel.petSpinePath = PlayerData:GetFactoryData(petCfg.homeCharacter).resDir
  DataModel.petInfoRatio = PlayerData:GetFactoryData(petCfg.homeCharacter).petInfoRatio
  DataModel.petScore = DataModel.CalPetScores(petInfo)
  DataModel.lvFavorMax = DataModel.GetNextLevelFavor(petInfo.lv)
  DataModel.CalPetFurPos()
  local petScoresConfig = PlayerData:GetFactoryData(99900022).petScoresConfig
  DataModel.maxLevel = petScoresConfig[#petScoresConfig].level
  DataModel.is_random = false
end

local function ChangePet(isNext)
  if isNext then
    DataModel.selectIndex = DataModel.selectIndex + 1 > DataModel.petCount and 1 or DataModel.selectIndex + 1
  else
    DataModel.selectIndex = DataModel.selectIndex - 1 < 1 and DataModel.petCount or DataModel.selectIndex - 1
  end
  DataModel.pet_uid = DataModel.petList[DataModel.selectIndex]
  local petInfo = DataModel.GetServerPetData()[DataModel.pet_uid]
  local petCfg = PlayerData:GetFactoryData(petInfo.id)
  DataModel.petVarity = petCfg.petVarity
  DataModel.petSpinePath = PlayerData:GetFactoryData(petCfg.homeCharacter).resDir
  DataModel.petInfoRatio = PlayerData:GetFactoryData(petCfg.homeCharacter).petInfoRatio
  DataModel.pet_uid = DataModel.petList[DataModel.selectIndex]
  DataModel.petScore = DataModel.CalPetScores(petInfo)
  DataModel.lvFavorMax = DataModel.GetNextLevelFavor(petInfo.lv)
  DataModel.is_random = false
  if DataModel.tween then
    DOTweenTools.KillAll()
  end
end

local function GetPetState(status_level)
  local lv = 15 <= status_level and 15 or status_level
  lv = lv <= 0 and 1 or lv
  local petStateConfig = PlayerData:GetFactoryData(99900022).petStateConfig
  for i, v in ipairs(petStateConfig) do
    if lv >= v.petStateMin and lv <= v.petStateMax then
      return v.stateName
    end
  end
end

local function FoodExtraAdd(foodId)
  local extraAdd = -1
  local cfg = PlayerData:GetFactoryData(foodId)
  for k, v in pairs(cfg.usedPetVarity) do
    if v.id == DataModel.petVarity then
      extraAdd = 1
      break
    end
  end
  return extraAdd
end

local function GetFoodList()
  DataModel.foodList = {}
  if PlayerData.visitMode then
    local petInfo = DataModel.GetServerPetData()[DataModel.pet_uid]
    local petCfg = PlayerData:GetFactoryData(petInfo.id)
    local cfg = PlayerData:GetFactoryData(petCfg.homeCharacter)
    for k, v in pairs(cfg.PetExpSourceMaterialList) do
      local data = PlayerData:GetMaterials()[tostring(v.id)]
      if data and data.num ~= 0 then
        table.insert(DataModel.foodList, {
          id = data.id,
          num = data.num
        })
      end
    end
    return
  end
  local foodItemList = PlayerData:GetFactoryData(99900022).favorItemList
  for i, v in ipairs(foodItemList) do
    local data = PlayerData:GetMaterials()[tostring(v.id)]
    if data and data.num ~= 0 then
      local extraAdd = FoodExtraAdd(data.id)
      table.insert(DataModel.foodList, {
        id = data.id,
        num = data.num,
        extraAdd = extraAdd
      })
    end
  end
  table.sort(DataModel.foodList, function(t1, t2)
    if t1.extraAdd ~= t2.extraAdd then
      return t1.extraAdd > t2.extraAdd
    end
    local quality1 = PlayerData:GetFactoryData(t1.id).qualityInt
    local quality2 = PlayerData:GetFactoryData(t2.id).qualityInt
    if quality1 ~= quality2 then
      return quality1 > quality2
    end
    return t1.id > t2.id
  end)
end

local function GetRoomIdAndPosx(ufid)
  local roomId = -1
  local posx = 0
  local roomList = PlayerData:GetHomeInfo().coach_template
  local furniture = CommonCoachData.GetFurData()[ufid]
  local coach_store = PlayerData:GetHomeInfo().coach_store
  if PlayerData.visitMode then
    roomList = PlayerData.visitInfo.coach_template
    coach_store = PlayerData.visitInfo.coach_store
  end
  for i, v in ipairs(roomList) do
    local cfgId = coach_store[v].id
    local coachType = PlayerData:GetFactoryData(cfgId).coachType
    local tagCA = PlayerData:GetFactoryData(coachType)
    if not tagCA.stopCarriage then
      roomId = roomId + 1
      if v == furniture.u_cid then
        posx = HomeManager.rooms[roomId]:GetFurniture(ufid).PosX
        break
      end
    end
  end
  return roomId, posx
end

local function CalPetFurPos()
  DataModel.petFurList = {}
  local furniture = CommonCoachData.GetFurData()
  for k, v in pairs(furniture) do
    local functionType = PlayerData:GetFactoryData(v.id).functionType
    if functionType == 12600464 then
      local data = {}
      data.roomId, data.posx = GetRoomIdAndPosx(k)
      DataModel.petFurList[k] = data
    end
  end
end

local function GetPetAniName(aniType)
  local petInfo = DataModel.GetServerPetData()[DataModel.pet_uid]
  local petCfg = PlayerData:GetFactoryData(petInfo.id)
  local homeCharacter = PlayerData:GetFactoryData(petCfg.homeCharacter)
  local ani_name
  DataModel.is_random = false
  if aniType == 1 then
    ani_name = homeCharacter.stand
  elseif aniType == 2 then
    ani_name = homeCharacter.eat
  elseif aniType == 3 then
    local petInteractionList = homeCharacter.petInteractionList or {}
    if next(petInteractionList) then
      ani_name = petInteractionList[math.random(1, #petInteractionList)].interaction
      DataModel.is_random = true
    end
  end
  return ani_name
end

function DataModel.GetServerPetData()
  if PlayerData.visitMode then
    return PlayerData.visitInfo.pets
  end
  return PlayerData:GetHomeInfo().pet
end

DataModel.CalPetScores = CalPetScores
DataModel.GetNextLevelFavor = GetNextLevelFavor
DataModel.Init = Init
DataModel.ChangePet = ChangePet
DataModel.GetPetState = GetPetState
DataModel.GetFoodList = GetFoodList
DataModel.CalPetFurPos = CalPetFurPos
DataModel.GetPetAniName = GetPetAniName
return DataModel
