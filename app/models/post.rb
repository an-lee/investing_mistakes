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
  AVAILABLE_PAYMENT = {
    symbol: 'CNB',
    name: 'Chui Niu Bi',
    asset_id: '965e5c6e-434c-3fa9-b780-c50f43cd955c',
    icon_url: 'https://images.mixin.one/0sQY63dDMkWTURkJVjowWY6Le4ICjAFuu3ANVyZA4uI3UdkbuOT5fjJUT82ArNYmZvVcxDXyNjxoOv0TAYbQTNKS=s128'
  }

  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  has_many :receivables, class_name: 'Payment'

  validates :should, presence: true
  validates :but, presence: true
  validates :result, presence: true
end
