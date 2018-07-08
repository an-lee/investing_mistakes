module MixinAPI
  def self.api_user
    @api_user ||= MixinAPI::API::User.new
  end
end
