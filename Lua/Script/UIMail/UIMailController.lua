local View = require("UIMail/UIMailView")
local DataModel = require("UIMail/UIMailDataModel")
local UIMailController = {}

function UIMailController:OnReceiveMailAward(args)
  if args == nil then
    return
  end
  local isOnekey = args.isOnekey
  SdkReporter.TrackGetEmailReward("", "", isOnekey)
  self:HandleRechargeMail(args)
end

function UIMailController:HandleRechargeMail(args)
  local isOnekey = args.isOnekey
  if isOnekey == 0 then
    local mail = args.mailData
    self:ReportWebRecharge(mail)
  else
    local mails = DataModel.NomalMails
    for k, mail in pairs(mails) do
      self:ReportWebRecharge(mail)
    end
  end
end

function UIMailController:ReportWebRecharge(mail)
  if mail and mail.recv == 0 and mail.pay_id ~= nil and mail.pay_id ~= "" then
    local productId = mail.pay_id
    local productAmount = PayProductHelper.GetProductConfigPriceAmount(productId)
    local productName = PayProductHelper.GetProductConfigName(productId)
    SdkReporter.TrackBuySuccess(mail.oid, productAmount, "officalweb", mail.pay_id, productName, mail.is_first, mail.platform_amount, mail.target_oid)
  end
end

function UIMailController:OnMailEvent()
  local data = DataModel.OpenData
  Net:SendProto("mail.accredit", function(json)
    CommonTips.OpenTips(80602513)
    DataModel.OpenData = PlayerData.ServerData.mails[tostring(data.id)]
    if not data.reward then
      View.Group_MailInfo_Normal.Btn_Receive.self:SetActive(false)
    end
    View.Group_MailInfo_Normal.Btn_Delete.self:SetActive(true)
    View.Group_MailInfo_Normal.ScrollView_Content.Viewport.Txt_Content.Btn_Event.self:SetActive(false)
    DataModel:RefreshData()
  end, tostring(data.id))
end

return UIMailController
