local View = require("UIPrisonContract/UIPrisonContractView")
local DataModel = require("UIPrisonContract/UIPrisonContractDataModel")
local ViewFunction = {
  PrisonContract_Btn_BG_Click = function(btn, str)
    View.self:CloseUI()
  end,
  PrisonContract_Btn_Confirm_Click = function(btn, str)
    local prisonCA = PlayerData:GetFactoryData(86800014, "PrisonFactory")
    local costItem = PlayerData:GetFactoryData(prisonCA.initialPriceItem)
    CommonTips.OnPrompt(string.format(GetText(80607159), prisonCA.initialPrice, costItem.name), nil, nil, function()
      PrisonData.OpenPrison(function()
        View.self:CloseUI()
        if UIManager:IsPanelOpened("UI/Prison/Main/PrisonMain") then
          local PrisonMainView = require("UIPrisonMain/UIPrisonMainView")
          PrisonMainView.self:CloseUI()
        end
        UIManager:Open("UI/Prison/Overview/Prison")
        UIManager:Open("UI/Prison/Main/PrisonOpenSuccess")
        local showQuest = PrisonData.GetShowQuest()
        local quest = showQuest[1]
        if quest then
          PlayerData:SetPlayerPrefs("int", "PrisonQuestTrace", quest)
          PrisonData.QuestRefresh()
        end
        PrisonController.CloseRoom()
      end)
    end)
  end
}
return ViewFunction
