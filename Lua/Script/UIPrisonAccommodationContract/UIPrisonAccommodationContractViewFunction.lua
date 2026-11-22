local View = require("UIPrisonAccommodationContract/UIPrisonAccommodationContractView")
local DataModel = require("UIPrisonAccommodationContract/UIPrisonAccommodationContractDataModel")
local ViewFunction = {
  PrisonAccommodationContract_Btn_BG_Click = function(btn, str)
    View.self:CloseUI()
  end,
  PrisonAccommodationContract_Btn_Confirm_Click = function(btn, str)
    local costItem = PlayerData:GetFactoryData(11400001)
    local costNum = DataModel.costList[11400001] or 0
    CommonTips.OnPrompt(string.format(GetText(80607264), costNum, costItem.name), nil, nil, function()
      local function callBack(json)
        View.self:CloseUI()
        
        UIManager:Open("UI/Prison/Main/PrisonAccomodation/PrisonDormOpenSuccess", nil, function()
          if json.reward then
            CommonTips.OpenShowItem(json.reward, function()
              if UIManager:IsPanelOpened("UI/Prison/Overview/Prison") then
                local UIPrisonDataModel = require("UIPrison/UIPrisonDataModel")
                UIPrisonDataModel.UnLockPrisonerRoom()
              end
            end)
          end
        end)
      end
      
      PrisonData.OpenPrisonerRoom(callBack)
    end)
  end
}
return ViewFunction
