local DataModel = {}
DataModel.Data = {}
DataModel.isMale = true
DataModel.Level = 0
DataModel.ChapterIndex = 1
DataModel.LastChapterIndex = 0
DataModel.menuData = {}
local isAutoChapter

function DataModel.InitData()
  DataModel.menuData = {}
  
  local function GetMenuData(configId)
    local totalNum = 0
    local curNum = 0
    local configCA = PlayerData:GetFactoryData(configId, "ConfigFactory")
    for i, v in ipairs(configCA.PlotReviewList) do
      local plotCA = PlayerData:GetFactoryData(v.ChapterList, "PlotFactory")
      local questIsComplete = DataModel.QuestIsComplete(v.questId)
      for _, v1 in ipairs(plotCA.IncludeStories) do
        totalNum = totalNum + 1
        if PlayerData.plot_paragraph[tostring(v1.UnlockOption)] or questIsComplete then
          curNum = curNum + 1
        end
      end
    end
    return totalNum, curNum
  end
  
  local plotTypeList = PlayerData:GetFactoryData(99900066).typeList
  for i, v in ipairs(plotTypeList) do
    local totalNum = 0
    local curNum = 0
    if v.reviewId == 99900078 then
      DataModel.anecdotePlotList = {}
      local anecdoteList = PlayerData:GetFactoryData(99900078).AnecdoteList
      for i, v in ipairs(anecdoteList) do
        if TimeUtil:TimeStamp(v.startTime) <= TimeUtil.GetServerTimeStamp() then
          table.insert(DataModel.anecdotePlotList, v)
          local plotCA = PlayerData:GetFactoryData(v.plotReviewId, "PlotFactory")
          local questIsComplete = DataModel.QuestIsComplete(v.questId)
          for _, v1 in ipairs(plotCA.IncludeStories) do
            totalNum = totalNum + 1
            if PlayerData.plot_paragraph[tostring(v1.UnlockOption)] or questIsComplete then
              curNum = curNum + 1
            end
          end
        end
      end
    else
      totalNum, curNum = GetMenuData(v.reviewId)
    end
    if 0 < totalNum then
      table.insert(DataModel.menuData, {
        reviewId = v.reviewId,
        totalNum = totalNum,
        curNum = curNum,
        info = v
      })
    end
  end
end

function DataModel.GetAnecdoteSelectIdx(chapterId)
  local idx = 1
  for i, v in ipairs(DataModel.anecdotePlotList) do
    if v.plotReviewId == chapterId then
      idx = i
      break
    end
  end
  return idx
end

function DataModel.QuestIsComplete(questId)
  local questIsComplete = false
  if 0 < questId then
    questIsComplete = PlayerData.IsQuestComplete(questId)
  end
  return questIsComplete
end

function DataModel.GetAutoChapterState()
  if isAutoChapter == nil then
    isAutoChapter = PlayerData:GetPlayerPrefs("int", "Dialog_isAutoChapter") == 1
  end
  return isAutoChapter
end

function DataModel.SetAutoChapter(_isAutoChapter)
  isAutoChapter = _isAutoChapter
  if _isAutoChapter then
    PlayerData:SetPlayerPrefs("int", "Dialog_isAutoChapter", 1)
  else
    PlayerData:SetPlayerPrefs("int", "Dialog_isAutoChapter", 0)
  end
end

return DataModel
