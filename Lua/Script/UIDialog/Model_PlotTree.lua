local view = require("UIDialog/UIDialogView")
local base = require("UIDialog/Model_PlotBase")
local PlotChangeBg = require("UIDialog/Model_ChangeBg")
local PlotChangeRoleImg = require("UIDialog/Model_ChangeRoleImg")
local PlotRoleImgStatus = require("UIDialog/Model_RoleImgStatus")
local PlotCheckBox = require("UIDialog/Model_CheckBox")
local PlotJumpOrder = require("UIDialog/Model_JumpOrder")
local PlotText = require("UIDialog/Model_PlotText")
local PlotTextShow = require("UIDialog/Model_PlotTextShow")
local PlotTextHide = require("UIDialog/Model_PlotTextHide")
local PlotRoleSpine = require("UIDialog/Model_RoleSpine")
local PlotImgMove = require("UIDialog/Model_PlotImgMove")
local PlotVideo = require("UIDialog/Model_PlotVideo")
local PlotSetUI = require("UIDialog/Model_PlotSetUI")
local PlotFocus = require("UIDialog/Model_Focus")
local PlotSound = require("UIDialog/Model_Sound")
local PloatMask = require("UIDialog/Model_Mask")
local PlotChangeFace = require("UIDialog/Model_PlotChangeFace")
local PlotChangeSpine = require("UIDialog/Model_ChangeSpine")
local PlotTree = Class.New("PlotTree", base)
local classModName = {
  ["\232\131\140\230\153\175"] = function()
    return PlotChangeBg.New()
  end,
  ["\232\167\146\232\137\178"] = function()
    return PlotChangeRoleImg.New()
  end,
  ["\231\171\139\231\187\152\231\138\182\230\128\129"] = function()
    return PlotRoleImgStatus.New()
  end,
  ["\231\171\139\231\187\152\231\167\187\229\138\168"] = function()
    return PlotImgMove.New()
  end,
  ["\229\164\141\233\128\137\230\161\134"] = function()
    return PlotCheckBox.New()
  end,
  ["\232\183\179\232\183\131\229\145\189\228\187\164"] = function()
    return PlotJumpOrder.New()
  end,
  ["\230\150\135\230\156\172\229\137\167\230\131\133"] = function()
    return PlotText.New()
  end,
  ["\230\152\190\231\164\186\230\150\135\230\156\172"] = function()
    return PlotTextShow.New()
  end,
  ["\233\154\144\232\151\143\230\150\135\230\156\172"] = function()
    return PlotTextHide.New()
  end,
  ["\232\129\154\231\132\166"] = function()
    return PlotFocus.New()
  end,
  ["\229\163\176\233\159\179"] = function()
    return PlotSound.New()
  end,
  ["\229\133\168\229\177\143\233\129\174\231\189\169"] = function()
    return PloatMask.New()
  end,
  ["\229\136\135\230\141\162\232\161\168\230\131\133"] = function()
    return PlotChangeFace.New()
  end,
  ["\232\167\146\232\137\178\229\138\168\231\148\187"] = function()
    return PlotRoleSpine.New()
  end,
  ["\229\136\135\230\141\162\229\138\168\231\148\187"] = function()
    return PlotChangeSpine.New()
  end
}
local childTable = {}

local function InitPlot(plotid)
  local plotCA = PlayerData:GetFactoryData(plotid, "PlotFactory")
  local classMod = classModName[plotCA.mod]()
  classMod:OnStart(plotCA)
  table.insert(childTable, classMod)
end

local function DoTree(nodes)
  for i = 1, #nodes do
    if nodes[i].plotID ~= nil then
      InitPlot(nodes[i].plotID)
    end
  end
end

function PlotTree:Ctor()
end

function PlotTree:OnStart(ca)
  DoTree(ca.plotIdList)
end

function PlotTree.GetState()
  rt = true
  for i = 1, #childTable do
    childTable[i]:OnUpdate()
    if childTable[i].GetState(childTable[i]) == false then
      rt = false
    end
  end
  return rt
end

function PlotTree:Dtor()
end

return PlotTree
