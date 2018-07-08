module MixinAPI
  module API
    class User
      attr_reader :client

      def initialize
        @client = Client.new
      end

      def read_profile(access_token)
        path = 'me'
        authorization = format('Bearer %s', access_token)
        client.get(path, headers: { 'Authorization': authorization })
      end

      def read_assets(access_token)
        path = 'assets'
        authorization = format('Bearer %s', access_token)
        client.get(path, headers: { 'Authorization': authorization })
      end
    end
  end
end
