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
#
# Indexes
#
#  index_payments_on_payer_id      (payer_id)
#  index_payments_on_post_id       (post_id)
#  index_payments_on_recipient_id  (recipient_id)
#  index_payments_on_trace         (trace) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (payer_id => users.id)
#  fk_rails_...  (recipient_id => users.id)
#

class Payment < ApplicationRecord
  include AASM
  include Tracable
  include DisplayAsset

  belongs_to :payer, class_name: 'User', foreign_key: 'payer_id'
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :post, optional: true

  validates :amount, numericality: { greater_than: 0 }

  asset_methods :amount

  aasm column: :state, requires_lock: true do
    state :drafted, initial: true
    state :processing
    state :completed

    event :started_processing_payment, after: :touch_processing_started_at do
      transitions from: :drafted, to: :processing
    end

    event :complete, after: :touch_completed_at do
      transitions from: :processing, to: :completed
    end
  end

  private

  def touch_processing_started_at
    touch(:processing_started_at)
  end

  def touch_completed_at
    touch(:completed_at)
  end
end
