local View = require("UIRogueItemReplace/UIRogueItemReplaceView")
local DataModel = require("UIRogueItemReplace/UIRogueItemReplaceDataModel")
local RogueController = require("UICubeRogueMain/UICubeRoguewMainController")
local RogueModel = require("UICubeRogueMain/UICubeRogueMainDataModel")
local Controller = {}

function Controller.ShowItem(itemView, data, index)
  itemView.Img_Selected:SetActive(index == DataModel.curSelect)
  itemView.Img_Sure:SetActive(index == DataModel.curSelect)
  if DataModel.onlySelect then
    return
  end
  if index > RogueModel.GetMaxItemNum() then
    itemView:SetActive(false)
    return
  else
    itemView:SetActive(true)
  end
  local cfg = GetCA(tonumber(data), "ItemFactory")
  itemView.Txt_Name:SetText(cfg.name)
  itemView.Img_Icon:SetSprite(cfg.iconPath)
  itemView.Img_Bg:SetSprite("UI/CubeRogue/QualityBG/Buff/Big/" .. cfg.quality)
  itemView.Img_TypeIcon:SetActive(false)
  itemView.Img_Type:SetActive(true)
  itemView.Img_Type:SetSprite("UI/CubeRogue/ItemUse/ItemUseUI/ItemType")
  itemView.ScrollView_DefaultDes.Viewport.Content.Txt_Tyep:SetText(GetText(80610767))
  itemView.ScrollView_DefaultDes.Viewport.Content.Txt_Already:SetActive(false)
  itemView.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetActive(true)
  itemView.ScrollView_DefaultDes.Viewport.Content.Txt_DefaultDes:SetText(cfg.des)
  itemView.ScrollView_DefaultDes.Viewport.Content.Txt_UpdateDes:SetActive(false)
  itemView.Img_Recommend:SetActive(false)
  itemView.Img_NotGet:SetActive(false)
  itemView.Btn_:SetClickParam(index)
  if index == -1 then
    itemView.Btn_:SetActive(false)
  end
end

function Controller.ShowPanel()
  local netData = PlayerData.TempCache.CubeRogueData.inside_item or {}
  Controller.ShowItem(View.Group_Change.Group_New.Group_Buff, netData[RogueModel.surplusItems], -1)
  View.Group_Change.Group_Old.ScrollGrid_ItemOld.grid.self:SetDataCount(RogueModel.GetMaxItemNum())
  View.Group_Change.Group_Old.ScrollGrid_ItemOld.grid.self:RefreshAllElement()
end

function Controller.Select(index)
  if index == DataModel.curSelect then
    return
  end
  DataModel.curSelect = index
  DataModel.onlySelect = true
  View.Group_Change.Group_Old.ScrollGrid_ItemOld.grid.self:RefreshAllElement()
  DataModel.onlySelect = nil
end

function Controller.Cancel()
  Controller.OnSendNet(-1)
end

function Controller.Confirm()
  Controller.OnSendNet(DataModel.curSelect)
end

function Controller.OnSendNet(index)
  Net:SendProto("cube.replace_item", function(json)
    local netItems = PlayerData.TempCache.CubeRogueData.inside_item
    if 0 < index then
      netItems[index] = netItems[RogueModel.surplusItems]
    end
    table.remove(netItems, RogueModel.surplusItems)
    if #netItems <= RogueModel.GetMaxItemNum() then
      RogueModel.surplusItems = nil
    end
    UIManager:GoBack(false)
    RogueController.RefreshUseItems()
    RogueController.OnPanelBack()
  end, index)
end

return Controller
