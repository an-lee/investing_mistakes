class MixinTokenManager
  client_id = Figaro.env.MIXIN_CLIENT_ID
  client_secret = Figaro.env.MIXIN_CLIENT_SECRET

  def self.access_token(code)
    payload = {
      "client_id": client_id,
      "code": code,
      "client_secret": client_secret
    }

    path = 'oauth/token'
    r = MixinAPI::Client.new.post(path, json: payload)

    access_token = r['data']['access_token']
  end

end
