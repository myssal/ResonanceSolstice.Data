local UIGoBack = {}
local nowCloseUI
local nowTs = 0
local lastTs = 0
local cacheBtnMap = {}
local Time = require("Common/Time")

local function FindField(tbl, targetKey)
  if tbl.Group_CommonTopLeft then
    local btn = tbl.Group_CommonTopLeft.Btn_Return
    if btn then
      return btn
    end
  end
  for key, value in pairs(tbl) do
    if key == targetKey then
      return value
    end
    if type(value) == "table" then
      local result = FindField(value, targetKey)
      if result then
        return result
      end
    end
  end
  return nil
end

local function GetObjetByTbl(btnAddress, tbl)
  local value = tbl
  local btnList = string.split(btnAddress, "/")
  for i, v in ipairs(btnList) do
    if type(value) == "table" and value[v] then
      value = value[v]
    else
      return nil
    end
  end
  return value
end

local function FindBackBtnByMapTbl(uiName, tbl)
  local cfg = PlayerData:GetFactoryData(99900114)
  if not cfg then
    return
  end
  local data = cacheBtnMap[uiName]
  if not data then
    for k, v in pairs(cfg.groupList) do
      if v.uiName == uiName then
        data = {
          uiName = uiName,
          btnAddress = v.nameBtn,
          childList = "",
          childBtnAddreeList = ""
        }
        if v.childName ~= "" then
          data.childList = string.split(v.childName, "#")
          data.childBtnAddreeList = string.split(v.childUrl, "#")
        end
        cacheBtnMap[uiName] = data
        break
      end
    end
  end
  if data then
    if data.childlist == "" then
      return GetObjetByTbl(data.btnAddress, tbl)
    else
      local count = #data.childList
      for i = 1, count do
        local panel = GetObjetByTbl(data.childList[i], tbl)
        if panel.IsActive then
          return GetObjetByTbl(data.childBtnAddreeList[i], tbl)
        end
      end
      return GetObjetByTbl(data.btnAddress, tbl)
    end
  end
  return nil
end

local function FindBackBtn()
  local url = UIManager:GetCurrentPanelURL(true)
  local lbv = UIManager:GetPanel(url)
  if not lbv then
    return
  end
  if lbv.IsPlayAnimator then
    return
  end
  nowCloseUI = url
  local UIName = url:match(".*/(.-)$")
  local modName = string.format("UI%s/UI%sView", UIName, UIName)
  local success, view = pcall(require, modName)
  local backBtn
  if success then
    backBtn = FindBackBtnByMapTbl(UIName, view)
    backBtn = backBtn or FindField(view, "Btn_Return")
  end
  return backBtn
end

local function CloseActivityMain()
  local ActivityMainDataModel = require("UIActivityMain/UIActivityMainDataModel")
  local activeList = ActivityMainDataModel:GetActivityCAList()
  local url = UIManager:GetCurrentPanelURL()
  for k, v in pairs(activeList) do
    if v.showUI == url then
      nowCloseUI = url
      return true
    end
  end
  return false
end

local function FunctionEnable()
  if ChannelUJoyHelper.IsChannelPC() then
    return true
  end
  if ChannelUJoyHelper.GetChannel() == "" then
    return true
  end
  return false
end

IsBanEsc = false

local function GoBack()
  nowTs = nowTs + Time.deltaTime
  if CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.Escape) then
    if not FunctionEnable then
      return
    end
    local waitPanel = UIManager:GetPanel("UI/Common/NetMask")
    if waitPanel and waitPanel.IsActive then
      return
    end
    if GuideHelper.HasGuide() or IsBanEsc then
      return
    end
    if 0.5 < nowTs - lastTs then
      nowCloseUI = nil
    end
    if nowCloseUI and UIManager:GetCurrentPanelURL() == nowCloseUI then
      return
    end
    lastTs = nowTs
    nowCloseUI = nil
    local backBtn
    local result = CloseActivityMain()
    if result then
      local ActivityMainView = require("UIActivityMain/UIActivityMainView")
      backBtn = FindField(ActivityMainView, "Btn_Return")
    else
      backBtn = FindBackBtn()
    end
    if backBtn and not backBtn:IsNull() and backBtn.IsActive then
      backBtn:BtnClick()
    end
  end
end

UIGoBack.GoBack = GoBack
return UIGoBack
