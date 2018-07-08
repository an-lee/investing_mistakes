class PaymentStatesController < ApplicationController
  before_action :load_payment

  def show
    return if @payment.blank?

    r = MixinAPI::api_payment.verify(@payment)
    Rails.logger.info r
    if r['data'].fetch('status') == 'paid'
      @payment.complete!
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
