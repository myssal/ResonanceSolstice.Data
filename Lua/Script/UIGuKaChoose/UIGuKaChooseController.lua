local View = require("UIGuKaChoose/UIGuKaChooseView")
local DataModel = require("UIGuKaChoose/UIGuKaChooseDataModel")
local Controller = {}

function Controller:Init()
  DataModel.Init()
  View.Group_Sure:SetActive(DataModel.CurSelectIdx ~= 0)
  View.Group_Choose:SetActive(not DataModel.IsOptional)
  View.Group_Optional:SetActive(DataModel.IsOptional)
  if not DataModel.IsOptional then
    Controller:SetGuKaElement()
  else
    View.Group_Optional.ScrollGrid_.grid.self:SetDataCount(#DataModel.GuKaList)
    View.Group_Optional.ScrollGrid_.grid.self:RefreshAllElement()
  end
  Controller:ResetRefreshBtnShow()
end

function Controller:TrySelectGuKa(idx)
  if DataModel.CurSelectIdx ~= idx then
    DataModel.CurSelectIdx = idx
    if not DataModel.IsOptional then
      Controller:SetGuKaElement()
    else
      View.Group_Optional.ScrollGrid_.grid.self:SetDataCount(#DataModel.GuKaList)
      View.Group_Optional.ScrollGrid_.grid.self:RefreshAllElement()
    end
  end
  View.Group_Sure:SetActive(DataModel.CurSelectIdx ~= 0)
end

function Controller:SetGuKaElement()
  local gukaCount = DataModel.IsOptional and table.count(DataModel.GuKaList) or 3
  for i = 1, gukaCount do
    local gukaId = DataModel.GuKaList[i]
    local gukaCA = PlayerData:GetFactoryData(gukaId, "GuKaFactory")
    if not gukaCA then
      return
    end
    local element = View.Group_Choose["Group_" .. i]
    element.Group_Attr.Txt_GuKaLevel:SetText(DataModel.GetGuKaLevel(gukaId))
    element.Group_Attr.Group_Entry.Txt_Entry_1:SetText(DataModel.GetGuKaAttrDesc(gukaId))
    element.Img_GuKa:SetSprite(gukaCA.tipsPath)
    local cfg = PlayerData:GetFactoryData(gukaCA.id)
    element.Group_Attr.Txt_GuKaName:SetText(cfg.name)
    element.Group_Attr.Group_Select:SetActive(i == DataModel.CurSelectIdx)
    element.transform:Find("UI_ring_lizi").gameObject:SetActive(i == DataModel.CurSelectIdx)
    element.transform:Find("UI_fire_003").gameObject:SetActive(false)
    if element.Group_Attr.Img_Symbol then
      element.Group_Attr.Img_Symbol:SetSprite(gukaCA.symbol or "")
    end
  end
end

function Controller:SetGuKaOptionalElement(element, elementIndex)
  local gukaId = DataModel.GuKaList[elementIndex]
  local gukaCA = PlayerData:GetFactoryData(gukaId, "GuKaFactory")
  if not gukaCA then
    return
  end
  local elementCtr = element.Group_1
  elementCtr.Group_Attr.Txt_GuKaLevel:SetText(DataModel.GetGuKaLevel(gukaId))
  elementCtr.Group_Attr.Group_Entry.Txt_Entry_1:SetText(DataModel.GetGuKaAttrDesc(gukaId))
  elementCtr.Img_GuKa:SetSprite(gukaCA.tipsPath)
  local cfg = PlayerData:GetFactoryData(gukaCA.id)
  elementCtr.Group_Attr.Txt_GuKaName:SetText(cfg.name)
  elementCtr.Group_Attr.Group_Select:SetActive(elementIndex == DataModel.CurSelectIdx)
  elementCtr.transform:Find("UI_ring_lizi").gameObject:SetActive(elementIndex == DataModel.CurSelectIdx)
  elementCtr.transform:Find("UI_fire_003").gameObject:SetActive(false)
  elementCtr.Btn_SelectGuKa:SetClickParam(elementIndex)
  if elementCtr.Group_Attr.Img_Symbol then
    elementCtr.Group_Attr.Img_Symbol:SetSprite(gukaCA.symbol or "")
  end
end

function Controller:ResetRefreshBtnShow()
  View.Group_Choose.Group_Refresh:SetActive(DataModel.IsRefresh)
  if DataModel.IsRefresh then
    local witchesData = WitchData.GetWitchesData()
    local remainFreeCount = witchesData.free_guka_refresh or 0
    local remainPayCount = witchesData.pay_guka_refresh or 0
    View.Group_Choose.Group_Refresh.Txt_Cost:SetActive(0 < remainFreeCount or 0 < remainPayCount)
    View.Group_Choose.Group_Refresh.Btn_Refresh.Group_Pay1:SetActive(0 < remainFreeCount)
    View.Group_Choose.Group_Refresh.Btn_Refresh.Group_Pay2:SetActive(remainFreeCount == 0 and 0 < remainPayCount)
    View.Group_Choose.Group_Refresh.Group_NoInteractive:SetActive(remainPayCount == 0 and remainFreeCount == 0)
    if 0 < remainFreeCount then
      View.Group_Choose.Group_Refresh.Txt_Cost:SetText(string.format(GetText(80611469), remainFreeCount, witchesData.max_free_guka_refresh or 3))
    elseif 0 < remainPayCount then
      local ca = WitchData.GetParkMapCA()
      local payRefreshItem = ca.payRefreshItem[1]
      View.Group_Choose.Group_Refresh.Txt_Cost:SetText(string.format(GetText(80611469), remainPayCount, ca.payRefreshNum))
      View.Group_Choose.Group_Refresh.Btn_Refresh.Group_Pay2.Txt_50:SetText(payRefreshItem.num)
      local itemCA = PlayerData:GetFactoryData(payRefreshItem.id)
      View.Group_Choose.Group_Refresh.Btn_Refresh.Group_Pay2.Img_:SetSprite(itemCA.iconPath)
    end
  end
end

function Controller:ClickRefresh()
  local witchesData = WitchData.GetWitchesData()
  local remainFreeCount = witchesData.free_guka_refresh or 0
  local remainPayCount = witchesData.pay_guka_refresh or 0
  local useItem = {}
  if remainFreeCount == 0 then
    if 0 < remainPayCount then
      local ca = WitchData.GetParkMapCA()
      local payRefreshItem = ca.payRefreshItem
      for k, v in ipairs(payRefreshItem) do
        useItem[v.id] = v.num
        local haveNum = PlayerData:GetGoodsById(v.id).num
        if haveNum < v.num then
          if v.id == 11400005 then
            CommonTips.OpenWitchPrompt(80611465, nil, nil, function()
              CommonTips.OpenStoreBuy()
            end)
          else
            CommonTips.OpenWitchTip(80611464)
          end
          return
        end
      end
    else
      CommonTips.OpenWitchTip(80611466)
      return
    end
  end
  
  local function cb()
    View.Group_Choose.Group_1.Group_EffectRefresh.self:SetActive(false)
    View.Group_Choose.Group_2.Group_EffectRefresh.self:SetActive(false)
    View.Group_Choose.Group_3.Group_EffectRefresh.self:SetActive(false)
    View.self:SelectPlayAnim(View.Group_Choose.self, "NewState")
    Net:SendProto("activity.refresh_select", function(json)
      witchesData.temp_select = json.temp_select
      if witchesData.free_guka_refresh and witchesData.free_guka_refresh > 0 then
        witchesData.free_guka_refresh = witchesData.free_guka_refresh - 1
      elseif witchesData.pay_guka_refresh and 0 < witchesData.pay_guka_refresh then
        witchesData.pay_guka_refresh = witchesData.pay_guka_refresh - 1
      end
      Controller:ResetRefreshBtnShow()
      View.Group_Choose.Group_1.Group_EffectRefresh.self:SetActive(true)
      View.Group_Choose.Group_2.Group_EffectRefresh.self:SetActive(true)
      View.Group_Choose.Group_3.Group_EffectRefresh.self:SetActive(true)
      View.self:SelectPlayAnim(View.Group_Choose.self, "GuKaChoose_in2", function()
        local rewardSelect = WitchData.GetRewardSelectList()
        DataModel.GuKaList = rewardSelect[DataModel.rewardType]
        Controller:Init()
      end)
    end, WitchData.GetActivityId())
  end
  
  if table.count(useItem) > 0 then
    local id, num = next(useItem)
    local ca = PlayerData:GetFactoryData(id)
    CommonTips.OpenWitchPrompt(string.format(GetText(80611467), num, ca.name), nil, nil, cb)
  else
    cb()
  end
end

return Controller
