local View = require("UICubeRogueQuit/UICubeRogueQuitView")
local DataModel = require("UICubeRogueQuit/UICubeRogueQuitDataModel")
local RogueMain = require("UICubeRogueMain/UICubeRoguewMainController")
local ViewFunction = {
  CubeRogueQuit_Img__Btn__Click = function(btn, str)
    UIManager:GoBack(false)
  end,
  CubeRogueQuit_Group_Btn_Btn_Finish_Click = function(btn, str)
    RogueMain.EndCube()
  end,
  CubeRogueQuit_Group_Btn_Btn_Furlough_Click = function(btn, str)
    local bgPath
    local cfg = PlayerData:GetFactoryData(89400002, "CubeRogueFactory")
    if cfg.loadingList and #cfg.loadingList > 0 then
      bgPath = cfg.loadingList[math.random(1, #cfg.loadingList)].imagePath
    end
    if bgPath == "" then
      bgPath = nil
    end
    CommonTips.OpenLoading(nil, nil, bgPath, function()
      CBus:ChangeScene("Main", function()
        UIManager:Open("UI/CubeRogue/OverView/CubeRogueOverView", Json.encode({activityId = 86000026}))
      end)
    end)
  end
}
return ViewFunction
