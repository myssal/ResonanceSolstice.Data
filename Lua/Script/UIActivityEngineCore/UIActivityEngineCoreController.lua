local DataModel = require("UIActivityEngineCore/UIActivityEngineCoreDataModel")
local View = require("UIActivityEngineCore/UIActivityEngineCoreView")
local CoreRew_Model = require("UIEngineCoreReward/UIEngineCoreRewardDataModel")
local Controller = {}

function Controller.Init()
  Controller.RefreshCoreListShow()
  Controller.RefreshRewardPartShow()
end

function Controller.RefreshCoreListShow()
  local coreList = CoreRew_Model.GetCoreList()
  if not coreList then
    return
  end
  local count = 5 < #coreList and 5 or #coreList
  View.Group_Right.Group_CoreLevel.Img_Contain.StaticGrid_Corelist.grid.self:SetDataCount(count)
  View.Group_Right.Group_CoreLevel.Img_Contain.StaticGrid_Corelist.grid.self:RefreshAllElement()
end

function Controller.RefreshCoreListElement(element, elementIndex)
  if not elementIndex or not element then
    return
  end
  local coreList = CoreRew_Model.GetCoreList()
  if not coreList then
    return
  end
  local coreInfo = coreList[elementIndex]
  if not coreInfo then
    return
  end
  local coreConfig = PlayerData:GetFactoryData(coreInfo.id, "EngineCoreFactory")
  if not coreConfig then
    return
  end
  element.Img_Contain.Img_Icon:SetSprite(coreConfig.coreIconPath)
  element.Img_Name.Txt_Name:SetText(GetText(coreConfig.name))
  local curLv = CoreRew_Model.GetCurCoreLevel(coreInfo.id) or 1
  element.Img_Contain.Group_LV.Txt_Num:SetText(string.format(GetText(80611066), curLv))
end

function Controller.RefreshRewardPartShow()
  local hasGetCount = CoreRew_Model.GetHasGetRewardCount()
  local isCanGet = CoreRew_Model.GetCoreRewardRedState()
  View.Group_Reward.Txt_Schedule:SetText(string.format(GetText(80611037), hasGetCount))
  View.Group_Reward.Group_Not:SetActive(not isCanGet)
  View.Group_Reward.Group_Can:SetActive(isCanGet)
end

function Controller.OnRewardBtnClick()
  UIManager:Open("UI/Activity/ActivityEngineCore/EngineCoreReward", Json.encode({isOpenedByActivityPanel = true}))
end

function Controller.OnSkipBtnClick()
  local openUi = DataModel.GetSkipPanelStr()
  if not string.nilorempty(openUi) then
    UIManager:Open(openUi)
  end
end

return Controller
