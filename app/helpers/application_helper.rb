# frozen_string_literal: true

module ApplicationHelper
  def authorable?
    logged_in? && @user == current_user
  end

  def render_flash
    ActiveSupport::SafeBuffer.new.tap do |output|
      %i[notice success error].each do |message|
        if flash[message].present?
          output << content_tag(:div, class: "Alert Alert--#{message}") do
            flash[message]
          end
        end
        flash[message] = nil
      end
    end
  end
end
