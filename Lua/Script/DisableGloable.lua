local declaredNames = {}

function declare(name, initval)
  rawset(_G, name, initval)
  declaredNames[name] = true
end

setmetatable(_G, {
  __newindex = function(t, n, v)
    if not declaredNames[n] then
      error("\229\176\157\232\175\149\229\134\153\229\133\165\230\156\170\229\163\176\230\152\142\231\154\132\229\133\168\229\177\128\229\143\152\233\135\143: " .. n, 2)
    else
      rawset(t, n, v)
    end
  end,
  __index = function(_, n)
    if not declaredNames[n] then
      error("\229\176\157\232\175\149\232\175\187\229\143\150\230\156\170\229\163\176\230\152\142\231\154\132\229\133\168\229\177\128\229\143\152\233\135\143: " .. n, 2)
    else
      return nil
    end
  end
})
