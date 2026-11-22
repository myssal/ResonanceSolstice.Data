local View = require("UIInsZone/UIInsZoneView")
local DataModel = require("UIInsZone/UIInsZoneDataModel")

local function SetLevelId(id)
  PlayerData.BattleInfo.battleStageId = id
end

local model = {}

function model.StartBattle(levelId, current, squadIdx, LCId, eventId)
  PlayerData.BattleInfo.battleStageId = levelId
  local status = {
    Current = current,
    squadIndex = squadIdx,
    hasOpenThreeView = false,
    levelChainId = LCId,
    eventId = eventId
  }
  SetLevelId(levelId)
  UIManager:Open("UI/Squads/Squads", Json.encode(status))
end

function model.GobackFunction()
  if DataModel.GoBackUI ~= nil then
    UIManager:Open(DataModel.GoBackUI, DataModel.GoBackUIParam)
  else
    MapNeedleData.GoBack()
  end
  DataModel.GoBackUI = nil
  DataModel.GoBackUIParam = nil
end

function model.GoHomeFunction()
  DataModel.GoBackUI = nil
  DataModel.GoBackUIParam = nil
  MapNeedleData.GoHome()
end

local tweenTime = 1

function model.RefreshOnShow()
  local chapterCA = PlayerData:GetFactoryData(DataModel.chapterId, "ChapterFactory")
  if not chapterCA then
    return
  end
  local totalCount = table.count(chapterCA.stageInfoList)
  if totalCount <= DataModel.GetChapterLevelCompleted() and not MapNeedleEventData.scene then
    model.GobackFunction()
    return
  end
  local curLevelIndex = DataModel.curLevelIndex
  local preLevelIndex = curLevelIndex - 1 > 0 and curLevelIndex - 1 or 0
  local lineLength = View.Group_Progress.Img_End.transform.localPosition.x - View.Group_Progress.Img_Start.transform.localPosition.x
  local count = 0 < totalCount and totalCount or 1
  local perLevelLength = lineLength / count
  local tartPosX = View.Group_Progress.Img_Start.transform.localPosition.x + perLevelLength * curLevelIndex
  local prevPosX = View.Group_Progress.Img_Start.transform.localPosition.x + perLevelLength * preLevelIndex
  View.Group_Progress.Img_Target:SetLocalPositionX(prevPosX, 0)
  DOTweenTools.DOLocalMoveXCallback(View.Group_Progress.Img_Target.transform, tartPosX, tweenTime, function()
  end)
  local curPercentage = curLevelIndex / count * 100
  local prevPercentage = preLevelIndex / count * 100
  View.Group_Progress.Txt_Percentage:SetText(string.format("%.2f", prevPercentage))
  DOTweenTools.DoTextProgress(View.Group_Progress.Txt_Percentage, prevPercentage, curPercentage, tweenTime)
  if totalCount > curLevelIndex then
    local nextLevelId = chapterCA.stageInfoList[curLevelIndex + 1].levelId
    DataModel.nextLevelId = nextLevelId
    local levelCA = PlayerData:GetFactoryData(nextLevelId, "LevelFactory")
    if levelCA then
      View.Prefab_Bg:SetData(levelCA.bgResUrl)
      View.Txt_Name:SetText(levelCA.levelName)
      View.Txt_NameEN:SetText(levelCA.levelChapter)
      View.Txt_Des:SetText(levelCA.description)
      View.Txt_Lv:SetText(string.format(GetText(80601819), levelCA.recomGrade))
      local sound = SoundManager:CreateSound(levelCA.insZoneBGMId)
      if sound ~= nil then
        sound:Play()
      end
    end
  end
  View.Img_Location:SetSprite(chapterCA.chapterMapBackground)
  View.Btn_Start:SetActive(totalCount > curLevelIndex)
  View.Group_CommonTopLeft.Btn_Home:SetActive(not MapNeedleEventData.scene)
end

function model.IsBattleFinishBackToInsZone()
  if PlayerData.BattleInfo and PlayerData.BattleInfo.battleStageId then
    local levelCA = PlayerData:GetFactoryData(PlayerData.BattleInfo.battleStageId)
    if levelCA.chapterId and levelCA.chapterId > 0 then
      local chapterCA = PlayerData:GetFactoryData(levelCA.chapterId, "ChapterFactory")
      local completed = true
      for k, v in pairs(chapterCA.stageInfoList) do
        if not PlayerData:GetLevelPass(v.levelId) then
          completed = false
          break
        end
      end
      local insZoneData = require("UIInsZone/UIInsZoneDataModel")
      if completed and not insZoneData.GoBackUI and PlayerData.BattleCallBackPage == "UI/InsZone/InsZone" then
        PlayerData.BattleCallBackPage = ""
        PlayerData.Last_Chapter_Parms = nil
      else
        PlayerData.BattleCallBackPage = "UI/InsZone/InsZone"
        PlayerData.Last_Chapter_Parms = {
          chapterId = insZoneData.chapterId,
          GoBackUI = insZoneData.GoBackUI,
          GoBackUIParam = insZoneData.GoBackUIParam,
          scene = DataModel.scene
        }
      end
    end
  end
end

return model
