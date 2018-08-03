module MixinBot
  module API
    class Message
      attr_reader :client

      def initialize(options)
        @client = Client.new
      end

      def read(data)
        io = StringIO.new(data.pack('c*'), 'rb')
        gzip = Zlib::GzipReader.new io
        msg = gzip.read
        gzip.close
        return msg
      end

      def write(action, params)
        msg = {
          "id": SecureRandom.uuid,
          "action":  action,
          "params": params
        }.to_json

        io = StringIO.new 'wb'
        gzip = Zlib::GzipWriter.new io
        gzip.write msg
        gzip.close
        data = io.string.unpack('c*')
      end
    end
  end
end
