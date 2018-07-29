module MixinAPI
  module API
    class Auth
      attr_reader :client

      def initialize
        @client = Client.new
      end

      def access_token
        hmac_secret = Figaro.env.MIXIN_PRIVATE_KEY
        iat = Time.now.utc
        epx = Time.now.utc + 200.seconds
        jti_raw = [hmac_secret, iat].join(':').to_s
        jti = Digest::MD5.hexdigest(jti_raw)
        payload = {
          'uid': Figaro.env.MIXIN_CLIENT_ID,
          'sid': Figaro.env.MIXIN_SESSION_ID,
          'iat': iat,
          'exp': exp,
          'jit': jit,
          'sig': jwtSig
        }
      end

      def encrypted_pin
        ts = Time.now.to_i
        tszero = ts % 0x100
        tsone = (ts % 0x10000) >> 8
        tstwo = (ts % 0x1000000) >> 16
        tsthree = (ts % 0x100000000) >> 24
        tsstring = tszero.chr + tsone.chr + tstwo.chr + tsthree.chr + '\0\0\0\0'
        toEncryptContent = Figaro.env.MIXIN_PIN_CODE + tsstring + tsstring
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
        session_id = Figaro.env.MIXIN_SESSION_ID
        pin_token_64 = Figaro.env.MIXIN_PIN_TOKEN
        pin_token = Base64.decode64 pin_token_64
        private_key = OpenSSL::PKey::RSA.new Figaro.env.MIXIN_PRIVATE_KEY
        decrypted_string = JOSE::JWA::PKCS1::rsaes_oaep_decrypt('SHA256', pin_token, private_key, session_id)

        Base64.encode64 decrypted_string
      end
    end
  end
end
