local View = require("UIVolleyBallChoose/UIVolleyBallChooseView")
local DataModel = require("UIVolleyBallChoose/UIVolleyBallChooseDataModel")
local ViewFunction = {
  VolleyBallChoose_Group_Choose_ScrollGrid__SetGrid = function(element, elementIndex)
    local id = DataModel.roleList[elementIndex].id
    local data = PlayerData:GetFactoryData(id)
    local selected, player = DataModel.RoleIsSelect(id)
    if selected then
      element.Img_Mask:SetActive(true)
      element.Group_Block:SetActive(true)
      element.Group_Block.Img_PBg:SetActive(player)
      element.Group_Block.Img_AIBg:SetActive(not player)
      element.Group_Select:SetActive(false)
    else
      element.Group_Block:SetActive(false)
      if DataModel.nowSelectIdx ~= elementIndex then
        element.Img_Mask:SetActive(true)
        element.Group_Select:SetActive(false)
      else
        element.Group_Select:SetActive(true)
        local isPlayer = DataModel.status == 0
        element.Group_Select.Img_Mask.Img_Client:SetSprite(data.uiPath)
        element.Group_Select.Img_PSelect:SetActive(isPlayer)
        element.Group_Select.Img_PSure:SetActive(isPlayer)
        element.Group_Select.Img_AISelect:SetActive(not isPlayer)
        element.Group_Select.Img_AISelect.Txt_Name:SetText(data.roleName)
      end
    end
    element.Img_Mask.Img_Client:SetSprite(data.uiPath)
    element.Txt_Name:SetText(data.roleName)
    element.Btn_:SetClickParam(elementIndex)
  end,
  VolleyBallChoose_Group_Choose_ScrollGrid__Group_Item_Btn__Click = function(btn, str)
    local isPlayer = DataModel.status == 0
    if isPlayer == false then
      return
    end
    local nowIdx = tonumber(str)
    local id = DataModel.roleList[nowIdx].id
    local selected = DataModel.RoleIsSelect(id)
    if not selected then
      if DataModel.nowSelectIdx == nowIdx then
        DataModel.UpdateSelectRoleInfo(id)
        DataModel.FindNextSelectId(DataModel.status == 1)
        DataModel.PlaySound(30005401)
        View.timer:Reset()
        View.Group_Choose.Group_Tips.Img_Countdown:SetSprite("UI/VolleyBall/Volleyball_Countdown/9")
        if DataModel.status == 1 then
          View.Group_Choose.Group_Tips.Txt_PStage:SetActive(false)
          View.Group_Choose.Group_Tips.Txt_AIstage:SetActive(true)
          View.Group_Choose.ScrollGrid_.grid.self:MoveToPos(DataModel.nowSelectIdx)
        end
        DataModel.PlaySound(30005398)
      else
        DataModel.PlaySound(30005397)
        DataModel.nowSelectIdx = nowIdx
      end
    end
    View.Group_Choose.ScrollGrid_.grid.self:RefreshAllElement()
    View.Group_Choose.StaticGrid_.grid.self:RefreshAllElement()
  end,
  VolleyBallChoose_Group_Choose_StaticGrid__SetGrid = function(element, elementIndex)
    local roleId = DataModel.selectRoleList[elementIndex]
    element.Img_Role:SetActive(not roleId)
    element.Group_:SetActive(roleId)
    if roleId then
      element.Group_.Group_Name.Img_Choose:SetActive(false)
      element.Group_.Group_Name.Img_Ball:SetActive(true)
      local data = PlayerData:GetFactoryData(roleId)
      element.Group_.SpineAnimation_Character:SetData(data.resPath, "volleyball_stand")
      element.Group_.Group_Name.Txt_Name:SetText(data.roleName)
    end
    if not roleId and elementIndex == #DataModel.selectRoleList + 1 then
      element.Group_:SetActive(true)
      element.Img_Role:SetActive(false)
      element.Group_.Group_Name.Img_Choose:SetActive(true)
      element.Group_.Group_Name.Img_Ball:SetActive(false)
      local id = DataModel.roleList[DataModel.nowSelectIdx].id
      local data = PlayerData:GetFactoryData(id)
      element.Group_.SpineAnimation_Character:SetData(data.resPath)
      element.Group_.Group_Name.Txt_Name:SetText(data.roleName, "volleyball_stand")
    end
  end
}
return ViewFunction
