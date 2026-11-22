local View = require("UIFastBattle/UIFastBattleView")
local DataModel = require("UIFastBattle/UIFastBattleDataModel")
local Controller = require("UIFastBattle/UIFastBattleController")
local Safe_Controller = require("UIFastBattle/UIFastBattleSafeController")
local RewardDataModel = require("UIFastBattle/UIFastBattleXSDataModel")
local RewardController = require("UIFastBattle/UIFastBattleXSController")
local Battle_Controller = require("UIFastBattle/UIFastBattleBattleController")
local Battle_DataModel = require("UIFastBattle/UIFastBattleBattleDataModel")
local ViewFunction = {
  FastBattle_Group_Ding_Btn_Energy_Click = function(btn, str)
    UIManager:Open("UI/Energy/Energy", nil, function()
      if Safe_Controller.refreshResourceFunc then
        Safe_Controller.refreshResourceFunc(1)
      end
    end)
  end,
  FastBattle_Group_Ding_Btn_Energy_Btn_Add_Click = function(btn, str)
  end,
  FastBattle_Group_Ding_Group_Tips_Btn_Tips_Click = function(btn, str)
    View.Group_Safa.Group_XS.Group_Tips.self:SetActive(true)
  end,
  FastBattle_Group_Ding_Group_ExpelTips_Btn__Click = function(btn, str)
    Controller.OnRewardBtnClick()
  end,
  FastBattle_Group_Safa_ScrollGrid_Tab_SetGrid = function(element, elementIndex)
    Controller.RefreshSafeStationElement(element, elementIndex)
  end,
  FastBattle_Group_Safa_ScrollGrid_Tab_Group_Item_Btn__Click = function(btn, str)
  end,
  FastBattle_Group_Safa_Group_Level_Group_Information_Group_Difficult_Btn_Difficult_Click = function(btn, str)
    if not DataModel.curLevelInfo then
      return
    end
    local index = tonumber(str)
    Safe_Controller.curLevelIndex = index
    View.Group_Safa.Group_Level.Group_Difficulty.self:SetActive(true)
    local info = DataModel.curLevelInfo[index]
    local levelConfig = PlayerData:GetFactoryData(info.levelId, "LevelFactory")
    local dropTableList = levelConfig.dropTableList
    DataModel.difficultyProgList = {}
    for i = 1, #dropTableList do
      DataModel.difficultyProgList[i] = (i - 1) / (#dropTableList - 1)
    end
    View.Group_Safa.Group_Level.Group_Difficulty.StaticGrid_Select.grid.self:SetDataCount(#dropTableList)
    View.Group_Safa.Group_Level.Group_Difficulty.StaticGrid_Select.grid.self:RefreshAllElement()
    View.Group_Safa.Group_Level.Group_Difficulty.Slider_Difficulty:SetSliderValue(DataModel.difficultyProgList[info.difficulty])
    View.Group_Safa.Group_Level.Group_Difficulty.Slider_BG:SetSliderValue(DataModel.difficultyProgList[info.difficulty])
    DataModel.curSliderIndex = nil
    Safe_Controller:OnSliderViewValChanged(DataModel.difficultyProgList[info.difficulty])
  end,
  FastBattle_Group_Safa_Group_Level_Group_Information_Group_Progress_Group_Schedule_Group_Right_Group_Reward_Btn__Click = function(btn, str)
    Safe_Controller:ClickRewardBox(btn, str)
  end,
  FastBattle_Group_Safa_Group_Level_Group_Information_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Safe_Controller:RefreshReward(element, elementIndex)
  end,
  FastBattle_Group_Safa_Group_Level_Group_Information_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  FastBattle_Group_Safa_Group_Level_Group_Information_Group_Battle_Group_Start_Group_Auto_Btn_Auto_Click = function(btn, str)
    Safe_Controller:OnClickBtnAuto()
  end,
  FastBattle_Group_Safa_Group_Level_Group_Information_Group_Battle_Group_Start_Btn_Battle_Click = function(btn, str)
    Safe_Controller:ClickBattle(str)
  end,
  FastBattle_Group_Safa_Group_Level_Group_Information_Group_Auto_Btn_Auto_Click = function(btn, str)
  end,
  FastBattle_Group_Safa_Group_Level_ScrollGrid_List_SetGrid = function(element, elementIndex)
    Safe_Controller:RefreshLevelElement(element, elementIndex)
  end,
  FastBattle_Group_Safa_Group_Level_ScrollGrid_List_Group_Item_Btn_Click_Click = function(btn, str)
    local idx = tonumber(str)
    Safe_Controller:ClickLevelBtn(idx)
  end,
  FastBattle_Group_Safa_Group_Level_Group_Tips_Btn_Close_Click = function(btn, str)
    View.Group_Safa.Group_Level.Group_Tips.self:SetActive(false)
  end,
  FastBattle_Group_Safa_Group_XS_Group_Information_Group_Reward_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local itemInfo = RewardDataModel.CurShowDrop[elementIndex]
    local BtnItem = require("Common/BtnItem")
    BtnItem:SetItem(element.Group_Item, {
      id = itemInfo.id,
      num = ""
    })
    element.Group_Item.Btn_Item:SetClickParam(itemInfo.id)
  end,
  FastBattle_Group_Safa_Group_XS_Group_Information_Group_Reward_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  FastBattle_Group_Safa_Group_XS_Group_Information_Group_TZ_Btn_QW_Click = function(btn, str)
    RewardController:ClickBattle(str)
  end,
  FastBattle_Group_Safa_Group_XS_Group_Information_Btn_Delete_Click = function(btn, str)
    RewardController:DeleteRewardLevel()
  end,
  FastBattle_Group_Safa_Group_XS_Group_Right_ScrollGrid_Right_SetGrid = function(element, elementIndex)
    RewardController:RefreshRightElement(element, elementIndex)
  end,
  FastBattle_Group_Safa_Group_XS_Group_Right_ScrollGrid_Right_Group_Item_Group_Level_Btn__Click = function(btn, str)
    RewardController:SelectIdx(tonumber(str))
  end,
  FastBattle_Group_Safa_Group_XS_Group_Right_ScrollGrid_Right_Group_Item_Group_Add_Btn__Click = function(btn, str)
    RewardController:AddRewardLevel()
  end,
  FastBattle_Group_Safa_Group_XS_Group_Tips_Btn_Close_Click = function(btn, str)
    View.Group_Safa.Group_XS.Group_Tips.self:SetActive(false)
  end,
  FastBattle_Group_Safa_Group_Switch_Group_Level_Btn__Click = function(btn, str)
    Controller.OnLevelBtnClick()
  end,
  FastBattle_Group_Safa_Group_Switch_Group_XS_Btn__Click = function(btn, str)
    Controller.OnXSBtnClick()
  end,
  FastBattle_Group_Battle_ScrollGrid_Tab_SetGrid = function(element, elementIndex)
    Controller.RefreshBattleElement(element, elementIndex)
  end,
  FastBattle_Group_Battle_ScrollGrid_Tab_Group_Item_Btn__Click = function(btn, str)
  end,
  FastBattle_Group_Battle_Group_Battle_Group_1_Group_Information_Group_TZ_Btn_QW_Click = function(btn, str)
    Battle_Controller.TryBattle(false)
  end,
  FastBattle_Group_Battle_Group_Battle_Group_1_Group_Information_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    Battle_Controller.RefreshRewardElement(element, elementIndex)
  end,
  FastBattle_Group_Battle_Group_Battle_Group_1_Group_Information_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    if not string.nilorempty(str) then
      local index = tonumber(str)
      if not index then
        return
      end
      if not Battle_DataModel.ChooseRewardList then
        return
      end
      local info = Battle_DataModel.ChooseRewardList[index]
      if info and info.id then
        CommonTips.OpenPreRewardDetailTips(info.id, nil, true)
      end
    end
  end,
  FastBattle_Group_Battle_Group_Battle_Group_1_Group_Information_Group_Auto_Btn_Auto_Click = function(btn, str)
    Battle_Controller.OnClickBtnAuto()
  end,
  FastBattle_Group_Battle_Group_Battle_Group_1_Group_Information_Group_Difficult_Btn_Difficult_Click = function(btn, str)
    Battle_Controller.OnDifficultyBtnClick()
  end,
  FastBattle_Group_Battle_Group_Battle_Group_1_ScrollGrid_List_SetGrid = function(element, elementIndex)
    Battle_Controller.RefreshBattleElementShow(element, elementIndex)
  end,
  FastBattle_Group_Battle_Group_Battle_Group_1_ScrollGrid_List_Group_Item_Btn__Click = function(btn, str)
    if not string.nilorempty(str) then
      Battle_Controller.ChooseBattleLevel(tonumber(str))
    end
  end,
  FastBattle_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    if DataModel.IsMainActivityIn then
      UIManager:GoBack()
    else
      UIManager:ClosePanel()
      UIManager:Open("UI/Activity/ActivityMain", Json.encode({id = 86000096}))
    end
    DataModel.SavePanelOpenCachedParams()
  end,
  FastBattle_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
    DataModel.SavePanelOpenCachedParams()
  end,
  FastBattle_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  FastBattle_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  FastBattle_Group_Safa_Group_Level_Group_Difficulty_Slider_BG_Slider = function(slider, value)
    Safe_Controller:OnSliderViewValChanged(value)
  end,
  FastBattle_Group_Safa_Group_Level_Group_Difficulty_Slider_BG_SliderDown = function(slider)
  end,
  FastBattle_Group_Safa_Group_Level_Group_Difficulty_Slider_BG_SliderUp = function(slider)
  end,
  FastBattle_Group_Safa_Group_Level_Group_Difficulty_Slider_Difficulty_Slider = function(slider, value)
    Safe_Controller:SetSliderViewTargetValue(value)
  end,
  FastBattle_Group_Safa_Group_Level_Group_Difficulty_Slider_Difficulty_SliderDown = function(slider)
  end,
  FastBattle_Group_Safa_Group_Level_Group_Difficulty_Slider_Difficulty_SliderUp = function(slider)
    local value = slider.slider.value
    local progList = DataModel.difficultyProgList
    local difficulty = 1
    for i = 1, #progList - 1 do
      if value > progList[i] and value <= progList[i + 1] then
        if value >= (progList[i + 1] + progList[i]) / 2 then
          difficulty = i + 1
        else
          difficulty = i
        end
        value = progList[difficulty]
        break
      end
    end
    Safe_Controller:SetDifficulty(Safe_Controller.curLevelIndex, difficulty)
    slider.slider.value = value
  end,
  FastBattle_Group_Safa_Group_Level_Group_Difficulty_Btn_Affirm_Click = function(btn, str)
    View.Group_Safa.Group_Level.Group_Difficulty.self:SetActive(false)
  end,
  FastBattle_Group_Safa_Group_Level_Group_Difficulty_Group_Item_Btn__Click = function(btn, str)
  end,
  FastBattle_Group_Safa_Group_Level_Group_Difficulty_StaticGrid_Select_SetGrid = function(element, elementIndex)
    if not DataModel.curLevelInfo then
      return
    end
    local levelIndex = Safe_Controller.curLevelIndex
    local info = DataModel.curLevelInfo[levelIndex]
    local difficulty = info.difficulty
    if elementIndex == difficulty then
      element.Group_On.Txt_Difficulty:SetAlpha(1)
      element.Group_On.Txt_Num:SetAlpha(1)
      element.Group_Off.Txt_Difficulty:SetAlpha(0)
      element.Group_Off.Txt_Num:SetAlpha(0)
    else
      element.Group_On.Txt_Difficulty:SetAlpha(0)
      element.Group_On.Txt_Num:SetAlpha(0)
      element.Group_Off.Txt_Difficulty:SetAlpha(1)
      element.Group_Off.Txt_Num:SetAlpha(1)
    end
    local difficultyText = GetText(Safe_Controller.DifficultyTextId[elementIndex])
    local numText = string.format(GetText(80601584), math.floor(DataModel.difficultyProgList[elementIndex] * 100))
    element.Group_On.Txt_Difficulty:SetText(difficultyText)
    element.Group_On.Txt_Num:SetText(numText)
    element.Group_Off.Txt_Difficulty:SetText(difficultyText)
    element.Group_Off.Txt_Num:SetText(numText)
    element.Btn_:SetClickParam(elementIndex)
  end,
  FastBattle_Group_Safa_Group_Level_Group_Difficulty_StaticGrid_Select_Group_Item_Btn__Click = function(btn, str)
    Safe_Controller:SetDifficulty(Safe_Controller.curLevelIndex, tonumber(str))
    View.Group_Safa.Group_Level.Group_Difficulty.Slider_Difficulty:SetSliderValue(DataModel.difficultyProgList[tonumber(str)])
  end
}
return ViewFunction
