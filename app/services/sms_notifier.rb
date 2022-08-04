# frozen_string_literal: true

class SmsNotifier
  TWILIO = Twilio::REST::Client.new(ENV.fetch('TWILIO_ACCOUNT_SID', nil), ENV.fetch('TWILIO_AUTH_TOKEN', nil))

  class << self
    def send(to:, body:)
      TWILIO.messages.create(from: ENV.fetch('TWILIO_PHONE_NUMBER', nil), to:, body:)
    end
  end
end
