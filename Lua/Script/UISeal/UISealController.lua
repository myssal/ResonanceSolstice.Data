local View = require("UISeal/UISealView")
local DataModel = require("UISeal/UISealDataModel")
local Controller = {}

function Controller:Init()
  DataModel.Init()
  if DataModel.CurSealNum < DataModel.SealNumMax or DataModel.IsConvert then
    View.Group_Single:SetActive(true)
    View.Group_Multi:SetActive(false)
    Controller:ShowSingleSeal()
  else
    View.Group_Single:SetActive(false)
    View.Group_Multi:SetActive(true)
    Controller:ShowMultiSeal()
  end
end

function Controller:ShowSingleSeal()
  local UI_WitchMain_posui = View.Group_Single.transform:Find("UI_WitchMain_posui")
  if UI_WitchMain_posui then
    UI_WitchMain_posui.gameObject:SetActive(false)
  end
  local UI_WitchMain_boom = View.Group_Single.transform:Find("UI_WitchMain_boom")
  if UI_WitchMain_boom then
    UI_WitchMain_boom.gameObject:SetActive(false)
    UI_WitchMain_boom.gameObject:SetActive(true)
  end
  local cfg = PlayerData:GetFactoryData(DataModel.NewSealId)
  View.Group_Single.Btn_:SetSprite(cfg.iconPath)
  View.Group_Single.Img_.Txt_Name:SetText(cfg.name)
  View.Group_Multi.Group_Deal.Img_Drop:SetActive(false)
end

function Controller:ShowMultiSeal()
  local cfg = PlayerData:GetFactoryData(DataModel.NewSealId)
  View.Group_Multi.Img_.Txt_Name:SetText(cfg.name)
  View.Group_Multi.Btn_:SetSprite(cfg.iconPath)
  View.Group_Multi.Group_Deal.Img_Drop:SetActive(true)
  Controller:RefreshSealGrid()
end

function Controller:SetSealElement(element, elementIndex)
  element.Group_Empty:SetActive(true)
  element.Group_Pick:SetActive(DataModel.CurSelectPos == elementIndex and not DataModel.IsSelected)
  local UI_WitchMain_posui = element.Img_Seal.transform:Find("UI_WitchMain_posui")
  if UI_WitchMain_posui then
    UI_WitchMain_posui.gameObject:SetActive(false)
  end
  local UI_WitchMain_boom = element.Img_Seal.transform:Find("UI_WitchMain_boom")
  if UI_WitchMain_boom then
    UI_WitchMain_boom.gameObject:SetActive(false)
  end
  element.Btn_Instead:SetClickParam(elementIndex)
  local seal = DataModel.SealList[elementIndex]
  local cfg = PlayerData:GetFactoryData(seal.id)
  element.Img_Seal:SetSprite(cfg.iconPath)
  element.Txt_Seal:SetText(cfg.name)
end

function Controller:RefreshSealGrid()
  View.Group_Multi.Group_Deal.StaticGrid_Seal.grid.self:SetDataCount(DataModel.SealNumMax)
  View.Group_Multi.Group_Deal.StaticGrid_Seal.grid.self:RefreshAllElement()
  View.Group_Multi.Group_Deal.Img_Drop:SetActive(not DataModel.IsSelected)
  View.Group_Multi.Group_Deal.Img_DropPick:SetActive(DataModel.CurSelectPos == -1 and not DataModel.IsSelected)
end

function Controller:ClickInstead(idx)
  if DataModel.CurSelectPos ~= idx then
    DataModel.CurSelectPos = idx
    Controller:RefreshSealGrid()
  else
    if DataModel.IsSelected then
      return
    end
    local index = idx
    if 0 < idx then
      index = idx - 1
    else
      index = -1
    end
    Net:SendProto("activity.replace_seal", function(json)
      DataModel.IsSelected = true
      View.Group_Multi.Group_Deal.Img_DropPick:SetActive(false)
      View.Group_Multi.Group_Deal.Img_Drop:SetActive(false)
      DataModel.CurSelectPos = 0
      WitchData.GetWitchesData().user_seal = json.user_seal
      WitchData.GetWitchesData().other_seal = {}
      DataModel.InitSealData()
      if idx == -1 then
        CommonTips.OpenTips(80610332)
        View.self:CloseUI()
        View.self:Confirm()
        if DataModel.WitchEventNextId and 0 < DataModel.WitchEventNextId then
          local EventDataModel = require("UIWitchesEvent/UIWitchesEventDataModel")
          EventDataModel.DealEvent(DataModel.WitchEventNextId)
          DataModel.WitchEventNextId = nil
        end
        return
      end
      CommonTips.OpenTips(80610331)
      local element = View.Group_Multi.Group_Deal.StaticGrid_Seal.grid[idx]
      local UI_WitchMain_posui = element.Img_Seal.transform:Find("UI_WitchMain_posui")
      if UI_WitchMain_posui then
        UI_WitchMain_posui.gameObject:SetActive(true)
      end
      View.self:StartC(LuaUtil.cs_generator(function()
        coroutine.yield(CS.UnityEngine.WaitForSeconds(1))
        Controller:RefreshSealGrid()
        if UI_WitchMain_posui then
          UI_WitchMain_posui.gameObject:SetActive(true)
        end
        local UI_WitchMain_boom = element.Img_Seal.transform:Find("UI_WitchMain_boom")
        if UI_WitchMain_boom then
          UI_WitchMain_boom.gameObject:SetActive(true)
        end
      end))
    end, tostring(DataModel.OtherSeal) .. ":" .. tostring(index), WitchData.GetActivityId())
  end
end

return Controller
