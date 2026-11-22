local view = require("UIDialog/UIDialogView")
local base = require("UIDialog/Model_PlotBase")
local DataModel = require("UIDialog/UIDialogDataModel")
local DialogReviewDataModel = require("UIDialogReview/UIDialogReviewDataModel")
local PlotCheckBox = Class.New("PlotCheckBox", base)
local finish, plotCA

local function Trim(str)
  if str == nil then
    return ""
  end
  return string.gsub(str, "^%s*(.-)%s*$", "%1")
end

local function GetReturnIndex(index)
  if plotCA == nil then
    return nil
  end
  local prefix, value = string.match(tostring(plotCA.name or ""), "^%s*([^=]+)%s*=%s*(.-)%s*$")
  if Trim(prefix) ~= "returnIndex" then
    return nil
  end
  if value == nil or value == "" then
    return nil
  end
  local returnList = string.split(value, "-") or {}
  local returnIndex = tonumber(returnList[index])
  if returnIndex == nil or returnIndex <= 0 then
    return nil
  end
  return returnIndex
end

local function ShouldExitAfterChoice(index)
  local key = "skipChose" .. index
  local value
  local factory = PlotFactory
  if factory == nil and CBus ~= nil then
    factory = CBus:GetFactory(CS.FactoryName.PlotFactory, false, true)
  end
  if factory ~= nil and plotCA ~= nil and plotCA.id ~= nil then
    local ok, ca = pcall(function()
      return factory:GetCA(tonumber(plotCA.id))
    end)
    if ok and ca ~= nil then
      do
        local getValueOk, rawValue = pcall(function()
          return ca:GetValue(key)
        end)
        if getValueOk then
          value = rawValue
        end
      end
    end
  end
  if value == nil and plotCA ~= nil then
    value = plotCA[key]
  end
  return value == true or value == 1 or value == "true" or value == "True"
end

function PlotCheckBox:Finish(index)
  local tList = {}
  local plotList = {}
  local plotList_i = plotCA["plotList_" .. index]
  for i = 1, #plotList_i do
    plotList[i] = PlayerData:GetFactoryData(plotList_i[i].plotID, "PlotFactory")
  end
  if plotCA["paragraph_" .. index] > 0 then
    local paCa = PlayerData:GetFactoryData(plotCA["paragraph_" .. index], "ParagraphFactory")
    if paCa.mod == "\230\174\181\232\144\189\232\132\154\230\156\172" then
      local info
      local isMale = PlayerData.IsMale()
      local path
      if paCa.girlPath ~= nil and paCa.girlPath ~= "" then
        path = isMale and paCa.path or paCa.girlPath
      else
        path = paCa.path
      end
      if plotCA["parg_" .. index] == nil or plotCA["parg_" .. index] == "" then
        local pattern
        if paCa.girlPattern ~= nil and paCa.girlPattern ~= "" then
          pattern = isMale and paCa.pattern or paCa.girlPattern
        else
          pattern = paCa.pattern
        end
        info = ParseParagraphScript():Parse(path, pattern)
      else
        info = ParseParagraphScript():Parse(path, plotCA["parg_" .. index])
      end
      print_r(info)
      print_r(info.plotBaseCAs)
      for k, v in pairs(info.plotBaseCAs) do
        plotList[k] = v
      end
    elseif paCa.mod == "\230\174\181\232\144\189" then
      local curPlotList
      if paCa.plotListGril ~= nil and 0 < #paCa.plotListGril then
        curPlotList = PlayerData.IsMale() and paCa.plotList or paCa.plotListGril
      else
        curPlotList = paCa.plotList
      end
      for k, v in pairs(curPlotList) do
        plotList[k] = PlayerData:GetFactoryData(v, "PlotFactory")
      end
    end
  end
  local returnIndex = GetReturnIndex(index)
  local plotController = require("UIDialog/Model_PlotController")
  local insertCount = 0
  if tList ~= nil and 0 < #tList then
    insertCount = insertCount + plotController.InsertPlotList(tList)
  end
  if plotList ~= nil and 0 < #plotList then
    insertCount = insertCount + plotController.InsertPlotList(plotList)
  end
  if ShouldExitAfterChoice(index) then
    plotController.InsertCheckBoxExit(insertCount)
  elseif returnIndex ~= nil then
    plotController.RecordCheckBoxReturnIndex(returnIndex, insertCount)
  end
  view.Group_Option.self:SetActive(false)
  finish = true
  table.insert(DialogReviewDataModel.extra_options, index)
  PlotManager:SetSelection(plotCA.id, plotCA.name, index)
end

function PlotCheckBox.Ctor()
end

function PlotCheckBox:OnStart(ca)
  plotCA = ca
  finish = false
  view.Group_Option.self:SetActive(true)
  local text, girlText, isActive
  for i = 1, 3 do
    text = plotCA["text_" .. i]
    isActive = text ~= nil and text ~= ""
    view.Group_Option["Btn_Option0" .. i].self:SetActive(isActive)
    if isActive then
      if DataModel.isBoy == false then
        girlText = plotCA["girlText_" .. i]
        if girlText ~= nil and girlText ~= "" then
          text = girlText
        end
      end
      view.Group_Option["Btn_Option0" .. i].Txt_Option:SetText(text)
    end
  end
end

function PlotCheckBox.GetState()
  return finish
end

function PlotCheckBox:Dtor()
end

return PlotCheckBox
