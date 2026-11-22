local View = require("UIDialog/UIDialogView")
local base = require("UIDialog/Model_PlotBase")
local PlotBoxCallBack = Class.New("PlotBoxCallBack", base)

function PlotBoxCallBack:Ctor()
end

function PlotBoxCallBack:OnStart(ca)
  if string.find(ca.callBackName, "[()]") then
    local funcs = require("UI" .. ca.prefabName .. "/UI" .. ca.prefabName .. "Controller")
    local env = {}
    for name, func in pairs(funcs) do
      if type(func) == "function" then
        env[name] = func
      end
    end
    local chunk = load("return " .. ca.callBackName, "=(command)", "t", env)
    if not chunk then
      print_r("\232\167\163\230\158\144\229\164\177\232\180\165: " .. ca.callBackName)
    else
      chunk()
    end
  else
    require("UI" .. ca.prefabName .. "/UI" .. ca.prefabName .. "Controller")[ca.callBackName]()
  end
end

function PlotBoxCallBack.GetState()
  return true
end

function PlotBoxCallBack:Dtor()
end

return PlotBoxCallBack
