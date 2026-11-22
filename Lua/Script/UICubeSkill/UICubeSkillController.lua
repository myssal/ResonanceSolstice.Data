local DataModel = require("UICubeSkill/UICubeSkillDataModel")
local View = require("UICubeSkill/UICubeSkillView")
local Controller = {
  curSelectIndex = 1,
  curUnlockIndex = 0,
  effectCt = nil
}

function Controller.Init()
  Controller.curUnlockIndex = 0
  local skillList = DataModel.GetSkillList() or {}
  View.ScrollView_SkillList.Viewport.Content.Group_Skill.StaticGrid_SkillList.grid.self:SetDataCount(#skillList)
  View.ScrollView_SkillList.Viewport.Content.Group_Skill.StaticGrid_SkillList.grid.self:RefreshAllElement()
  local openIndex = DataModel.GetFirstOpenIndex() or 1
  Controller.OnSkillClick(openIndex)
  View.ScrollView_SkillList.Viewport.Content:SetLocalPositionX(DataModel.GetScrollContentPosByIndex(openIndex))
  Controller.RefreshUnlockProgress()
  Controller.RefreshUseItemShow()
  View.Img_Title:SetSprite(PlayerData:GetFactoryData(88300189).filePath)
end

function Controller.Release()
  Controller.curUnlockIndex = 0
  if Controller.effectCt then
    View.self:StopC(Controller.effectCt)
    Controller.effectCt = nil
  end
end

function Controller.RefreshSkillItemElement(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  local skillList = DataModel.GetSkillList() or {}
  local skillInfo = skillList[elementIndex]
  if not skillInfo then
    return
  end
  local skillConfig = PlayerData:GetFactoryData(skillInfo.id, "RogueBuffFactory")
  if not skillConfig then
    return
  end
  local lockState = DataModel.GetSkillLockState(skillInfo)
  element.Img_Mask.Img_SkillIcon:SetSprite(skillConfig.iconPath)
  local lineColor = lockState == DataModel.lockState.Unlocked and "#FFFFFF" or "#7F7F7F"
  element.Group_Line.Img_1:SetColor(lineColor)
  element.Group_Line.Img_2:SetColor(lineColor)
  element.Group_Line.Img_3:SetColor(lineColor)
  element.Img_Mask.Img_SkillIcon:SetColor(lineColor)
  if lockState == DataModel.lockState.Unlocked then
    element.Img_UnLocked:SetActive(true)
    element.Img_UnLockable:SetActive(false)
    element.Img_Locked:SetActive(false)
  elseif lockState == DataModel.lockState.UnlockAble then
    element.Img_UnLocked:SetActive(false)
    element.Img_UnLockable:SetActive(true)
    element.Img_Locked:SetActive(false)
  else
    element.Img_UnLocked:SetActive(false)
    element.Img_UnLockable:SetActive(true)
    element.Img_Locked:SetActive(true)
  end
  element.Btn_Skill:SetClickFunction(function()
    Controller.OnSkillClick(elementIndex)
  end)
  if Controller.curSelectIndex == elementIndex then
    element.Img_Selected:SetActive(true)
  else
    element.Img_Selected:SetActive(false)
  end
  if Controller.curUnlockIndex == elementIndex then
    element.Group_LightenEffect:SetActive(true)
    Controller.effectCt = View.self:StartC(LuaUtil.cs_generator(function()
      coroutine.yield(CS.UnityEngine.WaitForSeconds(3))
      element.Group_LightenEffect:SetActive(false)
      Controller.curUnlockIndex = 0
    end))
  else
    element.Group_LightenEffect:SetActive(false)
  end
end

function Controller.OnSkillClick(elementIndex)
  if not elementIndex then
    return
  end
  Controller.curSelectIndex = elementIndex
  View.ScrollView_SkillList.Viewport.Content.Group_Skill.StaticGrid_SkillList.grid.self:RefreshAllElement()
  Controller.RefreshSkillDetailShow()
end

function Controller.RefreshSkillDetailShow()
  if not Controller.curSelectIndex then
    return
  end
  local skillList = DataModel.GetSkillList() or {}
  local skillInfo = skillList[Controller.curSelectIndex]
  if not skillInfo then
    return
  end
  local skillConfig = PlayerData:GetFactoryData(skillInfo.id, "RogueBuffFactory")
  if not skillConfig then
    return
  end
  local lockState = DataModel.GetSkillLockState(skillInfo)
  View.Group_Bottom.Group_Icon.Img_UnLocked:SetActive(lockState == DataModel.lockState.Unlocked)
  View.Group_Bottom.Group_Icon.Img_UnLockable:SetActive(lockState ~= DataModel.lockState.Unlocked)
  View.Group_Bottom.Group_Icon.Img_Locked:SetActive(2 < lockState)
  View.Group_Bottom.Group_Icon.Img_Mask.Img_SkillIcon:SetSprite(skillConfig.iconPath)
  local lineColor = lockState == DataModel.lockState.Unlocked and "#FFFFFF" or "#7F7F7F"
  View.Group_Bottom.Group_Icon.Img_Mask.Img_SkillIcon:SetColor(lineColor)
  View.Group_Bottom.Txt_SkillName:SetText(skillConfig.name)
  View.Group_Bottom.Txt_SkillDes:SetText(skillConfig.des)
  View.Group_Bottom.Group_Btn.Group_Unlocked:SetActive(lockState == DataModel.lockState.Unlocked)
  View.Group_Bottom.Group_Btn.Group_Unlockable:SetActive(lockState == DataModel.lockState.UnlockAble)
  View.Group_Bottom.Group_Btn.Group_NotEnoughCoin:SetActive(lockState == DataModel.lockState.Lock_NotEnoughCoin)
  View.Group_Bottom.Group_Btn.Group_Ongoing:SetActive(lockState == DataModel.lockState.Lock_Ongoing)
  View.Group_Bottom.Group_Btn.Group_PrerequisiteLocked:SetActive(lockState == DataModel.lockState.Lock_PreSkillLocked)
  View.Group_Bottom.Group_Btn.Group_Unlockable.Txt_RequiredNum:SetText(skillInfo.requiredNum)
  View.Group_Bottom.Group_Btn.Group_NotEnoughCoin.Txt_RequiredNum:SetText(skillInfo.requiredNum)
  local itemInfo = DataModel.GetUseItemConfigInfo()
  if itemInfo then
    View.Group_Bottom.Group_Btn.Group_Unlockable.Txt_RequiredNum.Img_Coin:SetSprite(itemInfo.iconPath)
    View.Group_Bottom.Group_Btn.Group_NotEnoughCoin.Txt_RequiredNum.Img_Coin:SetSprite(itemInfo.iconPath)
  end
end

function Controller.RefreshUnlockProgress()
  local skillList = DataModel.GetSkillList() or {}
  local unlockNum = 0
  for i = 1, #skillList do
    if DataModel.GetSkillLockState(skillList[i]) == DataModel.lockState.Unlocked then
      unlockNum = unlockNum + 1
    end
  end
  View.Group_Porgress.Txt_Num:SetText(tostring(unlockNum) .. "/" .. tostring(#skillList))
end

function Controller.RefreshUseItemShow()
  local itemInfo = DataModel.GetUseItemConfigInfo()
  if not itemInfo then
    return
  end
  View.Group_Coin.Img_Icon:SetSprite(itemInfo.iconPath)
  View.Group_Coin.Btn_GoldCoin:SetClickParam(itemInfo.id)
  local hasCount = DataModel.GetUseItemHasCount() or 0
  View.Group_Coin.Txt_Num:SetText(tostring(hasCount))
end

function Controller.OnUnlockAbleBtnClick()
  if not Controller.curSelectIndex then
    return
  end
  local skillList = DataModel.GetSkillList() or {}
  local skillInfo = skillList[Controller.curSelectIndex]
  if not skillInfo then
    return
  end
  local lockState = DataModel.GetSkillLockState(skillInfo)
  if lockState ~= DataModel.lockState.UnlockAble then
    return
  end
  Net:SendProto("cube.unlock_outside", function(json)
    if string.nilorempty(json.rc) then
      DataModel.SetSkillIsUnlock(tostring(skillInfo.id))
      Controller.curUnlockIndex = Controller.curSelectIndex
      local itemInfo = DataModel.GetUseItemConfigInfo()
      if itemInfo then
        PlayerData:RefreshUseItems({
          [itemInfo.id] = skillInfo.requiredNum
        })
      end
      View.ScrollView_SkillList.Viewport.Content.Group_Skill.StaticGrid_SkillList.grid.self:RefreshAllElement()
      Controller.RefreshUnlockProgress()
      Controller.RefreshUseItemShow()
      Controller.RefreshSkillDetailShow()
    end
  end, tostring(Controller.curSelectIndex - 1))
end

return Controller
