module MixinAPI
  module API
    class User
      attr_reader :client

      def initialize
        @client = Client.new
      end

      def read(user_id, access_token=nil)
        # user_id: Mixin User Id
        access_token ||= MixinAPI.api_auth.access_token('GET', format('/users/%s', user_id), '')
        authorization = format('Bearer %s', access_token)
        client.get(format('users/%s', user_id), headers: { 'Authorization': authorization })
      end

      def search(q, access_token=nil)
        # q: Mixin Id or Phone Number
        access_token ||= MixinAPI.api_auth.access_token('GET', format('/search/%s', q), '')
        authorization = format('Bearer %s', access_token)
        client.get(format('search/%s', q), headers: { 'Authorization': authorization })
      end

      def fetch(user_ids, access_token=nil)
        user_ids = [user_ids] if user_ids.is_a? String
        body = user_ids.to_json
        access_token ||= MixinAPI.api_auth.access_token('POST', '/users/fetch', body)
        authorization = format('Bearer %s', access_token)
        client.post('users/fetch', headers: { 'Authorization': authorization })
      end
    end
  end
end
