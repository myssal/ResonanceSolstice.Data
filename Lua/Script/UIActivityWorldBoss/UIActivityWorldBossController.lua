local View = require("UIActivityWorldBoss/UIActivityWorldBossView")
local DataModel = require("UIActivityWorldBoss/UIActivityWorldBossDataModel")
local Controller = {}

function Controller.ShowPanel()
  View.Group_Main.Group_Preview.ScrollGrid_Reward.grid.self:SetDataCount(#DataModel.cfg.rewardPreviewList)
  View.Group_Main.Group_Preview.ScrollGrid_Reward.grid.self:RefreshAllElement()
  local playerLv = PlayerData:GetUserInfo().lv or 1
  local lvLimit = playerLv < DataModel.cfg.openLv
  if lvLimit then
    View.Group_Main.Group_Times:SetActive(false)
    View.Group_Main.Btn_Start.Txt_T:SetActive(false)
    View.Group_Main.Btn_Start.Txt_Lock:SetActive(true)
    View.Group_Main.Btn_Start.Txt_Lock:SetText(string.format(GetText(80610982), DataModel.cfg.openLv))
  else
    View.Group_Main.Group_Times:SetActive(true)
    View.Group_Main.Btn_Start.Txt_T:SetActive(true)
    View.Group_Main.Btn_Start.Txt_Lock:SetActive(false)
    View.Group_Main.Group_Times.Txt_T:SetText(DataModel.netData.times .. "/" .. DataModel.cfg.bossTimes)
  end
  View.Group_Bg.SoftMask_Role.Spine_Role:SetData(DataModel.cfg.bossSpinePath)
  if DataModel.cfg.bossSpineAnim ~= nil and DataModel.cfg.bossSpineAnim ~= "" then
    View.Group_Bg.SoftMask_Role.Spine_Role:SetAction(DataModel.cfg.bossSpineAnim, true, true)
  end
  View.Group_Bg.SoftMask_Role.Spine_Role:SetAnchoredPosition(Vector2(DataModel.cfg.bossSpineX, DataModel.cfg.bossSpineY))
  View.Group_Bg.SoftMask_Role.Spine_Role:SetLocalScale(DataModel.cfg.bossSpineScaleX, DataModel.cfg.bossSpineScaleY, 1)
  View.Group_Main.Btn_Reward:SetActive(not lvLimit)
  local startTime = DataModel.cfg.startTime
  local endTime = DataModel.cfg.endTime
  View.Group_Main.Group_Time.Txt_M:SetText(string.sub(startTime, 6, 7))
  View.Group_Main.Group_Time.Txt_D:SetText(string.sub(startTime, 9, 10))
  View.Group_Main.Group_Time.Txt_Time:SetText(string.sub(startTime, 12, 16))
  View.Group_Main.Group_Time.Txt_M2:SetText(string.sub(endTime, 6, 7))
  View.Group_Main.Group_Time.Txt_D2:SetText(string.sub(endTime, 9, 10))
  View.Group_Main.Group_Time.Txt_Time2:SetText(string.sub(endTime, 12, 16))
  Controller.RefreshRedDot()
end

function Controller.RefreshRedDot()
  local data = PlayerData.ServerData.all_activities.ing[tostring(DataModel.activityId)]
  local hasReward = false
  for k, v in pairs(data.world_bosses) do
    local bossCfg = PlayerData:GetFactoryData(k)
    local maxRewardCount = #bossCfg.bossRewardList
    local canRecvCount = 0
    local curBossHpPercent = v.hp / bossCfg.bossHp
    for i = 1, maxRewardCount do
      if curBossHpPercent <= bossCfg.bossRewardList[i].ratio then
        canRecvCount = i
      end
    end
    if canRecvCount > #data.boss[k].received then
      hasReward = true
      break
    end
  end
  View.Group_Main.Btn_Reward.Img_Red:SetActive(hasReward)
end

return Controller
