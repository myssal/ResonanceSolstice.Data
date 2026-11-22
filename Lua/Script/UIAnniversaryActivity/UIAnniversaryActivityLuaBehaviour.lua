local View = require("UIAnniversaryActivity/UIAnniversaryActivityView")
local DataModel = require("UIAnniversaryActivity/UIAnniversaryActivityDataModel")
local ViewFunction = require("UIAnniversaryActivity/UIAnniversaryActivityViewFunction")
local Controller = require("UIAnniversaryActivity/UIAnniversaryActivityController")
local param
local Luabehaviour = {
  serialize = function()
    return param
  end,
  deserialize = function(initParams)
    param = initParams
    local data = Json.decode(initParams)
    DataModel.Init(data.activityId, data.closeTime)
    Controller.QuestIsFinish(DataModel.questId, DataModel.skipQuestId, DataModel.levelQuestId)
    Controller.RefreshPanelDot(DataModel.cardPackId)
    View.Group_Time:SetActive(not DataModel.continue)
    local startTime = DataModel.startTime:gsub("(%d+)-(%d+)-(%d+) (%d+:%d+):%d+", "%2/%3 %4")
    local endTime = DataModel.endTime:gsub("(%d+)-(%d+)-(%d+) (%d+:%d+):%d+", "%2/%3 %4")
    View.Group_Time.Txt_EndTime:SetText(string.format(GetText(80607096), startTime, endTime))
    View.Group_Join:SetActive(DataModel.isJoin)
    View.Group_NotJoin:SetActive(not DataModel.isJoin)
    local isOver = DataModel.ActivityOver()
    if not DataModel.isJoin then
      View.Group_NotJoin.Group_Preview.ScrollGrid_Reward.grid.self:SetDataCount(#DataModel.rewardPreviewList)
      View.Group_NotJoin.Group_Preview.ScrollGrid_Reward.grid.self:RefreshAllElement()
      View.Group_NotJoin.Group_Preview.ScrollGrid_Reward.grid.self:MoveToTop()
      View.Group_NotJoin.Group_Add.Group_Can:SetActive(DataModel.isCanJoin and not isOver)
      View.Group_NotJoin.Group_Add.Group_Quest:SetActive(not DataModel.isCanJoin and not isOver)
      View.Group_NotJoin.Group_Add.Group_Quest.Txt_Quest:SetText(DataModel.unlockTip)
      local remainDay = string.format(GetText(80607097), DataModel.GetRemainDays())
      local timeLimit = DataModel.isTimeLimit and not DataModel.continue
      View.Group_NotJoin.Group_Add.Group_Quest.Txt_Time:SetActive(timeLimit)
      View.Group_NotJoin.Group_Add.Group_Can.Txt_Time:SetActive(timeLimit)
      View.Group_NotJoin.Group_Add.Group_Can.Txt_:SetActive(timeLimit)
      View.Group_NotJoin.Group_Add.Group_Quest.Txt_Time:SetText(remainDay)
      View.Group_NotJoin.Group_Add.Group_Can.Txt_Time:SetText(remainDay)
      View.Group_NotJoin.Group_Add.Group_Finish:SetActive(isOver)
      if isOver then
        View.Group_NotJoin.Group_Add.Group_Finish.Txt_Time:SetText(DataModel.GetCloseTimeInfo())
      end
      View.Group_Bg.Img_Icon:SetSprite(GetResPath(88300181))
    else
      View.Group_Join.Group_Finish:SetActive(isOver)
      View.Group_Join.Group_Level:SetActive(not isOver)
      View.Group_Join.Group_Skip:SetActive(false)
      View.Group_Join.Group_Skip.Group_Can:SetActive(not DataModel.sideQuestIsComplete)
      View.Group_Join.Group_Skip.Group_Finish:SetActive(DataModel.sideQuestIsComplete)
      View.Group_Join.Group_Level.Group_Quest:SetActive(not DataModel.levelQuestIsComplete)
      if isOver then
        View.Group_Join.Group_Finish.Txt_Time:SetText(DataModel.GetCloseTimeInfo())
      end
      View.Group_Join.Group_Store.Txt_Num:SetText(PlayerData:GetGoodsById(11400545).num or 0)
      View.Group_Bg.Img_Icon:SetSprite(GetResPath(88300181))
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
