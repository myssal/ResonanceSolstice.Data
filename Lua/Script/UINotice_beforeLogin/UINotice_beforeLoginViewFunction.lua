local View = require("UINotice_beforeLogin/UINotice_beforeLoginView")
local Controller = require("UINotice_beforeLogin/UINotice_beforeLoginController")
local DataModel = require("UINotice_beforeLogin/UINotice_beforeLoginDataModel")
local ViewFunction = {
  Notice_beforeLogin_Btn_Close_Click = function(btn, str)
    View.self:CloseUI()
  end,
  Notice_beforeLogin_Group_Newinfo_Group_btn_Group_pic_Btn_pic_Click = function(btn, str)
    Controller:ClickTopTab(1)
  end,
  Notice_beforeLogin_Group_Newinfo_Group_btn_Group_notice_Btn_notice_Click = function(btn, str)
    Controller:ClickTopTab(2)
  end,
  Notice_beforeLogin_Group_Newinfo_Group_Pic_Group_small_ScrollGrid__SetGrid = function(element, elementIndex)
    local row = DataModel.LeftList[tonumber(elementIndex)]
    NoticeManager:SetAsyncTexture(row.smallImg, function(texture2D)
      if UIManager:GetPanel("UI/Notice/Notice_beforeLogin") and UIManager:GetPanel("UI/Notice/Notice_beforeLogin").IsActive then
        element.Img_Small:SetTexture2D(texture2D)
      end
    end, false)
    element.Btn_:SetClickParam(elementIndex)
    element.Img_Small.Txt_time:SetText(row.time)
    element.Img_Small.Txt_title:SetText(row.title)
    element.Img_Small.Txt_time:SetActive(row.time ~= "")
    element.Img_Small.Txt_title:SetActive(row.title ~= "")
  end,
  Notice_beforeLogin_Group_Newinfo_Group_Pic_Group_small_ScrollGrid__Group_Item_Btn__Click = function(btn, str)
    local row = DataModel.LeftList[tonumber(str)]
    local url = row.jumpUrl
    local webUrl = row.jumpWebUrlId
    local jumpUrlId = row.jumpUrlId
    Controller:ImgPageJump(url, webUrl, jumpUrlId)
  end,
  Notice_beforeLogin_Group_Newinfo_Group_Pic_Group_big_Btn__Click = function(btn, str)
    local grid = View.Group_Newinfo.Group_main.ScrollGrid_.grid.self
    local old_element
    if DataModel.RightIndex and grid:GetChildByIndex(DataModel.RightIndex - 1) then
      old_element = grid:GetChildByIndex(DataModel.RightIndex - 1):GetComponent(typeof(CS.Seven.UIGridItemIndex)).element
      old_element.Btn_Tab.Img_On:SetActive(false)
    end
    DataModel.RightIndex = DataModel.PicRightIndex
    DataModel.IsRefresh = true
    Controller:ImgPageJump(DataModel.LeftImgJumpUrl, DataModel.LeftImgJumpWebUrlId, DataModel.LeftImgJumpUrlId)
  end,
  Notice_beforeLogin_Group_Newinfo_Group_main_Group_details_Btn_Goto_Click = function(btn, str)
  end,
  Notice_beforeLogin_Group_Newinfo_Group_main_ScrollGrid__SetGrid = function(element, elementIndex)
    local row = DataModel.RightList[tonumber(elementIndex)]
    local Btn_Tab = element.Btn_Tab
    Btn_Tab.Txt_Title:SetText(row.title)
    Btn_Tab.Img_Time.Txt_Time:SetText(row.time)
    Btn_Tab.Img_On:SetActive(tonumber(elementIndex) == DataModel.RightIndex)
    if tonumber(elementIndex) == DataModel.RightIndex then
      Btn_Tab.Txt_Title:SetColor(UIConfig.ColorCH.Black)
    else
      Btn_Tab.Txt_Title:SetColor(UIConfig.ColorCH.White)
    end
    Btn_Tab:SetClickParam(elementIndex)
  end,
  Notice_beforeLogin_Group_Newinfo_Group_main_ScrollGrid__Group_Item_Btn_Tab_Click = function(btn, str)
    Controller:ClickRightTab(tonumber(str))
  end
}
return ViewFunction
