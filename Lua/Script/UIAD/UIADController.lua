local View = require("UIAD/UIADView")
local DataModel = require("UIAD/UIADDataModel")
local Controller = {}

function Controller:Init()
  if #PlayerData.TempCache.ADPopInfo.CompleteIdxs > 0 then
    Controller:ShowDetail(PlayerData.TempCache.ADPopInfo.CompleteIdxs[1])
    table.remove(PlayerData.TempCache.ADPopInfo.CompleteIdxs, 1)
  end
end

function Controller:ShowDetail(idx)
  local adCA = PlayerData:GetFactoryData(99900075)
  local info = adCA.adList[idx]
  DataModel.curInfo = info
  View.Btn_AD:SetSprite(info.adPath)
  View.Btn_AD:SetLocalScale(Vector3(info.scale, info.scale, info.scale))
end

function Controller:ClickAD()
  if DataModel.curInfo then
    local function cb()
      if DataModel.curInfo.param ~= "" then
        UIManager:Open(DataModel.curInfo.uiPath, DataModel.curInfo.param)
      else
        UIManager:Open(DataModel.curInfo.uiPath)
      end
    end
    
    if DataModel.curInfo.uiPath == "UI/Gacha/GachaNew" then
      Net:SendProto("recruit.pool_info", function(json)
        cb()
      end)
    else
      cb()
    end
  end
end

function Controller:Close()
  if #PlayerData.TempCache.ADPopInfo.CompleteIdxs > 0 then
    Controller:Init()
  else
    View.self:CloseUI()
  end
end

return Controller
