local View = require("UIActivityMonthlyCard/UIActivityMonthlyCardView")
local DataModel = require("UIActivityMonthlyCard/UIActivityMonthlyCardDataModel")
local BtnItem = require("Common/BtnItem")
local Controller = {}

function Controller:Init()
  DataModel.Init()
  Controller:RefreshBtnShow()
  Controller:RefreshRemainTxt()
  View.Txt_Time:SetText(string.format(GetText(80610650), os.date("%Y/%m/%d %H:%M", DataModel.endTimeStamp)))
  View.StaticGrid_Rewards.grid.self:RefreshAllElement()
  View.Img_Title:SetSprite(GetResPath(88300215))
  Controller:RefreshSpineShow()
end

function Controller:RefreshBtnShow()
  local data = PlayerData:GetActivityData(86000069)
  local isGet = false
  if data and data.rec_today then
    isGet = TimeUtil:GetServerTimeStamp() <= data.rec_today
  end
  View.Btn_Claim.self:SetActive(not isGet)
  View.Img_Claimed.self:SetActive(isGet and DataModel.GetRemainCount() > 0)
  View.Btn_Buy.self:SetActive(true)
end

function Controller:RefreshRemainTxt()
  View.Txt_Num:SetText(string.format(GetText(80610614), DataModel.GetRemainCount(), DataModel.totalCount))
end

function Controller:RefreshRewardElement(element, elementIndex)
  local info = DataModel.rewardList[elementIndex]
  BtnItem:SetItem(element, {
    id = info.id,
    num = info.num
  })
  element.Btn_Item:SetClickParam(info.id)
  element.Txt_Num:SetText(string.format(GetText(80610750), info.num))
  local data = PlayerData:GetActivityData(86000069)
  local isGet = false
  if data and data.rec_today then
    isGet = TimeUtil:GetServerTimeStamp() <= data.rec_today
  end
  element.Img_Claimed:SetActive(isGet)
  element.Img_Claimed:SetSprite(GetResPath(88300216))
end

function Controller:clickRewardItem(str)
  local itemId = tonumber(str)
  CommonTips.OpenRewardDetail(itemId)
end

function Controller:ClickHelp()
  CommonTips.OpenHelp(80306793)
end

function Controller:ClickClaim()
  Net:SendProto("main.rec_activity_month_card", function(json)
    PlayerData:GetHomeInfo().activity_monthly_req_back_num = 0
    PlayerData:RefreshActivityData(86000069, json.activity_info)
    View.StaticGrid_Rewards.grid.self:RefreshAllElement()
    Controller:RefreshBtnShow()
    Controller:RefreshRemainTxt()
    local ActivityMainController = require("UIActivityMain/UIActivityMainController")
    ActivityMainController:RefreshLeftRedState()
    CommonTips.OpenShowItem(json.reward, function()
      if DataModel.GetRemainCount() == 0 then
        CommonTips.OnPrompt(80610651, nil, nil, function(json)
          Controller:ClickBuy()
        end)
      end
    end, nil, true)
  end)
end

function Controller:ClickBuy()
  local data = {}
  data.jumpParams = "3|82100020"
  data.shopId = 80300323
  UIManager:Open("UI/Store/Store", Json.encode(data))
end

function Controller:RefreshSpineShow()
  local data = PlayerData:GetFactoryData(86000069)
  if not data or not data.npcId then
    return
  end
  local npcConfig = PlayerData:GetFactoryData(data.npcId, "NPCFactory")
  if not npcConfig or string.nilorempty(npcConfig.spineUrl) then
    return
  end
  View.SpineAnimation_Illus:SetData(npcConfig.spineUrl)
  View.SpineAnimation_Illus:SetAnchoredPositionX(npcConfig.spineOffsetX)
  View.SpineAnimation_Illus:SetAnchoredPositionY(npcConfig.spineOffsetY)
  View.SpineAnimation_Illus:SetLocalScale(Vector3(1, 1, 1) * npcConfig.spineScale)
end

return Controller
