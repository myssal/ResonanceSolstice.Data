local View = require("UIGuKaUpgrade/UIGuKaUpgradeView")
local DataModel = require("UIGuKaUpgrade/UIGuKaUpgradeDataModel")
local Controller = {}

function Controller:Init()
  DataModel.Init()
  DataModel.CurSelectGuKaIndex = 1
  DataModel.CurSelectGuKaId = DataModel.BagData[1].id
  Controller:RefreshBagElement()
  Controller:RefreshCurrency()
  Controller:RefreshSelectGuKaInfo()
  local gridId = WitchData.GetGridId()
  local gridData = WitchData.GetGridData(gridId)
  DataModel.IsZhanBu = gridData.event == tostring(88800233)
  View.Group_Effect:SetActive(false)
end

function Controller:SetCurrencyElement(element, elementIndex)
  local count = 0
  local iconPath = ""
  if elementIndex == 1 then
    count = WitchData.GetWitchesData().coin
    local parkMapCA = WitchData.GetParkMapCA()
    local coinInfo = parkMapCA and parkMapCA.dreamCoin and parkMapCA.dreamCoin[1]
    local coinCA = coinInfo and PlayerData:GetFactoryData(coinInfo.id, "ItemFactory")
    if coinCA then
      iconPath = coinCA.iconPath or ""
    end
  end
  element.Img_Item:SetSprite(iconPath)
  element.Txt_Num:SetText(count)
end

function Controller:RefreshCurrency()
  View.StaticGrid_Currency.grid.self:SetDataCount(1)
  View.StaticGrid_Currency.grid.self:RefreshAllElement()
end

function Controller:SetBagElement(element, elementIndex)
  local data = DataModel.BagData[elementIndex]
  if not data then
    return
  end
  local cfg = PlayerData:GetFactoryData(data.id)
  if not cfg then
    return
  end
  local x = element.Group_GuKa.transform.anchoredPosition.x
  if elementIndex % 2 == 0 then
    element.Group_GuKa.transform.anchoredPosition = Vector2(x, -10)
  else
    element.Group_GuKa.transform.anchoredPosition = Vector2(x, 40)
  end
  element.Group_GuKa.Img_:SetSprite(cfg.iconPath)
  element.Group_GuKa.Img_Symbol:SetSprite(cfg.symbol)
  element.Group_GuKa.Img_NameBg.Txt_Name:SetText(cfg.name)
  element.Group_GuKa.Img_Select.Txt_Name:SetText(cfg.name)
  element.Group_GuKa.Group_Effect:SetActive(tostring(cfg.id) == DataModel.CurSelectGuKaId)
  element.Group_GuKa.Img_Select:SetActive(tostring(cfg.id) == DataModel.CurSelectGuKaId)
  element.Group_GuKa.Btn_:SetClickParam(elementIndex)
end

function Controller:RefreshBagElement()
  View.Group_Pack.ScrollGrid_.grid.self:SetDataCount(#DataModel.BagData)
  View.Group_Pack.ScrollGrid_.grid.self:RefreshAllElement()
end

function Controller:SetGuKaElement(element, elementIndex)
  element.Img_Select:SetActive(elementIndex == DataModel.CurSelectGuKaIndex)
end

function Controller:SelectGuKa(idx)
  DataModel.CurSelectGuKaIndex = idx
  DataModel.CurSelectGuKaId = DataModel.BagData[idx].id
  Controller:RefreshSelectGuKaInfo()
  Controller:RefreshBagElement()
end

function Controller:RefreshSelectGuKaInfo()
  local data = DataModel.BagData[DataModel.CurSelectGuKaIndex]
  if not data then
    return
  end
  local cfg = PlayerData:GetFactoryData(data.id)
  if not cfg then
    return
  end
  local costListCfg = PlayerData:GetFactoryData(cfg.upgradeCostList[data.lv].id)
  if not costListCfg then
    return
  end
  View.Group_Attr.Txt_GuKaLevel:SetText(data.lv .. "/" .. data.maxLv)
  View.Group_Attr2.Txt_GuKaLevel:SetText(data.lv + 1 .. "/" .. data.maxLv)
  if table.count(cfg.skillList) > 0 then
    local skillCfg = PlayerData:GetFactoryData(cfg.skillList[1].skillId)
    if skillCfg.isPercent then
      local value1 = skillCfg.minAttrSN + skillCfg.digitSN * (data.lv - 1)
      value1 = value1 * 100
      local value2 = skillCfg.minAttrSN + skillCfg.digitSN * data.lv
      value2 = value2 * 100
      View.Group_Attr.Group_Entry.Txt_Entry_1:SetText(string.format(skillCfg.description, value1 .. "%"))
      View.Group_Attr2.Group_Entry.Txt_Entry_1:SetText(string.format(skillCfg.description, value2 .. "%"))
    else
      View.Group_Attr.Group_Entry.Txt_Entry_1:SetText(string.format(skillCfg.description, skillCfg.minAttrSN + skillCfg.digitSN * (data.lv - 1)))
      View.Group_Attr2.Group_Entry.Txt_Entry_1:SetText(string.format(skillCfg.description, skillCfg.minAttrSN + skillCfg.digitSN * data.lv))
    end
  else
    View.Group_Attr.Group_Entry.Txt_Entry_1:SetText("")
    View.Group_Attr2.Group_Entry.Txt_Entry_1:SetText("")
  end
  View.Group_GukaInfo.Txt_GuKaName:SetText(cfg.name)
  View.Group_GukaInfo.Img_GukaTipsImg:SetSprite(cfg.tipsPath)
  local costList = costListCfg.materialList
  View.Group_Cost.Group_1.Img_Money:SetSprite(PlayerData:GetFactoryData(costList[1].id).iconPath)
  View.Group_Cost.Group_1.Txt_Money:SetText(costList[1].num)
end

function Controller:TryUpgradeGuKa()
  local data = DataModel.BagData[DataModel.CurSelectGuKaIndex]
  if not data then
    return
  end
  local guka = PlayerData:GetFactoryData(data.id)
  if not guka then
    return
  end
  if DataModel.RemainUpgradeCount <= 0 then
    CommonTips.OpenTips(80610251)
    return
  end
  local costListCfg = PlayerData:GetFactoryData(guka.upgradeCostList[data.lv].id)
  if not costListCfg then
    return
  end
  local haveNum = WitchData.GetWitchesData().coin
  if haveNum < costListCfg.materialList[1].num then
    CommonTips.OpenTips(80610252)
    return
  end
  Net:SendProto("activity.upgrade", function(json)
    local function cb()
      WitchData.GetWitchesData().coin = WitchData.GetWitchesData().coin - costListCfg.materialList[1].num
      
      Controller:ShowUpgradeResult(data.id, data.lv)
      WitchData.GetWitchesData().guka[tostring(data.id)].lv = WitchData.GetWitchesData().guka[tostring(data.id)].lv + 1
      WitchData.GetWitchesData().guka_num = WitchData.GetWitchesData().guka_num - 1
      DataModel.Init()
      Controller:RefreshBagElement()
      Controller:RefreshCurrency()
      Controller:RefreshSelectGuKaInfo()
    end
    
    local cfg = PlayerData:GetFactoryData(88800235)
    View.Video_Majila:SetActive(cfg.isVideo)
    if cfg.isVideo then
      View.Video_Majila.self:Play(cfg.videoPath, false, false, true, function()
        View.Video_Majila.self:Stop()
        View.Video_Majila:SetActive(false)
        cb()
      end)
    else
      cb()
    end
  end, data.id, WitchData.GetActivityId())
end

function Controller:ShowUpgradeResult(id, lv)
  local cfg = PlayerData:GetFactoryData(id)
  local maxLv = cfg.maxLv
  View.Group_Effect.Img_GuKaImg:SetSprite(cfg.tipsPath)
  View.Group_Effect.Txt_GuKaLevel:SetText(lv .. "/" .. maxLv)
  View.Group_Effect.Txt_GuKaLevel2:SetText(lv + 1 .. "/" .. maxLv)
  View.Group_Effect:SetActive(true)
end

return Controller
