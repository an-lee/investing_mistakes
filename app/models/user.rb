# == Schema Information
#
# Table name: users
#
#  id                        :bigint(8)        not null, primary key
#  uid(mixin 的 user_id)     :string
#  raw(mixin 返回的原始数据) :json
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  index_users_on_uid  (uid) UNIQUE
#

class User < ApplicationRecord
  include Authenticatable

  has_many :assets, foreign_key: :owner_id
  has_many :posts, foreign_key: :author_id
  has_many :payments, foreign_key: 'payer_id'
  has_many :receivables, class_name: 'Payment', foreign_key: 'recipient_id'
  has_many :comments, foreign_key: :commenter_id

  validates :uid, presence: true, uniqueness: true

  def name
    raw.fetch('full_name')
  end

  def avatar_url
    raw.fetch('avatar_url')
  end

  def phone
    raw.fetch('phone')
  end

  def code_url
    raw.fetch('code_url')
  end
end
