local DataModel = require("UIMonopolyGrade/UIMonopolyGradeDataModel")
local View = require("UIMonopolyGrade/UIMonopolyGradeView")
local MonopolyManager = require("UIMonopoly/LuaMonopolyManager")
local BtnItem = require("Common/BtnItem")
local MainManager = require("UIMonopolyMain/UIMonopolyMainManager")
local UIMonopolyGradeController = {
  gameGradeList = {},
  openSound = nil
}

function UIMonopolyGradeController.Init()
  DataModel.InitMapGradeInfo()
  UIMonopolyGradeController.RefreshContentShow()
  UIMonopolyGradeController.PlayOpenSound()
end

function UIMonopolyGradeController.Release()
end

function UIMonopolyGradeController.PlayOpenSound()
  local sound = SoundManager:CreateSound(30006378)
  if sound then
    sound:Play()
  end
end

function UIMonopolyGradeController.RefreshContentShow()
  local mapId = PlayerData.GetUserMonopolyId()
  local ca = PlayerData:GetFactoryData(mapId, "MonopolyGameMapFactory")
  if not ca then
    return
  end
  local lv = DataModel.GetLv()
  local coin = DataModel.GetExp()
  local nextCost = DataModel.GetNextCost()
  View.Group_LV.Group_Num.Txt_Num:SetText(tostring(lv))
  local ratio = coin / (nextCost == 0 and 1 or nextCost)
  View.Group_LV.Group_Bar.Group_EXP.Txt_Present:SetText(tostring(coin))
  View.Group_LV.Group_Bar.Group_EXP.Txt_Max:SetText(tostring(nextCost))
  View.Group_LV.Group_Bar.Img_Bar.Img_Fill:SetFilledImgAmount(ratio)
  UIMonopolyGradeController.gameGradeList = ca.gameGradeList or {}
  if 0 < #UIMonopolyGradeController.gameGradeList then
    View.NewScrollGrid_RewardList.grid.self:StartC(LuaUtil.cs_generator(function()
      coroutine.yield(CS.UnityEngine.WaitForEndOfFrame())
      View.NewScrollGrid_RewardList.grid.self:SetDataCount(#UIMonopolyGradeController.gameGradeList)
      View.NewScrollGrid_RewardList.grid.self:RefreshAllElement()
      View.NewScrollGrid_RewardList.grid.self:MoveToPos(lv)
    end))
  end
  UIMonopolyGradeController.RefreshAllGetBtnState()
end

function UIMonopolyGradeController.RefreshAllGetBtnState()
  local isHasReward = UIMonopolyGradeController.GetIsHasCanGetReward()
  if isHasReward then
    View.Btn_GetAll.Img_Able:SetActive(true)
    View.Btn_GetAll.Img_Unable:SetActive(false)
  else
    View.Btn_GetAll.Img_Able:SetActive(false)
    View.Btn_GetAll.Img_Unable:SetActive(true)
  end
end

function UIMonopolyGradeController.RefreshRankElement(element, elementIndex)
  if element == nil then
    return
  end
  local info = UIMonopolyGradeController.gameGradeList[elementIndex]
  if not info then
    return
  end
  local getState = UIMonopolyGradeController.GetGetBtnState(elementIndex)
  if getState == 1 then
    element.Img_Able:SetActive(false)
    element.Img_Mask:SetActive(false)
    element.Img_Unable:SetActive(true)
    element.Img_Unable.Group_LV.Txt_Num:SetText(tostring(elementIndex))
  elseif getState == 2 then
    element.Img_Unable:SetActive(false)
    element.Img_Mask:SetActive(false)
    element.Img_Able:SetActive(true)
    element.Img_Able.Group_LV.Txt_Num:SetText(tostring(elementIndex))
  elseif getState == 3 then
    element.Img_Unable:SetActive(false)
    element.Img_Mask:SetActive(true)
    element.Img_Able:SetActive(true)
    element.Img_Able.Group_LV.Txt_Num:SetText(tostring(elementIndex))
  end
  element.Img_Able.Btn_Get:SetClickParam(tostring(elementIndex))
  local ca = PlayerData:GetFactoryData(info.rewardId, "ListFactory")
  if ca then
    local rewardList = ca.rewardList or {}
    local count = 3 < #rewardList and 3 or #rewardList
    element.StaticGrid_Item.grid.self:SetParentParam(elementIndex)
    element.StaticGrid_Item.grid.self:SetDataCount(count)
    element.StaticGrid_Item.grid.self:RefreshAllElement()
  end
end

function UIMonopolyGradeController.RefreshRewardElement(element, elementIndex)
  local index = tonumber(element.ParentParam)
  local info = UIMonopolyGradeController.gameGradeList[index]
  if not info then
    return
  end
  local ca = PlayerData:GetFactoryData(info.rewardId, "ListFactory")
  if ca then
    local rankDailyList = ca.rewardList or {}
    if rankDailyList[elementIndex] then
      BtnItem:SetItem(element, {
        id = rankDailyList[elementIndex].id,
        num = rankDailyList[elementIndex].num
      })
      element.Btn_Item:SetClickParam(rankDailyList[elementIndex].id)
    end
  end
end

function UIMonopolyGradeController.GetGetBtnState(index)
  if index == 1 then
    return 1
  end
  if PlayerData.GetLvIndexRewardInGotList(index - 1) then
    return 3
  end
  if index <= DataModel.GetLv() then
    return 2
  end
  return 1
end

function UIMonopolyGradeController.OnQuitBtnClick()
  UIManager:ClosePanel()
  if not DataModel.isOpenByMap then
    MainManager.Init()
  end
end

function UIMonopolyGradeController.GetLVReward(index)
  PlayerData.SetLvIndexRewardToGotList(index)
  View.NewScrollGrid_RewardList.grid.self:RefreshAllElement()
end

function UIMonopolyGradeController.CheckMPYIsOver(json)
  MonopolyManager.CheckTimeIsOverAndBack()
end

function UIMonopolyGradeController.GetIsHasCanGetReward()
  UIMonopolyGradeController.gameGradeList = UIMonopolyGradeController.gameGradeList or {}
  for i = 1, #UIMonopolyGradeController.gameGradeList do
    local getState = UIMonopolyGradeController.GetGetBtnState(i)
    if getState == 2 then
      return true
    end
  end
  return false
end

function UIMonopolyGradeController.OnGetAllRewardBtnClick()
  local hasReward = UIMonopolyGradeController.GetIsHasCanGetReward()
  if not hasReward then
    CommonTips.OpenTips(80609855)
    return
  end
  Net:SendProto("monopoly.recv_monopoly_lv_reward", function(json)
    if string.nilorempty(json.rc) then
      UIManager:Open("UI/Monopoly/UI/ShowItem/MonopolyShowItem", Json.encode({
        rewards = json.reward,
        title = nil,
        ignoreCloseTime = true
      }), nil)
      UIMonopolyGradeController.gameGradeList = UIMonopolyGradeController.gameGradeList or {}
      local mpyLv = PlayerData.GetUserMonopolyLv() or 1
      for i = 1, mpyLv do
        PlayerData.SetLvIndexRewardToGotList(i - 1)
      end
      View.NewScrollGrid_RewardList.grid.self:RefreshAllElement()
      UIMonopolyGradeController.RefreshAllGetBtnState()
    end
  end, -99, function(json)
    if not string.nilorempty(json) then
      Controller.CheckMPYIsOver()
    end
  end)
end

return UIMonopolyGradeController
