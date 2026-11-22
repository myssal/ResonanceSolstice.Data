local View = require("UISkinPreview/UISkinPreviewView")
local DataModel = require("UISkinPreview/UISkinPreviewDataModel")
local Controller = require("UISkinPreview/UISkinPreviewController")
local ViewFunction = {
  SkinPreview_Img_Bg_Group_Right_Img_Frame_ScrollGrid_SkinList_SetGrid = function(element, elementIndex)
    local row = DataModel.SkinList[tonumber(elementIndex)]
    local Btn_SkinBg = element.Btn_SkinBg
    Btn_SkinBg:SetClickParam(elementIndex)
    Btn_SkinBg.Img_LockMask:SetActive(not row.isHave)
    Btn_SkinBg.Img_Selected:SetActive(false)
    element.Img_Selected2:SetActive(row.isSelect)
    element.Img_Selected:SetActive(row.isSelect)
    Btn_SkinBg.Img_SkinFrame:SetSprite(row.ca.roleListResUrl)
    local SkinName = row.ca.SkinName
    local SkinDesc = row.ca.SkinDesc
    if row.isSpine2 == 1 then
      SkinName = row.ca.State2Name
      SkinDesc = row.ca.State2Desc
      Btn_SkinBg.Img_SkinFrame:SetSprite(row.ca.State2RoleListRes)
    end
    row.SkinName = SkinName
    row.SkinDesc = SkinDesc
    Btn_SkinBg.Img_SkinFrame.Img_SkinNameBg.Txt_:SetText(SkinName)
    local unitCA = PlayerData:GetFactoryData(DataModel.RoleId, "UnitFactory")
    local tagCA = PlayerData:GetFactoryData(unitCA.sideId, "TagFactory")
    Btn_SkinBg.Img_SkinFrame.Img_FrameMask.Img_Belonging:SetSprite(tagCA.icon)
    Btn_SkinBg.Img_SkinFrame.Img_InUsingBg:SetActive(row.isWear)
  end,
  SkinPreview_Img_Bg_Group_Right_Img_Frame_ScrollGrid_SkinList_Group_Item_Btn_SkinBg_Click = function(btn, str)
    DataModel:ClickLeftSkin(tonumber(str))
  end,
  SkinPreview_Img_Bg_Group_Right_Group_HoldingStatus_Btn_On_Click = function(btn, str)
    local row = DataModel.SkinList[tonumber(DataModel.ChooseIndex)]
    if row.Btn_Index == 0 then
      local getWay = row.ca.Getway[1]
      if getWay then
        local data = {}
        data.itemID = row.ca.id
        data.posX = 270
        data.posY = -180
        UIManager:Open("UI/Common/Group_GetWay", Json.encode(data))
      end
      return
    end
    Net:SendProto("hero.change_skin", function(json)
      local current_skin = PlayerData:GetRoleById(DataModel.RoleId).current_skin
      DataModel:RefreshPage()
      DataModel.RoleData.current_skin = current_skin
      PlayerData.RefreshRoleInCoachSkin(DataModel.RoleId)
    end, DataModel.RoleId, row.unitViewId, row.isSpine2)
  end,
  SkinPreview_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    View.self:Confirm()
    UIManager:GoBack()
  end,
  SkinPreview_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    MapNeedleData.GoHome()
  end,
  SkinPreview_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  SkinPreview_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  SkinPreview_Group_View_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
  end,
  SkinPreview_Group_View_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
  end,
  SkinPreview_Group_View_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  SkinPreview_Group_View_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  SkinPreview_Group_CommonTopLeft2_Btn_Return_Click = function(btn, str)
    View.self:PlayAnim("Animation_Skin_in")
    DataModel:Reset()
    if not DataModel.canDrag then
      DataModel:MoveSpine2Live2D(0)
    end
  end,
  SkinPreview_Group_CommonTopLeft2_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  SkinPreview_Group_CommonTopLeft2_Btn_Menu_Click = function(btn, str)
  end,
  SkinPreview_Group_CommonTopLeft2_Btn_Help_Click = function(btn, str)
  end,
  SkinPreview_Img_Bg_Slider_Scale_Slider = function(slider, value)
    View.Group_CharacterSkin.ScrollView_Skin.Viewport.Content.Group_Spine.transform.localScale = Vector3(value, value, value)
    View.Group_CharacterSkin.ScrollView_Skin.Viewport.Content.Group_Character.transform.localScale = Vector3(value, value, value)
    DataModel.SetHideTime()
  end,
  SkinPreview_Img_Bg_Slider_Scale_SliderDown = function(slider)
  end,
  SkinPreview_Img_Bg_Slider_Scale_SliderUp = function(slider)
  end,
  SkinPreview_Btn_Share_Click = function(btn, str)
    Controller:OnBtnShare()
  end,
  SkinPreview_Img_Bg_Group_Left_Group_Bottom_Group_Btn_Img_Live2dBg_Btn_Click_Click = function(btn, str)
    DataModel:ClickLive2D(DataModel.live2D)
  end,
  SkinPreview_Img_Bg_Group_Left_Group_Bottom_Group_Btn_Btn_Look_Click = function(btn, str)
    View.self:PlayAnim("Animation_Skin_out", function()
      View.Img_Bg.Slider_Scale:SetSliderValue(1)
      DataModel.InLook = true
      DataModel.SetHideTime()
      View.Img_Bg.Slider_Scale:SetActive(DataModel.canDrag)
    end)
    View.Group_CommonTopLeft:SetActive(false)
    View.Group_CommonTopLeft2:SetActive(true)
    if DataModel.canDrag then
      View.Group_CharacterSkin.ScrollView_Skin.self.ScrollRect.enabled = true
    else
      DataModel:MoveSpine2Live2D(1)
    end
  end,
  SkinPreview_Img_Bg_Group_Left_Group_Bottom_Group_Btn_Btn_HomeSkill_Click = function(btn, str)
    local row = DataModel.SkinList[tonumber(DataModel.ChooseIndex)]
    local t = {}
    t.roleId = DataModel.RoleId
    t.unitViewIdId = row.unitViewId
    t.noShowUnit = true
    UIManager:Open("UI/LifeSkillTips/LifeSkillTips", Json.encode(t))
  end,
  SkinPreview_Img_Bg_Group_Left_Group_Minion_Btn_Select_Click = function(btn, str)
    DataModel:OnClickSelectExtraSpine()
  end,
  SkinPreview_Img_Bg_Group_Left_Group_Minion_Btn_Loop_Click = function(btn, str)
    DataModel:OnClickLoopExtraSpine()
  end,
  SkinPreview_Img_Bg_Group_Left_Group_Minion_Btn_Reset_Click = function(btn, str)
    DataModel:OnClickResetExtraSpine()
  end,
  SkinPreview_Group_CharacterSkin_ScrollView_Skin_Viewport_Content_Group_Video_Video_Character_Skip_Click = function(btn, str)
  end,
  SkinPreview_Img_Bg_Group_Left_Btn_ChangePose_Click = function(btn, str)
    DataModel:OnClickChangePose()
  end
}
return ViewFunction
