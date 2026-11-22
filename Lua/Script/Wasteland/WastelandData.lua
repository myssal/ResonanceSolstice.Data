local Manager = {}

function Manager.InitNetData(json)
  Manager.mapData = {
    rail = {
      [1] = {
        id = 91500057,
        x = 1,
        y = 1
      }
    },
    rewardBox = {
      [1] = {
        id = 91500057,
        x = 1,
        y = 1
      }
    }
  }
  Manager.building = {
    ["91500007"] = {
      srl = 0,
      dir = 0,
      worldPosX = 0,
      worldPosY = 1,
      buildTime = nil,
      port = {
        [1] = {
          posX = 0,
          posY = 0,
          connect = {posX = 0, posY = 0}
        }
      },
      MaterialWarehouse = {},
      ProductWarehouse = {}
    }
  }
end

return Manager
