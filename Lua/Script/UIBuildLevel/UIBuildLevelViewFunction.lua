local View = require("UIBuildLevel/UIBuildLevelView")
local CommonItem = require("Common/BtnItem")
local DataModel = require("UIBuildLevel/UIBuildLevelDataModel")
local ViewFunction = {
  BuildLevel_Group_Level_Group_Level1_Btn__Click = function(btn, str)
    DataModel:SelectLevel(1)
  end,
  BuildLevel_Group_Level_Group_Level2_Btn__Click = function(btn, str)
    DataModel:SelectLevel(2)
  end,
  BuildLevel_Group_Level_Group_Level3_Btn__Click = function(btn, str)
    DataModel:SelectLevel(3)
  end,
  BuildLevel_Group_Level_Group_Level4_Btn__Click = function(btn, str)
    DataModel:SelectLevel(4)
  end,
  BuildLevel_Group_Level_Group_Level5_Btn__Click = function(btn, str)
    DataModel:SelectLevel(5)
  end,
  BuildLevel_Group_Ding_Btn_Energy_Click = function(btn, str)
    local function callback()
      DataModel:RefreshEnergy()
    end
    
    CommonTips.OpenEnergy(callback)
  end,
  BuildLevel_Group_Ding_Btn_Energy_Btn_Add_Click = function(btn, str)
  end,
  BuildLevel_Group_Right_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local row = DataModel.ChooseRewardList[elementIndex]
    element.Group_Item.Btn_Item:SetClickParam(row.id)
    element.Group_First.self:SetActive(false)
    element.Group_Allready.self:SetActive(false)
    if row.type == 1 then
      element.Group_First.self:SetActive(true)
      if row.isFinish == true then
        element.Group_Allready.self:SetActive(true)
      end
    end
    CommonItem:SetItem(element.Group_Item, row)
  end,
  BuildLevel_Group_Right_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    if str == nil then
      return
    end
    CommonTips.OpenPreRewardDetailTips(str, nil, true)
  end,
  BuildLevel_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    PlayerData.TempCache.MonsterLevelAutoBattle = false
    DataModel.monsterLevelAutoBattle = PlayerData.TempCache.MonsterLevelAutoBattle
    DataModel.remainAutoBattleTime = DataModel.constAutoBattleTime
    if DataModel.IsCityMapIn then
      UIManager:ClosePanel()
      UIManager:Open("UI/ExchangeStation/ExchangeStation", Json.encode({
        buildingId = DataModel.BuildCA.id,
        IsCityMapIn = true,
        name = DataModel.BuildCA.name
      }))
    elseif DataModel.IsActivityMainIn then
      UIManager:ClosePanel()
      local activityId = DataModel.BuildCA.correspondingActivity
      local ActivityMainDataModel = require("UIActivityMain/UIActivityMainDataModel")
      local activeList = ActivityMainDataModel:GetActivityCAList()
      for k, v in ipairs(activeList) do
        if v.id == activityId then
          UIManager:Open("UI/Activity/ActivityMain", Json.encode({index = k, id = activityId}))
          break
        end
      end
    else
      UIManager:GoBack()
    end
  end,
  BuildLevel_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    PlayerData.TempCache.MonsterLevelAutoBattle = false
    DataModel.monsterLevelAutoBattle = PlayerData.TempCache.MonsterLevelAutoBattle
    DataModel.remainAutoBattleTime = DataModel.constAutoBattleTime
    UIManager:GoHome()
  end,
  BuildLevel_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  BuildLevel_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  BuildLevel_Group_Right_Group_Fight_Group_Can_Btn__Click = function(btn, str)
    DataModel:TryBattle()
  end,
  BuildLevel_Group_Right_Group_Auto_Btn_Auto_Click = function(btn, str)
    DataModel:OnClickBtnAuto()
  end,
  BuildLevel_Group_Construction_Btn__Click = function(btn, str)
    DataModel:OpenActivityPanel()
  end
}
return ViewFunction
