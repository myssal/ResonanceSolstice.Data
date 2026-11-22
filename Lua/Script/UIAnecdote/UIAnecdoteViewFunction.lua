local View = require("UIAnecdote/UIAnecdoteView")
local DataModel = require("UIAnecdote/UIAnecdoteDataModel")
local ViewFunction = {
  Anecdote_Group_Right_NewScrollGrid_AnecdoteList_SetGrid = function(element, elementIndex)
    local seriesQuestData = DataModel.seriesQuestList[elementIndex]
    local data = DataModel.anecdoteList[seriesQuestData.idx]
    local roleCfg = PlayerData:GetFactoryData(data.characterId)
    element.Txt_CharacterName:SetText(roleCfg.name)
    element.Txt_AnecdoteName:SetText(data.anecdoteName)
    local headpath = PlayerData:GetFactoryData(roleCfg.viewId).squadsHalf1
    element.Group_Card.Img_Mask.Img_Character:SetSprite(headpath)
    local info = seriesQuestData.info
    element.Txt_CharacterName:SetTextAlpha(info.status == 1 and 0.49019607843137253 or 1)
    element.Txt_AnecdoteName:SetTextAlpha(info.status == 1 and 0.49019607843137253 or 1)
    if DataModel.selectSeriesIdx == elementIndex then
      local group = View.Group_Left.Group_Common.Group_Machine.Group_MachinePivot.Group_Furniture.Group_Furniture_03
      group.Img_Face:SetSprite(data.faceUrl)
      group.Img_Progress:SetFilledImgAmount(info.process)
      group.Txt_Progress:SetText(math.floor(info.process * 100) .. "%")
      local isCan = DataModel.nowJionIdx == seriesQuestData.idx or DataModel.nowJionIdx == -1
      group.Group_OnGoing:SetActive(info.status == 5)
      View.Group_Left.Group_Title.Group_OnGoing:SetActive(info.status == 5)
      group.Group_Continue:SetActive(info.status == 4 and isCan)
      View.Group_Left.Group_Title.Group_Continue:SetActive(info.status == 4 and isCan)
      group.Group_CannotContine:SetActive(info.status == 4 and not isCan)
      View.Group_Left.Group_Title.Group_CannotContine:SetActive(info.status == 4 and not isCan)
      group.Group_Available:SetActive(info.status == 3 and isCan)
      View.Group_Left.Group_Title.Group_Available:SetActive(info.status == 3 and isCan)
      group.Group_UnAvailable:SetActive(info.status == 3 and not isCan)
      View.Group_Left.Group_Title.Group_UnAvailable:SetActive(info.status == 3 and not isCan)
      group.Group_Locked:SetActive(info.status == 2)
      View.Group_Left.Group_Title.Group_Locked:SetActive(info.status == 2)
      group.Group_Completed:SetActive(info.status == 1)
      View.Group_Left.Group_Title.Group_Completed:SetActive(info.status == 1)
      if info.status == 2 then
        local questId = PlayerData:GetFactoryData(info.nowQuestId).preQuestId
        local questName = PlayerData:GetFactoryData(questId).name
        View.Group_Left.Group_Title.Group_Locked.Group_Bottom.Txt_Des:SetActive(true)
        View.Group_Left.Group_Title.Group_Locked.Group_Bottom.Txt_Des:SetText(string.format(GetText(80607064), questName))
      end
    end
    element.Group_OnGoing.Img_Deco:SetSprite(GetResPath(88300024))
    element.Btn_:SetClickParam(elementIndex)
    element.Group_Selected:SetActive(DataModel.selectSeriesIdx == elementIndex)
    element.Group_OnGoing:SetActive(info.status == 5)
    element.Group_Stop:SetActive(info.status == 4)
    element.Group_UnLocked:SetActive(info.status == 3)
    element.Group_Locked:SetActive(info.status == 2)
    element.Group_Completed:SetActive(info.status == 1)
    element.Img_Locked:SetActive(info.status == 1 or info.status == 2)
    element.Group_Card:SetLocalEulerAngles(info.status == 5 and 8 or 0)
    local questId = seriesQuestData[1]
    local redStatus = PlayerData:GetPlayerPrefs("int", questId)
    element.Img_New:SetActive(redStatus ~= 1)
  end,
  Anecdote_Group_Right_NewScrollGrid_AnecdoteList_Group_Item_Btn__Click = function(btn, str)
    local nowIdx = tonumber(str)
    if nowIdx ~= DataModel.selectSeriesIdx then
      DataModel.selectSeriesIdx = nowIdx
      View.Group_Right.NewScrollGrid_AnecdoteList.grid.self:RefreshAllElement()
    end
  end,
  Anecdote_Group_TopLeft_Btn_Return_Click = function(btn, str)
    if not DataModel.isActivityJump then
      require("UIMainUI/UIMainUIController"):PlayBGM()
    end
    UIManager:GoBack()
  end,
  Anecdote_Group_TopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  Anecdote_Group_TopLeft_Btn_Menu_Click = function(btn, str)
  end,
  Anecdote_Group_TopLeft_Btn_Help_Click = function(btn, str)
    CommonTips.OpenHelp(80302572)
  end,
  Anecdote_Group_Left_Group_Title_Btn__Click = function(btn, str)
    local info = DataModel.seriesQuestList[DataModel.selectSeriesIdx].info
    local nowIdx = DataModel.seriesQuestList[DataModel.selectSeriesIdx].idx
    if info.status == 1 then
      require("UIMainUI/UIMainUIController"):PlayBGM()
      local chapterId = DataModel.anecdoteList[nowIdx].plotReviewId
      UIManager:Open("UI/PlotReview/PlotReview", Json.encode({chapterId = chapterId}))
      return
    end
    local isCan = DataModel.nowJionIdx == nowIdx or DataModel.nowJionIdx == -1
    if isCan then
      if info.status == 3 or info.status == 4 then
        Net:SendProto("quest.accept_quest", function(json)
          DataModel.RefreshQuestStatus(5)
          QuestTrace.AcceptQuest(info.nowQuestId)
          UIManager:GoBack()
          if DataModel.isActivityJump then
            UIManager:GoBack(false, 2)
            UIManager:Open("UI/Quest/Quest")
          end
          require("UIMainUI/UIMainUIController"):PlayBGM()
        end, info.nowQuestId)
        return
      end
      if info.status == 5 then
        Net:SendProto("quest.suspend_quest", function(json)
          DataModel.RefreshQuestStatus(4)
          View.Group_Right.NewScrollGrid_AnecdoteList.grid.self:RefreshAllElement()
          QuestTrace.CancelQuest(info.nowQuestId)
        end, info.nowQuestId)
        return
      end
    end
  end
}
return ViewFunction
