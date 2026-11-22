local View = require("UIWitchesEnemy/UIWitchesEnemyView")
local DataModel = require("UIWitchesEnemy/UIWitchesEnemyDataModel")
local CommonItem = require("Common/BtnItem")
local ViewFunction = {
  WitchesEnemy_Img_RightBG_Img_FightRewards_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local info = DataModel.dropList[elementIndex]
    CommonItem.SetItem(self, element.Group_Item, {
      id = info.id
    })
    element.Group_Item.Btn_Item:SetClickParam(info.id)
  end,
  WitchesEnemy_Img_RightBG_Img_FightRewards_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local id = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(id)
  end,
  WitchesEnemy_Img_RightBG_Btn_Fight_Click = function(btn, str)
    DataModel.GoToFight()
  end,
  WitchesEnemy_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    CommonTips.OpenWitchPrompt(80610442, nil, nil, DataModel.GiveUpBattle)
  end,
  WitchesEnemy_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  WitchesEnemy_Group_Coin_Btn__Click = function(btn, str)
  end,
  WitchesEnemy_Group_Stamina_Btn__Click = function(btn, str)
  end,
  WitchesEnemy_Img_RightBG_Btn_Boss_Click = function(btn, str)
    DataModel.GoToFight()
  end,
  WitchesEnemy_Group_Energy_Btn_Add_Click = function(btn, str)
    UIManager:Open("UI/Energy/Energy", nil, function()
      local energy_content = string.format("%d/%d", PlayerData:GetUserInfo().energy, PlayerData:GetUserInfo().max_energy)
      View.Group_Energy.Txt_Num:SetText(energy_content)
    end)
  end,
  WitchesEnemy_Btn_Rank_Click = function(btn, str)
    local WitchRankDataModel = require("UIWitchesRanking/UIWitchesRankingDataModel")
    local rankId = WitchRankDataModel.RankForeverId
    local rankCA = PlayerData:GetFactoryData(rankId, "RankFactory")
    local levelTween = WitchData.GetSelfLevelTween(rankId)
    Net:SendProto("main.roll_rank", function(json)
      WitchRankDataModel.RefreshServerRankData(json)
      WitchRankDataModel.RefreshServerRankCacheInfo(json)
      WitchRankDataModel.RefreshSeverRankShowLimitNum(json.has_more)
      UIManager:Open(WitchData.GetUIPath("UI/Witches/Ranking/WitchesRanking"), Json.encode({tab = 2}))
    end, rankCA.rankType, rankCA.timeType, levelTween, rankCA.peopleNum, nil, nil, nil, nil, WitchData.GetActivityId())
  end,
  WitchesEnemy_Img_RightBG_Btn_Fight_Btn_FastPass_Click = function(btn, str)
    DataModel.FastPassBattle()
  end,
  WitchesEnemy_Btn_Guka_Click = function(btn, str)
    UIManager:Open(WitchData.GetUIPath("UI/Witches/Guka/GuKa"))
  end
}
return ViewFunction
