module MixinAPI
  def self.assets_list
    PRS_ASSET_ID = "3edb734c-6d6f-32ff-ab03-4eb43640c758"
    LY_ASSET_ID = "35f7a3a3-4335-3bf3-beca-685836602d72"
    BTCCash_ASSET_ID = "fd11b6e3-0b87-41f1-a41f-f0e9b49e5bf0"
    CNB_ASSET_ID = "965e5c6e-434c-3fa9-b780-c50f43cd955c"
    EOS_ASSET_ID = "f8127159-e473-389d-8e0c-9ac5a4dc8cc6"
    CANDY_ASSET_ID = "43b645fc-a52c-38a3-8d3b-705e7aaefa15"
  end
  
  def self.api_user
    @api_user ||= MixinAPI::API::User.new
  end

  def self.api_payment
    @api_payment ||= MixinAPI::API::Payment.new
  end

  def self.api_auth
    @api_auth ||= MixinAPI::API::Auth.new(
      client_id: Figaro.env.MIXIN_CLIENT_ID,
      client_secret: Figaro.env.MIXIN_CLIENT_SECRET,
      session_id: Figaro.env.MIXIN_SESSION_ID,
      pin_code: Figaro.env.MIXIN_PIN_CODE,
      pin_token: Figaro.env.MIXIN_PIN_TOKEN,
      private_key: Figaro.env.MIXIN_PRIVATE_KEY
    )
  end
end
