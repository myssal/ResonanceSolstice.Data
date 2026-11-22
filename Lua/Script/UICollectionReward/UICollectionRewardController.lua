local View = require("UICollectionReward/UICollectionRewardView")
local DataModel = require("UICollectionReward/UICollectionRewardDataModel")
local BtnItem = require("Common/BtnItem")
local Controller = {}

function Controller.Init()
  Controller.RefreshContentShow()
end

function Controller.RefreshContentShow()
  local bookInfo = DataModel.GetBookInfo()
  if not bookInfo then
    return
  end
  local finishCount = DataModel.GetFinishCount() or 0
  local stageList = bookInfo.stageList or {}
  View.Group_Stage.Txt_Num.Txt_Unlock:SetText(tostring(finishCount))
  View.Group_Stage.Txt_Num.Txt_Max:SetText(tostring(#stageList))
  View.Group_Progress.Group_Txt.Txt_0:SetText(bookInfo.typeName)
  local unlockNum, allNum = DataModel.GetAllUnlockNum()
  View.Group_Progress.Group_Txt.Txt_CurrentNum:SetText(tostring(unlockNum))
  View.Group_Progress.Group_Txt.Txt_AllNum:SetText(tostring(allNum))
  Controller.RefreshScrollShow()
end

function Controller.RefreshScrollShow()
  local bookInfo = DataModel.GetBookInfo()
  if not bookInfo then
    return
  end
  local stageList = bookInfo.stageList or {}
  View.ScrollGrid_Stage.grid.self:SetDataCount(#stageList)
  View.ScrollGrid_Stage.grid.self:RefreshAllElement()
end

function Controller.RefreshItemElement(element, index)
  if not element or not index then
    return
  end
  local bookInfo = DataModel.GetBookInfo()
  if not bookInfo then
    return
  end
  local stageList = bookInfo.stageList or {}
  local stageInfo = stageList[index]
  if not stageInfo then
    return
  end
  element.Txt_Stage:SetText(tostring(index))
  element.Txt_TargetNum:SetText(tostring(stageInfo.num))
  element.Txt_QuestDes:SetText(tostring(bookInfo.questDes))
  local ca = PlayerData:GetFactoryData(stageInfo.id, "ListFactory")
  if ca then
    local rewardList = ca.rewardList or {}
    local count = 3 < #rewardList and 3 or #rewardList
    element.StaticGrid_Rewareds.grid.self:SetParentParam(index)
    element.StaticGrid_Rewareds.grid.self:SetDataCount(count)
    element.StaticGrid_Rewareds.grid.self:RefreshAllElement()
  end
  local getState = DataModel.GetStageGetStateByIndex(index)
  element.Group_Deco.Group_UnClaimabe:SetActive(getState == DataModel.stateType.canNotGet)
  element.Group_Deco.Group_Claimable:SetActive(getState == DataModel.stateType.canGet)
  element.Group_Deco.Group_Claimed:SetActive(getState == DataModel.stateType.hasGet)
  element.Group_Bg.Group_UnClaimabe:SetActive(getState == DataModel.stateType.canNotGet)
  element.Group_Bg.Group_Claimable:SetActive(getState == DataModel.stateType.canGet)
  element.Group_Bg.Group_Claimed:SetActive(getState == DataModel.stateType.hasGet)
  element.Btn_Claim:SetActive(getState == DataModel.stateType.canGet)
  element.Btn_Claim:SetClickFunction(function()
    Controller.OnGetRewardBtnClick(index - 1)
  end)
  if getState == DataModel.stateType.canNotGet then
    element.Txt_TargetNum:SetColor("#B9B9B9")
    element.Txt_Stage:SetColor("#B9B9B9")
    element.Txt_QuestDes:SetColor("#B9B9B9")
  elseif getState == DataModel.stateType.canGet then
    element.Txt_TargetNum:SetColor("#FFFFFF")
    element.Txt_Stage:SetColor("#FF2B2B")
    element.Txt_QuestDes:SetColor("#FFFFFF")
  elseif getState == DataModel.stateType.hasGet then
    element.Txt_TargetNum:SetColor("#B9B9B9")
    element.Txt_Stage:SetColor("#B9B9B9")
    element.Txt_QuestDes:SetColor("#B9B9B9")
  end
end

function Controller.RefreshRewardElement(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  local bookInfo = DataModel.GetBookInfo()
  if not bookInfo then
    return
  end
  local index = tonumber(element.ParentParam)
  local stageList = bookInfo.stageList or {}
  local stageInfo = stageList[index]
  if not stageInfo then
    return
  end
  local ca = PlayerData:GetFactoryData(stageInfo.id, "ListFactory")
  if ca then
    local rankDailyList = ca.rewardList or {}
    if rankDailyList[elementIndex] then
      BtnItem:SetItem(element.Group_CommonItem, {
        id = rankDailyList[elementIndex].id,
        num = rankDailyList[elementIndex].num
      })
      element.Group_CommonItem.Btn_Item:SetClickParam(rankDailyList[elementIndex].id)
    end
  end
end

function Controller.OnGetRewardBtnClick(index)
  local protoName = DataModel.GetProtoName()
  Net:SendProto(protoName, function(json)
    if string.nilorempty(json.rc) then
      if json.reward and table.count(json.reward) > 0 then
        CommonTips.OpenShowItem(json.reward)
      end
      DataModel.SetRewardHasGet(index)
      Controller.RefreshScrollShow()
    end
  end, index)
end

return Controller
