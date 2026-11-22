local ComBtnShareComp = {}

function ComBtnShareComp.InitButton(View)
  local isShow = SdkShareHelper.IsShareUsable()
  ComViewComp.SetActive(View, isShow)
end

function ComBtnShareComp.ShowButton(View)
  local isShow = SdkShareHelper.IsShareUsable()
  if isShow then
    ComViewComp.SetActive(View, true)
  end
end

function ComBtnShareComp.HideButton(View)
  local isShow = SdkShareHelper.IsShareUsable()
  ComViewComp.SetActive(View, false)
end

function ComBtnShareComp.SetActiveButton(a, view)
  local isShow = SdkShareHelper.IsShareUsable()
  if not isShow then
    ComViewComp.SetActive(view, false)
    return
  end
  ComViewComp.SetActive(view, a)
end

function ComBtnShareComp.OnClickShareButton(View, args, cb)
  SdkShareHelper.StartShare(args, cb)
end

function ComBtnShareComp.OnClickShareWithNoneArgs(View)
  local args = {}
  
  local function cb()
  end
  
  SdkShareHelper.StartShare(args, cb)
end

return ComBtnShareComp
