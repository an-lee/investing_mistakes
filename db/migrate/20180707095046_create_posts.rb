class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts, comment: '帖子' do |t|
      t.references :author, foreign_key: { to_table: :users }, comment: '作者'
      t.text :should, comment: '本应'
      t.text :but, comment: '但是'
      t.text :result, comment: '结果'
      t.timestamps
    end
  end
end
