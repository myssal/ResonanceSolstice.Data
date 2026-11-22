local View = require("UIRevenueOverview/UIRevenueOverviewView")
local DataModel = {}
local huRunSelection
DataModel.MenuType = {
  InCome = 1,
  Rank = 2,
  HuRun = 3
}
DataModel.curMenuType = nil
DataModel.PanelType = {
  Income = 1,
  IncomeRatio = 2,
  ServerRank = 3,
  FriendRank = 4,
  HuRunServerRank = 5,
  HuRunFriendRank = 6
}
DataModel.curPanelType = nil
DataModel.revenueCfg = nil
DataModel.tabData = {}
DataModel.tabIndex = 1
DataModel.rankLevelTabIndex = 1
DataModel.tabElements = {}
DataModel.IncomeRecordKeyMap = {}
DataModel.incomeRecord = {}
DataModel.todayTotalIncome = 0
DataModel.ratioTotalIncome = 0
DataModel.ratioIncomeList = {}
DataModel.rankRatioTotalIncome = 0
DataModel.rankRatioIncomeList = {}
DataModel.friendRankList = {}
DataModel.friendSelfRankList = {}
DataModel.serverRankList = {}
DataModel.serverSelfRankList = {}
DataModel.huRunFriendRankList = {}
DataModel.huRunFriendSelfRankList = {}
DataModel.huRunSeverRankList = {}
DataModel.huRunSeverSelfRankList = {}
DataModel.huRunServeRankLevelCacheInfo = {}
DataModel.rankType = {}
DataModel.RankTab = {Server = 0, Friend = 1}
DataModel.rankBgList = {}
DataModel.defaultRankBg = ""
DataModel.rankRatioBgList = {}
DataModel.defaultRankRatioBg = ""
DataModel.rankElements = {}
DataModel.giveLiveC = nil

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.incomeRecord = data.incomeRecord
end

function DataModel.InitData()
  DataModel.tabData = {}
  local cfg = PlayerData:GetFactoryData(99900088, "ConfigFactory")
  DataModel.rankType = {}
  DataModel.serverRankList = {}
  DataModel.serverSelfRankList = {}
  DataModel.friendRankList = {}
  DataModel.friendSelfRankList = {}
  DataModel.IncomeRecordKeyMap = {}
  for i, v in ipairs(cfg.tabCategoryList) do
    if v.isShow then
      table.insert(DataModel.tabData, v)
      table.insert(DataModel.serverRankList, {})
      table.insert(DataModel.serverSelfRankList, {})
      table.insert(DataModel.friendRankList, {})
      table.insert(DataModel.friendSelfRankList, {})
      table.insert(DataModel.rankType, v.rank)
      local rankCA = PlayerData:GetFactoryData(v.rank, "RankFactory")
      DataModel.IncomeRecordKeyMap[v.rank] = rankCA.rankType
    end
  end
  DataModel.huRunFriendRankList = {}
  DataModel.huRunFriendSelfRankList = {}
  DataModel.huRunSeverRankList = {}
  DataModel.huRunSeverSelfRankList = {}
  DataModel.huRunServeRankLevelCacheInfo = {}
  huRunSelection = nil
  DataModel.rankBgList = {}
  for i, v in pairs(cfg.rankList) do
    if i <= 3 then
      table.insert(DataModel.rankBgList, v.bg)
      table.insert(DataModel.rankRatioBgList, v.ratio)
    end
  end
  DataModel.defaultRankBg = cfg.rankList[#cfg.rankList].bg
  DataModel.defaultRankRatioBg = cfg.rankList[#cfg.rankList].ratio
  DataModel.revenueCfg = cfg
  DataModel.tabIndex = 1
  local serverTime = DataModel.GetIncomeTodayTimeStamp()
  local key = os.date("!%Y-%m-%d", serverTime)
  local data = DataModel.incomeRecord[key] or {}
  local totalIncome = 0
  for i, v in pairs(data) do
    totalIncome = totalIncome + v
  end
  DataModel.todayTotalIncome = totalIncome
end

function DataModel.RefreshOnShow()
  View.Group_PickPanel.Group_Report.Btn_:SetSprite(GetResPath(88300095))
  View.Group_PickPanel.Group_Report.Img_Off:SetSprite(GetResPath(88300095))
  View.Group_PickPanel.Group_Rank.Btn_:SetSprite(GetResPath(88300092))
  View.Group_PickPanel.Group_Rank.Img_Off:SetSprite(GetResPath(88300092))
  View.Group_Report.Img_RevenueTitle:SetSprite(GetResPath(88300096))
  View.Group_Rank.Img_RankTitle:SetSprite(GetResPath(88300097))
  View.Group_PickPanel.Group_Hurun.Btn_:SetSprite(GetResPath(88300236))
  View.Group_PickPanel.Group_Hurun.Img_Off:SetSprite(GetResPath(88300236))
  View.Group_Money.Img_RankTitle:SetSprite(GetResPath(88300097))
  DataModel.tabElements = {}
  DataModel.curMenuType = DataModel.MenuType.InCome
  DataModel.curPanelType = DataModel.PanelType.Income
  View.Group_Report:SetActive(true)
  View.Group_Rank:SetActive(false)
  View.Group_Money:SetActive(false)
  DataModel.ShowIncomeTab()
  local serverTime = DataModel.GetIncomeTodayTimeStamp()
  View.Group_Report.Group_Date.Img_BGDate.Txt_:SetText(os.date("!%Y-%m-%d", serverTime))
  local totalIncome = DataModel.todayTotalIncome
  View.Group_Report.Group_Date.Group_Money.Txt_:SetText(DataModel.GetIncomeShow(totalIncome))
  DataModel.RefreshIncome()
  View.Group_CommonTopLeft.Btn_Help:SetActive(true)
  DataModel.RefreshRankRedPointTime()
  DataModel.RefreshRankRedPoint()
  View.Img_GiveLikeMask:SetActive(false)
  View.Group_Rank.Group_LVInterval:SetActive(false)
  DataModel.RefreshRightTab()
  DataModel.RefreshPickPanel()
  View.self:PlayAnimOnce("RevenueOverview")
end

function DataModel.RefreshRightTab()
  local curMenuType = DataModel.curMenuType
  local showRankOrIncomeTab = curMenuType == DataModel.MenuType.Rank or curMenuType == DataModel.MenuType.InCome
  local showTigerGoldTab = curMenuType == DataModel.MenuType.HuRun
  View.Group_Tab:SetActive(showRankOrIncomeTab)
  View.Group_MoneyTab:SetActive(showTigerGoldTab)
  if showRankOrIncomeTab then
    local count = #DataModel.tabData
    View.Group_Tab.ScrollGrid_Tab.grid.self:SetDataCount(count)
    View.Group_Tab.ScrollGrid_Tab.grid.self:RefreshAllElement()
  end
end

function DataModel.RefreshPickPanel()
  local curMenuType = DataModel.curMenuType
  local showIncome = curMenuType == DataModel.MenuType.InCome
  local showRank = curMenuType == DataModel.MenuType.Rank
  local showHuRun = curMenuType == DataModel.MenuType.HuRun
  if showIncome then
    View.Group_PickPanel.Group_Report.transform:SetAsLastSibling()
  elseif showRank then
    View.Group_PickPanel.Group_Rank.transform:SetAsLastSibling()
  elseif showHuRun then
    View.Group_PickPanel.Group_Hurun.transform:SetAsLastSibling()
  end
  View.Group_PickPanel.Group_Report.Img_Off:SetActive(not showIncome)
  View.Group_PickPanel.Group_Rank.Img_Off:SetActive(not showRank)
  View.Group_PickPanel.Group_Hurun.Img_Off:SetActive(not showHuRun)
end

function DataModel.ClickIncomeMenu()
  huRunSelection = nil
  if DataModel.curMenuType == DataModel.MenuType.InCome then
    return
  end
  DataModel.curMenuType = DataModel.MenuType.InCome
  local defaultPanelType = DataModel.PanelType.Income
  DataModel.curPanelType = defaultPanelType
  View.Group_Report:SetActive(true)
  View.Group_Rank:SetActive(false)
  View.Group_Money:SetActive(false)
  View.Group_Tab:SetActive(true)
  View.Group_Report.Group_Pick.Btn_Report.Group_On:SetActive(true)
  View.Group_Report.Group_Pick.Btn_Report.Group_off:SetActive(false)
  View.Group_Report.Group_Pick.Btn_Ratio.Group_On:SetActive(false)
  View.Group_Report.Group_Pick.Btn_Ratio.Group_off:SetActive(true)
  View.Group_Report.Group_RecentDays:SetActive(true)
  View.Group_Report.Group_Ratio:SetActive(false)
  local serverTime = DataModel.GetIncomeTodayTimeStamp()
  View.Group_Report.Group_Date.Img_BGDate.Txt_:SetText(os.date("!%Y-%m-%d", serverTime))
  local totalIncome = DataModel.todayTotalIncome
  View.Group_Report.Group_Date.Group_Money.Txt_:SetText(DataModel.GetIncomeShow(totalIncome))
  DataModel.RefreshIncome()
  DataModel.RefreshPickPanel()
  DataModel.RefreshRightTab()
  View.self:PlayAnimOnce("Group_RecentDays")
end

function DataModel.ShowIncomeTab()
  View.Group_Report.Group_Pick.Btn_Report.Group_On:SetActive(true)
  View.Group_Report.Group_Pick.Btn_Report.Group_off:SetActive(false)
  View.Group_Report.Group_Pick.Btn_Ratio.Group_On:SetActive(false)
  View.Group_Report.Group_Pick.Btn_Ratio.Group_off:SetActive(true)
  View.Group_Report.Group_RecentDays:SetActive(true)
  View.Group_Report.Group_Ratio:SetActive(false)
  View.Group_Tab:SetActive(true)
  DataModel.RefreshIncome()
end

function DataModel.RefreshIncome()
  local tabIndex = DataModel.tabIndex
  local tabCfg = DataModel.tabData[tonumber(tabIndex)]
  local dataKey = DataModel.IncomeRecordKeyMap[tabCfg.rank]
  local maxIncome = 0
  local recordIncomeList = {}
  local serverTime = DataModel.GetIncomeTodayTimeStamp()
  local key = os.date("!%Y-%m-%d", serverTime)
  local data = DataModel.incomeRecord[key] or {}
  local income = 0
  if tabCfg.rank == 84300009 then
    for i, v in pairs(data) do
      income = income + v
    end
  elseif dataKey and data[dataKey] then
    income = data[dataKey]
  end
  table.insert(recordIncomeList, income)
  if maxIncome < income then
    maxIncome = income
  end
  local time = serverTime - 86400
  local month = os.date("!%m", time)
  local day = os.date("!%d", time)
  View.Group_Report.Group_RecentDays.Group_Day4Bar.Txt_Date:SetText(tonumber(month) .. "/" .. tonumber(day))
  key = os.date("!%Y-%m-%d", time)
  data = DataModel.incomeRecord[key] or {}
  income = 0
  if tabCfg.rank == 84300009 then
    for i, v in pairs(data) do
      income = income + v
    end
  elseif dataKey and data[dataKey] then
    income = data[dataKey]
  end
  table.insert(recordIncomeList, income)
  if maxIncome < income then
    maxIncome = income
  end
  time = serverTime - 172800
  month = os.date("!%m", time)
  day = os.date("!%d", time)
  View.Group_Report.Group_RecentDays.Group_Day3Bar.Txt_Date:SetText(tonumber(month) .. "/" .. tonumber(day))
  key = os.date("!%Y-%m-%d", time)
  data = DataModel.incomeRecord[key] or {}
  income = 0
  if tabCfg.rank == 84300009 then
    for i, v in pairs(data) do
      income = income + v
    end
  elseif dataKey and data[dataKey] then
    income = data[dataKey]
  end
  table.insert(recordIncomeList, income)
  if maxIncome < income then
    maxIncome = income
  end
  time = serverTime - 259200
  month = os.date("!%m", time)
  day = os.date("!%d", time)
  View.Group_Report.Group_RecentDays.Group_Day2Bar.Txt_Date:SetText(tonumber(month) .. "/" .. tonumber(day))
  key = os.date("!%Y-%m-%d", time)
  data = DataModel.incomeRecord[key] or {}
  income = 0
  if tabCfg.rank == 84300009 then
    for i, v in pairs(data) do
      income = income + v
    end
  elseif dataKey and data[dataKey] then
    income = data[dataKey]
  end
  table.insert(recordIncomeList, income)
  if maxIncome < income then
    maxIncome = income
  end
  time = serverTime - 345600
  month = os.date("!%m", time)
  day = os.date("!%d", time)
  View.Group_Report.Group_RecentDays.Group_Day1Bar.Txt_Date:SetText(tonumber(month) .. "/" .. tonumber(day))
  key = os.date("!%Y-%m-%d", time)
  data = DataModel.incomeRecord[key] or {}
  income = 0
  if tabCfg.rank == 84300009 then
    for i, v in pairs(data) do
      income = income + v
    end
  elseif dataKey and data[dataKey] then
    income = data[dataKey]
  end
  table.insert(recordIncomeList, income)
  if maxIncome < income then
    maxIncome = income
  end
  income = recordIncomeList[1]
  View.Group_Report.Group_RecentDays.Group_TodayBar.Img_Bar.Img_Num.Txt_:SetText(DataModel.GetIncomeBarShow(income))
  local height = 0 < income and maxIncome ~= 0 and income / maxIncome * 334 or 0
  View.Group_Report.Group_RecentDays.Group_TodayBar.Img_Bar:SetHeight(height)
  income = recordIncomeList[2]
  View.Group_Report.Group_RecentDays.Group_Day4Bar.Img_Bar.Img_Num.Txt_:SetText(DataModel.GetIncomeBarShow(income))
  height = 0 < income and maxIncome ~= 0 and income / maxIncome * 334 or 0
  View.Group_Report.Group_RecentDays.Group_Day4Bar.Img_Bar:SetHeight(height)
  income = recordIncomeList[3]
  View.Group_Report.Group_RecentDays.Group_Day3Bar.Img_Bar.Img_Num.Txt_:SetText(DataModel.GetIncomeBarShow(income))
  height = 0 < income and maxIncome ~= 0 and income / maxIncome * 334 or 0
  View.Group_Report.Group_RecentDays.Group_Day3Bar.Img_Bar:SetHeight(height)
  income = recordIncomeList[4]
  View.Group_Report.Group_RecentDays.Group_Day2Bar.Img_Bar.Img_Num.Txt_:SetText(DataModel.GetIncomeBarShow(income))
  height = 0 < income and maxIncome ~= 0 and income / maxIncome * 334 or 0
  View.Group_Report.Group_RecentDays.Group_Day2Bar.Img_Bar:SetHeight(height)
  income = recordIncomeList[5]
  View.Group_Report.Group_RecentDays.Group_Day1Bar.Img_Bar.Img_Num.Txt_:SetText(DataModel.GetIncomeBarShow(income))
  height = 0 < income and maxIncome ~= 0 and income / maxIncome * 334 or 0
  View.Group_Report.Group_RecentDays.Group_Day1Bar.Img_Bar:SetHeight(height)
end

function DataModel.ShowIncomeRatio()
  View.Group_Report.Group_Pick.Btn_Report.Group_On:SetActive(false)
  View.Group_Report.Group_Pick.Btn_Report.Group_off:SetActive(true)
  View.Group_Report.Group_Pick.Btn_Ratio.Group_On:SetActive(true)
  View.Group_Report.Group_Pick.Btn_Ratio.Group_off:SetActive(false)
  View.Group_Report.Group_RecentDays:SetActive(false)
  View.Group_Report.Group_Ratio:SetActive(true)
  View.Group_Tab:SetActive(false)
  DataModel.RefreshIncomeRatio()
end

function DataModel.RefreshIncomeRatio()
  local incomes = {}
  local ratioIncomeList = {}
  local serverTime = DataModel.GetIncomeTodayTimeStamp()
  local key = os.date("!%Y-%m-%d", serverTime)
  local data = DataModel.incomeRecord[key] or {}
  local totalIncome = 0
  for i, v in pairs(DataModel.tabData) do
    if v.ratio ~= "" then
      local incomeKey = DataModel.IncomeRecordKeyMap[v.rank]
      local income = 0
      if incomeKey and data[incomeKey] and 0 < data[incomeKey] then
        income = data[incomeKey]
      end
      incomes[v.ratio] = income
      table.insert(ratioIncomeList, {
        income = income,
        name = v.name,
        ratio = v.ratio,
        labelBg = v.label
      })
      totalIncome = totalIncome + income
    end
  end
  table.sort(ratioIncomeList, function(a, b)
    return a.income > b.income
  end)
  DataModel.ratioIncomeList = ratioIncomeList
  DataModel.ratioTotalIncome = totalIncome
  View.Group_Report.Group_Ratio.Group_Label.ScrollGrid_.grid.self:SetDataCount(#ratioIncomeList)
  View.Group_Report.Group_Ratio.Group_Label.ScrollGrid_.grid.self:RefreshAllElement()
  local lastIncome = 0
  for i, v in ipairs(ratioIncomeList) do
    local income = incomes[v.ratio] or 0
    if 0 < income then
      income = income + lastIncome
      lastIncome = income
    end
    local ctr = View.Group_Report.Group_Ratio.Group_Circle[v.ratio]
    if ctr then
      local ratio = totalIncome == 0 and 0 or income / totalIncome
      ctr:SetFilledImgAmount(ratio)
      ctr.transform:SetAsFirstSibling()
    end
  end
end

function DataModel.ClickRankMenu()
  huRunSelection = nil
  if DataModel.curMenuType == DataModel.MenuType.Rank then
    return
  end
  DataModel.curMenuType = DataModel.MenuType.Rank
  local defaultPanelType = DataModel.PanelType.FriendRank
  DataModel.curPanelType = defaultPanelType
  local tabIndex = DataModel.tabIndex
  
  local function callBack()
    View.Group_Report:SetActive(false)
    View.Group_Rank:SetActive(true)
    View.Group_Money:SetActive(false)
    DataModel.RefreshRightTab()
    DataModel.ShowFriendRank()
    local serverTime = DataModel.GetRankTodayTimeStamp()
    local key = os.date("!%Y-%m-%d", serverTime)
    View.Group_Rank.Group_Date.Img_BGDate.Txt_:SetText(key)
    local data = DataModel.incomeRecord[key] or {}
    local totalIncome = 0
    for i, v in pairs(data) do
      totalIncome = totalIncome + v
    end
    View.Group_Rank.Group_Date.Group_Money.Txt_:SetText(DataModel.GetIncomeShow(totalIncome))
    DataModel.ClickResetRedPointTime()
    View.Img_RedDot:SetActive(false)
    DataModel.RefreshRankGiveLike()
    DataModel.RefreshPickPanel()
    View.self:PlayAnimOnce("RevenueOverview_Group_Rank")
  end
  
  local rankId = DataModel.rankType[tonumber(tabIndex)]
  local rankLevelTabIndex = DataModel.GetSelfLevelTabIndex(rankId)
  DataModel.rankLevelTabIndex = rankLevelTabIndex
  DataModel.GetRankData(tabIndex, rankLevelTabIndex, DataModel.RankTab.Friend, callBack)
  View.Group_Rank.Group_LVInterval:SetActive(false)
end

function DataModel.ClickServerRank()
  local curPanelType = DataModel.curPanelType
  if curPanelType == DataModel.PanelType.ServerRank then
    return
  end
  DataModel.curPanelType = DataModel.PanelType.ServerRank
  local tabIndex = DataModel.tabIndex
  
  local function callBack()
    DataModel.ShowServerRank()
  end
  
  local rankId = DataModel.rankType[tonumber(tabIndex)]
  local rankLevelTabIndex = DataModel.GetSelfLevelTabIndex(rankId)
  DataModel.rankLevelTabIndex = rankLevelTabIndex
  DataModel.GetRankData(tabIndex, rankLevelTabIndex, DataModel.RankTab.Server, callBack)
end

function DataModel.ShowServerRank()
  View.Group_Rank.Group_Pick.Btn_All.Group_On:SetActive(true)
  View.Group_Rank.Group_Pick.Btn_All.Group_off:SetActive(false)
  View.Group_Rank.Group_Pick.Btn_Friend.Group_On:SetActive(false)
  View.Group_Rank.Group_Pick.Btn_Friend.Group_off:SetActive(true)
  DataModel.RefreshServerRank()
end

function DataModel.RefreshServerRank()
  local tabIndex = DataModel.tabIndex
  local rankLevelTabIndex = DataModel.rankLevelTabIndex
  local rankId = DataModel.rankType[tonumber(tabIndex)]
  local rankCA = PlayerData:GetFactoryData(rankId, "RankFactory")
  View.Group_Rank.Group_Title.Txt_Title:SetText(rankCA.name)
  local levelTween = DataModel.GetLevelTween(rankId, rankLevelTabIndex)
  View.Group_Rank.Img_Lv.Txt_:SetText("LV." .. levelTween)
  local rankList = DataModel.serverRankList[tonumber(tabIndex)][rankLevelTabIndex] or {}
  local rankCount = table.count(rankList)
  if rankCount > rankCA.peopleNum then
    rankCount = rankCA.peopleNum
  end
  View.Group_Rank.Group_List:SetActive(0 < rankCount)
  View.Group_Rank.Group_Empty:SetActive(rankCount == 0)
  if 0 < rankCount then
    DataModel.rankElements = {}
    View.Group_Rank.Group_List.ScrollGrid_List.grid.self:SetDataCount(rankCount)
    View.Group_Rank.Group_List.ScrollGrid_List.grid.self:RefreshAllElement()
  end
  DataModel.ShowSelfRank(DataModel.RankTab.Server)
end

function DataModel.ClickFriendRank()
  local curPanelType = DataModel.curPanelType
  if curPanelType == DataModel.PanelType.FriendRank then
    return
  end
  DataModel.curPanelType = DataModel.PanelType.FriendRank
  local tabIndex = DataModel.tabIndex
  
  local function callBack()
    DataModel.ShowFriendRank()
  end
  
  local rankId = DataModel.rankType[tonumber(tabIndex)]
  local rankLevelTabIndex = DataModel.GetSelfLevelTabIndex(rankId)
  DataModel.rankLevelTabIndex = rankLevelTabIndex
  DataModel.GetRankData(tabIndex, rankLevelTabIndex, DataModel.RankTab.Friend, callBack)
end

function DataModel.ShowFriendRank()
  View.Group_Rank.Group_Pick.Btn_All.Group_On:SetActive(false)
  View.Group_Rank.Group_Pick.Btn_All.Group_off:SetActive(true)
  View.Group_Rank.Group_Pick.Btn_Friend.Group_On:SetActive(true)
  View.Group_Rank.Group_Pick.Btn_Friend.Group_off:SetActive(false)
  DataModel.RefreshFriendRank()
end

function DataModel.RefreshFriendRank()
  local tabIndex = DataModel.tabIndex
  local rankLevelTabIndex = DataModel.rankLevelTabIndex
  local rankId = DataModel.rankType[tonumber(tabIndex)]
  local rankCA = PlayerData:GetFactoryData(rankId, "RankFactory")
  View.Group_Rank.Group_Title.Txt_Title:SetText(rankCA.name)
  local levelTween = DataModel.GetLevelTween(rankId, rankLevelTabIndex)
  View.Group_Rank.Img_Lv.Txt_:SetText("LV." .. levelTween)
  local rankList = DataModel.friendRankList[tonumber(tabIndex)][rankLevelTabIndex] or {}
  local rankCount = table.count(rankList)
  View.Group_Rank.Group_List:SetActive(0 < rankCount)
  View.Group_Rank.Group_Empty:SetActive(rankCount == 0)
  if rankCount > rankCA.peopleNum then
    rankCount = rankCA.peopleNum
  end
  if 0 < rankCount then
    DataModel.rankElements = {}
    View.Group_Rank.Group_List.ScrollGrid_List.grid.self:SetDataCount(rankCount)
    View.Group_Rank.Group_List.ScrollGrid_List.grid.self:RefreshAllElement()
  end
  DataModel.ShowSelfRank(DataModel.RankTab.Friend)
end

function DataModel.ShowSelfRank(rankTab)
  local tabIndex = DataModel.tabIndex
  local rankId = DataModel.rankType[tonumber(tabIndex)]
  local rankCA = PlayerData:GetFactoryData(rankId, "RankFactory")
  local rankData
  if rankTab == DataModel.RankTab.Server then
    rankData = DataModel.serverSelfRankList[tabIndex][DataModel.rankLevelTabIndex]
  elseif rankTab == DataModel.RankTab.Friend then
    rankData = DataModel.friendSelfRankList[tabIndex][DataModel.rankLevelTabIndex]
  end
  local userInfo = PlayerData:GetUserInfo()
  local rank = rankData and rankData.rank
  if rank then
    local bgPath = DataModel.rankBgList[rank] or DataModel.defaultRankBg
    View.Group_Rank.Group_Oneself.Img_BG:SetSprite(bgPath)
    View.Group_Rank.Group_Oneself.Txt_Order:SetActive(rank > #DataModel.rankBgList)
    local rankTxt = tostring(rank)
    if rank >= rankCA.rankNumMax then
      rankTxt = string.format(GetText(80601252), rankCA.rankNumMax)
    end
    View.Group_Rank.Group_Oneself.Txt_Order:SetText(rankTxt)
    View.Group_Rank.Group_Oneself.Group_Content.Txt_Num:SetText(math.floor(rankData.val))
  else
    View.Group_Rank.Group_Oneself.Txt_Order:SetActive(true)
    View.Group_Rank.Group_Oneself.Img_BG:SetSprite(DataModel.defaultRankBg)
    View.Group_Rank.Group_Oneself.Txt_Order:SetText(GetText(80601253))
    View.Group_Rank.Group_Oneself.Group_Content.Txt_Num:SetText(0)
  end
  View.Group_Rank.Group_Oneself.Group_NameGrade.Group_Grade.Txt_Grade:SetText(userInfo.lv)
  local headPath, photoFactory = DataModel.GetHeadPath(userInfo.avatar, userInfo.gender)
  if headPath then
    View.Group_Rank.Group_Oneself.Btn_ProfilePhoto.Img_Head:SetSprite(headPath)
    CommonTips:SetPlayerHeadShader(View.Group_Rank.Group_Oneself.Btn_ProfilePhoto.Img_spAdd, photoFactory)
  end
  View.Group_Rank.Group_Oneself.Group_NameGrade.Txt_Name:SetText(userInfo.role_name)
  View.Group_Rank.Group_Oneself.Group_Likes:SetActive(false)
  View.Group_Rank.Group_Oneself.Img_LikesNum.Txt_:SetText(userInfo.being_like_count)
end

function DataModel.GetRankData(tabIndex, rankLevelTabIndex, rankTab, callBack)
  if rankTab == DataModel.RankTab.Friend and DataModel.friendRankList[tabIndex][rankLevelTabIndex] then
    callBack()
    return
  elseif rankTab == DataModel.RankTab.Server and DataModel.serverRankList[tabIndex][rankLevelTabIndex] then
    callBack()
    return
  end
  local rankId = DataModel.rankType[tabIndex]
  local rankCA = PlayerData:GetFactoryData(rankId, "RankFactory")
  local levelTween = DataModel.GetLevelTween(rankId, rankLevelTabIndex)
  Net:SendProto("main.rank", function(json)
    if rankTab == DataModel.RankTab.Friend then
      DataModel.friendRankList[tabIndex][rankLevelTabIndex] = json.rank_list
      local timeKey = os.date("!%Y-%m-%d", DataModel.GetRankTodayTimeStamp())
      local key = rankCA.rankType .. ":" .. rankCA.timeType .. ":" .. levelTween .. ":" .. timeKey
      DataModel.friendSelfRankList[tabIndex][rankLevelTabIndex] = json.my_rank and json.my_rank[key]
    elseif rankTab == DataModel.RankTab.Server then
      DataModel.serverRankList[tabIndex][rankLevelTabIndex] = json.rank_list
      DataModel.serverSelfRankList[tabIndex][rankLevelTabIndex] = json.my_rank
    end
    if callBack then
      callBack()
    end
  end, rankCA.rankType, rankCA.timeType, levelTween, "", rankCA.peopleNum, rankTab)
end

local function SetHuRunListState(loading, hasRows)
  local money = View.Group_Money
  money.Group_List:SetActive(hasRows)
  money.Group_Oneself:SetActive(not loading)
  money.Group_Empty:SetActive(not hasRows)
  money.Group_Empty.Img_:SetActive(not loading)
  money.Group_Empty.Txt_:SetText(GetText(loading and 80609865 or 80606020))
end

local function ShowHuRunRankTab(panelType)
  if panelType == DataModel.PanelType.HuRunServerRank then
    DataModel.ShowHuRunSeverRank()
  else
    DataModel.ShowHuRunFriendRank()
  end
end

local function RefreshHuRunRank(panelType)
  ShowHuRunRankTab(panelType)
  if panelType == DataModel.PanelType.HuRunServerRank then
    DataModel.RefreshHuRunServerRank(true)
  else
    DataModel.RefreshHuRunFriendRank()
  end
end

local function SelectHuRunRank(panelType, rankLevelTabIndex, showMenu)
  if not rankLevelTabIndex then
    return
  end
  local selection = {panelType = panelType, rankLevelTabIndex = rankLevelTabIndex}
  huRunSelection = selection
  local isServerRank = panelType == DataModel.PanelType.HuRunServerRank
  local rankLists = isServerRank and DataModel.huRunSeverRankList or DataModel.huRunFriendRankList
  local loading = DataModel.curMenuType == DataModel.MenuType.HuRun and not rankLists[rankLevelTabIndex]
  if loading then
    ShowHuRunRankTab(panelType)
    local levelTween = DataModel.GetLevelTween(84300033, rankLevelTabIndex)
    View.Group_Money.Img_Lv.Txt_:SetText("LV." .. levelTween)
    SetHuRunListState(true, false)
  end
  
  local function callBack()
    if huRunSelection ~= selection or not UIManager:IsPanelOpened("UI/RevenueOverview/RevenueOverview") then
      return
    end
    huRunSelection = nil
    DataModel.curMenuType = DataModel.MenuType.HuRun
    DataModel.curPanelType = panelType
    DataModel.rankLevelTabIndex = rankLevelTabIndex
    if showMenu then
      showMenu()
    end
    RefreshHuRunRank(panelType)
  end
  
  local function failCb()
    if huRunSelection ~= selection then
      return
    end
    huRunSelection = nil
    if loading and UIManager:IsPanelOpened("UI/RevenueOverview/RevenueOverview") then
      RefreshHuRunRank(DataModel.curPanelType)
    end
  end
  
  if isServerRank then
    DataModel.GetHuRunServerRankData(rankLevelTabIndex, callBack, failCb)
  else
    DataModel.GetHuRunFriendRankData(rankLevelTabIndex, callBack, failCb)
  end
end

function DataModel.GetHuRunSelectedLevelIndex()
  return huRunSelection and huRunSelection.rankLevelTabIndex or DataModel.rankLevelTabIndex
end

function DataModel.ClickHuRunRankLevel(rankLevelTabIndex)
  local panelType = huRunSelection and huRunSelection.panelType or DataModel.curPanelType
  if panelType == DataModel.PanelType.HuRunServerRank or panelType == DataModel.PanelType.HuRunFriendRank then
    SelectHuRunRank(panelType, rankLevelTabIndex)
  end
end

function DataModel.ClickHuRunMenu()
  if DataModel.curMenuType == DataModel.MenuType.HuRun then
    return
  end
  
  local function showMenu()
    View.Group_Report:SetActive(false)
    View.Group_Rank:SetActive(false)
    View.Group_Money:SetActive(true)
    local serverTime = DataModel.GetRankTodayTimeStamp()
    local key = os.date("!%Y-%m-%d", serverTime)
    View.Group_Money.Group_Date.Img_BGDate.Txt_:SetText(key)
    local data = DataModel.incomeRecord[key] or {}
    local totalIncome = 0
    for i, v in pairs(data) do
      totalIncome = totalIncome + v
    end
    View.Group_Money.Group_Date.Group_Money.Txt_:SetText(DataModel.GetIncomeShow(totalIncome))
    DataModel.RefreshPickPanel()
    DataModel.RefreshRightTab()
    View.self:PlayAnimOnce("Money")
  end
  
  local rankLevelTabIndex = DataModel.GetSelfLevelTabIndex(84300033)
  SelectHuRunRank(DataModel.PanelType.HuRunFriendRank, rankLevelTabIndex, showMenu)
end

function DataModel.ClickHuRunFriendRank()
  if DataModel.curPanelType == DataModel.PanelType.HuRunFriendRank then
    if huRunSelection and huRunSelection.panelType ~= DataModel.curPanelType then
      SelectHuRunRank(DataModel.curPanelType, DataModel.rankLevelTabIndex)
    end
    return
  end
  local rankLevelTabIndex = DataModel.GetSelfLevelTabIndex(84300033)
  SelectHuRunRank(DataModel.PanelType.HuRunFriendRank, rankLevelTabIndex)
end

function DataModel.ShowHuRunFriendRank()
  View.Group_Money.Group_Pick.Btn_Friend.Group_On:SetActive(true)
  View.Group_Money.Group_Pick.Btn_Friend.Group_off:SetActive(false)
  View.Group_Money.Group_Pick.Btn_All.Group_On:SetActive(false)
  View.Group_Money.Group_Pick.Btn_All.Group_off:SetActive(true)
  View.Group_Money.Group_LVInterval:SetActive(false)
end

function DataModel.RefreshHuRunFriendRank()
  local rankLevelTabIndex = DataModel.rankLevelTabIndex
  local rankId = 84300033
  local rankCA = PlayerData:GetFactoryData(rankId, "RankFactory")
  View.Group_Money.Group_Title.Txt_Title:SetText(rankCA.name)
  local levelTween = DataModel.GetLevelTween(rankId, rankLevelTabIndex)
  View.Group_Money.Img_Lv.Txt_:SetText("LV." .. levelTween)
  local rankList = DataModel.huRunFriendRankList[rankLevelTabIndex] or {}
  local rankCount = math.min(#rankList, rankCA.peopleNum)
  SetHuRunListState(false, 0 < rankCount)
  local grid = View.Group_Money.Group_List.ScrollGrid_List.grid.self
  grid:SetDataCount(rankCount)
  grid:MoveToTop()
  grid:RefreshAllElement()
  DataModel.ShowHuRunSelfRank(DataModel.RankTab.Friend)
end

function DataModel.ClickHuRunServerRank()
  if DataModel.curPanelType == DataModel.PanelType.HuRunServerRank then
    if huRunSelection and huRunSelection.panelType ~= DataModel.curPanelType then
      SelectHuRunRank(DataModel.curPanelType, DataModel.rankLevelTabIndex)
    end
    return
  end
  local rankLevelTabIndex = DataModel.GetSelfLevelTabIndex(84300033)
  SelectHuRunRank(DataModel.PanelType.HuRunServerRank, rankLevelTabIndex)
end

function DataModel.ShowHuRunSeverRank()
  View.Group_Money.Group_Pick.Btn_Friend.Group_On:SetActive(false)
  View.Group_Money.Group_Pick.Btn_Friend.Group_off:SetActive(true)
  View.Group_Money.Group_Pick.Btn_All.Group_On:SetActive(true)
  View.Group_Money.Group_Pick.Btn_All.Group_off:SetActive(false)
  View.Group_Money.Group_LVInterval:SetActive(false)
end

function DataModel.RefreshHuRunServerRank(moveToTop)
  local rankLevelTabIndex = DataModel.rankLevelTabIndex
  local rankId = 84300033
  local rankCA = PlayerData:GetFactoryData(rankId, "RankFactory")
  View.Group_Money.Group_Title.Txt_Title:SetText(rankCA.name)
  local levelTween = DataModel.GetLevelTween(rankId, rankLevelTabIndex)
  View.Group_Money.Img_Lv.Txt_:SetText("LV." .. levelTween)
  local rankList = DataModel.huRunSeverRankList[rankLevelTabIndex] or {}
  local rankCount = #rankList
  local showCount = rankCount
  local cacheInfo = DataModel.huRunServeRankLevelCacheInfo[rankLevelTabIndex]
  if cacheInfo and cacheInfo.has_more then
    local totalMembers = cacheInfo.total_members or rankCount + 5
    showCount = rankCount + math.min(5, math.max(0, totalMembers - rankCount))
  end
  SetHuRunListState(false, 0 < showCount)
  local grid = View.Group_Money.Group_List.ScrollGrid_List.grid.self
  grid:SetDataCount(showCount)
  if moveToTop then
    grid:MoveToTop()
  end
  grid:RefreshAllElement()
  DataModel.ShowHuRunSelfRank(DataModel.RankTab.Server)
end

function DataModel.ShowHuRunSelfRank(rankTab)
  local rankId = 84300033
  local rankCA = PlayerData:GetFactoryData(rankId, "RankFactory")
  local rankData
  local rankLevelTabIndex = DataModel.rankLevelTabIndex
  if rankTab == DataModel.RankTab.Server then
    rankData = DataModel.huRunSeverSelfRankList[rankLevelTabIndex]
  elseif rankTab == DataModel.RankTab.Friend then
    rankData = DataModel.huRunFriendSelfRankList[rankLevelTabIndex]
  end
  local userInfo = PlayerData:GetUserInfo()
  local rank = rankData and rankData.rank
  if rank then
    local bgPath = DataModel.rankBgList[rank] or DataModel.defaultRankBg
    View.Group_Money.Group_Oneself.Img_BG:SetSprite(bgPath)
    View.Group_Money.Group_Oneself.Txt_Order:SetActive(rank > #DataModel.rankBgList)
    local rankTxt = tostring(rank)
    if rank >= rankCA.rankNumMax then
      rankTxt = string.format(GetText(80601252), rankCA.rankNumMax)
    end
    View.Group_Money.Group_Oneself.Txt_Order:SetText(rankTxt)
    View.Group_Money.Group_Oneself.Group_Content.Txt_Num:SetText(math.floor(rankData.val))
  else
    View.Group_Money.Group_Oneself.Txt_Order:SetActive(true)
    View.Group_Money.Group_Oneself.Img_BG:SetSprite(DataModel.defaultRankBg)
    View.Group_Money.Group_Oneself.Txt_Order:SetText(GetText(80601253))
    View.Group_Money.Group_Oneself.Group_Content.Txt_Num:SetText(0)
  end
  View.Group_Money.Group_Oneself.Group_NameGrade.Group_Grade.Txt_Grade:SetText(userInfo.lv)
  local headPath, photoFactory = DataModel.GetHeadPath(userInfo.avatar, userInfo.gender)
  if headPath then
    View.Group_Money.Group_Oneself.Btn_ProfilePhoto.Img_Head:SetSprite(headPath)
    CommonTips:SetPlayerHeadShader(View.Group_Money.Group_Oneself.Btn_ProfilePhoto.Img_spAdd, photoFactory)
  end
  View.Group_Money.Group_Oneself.Group_NameGrade.Txt_Name:SetText(userInfo.role_name)
end

function DataModel.GetHuRunServerRankData(rankLevelTabIndex, callBack, failCb)
  local rankLists = DataModel.huRunSeverRankList
  if rankLists[rankLevelTabIndex] then
    callBack()
    return
  end
  local rankId = 84300033
  local rankCA = PlayerData:GetFactoryData(84300033, "RankFactory")
  local levelTween = DataModel.GetLevelTween(rankId, rankLevelTabIndex)
  Net:SendProto("main.roll_rank", function(json)
    if rankLists ~= DataModel.huRunSeverRankList then
      return
    end
    if not rankLists[rankLevelTabIndex] then
      rankLists[rankLevelTabIndex] = json.rank_list or {}
      DataModel.huRunSeverSelfRankList[rankLevelTabIndex] = json.my_rank
      DataModel.RefreshHuRunServerRankCacheInfo(rankLevelTabIndex, json)
    end
    if callBack then
      callBack()
    end
  end, rankCA.rankType, rankCA.timeType, levelTween, rankCA.peopleNum, nil, nil, nil, nil, nil, failCb)
end

function DataModel.RollGetHuRunServerRankData(rankLevelTabIndex)
  if huRunSelection then
    return
  end
  local cacheInfo = DataModel.huRunServeRankLevelCacheInfo[rankLevelTabIndex]
  local rankList = DataModel.huRunSeverRankList[rankLevelTabIndex]
  if not (rankList and cacheInfo and cacheInfo.has_more) or cacheInfo.loading then
    return
  end
  local rankId = 84300033
  local rankCA = PlayerData:GetFactoryData(rankId, "RankFactory")
  local levelTween = DataModel.GetLevelTween(rankId, rankLevelTabIndex)
  cacheInfo.loading = true
  Net:SendProto("main.roll_rank", function(json)
    if DataModel.huRunServeRankLevelCacheInfo[rankLevelTabIndex] ~= cacheInfo then
      return
    end
    local rows = json.rank_list or {}
    for _, row in ipairs(rows) do
      table.insert(rankList, row)
    end
    DataModel.RefreshHuRunServerRankCacheInfo(rankLevelTabIndex, json)
    if not huRunSelection and DataModel.curPanelType == DataModel.PanelType.HuRunServerRank and DataModel.rankLevelTabIndex == rankLevelTabIndex and UIManager:IsPanelOpened("UI/RevenueOverview/RevenueOverview") then
      DataModel.RefreshHuRunServerRank()
    end
  end, rankCA.rankType, rankCA.timeType, levelTween, rankCA.peopleNum, cacheInfo.request_id, cacheInfo.next_index, nil, nil, nil, function()
    cacheInfo.loading = false
  end)
end

function DataModel.GetHuRunFriendRankData(rankLevelTabIndex, callBack, failCb)
  local rankLists = DataModel.huRunFriendRankList
  if rankLists[rankLevelTabIndex] then
    callBack()
    return
  end
  local rankId = 84300033
  local rankCA = PlayerData:GetFactoryData(84300033, "RankFactory")
  local levelTween = DataModel.GetLevelTween(rankId, rankLevelTabIndex)
  Net:SendProto("main.rank", function(json)
    if rankLists ~= DataModel.huRunFriendRankList then
      return
    end
    if not rankLists[rankLevelTabIndex] then
      rankLists[rankLevelTabIndex] = json.rank_list or {}
      local key = rankCA.rankType .. ":" .. rankCA.timeType .. ":" .. levelTween
      DataModel.huRunFriendSelfRankList[rankLevelTabIndex] = json.my_rank and json.my_rank[key]
    end
    if callBack then
      callBack()
    end
  end, rankCA.rankType, rankCA.timeType, levelTween, "", rankCA.peopleNum, DataModel.RankTab.Friend, nil, nil, nil, failCb)
end

function DataModel.GetSelfLevelTabIndex(rankId)
  local rankCA = PlayerData:GetFactoryData(rankId, "RankFactory")
  local userLv = PlayerData:GetUserInfo().lv
  local isOneBased = rankCA.sectionType == "onebased"
  local minLv = 0
  for i, v in ipairs(rankCA.gradeSectionList) do
    if isOneBased then
      minLv = 1
    elseif i == 1 then
      minLv = 1
    else
      minLv = rankCA.gradeSectionList[i - 1].grade + 1
    end
    if userLv >= minLv and userLv <= v.grade then
      return i
    end
  end
end

function DataModel.GetLevelTween(rankId, rankLevelTabIndex)
  local rankCA = PlayerData:GetFactoryData(rankId, "RankFactory")
  local isOneBased = rankCA.sectionType == "onebased"
  local minLv = 0
  if isOneBased then
    minLv = 1
  elseif rankLevelTabIndex == 1 then
    minLv = 1
  else
    minLv = rankCA.gradeSectionList[rankLevelTabIndex - 1].grade + 1
  end
  return minLv .. "-" .. rankCA.gradeSectionList[rankLevelTabIndex].grade
end

function DataModel.ClickRightTab(tabIndex)
  local curTabIndex = DataModel.tabIndex
  if curTabIndex == tabIndex then
    return
  end
  local tabElement = DataModel.tabElements[curTabIndex]
  if tabElement then
    tabElement.Group_On:SetActive(false)
    tabElement.Group_Off:SetActive(true)
  end
  tabElement = DataModel.tabElements[tabIndex]
  if tabElement then
    tabElement.Group_On:SetActive(true)
    tabElement.Group_Off:SetActive(false)
  end
  DataModel.tabIndex = tabIndex
  local showType = DataModel.curPanelType
  if showType == DataModel.PanelType.Income then
    DataModel.RefreshIncome()
    View.self:PlayAnimOnce("Group_RecentDays")
  elseif showType == DataModel.PanelType.ServerRank then
    local function callBack()
      DataModel.RefreshServerRank()
      
      View.self:PlayAnimOnce("RevenueOverview_Group_Rank")
    end
    
    local rankId = DataModel.rankType[tonumber(tabIndex)]
    local rankLevelTabIndex = DataModel.GetSelfLevelTabIndex(rankId)
    DataModel.rankLevelTabIndex = rankLevelTabIndex
    DataModel.GetRankData(tabIndex, rankLevelTabIndex, DataModel.RankTab.Server, callBack)
    View.Group_Rank.Group_LVInterval:SetActive(false)
  elseif showType == DataModel.PanelType.FriendRank then
    local function callBack()
      DataModel.RefreshFriendRank()
      
      View.self:PlayAnimOnce("RevenueOverview_Group_Rank")
    end
    
    local rankId = DataModel.rankType[tonumber(tabIndex)]
    local rankLevelTabIndex = DataModel.GetSelfLevelTabIndex(rankId)
    DataModel.rankLevelTabIndex = rankLevelTabIndex
    DataModel.GetRankData(tabIndex, rankLevelTabIndex, DataModel.RankTab.Friend, callBack)
    View.Group_Rank.Group_LVInterval:SetActive(false)
  end
end

function DataModel.ClickRankRatio(rankIndex, selfRank)
  local tabIndex = DataModel.tabIndex
  local uid, role_name, headPath, photoFactory
  if selfRank then
    local userInfo = PlayerData:GetUserInfo()
    uid = userInfo.uid
    role_name = userInfo.role_name
    headPath, photoFactory = DataModel.GetHeadPath(userInfo.avatar, userInfo.gender)
  else
    local rankData
    if DataModel.curPanelType == DataModel.PanelType.FriendRank then
      local rankList = DataModel.friendRankList[tonumber(tabIndex)][DataModel.rankLevelTabIndex]
      rankData = rankList[tonumber(rankIndex)]
    elseif DataModel.curPanelType == DataModel.PanelType.ServerRank then
      local rankList = DataModel.serverRankList[tonumber(tabIndex)][DataModel.rankLevelTabIndex]
      rankData = rankList[tonumber(rankIndex)]
    end
    if rankData then
      uid = rankData and rankData.uid
      role_name = rankData.role_name
      headPath, photoFactory = DataModel.GetHeadPath(rankData.avatar, rankData.gender)
    end
  end
  if not (uid and role_name) or not headPath then
    return
  end
  Net:SendProto("main.revenue_record", function(json)
    View.Group_Rank.Group_OtherRatio:SetActive(true)
    local incomeRecord = json.revenue_record
    if incomeRecord then
      local incomes = {}
      local ratioIncomeList = {}
      local serverTime = DataModel.GetRankTodayTimeStamp()
      local key = os.date("!%Y-%m-%d", serverTime)
      local incomeData = incomeRecord[key] or {}
      local totalIncome = 0
      for i, v in pairs(DataModel.tabData) do
        if v.ratio ~= "" then
          local recordKey = DataModel.IncomeRecordKeyMap[v.rank]
          local income = 0
          if recordKey and incomeData[recordKey] and 0 < incomeData[recordKey] then
            income = incomeData[recordKey]
          end
          incomes[v.ratio] = income
          table.insert(ratioIncomeList, {
            income = income,
            name = v.name,
            ratio = v.ratio,
            labelBg = v.label
          })
          totalIncome = totalIncome + income
        end
      end
      table.sort(ratioIncomeList, function(a, b)
        return a.income > b.income
      end)
      DataModel.rankRatioIncomeList = ratioIncomeList
      DataModel.rankRatioTotalIncome = totalIncome
      local todayTotalIncome = 0
      for i, v in pairs(incomeData) do
        todayTotalIncome = todayTotalIncome + v
      end
      View.Group_Rank.Group_OtherRatio.Group_Title.Group_Money.Txt_:SetText(DataModel.GetIncomeShow(totalIncome))
      View.Group_Rank.Group_OtherRatio.Group_Title.Txt_Uid:SetText((string.format(GetText(80600575), uid)))
      View.Group_Rank.Group_OtherRatio.Group_Title.Txt_Name:SetText(role_name)
      View.Group_Rank.Group_OtherRatio.Group_Title.Btn_ProfilePhoto.Img_Head:SetSprite(headPath)
      CommonTips:SetPlayerHeadShader(View.Group_Rank.Group_OtherRatio.Group_Title.Btn_ProfilePhoto.Img_spAdd, photoFactory)
      View.Group_Rank.Group_OtherRatio.Group_Label.ScrollGrid_.grid.self:SetDataCount(#ratioIncomeList)
      View.Group_Rank.Group_OtherRatio.Group_Label.ScrollGrid_.grid.self:RefreshAllElement()
      local lastIncome = 0
      for i, v in ipairs(ratioIncomeList) do
        local income = incomes[v.ratio] or 0
        if 0 < income then
          income = income + lastIncome
          lastIncome = income
        end
        local ctr = View.Group_Rank.Group_OtherRatio.Group_Circle[v.ratio]
        if ctr then
          local ratio = totalIncome == 0 and 0 or income / totalIncome
          ctr:SetFilledImgAmount(ratio)
          ctr.transform:SetAsFirstSibling()
        end
      end
    end
  end, uid)
end

function DataModel.GetIncomeTodayTimeStamp()
  local serverTime = TimeUtil:GetServerTimeStamp() + PlayerData.TimeZone * 3600
  local date = os.date("!*t", serverTime)
  local nextDay = date.hour >= 22
  if nextDay then
    serverTime = serverTime + 86400
  end
  return serverTime
end

function DataModel.GetRankTodayTimeStamp()
  local serverTime = TimeUtil:GetServerTimeStamp() + PlayerData.TimeZone * 3600
  local date = os.date("!*t", serverTime)
  local yesterday = date.hour < 5
  if yesterday then
    serverTime = serverTime - 86400
  end
  return serverTime
end

function DataModel.GetIncomeBarShow(income)
  local num = math.abs(income)
  local str = tostring(num)
  local len = string.len(num)
  if 4 <= len and len <= 6 then
    str = string.format("%.2f", num / 1000) .. "k"
  end
  if 7 <= len and len <= 9 then
    str = string.format("%.2f", num / 1000000) .. "m"
  end
  if 10 <= len and len <= 12 then
    str = string.format("%.2f", num / 1000000000) .. "b"
  end
  if income < 0 then
    return "-" .. str
  end
  return str
end

function DataModel.GetIncomeShow(income)
  local thousandsSplit = NumThousandsSplit(math.abs(income))
  if income < 0 then
    return "-" .. thousandsSplit
  end
  return thousandsSplit
end

function DataModel.RefreshRankRedPointTime()
  local redPoint = PlayerData:GetPlayerPrefs("int", "RevenueRankRefreshRedPoint")
  if redPoint == 1 then
    return
  end
  local refreshTimeStamp = PlayerData:GetPlayerPrefs("string", "RevenueRankRefreshTimeStamp")
  if refreshTimeStamp == "" then
    PlayerData:SetPlayerPrefs("int", "RevenueRankRefreshRedPoint", 1)
  else
    local serverTime = TimeUtil:GetServerTimeStamp()
    if serverTime >= tonumber(refreshTimeStamp) then
      PlayerData:SetPlayerPrefs("int", "RevenueRankRefreshRedPoint", 1)
    end
  end
end

function DataModel.RefreshRankRedPoint()
  local redPoint = PlayerData:GetPlayerPrefs("int", "RevenueRankRefreshRedPoint")
  View.Img_RedDot:SetActive(redPoint == 1)
end

function DataModel.ClickResetRedPointTime()
  local redPoint = PlayerData:GetPlayerPrefs("int", "RevenueRankRefreshRedPoint")
  if redPoint == 0 then
    return
  end
  PlayerData:SetPlayerPrefs("int", "RevenueRankRefreshRedPoint", 0)
  local serverTime = TimeUtil:GetServerTimeStamp()
  local todayRefreshTimeStamp = TimeUtil:GetFutureTimeStampByUTC(0, 22, 0, 0)
  if serverTime < todayRefreshTimeStamp then
    PlayerData:SetPlayerPrefs("string", "RevenueRankRefreshTimeStamp", todayRefreshTimeStamp)
  else
    local nextDayRefreshTimeStamp = TimeUtil:GetFutureTimeStampByUTC(1, 22, 0, 0)
    PlayerData:SetPlayerPrefs("string", "RevenueRankRefreshTimeStamp", nextDayRefreshTimeStamp)
  end
end

function DataModel.GetHeadPath(avatar, gender)
  gender = gender or 0
  if avatar and avatar ~= "" then
    local photoCA = PlayerData:GetFactoryData(avatar, "ProfilePhotoFactory")
    return photoCA.imagePath, photoCA
  else
    local configCA = PlayerData:GetFactoryData(99900001, "ConfigFactory")
    return configCA.playerHeadList[gender + 1].playerHeadPath, nil
  end
end

function DataModel.RefreshRankGiveLike()
  local num, maxNum = PlayerData.GetGiveLikeNum()
  View.Group_Rank.Group_Title.Group_LikesNum.Group_NumLikes.Txt_:SetText(string.format(GetText(80609549), num, maxNum))
end

function DataModel.ClickGradeSection()
  if View.Group_Rank.Group_LVInterval.IsActive then
    View.Group_Rank.Group_LVInterval:SetActive(false)
    return
  end
  View.Group_Rank.Group_LVInterval:SetActive(true)
  local tabIndex = DataModel.tabIndex
  local rankId = DataModel.rankType[tonumber(tabIndex)]
  local rankCA = PlayerData:GetFactoryData(rankId, "RankFactory")
  View.Group_Rank.Group_LVInterval.StaticGrid_.grid.self:SetDataCount(#rankCA.gradeSectionList)
  View.Group_Rank.Group_LVInterval.StaticGrid_.grid.self:RefreshAllElement()
end

function DataModel.ClickHuRunGradeSection()
  if View.Group_Money.Group_LVInterval.IsActive then
    View.Group_Money.Group_LVInterval:SetActive(false)
    return
  end
  View.Group_Money.Group_LVInterval:SetActive(true)
  local rankId = 84300033
  local rankCA = PlayerData:GetFactoryData(rankId, "RankFactory")
  View.Group_Money.Group_LVInterval.StaticGrid_.grid.self:SetDataCount(#rankCA.gradeSectionList)
  View.Group_Money.Group_LVInterval.StaticGrid_.grid.self:RefreshAllElement()
end

function DataModel.RefreshHuRunServerRankCacheInfo(rankLevelTabIndex, json)
  local previous = DataModel.huRunServeRankLevelCacheInfo[rankLevelTabIndex] or {}
  DataModel.huRunServeRankLevelCacheInfo[rankLevelTabIndex] = {
    has_more = (json.has_more == true or tonumber(json.has_more) == 1) and json.request_id ~= nil and json.next_index ~= nil and #(json.rank_list or {}) > 0,
    request_id = json.request_id,
    next_index = json.next_index,
    total_members = tonumber(json.total_members) or previous.total_members
  }
end

return DataModel
