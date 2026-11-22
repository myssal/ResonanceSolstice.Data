local View = require("UIHomeUpgrade/UIHomeUpgradeView")
local DataModel = require("UIHomeUpgrade/UIHomeUpgradeDataModel")
local Controller = {}

local function CalRubbishChannelCnt(level)
  local homeCfg = PlayerData:GetFactoryData(99900014)
  local channelCnt = 1
  for i, v in ipairs(homeCfg.openLevelList) do
    if level >= v.Level then
      channelCnt = v.Num
    end
  end
  return channelCnt
end

function Controller:Init()
  local furCA = PlayerData:GetFactoryData(DataModel.curFurId, "HomeFurnitureFactory")
  local afterFurCA = PlayerData:GetFactoryData(furCA.upgrade, "HomeFurnitureFactory")
  local wasteoutputShow = furCA.wasteoutput > 0
  local yinuooutputShow = 0 < furCA.yinuooutput
  local pgId = CommonCoachData.GetPlaygroundId()
  View.Img_UpgradeBG.Group_PlaygroundTitle:SetActive(pgId ~= nil)
  View.Img_UpgradeBG.Group_Playground:SetActive(pgId ~= nil)
  DataModel.canLvUp = true
  if pgId ~= nil then
    local playgroundCA = PlayerData:GetFactoryData(pgId)
    View.Img_UpgradeBG.Group_Playground.Txt_Attribute:SetText(string.format(GetText(playgroundCA.lvLimitText), furCA.playgroundLv or 1))
    if CommonCoachData.GetCurPlaygroundServerInfo(pgId).lv < furCA.playgroundLv then
      DataModel.canLvUp = false
    end
  end
  View.Img_UpgradeBG.Group_Title.Txt_Title:SetText(furCA.name)
  View.Img_UpgradeBG.Group_Level.Txt_LevelBefore:SetText(furCA.Level)
  View.Img_UpgradeBG.Group_Level.Txt_NumAfter:SetText(afterFurCA.Level)
  View.Img_UpgradeBG.Group_Attribute1.self:SetActive(0 < furCA.comfort)
  View.Img_UpgradeBG.Group_Attribute1.Txt_ScoresBefore:SetText(furCA.comfort)
  View.Img_UpgradeBG.Group_Attribute1.Txt_ScoresAfter:SetText(afterFurCA.comfort)
  View.Img_UpgradeBG.Group_Attribute2.self:SetActive(0 < furCA.foodScores)
  View.Img_UpgradeBG.Group_Attribute2.Txt_ScoresBefore:SetText(furCA.foodScores)
  View.Img_UpgradeBG.Group_Attribute2.Txt_ScoresAfter:SetText(afterFurCA.foodScores)
  View.Img_UpgradeBG.Group_Attribute3.self:SetActive(0 < furCA.playScores)
  View.Img_UpgradeBG.Group_Attribute3.Txt_ScoresBefore:SetText(furCA.playScores)
  View.Img_UpgradeBG.Group_Attribute3.Txt_ScoresAfter:SetText(afterFurCA.playScores)
  View.Img_UpgradeBG.Group_Attribute4.self:SetActive(0 < furCA.plantScores)
  View.Img_UpgradeBG.Group_Attribute4.Txt_ScoresBefore:SetText(furCA.plantScores)
  View.Img_UpgradeBG.Group_Attribute4.Txt_ScoresAfter:SetText(afterFurCA.plantScores)
  View.Img_UpgradeBG.Group_Attribute5.self:SetActive(0 < furCA.petScores)
  View.Img_UpgradeBG.Group_Attribute5.Txt_ScoresBefore:SetText(furCA.petScores)
  View.Img_UpgradeBG.Group_Attribute5.Txt_ScoresAfter:SetText(afterFurCA.petScores)
  View.Img_UpgradeBG.Group_Attribute6.self:SetActive(0 < furCA.fishScores)
  View.Img_UpgradeBG.Group_Attribute6.Txt_ScoresBefore:SetText(furCA.fishScores)
  View.Img_UpgradeBG.Group_Attribute6.Txt_ScoresAfter:SetText(afterFurCA.fishScores)
  local outputProbability = furCA.PrisonExtraOutputProbability or 0
  local afterOutputProbability = afterFurCA.PrisonExtraOutputProbability or 0
  View.Img_UpgradeBG.Group_PrisonExtraProduce.self:SetActive(0 < outputProbability)
  View.Img_UpgradeBG.Group_PrisonExtraProduce.Txt_ScoresBefore:SetText(math.floor(outputProbability * 100) .. "%")
  View.Img_UpgradeBG.Group_PrisonExtraProduce.Txt_ScoresAfter:SetText(math.floor(afterOutputProbability * 100) .. "%")
  local configCA = PlayerData:GetFactoryData(99900061, "ConfigFactory")
  local seatPrice = 0
  local upgradeSeatPrice = 0
  local priceInfo = configCA[furCA.setPriceType]
  if priceInfo then
    seatPrice = priceInfo[furCA.Level].price
    upgradeSeatPrice = priceInfo[afterFurCA.Level].price
  end
  View.Img_UpgradeBG.Group_SeatPrice.self:SetActive(0 < seatPrice)
  View.Img_UpgradeBG.Group_SeatPrice.Txt_ScoresBefore:SetText(string.format(GetText(80602069), seatPrice))
  View.Img_UpgradeBG.Group_SeatPrice.Txt_ScoresAfter:SetText(string.format(GetText(80602069), upgradeSeatPrice))
  local trustUp = furCA.trustUp or 0
  View.Img_UpgradeBG.Group_TrustUp.self:SetActive(0 < trustUp)
  View.Img_UpgradeBG.Group_TrustUp.Txt_ScoresBefore:SetText(string.format(GetText(80602068), trustUp))
  View.Img_UpgradeBG.Group_TrustUp.Txt_ScoresAfter:SetText(string.format(GetText(80602068), afterFurCA.trustUp or 0))
  View.Img_UpgradeBG.Group_Output1.self:SetActive(wasteoutputShow)
  View.Img_UpgradeBG.Group_Output1.Txt_ScoresBefore:SetText(string.format(GetText(80600743), furCA.wasteoutput))
  View.Img_UpgradeBG.Group_Output1.Txt_ScoresAfter:SetText(string.format(GetText(80600743), afterFurCA.wasteoutput))
  View.Img_UpgradeBG.Group_Output2.self:SetActive(yinuooutputShow)
  View.Img_UpgradeBG.Group_Output2.Txt_ScoresBefore:SetText(string.format(GetText(80600744), furCA.yinuooutput))
  View.Img_UpgradeBG.Group_Output2.Txt_ScoresAfter:SetText(string.format(GetText(80600744), afterFurCA.yinuooutput))
  local costInfo = furCA.upgradeCostList
  DataModel.CostItems = costInfo
  View.Img_UpgradeBG.Group_MaterialsItem.ScrollGrid_Materials.grid.self:SetStartCorner("Center")
  View.Img_UpgradeBG.Group_MaterialsItem.ScrollGrid_Materials.grid.self:SetDataCount(#costInfo)
  View.Img_UpgradeBG.Group_MaterialsItem.ScrollGrid_Materials.grid.self:RefreshAllElement()
  View.Img_UpgradeBG.Group_Rubbish:SetActive(false)
  View.Img_UpgradeBG.Group_RubbishObtain:SetActive(false)
  View.Img_UpgradeBG.Group_RubbishTime:SetActive(false)
  View.Img_UpgradeBG.Group_RubbishStore:SetActive(false)
  View.Img_UpgradeBG.Group_RubbishStoreMax:SetActive(false)
  if furCA.functionType == 12600474 then
    View.Img_UpgradeBG.Group_Rubbish:SetActive(true)
    View.Img_UpgradeBG.Group_RubbishTime:SetActive(true)
    View.Img_UpgradeBG.Group_RubbishObtain:SetActive(true)
    View.Img_UpgradeBG.Group_RubbishStore:SetActive(true)
    View.Img_UpgradeBG.Group_RubbishStoreMax:SetActive(true)
    local nowChannelCnt = CalRubbishChannelCnt(furCA.Level)
    local nextLevelChannelCnt = CalRubbishChannelCnt(afterFurCA.Level)
    View.Img_UpgradeBG.Group_Rubbish.Txt_ScoresBefore:SetText(string.format(GetText(80601576), nowChannelCnt))
    View.Img_UpgradeBG.Group_Rubbish.Txt_ScoresAfter:SetText(string.format(GetText(80601576), nextLevelChannelCnt))
    View.Img_UpgradeBG.Group_RubbishTime.Txt_ScoresBefore:SetText(furCA.compressionTime .. "s")
    View.Img_UpgradeBG.Group_RubbishTime.Txt_ScoresAfter:SetText(afterFurCA.compressionTime .. "s")
    local homeCfg = PlayerData:GetFactoryData(99900014)
    local nowObtainType = furCA.Level < homeCfg.autoModeLevel and GetText(80601890) or GetText(80601889)
    local NextObtainType = afterFurCA.Level < homeCfg.autoModeLevel and GetText(80601890) or GetText(80601889)
    View.Img_UpgradeBG.Group_RubbishObtain.Txt_ScoresBefore:SetText(nowObtainType)
    View.Img_UpgradeBG.Group_RubbishObtain.Txt_ScoresAfter:SetText(NextObtainType)
    View.Img_UpgradeBG.Group_RubbishStore.Txt_ScoresBefore:SetText(furCA.StoreRubbish)
    View.Img_UpgradeBG.Group_RubbishStore.Txt_ScoresAfter:SetText(afterFurCA.StoreRubbish)
    View.Img_UpgradeBG.Group_RubbishStoreMax.Txt_ScoresBefore:SetText(furCA.StoreRubbishMax)
    View.Img_UpgradeBG.Group_RubbishStoreMax.Txt_ScoresAfter:SetText(afterFurCA.StoreRubbishMax)
  end
end

function Controller:DoUpGrade(callBack)
  local items = {}
  for k, v in pairs(DataModel.CostItems) do
    if v.num > PlayerData:GetGoodsById(v.id).num then
      CommonTips.OpenTips(80600696)
      return
    end
    items[v.id] = v.num
  end
  local netName = "furniture.upgrade"
  local isCoach = true
  local pgId = CommonCoachData.GetPlaygroundId()
  if pgId ~= nil then
    netName = "playground.upgrade"
    isCoach = false
    if not DataModel.canLvUp then
      local playgroundCA = PlayerData:GetFactoryData(pgId)
      CommonTips.OpenTips(playgroundCA.lvLimitTips)
      return
    end
  end
  Net:SendProto(netName, function(json)
    PlayerData:RefreshUseItems(items)
    local furCA = PlayerData:GetFactoryData(DataModel.curFurId, "HomeFurnitureFactory")
    local isPrisonProductFur = furCA.isPrison
    local serverData
    if isPrisonProductFur then
      serverData = PlayerData.ServerData.user_prison_info.furniture[tostring(DataModel.curFurUfid)]
    else
      serverData = CommonCoachData.GetFurData(furCA.bag)[DataModel.curFurUfid]
    end
    if HomeManager:GetFurnitureByUfid(DataModel.curFurUfid) then
      local UIMainUIDataModel = require("UIMainUI/UIMainUIDataModel")
      local roomIndex = UIMainUIDataModel.GetRoomIndexByUCid(serverData.u_cid)
      if roomIndex then
        HomeManager:UpGradeFurniture(roomIndex, DataModel.curFurUfid, furCA.upgrade)
      end
    end
    if isCoach then
      PlayerData.RefreshFurSkillData(serverData, true)
    end
    serverData.id = tostring(furCA.upgrade)
    if isCoach then
      PlayerData.RefreshFurSkillData(serverData)
    end
    if UIManager:GetPanel("UI/MainUI/MainUI") and UIManager:GetPanel("UI/MainUI/MainUI").IsActive then
      local UIMainUIView = require("UIMainUI/UIMainUIView")
      UIMainUIView.Group_Common.Group_TopLeft.Btn_Gold.Txt_Num:SetText(PlayerData:GetUserInfo().gold)
    end
    CommonCoachData.RefreshData()
    local homeCoachDataModel = require("UIHomeCoach/UIHomeCoachDataModel")
    homeCoachDataModel.InitRoomData()
    local isPrison = false
    local machineTypeList = PlayerData:GetFactoryData("99900014").prisonMachineList
    for i, v in ipairs(machineTypeList) do
      if v.id == furCA.type then
        isPrison = true
        break
      end
    end
    local afterFurCA = PlayerData:GetFactoryData(furCA.upgrade, "HomeFurnitureFactory")
    if json.reward ~= nil and #json.reward > 0 then
      CommonTips.OpenShowItem(json.reward, function()
        UIManager:Open("UI/HomeUpgrade/UpgradeSuccess", Json.encode({
          beforeNum = furCA.Level,
          afterNum = afterFurCA.Level,
          isPrison = isPrison
        }))
      end)
    else
      UIManager:Open("UI/HomeUpgrade/UpgradeSuccess", Json.encode({
        beforeNum = furCA.Level,
        afterNum = afterFurCA.Level,
        isPrison = isPrison
      }))
    end
    if callBack then
      callBack()
    end
  end, DataModel.curFurUfid, pgId)
end

return Controller
