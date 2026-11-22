local View = require("UICommonRewards/UICommonRewardsView")
local DataModel = require("UICommonRewards/UICommonRewardsDataModel")
local Controller = {}

function Controller.Init()
  Controller.RefreshCenterShow()
  local initIndex = DataModel.GetFirstOpenIndex() or 0
  if 0 < initIndex then
    View.ScrollGrid_LevelList.grid.self:MoveToPos(initIndex)
  end
  View.Img_Title:SetSprite(PlayerData:GetFactoryData(88300192).filePath)
end

function Controller.RefreshCenterShow()
  local lv = DataModel.GetCubeRewardLv() or 0
  View.Group_Level.Txt_Level:SetText(tostring(lv))
  local expNow = DataModel.GetShowExpCount() or 0
  local nextExp = DataModel.GetLvCostExpByIndex(lv + 1) or 0
  expNow = expNow < 0 and 0 or expNow
  local radio = expNow / (0 < nextExp and nextExp or 1)
  View.Group_Level.Img_Progress.Img_Bar:SetFilledImgAmount(radio)
  View.Group_Level.Group_Experience.Txt_Current:SetText(tostring(expNow))
  View.Group_Level.Group_Experience.Txt_Limit:SetText(tostring(nextExp))
  if DataModel.lvRewardList and 0 < #DataModel.lvRewardList then
    View.ScrollGrid_LevelList.grid.self:SetDataCount(#DataModel.lvRewardList)
    View.ScrollGrid_LevelList.grid.self:RefreshAllElement()
  end
end

function Controller.RefreshLvElement(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  if not DataModel.lvRewardList then
    return
  end
  local lvInfo = DataModel.lvRewardList[elementIndex]
  if not lvInfo then
    return
  end
  local numStr = ""
  if lvInfo.id == 11400001 then
    numStr = tostring(PlayerData:TransitionNum(lvInfo.num))
  else
    numStr = tostring(lvInfo.num)
  end
  element.Btn_Rewards.Txt_Num:SetText(numStr)
  element.Txt_Level:SetText(tostring(elementIndex))
  local itemInfo = PlayerData:GetFactoryData(lvInfo.id, "ItemFactory")
  if itemInfo then
    element.Btn_Rewards.Img_Item:SetSprite(string.nilorempty(itemInfo.iconPath) and itemInfo.imagePath or itemInfo.iconPath)
  end
  local getState = DataModel.GetLvRewardState(elementIndex)
  if getState == DataModel.lvState.hasGet then
    element.Group_Bg.Group_Claimed:SetActive(true)
    element.Group_Bg.Group_Claimable:SetActive(false)
    element.Group_Bg.Group_UnClaimable:SetActive(false)
    element.Group_Deco.Group_Claimed:SetActive(true)
    element.Group_Deco.Group_Claimable:SetActive(false)
    element.Group_Deco.Group_Unclaimable:SetActive(false)
    element.Btn_ClaimAll:SetActive(false)
  elseif getState == DataModel.lvState.canGet then
    element.Group_Bg.Group_Claimed:SetActive(false)
    element.Group_Bg.Group_Claimable:SetActive(true)
    element.Group_Bg.Group_UnClaimable:SetActive(false)
    element.Group_Deco.Group_Claimed:SetActive(false)
    element.Group_Deco.Group_Claimable:SetActive(true)
    element.Group_Deco.Group_Unclaimable:SetActive(false)
    element.Btn_ClaimAll:SetActive(true)
  else
    element.Group_Bg.Group_Claimed:SetActive(false)
    element.Group_Bg.Group_Claimable:SetActive(false)
    element.Group_Bg.Group_UnClaimable:SetActive(true)
    element.Group_Deco.Group_Claimed:SetActive(false)
    element.Group_Deco.Group_Claimable:SetActive(false)
    element.Group_Deco.Group_Unclaimable:SetActive(true)
    element.Btn_ClaimAll:SetActive(false)
  end
  element.Btn_Rewards:SetClickFunction(function()
    CommonTips.OpenRewardDetail(lvInfo.id)
  end)
  element.Btn_ClaimAll:SetClickFunction(function()
    Controller.ReqGetAllReward()
  end)
end

function Controller.ReqGetAllReward()
  Net:SendProto("cube.lv_reward", function(json)
    if string.nilorempty(json.rc) then
      CommonTips.OpenShowItem(json.reward)
      DataModel.SetCubeRewardGotLv(DataModel.GetCubeRewardLv())
      View.ScrollGrid_LevelList.grid.self:RefreshAllElement()
    end
  end)
end

return Controller
