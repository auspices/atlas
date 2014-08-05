class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :current_user
  helper_method :current_user

  private

  def current_user
    @current_user ||=
      if auth_str = request.env['HTTP_AUTHORIZATION']
        "#{ENV['ADMIN_USERNAME']}:#{ENV['ADMIN_PASSWORD']}" == Base64.decode64(auth_str.sub(/^Basic\s+/, ''))
      end
  end

  def authenticate
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      username == ENV['ADMIN_USERNAME'] && password == ENV['ADMIN_PASSWORD']
    end
  end
end
