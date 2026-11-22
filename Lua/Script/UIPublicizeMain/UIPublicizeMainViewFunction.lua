local View = require("UIPublicizeMain/UIPublicizeMainView")
local DataModel = require("UIPublicizeMain/UIPublicizeMainDataModel")
local ViewFunction = {
  PublicizeMain_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  PublicizeMain_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    CommonCoachData.GoHome()
  end,
  PublicizeMain_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  PublicizeMain_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  PublicizeMain_Group_TopRight_Group_PassengerCapacity_Btn_Add_Click = function(btn, str)
  end,
  PublicizeMain_Group_TopRight_Group_PassengerCapacity_Btn_Icon_Click = function(btn, str)
  end,
  PublicizeMain_Btn_Adv_Click = function(btn, str)
  end,
  PublicizeMain_Group_SendNum_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  PublicizeMain_Group_SendNum_Group_Tad_Group_Leaflet_Btn_On_Click = function(btn, str)
  end,
  PublicizeMain_Group_SendNum_Group_Tad_Group_Leaflet_Btn_Off_Click = function(btn, str)
    DataModel.PublicizeSelectLeafLet()
  end,
  PublicizeMain_Group_SendNum_Group_Tad_Group_Adv_Btn_On_Click = function(btn, str)
  end,
  PublicizeMain_Group_SendNum_Group_Tad_Group_Adv_Btn_Off_Click = function(btn, str)
    DataModel.PublicizeSelectAdv()
  end,
  PublicizeMain_Group_SendNum_Group_chooseNum_Btn_Min_Click = function(btn, str)
    local min = tonumber(str)
    if min > DataModel.curHaveNum then
      CommonTips.OpenTips(80607840)
      return
    elseif DataModel.publicizeNum == min then
      CommonTips.OpenTips(80607850)
      return
    end
    View.Group_SendNum.Group_chooseNum.Group_Slider.Slider_Value:SetSliderValue(math.floor(min / DataModel.basicNum))
  end,
  PublicizeMain_Group_SendNum_Group_chooseNum_Btn_Reduce_Click = function(btn, str)
    local num = DataModel.publicizeNum - tonumber(str)
    if num < DataModel.basicNum then
      CommonTips.OpenTips(80607850)
      return
    end
    View.Group_SendNum.Group_chooseNum.Group_Slider.Slider_Value:SetSliderValue(math.floor(num / DataModel.basicNum))
  end,
  PublicizeMain_Group_SendNum_Group_chooseNum_Group_Slider_Slider_Value_Slider = function(slider, value)
    local selectNum = math.floor(value) * DataModel.basicNum
    DataModel.SelectPublicizeNum(selectNum)
  end,
  PublicizeMain_Group_SendNum_Group_chooseNum_Group_Slider_Slider_Value_SliderDown = function(slider)
  end,
  PublicizeMain_Group_SendNum_Group_chooseNum_Group_Slider_Slider_Value_SliderUp = function(slider)
  end,
  PublicizeMain_Group_SendNum_Group_chooseNum_Btn_Add_Click = function(btn, str)
    local num = DataModel.publicizeNum + tonumber(str)
    if num > DataModel.curHaveNum then
      CommonTips.OpenTips(80607851)
      return
    end
    View.Group_SendNum.Group_chooseNum.Group_Slider.Slider_Value:SetSliderValue(math.floor(num / DataModel.basicNum))
  end,
  PublicizeMain_Group_SendNum_Group_chooseNum_Btn_Max_Click = function(btn, str)
    local max = tonumber(str)
    if DataModel.curHaveNum < DataModel.basicNum then
      CommonTips.OpenTips(80607840)
      return
    elseif DataModel.publicizeNum == max then
      CommonTips.OpenTips(80607851)
      return
    end
    View.Group_SendNum.Group_chooseNum.Group_Slider.Slider_Value:SetSliderValue(math.floor(max / DataModel.basicNum))
  end,
  PublicizeMain_Group_SendNum_Btn_Cancel_Click = function(btn, str)
    View.Group_SendNum:SetActive(false)
  end,
  PublicizeMain_Group_SendNum_Btn_Confirm_Click = function(btn, str)
    if DataModel.publicizeNum == 0 then
      CommonTips.OpenTips(80607840)
      return
    end
    local playgroundId = DataModel.playgroundId
    if PlayerData.GetVisitorsNum(playgroundId) == PlayerData.GetMaxVisitorsNum(playgroundId) then
      CommonTips.OpenTips(80607929)
      return
    end
    local info = DataModel.publicizeList[DataModel.publicizeIndex]
    Net:SendProto("playground.publicity", function(json)
      if DataModel.publicizeType == DataModel.EnumPublicizeType.leaflet then
        local returnNum = json.return_leaflet or 0
        PlayerData.SolicitData.leafletNum = PlayerData.SolicitData.leafletNum - DataModel.publicizeNum + returnNum
      else
        local returnNum = json.return_adv or 0
        PlayerData:GetGoodsById(11400072).num = PlayerData:GetGoodsById(11400072).num - DataModel.publicizeNum + returnNum
      end
      local victorList = {}
      if json.addVisitor then
        for k1, v in pairs(json.addVisitor) do
          for k2, num in pairs(v.vt_info) do
            local splitT = string.split(k2, ":")
            if splitT then
              table.insert(victorList, {
                psgId = splitT[1],
                tagId = splitT[2],
                num = num
              })
            end
          end
        end
        PlayerData.RefreshVisitorData(playgroundId, json.addVisitor)
      end
      UIManager:Open("UI/ParkPublicity/PublicizeSendSuccess", Json.encode({
        playGroundId = playgroundId,
        publicizeType = DataModel.publicizeType,
        publicizePondId = DataModel.publicizePondId,
        victorList = victorList
      }))
    end, 87300002, info.id, DataModel.publicizeType, DataModel.publicizeNum)
  end,
  PublicizeMain_Group_Bg_NewScrollGrid__SetGrid = function(element, elementIndex)
    local info = DataModel.publicizeList[elementIndex]
    if info then
      local pondCA = PlayerData:GetFactoryData(info.id, "PondFactory")
      local resource = pondCA.publicizeResources[1]
      if resource then
        element.Group_Show.Img_Bg:SetSprite(resource.bg)
        element.Group_Show.Img_Bg.Img_Picture:SetSprite(resource.PeoplePng)
        element.Group_Show.Img_Bg.Img_Picture:SetNativeSize()
        element.Group_Show.Btn_Come.Img_come:SetColor(resource.BtnImg)
        element.Group_Show.Group_Introduce.Img_Bg:SetSprite(resource.DecBg)
        element.Group_Show.Group_Introduce.Txt_Dec:SetText(GetText(pondCA.dec))
        element.Group_Show.Group_Introduce.Img_DecBg:SetColor(resource.DecColour)
        element.Group_Show.Group_Introduce.Img_Icon:SetSprite(resource.TitleBg)
        element.Group_Show.Group_Introduce.Txt_Name:SetText(GetText(pondCA.name))
        element.Group_Show.Group_Introduce.Txt_Name:SetColor(resource.TitleColour)
        element.Group_Show.Btn_Come:SetClickParam(elementIndex)
      end
    end
    element.Group_Empty:SetActive(not info)
    element.Group_Show:SetActive(info)
  end,
  PublicizeMain_Group_Bg_NewScrollGrid__Group_Item_Group_Show_Btn_Come_Click = function(btn, str)
    DataModel.Publicize(tonumber(str))
  end
}
return ViewFunction
