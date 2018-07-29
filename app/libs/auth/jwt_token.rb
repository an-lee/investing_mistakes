# Reference: https://github.com/eparreno/rack-jwt

module Auth
  # Token encoding and decoding
  class JwtToken
    SUPPORTED_ALGORITHMS = %w(none HS256 HS384 HS512 RS256 RS384 RS512 ES256 ES384 ES512).freeze

    # abc123.abc123.abc123    (w/ signature)
    # abc123.abc123.          ('none')
    TOKEN_REGEX = /\A([a-zA-Z0-9\-\_\~\+\\]+\.[a-zA-Z0-9\-\_\~\+\\]+\.[a-zA-Z0-9\-\_\~\+\\]*)\z/

    def self.encode(payload, secret, alg = 'RS512')
      raise 'Invalid payload. Must be a Hash.' unless payload.is_a?(Hash)
      raise 'Invalid secret type.'             unless secret_of_valid_type?(secret)
      raise 'Unsupported algorithm'            unless algorithm_supported?(alg)

      # if using an unsigned token ('none' alg) you *must* set the `secret`
      # to `nil` in which case any user provided `secret` will be ignored.
      if alg == 'none'
        JWT.encode(payload, nil, alg)
      else
        JWT.encode(payload, secret, alg)
      end
    end

    def self.decode(token, secret, verify, options = {})
      options[:algorithm] = 'RS512'     if options[:algorithm].nil?

      raise 'Invalid token format.'     unless valid_token_format?(token)
      raise 'Invalid secret type.'      unless secret_of_valid_type?(secret)
      raise 'Unsupported verify value.' unless verify_of_valid_type?(verify)

      # If using an unsigned 'none' algorithm token you *must* set the
      # `secret` to `nil` and `verify` to `false` or it won't work per
      # the ruby-jwt docs. Using 'none' is probably not recommended.
      if options[:algorithm] == 'none'
        JWT.decode(token, nil, false, options)
      else
        JWT.decode(token, secret, verify, options)
      end
    end

    def self.valid_token_format?(token)
      token =~ TOKEN_REGEX
    end
    private_class_method :valid_token_format?

    def self.secret_of_valid_type?(secret)
      secret.nil? ||
        secret.is_a?(String) ||
        secret.is_a?(OpenSSL::PKey::RSA) ||
        secret.is_a?(OpenSSL::PKey::EC)
    end
    private_class_method :secret_of_valid_type?

    def self.algorithm_supported?(alg)
      SUPPORTED_ALGORITHMS.include?(alg)
    end
    private_class_method :algorithm_supported?

    def self.verify_of_valid_type?(verify)
      verify.nil? || verify.is_a?(FalseClass) || verify.is_a?(TrueClass)
    end
    private_class_method :verify_of_valid_type?
  end
end
