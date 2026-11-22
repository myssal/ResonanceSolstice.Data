local View = require("UIHistoryList/UIHistoryListView")
local DataModel = {}
DataModel.ERecordType = {ToDay = "today", Total = "total"}
DataModel.todayRecord = {}
DataModel.totalRecord = {}
DataModel.recordType = DataModel.ERecordType.Total

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  local todayRecord = {}
  if data.todayRecord then
    for i, v in pairs(data.todayRecord) do
      local t = Clone(v)
      t.uid = i
      table.insert(todayRecord, t)
    end
  end
  table.sort(todayRecord, function(a, b)
    return a.look_ts > b.look_ts
  end)
  DataModel.todayRecord = todayRecord
  local totalRecord = {}
  if data.totalRecord then
    for i, v in pairs(data.totalRecord) do
      local t = Clone(v)
      t.uid = i
      table.insert(totalRecord, t)
    end
  end
  table.sort(totalRecord, function(a, b)
    return a.look_ts > b.look_ts
  end)
  DataModel.totalRecord = totalRecord
  DataModel.recordType = data.recordType or DataModel.ERecordType.Total
end

function DataModel.InitData()
end

function DataModel.RefreshOnShow()
  View.Group_Top.Group_1.Txt_Today:SetText(#DataModel.todayRecord)
  View.Group_Top.Group_2.Txt_Good:SetText(PlayerData:GetUserInfo().fg_being_like_count or 0)
  View.Group_Top.Group_3.Txt_Total:SetText(#DataModel.totalRecord)
  DataModel.RefreshHistoryList(DataModel.recordType)
end

function DataModel.RefreshHistoryList(recordType)
  View.Group_FriendList:SetActive(recordType == DataModel.ERecordType.Total)
  View.Group_DetailList:SetActive(recordType == DataModel.ERecordType.ToDay)
  if recordType == DataModel.ERecordType.Total then
    View.Group_FriendList.ScrollGrid_.grid.self:SetDataCount(#DataModel.totalRecord)
    View.Group_FriendList.ScrollGrid_.grid.self:RefreshAllElement()
  elseif recordType == DataModel.ERecordType.ToDay then
    View.Group_DetailList.ScrollGrid_.grid.self:SetDataCount(#DataModel.todayRecord)
    View.Group_DetailList.ScrollGrid_.grid.self:RefreshAllElement()
  end
  View.Group_Btn.Img_Select1:SetActive(recordType == DataModel.ERecordType.Total)
  View.Group_Btn.Img_Select2:SetActive(recordType == DataModel.ERecordType.ToDay)
end

function DataModel.SelectRecordClick(recordType)
  if DataModel.recordType == recordType then
    return
  end
  DataModel.recordType = recordType
  DataModel.RefreshHistoryList(recordType)
end

function DataModel.GetFriendBaseData(uid)
  local FriendListDataModel = require("UIFriendList/UIFriendListDataModel")
  for i, v in ipairs(FriendListDataModel.friends) do
    if v.uid == uid then
      return v
    end
  end
end

return DataModel
