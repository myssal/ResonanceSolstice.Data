local DataModel = require("UIRoguehelp/UIRoguehelpDataModel")
local View = require("UIRoguehelp/UIRoguehelpView")
local Controller = {maxCount = 0, curIndex = 1}

function Controller.Init()
  Controller.maxCount = View.Group_Info.StaticGrid_Pagecount.grid.self.DataCount or 0
  Controller.curIndex = 1
  Controller.RefreshContentInfo()
  View.Group_Info.Group_bg.Img_title:SetSprite(PlayerData:GetFactoryData(88300250).filePath)
  View.Group_Info.Group_Help.Img_Page1:SetSprite(PlayerData:GetFactoryData(88300256).filePath)
  View.Group_Info.Group_Help.Img_Page2:SetSprite(PlayerData:GetFactoryData(88300257).filePath)
  View.Group_Info.Group_Help.Img_Page3:SetSprite(PlayerData:GetFactoryData(88300258).filePath)
  View.Group_Info.Group_Help.Img_Page4:SetSprite(PlayerData:GetFactoryData(88300259).filePath)
  View.Group_Info.Group_Help.Img_Page5:SetSprite(PlayerData:GetFactoryData(88300260).filePath)
  View.Group_Info.Group_Help.Img_Page6:SetSprite(PlayerData:GetFactoryData(88300261).filePath)
  View.Group_Info.Group_Help.Img_Page7:SetSprite(PlayerData:GetFactoryData(88300262).filePath)
end

function Controller.RefreshContentInfo()
  local pageCount = View.Group_Info.Group_Help.self.transform.childCount
  if 0 < pageCount then
    for i = 1, pageCount do
      local temp = View.Group_Info.Group_Help["Img_Page" .. tostring(i)]
      if temp then
        temp:SetActive(Controller.curIndex == i)
      end
    end
  end
  View.Group_Info.Group_Btn.Btn_back:SetActive(1 < Controller.curIndex)
  View.Group_Info.Img_left:SetActive(1 < Controller.curIndex)
  View.Group_Info.Group_Btn.Btn_frost:SetActive(Controller.curIndex < Controller.maxCount)
  View.Group_Info.Img_right:SetActive(Controller.curIndex < Controller.maxCount)
  View.Group_Info.StaticGrid_Pagecount.grid.self:RefreshAllElement()
end

function Controller.RefreshPageCountElement(element, elementIndex)
  if not element or not elementIndex then
    return
  end
  if elementIndex == Controller.curIndex then
    element.Group_Unselete:SetActive(false)
    element.Group_Select:SetActive(true)
  else
    element.Group_Unselete:SetActive(true)
    element.Group_Select:SetActive(false)
  end
end

function Controller.OnBackBtnClick()
  Controller.curIndex = Controller.curIndex - 1
  if Controller.curIndex < 1 then
    Controller.curIndex = 1
  end
  Controller.RefreshContentInfo()
end

function Controller.OnNextBtnClick()
  Controller.curIndex = Controller.curIndex + 1
  if Controller.curIndex > Controller.maxCount then
    Controller.curIndex = Controller.maxCount
  end
  Controller.RefreshContentInfo()
end

return Controller
