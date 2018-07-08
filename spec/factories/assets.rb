# == Schema Information
#
# Table name: assets
#
#  id                            :bigint(8)        not null, primary key
#  owner_id(所有者)              :bigint(8)
#  uuid(Mixin网络中的唯一标识)   :string
#  chain_id(链ID)                :string
#  symbol(简称)                  :string
#  name(全称)                    :string
#  icon_url(图标链接)            :string
#  balance(余额)                 :string
#  public_key(公钥)              :string
#  price_btc(单价，以 BTC 计价)  :string
#  price_usd(单价，以  USD 计价) :string
#  change_btc(以 BTC 计价变动)   :string
#  change_usd(以 USD 计价变动)   :string
#  asset_key                     :string
#  confirmations(确认数)         :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
# Indexes
#
#  index_assets_on_owner_id  (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#

FactoryBot.define do
  factory :asset do
    
  end
end
