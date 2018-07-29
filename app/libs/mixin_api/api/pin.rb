module MixinAPI
  module API
    class Pin
      attr_reader :session_id, :pin_code, :pin_token, :private_key
      attr_reader :client

      def initialize(options)
        @session_id = options[:session_id]
        @pin_code = options[:pin_code]
        @pin_token = Base64.decode64 options[:pin_token]
        @private_key = OpenSSL::PKey::RSA.new options[:private_key]
        @client = Client.new
      end

      def verify(access_token=nil)
        payload = {
          "pin": encrypted_pin
        }
        access_token ||= MixinAPI.api_auth.access_token('POST', '/pin/verify', payload.to_json)
        authorization = format('Bearer %s', access_token)
        client.post('pin/verify', headers: { 'Authorization': authorization }, json: payload)
      end

      def encrypted_pin
        aes_key = Base64.encode64 JOSE::JWA::PKCS1::rsaes_oaep_decrypt('SHA256', pin_token, private_key, session_id)
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
        aes.key = aes_key
        aes.iv = iv
        cipher = aes.update(paddedContent)
        cipher << aes.final
        cipher64 = [cipher].pack('m')
        msg = iv + cipher64

        encoded = Base64.encode64 msg
        # encoded.gsub( /\n\z/, '' )
      end
    end
  end
end
