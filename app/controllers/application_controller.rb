class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :require_login

  private

  def not_authenticated
    redirect_to login_path, alert: 'Please login first'
  end

  def is_admin?
    current_user.is_admin?
  end
end
