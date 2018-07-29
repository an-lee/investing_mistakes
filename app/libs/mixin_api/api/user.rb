module MixinAPI
  module API
    class User
      attr_reader :client

      def initialize
        @client = Client.new
      end

      def read_profile(access_token=nil)
        access_token ||= MixinAPI.api_auth.access_token('GET', '/me', '')
        authorization = format('Bearer %s', access_token)
        client.get('me', headers: { 'Authorization': authorization })
      end

      def read_assets(access_token=nil)
        access_token ||= MixinAPI.api_auth.access_token('GET', '/assets', '')
        authorization = format('Bearer %s', access_token)
        client.get('assets', headers: { 'Authorization': authorization })
      end
    end
  end
end
