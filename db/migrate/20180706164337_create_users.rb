class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :uid, comment: 'mixin 的 user_id'
      t.json :raw, comment: 'mixin 返回的原始数据'
      t.timestamps
    end

    add_index :users, :uid, unique: true
  end
end
