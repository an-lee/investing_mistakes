module MixinAPI
  module API
    class Auth
      attr_reader :client_id, :client_secret, :session_id, :pin_code, :pin_token, :private_key
      attr_reader :client

      def initialize(options)
        @client_id = options[:client_id]
        @client_secret = options[:client_secret]
        @session_id = options[:session_id]
        @pin_code = options[:pin_code]
        @pin_token = Base64.decode64 options[:pin_token]
        @private_key = OpenSSL::PKey::RSA.new options[:private_key]
      end

      def access_token(method, uri, body)
        sig = Digest::SHA256.hexdigest (method + uri + body)
        iat = Time.now.utc.to_i
        exp = (Time.now.utc + 1.day).to_i
        jti = SecureRandom.uuid
        payload = {
          'uid': client_id,
          'sid': session_id,
          'iat': iat,
          'exp': exp,
          'jti': jti,
          'sig': sig
        }
        JWT.encode payload, private_key, 'RS512'
      end
    end
  end
end
