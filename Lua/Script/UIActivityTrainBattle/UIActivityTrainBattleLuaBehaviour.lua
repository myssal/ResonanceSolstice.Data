local View = require("UIActivityTrainBattle/UIActivityTrainBattleView")
local DataModel = require("UIActivityTrainBattle/UIActivityTrainBattleDataModel")
local ViewFunction = require("UIActivityTrainBattle/UIActivityTrainBattleViewFunction")
local Controller = require("UIActivityTrainBattle/UIActivityTrainBattleController")
local param
local Luabehaviour = {
  serialize = function()
    return param
  end,
  deserialize = function(initParams)
    View.Group_Join.Img_Icon:SetSprite(GetResPath(88300266))
    View.Group_NotJoin.Img_Icon:SetSprite(GetResPath(88300266))
    param = initParams
    local data = Json.decode(initParams)
    DataModel.Init(data.activityId, data.closeTime)
    Controller.QuestIsFinish(DataModel.questId, DataModel.gameQuestId, DataModel.levelQuestId)
    Controller.RefreshPanelDot()
    View.Group_Join.Group_Time:SetActive(not DataModel.continue)
    local startTime = string.gsub(DataModel.startTime, "-", "/")
    local endTime = string.gsub(DataModel.endTime, "-", "/")
    local timeInfo = string.format(GetText(80607096), startTime, endTime)
    View.Group_Join.Group_Time.Txt_EndTime:SetText(timeInfo)
    View.Group_Join:SetActive(DataModel.isCanJoin and DataModel.isJoin)
    View.Group_NotJoin:SetActive(not DataModel.isCanJoin or not DataModel.isJoin)
    Controller.RefreshCapsuleShow()
    local isOver = DataModel.ActivityOver()
    if not DataModel.isCanJoin or not DataModel.isJoin then
      View.Group_NotJoin.Group_Preview.ScrollGrid_Reward.grid.self:SetDataCount(#DataModel.rewardPreviewList)
      View.Group_NotJoin.Group_Preview.ScrollGrid_Reward.grid.self:RefreshAllElement()
      View.Group_NotJoin.Group_Preview.ScrollGrid_Reward.grid.self:MoveToTop()
      View.Group_NotJoin.Group_Add.Group_Can:SetActive(DataModel.isCanJoin and not isOver)
      View.Group_NotJoin.Group_Add.Group_Quest:SetActive(not DataModel.isCanJoin and not isOver)
      View.Group_NotJoin.Group_Add.Group_Quest.Txt_Quest:SetText(DataModel.unlockTip)
      View.Group_NotJoin.Group_Time:SetActive(not DataModel.continue)
      View.Group_NotJoin.Group_Time.Txt_EndTime:SetText(timeInfo)
      View.Group_NotJoin.Group_Add.Group_Finish:SetActive(isOver)
      if isOver then
        View.Group_NotJoin.Group_Add.Group_Finish.Txt_Time:SetText(DataModel.GetCloseTimeInfo())
      end
    else
      View.Group_Join.Group_Finish:SetActive(isOver)
      View.Group_Join.Group_Level:SetActive(not isOver)
      if isOver then
        View.Group_Join.Group_Finish.Txt_Time:SetText(DataModel.GetCloseTimeInfo())
      end
      View.Group_Join.Group_Store.Group_Top.Txt_Num:SetText(PlayerData:GetGoodsById(11400389).num or 0)
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
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
