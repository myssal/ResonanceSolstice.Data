local View = require("UIPrisonWorkshopContract/UIPrisonWorkshopContractView")
local DataModel = require("UIPrisonWorkshopContract/UIPrisonWorkshopContractDataModel")
local ViewFunction = {
  PrisonWorkshopContract_Btn_BG_Click = function(btn, str)
    View.self:CloseUI()
  end,
  PrisonWorkshopContract_Btn_Confirm_Click = function(btn, str)
    local costItem = PlayerData:GetFactoryData(11400001)
    local costNum = DataModel.costList[11400001] or 0
    CommonTips.OnPrompt(string.format(GetText(80607264), costNum, costItem.name), nil, nil, function()
      local function callBack(json)
        View.self:CloseUI()
        
        UIManager:Open("UI/Prison/Main/PrisonWorkshopOpenSuccess", nil, function()
          if json.reward then
            CommonTips.OpenShowItem(json.reward, function()
              if UIManager:IsPanelOpened("UI/Prison/Overview/Prison") then
                local UIPrisonDataModel = require("UIPrison/UIPrisonDataModel")
                UIPrisonDataModel.UnLockProductRoom()
              end
            end)
          end
        end)
      end
      
      PrisonData.OpenWorkShop(callBack)
    end)
  end
}
return ViewFunction
