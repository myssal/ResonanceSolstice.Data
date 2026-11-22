local View = require("UIExtendTips/UIExtendTipsView")
local DataModel = require("UIExtendTips/UIExtendTipsDataModel")
local Controller = {}

function Controller:Init()
  DataModel.Init()
  View.Txt_CanNum:SetText(DataModel.canUseNum)
  View.Txt_PossessNum:SetText(DataModel.hadNum)
  local color = "#FFFFFF"
  if DataModel.hadNum == 0 then
    color = "#FF0000"
  end
  View.Txt_PossessNum:SetColor(color)
  local itemCA = PlayerData:GetFactoryData(DataModel.itemId)
  View.Txt_Name:SetText(itemCA.name)
  View.Img_Icon:SetSprite(itemCA.tipsPath)
  local npcCA = PlayerData:GetFactoryData(DataModel.initParams.npcId)
  View.Img_Character:SetSprite(npcCA.qResUrl)
  Controller:RefreshNumInfo()
end

function Controller:Sub()
  if DataModel.curUseNum == 1 then
    return
  end
  DataModel.curUseNum = DataModel.curUseNum - 1
  Controller:RefreshNumInfo()
end

function Controller:Add()
  if DataModel.curUseNum >= DataModel.canUseNum or DataModel.curUseNum >= DataModel.hadNum then
    return
  end
  DataModel.curUseNum = DataModel.curUseNum + 1
  Controller:RefreshNumInfo()
end

function Controller:RefreshNumInfo()
  View.Txt_UseNum:SetText(DataModel.curUseNum)
  View.Txt_AddNum:SetText(string.format(GetText(80607469), DataModel.curUseNum * DataModel.oneAddNum))
end

function Controller:ClickItem()
  CommonTips.OpenPreRewardDetailTips(DataModel.itemId)
end

function Controller:UseItem()
  if DataModel.hadNum == 0 then
    CommonTips.OpenTips(80607470)
    return
  end
  local t = {}
  t[DataModel.itemId] = DataModel.curUseNum
  Net:SendProto("station.build_extra_warehouse", function(json)
    PlayerData:RefreshUseItems(t)
    local ws_info = PlayerData:GetHomeInfo().stations[tostring(DataModel.initParams.stationId)].ws_info
    if ws_info == nil then
      ws_info = {}
      PlayerData:GetHomeInfo().stations[tostring(DataModel.initParams.stationId)].ws_info = ws_info
    end
    local curNum = ws_info[DataModel.expandIndex + 1] or 0
    ws_info[DataModel.expandIndex + 1] = curNum + DataModel.curUseNum
    UIManager:GoBack()
    UIManager:Open("UI/HomeTrade/ExpandSuccess", tostring(DataModel.curUseNum * DataModel.oneAddNum))
  end, DataModel.curUseNum, DataModel.expandIndex)
end

function Controller:Return()
  UIManager:GoBack()
end

return Controller
