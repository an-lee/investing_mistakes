class CreateAssets < ActiveRecord::Migration[5.2]
  def change
    create_table :assets, comment: '虚拟资产' do |t|
      t.references :owner, foreign_key: { to_table: :users }, comment: '所有者'
      t.string :uuid, comment: 'Mixin网络中的唯一标识'
      t.string :chain_id, comment: '链ID'
      t.string :symbol, comment: '简称'
      t.string :name, comment: '全称'
      t.string :icon_url, comment: '图标链接'
      t.string :balance, comment: '余额'
      t.string :public_key, comment: '公钥'
      t.string :price_btc, comment: '单价，以 BTC 计价'
      t.string :price_usd, comment: '单价，以  USD 计价'
      t.string :change_btc, comment: '以 BTC 计价变动'
      t.string :change_usd, comment: '以 USD 计价变动'
      t.string :asset_key
      t.string :confirmations, comment: '确认数'
      t.timestamps
    end
  end
end
