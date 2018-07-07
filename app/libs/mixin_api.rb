module MixinAPI
  def self.api_profile
    @api_profile ||= MixinAPI::API::Profile.new
  end
end
