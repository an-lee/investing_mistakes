class PostPaymentsController < ApplicationController
  before_action :load_post

  def new
    @payment = @post.receivables.new(recipient: @post.author)
  end

  def create
    @payment = current_user.payments.new(payment_params)
    @payment.recipient = @post.author
    @payment.payer = current_user
    if @payment.save
      @payment.started_processing_payment!
      path = format('https://mixin.one/pay?recipient=%s&asset=%s&amount=%s&trace=%s&memo=%s', @payment.recipient.uid, @payment.asset_id, @payment.amount, @payment.trace, @payment.memo)
      redirect_to path
    end
  end

  private

  def load_post
    @post = Post.find(params[:post_id])
  end

  def payment_params
    params.require(:payment).permit(:asset_id, :amount, :memo)
  end
end
