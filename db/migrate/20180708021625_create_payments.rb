class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments, comment: '支付' do |t|
      t.references :payer, foreign_key: { to_table: :users }, comment: '支付人'
      t.references :recipient, foreign_key: { to_table: :users }, comment: '收款人'
      t.references :post, comment: '关联的帖子'
      t.string :asset_id, comment: '支付币种'
      t.string :trace, comment: '支付编号'
      t.string :memo, comment: '备注'
      t.string :state, comment: '支付状态'
      t.decimal :amount, comment: '支付总额'
      t.datetime :processing_started_at, comment: '开始支付时间'
      t.datetime :completed_at, comment: '支付完成时间'
      t.timestamps
    end

    add_index :payments, :trace, unique: true
  end
end
