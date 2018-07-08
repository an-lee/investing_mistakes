module MixinAPI
  module API
    class Payment
      attr_reader :client

      def initialize
        @client = Client.new
      end

      def verify(payment)
        path = 'payments'
        payload = {
          asset_id: payment.asset_id,
          opponent_id: payment.recipient.uid,
          amount: payment.amount,
          trace_id: payment.trace,
        }
        client.post(path, json: payload)
      end
    end
  end
end
