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
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  validates :should, presence: true
  validates :but, presence: true
  validates :result, presence: true
end
