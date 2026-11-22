local View = require("UIGroup_RapidLeft/UIGroup_RapidLeftView")
local DataModel = require("UIGroup_RapidLeft/UIGroup_RapidLeftDataModel")

local function GetItemIcon(itemId)
  local factoryName = DataManager:GetFactoryNameById(itemId)
  local caData = PlayerData:GetFactoryData(itemId, factoryName)
  local iconPath = ""
  if factoryName == "UnitFactory" then
    local unit = PlayerData:GetFactoryData(caData.viewId)
    iconPath = unit.face
  elseif factoryName == "HomeCoachFactory" then
    iconPath = caData.thumbnailone
  elseif factoryName == "UnitViewFactory" then
    iconPath = caData.iconPath
  else
    iconPath = caData.iconPath or caData.imagePath
  end
  return iconPath
end

local ViewFunction = {
  Group_RapidLeft_Btn_Rm_Click = function(btn, str)
    View.self:CloseUI()
  end,
  Group_RapidLeft_Img_RmBG_Btn_Set_Click = function(btn, str)
    UIManager:CloseTip("UI/Home_MachiningLathe/RapidMaking/Group_RapidLeft")
    UIManager:Open("UI/Home_MachiningLathe/RapidMaking/RapidMaking")
  end,
  Group_RapidLeft_Img_RmBG_ScrollGrid__SetGrid = function(element, elementIndex)
    local data = DataModel.formulaList[elementIndex]
    element.Btn_ChangBtn.Img_Choose:SetActive(false)
    element.Btn_ChangBtn.Group_Item.Img_Item:SetActive(data)
    element.Btn_ChangBtn.Group_Item.Img_Icon:SetActive(data)
    if data then
      local name = PlayerData:GetFactoryData(data.productId).name
      element.Btn_ChangBtn.Group_Item.Img_Item:SetSprite(GetItemIcon(data.productId))
      element.Btn_ChangBtn.Group_Item.Txt_Name:SetText(name)
      element.Btn_ChangBtn.Img_Choose:SetActive(DataModel.nowProductIdx == elementIndex)
    else
      element.Btn_ChangBtn.Group_Item.Txt_Name:SetText(GetText(80609839))
    end
    element.Btn_ChangBtn:SetClickParam(elementIndex)
  end,
  Group_RapidLeft_Img_RmBG_ScrollGrid__Group_Item_Btn_ChangBtn_Click = function(btn, str)
    local data = DataModel.formulaList[tonumber(str)]
    if data then
      local furId = PlayerData:GetFurniture()[data.furUid].id
      local t = {
        ufid = data.furUid,
        furId = furId,
        productionId = data.formulaId
      }
      UIManager:GoBack(false)
      UIManager:Open(data.uiPath, Json.encode(t))
    else
      UIManager:CloseTip("UI/Home_MachiningLathe/RapidMaking/Group_RapidLeft")
      UIManager:Open("UI/Home_MachiningLathe/RapidMaking/RapidMaking")
    end
  end
}
return ViewFunction
