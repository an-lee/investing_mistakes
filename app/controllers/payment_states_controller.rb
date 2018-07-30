class PaymentStatesController < ApplicationController
  before_action :load_payment

  def show
    return if @payment.blank?

    r = MixinBot.api_payment.verify({
        recipient_id: Figaro.env.MIXIN_CLIENT_ID,
        asset_id: @payment.asset_id,
        amount: @payment.amount,
        trace: @payment.trace
      })

    if r['data'].fetch('status') == 'paid'
      @payment.pay! if @payment.processing?
      render plain: 'paid'
    elsif r['data'].fetch('status') == 'pending'
      render plain: 'pending'
    else
      render plain: ''
    end
  end

  private

  def load_payment
    @payment = Payment.find_by(trace: params[:trace])
  end
end
