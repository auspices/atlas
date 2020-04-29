# frozen_string_literal: true

namespace :notify do
  task :via_sms, %i[user_id collection_id] => [:environment] do |_task, args|
    user = User.find(args[:user_id])

    unless user.phone_number?
      puts "missing phone number for user:#{user.id}"
      next
    end

    collection = user.collections.find(args[:collection_id])
    content = collection.contents.unscope(:order).order('RANDOM()').first

    SmsNotifier.send(to: user.phone_number, body: content.to_sms)
  end
end
