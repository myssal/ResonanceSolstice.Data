local PosClickHandler = {}
PosClickHandler.index = 0

function PosClickHandler.OnSpecialCharacterOver(id)
end

function PosClickHandler.OnSpecialCharacterTouch(id)
  if "UI/HomeBubble/InteractiveIcon/FastFood" == id then
    local Controller = require("UICityStore/UICityStoreDataModel")
    Controller:FastFoodClick()
  elseif id == "UI/Prison/Contract/PrisonContract" then
    UIManager:Open("UI/Prison/Contract/PrisonContract")
  elseif id == "UI/Prison/Contract/PrisonContractManage/PrisonContractManage" then
    UIManager:Open("UI/Prison/Contract/PrisonContractManage/PrisonContractManage")
  elseif tonumber(id) ~= nil then
    local idx = tonumber(id)
    local eventList = QuestProcess.GetCacheEventList()
    if idx <= #eventList then
      eventList[idx]:action()
    end
  elseif type(id) == "string" then
    local splits = string.split(id, "#")
    if 0 < #splits then
      if splits[1] == "tips" then
        CommonTips.OpenTips(splits[2])
        return
      end
      if splits[1] == "levelId" then
        local battleId = tonumber(splits[2])
        local backUrl = splits[3]
        local openSquadsParam = splits[4]
        if openSquadsParam == nil then
          openSquadsParam = {
            Current = "Chapter",
            squadIndex = PlayerData.BattleInfo.squadIndex,
            hasOpenThreeView = false
          }
          openSquadsParam = Json.encode(openSquadsParam)
        end
        PlayerData.Last_Chapter_Parms = {}
        PlayerData.BattleInfo.battleStageId = battleId
        PlayerData.BattleCallBackPage = backUrl
        UIManager:Open("UI/Squads/Squads", openSquadsParam)
      end
    end
  end
end

function PosClickHandler.OnTrainClose()
end

function PosClickHandler.OnFurnitureClick(pos, typeid, uid)
  if PlayerData.visitMode then
    return
  end
  if UIManager:IsPanelOpened("UI/Playground/FriendIslandUpdate/FriendUI/FriendUI") then
    return
  end
  local Controller = require("UIHomeCoach/UIHomeCoachController")
  Controller:OnFurnitureClick(pos, typeid, uid)
end

function PosClickHandler.OnSpecialFurnitureClick(pos, ufid, cid)
  if PlayerData.visitMode then
    return
  end
  if UIManager:IsPanelOpened("UI/Playground/FriendIslandUpdate/FriendUI/FriendUI") then
    return
  end
  local Controller = require("UIHomeCoach/UIHomeCoachController")
  Controller:OnSpecialFurnitureClick(pos, ufid, cid)
end

function PosClickHandler.OnReleaseFurniture()
  local Controller = require("UIHomeCoach/UIHomeCoachController")
  Controller:OnReleaseFurniture()
end

function PosClickHandler.OnReleaseSpecialFurniture()
  local Controller = require("UIHomeCoach/UIHomeCoachController")
  Controller:OnReleaseSpecialFurniture()
end

function PosClickHandler.OnHomeRoomIndex(index)
  local Controller = require("UIHomeCoach/UIHomeCoachController")
  Controller:OnHomeRoomIndex(index)
end

function PosClickHandler.OnFurniturePileUp()
  local Controller = require("UIHomeCoach/UIHomeCoachController")
  Controller:RefreshControllerPanel()
end

function PosClickHandler.OnSpecialFurnitureTipShow(id, uid)
  local Controller = require("UIHomeCoach/UIHomeCoachController")
  Controller:OnFurnitureTipShow(id, uid)
end

function PosClickHandler.OnSpecialFurnitureClickRewards(ufid)
  Net:SendProto("creature.rec_rewards", function(json)
    PlayerData.ServerData.user_home_info.furniture[ufid] = json.furniture[ufid]
    CommonTips.OpenShowItem(json.reward)
  end, ufid, 0)
end

function PosClickHandler.OnSpecialFurnitureCollectRubbish(index, ufidStr)
  local t = PlayerData.ServerData.user_home_info.furniture
  local ufids = Split(ufidStr, ",")
  local needCid = false
  for i, ufid in ipairs(ufids) do
    local data = PlayerData.ServerData.user_home_info.furniture[ufid]
    local furniture = PlayerData:GetFactoryData(data.id, "HomeFurnitureFactory")
    local tag = PlayerData:GetFactoryData(furniture.functionType, "TagFactory")
    if tag ~= nil and tag.typeName == "\229\158\131\229\156\190\230\161\182" then
      needCid = true
    end
    if needCid then
      break
    end
  end
  local ucid = PlayerData.ServerData.user_home_info.furniture[ufids[1]].u_cid
  Net:SendProto("home.collect_waste", function(json)
    for id, v in pairs(json.furniture) do
      PlayerData.ServerData.user_home_info.furniture[id] = v
    end
    CommonTips.OpenShowItem(json.reward)
  end, needCid and ucid or "", ufidStr)
end

function PosClickHandler.OnSpecialFurnitureTipIsHave(id)
  local furniture = PlayerData:GetFactoryData(id, "HomeFurnitureFactory")
  local tag = PlayerData:GetFactoryData(furniture.functionType, "TagFactory")
  if furniture.wasteoutput > 0 or tag ~= nil and tag.typeName == "\229\158\131\229\156\190\230\161\182" or tag ~= nil and tag.typeName == "\231\148\159\231\137\169" then
    return true
  end
  return false
end

function PosClickHandler.IsCargoHold(index)
  local index = index + 1
  local id = PlayerData.ServerData.user_home_info.coach[index].id
  local coachData = PlayerData:GetFactoryData(id, "HomeCoachFactory")
  if coachData.coachType and coachData.coachType ~= "" and 12600247 == coachData.coachType then
    UIManager:Open("UI/Cargocompartment/cargocompartment")
    return true
  end
  return false
end

function PosClickHandler.PetClick(pos, uId, confirmCallBack)
  if PlayerData.visitMode then
    return
  end
  local json = Json.encode({uId = uId})
  UIManager:Open("UI/HomeUpgrade/HomeBubblePet", json, confirmCallBack)
  local bubbleView = require("UIHomeBubblePet/UIHomeBubblePetView")
  local vec = Vector2(pos.x + 100, pos.y + 50)
  bubbleView.Group_Panel:SetAnchoredPosition(vec)
end

function PosClickHandler.PassengerClick(pos, uId, confirmCallBack)
  if PlayerData.visitMode then
    return
  end
  local json = Json.encode({uId = uId})
  UIManager:Open("UI/HomeUpgrade/HomeBubblePassenger", json, confirmCallBack)
  local bubbleView = require("UIHomeBubblePassenger/UIHomeBubblePassengerView")
  local vec = Vector2(pos.x + 100, pos.y + 200)
  bubbleView.Group_Panel:SetAnchoredPosition(vec)
end

function PosClickHandler.CharacterClick(characterId, confirmCallBack)
  if PlayerData.visitMode then
    return
  end
  local characterCA = PlayerData:GetFactoryData(characterId, "HomeCharacterFactory")
  if table.count(characterCA.defaultSkins) > 0 then
    UIManager:Open("UI/ChangeSkin/ChangeSkin", nil, confirmCallBack)
  end
end

function PosClickHandler.GetCoachDirtyPercent()
  local wash = PlayerData:GetHomeInfo().readiness.wash
  local percent = wash.cleanliness or 1
  return percent
end

function PosClickHandler.GetCoachDirtyType()
  local percent = PosClickHandler.GetCoachDirtyPercent()
  local homeCoachSkinCA = PlayerData:GetFactoryData(70500001, "HomeCoachSkinFactory")
  for k, v in pairs(homeCoachSkinCA.dirtySkins) do
    if percent < v.dirtyPercent then
      return k
    end
  end
  return 0
end

function PosClickHandler.RefreshLiveFurniture(ufid)
  local furnitureInfo = CommonCoachData.GetFurData()[ufid]
  if not furnitureInfo then
    return
  end
  local furCA = PlayerData:GetFactoryData(furnitureInfo.id, "HomeFurnitureFactory")
  if furCA.functionType == 12600199 and furCA.characterNum > 0 then
    for i = 1, furCA.characterNum do
      local state = furnitureInfo.roles and furnitureInfo.roles[i] and furnitureInfo.roles[i] ~= ""
      local iconPath = ""
      if state then
        local unitCA = PlayerData:GetFactoryData(furnitureInfo.roles[i], "UnitFactory")
        local unitViewCA = PlayerData:GetFactoryData(unitCA.viewId, "UnitViewFactory")
        local profilePhotoCA = PlayerData:GetFactoryData(unitViewCA.profilePhotoID, "ProfilePhotoFactory")
        iconPath = profilePhotoCA.imagePath
      end
      HomeManager:RefreshFurPhotoFrame(ufid, i, state, iconPath)
    end
    local liveDataModel = require("UINewHomeLive/UINewHomeLiveDataModel")
    if furCA.characterNum == 2 and 0 >= furCA.upgrade then
      local value = PlayerData:GetPlayerPrefs("string", "FurLightColor" .. ufid)
      if value == "" then
        value = liveDataModel.defaultLightColorType
      end
      HomeManager:ChangeFurLight(ufid, EnumDefine.EFurLightColor[value])
    elseif furCA.characterNum == 1 and 0 >= furCA.upgrade then
      local value = PlayerData:GetPlayerPrefs("string", "FurLightColor" .. ufid)
      if value == "" then
        value = liveDataModel.defaultLightColorType
      end
      HomeManager:ChangeFurMaterial(ufid, EnumDefine.EFurLightMaterialPath[value])
    end
  end
end

function PosClickHandler.GotoSleep(ufid, index)
  if PlayerData.visitMode then
    return
  end
  local furData = PlayerData:GetHomeInfo().furniture[ufid]
  local roleId = furData.roles and furData.roles[index]
  if roleId and roleId ~= "" then
    local UINewHomeLiveDataModel = require("UINewHomeLive/UINewHomeLiveDataModel")
    if UINewHomeLiveDataModel.IsInEmergency(roleId) then
      CommonTips.OpenTips(80601267)
      return
    end
    local remainTime = PlayerData:GetRoleRemainSleepTime(roleId)
    if remainTime == 0 then
      local time = math.random(25, 100)
      PlayerData:SetRoleSleepTime(roleId, time)
      remainTime = time
    end
    CharacterUtil.StartOp(roleId, ufid, index - 1, remainTime, true)
  end
end

function PosClickHandler.GetFurnitureAnimationState(ufid)
  local skinId = PosClickHandler.GetFurnitureSkinId(ufid)
  local furSkinCA = PlayerData:GetFactoryData(skinId, "HomeFurnitureFactory")
  if furSkinCA.banswitchAnimation then
    local dataModel = require("UIHome/UIHomeTradeDataModel")
    if dataModel.GetInTravel() then
      return 0
    end
  end
  local value = PlayerData:GetPlayerPrefs("int", "FurnitureAnimationState" .. ufid)
  return value
end

function PosClickHandler.GetFurnitureSkinId(ufid, coachBagTag)
  local skinId = 0
  local serverFurData
  if coachBagTag then
    serverFurData = CommonCoachData.GetFurData(coachBagTag)
    if serverFurData == nil then
      return ""
    end
    serverFurData = serverFurData[ufid]
  else
    for k, v in pairs(EnumDefine.CoachBagTagToFurBagKey) do
      serverFurData = PlayerData:GetHomeInfo()[v]
      if PlayerData.visitMode then
        serverFurData = PlayerData.visitInfo.furdata
      end
      local strK = tostring(k)
      if serverFurData and serverFurData[strK] and serverFurData[strK][ufid] then
        serverFurData = serverFurData[strK][ufid]
        break
      elseif serverFurData and serverFurData[ufid] then
        serverFurData = serverFurData[ufid]
        break
      end
    end
  end
  if serverFurData.u_skin ~= nil and serverFurData.u_skin ~= "" then
    skinId = tonumber(PlayerData:GetHomeInfo().furniture_skins[serverFurData.u_skin].id)
  else
    local furCA = PlayerData:GetFactoryData(serverFurData.id, "HomeFurnitureFactory")
    if furCA == nil then
      error("\229\174\182\229\133\183 ufid :" .. ufid .. " \229\174\182\229\133\183id : " .. (serverFurData.id or 0) .. " \229\174\162\230\136\183\231\171\175\228\184\141\229\173\152\229\156\168\233\133\141\231\189\174")
    end
    if PlayerData.ServerData.user_info.gender == 0 and 0 < furCA.FemaleFurnitureSkin then
      return furCA.FemaleFurnitureSkin
    end
    skinId = furCA.defaultSkin
  end
  return skinId
end

function PosClickHandler.GetRoomIsHaveEmptyTile(roomIdx)
  return true
end

function PosClickHandler.IsStopCarriage(id)
  local coachData = PlayerData:GetFactoryData(id)
  if coachData.coachType and coachData.coachType ~= "" then
    local tagCA = PlayerData:GetFactoryData(coachData.coachType)
    if tagCA.stopCarriage then
      return true
    end
  end
  return false
end

function PosClickHandler.ClickCoach(index)
  local CarriageDataModel = require("UIHomeCarriageeditor/UIHomeCarriageeditorDataModel")
  local t = {
    CurrTag = CarriageDataModel.TagType.Edit
  }
  HomeTrainManager:EnabledCoachSkinClick(false)
  CommonTips.OpenToHomeCarriageeditor(t)
end

function PosClickHandler.GetRoomEmptyTileCount(roomIdx)
  local room = HomeManager:GetRoom(roomIdx - 1)
  if room then
    return room:GetEmptyTilesCount()
  end
  return 0
end

return PosClickHandler
