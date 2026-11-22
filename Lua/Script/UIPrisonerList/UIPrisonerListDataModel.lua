local View = require("UIPrisonerList/UIPrisonerListView")
local TradeDataModel = require("UIHome/UIHomeTradeDataModel")
local DataModel = {}

function DataModel:Init()
  self.personalityIndex = 0
  self.specialityIndex = 0
  self.rarityIndex = 0
  local configCA = PlayerData:GetFactoryData(99900017)
  self.personalityEnum = configCA.prisonPersonalityNameList
  self.specialityEnum = configCA.prisonSpecialityList
  self.rarityEnum = configCA.enemyStrengthEnumList
  for i = 1, #self.personalityEnum do
    local personalityCA = PlayerData:GetFactoryData(self.personalityEnum[i].id)
    if i < 10 then
      View.Group_Chapter.Group_Career["Btn_C0" .. i].Txt_:SetText(personalityCA.prisonerPersonalityName)
    else
      View.Group_Chapter.Group_Career["Btn_C" .. i].Txt_:SetText(personalityCA.prisonerPersonalityName)
    end
  end
  for i = 1, #self.specialityEnum do
    local specialityCA = PlayerData:GetFactoryData(self.specialityEnum[i].id)
    View.Group_Chapter.Group_Group["Btn_G0" .. i].Txt_:SetText(specialityCA.prisonerSpeciality)
  end
  for i = 1, #self.rarityEnum do
    local rarityCA = PlayerData:GetFactoryData(self.rarityEnum[i].id)
    View.Group_Chapter.Group_Rarity["Btn_R0" .. i].Txt_:SetText(rarityCA.enemyTypeName)
  end
  self:InitSortType()
  if self.PageMode == "Coach" then
    self.checkInPrisonerList = {}
    self:InitCoach()
  elseif self.PageMode == "Prison" then
    self:RefreshPrison()
  end
end

function DataModel:InitSortType()
  DataModel.curSortType = nil
  DataModel.sortReverseMap = {
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false
  }
  self:RefreshAllSortBtn()
end

function DataModel:OpenPrisonerCheckIn()
  self.checkInPrisonerList = {}
  self.isInPrison = false
  self:InitSortType()
  self:InitCoach()
end

function DataModel:RefreshPrison()
  View.Group_TopRightPrison.self:SetActive(true)
  View.ScrollGrid_Prison.self:SetActive(true)
  View.Group_Bottom.Group_Prison.self:SetActive(true)
  View.Group_TopRightCoach.self:SetActive(false)
  View.ScrollGrid_Coach.self:SetActive(false)
  View.Group_Bottom.Group_CoachList.self:SetActive(false)
  View.Txt_Title:SetText(GetText(80607973))
  local backpackCount = table.count(PlayerData.ServerData.user_prison_info.carrying_backpack)
  local prisonerCount = table.count(PlayerData.ServerData.user_prison_info.prison_backpack)
  View.Group_Bottom.Group_Prison.Btn_PrisonerEnter.Img_RedPoint:SetActive(0 < backpackCount and prisonerCount < 168)
  self.isInPrison = true
  self:InitPrisonPrisonerList()
end

function DataModel:InitPrisonPrisonerList()
  self.prisonPrisonerList = {}
  for k, v in pairs(PlayerData.ServerData.user_prison_info.prison_backpack) do
    if self:CheckPrisoner(v) then
      self.prisonPrisonerList[#self.prisonPrisonerList + 1] = {
        uid = k,
        prisoner_id = v.prisoner_id,
        place_id = v.place_id,
        status = v.status,
        energy = v.energy,
        days = v.days,
        personality_id = v.personality_id,
        speciality_id = v.speciality_id,
        clint_num = v.clint_num,
        healthy = v.healthy,
        imprisonment_ts = v.imprisonment_ts
      }
    end
  end
  self:SortPrisonPrisonerList()
end

function DataModel:SetSortType(bType)
  if DataModel.curSortType ~= bType then
    DataModel.curSortType = bType
  else
    if DataModel.sortReverseMap[bType] then
      DataModel.curSortType = nil
    end
    DataModel.sortReverseMap[bType] = not DataModel.sortReverseMap[bType]
  end
  self:RefreshAllSortBtn()
  if self.PageMode == "Prison" and self.isInPrison then
    self:SortPrisonPrisonerList()
  else
    self:SortCoachPrisonerList()
  end
end

function DataModel:RefreshAllSortBtn()
  self:RefreshBtnBySortType(View.Group_TopRightPrison.Btn_Level, 1)
  self:RefreshBtnBySortType(View.Group_TopRightPrison.Btn_Rarity, 2)
  self:RefreshBtnBySortType(View.Group_TopRightPrison.Btn_Time, 3)
  self:RefreshBtnBySortType(View.Group_TopRightCoach.Btn_Rarity, 4)
  self:RefreshBtnBySortType(View.Group_TopRightCoach.Btn_Time, 2)
end

function DataModel:RefreshBtnBySortType(btn, btnType)
  local curType = DataModel.curSortType
  btn.Img_DeP.self:SetActive(curType == btnType and not DataModel.sortReverseMap[btnType])
  btn.Img_DeN.self:SetActive(curType ~= btnType and not DataModel.sortReverseMap[btnType])
  btn.Img_AP.self:SetActive(curType == btnType and DataModel.sortReverseMap[btnType])
  btn.Img_AN.self:SetActive(curType ~= btnType and DataModel.sortReverseMap[btnType])
end

function DataModel.Compare(e1, e2)
  local curType = DataModel.curSortType
  if curType == 1 then
    if DataModel.sortReverseMap[curType] then
      return DataModel.ProbabilityCompareReverse(e1, e2)
    else
      return DataModel.ProbabilityCompare(e1, e2)
    end
  elseif curType == 2 then
    if DataModel.sortReverseMap[curType] then
      return DataModel.HealthyCompareReverse(e1, e2)
    else
      return DataModel.HealthyCompare(e1, e2)
    end
  elseif curType == 3 then
    if DataModel.sortReverseMap[curType] then
      return DataModel.DaysCompareReverse(e1, e2)
    else
      return DataModel.DaysCompare(e1, e2)
    end
  elseif curType == 4 then
    if DataModel.sortReverseMap[curType] then
      return DataModel.RarityCompareReverse(e1, e2)
    else
      return DataModel.RarityCompare(e1, e2)
    end
  else
    return DataModel.DefaultCompare(e1, e2)
  end
end

function DataModel.DefaultCompare(e1, e2)
  if e1.prisoner_id ~= e2.prisoner_id then
    return tonumber(e1.prisoner_id) > tonumber(e2.prisoner_id)
  elseif #e1.uid ~= #e2.uid then
    return #e1.uid > #e2.uid
  else
    for i = 1, #e1.uid do
      local sub1 = string.sub(e1.uid, i, i)
      local sub2 = string.sub(e2.uid, i, i)
      if tonumber(sub1) ~= tonumber(sub2) then
        return tonumber(sub1) > tonumber(sub2)
      end
    end
    return false
  end
end

function DataModel.ProbabilityCompare(e1, e2)
  local ca1 = PlayerData:GetFactoryData(e1.prisoner_id)
  local ca2 = PlayerData:GetFactoryData(e2.prisoner_id)
  if ca1.extraOutputProbability ~= ca2.extraOutputProbability then
    return ca1.extraOutputProbability > ca2.extraOutputProbability
  else
    return DataModel.DefaultCompare(e1, e2)
  end
end

function DataModel.ProbabilityCompareReverse(e1, e2)
  local ca1 = PlayerData:GetFactoryData(e1.prisoner_id)
  local ca2 = PlayerData:GetFactoryData(e2.prisoner_id)
  if ca1.extraOutputProbability ~= ca2.extraOutputProbability then
    return ca1.extraOutputProbability < ca2.extraOutputProbability
  else
    return DataModel.DefaultCompare(e1, e2)
  end
end

function DataModel.HealthyCompare(e1, e2)
  local healthy1 = e1.healthy
  local healthy2 = e2.healthy
  if DataModel.PageMode ~= "Prison" or not DataModel.isInPrison then
    local ca1 = PlayerData:GetFactoryData(e1.prisoner_id)
    if healthy1 ~= nil then
      healthy1 = math.ceil(ca1.physicalQuality * healthy1)
    else
      healthy1 = ca1.physicalQuality * 100
    end
    local ca2 = PlayerData:GetFactoryData(e2.prisoner_id)
    if healthy2 ~= nil then
      healthy2 = math.ceil(ca2.physicalQuality * healthy2)
    else
      healthy2 = ca2.physicalQuality * 100
    end
  end
  if healthy1 ~= healthy2 then
    return healthy1 > healthy2
  else
    return DataModel.DefaultCompare(e1, e2)
  end
end

function DataModel.HealthyCompareReverse(e1, e2)
  local healthy1 = e1.healthy
  local healthy2 = e2.healthy
  if DataModel.PageMode ~= "Prison" or not DataModel.isInPrison then
    local ca1 = PlayerData:GetFactoryData(e1.prisoner_id)
    if healthy1 ~= nil then
      healthy1 = math.ceil(ca1.physicalQuality * healthy1)
    else
      healthy1 = ca1.physicalQuality * 100
    end
    local ca2 = PlayerData:GetFactoryData(e2.prisoner_id)
    if healthy2 ~= nil then
      healthy2 = math.ceil(ca2.physicalQuality * healthy2)
    else
      healthy2 = ca2.physicalQuality * 100
    end
  end
  if healthy1 ~= healthy2 then
    return healthy1 < healthy2
  else
    return DataModel.DefaultCompare(e1, e2)
  end
end

function DataModel.DaysCompare(e1, e2)
  local remainTime1 = math.max(0, TimeUtil:GetServerTimeStamp() - e1.imprisonment_ts)
  local remainDays1 = e1.days - TimeUtil:SecondToTable(remainTime1).day
  local remainTime2 = math.max(0, TimeUtil:GetServerTimeStamp() - e2.imprisonment_ts)
  local remainDays2 = e2.days - TimeUtil:SecondToTable(remainTime2).day
  if remainDays1 ~= remainDays2 then
    return remainDays1 > remainDays2
  else
    return DataModel.DefaultCompare(e1, e2)
  end
end

function DataModel.DaysCompareReverse(e1, e2)
  local remainTime1 = math.max(0, TimeUtil:GetServerTimeStamp() - e1.imprisonment_ts)
  local remainDays1 = e1.days - TimeUtil:SecondToTable(remainTime1).day
  local remainTime2 = math.max(0, TimeUtil:GetServerTimeStamp() - e2.imprisonment_ts)
  local remainDays2 = e2.days - TimeUtil:SecondToTable(remainTime2).day
  if remainDays1 ~= remainDays2 then
    return remainDays1 < remainDays2
  else
    return DataModel.DefaultCompare(e1, e2)
  end
end

function DataModel.RarityCompare(e1, e2)
  local ca1 = PlayerData:GetFactoryData(e1.prisoner_id)
  local ca2 = PlayerData:GetFactoryData(e2.prisoner_id)
  local r1 = 1
  local r2 = 1
  for i = 1, #DataModel.rarityEnum do
    if tostring(DataModel.rarityEnum[i].id) == tostring(ca1.prisonerRarity) then
      r1 = i
    end
    if tostring(DataModel.rarityEnum[i].id) == tostring(ca2.prisonerRarity) then
      r2 = i
    end
  end
  if r1 ~= r2 then
    return r1 > r2
  else
    return DataModel.DefaultCompare(e1, e2)
  end
end

function DataModel.RarityCompareReverse(e1, e2)
  local ca1 = PlayerData:GetFactoryData(e1.prisoner_id)
  local ca2 = PlayerData:GetFactoryData(e2.prisoner_id)
  local r1 = 1
  local r2 = 1
  for i = 1, #DataModel.rarityEnum do
    if tostring(DataModel.rarityEnum[i].id) == tostring(ca1.prisonerRarity) then
      r1 = i
    end
    if tostring(DataModel.rarityEnum[i].id) == tostring(ca2.prisonerRarity) then
      r2 = i
    end
  end
  if r1 ~= r2 then
    return r1 < r2
  else
    return DataModel.DefaultCompare(e1, e2)
  end
end

function DataModel:SortPrisonPrisonerList()
  if #self.prisonPrisonerList > 0 then
    table.sort(self.prisonPrisonerList, self.Compare)
    View.Group_NoPrison.self:SetActive(false)
    View.ScrollGrid_Prison.self:SetActive(true)
    View.ScrollGrid_Prison.grid.self:SetDataCount(#self.prisonPrisonerList)
    View.ScrollGrid_Prison.grid.self:RefreshAllElement()
    View.ScrollGrid_Prison.grid.self:MoveToTop()
  else
    View.ScrollGrid_Prison.self:SetActive(false)
    View.Group_NoPrison.self:SetActive(true)
  end
  self:RefreshPrisonBottom()
end

function DataModel:GetMaxPrisonerNum()
  local prisonCfg = PrisonData.GetPrisonCA()
  local cellRoomList = PrisonData.GetCellRoomList()
  local totalNum = 0
  for i, v in pairs(cellRoomList) do
    totalNum = totalNum + table.count(v) * prisonCfg.roomPrisonerNum
  end
  return totalNum
end

function DataModel:RefreshPrisonBottom()
  local curNum = table.count(PlayerData.ServerData.user_prison_info.prison_backpack) + table.count(PlayerData.ServerData.user_prison_info.temporary_backpack)
  local totalNum = DataModel:GetMaxPrisonerNum()
  View.Group_Bottom.Group_Prison.Group_Prisoner.Txt_Num:SetText(string.format(GetText(80607078), curNum, "", totalNum))
  local cost = 0
  for k, v in pairs(PlayerData.ServerData.user_prison_info.prison_backpack) do
    local prisonerData = v
    local prisonerCA = PlayerData:GetFactoryData(prisonerData.prisoner_id)
    if 0 < #prisonerCA.prisonerCost then
      cost = cost + prisonerCA.prisonerCost[1].num
    end
  end
  View.Group_Bottom.Group_Prison.Group_Cost.Txt_Num:SetText(string.format(GetText(80607092), cost))
end

function DataModel:RefreshPrisonPackGrid(element, elementIndex)
  local prisonerData = self.prisonPrisonerList[elementIndex]
  local prisonerCA = PlayerData:GetFactoryData(prisonerData.prisoner_id)
  element.Group_Normal.Txt_Name:SetText(prisonerCA.prisonerName)
  local placeCA = PlayerData:GetFactoryData(prisonerData.place_id)
  if placeCA.name ~= nil then
    element.Group_Normal.Group_Location.Txt_:SetText(string.format(GetText(80607093), placeCA.name))
  elseif placeCA.station01 ~= nil and placeCA.station02 ~= nil then
    local station1CA = PlayerData:GetFactoryData(placeCA.station01)
    local station2CA = PlayerData:GetFactoryData(placeCA.station02)
    element.Group_Normal.Group_Location.Txt_:SetText(string.format(GetText(80607093), station1CA.name .. "-" .. station2CA.name))
  end
  local personalityCA = PlayerData:GetFactoryData(prisonerData.personality_id)
  element.Group_Normal.Group_Personality.Txt_:SetText(personalityCA.prisonerPersonalityName)
  if personalityCA.icon ~= nil and personalityCA.icon ~= "" then
    element.Group_Normal.Group_Personality.Img_:SetSprite(personalityCA.icon)
  end
  local specialityCA = PlayerData:GetFactoryData(prisonerData.speciality_id)
  if specialityCA then
    element.Group_Normal.Group_GoodAt.Txt_:SetText(specialityCA.prisonerSpeciality)
    element.Group_Normal.Group_GoodAt.Img_:SetSprite(specialityCA.icon)
  end
  element.Group_Normal.Img_Pic:SetSprite(prisonerCA.prisonerIconPath)
  local rarityCA = PlayerData:GetFactoryData(prisonerCA.prisonerRarity)
  element.Group_Normal.Group_ID.Img_Rarity:SetSprite(rarityCA.prisonerRarity)
  local sideCA = PlayerData:GetFactoryData(prisonerCA.prisonerSide)
  if sideCA then
    element.Group_Normal.Img_Side:SetSprite(sideCA.iconPath)
  end
  local client_num
  if prisonerData.clint_num then
    local zeroCount = 6 - string.len(prisonerData.clint_num)
    client_num = prisonerData.clint_num
    for i = 1, zeroCount do
      client_num = 0 .. client_num
    end
  else
    client_num = "XXXXXX"
  end
  element.Group_Normal.Group_ID.Txt_ID:SetText(client_num)
  local healthyStr = GetText(80608522)
  local curHealthy = prisonerData.healthy
  local maxHealthy = PrisonData.GetPrisonCA().defaultHealth
  element.Group_Normal.Group_Energy.Txt_Num:SetText(string.format(healthyStr, curHealthy, maxHealthy))
  element.Group_Normal.Group_Energy.Img_Bar.Img_:SetFilledImgAmount(curHealthy / maxHealthy)
  local monitorCA = PlayerData:GetFactoryData(prisonerCA.monitor)
  if monitorCA ~= nil then
    element.Group_Normal.Group_Skill.Txt_:SetText(monitorCA.monitorJobName)
  end
  element.Group_Normal.Group_Outcome.Txt_:SetText(GetText(80607788))
  element.Group_Normal.Group_Outcome.Txt_Des:SetText(string.format(GetText(80608126), math.ceil(prisonerCA.extraOutputProbability * 100)))
  local status = DataModel:JudgePrisonerStatus(prisonerData)
  if status == 1 then
    element.Group_Normal.Txt_State:SetText(GetText(80608253))
  elseif status == 2 then
    element.Group_Normal.Txt_State:SetText(GetText(80608255))
  elseif status == 3 then
    element.Group_Normal.Txt_State:SetText(GetText(80608254))
  else
    element.Group_Normal.Txt_State:SetText(GetText(80607982))
  end
  local remainTime = math.max(0, TimeUtil:GetServerTimeStamp() - prisonerData.imprisonment_ts)
  local remainDays = TimeUtil:SecondToTable(remainTime).day
  element.Group_Normal.Group_Time.Txt_Num:SetText(prisonerData.days - remainDays)
  if 0 < #prisonerCA.prisonerCost then
    element.Group_Normal.Group_Cost.Txt_Num:SetText(string.format(GetText(80607092), prisonerCA.prisonerCost[1].num))
  end
end

function DataModel:JudgePrisonerStatus(prisonerData)
  local workshops_front = PlayerData.ServerData.user_prison_info.workshops_front or {}
  local workshops_product_plant = PlayerData.ServerData.user_prison_info.workshops_product_plant or {}
  for workshopId, cell in pairs(workshops_front) do
    for index, id in pairs(cell) do
      if tonumber(id) == tonumber(prisonerData.prisoner_id) and workshops_product_plant[workshopId] ~= nil and workshops_product_plant[workshopId][index] ~= nil then
        if workshops_product_plant[workshopId][index].sts == 0 then
          return 3
        end
        local formulaId = workshops_product_plant[workshopId][index].formula_group_id
        local formulaCA = PlayerData:GetFactoryData(formulaId)
        if formulaCA ~= nil then
          local tTime = workshops_product_plant[workshopId][index].count * formulaCA.perTime
          if tTime > workshops_product_plant[workshopId][index].start_ts + workshops_product_plant[workshopId][index].speed_ts then
            return 1
          end
        end
      end
    end
  end
  local raw_material_workshops = PlayerData.ServerData.user_prison_info.raw_material_workshops or {}
  for workshopId, cell in pairs(raw_material_workshops) do
    if cell.start_ts ~= 0 then
      local pidList = cell.u_pid_list or {}
      for i = 1, #pidList do
        if tonumber(pidList[i]) == tonumber(prisonerData.prisoner_id) then
          return 1
        end
      end
    end
  end
  local detention_room = PlayerData.ServerData.user_prison_info.detention_room or {}
  for k, v in pairs(detention_room) do
    if tonumber(k) == tonumber(prisonerData.prisoner_id) then
      return 2
    end
  end
  if prisonerData.disease_ts ~= nil and prisonerData.disease_ts < TimeUtil:GetServerTimeStamp() then
    return 3
  end
  return 4
end

function DataModel:OnClickPrisonEnterBtn()
  self:OpenPrisonerCheckIn()
end

function DataModel:OnClickReturnBtn()
  if self.PageMode == "Prison" and not self.isInPrison then
    self:InitSortType()
    self:RefreshPrison()
  else
    View.self:CloseUI()
  end
end

function DataModel:InitCoach()
  View.Group_TopRightPrison.self:SetActive(false)
  View.ScrollGrid_Prison.self:SetActive(false)
  View.Group_Bottom.Group_Prison.self:SetActive(false)
  View.Group_TopRightCoach.self:SetActive(true)
  View.ScrollGrid_Coach.self:SetActive(true)
  View.Group_Bottom.Group_CoachList.self:SetActive(true)
  View.Group_Bottom.Group_CoachList.Btn_Confirm:SetActive(self.PageMode == "Prison")
  View.Group_Bottom.Group_CoachList.Btn_All:SetActive(self.PageMode == "Prison")
  View.Group_Bottom.Group_CoachList.Btn_Release:SetActive(self.PageMode == "Prison")
  if self.PageMode == "Prison" then
    View.Txt_Title:SetText(GetText(80607974))
  else
    View.Txt_Title:SetText(GetText(80607975))
  end
  self:InitCoachPrisonerList()
  View.Group_Bottom.Group_CoachList.Btn_Release:SetActive(self.PageMode == "Prison" and #self.coachPrisonerList > 0)
end

function DataModel:InitCoachPrisonerList()
  self.coachPrisonerList = {}
  for k, v in pairs(PlayerData.ServerData.user_prison_info.carrying_backpack) do
    if self:CheckPrisoner(v) then
      self.coachPrisonerList[#self.coachPrisonerList + 1] = {
        uid = k,
        prisoner_id = v.prisoner_id,
        place_id = v.place_id,
        personality_id = v.personality_id,
        healthy = v.healthy,
        speciality_id = v.speciality_id
      }
    end
  end
  self:SortCoachPrisonerList()
end

function DataModel:CheckPrisoner(prisonerData)
  local rt = true
  local prisonerCA = PlayerData:GetFactoryData(prisonerData.prisoner_id)
  if self.personalityIndex > 0 then
    rt = rt and tostring(prisonerData.personality_id) == tostring(self.personalityEnum[self.personalityIndex].id)
  end
  if 0 < self.specialityIndex then
    rt = rt and tostring(prisonerData.speciality_id) == tostring(self.specialityEnum[self.specialityIndex].id)
  end
  if 0 < self.rarityIndex then
    rt = rt and tostring(prisonerCA.prisonerRarity) == tostring(self.rarityEnum[self.rarityIndex].id)
  end
  return rt
end

function DataModel:OnClickBtnSift()
  View.Group_Chapter:SetActive(true)
  self.personalityIndexCache = self.personalityIndex
  self.specialityIndexCache = self.specialityIndex
  self.rarityIndexCache = self.rarityIndex
  for i = 0, #self.personalityEnum do
    local str = "Btn_C0"
    if 10 <= i then
      str = "Btn_C"
    end
    if i == self.personalityIndexCache then
      View.Group_Chapter.Group_Career[str .. i].Img_Select:SetActive(true)
    else
      View.Group_Chapter.Group_Career[str .. i].Img_Select:SetActive(false)
    end
  end
  for i = 0, #self.specialityEnum do
    if i == self.specialityIndexCache then
      View.Group_Chapter.Group_Group["Btn_G0" .. i].Img_Select:SetActive(true)
    else
      View.Group_Chapter.Group_Group["Btn_G0" .. i].Img_Select:SetActive(false)
    end
  end
  for i = 0, #self.rarityEnum do
    if i == self.rarityIndexCache then
      View.Group_Chapter.Group_Rarity["Btn_R0" .. i].Img_Select:SetActive(true)
    else
      View.Group_Chapter.Group_Rarity["Btn_R0" .. i].Img_Select:SetActive(false)
    end
  end
end

function DataModel:OnClickSiftCancel()
  View.Group_Chapter:SetActive(false)
end

function DataModel:OnClickSiftConfirm()
  View.Group_Chapter:SetActive(false)
  self.personalityIndex = self.personalityIndexCache
  self.specialityIndex = self.specialityIndexCache
  self.rarityIndex = self.rarityIndexCache
  self.checkInPrisonerList = {}
  if self.PageMode == "Prison" and self.isInPrison then
    self:InitPrisonPrisonerList()
  else
    self:InitCoachPrisonerList()
  end
end

function DataModel:OnClickPersonality(index)
  local lastIndex = self.personalityIndexCache
  if lastIndex ~= nil then
    local str = "Btn_C0"
    if 10 <= lastIndex then
      str = "Btn_C"
    end
    View.Group_Chapter.Group_Career[str .. lastIndex].Img_Select:SetActive(false)
  end
  local str = "Btn_C0"
  if 10 <= index then
    str = "Btn_C"
  end
  View.Group_Chapter.Group_Career[str .. index].Img_Select:SetActive(true)
  self.personalityIndexCache = index
end

function DataModel:OnClickSpeciality(index)
  local lastIndex = self.specialityIndexCache
  if lastIndex ~= nil then
    View.Group_Chapter.Group_Group["Btn_G0" .. lastIndex].Img_Select:SetActive(false)
  end
  View.Group_Chapter.Group_Group["Btn_G0" .. index].Img_Select:SetActive(true)
  self.specialityIndexCache = index
end

function DataModel:OnClickRarity(index)
  local lastIndex = self.rarityIndexCache
  if lastIndex ~= nil then
    View.Group_Chapter.Group_Rarity["Btn_R0" .. lastIndex].Img_Select:SetActive(false)
  end
  View.Group_Chapter.Group_Rarity["Btn_R0" .. index].Img_Select:SetActive(true)
  self.rarityIndexCache = index
end

function DataModel:SortCoachPrisonerList(notMoveTop)
  if #self.coachPrisonerList > 0 then
    table.sort(self.coachPrisonerList, self.Compare)
    View.Group_NoPrison.self:SetActive(false)
    View.ScrollGrid_Coach.self:SetActive(true)
    View.ScrollGrid_Coach.grid.self:SetDataCount(#self.coachPrisonerList)
    View.ScrollGrid_Coach.grid.self:RefreshAllElement()
    if not notMoveTop then
      View.ScrollGrid_Coach.grid.self:MoveToTop()
    end
  else
    View.ScrollGrid_Coach.self:SetActive(false)
    View.Group_NoPrison.self:SetActive(true)
  end
  self:RefreshGroupBottom()
end

function DataModel:RefreshBackpackGrid(element, elementIndex)
  if self.PageMode == "Coach" then
    self:RefreshCoachGrid(element, elementIndex)
  elseif self.PageMode == "Prison" then
    self:RefreshPrisonGrid(element, elementIndex)
  end
end

function DataModel:RefreshCoachGrid(element, elementIndex)
  element.Group_Right.Img_Unpicked:SetActive(false)
  element.Group_Right.Img_Picked:SetActive(false)
  element.Group_Right.Img_Coach:SetActive(true)
  local prisonerData = self.coachPrisonerList[elementIndex]
  local prisonerCA = PlayerData:GetFactoryData(prisonerData.prisoner_id)
  element.Group_Normal.Txt_Name:SetText(prisonerCA.prisonerName)
  local placeCA = PlayerData:GetFactoryData(prisonerData.place_id)
  if placeCA.name ~= nil then
    element.Group_Normal.Group_Location.Txt_:SetText(string.format(GetText(80607093), placeCA.name))
  elseif placeCA.station01 ~= nil and placeCA.station02 ~= nil then
    local station1CA = PlayerData:GetFactoryData(placeCA.station01)
    local station2CA = PlayerData:GetFactoryData(placeCA.station02)
    element.Group_Normal.Group_Location.Txt_:SetText(string.format(GetText(80607093), station1CA.name .. "-" .. station2CA.name))
  end
  local personalityCA = PlayerData:GetFactoryData(prisonerData.personality_id)
  element.Group_Normal.Group_Personality.Txt_:SetText(personalityCA.prisonerPersonalityName)
  if personalityCA.icon ~= nil and personalityCA.icon ~= "" then
    element.Group_Normal.Group_Personality.Img_:SetSprite(personalityCA.icon)
  end
  local specialityCA = PlayerData:GetFactoryData(prisonerData.speciality_id)
  if specialityCA then
    element.Group_Normal.Group_GoodAt.Txt_:SetText(specialityCA.prisonerSpeciality)
    element.Group_Normal.Group_GoodAt.Img_:SetSprite(specialityCA.icon)
  end
  element.Group_Normal.Img_Pic:SetSprite(prisonerCA.prisonerIconPath)
  local rarityCA = PlayerData:GetFactoryData(prisonerCA.prisonerRarity)
  element.Group_Normal.Group_ID.Img_Rarity:SetSprite(rarityCA.prisonerRarity)
  local sideCA = PlayerData:GetFactoryData(prisonerCA.prisonerSide)
  if sideCA then
    element.Group_Normal.Img_Side:SetSprite(sideCA.iconPath)
  end
  local healthy = prisonerData.healthy
  if healthy ~= nil then
    element.Group_Energy.Txt_Num:SetText(math.ceil(prisonerCA.physicalQuality * healthy))
  else
    element.Group_Energy.Txt_Num:SetText(prisonerCA.physicalQuality * 100)
  end
  element.Btn_Release:SetClickParam(elementIndex)
end

function DataModel:RefreshPrisonGrid(element, elementIndex)
  local isCheckIn = self.checkInPrisonerList[elementIndex] == true
  element.Group_Right.Img_Unpicked:SetActive(not isCheckIn)
  element.Group_Right.Img_Picked:SetActive(isCheckIn)
  element.Group_Right.Img_Coach:SetActive(false)
  local prisonerData = self.coachPrisonerList[elementIndex]
  local prisonerCA = PlayerData:GetFactoryData(prisonerData.prisoner_id)
  element.Group_Normal.Txt_Name:SetText(prisonerCA.prisonerName)
  local placeCA = PlayerData:GetFactoryData(prisonerData.place_id)
  if placeCA.name ~= nil then
    element.Group_Normal.Group_Location.Txt_:SetText(string.format(GetText(80607093), placeCA.name))
  elseif placeCA.station01 ~= nil and placeCA.station02 ~= nil then
    local station1CA = PlayerData:GetFactoryData(placeCA.station01)
    local station2CA = PlayerData:GetFactoryData(placeCA.station02)
    element.Group_Normal.Group_Location.Txt_:SetText(string.format(GetText(80607093), station1CA.name .. "-" .. station2CA.name))
  end
  local personalityCA = PlayerData:GetFactoryData(prisonerData.personality_id)
  element.Group_Normal.Group_Personality.Txt_:SetText(personalityCA.prisonerPersonalityName)
  if personalityCA.icon ~= nil and personalityCA.icon ~= "" then
    element.Group_Normal.Group_Personality.Img_:SetSprite(personalityCA.icon)
  end
  local specialityCA = PlayerData:GetFactoryData(prisonerData.speciality_id)
  if specialityCA then
    element.Group_Normal.Group_GoodAt.Txt_:SetText(specialityCA.prisonerSpeciality)
    element.Group_Normal.Group_GoodAt.Img_:SetSprite(specialityCA.icon)
  end
  element.Group_Normal.Img_Pic:SetSprite(prisonerCA.prisonerIconPath)
  local rarityCA = PlayerData:GetFactoryData(prisonerCA.prisonerRarity)
  element.Group_Normal.Group_ID.Img_Rarity:SetSprite(rarityCA.prisonerRarity)
  local sideCA = PlayerData:GetFactoryData(prisonerCA.prisonerSide)
  if sideCA then
    element.Group_Normal.Img_Side:SetSprite(sideCA.iconPath)
  end
  local healthy = prisonerData.healthy
  if healthy ~= nil then
    element.Group_Energy.Txt_Num:SetText(math.ceil(prisonerCA.physicalQuality * healthy))
  else
    element.Group_Energy.Txt_Num:SetText(prisonerCA.physicalQuality * 100)
  end
  element.Btn_Pick:SetClickParam(elementIndex)
  element.Btn_Release:SetClickParam(elementIndex)
end

function DataModel:OnClickPickPrisoner(str)
  if self.PageMode == "Prison" then
    if self.checkInPrisonerList[tonumber(str)] ~= true then
      local curNum = table.count(PlayerData.ServerData.user_prison_info.prison_backpack) + table.count(PlayerData.ServerData.user_prison_info.temporary_backpack)
      local checkNum = self:GetCheckInCount()
      local totalNum = DataModel:GetMaxPrisonerNum()
      if totalNum <= curNum + checkNum then
        CommonTips.OpenTips(GetText(80607475))
        return
      end
      self.checkInPrisonerList[tonumber(str)] = true
    else
      self.checkInPrisonerList[tonumber(str)] = false
    end
    self:SortCoachPrisonerList(true)
  end
end

function DataModel:OnClickPickAll()
  local curNum = table.count(PlayerData.ServerData.user_prison_info.prison_backpack) + table.count(PlayerData.ServerData.user_prison_info.temporary_backpack)
  local checkNum = self:GetCheckInCount()
  local needNum = DataModel:GetMaxPrisonerNum() - curNum - checkNum
  for i = 1, #self.coachPrisonerList do
    if needNum <= 0 then
      break
    end
    if self.checkInPrisonerList[i] ~= true then
      self.checkInPrisonerList[i] = true
      needNum = needNum - 1
    end
  end
  self:SortCoachPrisonerList(true)
end

function DataModel:OnClickReleasePrisoner(str)
  CommonTips.OnPrompt("80607091", "80600068", "80600067", function()
    local u_pid_list = {
      self.coachPrisonerList[tonumber(str)].uid
    }
    Net:SendProto("prison.release", function(json)
      DataModel:OpenPrisonerCheckIn()
    end, u_pid_list)
  end)
end

function DataModel:OnClickReleaseAllPrisoner(str)
  if #self.coachPrisonerList <= 0 then
    return
  end
  CommonTips.OnPrompt(string.format(GetText("80609236"), #self.coachPrisonerList), "80600068", "80600067", function()
    local u_pid_list = {}
    for i = 1, #self.coachPrisonerList do
      u_pid_list[#u_pid_list + 1] = self.coachPrisonerList[i].uid
    end
    Net:SendProto("prison.release", function(json)
      DataModel:OpenPrisonerCheckIn()
    end, u_pid_list)
  end)
end

function DataModel:GetCheckInCount()
  local checkInCount = 0
  for k, v in pairs(self.checkInPrisonerList) do
    if v == true then
      checkInCount = checkInCount + 1
    end
  end
  return checkInCount
end

function DataModel:RefreshGroupBottom()
  local checkInCount = self:GetCheckInCount()
  local curNum = table.count(PlayerData.ServerData.user_prison_info.carrying_backpack)
  local maxNum = PrisonData.GetPrisonerBagMaxCapacity()
  local outStr = ""
  local inStr = ""
  if 0 < checkInCount then
    outStr = string.format(GetText(80607079), checkInCount)
    inStr = string.format(GetText(80607080), checkInCount)
  end
  View.Group_Bottom.Group_CoachList.Group_PrisonerNot.Txt_Num:SetText(string.format(GetText(80607078), curNum, outStr, maxNum))
  curNum = table.count(PlayerData.ServerData.user_prison_info.prison_backpack) + table.count(PlayerData.ServerData.user_prison_info.temporary_backpack)
  local totalNum = DataModel:GetMaxPrisonerNum()
  View.Group_Bottom.Group_CoachList.Group_Prisoner.Txt_Num:SetText(string.format(GetText(80607078), curNum, inStr, totalNum))
  View.Group_Bottom.Group_CoachList.Btn_Confirm.Img_ConfirmNot:SetActive(checkInCount <= 0)
  local backpackCount = table.count(PlayerData.ServerData.user_prison_info.carrying_backpack)
  local prisonerCount = table.count(PlayerData.ServerData.user_prison_info.prison_backpack)
  View.Group_Bottom.Group_Prison.Btn_PrisonerEnter.Img_RedPoint:SetActive(0 < backpackCount and prisonerCount < 168)
end

function DataModel:OnClickCheckInConrirm()
  local checkInCount = self:GetCheckInCount()
  if checkInCount <= 0 then
    return
  end
  if TradeDataModel.CurStayCity ~= 83000017 then
    CommonTips.OpenTips(80608033)
    return
  end
  local u_pid_list = {}
  for k, v in pairs(self.checkInPrisonerList) do
    if v == true and self.coachPrisonerList[tonumber(k)] ~= nil then
      u_pid_list[#u_pid_list + 1] = self.coachPrisonerList[tonumber(k)].uid
    end
  end
  Net:SendProto("prison.imprisonment", function(json)
    UIManager:Open("UI/Prison/PrisonerList/PrisonerArrangement", Json.encode({uidList = u_pid_list}))
    self:RefreshPrison()
    local backpackCount = table.count(PlayerData.ServerData.user_prison_info.carrying_backpack)
    local prisonerCount = table.count(PlayerData.ServerData.user_prison_info.prison_backpack)
    View.Group_Bottom.Group_Prison.Btn_PrisonerEnter.Img_RedPoint:SetActive(0 < backpackCount and prisonerCount < 168)
  end, u_pid_list)
end

return DataModel
