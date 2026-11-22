local View = require("UIPrisonerList/UIPrisonerListView")
local DataModel = require("UIPrisonerList/UIPrisonerListDataModel")
local ViewFunction = {
  PrisonerList_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    DataModel:OnClickReturnBtn()
  end,
  PrisonerList_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  PrisonerList_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  PrisonerList_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  PrisonerList_Group_TopRightPrison_Btn_Level_Click = function(btn, str)
    DataModel:SetSortType(1)
  end,
  PrisonerList_Group_TopRightPrison_Btn_Rarity_Click = function(btn, str)
    DataModel:SetSortType(2)
  end,
  PrisonerList_Group_TopRightPrison_Btn_Time_Click = function(btn, str)
    DataModel:SetSortType(3)
  end,
  PrisonerList_Group_TopRightCoach_Btn_Rarity_Click = function(btn, str)
    DataModel:SetSortType(4)
  end,
  PrisonerList_Group_TopRightCoach_Btn_Time_Click = function(btn, str)
    DataModel:SetSortType(2)
  end,
  PrisonerList_ScrollGrid_Prison_SetGrid = function(element, elementIndex)
    DataModel:RefreshPrisonPackGrid(element, elementIndex)
  end,
  PrisonerList_ScrollGrid_Prison_Group_Item_Btn__Click = function(btn, str)
  end,
  PrisonerList_ScrollGrid_Coach_SetGrid = function(element, elementIndex)
    DataModel:RefreshBackpackGrid(element, elementIndex)
  end,
  PrisonerList_ScrollGrid_Coach_Group_Item_Btn_Release_Click = function(btn, str)
    DataModel:OnClickReleasePrisoner(str)
  end,
  PrisonerList_ScrollGrid_Coach_Group_Item_Btn_Pick_Click = function(btn, str)
    DataModel:OnClickPickPrisoner(str)
  end,
  PrisonerList_Group_Bottom_Group_CoachList_Btn_Confirm_Click = function(btn, str)
    DataModel:OnClickCheckInConrirm()
  end,
  PrisonerList_Group_Bottom_Group_Prison_Group_Des_Btn__Click = function(btn, str)
  end,
  PrisonerList_Group_Bottom_Group_Prison_Btn_PrisonerEnter_Click = function(btn, str)
    DataModel:OnClickPrisonEnterBtn()
  end,
  PrisonerList_Group_Chapter_Btn_BG_Click = function(btn, str)
  end,
  PrisonerList_Group_Chapter_Group_Career_Btn_C00_Click = function(btn, str)
    DataModel:OnClickPersonality(0)
  end,
  PrisonerList_Group_Chapter_Group_Career_Btn_C01_Click = function(btn, str)
    DataModel:OnClickPersonality(1)
  end,
  PrisonerList_Group_Chapter_Group_Career_Btn_C02_Click = function(btn, str)
    DataModel:OnClickPersonality(2)
  end,
  PrisonerList_Group_Chapter_Group_Career_Btn_C03_Click = function(btn, str)
    DataModel:OnClickPersonality(3)
  end,
  PrisonerList_Group_Chapter_Group_Career_Btn_C04_Click = function(btn, str)
    DataModel:OnClickPersonality(4)
  end,
  PrisonerList_Group_Chapter_Group_Career_Btn_C05_Click = function(btn, str)
    DataModel:OnClickPersonality(5)
  end,
  PrisonerList_Group_Chapter_Group_Career_Btn_C06_Click = function(btn, str)
    DataModel:OnClickPersonality(6)
  end,
  PrisonerList_Group_Chapter_Group_Career_Btn_C07_Click = function(btn, str)
    DataModel:OnClickPersonality(7)
  end,
  PrisonerList_Group_Chapter_Group_Career_Btn_C08_Click = function(btn, str)
    DataModel:OnClickPersonality(8)
  end,
  PrisonerList_Group_Chapter_Group_Career_Btn_C09_Click = function(btn, str)
    DataModel:OnClickPersonality(9)
  end,
  PrisonerList_Group_Chapter_Group_Group_Btn_G00_Click = function(btn, str)
    DataModel:OnClickSpeciality(0)
  end,
  PrisonerList_Group_Chapter_Group_Group_Btn_G01_Click = function(btn, str)
    DataModel:OnClickSpeciality(1)
  end,
  PrisonerList_Group_Chapter_Group_Rarity_Btn_R00_Click = function(btn, str)
    DataModel:OnClickRarity(0)
  end,
  PrisonerList_Group_Chapter_Group_Rarity_Btn_R01_Click = function(btn, str)
    DataModel:OnClickRarity(1)
  end,
  PrisonerList_Group_Chapter_Group_Rarity_Btn_R02_Click = function(btn, str)
    DataModel:OnClickRarity(2)
  end,
  PrisonerList_Group_Chapter_Group_Rarity_Btn_R03_Click = function(btn, str)
    DataModel:OnClickRarity(3)
  end,
  PrisonerList_Group_Chapter_Btn_OK_Click = function(btn, str)
    DataModel:OnClickSiftConfirm()
  end,
  PrisonerList_Group_Chapter_Btn_Cancel_Click = function(btn, str)
    DataModel:OnClickSiftCancel()
  end,
  PrisonerList_Group_TopRightPrison_Btn_Sift_Click = function(btn, str)
    DataModel:OnClickBtnSift()
  end,
  PrisonerList_Group_TopRightCoach_Btn_Sift_Click = function(btn, str)
    DataModel:OnClickBtnSift()
  end,
  PrisonerList_Group_Bottom_Group_CoachList_Btn_All_Click = function(btn, str)
    DataModel:OnClickPickAll()
  end,
  PrisonerList_Group_Chapter_Group_Career_Btn_C10_Click = function(btn, str)
    DataModel:OnClickPersonality(10)
  end,
  PrisonerList_Group_Chapter_Group_Career_Btn_C11_Click = function(btn, str)
    DataModel:OnClickPersonality(11)
  end,
  PrisonerList_Group_Chapter_Group_Career_Btn_C12_Click = function(btn, str)
    DataModel:OnClickPersonality(12)
  end,
  PrisonerList_Group_Chapter_Group_Career_Btn_C13_Click = function(btn, str)
    DataModel:OnClickPersonality(13)
  end,
  PrisonerList_Group_Chapter_Group_Group_Btn_G02_Click = function(btn, str)
    DataModel:OnClickSpeciality(2)
  end,
  PrisonerList_Group_Bottom_Group_CoachList_Btn_Release_Click = function(btn, str)
    DataModel:OnClickReleaseAllPrisoner(str)
  end,
  PrisonerList_Btn_Passenger_Click = function(btn, str)
  end
}
return ViewFunction
