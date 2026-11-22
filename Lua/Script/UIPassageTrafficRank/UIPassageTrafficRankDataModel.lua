local View = require("UIPassageTrafficRank/UIPassageTrafficRankView")
local DataModel = {}
DataModel.comfortScore = 0
DataModel.foodScore = 0
DataModel.petScore = 0
DataModel.plantScore = 0
DataModel.clearScore = 0
DataModel.playScore = 0
DataModel.fishScore = 0
DataModel.medicalScore = 0
local ScoreGrades = {}

function DataModel.InitData()
  ScoreGrades = {
    View.Group_Grade.Group_Buff.Group_Icon.Img_.Img_E,
    View.Group_Grade.Group_Buff.Group_Icon.Img_.Img_D,
    View.Group_Grade.Group_Buff.Group_Icon.Img_.Img_C,
    View.Group_Grade.Group_Buff.Group_Icon.Img_.Img_B,
    View.Group_Grade.Group_Buff.Group_Icon.Img_.Img_A,
    View.Group_Grade.Group_Buff.Group_Icon.Img_.Img_S,
    View.Group_Grade.Group_Buff.Group_Icon.Img_.Img_SS,
    View.Group_Grade.Group_Buff.Group_Icon.Img_.Img_SSS
  }
  local comfortScore = 0
  local foodScore = 0
  local petScore = 0
  local plantScore = 0
  local playScore = 0
  local fishScore = 0
  local medicalScore = 0
  local coach = PlayerData.ServerData.user_home_info.coach
  local furniture = PlayerData.ServerData.user_home_info.furniture
  for k, v in pairs(coach) do
    for k1, v1 in pairs(v.location) do
      local tempfurniture = furniture[tostring(v1.id)]
      if tempfurniture then
        local furCA = PlayerData:GetFactoryData(tempfurniture.id)
        local scoresWithAllBuff = PlayerData.GetFurScoreWithAllBuff(v1.id, furCA.bag)
        comfortScore = comfortScore + scoresWithAllBuff.comfort
        foodScore = foodScore + scoresWithAllBuff.food
        petScore = petScore + scoresWithAllBuff.pet
        plantScore = plantScore + scoresWithAllBuff.plant
        playScore = playScore + scoresWithAllBuff.play
        fishScore = fishScore + scoresWithAllBuff.fish
        medicalScore = medicalScore + scoresWithAllBuff.medical
      end
    end
  end
  local nowActivity = require("UIGroup_EventWeek/WeekActivityData").FindNowWeekActivity()
  if nowActivity then
    local gradelList = require("UIGroup_EventWeek/WeekActivityData").GetGradelList(nowActivity)
    for i1, v1 in ipairs(gradelList) do
      local buffCfg = PlayerData:GetFactoryData(v1.id)
      if buffCfg.buffType == "endComfortGrade" then
        comfortScore = MathEx.roundToDecimalPlaces(comfortScore + comfortScore * buffCfg.param, 1)
      end
      if buffCfg.buffType == "endPlantGrade" then
        plantScore = MathEx.roundToDecimalPlaces(plantScore + plantScore * buffCfg.param, 1)
      end
      if buffCfg.buffType == "endFishGrade" then
        fishScore = MathEx.roundToDecimalPlaces(fishScore + fishScore * buffCfg.param, 1)
      end
      if buffCfg.buffType == "endPetGrade" then
        petScore = MathEx.roundToDecimalPlaces(petScore + petScore * buffCfg.param, 1)
      end
      if buffCfg.buffType == "endFoodGrade" then
        foodScore = MathEx.roundToDecimalPlaces(foodScore + foodScore * buffCfg.param, 1)
      end
      if buffCfg.buffType == "endPlayGrade" then
        playScore = MathEx.roundToDecimalPlaces(playScore + playScore * buffCfg.param, 1)
      end
      if buffCfg.buffType == "enMedicalGrade" then
        medicalScore = MathEx.roundToDecimalPlaces(medicalScore + medicalScore * buffCfg.param, 1)
      end
    end
  end
  DataModel.comfortScore = comfortScore
  DataModel.foodScore = foodScore
  DataModel.petScore = petScore
  DataModel.plantScore = plantScore
  DataModel.playScore = playScore
  DataModel.fishScore = fishScore
  DataModel.medicalScore = medicalScore
end

function DataModel.RefreshOnShow()
  local gradeIndex = 1
  local buffAddNum = 0
  local comfortnum = 0
  local plantnum = 0
  local fishnum = 0
  local petnum = 0
  local playnum = 0
  local foodnum = 0
  local medicalnum = 0
  local upwinnum = 0
  local max = true
  local cfg = PlayerData:GetFactoryData(99900081, "ConfigFactory")
  local propertyCompareMap = {
    comfort = DataModel.comfortScore,
    plant = DataModel.plantScore,
    fish = DataModel.fishScore,
    pet = DataModel.petScore,
    play = DataModel.playScore,
    delicious = DataModel.foodScore,
    medic = DataModel.medicalScore
  }
  for i, v in ipairs(cfg.scoreGradeList) do
    local pass = true
    for property, compareNum in pairs(propertyCompareMap) do
      if v[property] then
        comfortnum = v.comfort
        plantnum = v.plant
        fishnum = v.fish
        petnum = v.pet
        playnum = v.play
        foodnum = v.delicious
        medicalnum = v.medic
        upwinnum = v.upwin
      end
      if v[property] and compareNum < v[property] then
        pass = false
        max = false
        break
      end
    end
    if not pass then
      break
    end
    buffAddNum = v.upwin
    gradeIndex = i
  end
  for i, v in ipairs(ScoreGrades) do
    v:SetActive(i == gradeIndex)
  end
  View.Group_Grade.Group_Buff.Txt_Buff:SetText(string.format(GetText(80611755), ClearFollowZero(buffAddNum * 100)))
  View.Group_Grade.Group_Buff.Txt_BuffPlus:SetText(string.format(GetText(80611755), ClearFollowZero(upwinnum * 100)))
  View.Group_Grade.Group_Buff.Group_Icon.Img_.Img_SSS.Txt_BuffPlus:SetText(string.format(GetText(80611755), ClearFollowZero(buffAddNum * 100)))
  View.Group_Grade.Group_GradeNum.Group_comfort.Txt_Num:SetText(math.floor(DataModel.comfortScore))
  View.Group_Grade.Group_GradeNum.Group_fish.Txt_Num:SetText(math.floor(DataModel.fishScore))
  View.Group_Grade.Group_GradeNum.Group_medical.Txt_Num:SetText(math.floor(DataModel.medicalScore))
  View.Group_Grade.Group_GradeNum.Group_play.Txt_Num:SetText(math.floor(DataModel.playScore))
  View.Group_Grade.Group_GradeNum.Group_plant.Txt_Num:SetText(math.floor(DataModel.plantScore))
  View.Group_Grade.Group_GradeNum.Group_pet.Txt_Num:SetText(math.floor(DataModel.petScore))
  View.Group_Grade.Group_GradeNum.Group_food.Txt_Num:SetText(math.floor(DataModel.foodScore))
  View.Group_Grade.Group_GradeNum.Group_clean.Txt_Num:SetText(ClearFollowZero(DataModel.clearScore * 100) .. "%")
  View.Group_Grade.Group_GradeNum.Group_clean.Btn_Clean:SetActive(1 > DataModel.clearScore)
  if not max then
    View.Group_Grade.Group_GradeNum.Group_comfort.Txt_NumNext:SetText(math.floor(comfortnum))
    View.Group_Grade.Group_GradeNum.Group_fish.Txt_NumNext:SetText(math.floor(fishnum))
    View.Group_Grade.Group_GradeNum.Group_medical.Txt_NumNext:SetText(math.floor(medicalnum))
    View.Group_Grade.Group_GradeNum.Group_play.Txt_NumNext:SetText(math.floor(playnum))
    View.Group_Grade.Group_GradeNum.Group_plant.Txt_NumNext:SetText(math.floor(plantnum))
    View.Group_Grade.Group_GradeNum.Group_pet.Txt_NumNext:SetText(math.floor(petnum))
    View.Group_Grade.Group_GradeNum.Group_food.Txt_NumNext:SetText(math.floor(foodnum))
  else
    View.Group_Grade.Group_GradeNum.Group_comfort.Txt_NumNext:SetText(GetText(80611761))
    View.Group_Grade.Group_GradeNum.Group_fish.Txt_NumNext:SetText(GetText(80611761))
    View.Group_Grade.Group_GradeNum.Group_medical.Txt_NumNext:SetText(GetText(80611761))
    View.Group_Grade.Group_GradeNum.Group_play.Txt_NumNext:SetText(GetText(80611761))
    View.Group_Grade.Group_GradeNum.Group_plant.Txt_NumNext:SetText(GetText(80611761))
    View.Group_Grade.Group_GradeNum.Group_pet.Txt_NumNext:SetText(GetText(80611761))
    View.Group_Grade.Group_GradeNum.Group_food.Txt_NumNext:SetText(GetText(80611761))
  end
  local tranLv = PlayerData:GetHomeInfo().tran_lv or 0
  View.Group_TopRight.Group_Transport.Txt_Num:SetText(string.format(GetText(80611754), tranLv))
  View.Group_TopRight.Group_Adv.Txt_:SetText(PlayerData:GetGoodsById(11400072).num)
  local config = PlayerData:GetFactoryData(99900061, "ConfigFactory")
  local maxHaveFlierNum = config.leafletMax + PlayerData:GetHomeSkillIncrease(EnumDefine.HomeSkillEnum.RiseFliersSaveLimited)
  View.Group_TopRight.Group_Cerent.Txt_:SetText(PlayerData.GetLeafLetNum() .. "/" .. maxHaveFlierNum)
end

function DataModel.ExitTo()
  if UIManager:IsPanelOpened("UI/MainUI/ESC") then
    UIManager:ClosePanel(false, "UI/MainUI/ESC")
  end
  if UIManager:IsPanelOpened("UI/MainUI/MainUI") then
    UIManager:ClosePanel(false, "UI/MainUI/MainUI")
  end
  local mainUIDataModel = require("UIMainUI/UIMainUIDataModel")
  local TradeDataModel = require("UIHome/UIHomeTradeDataModel")
  if not TradeDataModel.GetInTravel() then
    if MainManager.bgSceneName == mainUIDataModel.SceneNameEnum.Main then
      TrainCameraManager:OpenCamera(1)
    elseif MainManager.bgSceneName == mainUIDataModel.SceneNameEnum.Home then
      TrainCameraManager:OpenCamera(2)
    end
  else
    TrainCameraManager:OpenCamera(0)
  end
end

return DataModel
