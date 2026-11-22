local View = require("UIConstructStage/UIConstructStageView")
local CommonItem = require("Common/BtnItem")
local DataModel = {
  StationId = 0,
  StationCA = 0,
  ConstructNowCA = {},
  posXMin = -809,
  posXMax = 812,
  pbLength = 1620
}

local function SetGroupItem(view, data, num, index)
  view.Group_Not:SetActive(false)
  view.Group_Able:SetActive(false)
  view.Group_Already:SetActive(false)
  if num >= data.construct then
    if DataModel.rec_index_list[index - 1] then
      view.Group_Already.Txt_Schedule:SetText(data.construct)
      view.Group_Already:SetActive(true)
    else
      view.Group_Able.Txt_Schedule:SetText(data.construct)
      view.Group_Able:SetActive(true)
    end
  else
    view.Group_Not.Txt_Schedule:SetText(data.construct)
    view.Group_Not:SetActive(true)
  end
  local ca = PlayerData:GetFactoryData(data.id)
  view.Txt_Name:SetText(ca.name)
  view.Group_Item.Btn_Item:SetClickParam(data.id)
  CommonItem:SetItem(view.Group_Item, {
    id = data.id,
    num = data.num
  })
end

function DataModel:ChooseBottomTab(index)
  if index and DataModel.Tab_index and index == DataModel.Tab_index then
    return
  end
  local now_row = DataModel.ConstructStageList[index]
  local now_element = now_row.element
  now_element.Group_On:SetActive(true)
  if DataModel.Tab_index and DataModel.ConstructStageList[DataModel.Tab_index] then
    local old_element = DataModel.ConstructStageList[DataModel.Tab_index].element
    old_element.Group_On:SetActive(false)
  end
  local Group_Top = View.Group_Top
  Group_Top.Img_BG:SetSprite(now_row.png)
  Group_Top.Txt_Dec:SetText(now_row.desc)
  Group_Top.Txt_Title:SetText(now_row.name)
  Group_Top.Img_Icon:SetSprite(now_row.stagePng)
  Group_Top.Txt_EnglishTitle:SetText(now_row.nameEN)
  DataModel.TopTipsList = PlayerData:GetFactoryData(now_row.id).textTipsList
  Group_Top.ScrollGrid_List.grid.self:SetDataCount(#DataModel.TopTipsList)
  Group_Top.ScrollGrid_List.grid.self:RefreshAllElement()
  local CA = DataModel.ConstructNowCA
  local Group_Schedule = View.Group_Schedule
  local now_num = math.min(DataModel.ConstructNowNum, now_row.server.proportion)
  local max_num = now_row.constructNum
  local diff = now_num / max_num
  Group_Schedule.Txt_Num:SetText(now_num .. "/" .. max_num)
  Group_Schedule.Img_PB:SetFilledImgAmount(diff)
  Group_Schedule.Img_PB.Img_.transform.localPosition = Vector3(DataModel.pbLength * diff + DataModel.posXMin, 0, 0)
  DataModel.Tab_index = index
  local reward_count = table.count(now_row.ca.stageRewardList)
  DataModel.rec_index_list = {}
  local rec_index = DataModel.StationList.construction[DataModel.Tab_index].rec_index
  if rec_index then
    for k, v in pairs(rec_index) do
      DataModel.rec_index_list[v] = 1
    end
  end
  local count = 0
  for i = 1, 7 do
    local group = "Group_Item" .. i
    local obj = View.Group_Schedule.Group_Reward[group]
    obj:SetActive(false)
    if i <= reward_count then
      obj:SetActive(true)
      SetGroupItem(obj, now_row.ca.stageRewardList[i], now_num, i)
      obj.transform.localPosition = Vector3(DataModel.pbLength * (now_row.ca.stageRewardList[i].construct / max_num) + DataModel.posXMin, 0, 0)
    end
  end
  if count ~= 0 then
    now_element.Img_RedPoint:SetActive(true)
  end
end

function DataModel:Init(index)
  View.Group_Tips.self:SetActive(false)
  local Group_Tab = View.Group_Tab
  DataModel.ConstructStageList = {}
  for k, v in pairs(DataModel.StationCA.constructStageList) do
    local row = {}
    for c, d in pairs(v) do
      row[c] = d
    end
    row.isLock = false
    row.server = DataModel.StationList.construction[k]
    if row.server == nil then
      row.server = {}
      row.server.proportion = 0
    end
    if row.server.proportion == 0 and DataModel.StationCA.constructStageList[k - 1] and DataModel.StationList.construction[k - 1] and DataModel.StationCA.constructStageList[k - 1].constructNum > DataModel.StationList.construction[k - 1].proportion then
      row.isLock = true
    end
    row.ca = PlayerData:GetFactoryData(row.id)
    row.isRecive = false
    local stageRewardList = row.ca.stageRewardList
    local count = 0
    for k, v in pairs(stageRewardList) do
      if row.server and v.construct <= row.server.proportion and row.server.rec_index[k] == nil then
        count = count + 1
      end
    end
    if count ~= 0 then
      row.isRecive = true
    end
    table.insert(DataModel.ConstructStageList, row)
  end
  Group_Tab.StaticGrid_List.grid.self:SetDataCount(table.count(DataModel.ConstructStageList))
  Group_Tab.StaticGrid_List.grid.self:RefreshAllElement()
  DataModel.Tab_index = nil
  DataModel:ChooseBottomTab(index or tonumber(DataModel.Index_Construct))
end

local function GetStageRedState()
  local now_row = DataModel.ConstructStageList[DataModel.Tab_index]
  local stageRewardList = now_row.ca.stageRewardList
  local count = 0
  for k, v in pairs(stageRewardList) do
    if now_row.server and v.construct <= now_row.server.proportion and now_row.server.rec_index[k] == nil then
      count = count + 1
    end
  end
  if count ~= 0 then
    return true
  end
  return false
end

function DataModel:ClickConstructStageReward(index)
  Net:SendProto("station.get_stage_reward", function(json)
    CommonTips.OpenShowItem(json.reward)
    PlayerData:SetConstructStageRecIndex(DataModel.StationId, DataModel.Tab_index, index - 1)
    DataModel.StationList = PlayerData:GetHomeInfo().stations[tostring(DataModel.StationId)]
    DataModel:Init(DataModel.Tab_index)
    local now_row = DataModel.ConstructStageList[DataModel.Tab_index]
    local now_element = now_row.element
    local state = GetStageRedState()
    now_row.isRecive = state
    now_element.Img_RedPoint:SetActive(state)
    local group = "Group_Item" .. index
    local obj = View.Group_Schedule.Group_Reward[group]
    obj.Group_Not:SetActive(false)
    obj.Group_Able:SetActive(false)
    obj.Group_Already:SetActive(true)
    obj.Group_Already.Txt_Schedule:SetText(DataModel.ConstructStageList[DataModel.Tab_index].ca.stageRewardList[index].construct)
  end, DataModel.Tab_index - 1, index - 1, 0)
end

function DataModel:OpenReward(id)
  if id == nil then
    return
  end
  CommonTips.OpenPreRewardDetailTips(tonumber(id))
end

function DataModel:GetStationStageData(stationId)
  DataModel.StationId = stationId
  DataModel.StationCA = PlayerData:GetFactoryData(stationId)
  DataModel.StationList = PlayerData:GetHomeInfo().stations[tostring(stationId)]
  DataModel.StationState = PlayerData:GetHomeInfo().stations[tostring(stationId)].state
  DataModel.ConstructMaxNum = 0
  DataModel.ConstructNowNum = 0
  DataModel.ConstructNowCA = {}
  for k, v in pairs(DataModel.StationList.construction) do
    DataModel.ConstructNowNum = DataModel.ConstructNowNum + v.proportion
  end
  local count = 0
  for i = 1, #DataModel.StationCA.constructStageList do
    local row = DataModel.StationCA.constructStageList[i]
    DataModel.ConstructMaxNum = DataModel.ConstructMaxNum + row.constructNum
    DataModel.ConstructNowCA = row
    count = i
    if row.state and row.state ~= -1 and DataModel.ConstructNowNum >= DataModel.ConstructMaxNum and DataModel.StationState < row.state then
      DataModel.StationState = row.state
      PlayerData:GetHomeInfo().stations[tostring(DataModel.StationId)].state = row.state
    end
    if DataModel.ConstructNowNum < DataModel.ConstructMaxNum then
      break
    end
  end
  DataModel.Index_Construct = count
end

return DataModel
