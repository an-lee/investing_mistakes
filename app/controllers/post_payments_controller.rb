class PostPaymentsController < ApplicationController
  before_action :load_post

  def new
    @payment = @post.receivables.new(
      asset_id: Post::AVAILABLE_PAYMENT.fetch(:asset_id),
      recipient: @post.author,
      amount: 100
    )
    @payment.setup_trace
  end

  def create
    @payment = current_user.payments.new(payment_params)
    @payment.post = @post
    @payment.recipient = @post.author
    @payment.payer = current_user

    if @payment.save
      @path = CreateMixinPaymentPathService.new.call(
        recipient: @payment.recipient.uid,
        asset: @payment.asset_id,
        amount: @payment.amount,
        trace: @payment.trace,
        memo: @payment.memo,
      )
      @payment.started_processing_payment!

      if browser.device.mobile?
        redirect_to @path
      else
        render 'create'
      end
    end
  end

  private

  def load_post
    @post = Post.find(params[:post_id])
  end

  def payment_params
    params.require(:payment).permit(:asset_id, :trace, :amount, :memo)
  end
end
