local LoginGV = {}
LoginGV.accessToken = ""
LoginGV.username = ""
LoginGV.viewId = ""
LoginGV.isLoginChannel = false
LoginGV.isLogin = false
LoginGV.isEnterGame = false
LoginGV.channelChannel = ""
LoginGV.SdkLoginDelay = 0.4

function LoginGV.SetAccessToken(token)
  LoginGV.accessToken = token
end

function LoginGV.GetAccessToken()
  return LoginGV.accessToken
end

function LoginGV.SetUsername(name)
  LoginGV.username = name
end

function LoginGV.GetUsername()
  return LoginGV.username or "rolename"
end

function LoginGV.IsLoginChannel()
  return LoginGV.isLoginChannel
end

function LoginGV.SetIsLoginChannel(v)
  LoginGV.isLoginChannel = v
end

function LoginGV.IsLogin()
  return LoginGV.isLogin
end

function LoginGV.SetIsLogin(v)
  LoginGV.isLogin = v
end

function LoginGV.IsEnterGame()
  return LoginGV.isEnterGame
end

function LoginGV.SetIsEnterGame(v)
  LoginGV.isEnterGame = v
end

function LoginGV.OnChannelLogin(args)
  LoginGV.SetAccessToken(args.accessToken)
  if args.username == nil or args.username == "" then
    LoginGV.SetUsername(args.uid)
  else
    LoginGV.SetUsername(args.username)
  end
  LoginGV.SetViewId(args.uid)
  LoginGV.SetIsLogin(true)
end

function LoginGV.SetViewId(id)
  LoginGV.viewId = id
end

function LoginGV.GetViewId()
  return LoginGV.viewId or "0"
end

function LoginGV.SetChannelChannel(v)
  LoginGV.channelChannel = v
end

function LoginGV.GetChannelChannel()
  return LoginGV.channelChannel
end

return LoginGV
