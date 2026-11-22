local View = require("UIDepthSelection/UIDepthSelectionView")
local DataModel = require("UIDepthSelection/UIDepthSelectionDataModel")
local BtnItem = require("Common/BtnItem")
local Controller = {}

function Controller:Init()
  if DataModel.cubeId == nil then
    DataModel.cubeId = 89400002
  end
  local cubeCA = PlayerData:GetFactoryData(DataModel.cubeId)
  DataModel.cubeCA = cubeCA
  DataModel.curDiffIndex = 1
  if DataModel.initIndex ~= nil then
    DataModel.curDiffIndex = DataModel.initIndex
  else
    for i = #cubeCA.rogueDifficultList, 1, -1 do
      if Controller:IsDifficultyUnlock(i) then
        DataModel.curDiffIndex = i
        break
      end
    end
  end
  View.ScrollView_Main.Viewport.Content.StaticGrid_Level.grid.self:SetDataCount(#cubeCA.rogueDifficultList)
  View.ScrollView_Main.Viewport.Content.StaticGrid_Level.grid.self:RefreshAllElement()
  Controller:RefreshCurDiffInfo()
  local initContentPos = 0
  if DataModel.curDiffIndex > 4 then
    initContentPos = -874
  end
  View.ScrollView_Main.Viewport.Content.self:SetAnchoredPositionX(initContentPos)
end

function Controller:OnSetLevelGrid(element, elementIndex)
  local cubeCA = DataModel.cubeCA
  local levelData = cubeCA.rogueDifficultList[elementIndex]
  element.Group_Active:SetActive(elementIndex == DataModel.curDiffIndex)
  if elementIndex == DataModel.curDiffIndex then
    element.Group_Active.Group_EXP.Group_Num.Txt_Num:SetText(levelData.settlementCoefficient)
    element.Group_Active.Group_Point.Group_Num.Txt_Num:SetText(levelData.weeklyExperience)
  end
  local isLevelUnlock = self:IsDifficultyUnlock(elementIndex)
  element.Btn_Defult:SetClickParam(elementIndex)
  element.Img_Unlock:SetActive(not isLevelUnlock)
  if 1 < elementIndex then
    local line = View.ScrollView_Main.Viewport.Content.Group_Line.StaticGrid_Line.grid[elementIndex - 1]
    if line ~= nil then
      line:SetActive(isLevelUnlock)
    end
  end
end

function Controller:RefreshCurDiffInfo()
  local index = DataModel.curDiffIndex
  local cubeCA = DataModel.cubeCA
  local levelData = cubeCA.rogueDifficultList[index]
  local rewardCA = PlayerData:GetFactoryData(levelData.id)
  View.Img_Reward.ScrollGrid_Reward.self:SetActive(true)
  View.Img_Reward.ScrollGrid_Reward.grid.self:SetDataCount(#rewardCA.rewardList)
  View.Img_Reward.ScrollGrid_Reward.grid.self:RefreshAllElement()
  local isExtraDiffcult = levelData.isDifficult
  View.Btn_Descent:SetActive(isExtraDiffcult)
  if isExtraDiffcult then
    local val = 0
    local buffMap = {}
    if next(PlayerData.TempCache.CubeRogueData.debuff) then
      for k, v in pairs(PlayerData.TempCache.CubeRogueData.debuff) do
        local orderCA = PlayerData:GetFactoryData(k)
        if orderCA and buffMap[orderCA.descent] ~= true then
          buffMap[orderCA.descent] = true
          local buffCA = PlayerData:GetFactoryData(orderCA.descent)
          if buffCA then
            val = val + buffCA.descent
          end
        end
      end
    else
      local str = PlayerData:GetPlayerPrefs("string", "CubeDebuff")
      local curBuffList = string.split(str, ",")
      for j = 1, #curBuffList do
        if buffMap[curBuffList[j]] ~= true then
          buffMap[curBuffList[j]] = true
          local buffCA = PlayerData:GetFactoryData(curBuffList[j])
          if buffCA then
            val = val + buffCA.descent
          end
        end
      end
      Net:SendProto("cube.debuff", function(json)
      end, str)
    end
    View.Btn_Descent.Txt_Num:SetText(val)
  end
  local enemyLevel = levelData.enemyLv
  View.Btn_Start.Group_LV.Txt_Num:SetText(enemyLevel)
end

function Controller:OnSetRewardGrid(element, elementIndex)
  local index = DataModel.curDiffIndex
  local cubeCA = DataModel.cubeCA
  local levelData = cubeCA.rogueDifficultList[index]
  local rewardCA = PlayerData:GetFactoryData(levelData.id)
  local itemData = rewardCA.rewardList[elementIndex]
  BtnItem:SetItem(element, itemData)
  element.Btn_Item:SetClickParam(itemData.id)
  local isFinish = Controller:IsDiffcultyFinished(DataModel.curDiffIndex)
  element.Img_GainedMask:SetActive(isFinish)
end

function Controller:OnBtnLevel(index)
  if not self:IsDifficultyUnlock(index) then
    return
  end
  DataModel.curDiffIndex = index
  View.ScrollView_Main.Viewport.Content.StaticGrid_Level.grid.self:RefreshAllElement()
  Controller:RefreshCurDiffInfo()
end

function Controller:OnBtnStart()
  PlayerData.TempCache.RogueCache = {}
  PlayerData.TempCache.RogueCache.cubeId = DataModel.cubeId
  PlayerData.TempCache.RogueCache.difficulty = DataModel.curDiffIndex - 1
  Net:SendProto("cube.difficulty", function(json)
    PlayerData.TempCache.CubeRogueData.difficulty = DataModel.curDiffIndex - 1
    UIManager:Open("UI/CubeRogue/TacticsSelection/TacticsSelection_New", Json.encode({
      id = DataModel.cubeId,
      hasPrePanel = true
    }))
  end, DataModel.curDiffIndex - 1)
end

function Controller:IsDiffcultyFinished(diff)
  local compDiff = PlayerData.TempCache.CubeRogueData.comp_diff or -1
  return compDiff >= diff - 1
end

function Controller:IsDifficultyUnlock(diff)
  if diff == 1 or self:IsDiffcultyFinished(diff - 1) then
    return true
  end
  return false
end

return Controller
