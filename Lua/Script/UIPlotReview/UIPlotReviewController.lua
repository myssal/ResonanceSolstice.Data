local View = require("UIPlotReview/UIPlotReviewView")
local DataModel = require("UIPlotReview/UIPlotReviewDataModel")
local DialogDataModel = require("UIDialog/UIDialogDataModel")
local Controller = {}

function Controller.RefreshOnShow()
  View.Group_Menu:SetActive(true)
  View.Img_Bg1:SetActive(false)
  View.Group_Menu.ScrollGrid_LOG.grid.self:SetDataCount(table.count(DataModel.menuData))
  View.Group_Menu.ScrollGrid_LOG.grid.self:RefreshAllElement()
end

function Controller.FreshAutoChapter()
  View.Img_Bg1.Group_Play.Btn_Play.Group_Off:SetActive(DataModel.GetAutoChapterState())
  View.Img_Bg1.Group_Play.Btn_Play.Group_On:SetActive(not DataModel.GetAutoChapterState())
end

function Controller.InitView(plotReviewId)
  View.Group_Menu:SetActive(false)
  View.Img_Bg1:SetActive(true)
  Controller.FreshAutoChapter()
  local data = PlayerData:GetFactoryData(plotReviewId, "ConfigFactory")
  if data ~= nil and data.PlotReviewList ~= nil or plotReviewId == "99900078" then
    DataModel.Level = 1
    DataModel.ChapterIndex = 1
    DataModel.LastChapterIndex = 0
    View.Img_Bg1.Group_PlotList:SetActive(false)
    DataModel.isMale = true
    local serverData = PlayerData.ServerData
    if serverData ~= nil and serverData.user_info ~= nil and serverData.user_info.gender == 0 then
      DataModel.isMale = false
    end
    DataModel.Data = {}
    local index = 0
    local PlotReviewList = plotReviewId == "99900078" and DataModel.anecdotePlotList or data.PlotReviewList
    for k, v in pairs(PlotReviewList) do
      local list = {}
      local id = plotReviewId == "99900078" and v.plotReviewId or v.ChapterList
      local tempData = PlayerData:GetFactoryData(id, "PlotFactory")
      list.TitlePlot = tempData.TitlePlot
      list.MainTitle = tempData.MainTitle
      list.TitleEN = tempData.TitleEN
      list.CoverPage = tempData.CoverPage
      list.MaleVideo = tempData.MaleVideo
      list.FemaleVideo = tempData.FemaleVideo
      list.characterId = v.characterId
      local isUnlockChapter = false
      local tList = {}
      local optionCount = 0
      local optionSum = 0
      local sortIndex = 0
      local questIsComplete = DataModel.QuestIsComplete(v.questId)
      for k1, v1 in pairs(tempData.IncludeStories) do
        local temp = {}
        sortIndex = sortIndex + 1
        temp.sortIndex = sortIndex
        temp.SecTitle = v1.SecTitle
        temp.Picture = v1.Picture
        temp.SecTitleDesc = v1.SecTitleDesc
        local tempList = {}
        if 0 < v1.IncludeParagraph then
          local IncludeParagraph = {}
          IncludeParagraph = PlayerData:GetFactoryData(v1.IncludeParagraph, "ListFactory").IncludeParagraph
          for k2, v2 in pairs(IncludeParagraph) do
            tempList[k2] = v2.id
          end
        end
        temp.reviewList = tempList
        local isUnlock = false
        local unlockId = tostring(v1.UnlockOption)
        if PlayerData.plot_paragraph[unlockId] or questIsComplete then
          isUnlockChapter = true
          isUnlock = true
          optionCount = optionCount + 1
        end
        temp.isUnlock = isUnlock
        tList[k1] = temp
        optionSum = optionSum + 1
      end
      list.optionCount = optionCount
      list.optionSum = optionSum
      list.isUnlock = isUnlockChapter
      table.sort(tList, function(a, b)
        if a.isUnlock == b.isUnlock then
          return a.sortIndex < b.sortIndex
        end
        if a.isUnlock and not b.isUnlock then
          return true
        end
        return false
      end)
      list.IncludeStories = tList
      index = index + 1
      DataModel.Data[index] = list
    end
    SoundManager:PauseBGM(true)
    View.Img_Bg1.Group_Tab.ScrollGrid_.grid.self:SetDataCount(#DataModel.Data)
    View.Img_Bg1.Group_Tab.ScrollGrid_.grid.self:RefreshAllElement()
    View.Img_Bg1.Group_Tab.ScrollGrid_.grid.self:MoveToTop()
  end
end

local function LoadSpine(characterId)
  if characterId then
    local cfg = PlayerData:GetFactoryData(characterId)
    local spinePath = PlayerData:GetFactoryData(cfg.viewId).gachaSpine2Url
    View.Img_Bg1.Group_Video.Btn_Item.Group_Spine.SpineAnimation_:SetData(spinePath)
    View.Img_Bg1.Group_Video.Btn_Item.Group_Spine:SetActive(true)
    View.Img_Bg1.Group_Video.Btn_Item.Video_Main:SetActive(false)
  end
end

local function PlayVideo(data)
  local view = View.Img_Bg1.Group_Video
  view:SetActive(true)
  if data ~= nil then
    if DataModel.LastChapterIndex == DataModel.ChapterIndex then
      if data.isUnlock then
        view.Btn_Item.Video_Main:PlayAgain()
      else
        view.Btn_Item.Video_Main:Pause()
      end
      return
    end
    DataModel.LastChapterIndex = DataModel.ChapterIndex
    local videoId = data.FemaleVideo
    if DataModel.isMale then
      videoId = data.MaleVideo
    end
    if 0 < videoId then
      view.Btn_Item.Video_Main:SetActive(true)
      view.Btn_Item.Group_Spine:SetActive(false)
      local videoData = PlayerData:GetFactoryData(videoId, "VideoFactory")
      if videoData ~= nil and videoData.videoPath ~= nil and videoData.videoPath ~= "" then
        local video = view.Btn_Item.Video_Main.transform:GetChild(0)
        if video ~= nil then
          local videoPlayer = video:GetComponent(typeof(CS.UnityEngine.Video.VideoPlayer))
          if videoPlayer ~= nil then
            videoPlayer.controlledAudioTrackCount = 1
            videoPlayer:EnableAudioTrack(0, true)
            videoPlayer:SetTargetAudioSource(0, video:GetComponent(typeof(CS.UnityEngine.AudioSource)))
          end
        end
        view.Btn_Item.Video_Main:Play(videoData.videoPath, true, not data.isUnlock, true, nil)
      end
    else
      LoadSpine(data.characterId)
    end
    view.Btn_Item.Img_Mask:SetActive(not data.isUnlock)
    view.Btn_Item.Img_MaskBlack:SetActive(not data.isUnlock)
    view.Btn_Item.Group_Unlock:SetActive(data.isUnlock)
  else
    view.Btn_Item.Video_Main:Pause()
  end
end

function Controller.SetChapterElement(element, index)
  local data = DataModel.Data[index]
  element.Btn_.Txt_:SetText(data.MainTitle)
  element.Img_Mask:SetActive(not data.isUnlock)
  element.Btn_.Img_Off:SetActive(data.isUnlock)
  if data.isUnlock then
    element.Btn_.Img_Off:SetSprite(data.CoverPage)
  end
  local isActive = DataModel.ChapterIndex == index
  element.Btn_.Img_Select:SetActive(isActive)
  if DataModel.Level == 1 and isActive then
    PlayVideo(data)
  elseif isActive and data.FemaleVideo < 0 then
    LoadSpine(data.characterId)
  end
  if isActive then
    local view = View.Img_Bg1.Group_Video.Btn_Item
    view.Txt_PlotTitle:SetText(data.TitlePlot)
    view.Txt_ChapterNameCN:SetText(data.MainTitle)
    view.Txt_ChapterNameEN:SetText(data.TitleEN)
    view.Txt_ChapterNameEN:SetActive(not CommonTips.IsResEN())
    view.Img_ProcessBg.Txt_Num:SetText(tostring(data.optionCount) .. "/" .. tostring(data.optionSum))
  end
end

function Controller.ChapterBtn(index)
  DataModel.ChapterIndex = index
  View.Img_Bg1.Group_Tab.ScrollGrid_.grid.self:RefreshAllElement()
  if DataModel.Level == 2 then
    local data = DataModel.Data[index]
    if data.isUnlock then
      local view = View.Img_Bg1.Group_PlotList.Img_Frame.ScrollGrid_.grid.self
      view:SetDataCount(#data.IncludeStories)
      view:RefreshAllElement()
      view:MoveToTop()
      View.Img_Bg1.Group_PlotList.Img_ProcessBg.Txt_Num:SetText(string.format("%d/%d", data.optionCount, data.optionSum))
    else
      Controller.OpenChapter(false)
    end
  end
end

function Controller.OpenChapter(isOpen)
  local data = DataModel.Data[DataModel.ChapterIndex]
  if isOpen and data.isUnlock == false then
    return
  end
  local view = View.Img_Bg1.Group_PlotList
  view:SetActive(isOpen)
  View.Img_Bg1.Group_Play.Btn_Play:SetActive(not isOpen)
  Controller.FreshAutoChapter()
  if isOpen then
    DataModel.Level = 2
    view.Img_Frame.ScrollGrid_.grid.self:SetDataCount(#data.IncludeStories)
    view.Img_Frame.ScrollGrid_.grid.self:RefreshAllElement()
    view.Img_Frame.ScrollGrid_.grid.self:MoveToTop()
    view.Img_ProcessBg.Txt_Num:SetText(tostring(data.optionCount) .. "/" .. tostring(data.optionSum))
  else
    DataModel.Level = 1
    PlayVideo(data)
  end
end

function Controller.SetSectionElement(element, index)
  local data = DataModel.Data[DataModel.ChapterIndex].IncludeStories[index]
  element.Img_PicBg.Img_:SetSprite(data.Picture)
  element.Txt_Title:SetText(data.SecTitle)
  element.Txt_Desc:SetText(data.SecTitleDesc)
  element.Img_Mask:SetActive(not data.isUnlock)
  PlayVideo()
end

function Controller.SectionPlayBtn(index)
  local IncludeStories = DataModel.Data[DataModel.ChapterIndex].IncludeStories
  local targetPlayIndex = #IncludeStories
  for i = index, targetPlayIndex do
    local data = IncludeStories[i]
    if data.isUnlock and #data.reviewList > 0 then
      for j = 1, #data.reviewList do
        if not table.contains(DialogDataModel.ReviewList, data.reviewList[j]) then
          table.insert(DialogDataModel.ReviewList, data.reviewList[j])
        end
      end
      View.Img_Bg1.Group_Video.Btn_Item.Video_Main.self.IsNotRelease = true
      View.self.gameObject:SetActive(false)
    end
  end
  if 0 < #DialogDataModel.ReviewList then
    UIManager:Open(UIPath.UIDialog, Json.encode({
      id = DialogDataModel.ReviewList[1]
    }))
  end
end

function Controller.SectionDetailBtn(index)
end

function Controller.SwitchContinuePlay()
  local newContinueState = not DataModel.GetAutoChapterState()
  DataModel.SetAutoChapter(newContinueState)
  View.Img_Bg1.Group_Play.Btn_Play.Group_Off.self.gameObject:SetActive(newContinueState)
  View.Img_Bg1.Group_Play.Btn_Play.Group_On.self.gameObject:SetActive(not newContinueState)
end

return Controller
