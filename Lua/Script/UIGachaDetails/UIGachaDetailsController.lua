local View = require("UIGachaDetails/UIGachaDetailsView")
local DataModel = require("UIGachaDetails/UIGachaDetailsDataModel")
local Controller = {}

function Controller:Init()
  DataModel.extractCA = PlayerData:GetFactoryData(DataModel.param.id)
  DataModel.ServerGacheConfig = PlayerData:GetFactoryData(99900053)
  local tagCA = PlayerData:GetFactoryData(DataModel.extractCA.protectTag)
  DataModel.maxPageNum = 100000
  DataModel.gachaRecordTable = {}
  DataModel.RecordProbability = {}
  View.Txt_UID:SetText(string.format(GetText(80600575), PlayerData:GetUserInfo().uid))
  View.Group_Record.Img_Tips.Txt_Tips:SetText(tagCA.recordTips)
  View.Group_Three.self:SetActive(DataModel.ServerGacheConfig.gacheUI)
  View.Group_Two.self:SetActive(not DataModel.ServerGacheConfig.gacheUI)
  Controller:Select(DataModel.SelectType.ViewDetail, true)
end

function Controller:Select(type, force)
  if not force and type == DataModel.curSelect then
    return
  end
  DataModel.curSelect = type
  local isViewDetail = type == DataModel.SelectType.ViewDetail
  local isGachaRecord = type == DataModel.SelectType.GachaRecord
  local isGachaProbability = type == DataModel.SelectType.GachaProbability
  local currentView
  if DataModel.ServerGacheConfig.gacheUI then
    currentView = View.Group_Three
  else
    currentView = View.Group_Two
  end
  View.ScrollView_Details:SetActive(isViewDetail)
  currentView.Btn_Details.Img_On:SetActive(isViewDetail)
  currentView.Btn_Record.Img_On:SetActive(isGachaRecord)
  if currentView.Btn_Probability then
    currentView.Btn_Probability.Img_On:SetActive(isGachaProbability)
  end
  View.Group_Record:SetActive(isGachaRecord)
  View.Group_Probability:SetActive(isGachaProbability)
  if type == DataModel.SelectType.ViewDetail then
    Controller:ShowViewDetail()
  elseif type == DataModel.SelectType.GachaRecord then
    Controller:ShowGachaRecord(1, true)
  elseif type == DataModel.SelectType.GachaProbability then
    Controller:ShowGachaRecordProbability()
  end
end

function Controller:ShowViewDetail()
  local extract = DataModel.extractCA.details
  View.ScrollView_Details.Viewport.Txt_Details:SetText(extract)
  View.ScrollView_Details:SetVerticalNormalizedPosition(1)
end

function Controller:ShowGachaRecord(page, force)
  if not force and page == DataModel.curSelectPage then
    return
  end
  if page < 1 or page > DataModel.maxPageNum then
    return
  end
  local count = #DataModel.gachaRecordTable
  local isNull = count == 0
  local isRequest = count <= DataModel.defaultClientPageNum * (page - 1)
  View.Group_Record.Group_Null:SetActive(isNull)
  View.Group_Record.Group_Data:SetActive(not isNull)
  if isRequest then
    Net:SendProto("recruit.records", function(json)
      if json.record_cnt then
        DataModel.maxPageNum = math.ceil(json.record_cnt / DataModel.defaultClientPageNum)
      end
      if json.card_records and #json.card_records > 0 then
        DataModel.curSelectPage = page
        for k, v in ipairs(json.card_records) do
          table.insert(DataModel.gachaRecordTable, v)
        end
        count = #DataModel.gachaRecordTable
        isNull = count == 0
        View.Group_Record.Group_Null:SetActive(isNull)
        View.Group_Record.Group_Data:SetActive(not isNull)
        View.Group_Record.Group_Data.StaticGrid_List.grid.self:RefreshAllElement()
      else
        DataModel.maxPageNum = page - 1
      end
      View.Group_Record.Group_Data.Txt_Page:SetText(page .. "/" .. DataModel.maxPageNum)
    end, DataModel.extractCA.protectTag, DataModel.defaultToServerPageNum, math.floor(count / DataModel.defaultToServerPageNum) + 1)
  else
    DataModel.curSelectPage = page
    if not isNull then
      View.Group_Record.Group_Data.StaticGrid_List.grid.self:RefreshAllElement()
      View.Group_Record.Group_Data.Txt_Page:SetText(page .. "/" .. DataModel.maxPageNum)
    end
  end
end

function Controller:ShowRecordElement(element, elementIndex)
  local curIdx = (DataModel.curSelectPage - 1) * DataModel.defaultClientPageNum + elementIndex
  local info = DataModel.gachaRecordTable[curIdx]
  local isShow = info ~= nil
  element:SetActive(isShow)
  if isShow then
    local unitCA = PlayerData:GetFactoryData(info.role_id)
    local color = "#FFFFFF"
    if unitCA.qualityInt >= 4 then
      color = "#FFE266"
    elseif unitCA.qualityInt >= 3 then
      color = "#E4B7FF"
    end
    element.Txt_Character:SetText(unitCA.name)
    element.Txt_Character:SetColor(color)
    local name
    if info.card_id and info.card_id ~= "" then
      local ca = PlayerData:GetFactoryData(info.card_id)
      name = ca.name
    else
      name = GetText(80605604)
    end
    element.Txt_TagName:SetText(name)
    element.Txt_Time:SetText(os.date("%Y-%m-%d %H:%M:%S", info.obtain_time))
  end
end

function Controller:ShowGachaRecordProbability()
  local count = #DataModel.extractCA.newNormalList
  if count == 0 then
    View.Group_Probability.self:SetActive(false)
    return
  end
  local list = {}
  local maxWeight_1 = 0
  local maxWight_2_list = {}
  if #DataModel.RecordProbability == 0 then
    for k, v in pairs(DataModel.extractCA.newNormalList) do
      local weight_1 = v.weight
      local weight_1_Var = v.weightVAR
      local index = k
      maxWeight_1 = maxWeight_1 + v.weight
      local rewardList = PlayerData:GetFactoryData(v.id).rewardList
      maxWight_2_list[index] = {}
      maxWight_2_list[index].maxNum = 0
      for c, d in pairs(rewardList) do
        local row = {}
        if list[d.id] == nil then
          row.weight_2 = d.weight
          row.weight_1 = weight_1
          if DataModel.ServerGacheConfig.gacheUIChange and 0 < DataModel.GetProtectInfoNum() + 1 - DataModel.extractCA.protectCount then
            row.weight_1 = weight_1 + (DataModel.GetProtectInfoNum() + 1 - DataModel.extractCA.protectCount) * weight_1_Var
          end
          row.index = index
          row.id = d.id
          maxWight_2_list[index].maxNum = maxWight_2_list[index].maxNum + d.weight
          list[d.id] = row
        end
      end
    end
    for k, v in pairs(list) do
      local maxWeight_2 = maxWight_2_list[v.index].maxNum
      local probability_1 = v.weight_1 / maxWeight_1
      local probability_2 = v.weight_2 / maxWeight_2
      local roleCA = PlayerData:GetFactoryData(v.id)
      v.name = roleCA.name
      v.qualityInt = roleCA.qualityInt
      v.probability = PlayerData:GetPreciseDecimalFloor(probability_1 * probability_2 * 100, 3)
      table.insert(DataModel.RecordProbability, v)
    end
    table.sort(DataModel.RecordProbability, function(a, b)
      if a.index == b.index then
        return a.probability > b.probability
      end
      return a.index > b.index
    end)
    View.Group_Probability.ScrollGrid_detail.grid.self:SetDataCount(#DataModel.RecordProbability)
    View.Group_Probability.ScrollGrid_detail.grid.self:RefreshAllElement()
  end
  View.Group_Probability.ScrollGrid_detail.grid.self:MoveToTop()
end

function Controller:ShowGachaRecordProbabilityElement(element, elementIndex)
  local row = DataModel.RecordProbability[tonumber(elementIndex)]
  element.Txt_Name:SetText(row.name)
  element.Txt_Probability:SetText(row.probability .. "%")
  element.Group_Pic.Img_Quality:SetSprite(UIConfig.RoleQuality[row.qualityInt])
  element.Group_Pic.Img_Quality:SetNativeSize()
end

return Controller
