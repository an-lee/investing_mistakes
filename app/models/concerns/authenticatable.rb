module Authenticatable
  extend ActiveSupport::Concern

  class_methods do
    def auth_from_mixin(code)
      access_token = MixinTokenManager.access_token(code)
      profile = MixinAPI.api_user.read_profile(access_token).fetch('data', nil)
      assets = MixinAPI.api_user.read_assets(access_token).fetch('data', nil)

      raise 'No user profile found!' unless profile.present?

      user = find_or_create_by!(uid: profile.fetch('user_id'))
      raw = (user.raw.presence || {}).merge(profile)
      user.update! raw: raw

      unless assets.blank?
        assets.each do |asset|
          user_asset = user.assets.find_or_create_by(uuid: asset.fetch('asset_id'))
          user_asset.update({
            chain_id: asset.fetch('chain_id'),
            symbol: asset.fetch('symbol'),
            name: asset.fetch('name'),
            icon_url: asset.fetch('icon_url'),
            balance: asset.fetch('balance'),
            price_btc: asset.fetch('price_btc'),
            price_usd: asset.fetch('price_usd'),
            change_btc: asset.fetch('change_btc'),
            change_usd: asset.fetch('change_usd'),
            asset_key: asset.fetch('asset_key'),
            confirmations: asset.fetch('confirmations'),
          })
        end
      end

      user
    end
  end
end
