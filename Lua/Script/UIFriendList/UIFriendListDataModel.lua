local View = require("UIFriendList/UIFriendListView")
local DataModel = {}
DataModel.playgroundId = 87300002
DataModel.friends = {}
DataModel.sortType = nil
DataModel.curVisitFriendUid = nil
DataModel.EnumSort = {
  Level = 1,
  Clean = 2,
  Safe = 3
}
DataModel.SortTabList = {}

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  local friends = {}
  if data.friends then
    for uid, v in pairs(data.friends) do
      local t = Clone(v)
      t.uid = uid
      local playgroundData = t.playground[tostring(DataModel.playgroundId)]
      t.canClean = DataModel.IsFriendCanClean(playgroundData, uid, t.guarantee)
      t.canHelp = playgroundData.levels and table.count(playgroundData.levels) > 0
      table.insert(friends, t)
    end
  end
  DataModel.friends = friends
end

function DataModel.InitData()
  DataModel.SortTabList = {
    [DataModel.EnumSort.Level] = View.Group_FriendList.Img_Tab.Btn_Level,
    [DataModel.EnumSort.Clean] = View.Group_FriendList.Img_Tab.Btn_Clean,
    [DataModel.EnumSort.Safe] = View.Group_FriendList.Img_Tab.Btn_Fight
  }
  local sortType = PlayerData:GetPlayerPrefs("int", "playgroundFriendListSort")
  if sortType == 0 then
    sortType = DataModel.EnumSort.Level
  end
  DataModel.sortType = sortType
end

function DataModel.RefreshOnShow()
  local dayVisitNum = PlayerData:GetUserInfo().fg_being_look_count_ct or 0
  View.Group_FriendList.Group_RightTop.Txt_Today:SetText(dayVisitNum)
  local totalLikeNum = PlayerData:GetUserInfo().fg_being_like_count or 0
  View.Group_FriendList.Group_RightTop.Txt_Goods:SetText(totalLikeNum)
  DataModel.RefreshFriends(DataModel.sortType)
end

function DataModel.SortFriend(enumSort)
  if enumSort == DataModel.EnumSort.Level then
    table.sort(DataModel.friends, function(a, b)
      if a.lv == b.lv then
        return a.add_ts < b.add_ts
      else
        return a.lv <= b.lv
      end
    end)
  elseif enumSort == DataModel.EnumSort.Clean then
    local function GetSortIndex(data)
      if data.canClean then
        return 0
      end
      return 1
    end
    
    table.sort(DataModel.friends, function(a, b)
      local index1 = GetSortIndex(a)
      local index2 = GetSortIndex(b)
      if index1 == index2 then
        return a.add_ts < b.add_ts
      else
        return index1 < index2
      end
    end)
  elseif enumSort == DataModel.EnumSort.Safe then
    local function GetSortIndex(data)
      local playgroundData = data.playground[tostring(DataModel.playgroundId)]
      
      return playgroundData.levels and table.count(playgroundData.levels) or 0
    end
    
    table.sort(DataModel.friends, function(a, b)
      local index1 = GetSortIndex(a)
      local index2 = GetSortIndex(b)
      if index1 == index2 then
        return a.add_ts < b.add_ts
      else
        return index1 > index2
      end
    end)
  end
  if enumSort ~= DataModel.sortType and DataModel.curVisitFriendUid then
    local curFriendData
    if DataModel.curVisitFriendUid then
      for i, v in ipairs(DataModel.friends) do
        if v.uid == DataModel.curVisitFriendUid then
          curFriendData = v
          table.remove(DataModel.friends, i)
          break
        end
      end
    end
    table.insert(DataModel.friends, 1, curFriendData)
    if UIManager:IsPanelOpened("UI/Playground/FriendIslandUpdate/FriendUI/FriendUI") then
      local FriendUIView = require("UIFriendUI/UIFriendUIView")
      FriendUIView.Img_CantNext:SetActive(false)
      FriendUIView.Btn_Next:SetActive(true)
      FriendUIView.Img_CantLast:SetActive(true)
      FriendUIView.Btn_Last:SetActive(false)
    end
  end
end

function DataModel.RefreshFriends(enumSort)
  DataModel.SortFriend(enumSort)
  View.Group_FriendList.ScrollGrid_List.grid.self:SetDataCount(#DataModel.friends)
  View.Group_FriendList.ScrollGrid_List.grid.self:RefreshAllElement()
  for sort, element in pairs(DataModel.SortTabList) do
    element.Group_Pick:SetActive(sort == enumSort)
    element.Group_Unpick:SetActive(sort ~= enumSort)
  end
  DataModel.sortType = enumSort
  PlayerData:SetPlayerPrefs("int", "playgroundFriendListSort", enumSort)
end

function DataModel.SortFriendClick(enumSort)
  if enumSort == DataModel.sortType then
    return
  end
  DataModel.RefreshFriends(enumSort)
end

function DataModel.VisitFriendClick(friendIndex)
  friendIndex = tonumber(friendIndex)
  local data = DataModel.friends[friendIndex]
  if data.uid == DataModel.curVisitFriendUid then
    View.self:CloseUI()
    return
  end
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
    DataModel.curVisitFriendUid = data.uid
    if UIManager:IsPanelOpened("UI/Playground/Playground") then
      local playgroundView = require("UIPlayground/UIPlaygroundView")
      playgroundView.self:CloseUI()
    end
    View.self:CloseUI()
    HomeCharacterManager:RecycleAll()
    CommonTips.OpenLoadingCB(function()
      UIManager:Pause(false)
      View.self:StartC(LuaUtil.cs_generator(function()
        LoadingManager:SetLoadingPercent(0.3)
        coroutine.yield(CS.UnityEngine.WaitForSeconds(0.5))
        local params = {
          reload = true,
          friendServerData = DataModel.friends[friendIndex],
          ownOtherInfo = json.own_other_info,
          otherInfo = json.other_info,
          petReduceRate = json.pet_reduce_rate or 0
        }
        UIManager:Open("UI/Playground/FriendIslandUpdate/FriendUI/FriendUI", Json.encode(params))
        LoadingManager:SetLoadingPercent(0.8)
        coroutine.yield(CS.UnityEngine.WaitForSeconds(0.1))
        LoadingManager:SetLoadingPercent(1)
      end))
    end)
  end, data.uid, DataModel.playgroundId)
end

function DataModel.GetFriendIndex(uid)
  for i, v in ipairs(DataModel.friends) do
    if v.uid == uid then
      return i
    end
  end
end

function DataModel.IsFriendCanClean(playgroundData, uid, protectNum)
  local FriendUIDataModel = require("UIFriendUI/UIFriendUIDataModel")
  local remainNum = FriendUIDataModel.GetCleanNumInfo()
  if remainNum == 0 then
    return false
  end
  local cd = FriendUIDataModel.GetCleanCD(uid)
  if 0 < cd then
    return false
  end
  local rubbishInfo = playgroundData.rubbish_area
  local rubbishNum = rubbishInfo and rubbishInfo.waste_block or 0
  if protectNum >= rubbishNum then
    return false
  end
  return true
end

return DataModel
