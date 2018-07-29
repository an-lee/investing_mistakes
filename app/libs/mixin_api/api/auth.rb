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
        @client = Client.new
      end

      def access_token(method, uri, body)
        sig = Digest::SHA256.hexdigest (method + uri + body)
        iat = Time.now.utc.to_i
        exp = (Time.now.utc + 200.seconds).to_i
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

      def encrypted_pin
        ts = Time.now.utc.to_i
        tszero = ts % 0x100
        tsone = (ts % 0x10000) >> 8
        tstwo = (ts % 0x1000000) >> 16
        tsthree = (ts % 0x100000000) >> 24
        tsstring = tszero.chr + tsone.chr + tstwo.chr + tsthree.chr + '\0\0\0\0'
        toEncryptContent = pin_code + tsstring + tsstring
        lenOfToEncryptContent = toEncryptContent.length
        toPadCount = 16 - lenOfToEncryptContent % 16
        if toPadCount > 0
          paddedContent = toEncryptContent + toPadCount.chr * toPadCount
        else
          paddedContent = toEncryptContent
        end

        alg = "AES-256-CBC"
        aes = OpenSSL::Cipher::Cipher.new(alg)
        iv = OpenSSL::Cipher::Cipher.new(alg).random_iv
        aes.encrypt
        aes.key = _aes_key
        aes.iv = iv
        cipher = aes.update(paddedContent)
        cipher << aes.final
        cipher64 = [cipher].pack('m')
        msg = iv + cipher64

        Base64.encode64 msg
      end

      private

      def _aes_key
        decrypted_string = JOSE::JWA::PKCS1::rsaes_oaep_decrypt('SHA256', pin_token, private_key, session_id)
        Base64.encode64 decrypted_string
      end
    end
  end
end
