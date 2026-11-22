local CharacterUtil = {}
local opCharacterIds = {}

local function IsRandomCharacterFurniture(ufid)
  local furData = PlayerData:GetFurniture()[ufid]
  if not furData then
    return false
  end
  local furCA = PlayerData:GetFactoryData(furData.id, "HomeFurnitureFactory")
  if not furCA then
    return false
  end
  local functionType = tonumber(furCA.functionType)
  return functionType == 12600199 or functionType == 12600296
end

function CharacterUtil.GetOpHomeCharacter(uid)
  if not uid or uid == "" then
    return
  end
  local characterId = opCharacterIds[tostring(uid)]
  if characterId then
    return HomeCharacterManager:GetCharacterById(characterId)
  end
  return CharacterUtil.GetHomeCharacterById(uid)
end

function CharacterUtil.GetHomeCharacterById(uid)
  if not uid or uid == "" then
    return
  end
  local unitCA = PlayerData:GetFactoryData(uid, "UnitFactory")
  local characterId = tonumber(unitCA.homeCharacter)
  local character = HomeCharacterManager:GetCharacterById(characterId)
  return character
end

function CharacterUtil.GetHomeCharacter2ById(uid)
  if not uid or uid == "" then
    return
  end
  local unitCA = PlayerData:GetFactoryData(uid, "UnitFactory")
  local characterId = tonumber(unitCA.homeCharacter2)
  if not characterId or characterId <= 0 then
    return
  end
  local character = HomeCharacterManager:GetCharacterById(characterId)
  return character
end

function CharacterUtil.CreateHomeCharacter(uid, roomIndex, tileIndex, characterId)
  if not uid or uid == "" then
    return
  end
  if not characterId then
    local unitCA = PlayerData:GetFactoryData(uid, "UnitFactory")
    characterId = tonumber(unitCA.homeCharacter)
  else
    characterId = tonumber(characterId)
  end
  if not characterId or characterId <= 0 then
    return
  end
  return HomeCharacterManager:CreateCharacter(characterId, roomIndex, tileIndex)
end

function CharacterUtil.GetFurnitureRoomIndexAndTileIndex(ufid)
  local furData = PlayerData:GetFurniture()[ufid]
  local MainUIDataModel = require("UIMainUI/UIMainUIDataModel")
  local roomIndex = MainUIDataModel.GetRoomIndexByUCid(furData.u_cid)
  if not roomIndex then
    return
  end
  local homeFurniture = HomeManager:GetFurnitureByUfid(ufid, roomIndex)
  local tileIndex = homeFurniture and homeFurniture:GetTileIdx()
  return roomIndex, tileIndex
end

local function GetOrCreateOpCharacter(uid, ufid, needCreate)
  if not uid or uid == "" then
    return
  end
  local key = tostring(uid)
  local unitCA = PlayerData:GetFactoryData(uid, "UnitFactory")
  local primaryId = tonumber(unitCA.homeCharacter)
  local secondaryId = tonumber(unitCA.homeCharacter2)
  local useRandom = IsRandomCharacterFurniture(ufid)
  local characterId = primaryId
  if useRandom then
    characterId = opCharacterIds[key]
    if characterId ~= primaryId and characterId ~= secondaryId then
      characterId = nil
    end
    if not characterId then
      characterId = primaryId
      if secondaryId and 0 < secondaryId and math.random(1, 2) == 2 then
        characterId = secondaryId
      end
    end
  end
  if not characterId or characterId <= 0 then
    return
  end
  local character = HomeCharacterManager:GetCharacterById(characterId)
  if not character and (needCreate or useRandom) then
    local roomIndex, tileIndex = CharacterUtil.GetFurnitureRoomIndexAndTileIndex(ufid)
    if roomIndex == nil or tileIndex == nil then
      return
    end
    character = CharacterUtil.CreateHomeCharacter(uid, roomIndex, tileIndex, characterId)
  end
  if not character then
    return
  end
  if useRandom then
    opCharacterIds[key] = characterId
  end
  return character
end

function CharacterUtil.InitOp(uid, ufid, opIndex, opTime)
  local character = GetOrCreateOpCharacter(uid, ufid, true)
  if not character then
    return
  end
  character.aiPart:Stop()
  character.movePart:Stop()
  HomeCharacterManager:InitContinuousOp(character, ufid, opIndex, opTime)
end

function CharacterUtil.StartOp(uid, ufid, opIndex, opTime, needCreate)
  local character = GetOrCreateOpCharacter(uid, ufid, needCreate)
  if not character then
    return
  end
  character.aiPart:Stop()
  HomeCharacterManager:StartOp(character, ufid, opIndex, opTime)
end

function CharacterUtil.StopOp(uid, isCaption)
  if not uid or uid == "" then
    return
  end
  local character = CharacterUtil.GetOpHomeCharacter(uid)
  local characterId = character and character.ca.id
  if character then
    character.aiPart:Stop()
    HomeCharacterManager:StopOp(character)
    if character.workPart.opTime ~= 0 then
      if character.movePart.IsMoving then
        character.workPart:ResetOpData()
        character.tagPart:Delete("\228\184\141\232\131\189\230\137\147\230\150\173")
        character:ResetAIPart()
      else
        character.workPart:ResetOpData()
        character.tagPart:Delete("\228\184\141\232\131\189\230\137\147\230\150\173")
        HomeCharacterManager:RemoveCharacter(character)
        local HomeDataModel = require("UIHomeCoach/UIHomeCoachDataModel")
        local roomCount = HomeDataModel.GetRoomCount()
        local roomIndex
        if isCaption then
          if 0 < PosClickHandler.GetRoomEmptyTileCount(1) then
            roomIndex = 1
          end
        else
          local curRoomIndex = HomeManager.camRoom + 1
          if 0 < PosClickHandler.GetRoomEmptyTileCount(curRoomIndex) then
            roomIndex = curRoomIndex
          else
            for i = 2, roomCount do
              if i ~= curRoomIndex and 0 < PosClickHandler.GetRoomEmptyTileCount(i) then
                roomIndex = i
                break
              end
            end
          end
        end
        if roomIndex then
          character = CharacterUtil.CreateHomeCharacter(uid, roomIndex - 1, -1, characterId)
        end
      end
    else
      character:ResetAIPart()
    end
  end
  opCharacterIds[tostring(uid)] = nil
end

function CharacterUtil.InitCharacterOp()
  local liveController = require("UINewHomeLive/UINewHomeLiveController")
  local emergencyDataModel = require("UIHomeEmergency/UIHomeEmergencyDataModel")
  local homeFoodController = require("UIHomeFood/UIHomeFoodController")
  liveController.InitSleep()
  emergencyDataModel.InitEmergency()
  homeFoodController.InitFoodCook()
end

function CharacterUtil.FocusResetMovePart()
  for unitId, v in pairs(PlayerData.ServerData.roles) do
    local character1 = CharacterUtil.GetHomeCharacterById(unitId)
    local character2 = CharacterUtil.GetHomeCharacter2ById(unitId)
    if character1 then
      character1.movePart:Stop()
    end
    if character2 and character2 ~= character1 then
      character2.movePart:Stop()
    end
  end
end

function CharacterUtil.GetCharacterAllSkinJson(characterId)
  characterId = tonumber(characterId)
  if characterId ~= ChangeSkinUtil.GetCaptainCharacterId() then
    return
  end
  local normalSkinItems = ChangeSkinUtil.InitNormalSkinItems()
  local overlaySkinItems = ChangeSkinUtil.InitOverlaySkinItems()
  local skinJson, attachmentsJson, atlasSkinJson, atlasOverlaySkinJson = ChangeSkinUtil.GetAllSkinJson(normalSkinItems, overlaySkinItems)
  local hairColorCurves = ""
  local hairColorMask = ""
  local hairColorTagId = ChangeSkinUtil.GetHairColor(normalSkinItems[EnumDefine.ESkinType.Hair])
  if hairColorTagId then
    local tagCA = PlayerData:GetFactoryData(hairColorTagId, "TagFactory")
    if tagCA then
      hairColorCurves = tagCA.hairColorCurves or ""
      hairColorMask = tagCA.hairColorMask or ""
    end
  end
  return {
    [1] = skinJson or "",
    [2] = attachmentsJson or "",
    [3] = atlasSkinJson or "",
    [4] = atlasOverlaySkinJson or "",
    [5] = hairColorCurves,
    [6] = hairColorMask
  }
end

function CharacterUtil.InitCharacterSpineSkin(characterId)
  characterId = tonumber(characterId)
  if characterId ~= ChangeSkinUtil.GetCaptainCharacterId() then
    return
  end
  ChangeSkinUtil.InitHomeCaptainSpineSkin()
  ChangeSkinUtil.InitHomeCaptainSpineHairColor()
end

return CharacterUtil
