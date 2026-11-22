local View = require("UIItemUse/UIItemUseView")
local DataModel = {}
DataModel.itemId = nil
DataModel.index = nil
local BgQualityMap = {
  Blue = "UI/CubeRogue/QualityBG/Buff/Big/Blue",
  Purple = "UI/CubeRogue/QualityBG/Buff/Big/Purple",
  Golden = "UI/CubeRogue/QualityBG/Buff/Big/Golden",
  Orange = "UI/CubeRogue/QualityBG/Buff/Big/Orange"
}

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.itemId = data.itemId
  DataModel.index = data.index
end

function DataModel.InitData()
end

function DataModel.RefreshOnShow()
  local itemId = DataModel.itemId
  local itemCA = PlayerData:GetFactoryData(itemId, "ItemFactory")
  View.Group_Use.Img_Bg:SetSprite(BgQualityMap[itemCA.quality])
  View.Group_Use.Txt_Name:SetText(itemCA.name)
  View.Group_Use.Img_Icon:SetSprite(itemCA.iconPath)
  View.Group_Use.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetText(itemCA.des)
  View.Group_Use.Btn_:SetClickParam(itemId)
end

function DataModel.UseItem(itemId, index)
  if PlayerData.TempCache.CubeRogueData.rest_id and PlayerData.TempCache.CubeRogueData.rest_id ~= "" then
    CommonTips.OpenTips(80610865)
    return
  end
  itemId = tostring(itemId)
  local RogueMainDataModel = require("UICubeRogueMain/UICubeRogueMainDataModel")
  local RogueController = require("UICubeRogueMain/UICubeRoguewMainController")
  if itemId == "11400683" and RogueMainDataModel.GetMaxStepNum() - RogueMainDataModel.curMoveNum == 0 then
    CommonTips.OpenTips(80610857)
    return
  elseif (itemId == "11400708" or itemId == "11400688") and (not ((not RogueMainDataModel.curSelectCube or not RogueMainDataModel.curSelectCube.realId) and RogueMainDataModel.hasConfirmRot) or RogueController.playerMoving or RogueController.playerRotating) then
    CommonTips.OpenTips(80610939)
    return
  end
  local itemCA = PlayerData:GetFactoryData(itemId, "ItemFactory")
  local orderId = itemCA.cubeItemEffect
  local orderCA = PlayerData:GetFactoryData(orderId, "RogueOrderFactory")
  local orderType = orderCA.orderType
  local ItemAttrManager = require("UICubeRogueMain/CubeRogueItemAttrManager")
  if Enum_RogueItemFunType[orderType] then
    if orderType == Enum_RogueItemFunType.Recover then
      local hpHealthy = true
      for roleId, v in pairs(RogueMainDataModel.battleRoles) do
        if v.hp ~= 1 then
          hpHealthy = false
          break
        end
      end
      if hpHealthy then
        CommonTips.OpenTips(80610797)
        return
      end
    elseif (orderType == Enum_RogueItemFunType.TpBoss or orderType == Enum_RogueItemFunType.TpSpecial) and RogueMainDataModel.playerCube and RogueMainDataModel.playerCube.realId then
      CommonTips.OpenTips(80610959)
      return
    end
  elseif not orderCA.isReuse and ItemAttrManager.CheckHasSameEffect(orderId) then
    CommonTips.OpenTips(80610776)
    return
  end
  Net:SendProto("cube.use_items", function(json)
    View.self:CloseUI()
    ItemAttrManager.RemoveItem(index)
    ItemAttrManager.AddBuff(orderId)
    if orderType == Enum_RogueItemFunType.Recover then
      RogueController.SetRoleHp(orderCA.recoverType, orderCA.param, true)
      RogueController.TryShowReward()
    elseif orderType == Enum_RogueItemFunType.TpSpecial then
      RogueController.RoleFlashPos(json)
    elseif orderType == Enum_RogueItemFunType.TpBoss then
      local bossCtrl = RogueMainDataModel.bossCtrl
      json.cur_lct = bossCtrl.x .. ":" .. bossCtrl.y .. ":" .. bossCtrl.face
      RogueController.RoleFlashPos(json)
    elseif orderType == Enum_RogueItemOrderType.StepDistanceItem then
      RogueController.StepNumAnim(orderCA.param, GetText(80610794))
      if RogueController.playerMoving then
        RogueMainDataModel.ShowCanMoveOutline(true)
      end
    elseif orderType == Enum_RogueItemOrderType.SpinNumItem then
      RogueController.StepNumAnim(orderCA.param, GetText(80610792))
      RogueController.RefreshPlayerStep()
    elseif orderType == Enum_RogueItemOrderType.ActionItem then
      RogueController.StepNumAnim(orderCA.param, GetText(80610791))
      RogueController.RefreshStepNum()
    elseif orderType == Enum_RogueItemOrderType.StepNumItem then
      RogueController.StepNumAnim(orderCA.param, GetText(80610793))
      RogueController.RefreshPlayerStep()
    end
    RogueController.RefreshUseItems()
  end, itemId, index - 1)
end

return DataModel
