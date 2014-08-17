class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :require_login
  add_flash_types :error, :success

  private

  def not_authenticated
    redirect_to login_path, notice: 'Please login first'
  end

  def admin?
    current_user.admin?
  end
end
