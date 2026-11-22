local View = require("UIStealResultIn/UIStealResultInView")
local BtnItem = require("Common/BtnItem")
local DataModel = {}
DataModel.stealNum = 0

function DataModel.SetJsonData(json)
  if not json then
    return
  end
  local data = Json.decode(json)
  DataModel.stealNum = data.stealNum
end

function DataModel.InitData()
end

function DataModel.RefreshOnShow()
  local success = DataModel.stealNum > 0
  View.Group_Fail:SetActive(not success)
  View.Group_300:SetActive(success)
  View.Group_Item:SetActive(success)
  View.Group_300.Group_Title.Img_Title:SetSprite(GetResPath(88300182))
  if success then
    View.Group_Item.Group_Item.Btn_Item:SetClickParam(82900012)
    BtnItem:SetItem(View.Group_Item.Group_Item, {
      id = 82900012,
      num = DataModel.stealNum
    })
  end
end

return DataModel
