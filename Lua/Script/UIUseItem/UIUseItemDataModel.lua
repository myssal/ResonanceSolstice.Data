local DataModel = {
  Params = {},
  CurShowList = {}
}

function DataModel.Init()
  DataModel.CurShowList = {}
  local tradeConfig = PlayerData:GetFactoryData(99900062, "ConfigFactory")
  if DataModel.Params.type == 1 then
    DataModel.CurShowList = {}
    for _, v in ipairs(tradeConfig.buyItemList) do
      local isFind = true
      local itemCA = PlayerData:GetFactoryData(v.id)
      if itemCA and itemCA.goodsList and #itemCA.goodsList > 0 then
        isFind = false
        for _, goodsId in ipairs(itemCA.goodsList) do
          for _, sellId in ipairs(DataModel.Params.sellList) do
            if goodsId.id == sellId then
              isFind = true
              break
            end
          end
          if isFind then
            break
          end
        end
      end
      if isFind then
        local t = Clone(v)
        table.insert(DataModel.CurShowList, t)
      end
    end
  elseif DataModel.Params.type == 2 then
    DataModel.CurShowList = tradeConfig.sellItemList
  end
end

return DataModel
