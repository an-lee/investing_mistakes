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

require 'rails_helper'

RSpec.describe Post, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
