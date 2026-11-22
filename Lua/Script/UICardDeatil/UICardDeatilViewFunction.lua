local View = require("UICardDeatil/UICardDeatilView")
local DataModel = require("UICardDeatil/UICardDeatilDataModel")
local Controller = require("UICardDeatil/UICardDeatilController")
local ViewFunction = {
  CardDeatil_Btn_BG_Click = function(btn, str)
    View.self:PlayAnimOnce("CardDeatil_Out", function()
      View.self:Confirm()
      UIManager:ClosePanel()
    end)
  end,
  CardDeatil_Group_Main_Group_Option_Group_Option_Btn_On_Click = function(btn, str)
  end,
  CardDeatil_Group_Main_Group_Option_Group_NumSelect_Btn_BG_Click = function(btn, str)
    Controller:CloseNumSelect()
  end,
  CardDeatil_Group_Main_Group_Option_Group_NumSelect_Btn_Comfirm_Click = function(btn, str)
    Controller:RefreshUseParam()
    Controller:CloseNumSelect()
  end,
  CardDeatil_Group_Main_Group_Skill_ScrollView_Group_CardsSetting_Viewport_Content_Group_SkillDes_StaticGrid_CardTags_SetGrid = function(element, elementIndex)
    Controller:OnSetTagGrid(element, elementIndex)
  end,
  CardDeatil_Group_Main_Group_Option_Group_Option_Btn_On_Group_Txt_Img_NumBox_Btn__Click = function(btn, str)
  end,
  CardDeatil_Group_Main_Group_Option_Group_Option_Img_Off_Group_Txt_Img_NumBox_Btn__Click = function(btn, str)
  end,
  CardDeatil_Group_Main_Group_Option_Group_NumSelect_Img_SelectBarBg_Page_Numbers_SetPage = function(element, elementIndex)
    local index = DataModel.curSetIndex
    local cardId = DataModel.curData.id
    local cardCA = PlayerData:GetFactoryData(cardId)
    local data
    if index <= #cardCA.ExCondList + 2 then
      data = cardCA.ExCondList[index - 2]
    else
      data = cardCA.ExActList[index - #cardCA.ExCondList - 2]
    end
    local num = data.minNum + (elementIndex - 1) * data.numDuration
    if data.typeEnum == "percent" then
      num = num .. "%"
    end
    element.Txt_Num:SetText(num)
    if elementIndex - 1 == DataModel.curNumIndex then
      element.Txt_Num:SetColor("#FFFFFF")
    else
      element.Txt_Num:SetColor("#7E7E7E")
    end
  end,
  CardDeatil_Group_Main_Group_Option_Group_NumSelect_Img_SelectBarBg_Page_Numbers_PageDrag = function(dragOffsetPos)
  end,
  CardDeatil_Group_Main_Group_Option_Group_NumSelect_Img_SelectBarBg_Page_Numbers_PageDragComplete = function(index)
  end,
  CardDeatil_Group_Main_Group_Option_Group_NumSelect_Img_SelectBarBg_Page_Numbers_PageDragBegin = function(dragOffsetPos)
  end,
  CardDeatil_Group_Main_Group_Option_Group_NumSelect_Img_SelectBarBg_Page_NumbersHide_SetPage = function(element, elementIndex)
  end,
  CardDeatil_Group_Main_Group_Option_Group_NumSelect_Img_SelectBarBg_Page_NumbersHide_PageDrag = function(dragOffsetPos)
    local group = View.Group_Main.Group_Option.Group_NumSelect
    local grid = group.Img_SelectBarBg.Page_Numbers.grid.self
    local pos = group.Img_SelectBarBg.Page_NumbersHide.grid.self.ScrollRect.content.anchoredPosition
    grid.ScrollRect.content.anchoredPosition = Vector2(pos.x + 167, 0)
    grid:HandleScrollEvent(Vector2(grid.ScrollRect.horizontalNormalizedPosition, 0))
    grid:UpdateScale()
  end,
  CardDeatil_Group_Main_Group_Option_Group_NumSelect_Img_SelectBarBg_Page_NumbersHide_PageDragComplete = function(index)
    local group = View.Group_Main.Group_Option.Group_NumSelect
    local grid = group.Img_SelectBarBg.Page_Numbers.grid.self
    grid.ScrollRect.content.anchoredPosition = Vector2(-100 * index + 167, 0)
    grid:HandleScrollEvent(Vector2(grid.ScrollRect.horizontalNormalizedPosition, 0))
    grid:UpdateScale()
    DataModel.curNumIndex = index
    group.Img_SelectBarBg.Page_Numbers.grid.self:RefreshAllElement()
  end,
  CardDeatil_Group_Main_Group_Option_Group_NumSelect_Img_SelectBarBg_Page_NumbersHide_PageDragBegin = function(dragOffsetPos)
  end,
  CardDeatil_Group_Main_Group_Option_ScrollGrid_Options_SetGrid = function(element, elementIndex)
    Controller:OnSetOptionGrid(element, elementIndex)
  end,
  CardDeatil_Group_Main_Group_Option_ScrollGrid_Options_Group_Option_Btn_On_Click = function(btn, str)
    Controller:SetUseType(tonumber(str))
  end,
  CardDeatil_Group_Main_Group_Option_ScrollGrid_Options_Group_Option_Btn_On_Group_Txt_Img_NumBox_Btn__Click = function(btn, str)
    Controller:OpenNumSelect(tonumber(str))
  end,
  CardDeatil_Group_Main_Group_Option_ScrollGrid_Options_Group_Option_Img_Off_Group_Txt_Img_NumBox_Btn__Click = function(btn, str)
    Controller:OpenNumSelect(tonumber(str))
  end
}
return ViewFunction
