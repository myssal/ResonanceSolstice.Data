local Controller = {}

function Controller:StartDataLink(cb)
  local function callback(json)
    if cb ~= nil then
      cb(json)
    end
  end
  
  Net:SendProto("main.derive_account_gen", callback)
end

function Controller:SetDataLinkPassword(cb, password, password1)
  local function callback(json)
    if cb ~= nil then
      cb(json)
    end
  end
  
  Net:SendProto("main.derive_account_bind", callback, password, password1)
end

return Controller
