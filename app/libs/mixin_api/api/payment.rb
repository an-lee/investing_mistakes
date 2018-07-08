module MixinAPI
  module API
    class Payment
      attr_reader :client

      def initialize
        @client = Client.new
      end

      def pay(payment)
        path = format('pay?recipient=%s&asset=%s&amount=%s&trace=%s&memo=%s', payment.recipient.uid, payment.asset_id, payment.amount, payment.trace, payment.memo)
        client.get(path)
      end
    end
  end
end
