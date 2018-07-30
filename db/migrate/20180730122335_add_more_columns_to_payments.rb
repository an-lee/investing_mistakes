class AddMoreColumnsToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :transfer_trace, :string, comment: '转账trace'
    add_column :payments, :paid_at, :datetime, comment: '付款时间'
    add_column :payments, :transferred_at, :datetime, comment: '转账时间'
    add_index :payments, :transfer_trace, unique: true
  end
end
