# frozen_string_literal: true

class JsonWebToken
  class << self
    def encode(payload, exp = 7.days.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, Rails.application.credentials.secret_key_base, 'HS256')
    end

    def decode(token)
      payload = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256').first
      ActiveSupport::HashWithIndifferentAccess.new(payload)
    rescue StandardError
      nil
    end
  end
end
