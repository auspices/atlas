module ApplicationHelper
  def authorable?
    logged_in? && @user == current_user
  end
end
