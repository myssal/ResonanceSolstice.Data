local View = require("UIDownload/UIDownloadView")
local DataModel = require("UIDownload/UIDownloadDataModel")
local CommonItem = require("Common/BtnItem")
local Controller = {}
local progressView, time, timer, hint, isActiveRewardView, isGameIn

local function GetCompareFileSize()
  if DataModel.SizeInfo == "" then
    DataModel.SizeInfo = DownloadAndPlayController.CompareFile()
    DataModel.Hint = string.format(GetText(80611263), DataModel.SizeInfo)
  end
end

local function SetlRetryBtn(isRetry)
  DataModel.IsRetry = isRetry
  progressView.Btn_Retry:SetActive(isRetry)
  progressView.Group_Progress.Img_ProgressStop:SetActive(isRetry)
end

local function SetRewardItem()
  if isActiveRewardView and next(DataModel.GetRewardList()) ~= nil then
    progressView.Group_Reward:SetActive(true)
    progressView.Group_Reward.StaticGrid_Reward.grid.self:SetDataCount(#DataModel.GetRewardList())
    progressView.Group_Reward.StaticGrid_Reward.grid.self:RefreshAllElement()
  end
end

local function onFinish()
  isActiveRewardView = isGameIn and PlayerData.IsExistRewardForGuideAsset()
  View.Group_Reward.Group_UnFinish:SetActive(true)
  View.Group_Reward.Btn_Reward:SetActive(false)
  if DownloadAndPlayController.IsGuideAsset == false and isActiveRewardView then
    DataModel.Hint = DownloadAndPlayController.GetText(22)
    DataModel.IsDownloading = false
    progressView = View.Group_Reward
    progressView:SetActive(true)
    SetlRetryBtn(false)
    progressView.Group_Progress:SetActive(false)
    View.Group_Prompt:SetActive(false)
    View.Group_PromptNew:SetActive(false)
    SetRewardItem()
    View.Group_Reward.Btn_Reward:SetActive(true)
    View.Group_Reward.Group_UnFinish:SetActive(false)
    return true
  end
  return false
end

function Controller.Init(IsGameIn)
  hint = ""
  time = 50
  timer = 50
  isGameIn = IsGameIn
  DataModel.IsDownloading = DownloadAndPlayController.IsDownloading
  DownloadAndPlayController.Init()
  if onFinish() then
    return
  end
  
  function DownloadAndPlayController.failCallback()
    DataModel.Hint = DownloadAndPlayController.GetText(4)
    DataModel.SizeInfo = ""
    DataModel.IsDownloading = false
    SetlRetryBtn(true)
  end
  
  if isActiveRewardView then
    progressView = View.Group_Reward
    View.Group_Loading:SetActive(false)
  else
    progressView = View.Group_Loading
    View.Group_Reward:SetActive(false)
  end
  SetlRetryBtn(DataModel.IsRetry)
  if DataModel.IsDownloading then
    DataModel.Hint = GetText(80611286)
    View.Group_Prompt:SetActive(false)
    View.Group_PromptNew:SetActive(false)
    progressView:SetActive(true)
    SetRewardItem()
  else
    View.Group_Prompt:SetActive(not isActiveRewardView)
    View.Group_PromptNew:SetActive(isActiveRewardView)
    progressView:SetActive(false)
    local result = DownloadAndPlayController.GetNetworkState()
    GetCompareFileSize()
    local text = DataModel.Hint
    local is5G = false
    if result == 2 then
    elseif result == 1 then
      is5G = true
    else
      text = DownloadAndPlayController.GetText(23)
      DataModel.IsDownloading = false
    end
    local prompt
    if isActiveRewardView then
      prompt = View.Group_PromptNew
      if next(DataModel.GetRewardList()) ~= nil then
        prompt.Group_Reward:SetActive(true)
        prompt.Group_Reward.StaticGrid_Reward.grid.self:SetDataCount(#DataModel.GetRewardList())
        prompt.Group_Reward.StaticGrid_Reward.grid.self:RefreshAllElement()
      else
        prompt.Group_Reward:SetActive(false)
      end
    else
      prompt = View.Group_Prompt
    end
    prompt.Group_Warning:SetActive(is5G)
    prompt.Txt_Prompt:SetText(text)
  end
end

function Controller.OnClickDownload()
  SetlRetryBtn(false)
  if DownloadAndPlayController.GetNetworkState() == 0 or DownloadAndPlayController.IsGuideAsset == false then
    UIManager:GoBack(false)
    return
  end
  GetCompareFileSize()
  DataModel.Hint = GetText(80611286)
  View.Group_Prompt:SetActive(false)
  View.Group_PromptNew:SetActive(false)
  progressView:SetActive(true)
  progressView.Group_Progress:SetActive(true)
  SetRewardItem()
  progressView.Group_Progress.Img_Progress:SetFilledImgAmount(0)
  progressView.Group_Progress.Img_ProgressStop:SetFilledImgAmount(0)
  progressView.Group_Progress.Img_ProgressStop:SetActive(false)
  progressView.Group_Progress.Txt_Progress:SetText("")
  progressView.Group_Progress.Txt_Progress2:SetText("")
  DownloadAndPlayController.StartDownload(function()
    onFinish()
  end)
  DataModel.IsDownloading = true
end

function Controller.UpdateDownloadView()
  time = time + 1
  if time > timer then
    time = 0
    if DataModel.IsDownloading then
      DownloadAndPlayController.UpdateDownloadInfo()
      DataModel.IsDownloading = DownloadAndPlayController.IsDownloading
      if DataModel.IsDownloading == false then
        onFinish()
      end
      local percent = DownloadAndPlayController.percent
      if 1 < percent then
        percent = 1
      end
      progressView.Group_Progress.Img_Progress:SetFilledImgAmount(percent)
      progressView.Group_Progress.Txt_Progress:SetText(DownloadAndPlayController.downloadInfo)
      progressView.Group_Progress.Txt_Progress2:SetText(DownloadAndPlayController.percentInfo)
    end
    if not isActiveRewardView and DataModel.Hint ~= hint then
      hint = DataModel.Hint
      View.Group_Loading.Txt_Prompt:SetText(hint)
    end
  end
end

function Controller.SetElement(element, elementIndex)
  local data = DataModel.GetRewardList()
  if next(data) ~= nil and data[tonumber(elementIndex)] ~= nil then
    data = data[tonumber(elementIndex)]
    element.Group_Item.Btn_Item:SetClickParam(tostring(elementIndex))
    CommonItem:SetItem(element.Group_Item, {
      id = data.id,
      num = data.num
    }, EnumDefine.ItemType.Item)
  else
    element:SetActive(false)
  end
end

function Controller.SetItemBtn(str)
  local data = DataModel.GetRewardList()
  if next(data) ~= nil and data[tonumber(str)] ~= nil then
    data = data[tonumber(str)]
    CommonTips.OpenRewardDetail(data.id, data.num, true)
  end
end

function Controller.OnClickReward()
  Net:SendProto("main.package_reward", function(json)
    PlayerData:GetUserInfo().reward_package = 300
    UIManager:GoBack(false)
    CommonTips.OpenShowItem(json.reward)
  end)
end

return Controller
