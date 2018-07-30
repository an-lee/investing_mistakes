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

class Payment < ApplicationRecord
  include AASM
  include Tracable
  include DisplayAsset

  belongs_to :payer, class_name: 'User', foreign_key: 'payer_id'
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :post, optional: true

  validates :amount, numericality: { greater_than: 0 }

  before_validation :setup_memo, :setup_transfer_trace

  asset_methods :amount

  aasm column: :state, requires_lock: true do
    state :drafted, initial: true
    state :processing
    state :paid
    state :transferred
    state :completed

    event :started_processing_payment, after: :touch_processing_started_at do
      transitions from: :drafted, to: :processing
    end

    event :pay, after: [:touch_paid_at, :transfer_to_recipient!] do
      transitions from: :processing, to: :paid
    end

    event :transfer, after: [:touch_transferred_at, :confirm_and_complete] do
      transitions from: :paid, to: :transferred
    end

    event :complete, after: :touch_completed_at do
      transitions from: :transferred, to: :completed
    end
  end

  private

  def setup_memo
    self.memo = '憋伤心，至少还有吹牛币' if memo.blank?
  end

  def transfer_memo
    format('%s (来自用户%s的鼓励金)', memo, payer&.name)
  end

  def transfer_to_recipient!
    self.setup_transfer_trace
    pin = MixinBot.api_pin.encrypt(Figaro.env.MIXIN_PIN_CODE)
    r = MixinBot.api_transfer.create(pin, {
      asset_id: asset_id,
      opponent_id: recipient.uid,
      amount: amount,
      trace_id: transfer_trace,
      memo: transfer_memo
    })
    raise 'transfer failed' unless r['error'].nil?

    transfer!
  end

  def confirm_and_complete
    r = MixinBot.api_transfer.read(transfer_trace)
    raise 'can not read transfer in mixin network' if r['error'].present?

    if r['data']['amount'] == amount && r['data']['opponent_id'] == recipient.uid
      complete!
    end
  end

  def touch_processing_started_at
    touch(:processing_started_at)
  end

  def touch_paid_at
    touch(:paid_at)
  end

  def touch_transferred_at
    touch(:transferred_at)
  end

  def touch_completed_at
    touch(:completed_at)
  end
end
