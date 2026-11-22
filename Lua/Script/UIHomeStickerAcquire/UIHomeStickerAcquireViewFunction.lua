local View = require("UIHomeStickerAcquire/UIHomeStickerAcquireView")
local DataModel = require("UIHomeStickerAcquire/UIHomeStickerAcquireDataModel")
local Controller = require("UIHomeStickerAcquire/UIHomeStickerAcquireController")
local ViewFunction = {
  HomeStickerAcquire_Btn_Mask_Click = function(btn, str)
    if DataModel.DataIndex >= #DataModel.Data then
      local stickerController = require("UIHomeSticker/UIHomeStickerController")
      stickerController:SetUIVisible(true)
      UIManager:GoBack(false, 1)
    else
      DataModel.DataIndex = DataModel.DataIndex + 1
      View.self:SetEnableAnimator(true)
      Controller:Init()
    end
  end,
  HomeStickerAcquire_Group_Item_Group_Other_Btn_Other_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(DataModel.Data[DataModel.DataIndex].id, DataModel.Data[DataModel.DataIndex])
  end
}
return ViewFunction
