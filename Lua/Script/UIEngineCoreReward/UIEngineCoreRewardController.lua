local View = require("UIEngineCoreReward/UIEngineCoreRewardView")
local DataModel = require("UIEngineCoreReward/UIEngineCoreRewardDataModel")
local BtnItem = require("Common/BtnItem")
local Controller = {
  curSelectTabIndex = 1,
  curCoreConfig = nil,
  curCoreLvList = nil
}

function Controller.Init()
  Controller.RefreshTagListShow()
  Controller.OnTabClick(1)
end

function Controller.RefreshTagListShow()
  local coreList = DataModel.GetCoreList()
  if not coreList then
    return
  end
  View.ScrollGrid_Tab.grid.self:SetDataCount(#coreList)
  View.ScrollGrid_Tab.grid.self:RefreshAllElement()
end

function Controller.RefreshCoreElementShow(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  local coreList = DataModel.GetCoreList()
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
  element.Group_Off.Img_Icon:SetSprite(coreConfig.rewardIconPath)
  element.Group_On.Img_Icon:SetSprite(coreConfig.rewardIconPath)
  element.Group_Off.Txt_Name:SetText(GetText(coreConfig.name))
  element.Group_On.Txt_Name:SetText(GetText(coreConfig.name))
  local isHasRed = DataModel.GetIsHasRedDotByCoreId(coreInfo.id)
  element.Img_RedPoint:SetActive(isHasRed)
  local isSelect = elementIndex == Controller.curSelectTabIndex
  element.Group_Off:SetActive(not isSelect)
  element.Group_On:SetActive(isSelect)
  element.Btn_:SetClickFunction(function()
    Controller.OnTabClick(elementIndex)
  end)
end

function Controller.OnTabClick(elementIndex)
  Controller.curSelectTabIndex = elementIndex
  View.ScrollGrid_Tab.grid.self:RefreshAllElement()
  local coreList = DataModel.GetCoreList()
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
  Controller.curCoreConfig = coreConfig
  View.Img_Bg:SetSprite(coreConfig.rewardBgPath)
  View.Img_Icon:SetSprite(coreConfig.rewardIconPath)
  View.Txt_Name:SetText(GetText(coreConfig.name))
  local lv = DataModel.GetCurCoreLevel(coreInfo.id) or 1
  View.Txt_Name.Txt_Grade:SetText(tostring(lv))
  Controller.RefreshContentListShow()
end

function Controller.RefreshContentListShow()
  if not Controller.curCoreConfig then
    return
  end
  local coreLvList = DataModel.GetCoreLvListById(Controller.curCoreConfig.id) or {}
  Controller.curCoreLvList = coreLvList
  View.ScrollGrid_List.grid.self:SetDataCount(#coreLvList)
  View.ScrollGrid_List.grid.self:RefreshAllElement()
end

function Controller.RefreshCoreLvRewardElement(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  if not Controller.curCoreLvList then
    return
  end
  local lvInfo = Controller.curCoreLvList[elementIndex]
  if not lvInfo then
    return
  end
  local lvStr = string.format(GetText(80611066), lvInfo.lv)
  local nameStr = GetText(Controller.curCoreConfig.rewardDes)
  element.Group_Can.Txt_Name:SetText(nameStr)
  element.Group_Can.Txt_Grade:SetText(lvStr)
  element.Group_Not.Txt_Name:SetText(nameStr)
  element.Group_Not.Txt_Grade:SetText(lvStr)
  element.Group_Complete.Txt_Name:SetText(nameStr)
  element.Group_Complete.Txt_Grade:SetText(lvStr)
  local tempListCA = PlayerData:GetFactoryData(lvInfo.id, "ListFactory")
  if tempListCA and #tempListCA.EngineRewardList > 0 then
    element.Group_Reward.ScrollGrid_Reward.grid.self:SetParentParam(elementIndex)
    element.Group_Reward.ScrollGrid_Reward.grid.self:SetDataCount(#tempListCA.EngineRewardList)
    element.Group_Reward.ScrollGrid_Reward.grid.self:RefreshAllElement()
  end
  local rewardState = DataModel.GetLvRewardStateByIdAndLv(Controller.curCoreConfig.id, lvInfo.lv)
  element.Group_Can:SetActive(rewardState == DataModel.rewardState.canGet)
  element.Group_Can:SetActive(rewardState == DataModel.rewardState.canGet)
  element.Group_Not:SetActive(rewardState == DataModel.rewardState.canNot)
  element.Group_Not:SetActive(rewardState == DataModel.rewardState.canNot)
  element.Group_Complete:SetActive(rewardState == DataModel.rewardState.hasGet)
  element.Group_Complete:SetActive(rewardState == DataModel.rewardState.hasGet)
  local bgPath = rewardState == DataModel.rewardState.canGet and Controller.curCoreConfig.rewardGetPath or Controller.curCoreConfig.rewardNotPath
  element.Img_BG:SetSprite(bgPath)
  element.Group_Can.Btn_Click:SetClickFunction(function()
    Controller.OnGetCoreRewardClick(lvInfo)
  end)
end

function Controller.RefreshRewardElement(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  if not Controller.curCoreLvList then
    return
  end
  local index = tonumber(element.ParentParam)
  local lvInfo = Controller.curCoreLvList[index]
  if not lvInfo then
    return
  end
  local tempListCA = PlayerData:GetFactoryData(lvInfo.id, "ListFactory")
  if not tempListCA then
    return
  end
  local rewardList = tempListCA.EngineRewardList
  if not rewardList then
    return
  end
  local rewardInfo = rewardList[elementIndex]
  if not rewardInfo then
    return
  end
  BtnItem:SetItem(element.Group_Item, {
    id = rewardInfo.id,
    num = rewardInfo.num
  })
  element.Group_Item.Btn_Item:SetClickFunction(function()
    CommonTips.OpenPreItemTips({
      itemId = rewardInfo.id
    })
  end)
end

function Controller.OnGetCoreRewardClick(lvInfo)
  if not lvInfo or not Controller.curCoreConfig then
    return
  end
  Net:SendProto("core.rec_reward", function(json)
    if string.nilorempty(json.rc) then
      CommonTips.OpenShowItem(json.reward)
      local serverInfo = PlayerData.ServerData.engines[tostring(Controller.curCoreConfig.id)]
      if serverInfo.lv_reward == nil then
        serverInfo.lv_reward = {}
      end
      table.insert(serverInfo.lv_reward, lvInfo.lv - 1)
      local redName = RedpointTree.NodeNames.Core .. "|" .. Controller.curCoreConfig.id .. "|" .. lvInfo.lv
      RedpointTree:ChangeRedpointCnt(redName, -1)
      RedpointTree:DeleteNode(redName)
      View.ScrollGrid_Tab.grid.self:RefreshAllElement()
      Controller.RefreshContentListShow()
      if DataModel.isOpenedByActivityPanel then
        local ActivityMainController = require("UIActivityMain/UIActivityMainController")
        if ActivityMainController then
          ActivityMainController:RefreshLeftRedState()
        end
      end
    end
  end, Controller.curCoreConfig.id, lvInfo.lv - 1)
end

return Controller
