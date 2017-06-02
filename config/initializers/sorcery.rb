# frozen_string_literal: true

# Available submodules are: :user_activation, :http_basic_auth, :remember_me,
# :reset_password, :session_timeout, :brute_force_protection, :activity_logging, :external
Rails.application.config.sorcery.submodules = []

Rails.application.config.sorcery.configure do |config|
  config.user_config do |user|
    user.username_attribute_names = [:username]
  end
  config.user_class = 'User'
end
