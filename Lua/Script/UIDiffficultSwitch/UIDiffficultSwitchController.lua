local View = require("UIDiffficultSwitch/UIDiffficultSwitchView")
local DataModel = require("UIDiffficultSwitch/UIDiffficultSwitchDataModel")
local Controller = {}
Controller.DifficultyTextId = {
  80601525,
  80601526,
  80601527,
  80601528,
  80601529,
  80601574
}
Controller.DifficultyTextWithColorId = {
  80601782,
  80601783,
  80601784,
  80601785,
  80601786,
  80601787
}
Controller.DifficultyBgPath = {
  "UI/Home/HomeSafe/Difficulty/page_bg_1",
  "UI/Home/HomeSafe/Difficulty/page_bg_2",
  "UI/Home/HomeSafe/Difficulty/page_bg_3",
  "UI/Home/HomeSafe/Difficulty/page_bg_4",
  "UI/Home/HomeSafe/Difficulty/page_bg_5",
  "UI/Home/HomeSafe/Difficulty/page_bg_6"
}
Controller.DifficultyIconPath = {
  "UI/Home/HomeSafe/Difficulty/icon_grade_1",
  "UI/Home/HomeSafe/Difficulty/icon_grade_2",
  "UI/Home/HomeSafe/Difficulty/icon_grade_3",
  "UI/Home/HomeSafe/Difficulty/icon_grade_4",
  "UI/Home/HomeSafe/Difficulty/icon_grade_5",
  "UI/Home/HomeSafe/Difficulty/icon_grade_6"
}
Controller.DifficultyNumPath = {
  "UI/Home/HomeSafe/Difficulty/icon_num_1",
  "UI/Home/HomeSafe/Difficulty/icon_num_2",
  "UI/Home/HomeSafe/Difficulty/icon_num_3",
  "UI/Home/HomeSafe/Difficulty/icon_num_4",
  "UI/Home/HomeSafe/Difficulty/icon_num_5",
  "UI/Home/HomeSafe/Difficulty/icon_num_6"
}
Controller.DifficultyIconBgPath = {
  "UI/Home/HomeSafe/Difficulty/icon_bg_1",
  "UI/Home/HomeSafe/Difficulty/icon_bg_2",
  "UI/Home/HomeSafe/Difficulty/icon_bg_3",
  "UI/Home/HomeSafe/Difficulty/icon_bg_4",
  "UI/Home/HomeSafe/Difficulty/icon_bg_5",
  "UI/Home/HomeSafe/Difficulty/icon_bg_6"
}
Controller.DifficultyBtnImgPath = {
  "UI/Home/HomeSafe/Difficulty/btn_grade_1",
  "UI/Home/HomeSafe/Difficulty/btn_grade_2",
  "UI/Home/HomeSafe/Difficulty/btn_grade_3",
  "UI/Home/HomeSafe/Difficulty/btn_grade_4",
  "UI/Home/HomeSafe/Difficulty/btn_grade_5",
  "UI/Home/HomeSafe/Difficulty/btn_grade_6"
}

function Controller:Init()
  local levelId = DataModel.levelId
  local levelConfig = PlayerData:GetFactoryData(levelId, "LevelFactory")
  local dropTableList = levelConfig.dropTableList
  DataModel.difficultyProgList = {}
  for i = 1, #dropTableList do
    DataModel.difficultyProgList[i] = (i - 1) / (#dropTableList - 1)
  end
  View.StaticGrid_Select.grid.self:SetDataCount(#dropTableList)
  View.StaticGrid_Select.grid.self:RefreshAllElement()
  local difficulty = DataModel.difficulty
  View.Slider_Difficulty:SetSliderValue(DataModel.difficultyProgList[difficulty])
  View.Slider_BG:SetSliderValue(DataModel.difficultyProgList[difficulty])
  DataModel.curSliderIndex = nil
  Controller:OnSliderViewValChanged(DataModel.difficultyProgList[difficulty])
end

function Controller:SetSliderViewTargetValue(val)
  DataModel._targetSliderValue = val
end

function Controller:UpdateSliderView()
  local targetVal = DataModel._targetSliderValue
  if targetVal == nil then
    return
  end
  local sliderView = View.Slider_BG
  local curSliderVal = sliderView.slider.value
  if curSliderVal ~= targetVal then
    local distance = targetVal - curSliderVal
    local valPreFrame = CS.GameSetting.Instance.frameTime * 3
    local isAdd = 0 < distance
    DataModel.isSliderAdd = isAdd
    if valPreFrame >= math.abs(distance) then
      sliderView:SetSliderValue(targetVal)
    elseif isAdd then
      sliderView:SetSliderValue(curSliderVal + valPreFrame)
    elseif not isAdd then
      sliderView:SetSliderValue(curSliderVal - valPreFrame)
    end
  end
end

function Controller:UpdateBgGroupByDifficulty(element, difficulty)
  local index = math.min(difficulty, #Controller.DifficultyBgPath)
  element.Img_BG:SetSprite(Controller.DifficultyBgPath[index])
  element.Img_Icon:SetSprite(Controller.DifficultyIconPath[index])
  element.Img_Num:SetSprite(Controller.DifficultyNumPath[index])
  element.Group_Text.Txt_Difficulty:SetText(GetText(Controller.DifficultyTextId[index]))
end

function Controller:OnSliderViewValChanged(value)
  local progList = DataModel.difficultyProgList
  local difficulty = 1
  for i = 1, #progList - 1 do
    if value > progList[i] and value <= progList[i + 1] then
      difficulty = i
      break
    end
  end
  local centre = (progList[difficulty] + progList[difficulty + 1]) / 2
  local levelConfig = PlayerData:GetFactoryData(DataModel.levelId, "ListFactory")
  local mutiple
  if value > centre then
    mutiple = difficulty
  else
    mutiple = difficulty - 1
  end
  local groupBottom = View.Group_Di
  groupBottom.Group_Energy.Txt_Energy:SetText(string.format(GetText(80601530), levelConfig.energyEnd + levelConfig.extraEnergy * mutiple))
  groupBottom.Group_Difficulty.Txt_Difficulty:SetText(string.format(GetText(80601531), levelConfig.recomGrade + levelConfig.extraLevelOffset * mutiple))
  local iconBgPath = Controller.DifficultyIconBgPath[mutiple + 1]
  groupBottom.Img_BG:SetSprite(iconBgPath)
  local stepProg = (value - progList[difficulty]) * (#progList - 1)
  local groupBG = View.Group_BG
  local groupBGFade = View.Group_BG_Fade
  groupBG:GetComponent(typeof(CS.UnityEngine.CanvasGroup)).alpha = 1 - stepProg
  groupBGFade:GetComponent(typeof(CS.UnityEngine.CanvasGroup)).alpha = stepProg
  local groupSchedule = View.Slider_BG.Group_Schedule
  local staticGridSelect = View.StaticGrid_Select.grid
  for i = 1, difficulty - 1 do
    groupSchedule["Img_Grade_" .. i]:SetAlpha(0)
    local gridSelect = staticGridSelect[i]
    gridSelect.Group_Off.Txt_Difficulty:SetAlpha(1)
    gridSelect.Group_Off.Txt_Num:SetAlpha(1)
    gridSelect.Group_On.Txt_Difficulty:SetAlpha(0)
    gridSelect.Group_On.Txt_Num:SetAlpha(0)
  end
  for i = difficulty + 2, #progList do
    groupSchedule["Img_Grade_" .. i]:SetAlpha(0)
    local gridSelect = staticGridSelect[i]
    gridSelect.Group_Off.Txt_Difficulty:SetAlpha(1)
    gridSelect.Group_Off.Txt_Num:SetAlpha(1)
    gridSelect.Group_On.Txt_Difficulty:SetAlpha(0)
    gridSelect.Group_On.Txt_Num:SetAlpha(0)
  end
  groupSchedule["Img_Grade_" .. difficulty]:SetAlpha(1 - stepProg)
  groupSchedule["Img_Grade_" .. difficulty + 1]:SetAlpha(stepProg)
  local homeConfig = PlayerData:GetFactoryData(99900014, "ConfigFactory")
  if not DataModel.isSliderAdd then
    stepProg = 1 - (progList[difficulty + 1] - value) * (#progList - 1) * homeConfig.difficultyTransMutiple
  else
    stepProg = stepProg * homeConfig.difficultyTransMutiple
  end
  local gridNow = staticGridSelect[difficulty]
  gridNow.Group_Off.Txt_Difficulty:SetAlpha(stepProg)
  gridNow.Group_Off.Txt_Num:SetAlpha(stepProg)
  gridNow.Group_On.Txt_Difficulty:SetAlpha(1 - stepProg)
  gridNow.Group_On.Txt_Num:SetAlpha(1 - stepProg)
  local gridNext = staticGridSelect[difficulty + 1]
  gridNext.Group_Off.Txt_Difficulty:SetAlpha(1 - stepProg)
  gridNext.Group_Off.Txt_Num:SetAlpha(1 - stepProg)
  gridNext.Group_On.Txt_Difficulty:SetAlpha(stepProg)
  gridNext.Group_On.Txt_Num:SetAlpha(stepProg)
  if difficulty == DataModel.curSliderIndex then
    return
  end
  DataModel.curSliderIndex = difficulty
  Controller:UpdateBgGroupByDifficulty(groupBG, difficulty)
  Controller:UpdateBgGroupByDifficulty(groupBGFade, difficulty + 1)
end

function Controller:SetDifficulty(difficulty)
  DataModel.difficulty = difficulty
end

function Controller:OnSliderUp(slider)
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
  Controller:SetDifficulty(difficulty)
  slider.slider.value = value
end

function Controller:OnSetStaticGrid(element, elementIndex)
  local difficulty = DataModel.difficulty
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
  local difficultyText = GetText(Controller.DifficultyTextId[elementIndex])
  local numText = string.format(GetText(80601584), math.floor(DataModel.difficultyProgList[elementIndex] * 100))
  element.Group_On.Txt_Difficulty:SetText(difficultyText)
  element.Group_On.Txt_Num:SetText(numText)
  element.Group_Off.Txt_Difficulty:SetText(difficultyText)
  element.Group_Off.Txt_Num:SetText(numText)
  element.Btn_:SetClickParam(elementIndex)
end

return Controller
