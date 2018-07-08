module MixinAPI
  def self.api_user
    @api_user ||= MixinAPI::API::User.new
  end

  def self.api_payment
    @api_payment ||= MixinAPI::API::Payment.new
  end
end
