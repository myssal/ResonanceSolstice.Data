local View = require("UIHomeCarriageeditor/UIHomeCarriageeditorView")
local DataModel = require("UIHomeCarriageeditor/UIStudyDataModel")
local BtnItem = require("Common/BtnItem")
local Controller = {}

function Controller:InitView()
  DataModel.viewLoadComplete = true
  DataModel.Init()
  DataModel.selectTreeIdx = 0
  DataModel.selectNodeIdx = 0
  self:RefreshTopTitle()
  View.Group_StudyMap.Group_StudyInfo.self:SetActive(false)
  View.Group_StudyMap.Group_StudyTree.ScrollGrid_List.grid.self:SetDataCount(#DataModel.studyData)
  View.Group_StudyMap.Group_StudyTree.ScrollGrid_List.grid.self:RefreshAllElement()
  self:ClickTreeElement(0 < DataModel.autoSelectTreeIdx and DataModel.autoSelectTreeIdx or 1, true)
  if 0 < DataModel.autoSelectTreeIdx and 0 < DataModel.autoSelectNodeIdx then
    self:InnerJumpNode(DataModel.autoSelectTreeIdx, DataModel.autoSelectNodeIdx)
    self:ClickNodeElement(DataModel.autoSelectNodeIdx, true)
  end
  Controller:AutoGetSkin()
end

function Controller:AutoGetSkin()
  if DataModel.studyingId > 0 and TimeUtil:GetServerTimeStamp() >= DataModel.studyingEndTime then
    self:ClickBtnFinish()
  end
end

function Controller:RefreshTopTitle()
  self:RefreshStudyNum()
  self:RefreshStudying()
end

function Controller:RefreshStudyNum()
  View.Group_StudyMap.Img_TittleBg.Group_Tip.Group_Num.Txt_StudyNum:SetText(table.count(DataModel.cacheStudiedId))
  View.Group_StudyMap.Img_TittleBg.Group_Tip.Group_Num.Txt_Total:SetText("/" .. DataModel.totalNum)
end

function Controller:RefreshStudying()
  if DataModel.studyingId > 0 then
    local remainTime = DataModel.studyingEndTime - TimeUtil:GetServerTimeStamp()
    if 0 < remainTime then
      self:UpdateStudyTime()
    end
    View.Group_StudyMap.Group_Study.Txt_Name:SetText(DataModel.studyingCA.name)
    View.Group_StudyMap.Group_Study.Btn_FInish:SetActive(true)
  else
    DataModel.studyingCA = {}
    DataModel.studyingId = 0
    DataModel.studyingEndTime = 0
    View.Group_StudyMap.Group_Study.Txt_Name:SetText(GetText(80610237))
    View.Group_StudyMap.Group_Study.Txt_Time:SetText("--:--:--")
    View.Group_StudyMap.Group_Study.Img_PBG.Img_Progress:SetFilledImgAmount(1)
    View.Group_StudyMap.Group_Study.Btn_FInish:SetActive(false)
  end
end

function Controller:UpdateStudyTime()
  if not DataModel.viewLoadComplete then
    return
  end
  if DataModel.isUpdateStudying and DataModel.studyingId > 0 then
    local remainTime = DataModel.studyingEndTime - TimeUtil:GetServerTimeStamp()
    if remainTime <= 0 then
      View.Group_StudyMap.Group_Study.Txt_Time:SetText("--:--:--")
      View.Group_StudyMap.Group_Study.Img_PBG.Img_Progress:SetFilledImgAmount(1)
      DataModel.isUpdateStudying = false
    else
      local timeTable = TimeUtil:SecondToTable(remainTime)
      View.Group_StudyMap.Group_Study.Txt_Time:SetText(string.format("%02d:%02d:%02d", timeTable.hour + timeTable.day * 24, timeTable.minute, timeTable.second))
      local totalTime = DataModel.studyingCA.timeCost
      View.Group_StudyMap.Group_Study.Img_PBG.Img_Progress:SetFilledImgAmount((totalTime - remainTime) / totalTime)
    end
  end
end

function Controller:ClickBtnFinish()
  if DataModel.studyingId > 0 then
    local function complete_studying()
      Net:SendProto("home.complete_studying", function(json)
        PlayerData:GetHomeInfo().studying = {}
        
        local skinId = DataModel.studyingId
        DataModel.RefreshStudyingInfo()
        self:DetailGetSkin(skinId)
      end)
    end
    
    local remainTime = DataModel.studyingEndTime - TimeUtil:GetServerTimeStamp()
    if 0 < remainTime then
      local trainWeaponConfig = PlayerData:GetFactoryData(99900044)
      local unit = math.ceil(remainTime / trainWeaponConfig.lTime)
      local cost = {}
      for i, v in ipairs(trainWeaponConfig.hourCost) do
        cost[v.id] = v.num * unit
      end
      for i, v in ipairs(trainWeaponConfig.lCost) do
        if cost[v.id] then
          cost[v.id] = cost[v.id] + v.num
        else
          cost[v.id] = v.num
        end
      end
      local key, value = next(cost)
      local showTxt = string.format(GetText(80610271), value)
      CommonTips.OnPrompt(showTxt, nil, nil, function()
        remainTime = DataModel.studyingEndTime - TimeUtil:GetServerTimeStamp()
        if 0 < remainTime then
          for _, v in ipairs(cost) do
            if PlayerData.GetGoodsById(v.id).num < v.num then
              CommonTips.OpenTips(80610274)
              return
            end
          end
          Net:SendProto("home.skip_study", function(json)
            PlayerData:GetHomeInfo().studying = {}
            PlayerData:RefreshUseItems(cost)
            local skinId = DataModel.studyingId
            DataModel.RefreshStudyingInfo()
            self:DetailGetSkin(skinId)
          end)
        else
          complete_studying()
        end
      end)
    else
      complete_studying()
    end
  end
end

function Controller:DetailGetSkin(skinId)
  self:RefreshStudying()
  DataModel.cacheStudiedId[skinId] = 1
  local ca = PlayerData:GetFactoryData(skinId)
  for _, v in ipairs(DataModel.studyData) do
    if v.id == ca.treeStudy then
      v.studiedCount = v.studiedCount + 1
      break
    end
  end
  local t = {}
  t.id = skinId
  UIManager:Open("UI/TrainStudy/StudyOver", Json.encode(t))
  self:RefreshTopTitle()
  self:ClickTreeElement(DataModel.selectTreeIdx, true)
  if DataModel.selectNodeIdx > 0 then
    self:ClickNodeElement(DataModel.selectNodeIdx, true)
  end
end

function Controller:ClickBtnJump()
  local targetTreeIdx = 0
  local targetNodeIdx = 0
  
  local function findIdx(studyId)
    local ca = PlayerData:GetFactoryData(studyId)
    local treeId = ca.treeStudy
    for treeIdx, v in ipairs(DataModel.studyData) do
      if treeId == v.id then
        for nodeIdx, v1 in ipairs(v.studyList) do
          if v1.id == studyId then
            return treeIdx, nodeIdx
          end
        end
        break
      end
    end
  end
  
  if DataModel.studyingId and 0 < DataModel.studyingId then
    targetTreeIdx, targetNodeIdx = findIdx(DataModel.studyingId)
  else
    local defaultConfig = PlayerData:GetFactoryData(99900044)
    local firstNoStudyId = 0
    for _, v in ipairs(defaultConfig.studyList) do
      if not DataModel.cacheStudiedId[v.id] then
        if firstNoStudyId == 0 then
          firstNoStudyId = v.id
        end
        if DataModel.CheckCanStudy(v.id) then
          local checkUnlock = true
          local ca = PlayerData:GetFactoryData(v.id)
          for _, itemInfo in ipairs(ca.itemPrepare) do
            if 0 >= PlayerData:GetGoodsById(itemInfo.id).num then
              checkUnlock = false
              break
            end
          end
          if checkUnlock then
            targetTreeIdx, targetNodeIdx = findIdx(v.id)
            break
          end
        end
      end
    end
    if targetTreeIdx == 0 and targetNodeIdx == 0 and 0 < firstNoStudyId then
      targetTreeIdx, targetNodeIdx = findIdx(firstNoStudyId)
    end
  end
  self:InnerJumpNode(targetTreeIdx, targetNodeIdx)
  self:CloseDetailPanel()
  self:ClickNodeElement(targetNodeIdx)
end

function Controller:InnerJumpNode(targetTreeIdx, targetNodeIdx)
  if targetTreeIdx and 0 < targetTreeIdx and targetNodeIdx and 0 < targetNodeIdx then
    if targetTreeIdx ~= DataModel.selectTreeIdx then
      self:ClickTreeElement(targetTreeIdx)
    end
    local element = View.Group_StudyMap.ScrollView_Map.Viewport.Content.Group_StudyPoint.StaticGrid_Point.grid[targetNodeIdx]
    local halfWidth = Screen.width * 0.5
    local posX = element.self:GetAnchoredPositionX()
    local targetX = posX - halfWidth
    if targetX < 0 then
      targetX = 0
    end
    View.Group_StudyMap.ScrollView_Map.Viewport.Content.self:SetAnchoredPositionX(-targetX)
    local scrollRect = View.Group_StudyMap.ScrollView_Map.self.ScrollRect
    scrollRect.enabled = false
    scrollRect.enabled = true
  end
end

function Controller:CloseDetailPanel()
  View.Group_StudyMap.Group_StudyInfo.self:SetActive(false)
  local element = View.Group_StudyMap.ScrollView_Map.Viewport.Content.Group_StudyPoint.StaticGrid_Point.grid[DataModel.selectNodeIdx]
  if element then
    element.Group_CarriageSkin.Img_Select:SetActive(false)
  end
  DataModel.selectNodeIdx = 0
  DataModel.lastSelectNodeIdx = 0
end

function Controller:ShowDetailPanel(studyId)
  local studyCA = PlayerData:GetFactoryData(studyId)
  local isStudied = DataModel.cacheStudiedId[studyId] ~= nil
  View.Group_StudyMap.Group_StudyInfo.self:SetActive(true)
  View.Group_StudyMap.Group_StudyInfo.Group_Info.Group_Top.Group_Study.Group_off.self:SetActive(not isStudied and studyId ~= DataModel.studyingId)
  View.Group_StudyMap.Group_StudyInfo.Group_Info.Group_Top.Group_Study.Group_over.self:SetActive(isStudied)
  View.Group_StudyMap.Group_StudyInfo.Group_Info.Group_Top.Group_Study.Group_on.self:SetActive(not isStudied and studyId == DataModel.studyingId)
  if not isStudied and studyId ~= DataModel.studyingId then
    local timeTable = TimeUtil:SecondToTable(studyCA.timeCost)
    View.Group_StudyMap.Group_StudyInfo.Group_Info.Group_Top.Group_Study.Group_off.Txt_:SetText(string.format("%02d:%02d:%02d", timeTable.hour + timeTable.day * 24, timeTable.minute, timeTable.second))
  end
  View.Group_StudyMap.Group_StudyInfo.Group_Info.Group_Top.Group_Name.Txt_Name:SetText(studyCA.name)
  local skinCA = PlayerData:GetFactoryData(studyCA.showPic)
  View.Group_StudyMap.Group_StudyInfo.Group_Info.Group_SkillInfo.Group_SpecialTitle.self:SetActive(true)
  for i = 1, 6 do
    local element = View.Group_StudyMap.Group_StudyInfo.Group_Info.Group_SkillInfo.Group_SpecialTitle["Group_SpecialEntry" .. i]
    local info = skinCA.normalEntryList[i]
    if info then
      element:SetActive(true)
      local ca = PlayerData:GetFactoryData(info.id, "TrainWeaponSkillFactory")
      local valueA
      if ca.aTypeInt == 1 then
        valueA = ca.aNumMinP
        if ca.aDevelopment then
          valueA = ca.aNumMinP * ca.aCommonNumP
        else
          valueA = valueA * ca.aCommonNumP
        end
      else
        valueA = ca.aNumMin
        if ca.aDevelopment then
          valueA = ca.aNumMin * ca.aCommonNum
        else
          valueA = valueA * ca.aCommonNum
        end
        valueA = ClearFollowZero(valueA)
      end
      local tagCa = PlayerData:GetFactoryData(ca.entryTag)
      local icon = tagCa.icon
      element.Img_Icon:SetSprite(icon)
      local text = "<color=#D2B075>" .. ca.name .. "</color>\227\128\128" .. string.format(ca.text, valueA)
      element.Txt_Entry:SetText(text)
      local txtHeight = element.Txt_Entry:GetHeight()
      element.Txt_Entry:SetHeight(txtHeight)
      element:SetHeight(txtHeight)
    else
      element:SetActive(false)
    end
  end
  View.Group_StudyMap.Group_StudyInfo.Group_Info.Group_SkillInfo.Group_SpecialTitle.self:SetActive(false)
  View.Group_StudyMap.Group_StudyInfo.Group_Info.Group_SkillInfo.Group_SpecialTitle.self:SetActive(true)
  local curLv = PlayerData:GetPlayerLevel()
  local checkLimit = curLv < studyCA.levelPrepare
  View.Group_StudyMap.Group_StudyInfo.Group_Prepare.Group_LvRequest.Group_RoleLv.Txt_Lv:SetText("LV" .. studyCA.levelPrepare)
  View.Group_StudyMap.Group_StudyInfo.Group_Prepare.Group_LvRequest.Group_RoleLv.Txt_Lv:SetColor(checkLimit and DataModel.txtLimitColor or DataModel.txtColor)
  curLv = PlayerData:GetHomeInfo().electric_lv + 1
  checkLimit = curLv < studyCA.powerPrepare
  View.Group_StudyMap.Group_StudyInfo.Group_Prepare.Group_LvRequest.Group_EleLv.Txt_Lv:SetText("LV" .. studyCA.powerPrepare)
  View.Group_StudyMap.Group_StudyInfo.Group_Prepare.Group_LvRequest.Group_EleLv.Txt_Lv:SetColor(checkLimit and DataModel.txtLimitColor or DataModel.txtColor)
  local homeCommon = require("Common/HomeCommon")
  local stationId = studyCA.cityPrepare[1].id
  local stationCA = PlayerData:GetFactoryData(stationId)
  curLv = homeCommon.GetRepLv(stationId)
  checkLimit = curLv < studyCA.cityPrepare[1].lv
  View.Group_StudyMap.Group_StudyInfo.Group_Prepare.Group_CityLv.Group_City.Group_txt.Txt_City:SetText(stationCA.name)
  View.Group_StudyMap.Group_StudyInfo.Group_Prepare.Group_CityLv.Group_City.Group_txt.Txt_Lv:SetText("LV" .. studyCA.cityPrepare[1].lv)
  View.Group_StudyMap.Group_StudyInfo.Group_Prepare.Group_CityLv.Group_City.Group_txt.Txt_Lv:SetColor(checkLimit and DataModel.txtLimitColor or DataModel.txtColor)
  DataModel.engLvInfo = studyCA.energyPrepare
  View.Group_StudyMap.Group_StudyInfo.Group_Prepare.Group_EngLv.StaticGrid_Type.grid.self:RefreshAllElement()
  DataModel.itemCost = studyCA.itemCost
  View.Group_StudyMap.Group_StudyInfo.Group_Prepare.Group_Cost.ScrollGrid_GoodsList.grid.self:SetDataCount(#DataModel.itemCost)
  View.Group_StudyMap.Group_StudyInfo.Group_Prepare.Group_Cost.ScrollGrid_GoodsList.grid.self:RefreshAllElement()
  local canStudy = DataModel.studyingId <= 0 and DataModel.CheckCanStudy(studyId)
  if canStudy then
    for _, v in ipairs(studyCA.itemPrepare) do
      if 0 >= PlayerData:GetGoodsById(v.id).num then
        canStudy = false
        break
      end
    end
  end
  local btnElement = View.Group_StudyMap.Group_StudyInfo.Btn_Accept
  btnElement.Group_Over.self:SetActive(isStudied)
  btnElement.Group_Accept.self:SetActive(not isStudied)
  btnElement.Group_Refuse.self:SetActive(not isStudied and not canStudy)
  btnElement:SetBtnInteractable(not isStudied and canStudy)
end

function Controller:ClickBtnAccept()
  if DataModel.selectTreeIdx > 0 and 0 < DataModel.selectNodeIdx then
    local studyInfo = DataModel.studyData[DataModel.selectTreeIdx].studyList[DataModel.selectNodeIdx]
    local studyId = studyInfo.id
    Net:SendProto("home.study", function(json)
      PlayerData:GetHomeInfo().studying = json.studying
      local useItem = {}
      for _, v in ipairs(studyInfo.itemCost) do
        useItem[v.id] = v.num
      end
      PlayerData:RefreshUseItems(useItem)
      DataModel.RefreshStudyingInfo()
      self:RefreshStudying()
      View.Group_StudyMap.Group_StudyInfo.Btn_Accept:SetBtnInteractable(false)
      View.Group_StudyMap.Group_StudyInfo.Group_Info.Group_Top.Group_Study.Group_off.self:SetActive(false)
      View.Group_StudyMap.Group_StudyInfo.Group_Info.Group_Top.Group_Study.Group_on.self:SetActive(true)
      View.Group_StudyMap.Group_StudyInfo.Btn_Accept.Group_Refuse.self:SetActive(true)
      View.Group_StudyMap.Group_StudyInfo.Group_Prepare.Group_Cost.ScrollGrid_GoodsList.grid.self:RefreshAllElement()
    end, studyId)
  end
end

function Controller:RefreshEngLvElement(element, elementIndex)
  local info = DataModel.engLvInfo[elementIndex]
  local serverInfo = PlayerData.ServerData.engines[tostring(info.id)]
  local coreCA = PlayerData:GetFactoryData(info.id)
  local checkLimit = serverInfo.lv < info.lv
  element.self:SetSprite(coreCA.coreIconPath)
  element.Txt_Level:SetText("LV" .. info.lv)
  element.Txt_Level:SetColor(checkLimit and DataModel.txtLimitColor or DataModel.txtColor)
end

function Controller:RefreshCostItemElement(element, elementIndex)
  local info = DataModel.itemCost[elementIndex]
  BtnItem:SetItem(element, {
    id = info.id
  })
  element.Btn_Item:SetClickParam(elementIndex)
  local ownNum = PlayerData:GetGoodsById(info.id).num
  element.Group_Num.Txt_Own:SetText(PlayerData:NumToFormatString(ownNum))
  element.Group_Num.Txt_need:SetText(PlayerData:NumToFormatString(info.num))
  element.Group_Num.Txt_Own:SetColor(ownNum < info.num and DataModel.txtLimitColor or DataModel.txtColor)
end

function Controller:ClickCostItemElement(str)
  local idx = tonumber(str)
  local itemId = DataModel.itemCost[idx].id
  CommonTips.OpenPreRewardDetailTips(itemId)
end

function Controller:RefreshTreeElement(element, elementIndex)
  local info = DataModel.studyData[elementIndex]
  element.Btn_.self:SetClickParam(elementIndex)
  element.Btn_.Group_NotSelect.self:SetActive(DataModel.selectTreeIdx ~= elementIndex)
  element.Btn_.Group_Select.self:SetActive(DataModel.selectTreeIdx == elementIndex)
  local showElement = DataModel.selectTreeIdx == elementIndex and element.Btn_.Group_Select or element.Btn_.Group_NotSelect
  showElement.Img_Icon:SetSprite(info.ca.studyPic)
  showElement.Txt_Name:SetText(info.ca.name)
  showElement.Txt_Num:SetText(info.studiedCount .. "/" .. #info.studyList)
end

function Controller:ClickTreeElement(str, force)
  local idx = tonumber(str)
  if DataModel.selectTreeIdx == idx and not force then
    return
  end
  self:CloseDetailPanel()
  DataModel.lastSelectTreeIdx = DataModel.selectTreeIdx
  DataModel.selectTreeIdx = idx
  local info = DataModel.studyData[idx]
  local sortedStudiedCount = 0
  for _, v in ipairs(info.studyList) do
    if 0 < PlayerData:GetGoodsById(v.reward[1].id).num then
      sortedStudiedCount = sortedStudiedCount + 1
    else
      break
    end
  end
  local Group_StudyPoint = View.Group_StudyMap.ScrollView_Map.Viewport.Content.Group_StudyPoint
  local treeIdx = math.floor(sortedStudiedCount / 4)
  local nodeIdx = sortedStudiedCount % 4
  for i = 0, treeIdx - 1 do
    local element = Group_StudyPoint.Group_Tree["Img_Tree_00" .. i]
    element.Img_TreeFill:SetFilledImgAmount(1)
  end
  local fileAmount = 1
  if nodeIdx == 0 then
    fileAmount = 0.184
  elseif nodeIdx == 1 then
    fileAmount = 0.402
  elseif nodeIdx == 2 then
    fileAmount = 0.59
  end
  Group_StudyPoint.Group_Tree["Img_Tree_00" .. treeIdx].Img_TreeFill:SetFilledImgAmount(fileAmount)
  for i = treeIdx + 1, 3 do
    local element = Group_StudyPoint.Group_Tree["Img_Tree_00" .. i]
    element.Img_TreeFill:SetFilledImgAmount(0)
  end
  View.Group_StudyMap.ScrollView_Map.Viewport.Content.self:SetAnchoredPositionX(0)
  Group_StudyPoint.StaticGrid_Point.grid.self:RefreshAllElement()
  if DataModel.lastSelectTreeIdx ~= DataModel.selectTreeIdx then
    local lastElement = View.Group_StudyMap.Group_StudyTree.ScrollGrid_List.grid.self:GetElementByIndex(DataModel.lastSelectTreeIdx - 1)
    if lastElement then
      self:RefreshTreeElement(lastElement, DataModel.lastSelectTreeIdx)
    end
  end
  local element = View.Group_StudyMap.Group_StudyTree.ScrollGrid_List.grid.self:GetElementByIndex(DataModel.selectTreeIdx - 1)
  if element then
    self:RefreshTreeElement(element, DataModel.selectTreeIdx)
  end
end

function Controller:RefreshNodeElement(element, elementIndex)
  local info = DataModel.studyData[DataModel.selectTreeIdx].studyList[elementIndex]
  element.Group_CarriageSkin.self:SetActive(info ~= nil)
  element.Group_Wait.self:SetActive(info == nil)
  element.Group_CarriageSkin.Img_Select:SetActive(elementIndex == DataModel.selectNodeIdx)
  if info then
    local isStudied = DataModel.cacheStudiedId[info.id] ~= nil
    local skinCA = PlayerData:GetFactoryData(info.showPic)
    element.Group_CarriageSkin.Img_mengban.Img_Skin:SetSprite(skinCA.skinDisplay)
    local checkUnlock = true
    for _, v in ipairs(info.itemPrepare) do
      if PlayerData:GetGoodsById(v.id).num <= 0 then
        checkUnlock = false
        break
      end
    end
    element.Group_Line.Img_:SetColor(isStudied and DataModel.lineColor or DataModel.CheckCanStudy(info.id) and checkUnlock and DataModel.lineLimitColor or DataModel.lineCantStudyColor)
    element.Group_CarriageSkin.Img_Shadow:SetActive(not isStudied and not checkUnlock)
    element.Group_CarriageSkin.Btn_Check:SetActive(false)
    element.Group_CarriageSkin.Btn_Check:SetClickParam(elementIndex)
    element.Group_CarriageSkin.Img_Bg.Txt_Name:SetText(info.name)
    element.Group_CarriageSkin.Btn_Button:SetClickParam(elementIndex)
  else
    element.Group_Line.Img_:SetColor(DataModel.lineCantStudyColor)
  end
end

function Controller:ClickNodeElement(str, force)
  local idx = tonumber(str)
  if (DataModel.selectNodeIdx == idx or idx > #DataModel.studyData[DataModel.selectTreeIdx].studyList) and not force then
    return
  end
  DataModel.lastSelectNodeIdx = DataModel.selectNodeIdx
  DataModel.selectNodeIdx = idx
  if DataModel.lastSelectNodeIdx ~= DataModel.selectNodeIdx then
    local lastElement = View.Group_StudyMap.ScrollView_Map.Viewport.Content.Group_StudyPoint.StaticGrid_Point.grid[DataModel.lastSelectNodeIdx]
    if lastElement then
      lastElement.Group_CarriageSkin.Img_Select:SetActive(false)
    end
  end
  local element = View.Group_StudyMap.ScrollView_Map.Viewport.Content.Group_StudyPoint.StaticGrid_Point.grid[idx]
  if element then
    element.Group_CarriageSkin.Img_Select:SetActive(true)
  end
  self:ShowDetailPanel(DataModel.studyData[DataModel.selectTreeIdx].studyList[idx].id)
end

function Controller:ClickNodeBtnCheck(str)
end

return Controller
