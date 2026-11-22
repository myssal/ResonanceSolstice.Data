local View = require("UIItemSelection/UIItemSelectionView")
local DataModel = require("UIItemSelection/UIItemSelectionDataModel")
local Controller = require("UIItemSelection/UIItemSelectionController")
local BuffBook = require("UIBuff_Illustration/UIBuff_IllustrationDataModel")
local EquipBook = require("UIEquipment_Illustration/UIEquipment_IllustrationDataModel")
local ViewFunction = {
  ItemSelection_ScrollGrid_Buff_SetGrid = function(element, elementIndex)
    local data = DataModel.dataList[elementIndex]
    if data == nil then
      return
    end
    local isSelect = table.contains(DataModel.curSelect, tonumber(data.id))
    element.Img_Selected:SetActive(isSelect)
    element.Img_Sure:SetActive(isSelect)
    if DataModel.onlyRefreshSel then
      return
    end
    local cfg = GetCA(tonumber(data.id), "RogueBuffFactory")
    element.Img_UnSelectSure:SetActive(true)
    element.Txt_Name:SetText(cfg.name)
    element.Img_Icon:SetSprite(cfg.iconPath)
    element.Img_Bg:SetSprite("UI/CubeRogue/QualityBG/Buff/Big/" .. cfg.quality)
    local liupaiCfg = GetCA(cfg.correspondingTeam, "RogueTeamFactory")
    element.Img_TypeIcon:SetSprite(liupaiCfg.shadePath)
    element.Img_Type:SetSprite(liupaiCfg.tabIconPath)
    element.Btn_:SetClickParam(data.id)
    element.ScrollView_DefaultDes.Viewport.Content.Txt_Tyep:SetText(liupaiCfg.name)
    element.ScrollView_DefaultDes.Viewport.Content.Txt_Already:SetActive(data.intensify)
    element.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetActive(not data.intensify)
    element.ScrollView_DefaultDes.Viewport.Content.Txt_UpdateDes:SetActive(data.intensify)
    if data.intensify then
      element.ScrollView_DefaultDes.Viewport.Content.Txt_UpdateDes:SetText(cfg.intensifyDes)
    else
      element.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetText(cfg.des)
    end
    element.ScrollView_DefaultDes.Viewport.Content.Img_0:SetActive(false)
    element.Img_Recommend:SetActive(PlayerData.TempCache.CubeRogueData.team == tostring(cfg.correspondingTeam))
    element.Img_NotGet:SetActive(BuffBook.GetBookItemIsNew(data.id))
  end,
  ItemSelection_ScrollGrid_Weapon_SetGrid = function(element, elementIndex)
    local data = DataModel.dataList[elementIndex]
    if data == nil then
      return
    end
    local isSelect = table.contains(DataModel.curSelect, tonumber(data.id))
    element.Img_Selected:SetActive(isSelect)
    element.Img_Sure:SetActive(isSelect)
    if DataModel.onlyRefreshSel then
      return
    end
    local cfg = GetCA(tonumber(data.id), "RogueEquipmentFactory")
    element.Txt_Name:SetText(cfg.name)
    element.Img_Icon:SetSprite(cfg.iconPath)
    if cfg.isNegative then
      element.Img_Bg:SetSprite("UI/CubeRogue/QualityBG/Weapon/Big/Red")
    else
      element.Img_Bg:SetSprite("UI/CubeRogue/QualityBG/Weapon/Big/" .. cfg.quality)
    end
    element.Img_UnSelectSure:SetActive(true)
    element.ScrollView_Des.Viewport.Content.Txt_Des:SetText(cfg.des)
    element.Img_NotGet:SetActive(EquipBook.GetBookItemIsNew(data.id))
    element.Btn_:SetClickParam(data.id)
  end,
  ItemSelection_Group_Coin_Btn_GoldCoin_Click = function(btn, str)
    local allCfg = PlayerData:GetFactoryData(89400002, "CubeRogueFactory")
    CommonTips.OpenCubeRogueItemDetails({
      id = allCfg.coinId
    })
  end,
  ItemSelection_ScrollGrid_Buff_Group_Buff_Btn__Click = function(btn, str)
    Controller.Select(tonumber(str))
  end,
  ItemSelection_ScrollGrid_Weapon_Group_Weapon_Btn__Click = function(btn, str)
    Controller.Select(tonumber(str))
  end,
  ItemSelection_Group_Btn_Btn_Refresh_Click = function(btn, str)
    if DataModel.refreshCost > PlayerData:GetGoodsById(DataModel.refreshCostId).num then
      return
    end
    Net:SendProto("cube.refresh_buff", function(json)
      DataModel.refreshNum = DataModel.refreshNum + 1
      for k, v in pairs(json.package) do
        local tempDataList = v.buff or v.equip
        local realDataList = {}
        for o, p in pairs(tempDataList) do
          realDataList[tostring(p)] = {}
        end
        Controller.ShowList(realDataList)
        break
      end
      PlayerData:RefreshUseItems({
        [DataModel.refreshCostId] = DataModel.refreshCost
      })
      Controller.ShowCoin()
      local RogueController = require("UICubeRogueMain/UICubeRoguewMainController")
      RogueController.ShowCoin()
      Controller.ClearSelect()
    end, DataModel.cfg.id)
  end,
  ItemSelection_Group_Btn_Btn_Confirm_Click = function(btn, str)
    if not DataModel.canConfirm then
      return
    end
    local protoName
    if DataModel.showType == 1 or DataModel.showType == 3 then
      protoName = "cube.select_package"
    elseif DataModel.showType == 2 then
      protoName = "cube.lose_eq"
    elseif DataModel.showType == 4 then
      protoName = "cube.lose_bf"
    end
    if protoName then
      local temp = ""
      local count = #DataModel.curSelect
      for i = 1, count do
        temp = temp .. DataModel.curSelect[i]
        if i ~= count then
          temp = temp .. ","
        end
      end
      Net:SendProto(protoName, Controller.OnSendNet, DataModel.cfg.id, temp)
    end
  end,
  ItemSelection_Group_Backpack_Btn__Click = function(btn, str)
    UIManager:Open("UI/CubeRogue/CubeWarehouse/CubeWarehouse")
  end
}
return ViewFunction
