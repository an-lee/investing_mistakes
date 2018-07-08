class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments, comment: '评论' do |t|
      t.references :commenter, foreign_key: { to_table: :users }, comment: '评论者'
      t.references :commentable, polymorphic: true, index: true, comment: '评论对象'
      t.text :content, comment: '内容'
      t.string :ancestry, index: true
      t.datetime :soft_deleted_at, comment: '删除时间'
      t.timestamps
    end
  end
end
