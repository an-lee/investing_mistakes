module MixinAPI
  module API
    class Me
      attr_reader :client

      def initialize
        @client = Client.new
      end

      def read_profile(access_token=nil)
        access_token ||= MixinAPI.api_auth.access_token('GET', '/me', '')
        authorization = format('Bearer %s', access_token)
        client.get('me', headers: { 'Authorization': authorization })
      end

      def update_profile(full_name, avatar_base64, access_token=nil)
        body = {
          "full_name": full_name,
          "avatar_base64": avatar_base64
        }.to_json
        access_token ||= MixinAPI.api_auth.access_token('POST', '/me', body)
        authorization = format('Bearer %s', access_token)
        client.post('me', headers: { 'Authorization': authorization })
      end

      def read_assets(access_token=nil)
        access_token ||= MixinAPI.api_auth.access_token('GET', '/assets', '')
        authorization = format('Bearer %s', access_token)
        client.get('assets', headers: { 'Authorization': authorization })
      end
    end
  end
end
