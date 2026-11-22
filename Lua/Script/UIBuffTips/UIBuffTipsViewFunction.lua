local View = require("UIBuffTips/UIBuffTipsView")
local DataModel = require("UIBuffTips/UIBuffTipsDataModel")
local ViewFunction = {
  BuffTips_StaticGrid_Stage_SetGrid = function(element, elementIndex)
    local activityCfg = PlayerData:GetFactoryData(86000001, "ActivityFactory")
    local inTime = TimeUtil:IsActive(activityCfg.startTime, activityCfg.endTime)
    if activityCfg.isTriggerTime then
      local activityData = PlayerData:GetActivityData(86000001)
      local startTime = activityData.st
      if startTime then
        local time = startTime + activityCfg.buffContinueTime * 86400
        if activityCfg.continueTime > 0 then
          local endTime = PlayerData.ServerData.user_home_info.addTime + (activityCfg.putTime + activityCfg.continueTime) * 86400
          if time > endTime then
            time = endTime
          end
        end
        local remainTime = time - PlayerData:GetSeverTime()
        inTime = 0 < remainTime
      end
    end
    local info = DataModel.allBuffStage[elementIndex]
    element.Group_Title.Txt_Num:SetText(info.stageIndex)
    local buffActive = info.stageIndex <= DataModel.curStageIndex
    element.Img_Mask:SetActive(not buffActive or not inTime)
    element.Group_State.Img_Finish:SetActive(not inTime)
    element.Group_State.Img_ON:SetActive(inTime and buffActive)
    element.Group_State.Img_Off:SetActive(inTime and not buffActive)
  end,
  BuffTips_Group_Bar_Btn_Check_Click = function(btn, str)
    if UIManager:IsPanelOpened("UI/Activity/BlackTea/ServerProgress") then
      View.self:CloseUI()
      return
    end
    UIManager:Open("UI/Activity/BlackTea/ServerProgress")
  end,
  BuffTips_Btn_Close_Click = function(btn, str)
    View.self:PlayAnim("BuffTips_Out", function()
      View.self:CloseUI()
    end)
  end
}
return ViewFunction
