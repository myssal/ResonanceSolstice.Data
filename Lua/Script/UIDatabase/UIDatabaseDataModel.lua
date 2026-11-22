local View = require("UIDatabase/UIDatabaseView")
local DataModel = {}

local function setTabData(row)
  local ca = PlayerData:GetFactoryData(row.id)
  row.coverPage = ca.coverPage
  row.icon = ca.icon
  row.interfaceUrl = ca.interfaceUrl
end

function DataModel.initData()
  DataModel.database_list = {}
  DataModel:SetCaheRoleData()
  DataModel:SetCaheEnemiesData()
  local dataTab = {}
  dataTab = PlayerData:GetFactoryData(80300040).dataTab
  DataModel.databae_info_list = nil
  DataModel.unlockcnt = 0
  DataModel.allcnt = 0
  DataModel.unlock_list = {}
  for i, v in ipairs(PlayerData.gotWord) do
    DataModel.unlock_list[v] = 1
  end
  DataModel.select1_indx = nil
  DataModel.select2_indx = nil
  DataModel.select3_indx = nil
  DataModel.select_type = 0
  for i, v in ipairs(dataTab) do
    local row = v
    if v.id == 80300339 then
      local noteBookDataMode = require("UINotebook/UINotebookDataModel")
      local dataTab = PlayerData:GetFactoryData(v.id).dataTab
      row.allcnt, row.unlockcnt = noteBookDataMode.GetAllCountInfo(dataTab)
      row.new_cnt = noteBookDataMode.GetAllNewNum(dataTab)
    elseif v.id == 80301357 then
      row.new_cnt, row.unlockcnt = PlayerData:GetNewRoleNum()
      row.allcnt = table.count(PlayerData:GetFactoryData(80900001).unitList)
      if row.unlockcnt > row.allcnt then
        row.unlockcnt = row.allcnt
      end
    elseif v.id == 80301358 then
      row.new_cnt, row.unlockcnt = PlayerData:GetNewEnemiesNum()
      row.allcnt = table.count(PlayerData:GetFactoryData(80900005).unitList)
      if row.unlockcnt > row.allcnt then
        row.unlockcnt = row.allcnt
      end
    elseif v.id == 80302632 then
      row.new_cnt, row.unlockcnt = PlayerData:GetNewArmNum()
      row.allcnt = table.count(PlayerData:GetFactoryData(80900009).armamentList)
      if row.unlockcnt > row.allcnt then
        row.unlockcnt = row.allcnt
      end
    elseif v.id == 80302633 then
      row.new_cnt, row.unlockcnt = PlayerData:GetNewEquip()
      row.allcnt = table.count(PlayerData:GetFactoryData(80900010).equipmentList)
      if row.unlockcnt > row.allcnt then
        row.unlockcnt = row.allcnt
      end
    elseif v.id == 80301940 then
      row.allcnt = table.count(PlayerData:GetFactoryData(80900011).sourceList)
      row.new_cnt = 0
      row.unlockcnt = row.allcnt
      if row.unlockcnt > row.allcnt then
        row.unlockcnt = row.allcnt
      end
    else
      row.new_cnt = DataModel.GetNewCount(v.id)
      row.unlockcnt = DataModel.GetUnLockCount(v.id)
      row.allcnt = DataModel.GetCount(v.id)
    end
    setTabData(row)
    table.insert(DataModel.database_list, row)
  end
end

function DataModel.RefreshUI()
  View.ScrollGrid_Outside.grid.self:SetActive(true)
  View.ScrollGrid_Outside.grid.self:SetDataCount(table.count(DataModel.database_list))
  View.ScrollGrid_Outside.grid.self:RefreshAllElement()
end

function DataModel.GetDatabaseInfolist(select_type, data_type)
  DataModel.unlockcnt = 0
  DataModel.allcnt = 0
  DataModel.select1_indx = nil
  DataModel.select2_indx = nil
  DataModel.select3_indx = nil
  DataModel.select_type = select_type
  DataModel.data_type = data_type
  local cfg_id = DataModel.database_list[data_type].id
  DataModel.databae_info_list = PlayerData:GetFactoryData(cfg_id).dataTab
  local first_list = PlayerData:GetFactoryData(cfg_id).dataTab
  DataModel.databae_info_list = {}
  for i, v in ipairs(first_list) do
    v.expand = false
    local data_info = v
    DataModel.allcnt = DataModel.allcnt + DataModel.GetCount(v.id)
    local unLockCount = DataModel.GetUnLockCount(v.id)
    DataModel.unlockcnt = DataModel.unlockcnt + unLockCount
    if DataModel.select_type == 1 then
      if 0 < unLockCount then
        table.insert(DataModel.databae_info_list, data_info)
      end
    elseif DataModel.select_type == 0 then
      table.insert(DataModel.databae_info_list, data_info)
    end
  end
end

function DataModel.FormatNum(num)
  local num = math.floor(num * 10) / 10
  if num <= 0 then
    return 0
  else
    local t1, t2 = math.modf(num)
    if 0 < t2 then
      return num
    else
      return t1
    end
  end
end

function DataModel.GetRedPointState()
  for i, v in ipairs(DataModel.database_list) do
    if v.new_cnt and v.new_cnt > 0 then
      return true
    end
  end
  return false
end

function DataModel:SetCaheRoleData()
  if DataModel.CaheRoleData == nil then
    DataModel.CaheRoleData = {}
  end
  if table.count(DataModel.CaheRoleData) > 0 then
    return
  end
  for i, v in ipairs(PlayerData:GetFactoryData(80900001).unitList) do
    DataModel.CaheRoleData[tostring(v.id)] = true
  end
end

function DataModel:SetCaheEnemiesData()
  if DataModel.CaheEnemiesData == nil then
    DataModel.CaheEnemiesData = {}
  end
  if table.count(DataModel.CaheEnemiesData) > 0 then
    return
  end
  for i, v in ipairs(PlayerData:GetFactoryData(80900005).unitList) do
    DataModel.CaheEnemiesData[tostring(v.id)] = true
  end
end

function DataModel.AddExpandData(index)
  local data = DataModel.databae_info_list[index]
  if not data then
    return
  end
  local dataTab = PlayerData:GetFactoryData(data.id, "ListFactory").dataTab
  for i = 1, #dataTab do
    dataTab[i].expand = false
    dataTab[i].front = data.id
    index = index + 1
    table.insert(DataModel.databae_info_list, index, dataTab[i])
  end
  data.expand = true
end

function DataModel.RemoveExpandData(index)
  local data = DataModel.databae_info_list[index]
  if not data then
    return
  end
  local dataTab = PlayerData:GetFactoryData(data.id).dataTab
  for _, v in ipairs(dataTab) do
    local expand, menuIndex = DataModel.IsMenuExpand(v.id)
    if expand then
      DataModel.RemoveExpandData(menuIndex)
    end
  end
  for i = 1, #dataTab do
    table.remove(DataModel.databae_info_list, index + 1)
  end
  data.expand = false
end

function DataModel.IsMenuHasExpand(id)
  local factoryName = DataManager:GetFactoryNameById(id)
  return factoryName == "ListFactory"
end

function DataModel.IsMenuExpand(id)
  local menuIndex = DataModel.GetMenuIndex(id)
  local data = DataModel.databae_info_list[menuIndex]
  return data.expand, menuIndex
end

function DataModel.IsWordUnLock(id)
  local info = PlayerData:GetFactoryData(id, "DataFactory")
  if info.unlock and info.unlock > 0 then
    return PlayerData.plot_paragraph[tostring(info.unlock)]
  end
  return true
end

function DataModel.HideLeftInfo()
  View.Group_Inside.Group_Left:SetActive(false)
end

function DataModel.RefreshLeftInfo(index)
  local infoId
  local data = DataModel.databae_info_list[index]
  local hasExpand = DataModel.IsMenuHasExpand(data.id)
  if hasExpand then
    local info = PlayerData:GetFactoryData(data.id, "ListFactory")
    infoId = info.txt
  else
    infoId = data.id
  end
  local showInfo = 0 < infoId
  View.Group_Inside.Group_Left:SetActive(showInfo)
  if showInfo then
    local unLock = DataModel.IsWordUnLock(infoId)
    View.Group_Inside.Group_Left.Group_Owned:SetActive(unLock)
    View.Group_Inside.Group_Left.Group_UnOwned:SetActive(not unLock)
    if unLock then
      local info = PlayerData:GetFactoryData(infoId, "DataFactory")
      View.Group_Inside.Group_Left.Group_Owned.Txt_Title:SetText(info.name)
      View.Group_Inside.Group_Left.Group_Owned.ScrollView_Content.Viewport.Content.Txt_Data:SetText(info.desc)
      View.Group_Inside.Group_Left.Group_Owned.ScrollView_Content:SetVerticalNormalizedPosition(1)
    end
  end
end

function DataModel.GetNewCount(id)
  local count = 0
  local listCA = PlayerData:GetFactoryData(id, "ListFactory")
  if listCA then
    for i, v in ipairs(listCA.dataTab) do
      local hasExpand = DataModel.IsMenuHasExpand(v.id)
      if hasExpand then
        count = count + DataModel.GetNewCount(v.id)
      elseif DataModel.IsWordUnLock(v.id) and PlayerData:GetPlayerPrefs("int", v.id) == 0 then
        count = count + 1
      end
    end
  end
  return count
end

function DataModel.GetCount(id)
  local count = 0
  local listCA = PlayerData:GetFactoryData(id, "ListFactory")
  if listCA then
    for i, v in ipairs(listCA.dataTab) do
      local hasExpand = DataModel.IsMenuHasExpand(v.id)
      if hasExpand then
        count = count + DataModel.GetCount(v.id)
      else
        count = count + 1
      end
    end
  end
  return count
end

function DataModel.GetUnLockCount(id)
  local count = 0
  local listCA = PlayerData:GetFactoryData(id, "ListFactory")
  if listCA then
    for i, v in ipairs(listCA.dataTab) do
      local hasExpand = DataModel.IsMenuHasExpand(v.id)
      if hasExpand then
        count = count + DataModel.GetUnLockCount(v.id)
      elseif DataModel.IsWordUnLock(v.id) then
        count = count + 1
      end
    end
  end
  return count
end

function DataModel.GetMenuIndex(id)
  for i, v in ipairs(DataModel.databae_info_list) do
    if v.id == tonumber(id) then
      return i
    end
  end
end

return DataModel
