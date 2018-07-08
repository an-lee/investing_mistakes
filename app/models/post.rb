# == Schema Information
#
# Table name: posts
#
#  id              :bigint(8)        not null, primary key
#  author_id(作者) :bigint(8)
#  should(本应)    :string
#  but(但是)       :string
#  result(结果)    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_posts_on_author_id  (author_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#

class Post < ApplicationRecord
  DEFAULT_PAYMENT_OPTIONS = [
    {
      symbol: 'CNB',
      asset_id: '965e5c6e-434c-3fa9-b780-c50f43cd955c',
      icon_url: 'https://images.mixin.one/0sQY63dDMkWTURkJVjowWY6Le4ICjAFuu3ANVyZA4uI3UdkbuOT5fjJUT82ArNYmZvVcxDXyNjxoOv0TAYbQTNKS=s128'
    },
    {
      symbol: 'PRS',
      asset_id: '3edb734c-6d6f-32ff-ab03-4eb43640c758',
      icon_url: 'https://images.mixin.one/1fQiAdit_Ji6_Pf4tW8uzutONh9kurHhAnN4wqEIItkDAvFTSXTMwlk3AB749keufDFVoqJb5fSbgz7K2HoOV7Q=s128'
    },
    {
      symbol: 'XIN',
      asset_id: 'c94ac88f-4671-3976-b60a-09064f1811e8',
      icon_url: 'https://images.mixin.one/E2y0BnTopFK9qey0YI-8xV3M82kudNnTaGw0U5SU065864SsewNUo6fe9kDF1HIzVYhXqzws4lBZnLj1lPsjk-0=s128'
    }
  ]

  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  has_many :receivables, class_name: 'Payment'

  validates :should, presence: true
  validates :but, presence: true
  validates :result, presence: true
end
