local View = require("UIStore/UIStoreView")
local RecommendController = {}

function RecommendController:SetRecommendImage(imagePath)
  if SdkHelper.IsChannelDmm() then
    imagePath = imagePath .. "_dmm"
  end
  View.Group_RecommendStore.Btn_Recommend:SetSprite(imagePath)
end

return RecommendController
