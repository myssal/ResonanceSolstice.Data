local View = require("UISelectItemAcculate/UISelectItemAcculateView")
local DataModel = require("UISelectItemAcculate/UISelectItemAcculateDataModel")
local CommonItem = require("Common/BtnItem")
local ViewFunction = {
  SelectItemAcculate_Btn_BG_Click = function(btn, str)
    View.self:CloseUI()
  end,
  SelectItemAcculate_ScrollGrid_List_SetGrid = function(element, elementIndex)
    local itemUseInfo = DataModel.itemUseList[elementIndex]
    local itemId = itemUseInfo.itemId
    local itemCA = PlayerData:GetFactoryData(itemId)
    element.Txt_Name:SetText(itemCA.name)
    CommonItem.SetItem(self, element.Group_Item, {
      id = itemId,
      num = itemUseInfo.haveNum
    })
    element.Group_Item.Btn_Item:SetClickParam(itemId)
    element.Btn_Item:SetClickParam(elementIndex)
    local showMask = not DataModel.IsItemCanUse(elementIndex)
    element.Img_Mask:SetActive(showMask)
    DataModel.itemUseElementList[elementIndex] = element
  end,
  SelectItemAcculate_ScrollGrid_List_Group_Item_Btn_Item_Click = function(btn, str)
    DataModel.ClickItem(tonumber(str))
  end,
  SelectItemAcculate_ScrollGrid_List_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenRewardDetail(itemId)
  end,
  SelectItemAcculate_Group_Item_Btn_Item_Click = function(btn, str)
  end,
  SelectItemAcculate_Group_SelectQuantity_Btn_Min_Click = function(btn, str)
    if DataModel.maxUseNum > 1 then
      View.Group_SelectQuantity.Group_Slider.Slider_Value:SetSliderValue(1)
    end
  end,
  SelectItemAcculate_Group_SelectQuantity_Btn_Dec_Click = function(btn, str)
    if DataModel.selectNum > 1 then
      View.Group_SelectQuantity.Group_Slider.Slider_Value:SetSliderValue(DataModel.selectNum - 1)
    end
  end,
  SelectItemAcculate_Group_SelectQuantity_Group_Slider_Slider_Value_Slider = function(slider, value)
    if DataModel.maxUseNum > 1 then
      local num = math.floor(tonumber(value))
      DataModel.selectNum = num
      View.Group_SelectQuantity.Group_Slider.Group_Num.Txt_Select:SetText(num)
      local itemUseInfo = DataModel.itemUseList[DataModel.selectIndex]
      local timeStr = DataModel.GetTimeStr(itemUseInfo.time * num)
      View.Group_Time.Txt_TimeNum:SetText(timeStr)
    end
  end,
  SelectItemAcculate_Group_SelectQuantity_Group_Slider_Slider_Value_SliderDown = function(slider)
  end,
  SelectItemAcculate_Group_SelectQuantity_Group_Slider_Slider_Value_SliderUp = function(slider)
  end,
  SelectItemAcculate_Group_SelectQuantity_Btn_Add_Click = function(btn, str)
    if DataModel.selectNum < DataModel.maxUseNum then
      View.Group_SelectQuantity.Group_Slider.Slider_Value:SetSliderValue(DataModel.selectNum + 1)
    end
  end,
  SelectItemAcculate_Group_SelectQuantity_Btn_Max_Click = function(btn, str)
    if DataModel.maxUseNum > 1 then
      View.Group_SelectQuantity.Group_Slider.Slider_Value:SetSliderValue(DataModel.maxUseNum)
    end
  end,
  SelectItemAcculate_Btn_Acculate_Click = function(btn, str)
    if DataModel.selectNum == 0 then
      return
    end
    local itemUseInfo = DataModel.itemUseList[DataModel.selectIndex]
    local itemId = itemUseInfo.itemId
    local time = itemUseInfo.time
    if DataModel.addSpeedType == 1 then
      local function callBack()
        View.self:CloseUI()
        
        if UIManager:IsPanelOpened("UI/Prison/Overview/Prison") then
          local UIPrisonData = require("UIPrison/UIPrisonDataModel")
          UIPrisonData.UpgradeBuildFaster(DataModel.roomTypeId)
        end
      end
      
      PrisonData.UpgradeRoomFaster(callBack, DataModel.roomTypeId, {
        id = tostring(itemId),
        num = DataModel.selectNum
      })
    elseif DataModel.addSpeedType == 2 then
      local function callBack()
        View.self:CloseUI()
        
        local min = ClearFollowZero(time * DataModel.selectNum / 60)
        CommonTips.OpenTips(string.format(GetText(80608348), min))
      end
      
      PrisonData.ProductFaster(callBack, PrisonData.roomIndex, {
        id = tostring(itemId),
        num = DataModel.selectNum
      })
    elseif DataModel.addSpeedType == 3 then
      local UIMaterialController = require("UIMaterialProductionEdit/UIMaterialProductionEditController")
      
      local function callBack()
        PlayerData.ServerData.items[tostring(itemId)].num = PlayerData.ServerData.items[tostring(itemId)].num - DataModel.selectNum
        View.self:CloseUI()
        if UIManager:IsPanelOpened("UI/Prison/MaterialProduction/MaterialProductionEdit") then
          UIMaterialController:RefreshOnProductSateChange()
        end
      end
      
      UIMaterialController:DoSpeedProduct(callBack, Json.encode({
        {
          id = tostring(itemId),
          num = DataModel.selectNum
        }
      }))
    elseif DataModel.addSpeedType == 4 then
      local function callBack()
        View.self:CloseUI()
        
        local min = ClearFollowZero(time * DataModel.selectNum / 60)
        CommonTips.OpenTips(string.format(GetText(80608348), min))
      end
      
      PrisonData.ProductCellFaster(callBack, PrisonData.roomIndex, DataModel.cellIndex, {
        id = tostring(itemId),
        num = DataModel.selectNum
      })
    end
  end,
  SelectItemAcculate_Btn_Complete_Click = function(btn, str)
    local costInfo
    local prisonCA = PrisonData.GetPrisonCA()
    for i, v in ipairs(prisonCA.diamondFaster) do
      if v.timeFaster >= DataModel.remainTime then
        costInfo = v
        break
      end
    end
    if costInfo then
      local function yesFun()
        if DataModel.addSpeedType == 1 then
          local function callBack()
            View.self:CloseUI()
            
            if UIManager:IsPanelOpened("UI/Prison/Overview/Prison") then
              local UIPrisonData = require("UIPrison/UIPrisonDataModel")
              UIPrisonData.UpgradeBuildImmediately(DataModel.roomTypeId)
            end
          end
          
          PrisonData.UpgradeRoomImmediately(callBack, DataModel.roomTypeId, DataModel.roomId, costInfo)
        elseif DataModel.addSpeedType == 2 then
          local function callBack()
            View.self:CloseUI()
            
            CommonTips.OpenTips(80607087)
          end
          
          PrisonData.CompleteProductImmediately(callBack, PrisonData.roomIndex, costInfo)
        end
      end
      
      local textId
      if DataModel.addSpeedType == 1 then
        textId = 80607671
      elseif DataModel.addSpeedType == 2 then
        textId = 80608349
      end
      if textId then
        local itemCA = PlayerData:GetFactoryData(costInfo.diamond)
        CommonTips.OnPrompt(string.format(GetText(textId), costInfo.diamondNum, itemCA.name), nil, nil, yesFun)
      end
    end
  end,
  SelectItemAcculate_Btn_Cancel_Click = function(btn, str)
    View.self:CloseUI()
    DataModel.selectIndex = nil
  end
}
return ViewFunction
