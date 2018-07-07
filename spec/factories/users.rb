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

FactoryBot.define do
  factory :user do
    
  end
end
