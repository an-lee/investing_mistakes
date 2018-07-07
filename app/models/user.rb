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
