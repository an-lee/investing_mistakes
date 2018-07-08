class CreateMixinPaymentPathService
  def call(options)
    recipient = options.fetch(:recipient)
    asset = options.fetch(:asset)
    amount = options.fetch(:amount)
    trace = options.fetch(:trace)
    memo = options.fetch(:memo)

    raise 'recipient is required!' if recipient.blank?
    raise 'asset is required!' if asset.blank?
    raise 'amount is required!' if amount.blank?

    path = format('https://mixin.one/pay?recipient=%s&asset=%s&amount=%s&trace=%s&memo=%s', recipient, asset, amount, trace, memo)
    path
  end
end
