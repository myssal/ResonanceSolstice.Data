local Order = {}

function Order:OnStart(ca)
  if ca.isMainUI then
    if UIManager:IsPanelOpened("UI/MainUI/MainUI") then
      if ca.isPlay then
        UIMainUIController.ResumePosterGirlAudioSource()
      else
        UIMainUIController.StopPosterGirlAudioSource()
      end
    end
  else
    local npcDialog = require("Common/NPCDialog")
    npcDialog.StopSound(not ca.isPlay)
  end
end

function Order:IsFinish()
  return true
end

return Order
