module ApplicationHelper
  def authorable?
    logged_in? && @user == current_user
  end

  def render_flash
    ActiveSupport::SafeBuffer.new.tap do |output|
      %i(notice success error).each do |message|
        output << content_tag(:div, class: "l-alerts is-#{message}") do
          flash[message]
        end if flash[message].present?
        flash[message] = nil
      end
    end
  end
end
