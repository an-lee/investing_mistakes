# == Schema Information
#
# Table name: comments
#
#  id                        :bigint(8)        not null, primary key
#  commenter_id(评论者)      :bigint(8)
#  commentable_type          :string
#  commentable_id(评论对象)  :bigint(8)
#  content(内容)             :text
#  ancestry                  :string
#  soft_deleted_at(删除时间) :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  index_comments_on_ancestry                             (ancestry)
#  index_comments_on_commentable_type_and_commentable_id  (commentable_type,commentable_id)
#  index_comments_on_commenter_id                         (commenter_id)
#
# Foreign Keys
#
#  fk_rails_...  (commenter_id => users.id)
#

FactoryBot.define do
  factory :comment do
    
  end
end
