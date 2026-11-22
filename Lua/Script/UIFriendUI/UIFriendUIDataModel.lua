local View = require("UIFriendUI/UIFriendUIView")
local DataModel = {}
DataModel.selfHomeRubFurId = 81300043
DataModel.playgroundId = 87300002
DataModel.friendServerData = {}
DataModel.otherInfo = {}
DataModel.ownOtherInfo = {}
DataModel.petReduceRate = 0
DataModel.protectNum = 0
DataModel.reload = false
DataModel.cacheBattleChaInfo = {}
DataModel.battleFindIdx = 1

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.reload = data.reload
  DataModel.friendServerData = data.friendServerData
  DataModel.otherInfo = data.otherInfo
  DataModel.ownOtherInfo = data.ownOtherInfo
  DataModel.petReduceRate = data.petReduceRate
end

function DataModel.InitData()
  for i, v in pairs(CommonCoachData.GetFurData()) do
    local furCA = PlayerData:GetFactoryData(v.id, "HomeFurnitureFactory")
    if furCA and furCA.functionType == 12600474 then
      DataModel.selfHomeRubFurId = v.id
      break
    end
  end
  DataModel.protectNum = DataModel.friendServerData.guarantee or 0
end

function DataModel.RefreshOnShow()
  local playgroundData = DataModel.friendServerData.playground[tostring(DataModel.playgroundId)]
  local avatar = DataModel.friendServerData.avatar
  local gender = DataModel.friendServerData.gender
  local roleName = DataModel.friendServerData.role_name
  if avatar and avatar ~= "" then
    local profilePhotoCA = PlayerData:GetFactoryData(avatar, "ProfilePhotoFactory")
    View.Img_LV.Btn_ProfilePhoto.Img_Client:SetSprite(profilePhotoCA.imagePath)
  else
    local head = PlayerData:GetFactoryData(99900001, "ConfigFactory")
    if head and head.playerHeadList then
      View.Img_LV.Btn_ProfilePhoto.Img_Client:SetSprite(head.playerHeadList[gender + 1].playerHeadPath)
    end
  end
  View.Img_LV.Img_FriendNameBg.Txt_FriendName:SetText(roleName)
  View.Img_LV.Txt_Num:SetText(playgroundData.lv)
  local monsterNum = playgroundData.levels and table.count(playgroundData.levels) or 0
  View.Btn_Moster.Txt_Num:SetText(monsterNum)
  local totalGiveLikeNum = DataModel.otherInfo.fg_being_like_count
  View.Img_LV.Txt_GoodNum:SetText(totalGiveLikeNum)
  local remainHelpNum, maxHelpNum = DataModel.GetHelpNumInfo()
  View.Group_Info.Group_Help.Txt_Num:SetText(remainHelpNum .. "/" .. maxHelpNum)
  local remainCleanNum, maxCleanNum = DataModel.GetCleanNumInfo()
  View.Group_Info.Group_Clear.Txt_Num:SetText(remainCleanNum .. "/" .. maxCleanNum)
  local cd = DataModel.GetCleanCD(DataModel.friendServerData.uid)
  if 0 < cd then
    View.Group_Info.Group_ClearCD.Txt_Num:SetText(cd)
  end
  View.Group_Info.Group_ClearCD:SetActive(0 < cd)
  local rate = DataModel.GetCleanSuccessRate()
  View.Group_Info.Group_ClearRate.Txt_Num:SetText(ClearFollowZero(rate * 100) .. "%")
  local cleanFunOpen = DataModel.IsCleanFunOpen()
  View.Btn_Clean:SetActive(cleanFunOpen)
  View.Img_CantClear:SetActive(not cleanFunOpen)
  local wasteNum = playgroundData.rubbish_area.waste_block
  local canClean = cleanFunOpen and wasteNum > DataModel.protectNum
  View.Group_Reward:SetActive(canClean)
  local giveLike = false
  local giveLikeList = PlayerData:GetUserInfo().fg_give_like_list or {}
  for i, v in pairs(giveLikeList) do
    if v == DataModel.friendServerData.uid then
      giveLike = true
      break
    end
  end
  View.Btn_Good:SetActive(not giveLike)
  View.Img_Gooded:SetActive(giveLike)
  local friendListDataModel = require("UIFriendList/UIFriendListDataModel")
  local friendIndex = friendListDataModel.GetFriendIndex(DataModel.friendServerData.uid) or 1
  local lastFriend = 1 < friendIndex
  View.Btn_Last:SetActive(lastFriend)
  View.Img_CantLast:SetActive(not lastFriend)
  local nextFriend = friendIndex < #friendListDataModel.friends
  View.Btn_Next:SetActive(nextFriend)
  View.Img_CantNext:SetActive(not nextFriend)
  DataModel.ReloadPlayground()
end

function DataModel.IsCleanFunOpen()
  local selfPlaygroundData = PlayerData.GetPlaygroundData(DataModel.playgroundId)
  local selfPlaygroundLv = selfPlaygroundData and selfPlaygroundData.lv or 0
  local playgroundCA = PlayerData:GetFactoryData(DataModel.playgroundId, "PlaygroundFactory")
  if selfPlaygroundLv < playgroundCA.isLvMin then
    return false
  end
  local selfRubLv = PlayerData:GetFactoryData(DataModel.selfHomeRubFurId, "HomeFurnitureFactory").Level
  if selfRubLv < playgroundCA.rubLvMin then
    return false
  end
  return true
end

function DataModel.GetHelpNumInfo()
  local playgroundCA = PlayerData:GetFactoryData(DataModel.playgroundId, "PlaygroundFactory")
  local curHelpNum = PlayerData:GetUserInfo().fg_help_count or 0
  return playgroundCA.helpNum - curHelpNum, playgroundCA.helpNum
end

function DataModel.GetCleanNumInfo()
  local playgroundCA = PlayerData:GetFactoryData(DataModel.playgroundId, "PlaygroundFactory")
  local remainNum = playgroundCA.stealNum
  local data = PlayerData:GetUserInfo().fg_steal_info
  if data then
    local stealInfo = data[tostring(DataModel.friendServerData.uid)]
    if stealInfo then
      remainNum = remainNum - stealInfo.count
    end
  end
  return remainNum, playgroundCA.stealNum
end

function DataModel.GetCleanCD(uid)
  local playgroundCA = PlayerData:GetFactoryData(DataModel.playgroundId, "PlaygroundFactory")
  local data = PlayerData:GetUserInfo().fg_steal_info
  if data then
    local stealInfo = data[tostring(uid)]
    if stealInfo then
      local cd = playgroundCA.stealCD - (TimeUtil:GetServerTimeStamp() - stealInfo.ts)
      if cd < 0 then
        cd = 0
      end
      return cd
    end
  end
  return 0
end

function DataModel.CheckCleanTips(playgroundData, protectNum)
  local remainNum = DataModel.GetCleanNumInfo()
  if remainNum == 0 then
    return 80610168
  end
  local cd = DataModel.GetCleanCD(DataModel.friendServerData.uid)
  if 0 < cd then
    return 80610169
  end
  local rubbishInfo = playgroundData.rubbish_area
  local rubbishNum = rubbishInfo and rubbishInfo.waste_block or 0
  if protectNum >= rubbishNum then
    return 80610170
  end
  local addCapacity = PlayerData:GetHomeSkillIncrease(EnumDefine.HomeSkillEnum.RiseTrashStagingLimited)
  local maxBlock = PlayerData:GetFactoryData(DataModel.selfHomeRubFurId, "HomeFurnitureFactory").StoreRubbishMax + addCapacity
  local rubbishData = PlayerData:GetHomeInfo().rubbish_area
  local remainBlock = maxBlock - rubbishData.waste_block
  if remainBlock <= 0 then
    return 80610171
  end
  return 0
end

function DataModel.CleanClick()
  local playgroundData = DataModel.friendServerData.playground[tostring(DataModel.playgroundId)]
  local cleanTips = DataModel.CheckCleanTips(playgroundData, DataModel.protectNum)
  if cleanTips ~= 0 then
    CommonTips.OpenTips(cleanTips)
    return
  end
  Net:SendProto("playground.fg_steal", function(json)
    if json.other_info then
      DataModel.otherInfo = json.other_info
    end
    if json.own_other_info then
      DataModel.ownOtherInfo = json.own_other_info
    end
    if json.other_playground then
      local newPlayGroundData = json.other_playground[tostring(DataModel.playgroundId)]
      if newPlayGroundData then
        playgroundData.levels = newPlayGroundData.levels
        playgroundData.rubbish_area = newPlayGroundData.rubbish_area
      end
    end
    if json.pet_reduce_rate then
      DataModel.petReduceRate = json.pet_reduce_rate
    end
    if json.other_guarantee then
      DataModel.protectNum = json.other_guarantee
    end
    if json.status == 0 then
      CommonTips.OpenTips(80610170)
      View.Group_Reward:SetActive(false)
      return
    end
    UIManager:Open("UI/Playground/FriendIslandUpdate/FightAward/StealResult", Json.encode({
      stealNum = json.steal_num
    }))
    local rubbishData = PlayerData:GetHomeInfo().rubbish_area
    rubbishData.waste_block = rubbishData.waste_block + json.steal_num
    local storeMax = PlayerData:GetFactoryData(DataModel.selfHomeRubFurId, "HomeFurnitureFactory").StoreRubbishMax
    if storeMax < rubbishData.waste_block then
      rubbishData.waste_block = storeMax
    end
    local wasteNum = playgroundData.rubbish_area.waste_block
    local canClean = wasteNum > DataModel.protectNum
    View.Group_Reward:SetActive(canClean)
    local remainCleanNum, maxCleanNum = DataModel.GetCleanNumInfo()
    View.Group_Info.Group_Clear.Txt_Num:SetText(remainCleanNum .. "/" .. maxCleanNum)
    View.Group_Info.Group_ClearCD:SetActive(true)
    View.Group_Info.Group_ClearCD.Txt_Num:SetText(DataModel.GetCleanCD(DataModel.friendServerData.uid))
    local rate = DataModel.GetCleanSuccessRate()
    View.Group_Info.Group_ClearRate.Txt_Num:SetText(ClearFollowZero(rate * 100) .. "%")
    local cleanRate = DataModel.GetCleanRate()
    View.Group_RateTips.Img_Tips.Txt_Tips:SetText(string.format(GetText(80610072), ClearFollowZero(cleanRate * 100), ClearFollowZero(DataModel.petReduceRate * 100)))
  end, DataModel.friendServerData.uid, DataModel.playgroundId)
end

function DataModel.GiveLikeClick()
  local playgroundData = DataModel.friendServerData.playground[tostring(DataModel.playgroundId)]
  Net:SendProto("playground.fg_give_like", function(json)
    if json.other_playground then
      local newPlayGroundData = json.other_playground[tostring(DataModel.playgroundId)]
      if newPlayGroundData then
        playgroundData.levels = newPlayGroundData.levels
        playgroundData.rubbish_area = newPlayGroundData.rubbish_area
      end
    end
    if json.other_info then
      DataModel.otherInfo = json.other_info
      local totalGiveLikeNum = DataModel.otherInfo.fg_being_like_count
      View.Img_LV.Txt_GoodNum:SetText(totalGiveLikeNum)
    end
    if json.own_other_info then
      DataModel.ownOtherInfo = json.own_other_info
    end
    View.Btn_Good:SetActive(false)
    View.Img_Gooded:SetActive(true)
  end, DataModel.friendServerData.uid, DataModel.playgroundId)
end

function DataModel.VisitLastClick()
  local FriendListDataModel = require("UIFriendList/UIFriendListDataModel")
  local curVisitFriendIndex = FriendListDataModel.GetFriendIndex(DataModel.friendServerData.uid)
  DataModel.VisitFriend(curVisitFriendIndex - 1)
end

function DataModel.VisitNextClick()
  local FriendListDataModel = require("UIFriendList/UIFriendListDataModel")
  local curVisitFriendIndex = FriendListDataModel.GetFriendIndex(DataModel.friendServerData.uid)
  DataModel.VisitFriend(curVisitFriendIndex + 1)
end

function DataModel.VisitFriend(friendIndex)
  local UIFriendListDataModel = require("UIFriendList/UIFriendListDataModel")
  if friendIndex == 0 or friendIndex > #UIFriendListDataModel.friends then
    return
  end
  local data = UIFriendListDataModel.friends[friendIndex]
  UIFriendListDataModel.curVisitFriendUid = data.uid
  Net:SendProto("playground.fg_look", function(json)
    if json.other_playground then
      local playgroundData = data.playground[tostring(DataModel.playgroundId)]
      local newPlayGroundData = json.other_playground[tostring(DataModel.playgroundId)]
      if newPlayGroundData then
        playgroundData.levels = newPlayGroundData.levels
        playgroundData.rubbish_area = newPlayGroundData.rubbish_area
      end
    end
    if json.other_guarantee then
      data.guarantee = json.other_guarantee
    end
    if UIManager:IsPanelOpened("UI/Playground/FriendIslandUpdate/FriendList/FriendList") then
      local UIFriendUIView = require("UIFriendUI/UIFriendUIView")
      UIFriendUIView.self:CloseUI()
    end
    HomeCharacterManager:RecycleAll()
    CommonTips.OpenLoadingCB(function()
      UIManager:Pause(false)
      View.self:StartC(LuaUtil.cs_generator(function()
        LoadingManager:SetLoadingPercent(0.3)
        coroutine.yield(CS.UnityEngine.WaitForSeconds(0.5))
        DataModel.reload = true
        DataModel.friendServerData = data
        DataModel.ownOtherInfo = json.own_other_info
        DataModel.otherInfo = json.other_info
        DataModel.petReduceRate = json.pet_reduce_rate or 0
        DataModel.InitData()
        DataModel.RefreshOnShow()
        LoadingManager:SetLoadingPercent(0.8)
        coroutine.yield(CS.UnityEngine.WaitForSeconds(0.1))
        LoadingManager:SetLoadingPercent(1)
      end))
    end)
  end, data.uid, DataModel.playgroundId)
end

function DataModel.GoBackSelfPlayground()
  CommonTips.OpenLoadingCB(function()
    UIManager:Pause(false)
    View.self:StartC(LuaUtil.cs_generator(function()
      LoadingManager:SetLoadingPercent(0.3)
      coroutine.yield(CS.UnityEngine.WaitForSeconds(0.5))
      LoadingManager:SetLoadingPercent(0.8)
      coroutine.yield(CS.UnityEngine.WaitForSeconds(0.1))
      LoadingManager:SetLoadingPercent(1)
    end))
    local PlaygroundDataModel = require("UIPlayground/UIPlaygroundDataModel")
    PlaygroundDataModel.isLoad = false
    HomeCharacterManager:RecycleAll()
    UIManager:Open("UI/Playground/Playground", Json.encode(PlaygroundDataModel.initParams))
  end)
end

function DataModel.GetPlaygroundBlockData(playgroundData)
  local t = {}
  for k, v in pairs(playgroundData.block) do
    local info = Clone(v)
    info.ucid = k
    table.insert(t, info)
  end
  table.sort(t, function(a, b)
    if a.create_ts == nil and b.create_ts ~= nil then
      return true
    end
    if a.create_ts ~= nil and b.create_ts == nil then
      return false
    end
    if a.create_ts == nil and b.create_ts == nil then
      return false
    end
    return a.create_ts < b.create_ts
  end)
  return t
end

function DataModel.GetPlaygroundData(playgroundData, serverFurs, serverFurSkins, gender)
  local roomUCidList = {}
  local roomIdList = {}
  local roomData = {}
  local roomSkinIds = {}
  local roomFurnitureData = {}
  local blockData = DataModel.GetPlaygroundBlockData(playgroundData)
  for roomIndex, block in ipairs(blockData) do
    local coachCA = PlayerData:GetFactoryData(block.id, "HomeCoachFactory")
    local ucid = block.ucid
    table.insert(roomUCidList, ucid)
    table.insert(roomIdList, tonumber(block.id))
    local cacheUfid = {}
    local roomFur = {}
    local roomJson = {}
    for furIndex, location in ipairs(block.location) do
      local furData = serverFurs[location.id]
      if not cacheUfid[location.id] then
        cacheUfid[location.id] = 1
        local skinId
        if furData.u_skin and furData.u_skin ~= "" then
          skinId = tonumber(serverFurSkins[furData.u_skin].id)
        else
          local furCA = PlayerData:GetFactoryData(furData.id, "HomeFurnitureFactory")
          if gender == 0 and 0 < furCA.FemaleFurnitureSkin then
            skinId = furCA.FemaleFurnitureSkin
          else
            skinId = furCA.defaultSkin
          end
        end
        table.insert(roomFur, {
          id = furData.id,
          ufid = location.id,
          skinId = skinId
        })
        local t = {
          [1] = {
            id = furData.id,
            ufid = location.id,
            skinId = skinId,
            x = location.x,
            y = location.y,
            r = location.r or 0,
            z = location.z or 0
          }
        }
        roomJson[tostring(furIndex)] = t
      end
    end
    if 0 < table.count(roomJson) then
      table.insert(roomData, Json.encode(roomJson))
    else
      table.insert(roomData, "{}")
    end
    table.insert(roomFurnitureData, roomFur)
    local skinId = coachCA.defaultSkin
    if block.skin then
      skinId = tonumber(block.skin)
    end
    table.insert(roomSkinIds, skinId)
  end
  return roomUCidList, roomIdList, roomData, roomSkinIds, roomFurnitureData
end

function DataModel.ReloadPlayground()
  if not DataModel.reload then
    return
  end
  DataModel.reload = false
  local playgroundData = DataModel.friendServerData.playground[tostring(DataModel.playgroundId)]
  local playgroundFurs = DataModel.friendServerData.facility
  local playgroundFurSkins = DataModel.friendServerData.furniture_skins
  local gender = DataModel.friendServerData.gender
  local _, roomIdList, roomData = DataModel.GetPlaygroundData(playgroundData, playgroundFurs, playgroundFurSkins, gender)
  HomeManager:RefreshData(roomIdList, roomData)
  local homeCommon = require("Common/HomeCommon")
  homeCommon.TempRefreshRoomPileUpData()
  local HomeController = require("UIHome/UIHomeController")
  HomeController.InitAllFurnitureExtraData()
  DataModel.InitMonster(roomIdList)
  HomeManager:OpenHome(0)
  local playgroundCA = PlayerData:GetFactoryData(DataModel.playgroundId, "PlaygroundFactory")
  HomeManager:SetPlaygroundScenePosX(HomeManager:GetTotalRoomSize() - HomeManager:GetRoomSize(0) + playgroundCA.sceneDefaultOffsetX)
end

local HideSpriteFurIdList = {
  ["81300441"] = 1,
  ["81300437"] = 1,
  ["81300454"] = 1
}
local HideSpriteFurFunTypeList = {
  ["12600474"] = 1
}

function DataModel.GetFurStatusIcon(id)
  return nil
end

function DataModel.GetCleanRate()
  local configCA = PlayerData:GetFactoryData(99900192, "ConfigFactory")
  local playgroundCA = PlayerData:GetFactoryData(DataModel.playgroundId, "PlaygroundFactory")
  local rate = playgroundCA.stealRate * (1 - configCA.doReduceRate * DataModel.ownOtherInfo.record_today.steal_success_cnt)
  return rate < 0 and 0 or rate
end

function DataModel.GetCleanSuccessRate()
  local rate = DataModel.GetCleanRate() * DataModel.petReduceRate
  return rate < 0 and 0 or rate
end

function DataModel.InitMonster(roomIdList)
  DataModel.ClearCacheBattleCharacter()
  DataModel.cacheBattleChaInfo = {}
  local playgroundData = DataModel.friendServerData.playground[tostring(DataModel.playgroundId)]
  if not playgroundData.levels then
    return
  end
  local curTime = TimeUtil:GetServerTimeStamp()
  for i, v in ipairs(playgroundData.levels) do
    local levelId = v.id
    local createTime = v.created_ts or 0
    local time = curTime - createTime
    if not (time < 0) then
      local levelCA = PlayerData:GetFactoryData(levelId)
      if levelCA.homeChrId and 0 < levelCA.homeChrId then
        local roomIdx = math.random(0, #roomIdList - 1)
        local homeCharacter = HomeCharacterManager:CreateCharacter(levelCA.homeChrId, roomIdx, -1)
        local characterCA = PlayerData:GetFactoryData(levelCA.homeChrId)
        local status = {
          Current = "Chapter",
          squadIndex = PlayerData.BattleInfo.squadIndex,
          hasOpenThreeView = false,
          pgUniqueId = v.unique_id,
          pgUid = DataModel.friendServerData.uid
        }
        status.extraUIParamData = {
          reload = true,
          friendServerData = DataModel.friendServerData,
          otherInfo = DataModel.otherInfo,
          petReduceRate = DataModel.petReduceRate,
          scene = MainManager.bgSceneName
        }
        local sParams
        local remainHelpNum = DataModel.GetHelpNumInfo()
        if remainHelpNum == 0 then
          sParams = "tips#80610311"
        else
          sParams = "levelId#" .. tostring(levelId) .. "#" .. View.self.url .. "#" .. Json.encode(status)
        end
        local playgroundCA = PlayerData:GetFactoryData(DataModel.playgroundId)
        local bubblePath = ""
        for i1 = #playgroundCA.bubbleList, 1, -1 do
          local v1 = playgroundCA.bubbleList[i1]
          if time >= v1.changeTime * 3600 then
            bubblePath = v1.bubblePath
            break
          end
        end
        if bubblePath ~= "" then
          local effectPart = homeCharacter.effectPart
          effectPart:SetTouchEventWithObj(bubblePath, sParams)
          effectPart:SetTouchEventPos(characterCA.bubbleX, characterCA.bubbleY, characterCA.bubbleZ)
        end
        local chrInfo = {}
        chrInfo.idx = homeCharacter.id
        chrInfo.chaCAId = levelCA.homeChrId
        chrInfo.time = time
        table.insert(DataModel.cacheBattleChaInfo, chrInfo)
      end
    end
  end
end

function DataModel.ClearCacheBattleCharacter()
  for i, chaInfo in ipairs(DataModel.cacheBattleChaInfo) do
    local character = HomeCharacterManager:GetHomeCharactersByIdx(chaInfo.idx)
    if character then
      HomeCharacterManager:RemoveCharacter(character)
    end
  end
  DataModel.cacheBattleChaInfo = {}
end

function DataModel.ClickMonster()
  local count = #DataModel.cacheBattleChaInfo
  if count == 0 then
    local ca = PlayerData:GetFactoryData(DataModel.playgroundId, "PlaygroundFactory")
    CommonTips.OpenTips(ca.noMONTips)
    return
  end
  if DataModel.battleFindIdx > #DataModel.cacheBattleChaInfo then
    DataModel.battleFindIdx = 1
  end
  if DataModel.battleFindIdx <= #DataModel.cacheBattleChaInfo then
    local chaInfo = DataModel.cacheBattleChaInfo[DataModel.battleFindIdx]
    local character = HomeCharacterManager:GetHomeCharactersByIdx(chaInfo.idx)
    if character ~= nil then
      local pos = character.view.transform.localPosition
      HomeManager:HomeCameraMoveXTween(pos, 0.5)
    end
  end
  DataModel.battleFindIdx = DataModel.battleFindIdx + 1
end

function DataModel.BattleBack()
  Net:SendProto("playground.fg_look", function(json)
    if json.other_playground then
      local playgroundData = DataModel.friendServerData.playground[tostring(DataModel.playgroundId)]
      local newPlayGroundData = json.other_playground[tostring(DataModel.playgroundId)]
      if newPlayGroundData then
        playgroundData.levels = newPlayGroundData.levels
        playgroundData.rubbish_area = newPlayGroundData.rubbish_area
      end
    end
    if json.other_info then
      DataModel.otherInfo = json.other_info
    end
    if json.own_other_info then
      DataModel.ownOtherInfo = json.own_other_info
    end
    if json.other_guarantee then
      DataModel.protectNum = json.other_guarantee
    end
    DataModel.reload = true
    UIManager:Open("UI/Playground/FriendIslandUpdate/FriendUI/FriendUI")
  end, DataModel.friendServerData.uid, DataModel.playgroundId)
end

return DataModel
