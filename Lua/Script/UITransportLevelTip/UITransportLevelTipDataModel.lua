local View = require("UITransportLevelTip/UITransportLevelTipView")
local DataModel = {}
local MaxLevel = 100

function DataModel.InitData()
  local cfg = PlayerData:GetFactoryData(99900081, "ConfigFactory")
  MaxLevel = cfg.transportLvList[#cfg.transportLvList].tranLv
end

function DataModel.RefreshOnShow()
  local cfg = PlayerData:GetFactoryData(99900081, "ConfigFactory")
  local curTransLv = PlayerData:GetHomeInfo().tran_lv
  local curExp = math.floor(PlayerData:GetHomeInfo().tran_exp)
  View.Img_PlayerInfo.Group_LV.Txt_Num:SetText(curTransLv)
  View.Group_Now.Txt_Rise:SetText(cfg.transportLvList[curTransLv].reward)
  if curTransLv == MaxLevel then
    View.Img_PlayerInfo.Img_BP:SetFilledImgAmount(1)
    View.Img_PlayerInfo.Txt_Profit:SetText(curExp .. "/-")
    View.Group_Next.Txt_Rise:SetText(GetText(80609058))
  else
    local nextLv = curTransLv + 1
    local nextLvCfg = cfg.transportLvList[nextLv]
    local nextExp = nextLvCfg.tranExp
    View.Img_PlayerInfo.Img_BP:SetFilledImgAmount(curExp / nextExp)
    View.Img_PlayerInfo.Txt_Profit:SetText(curExp .. "/" .. nextExp)
    View.Group_Next.Txt_Rise:SetText(nextLvCfg.reward)
  end
end

return DataModel
