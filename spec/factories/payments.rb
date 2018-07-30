# == Schema Information
#
# Table name: payments
#
#  id                                  :bigint(8)        not null, primary key
#  payer_id(支付人)                    :bigint(8)
#  recipient_id(收款人)                :bigint(8)
#  post_id(关联的帖子)                 :bigint(8)
#  asset_id(支付币种)                  :string
#  trace(支付编号)                     :string
#  memo(备注)                          :string
#  state(支付状态)                     :string
#  amount(支付总额)                    :decimal(, )
#  processing_started_at(开始支付时间) :datetime
#  completed_at(支付完成时间)          :datetime
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  transfer_trace(转账trace)           :string
#  paid_at(付款时间)                   :datetime
#  transferred_at(转账时间)            :datetime
#
# Indexes
#
#  index_payments_on_payer_id        (payer_id)
#  index_payments_on_post_id         (post_id)
#  index_payments_on_recipient_id    (recipient_id)
#  index_payments_on_trace           (trace) UNIQUE
#  index_payments_on_transfer_trace  (transfer_trace) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (payer_id => users.id)
#  fk_rails_...  (recipient_id => users.id)
#

FactoryBot.define do
  factory :payment do
    
  end
end
