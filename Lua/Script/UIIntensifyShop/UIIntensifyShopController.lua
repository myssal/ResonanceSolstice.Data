local View = require("UIIntensifyShop/UIIntensifyShopView")
local DataModel = require("UIIntensifyShop/UIIntensifyShopDataModel")
local RogueController = require("UICubeRogueMain/UICubeRoguewMainController")
local RogueData = require("UICubeRogueMain/UICubeRogueMainDataModel")
local OutSideData = require("UICubeSkill/UICubeSkillDataModel")
local AttrManager = require("UICubeRogueMain/CubeRogueEquipAttrManager")
local ItemAttrManager = require("UICubeRogueMain/CubeRogueItemAttrManager")
local Controller = {
  Enum_BuffQuality = {
    Blue = 1,
    Purple = 2,
    Golden = 3,
    Orange = 4
  }
}

function Controller.ShowPanel()
  DataModel.DataList = {}
  local netData = PlayerData.TempCache.CubeRogueData.inside_buffs
  for k, v in pairs(netData) do
    local buffCA = GetCA(k, "RogueBuffFactory")
    if buffCA.intensifyList ~= nil and #buffCA.intensifyList > 0 then
      local temp = {id = k}
      temp.name = buffCA.name
      temp.icon = buffCA.iconPath
      temp.quality = buffCA.quality
      temp.upCostId = buffCA.intensifyList[1].id
      local rate = AttrManager:GetAttr(Enum_AttrType.IntensifyPrice) + RogueData.GetDescentAttr("IntensifyPrice").value
      temp.upCostNum = MathEx.Round(buffCA.intensifyList[1].num * (1 + rate))
      temp.isRec = PlayerData.TempCache.CubeRogueData.team == tostring(buffCA.correspondingTeam) and 1 or 0
      temp.intensify = v.intensify
      table.insert(DataModel.DataList, temp)
    end
  end
  table.sort(DataModel.DataList, function(a, b)
    if a.intensify and not b.intensify then
      return false
    elseif b.intensify and not a.intensify then
      return true
    elseif a.isRec == b.isRec then
      return Controller.Enum_BuffQuality[a.quality] > Controller.Enum_BuffQuality[b.quality]
    else
      return a.isRec > b.isRec
    end
  end)
  Controller.Select(1)
  View.Group_Buff.ScrollGrid_Buff.grid.self:SetDataCount(#DataModel.DataList)
  View.Group_Buff.ScrollGrid_Buff.grid.self:RefreshAllElement()
  Controller.ShowCoin()
  View.Img_Title:SetSprite(GetResPath(88300217))
end

function Controller.ShowCoin()
  local coinCfg = GetCA(11400607, "ItemFactory")
  View.Group_Coin.Img_Icon:SetSprite(coinCfg.iconPath)
  View.Group_Coin.Txt_Num:SetText(PlayerData:GetGoodsById(11400607).num)
end

function Controller.Select(index)
  if DataModel.CurSelect == index then
    return
  end
  DataModel.CurSelect = index
  local data = DataModel.DataList[index]
  if data == nil then
    return
  end
  
  local function showBuff(buffView, _data, _type)
    local cfg = GetCA(data.id, "RogueBuffFactory")
    buffView.Img_Bg:SetSprite("UI/CubeRogue/QualityBG/Buff/Big/" .. cfg.quality)
    buffView.Txt_Name:SetText(cfg.name)
    buffView.Img_Icon:SetSprite(cfg.iconPath)
    local liupaiCfg = GetCA(cfg.correspondingTeam, "RogueTeamFactory")
    buffView.ScrollView_DefaultDes.Viewport.Content.Txt_Tyep:SetText(liupaiCfg.name)
    buffView.Img_Type:SetSprite(liupaiCfg.tabIconPath)
    buffView.Img_TypeIcon:SetSprite(liupaiCfg.shadePath)
    if _type == 0 then
      buffView.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetText(cfg.des)
    else
      buffView.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetText(cfg.intensifyDes)
    end
    buffView.Img_Level:SetActive(_type == 0)
    buffView.Img_Level2:SetActive(_type == 1)
  end
  
  if data.intensify then
    View.Group_Info.Group_Lv2:SetActive(true)
    View.Group_Info.Group_Lv1:SetActive(false)
    showBuff(View.Group_Info.Group_Lv2.Group_BuffAfter, data, 1)
  else
    View.Group_Info.Group_Lv2:SetActive(false)
    View.Group_Info.Group_Lv1:SetActive(true)
    showBuff(View.Group_Info.Group_Lv1.Group_BuffBefore, data, 0)
    showBuff(View.Group_Info.Group_Lv1.Group_BuffAfter, data, 1)
    local coinCfg = GetCA(11400607, "ItemFactory")
    View.Group_Info.Group_Lv1.Btn_Intensify.Img_Coin:SetSprite(coinCfg.iconPath)
    View.Group_Info.Group_Lv1.Btn_Intensify.Txt_Prise:SetText(string.format("%d", data.upCostNum))
    local moneyEnough = PlayerData:GetGoodsById(data.upCostId).num >= data.upCostNum
    View.Group_Info.Group_Lv1.Btn_Intensify.Txt_Prise:SetColor(moneyEnough and "#FFFFFF" or "#FF2121")
  end
end

function Controller.ConfirmClick()
  local data = DataModel.DataList[DataModel.CurSelect]
  if data == nil then
    return
  end
  if data.intensify then
    CommonTips.OpenTips(80610127)
    return
  end
  if PlayerData:GetGoodsById(data.upCostId).num < data.upCostNum then
    CommonTips.OpenTips(80610292)
    return
  end
  Net:SendProto("cube.intensify", function(json)
    local temp = {
      ptype = "intensify",
      data = {
        [1] = {
          id = data.id,
          intensify = true
        }
      }
    }
    UIManager:Open("UI/CubeRogue/ItemGet/ItemGet", Json.encode(temp))
    RogueController:SetBuffIntensify(data.id, 1)
    PlayerData:RefreshUseItems({
      [11400607] = data.upCostNum
    })
    Controller.ShowCoin()
    RogueController.ShowCoin()
    local sel = DataModel.CurSelect
    DataModel.CurSelect = nil
    data.intensify = 1
    Controller.Select(sel)
    View.Group_Buff.ScrollGrid_Buff.grid.self:RefreshAllElement()
    AttrManager:TriggerByTimingType(Enum_TriggerTiming.LoseCoin, {
      loseNum = data.upCostNum
    })
    AttrManager:RefreshEffectNumByAttrType(Enum_AttrType.IntensifyPrice)
  end, data.id)
end

function Controller.Clear()
  DataModel.CurSelect = nil
  DataModel.DataList = nil
end

return Controller
