# frozen_string_literal: true

class SmsNotifier
  TWILIO = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

  class << self
    def send(to:, body:)
      TWILIO.messages.create(from: ENV['TWILIO_PHONE_NUMBER'], to: to, body: body)
    end
  end
end
