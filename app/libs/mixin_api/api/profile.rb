module MixinAPI
  module API
    class Profile
      attr_reader :client

      def initialize
        @client = Client.new
      end

      def read(access_token)
        path = 'me'
        authorization = format('Bearer %s', access_token)
        client.get(path, headers: { 'Authorization': authorization })
      end
    end
  end
end

# eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJhaWQiOiIxZDgxZGJkNi02OWZlLTQ0NjAtYjU1Yy1hMGNhNmYyZDg0ZWMiLCJleHAiOjE1NjI0MzA4ODMsImlhdCI6MTUzMDg5NDg4MywiaXNzIjoiMWRjNzljZTYtZjI5Ni00ZGE1LWFjMTEtNzljODgyMzk1YjA2In0.AfI_Q0bDEX3zZHWtLM1mXSh9IS7B5IeUdwndqRhQIyQ0fUVevLVgC0hYHIXRccp5--82C7uikNzZLjZbanxKOSyrZWj6HWp_Q4IgT68mSnA23Nt24-CcLsCJ0FZimuApeSMd5DkC7vzD19X6QKbekUcR8ySRZN8YBTfkbfDMeDQ
