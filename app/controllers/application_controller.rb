class ApplicationController < ActionController::Base
  include Clearance::Controller
  around_action :set_timezone, if: :signed_in?
  before_action :set_locale, if: :signed_in?
  before_action :set_paper_trail_whodunnit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def append_info_to_payload(payload)
    super
    payload[:remote_ip] = request.remote_ip
    payload[:user_id] = current_user.id if signed_in?
  end

  private

  def set_timezone
    Time.use_zone(current_user.timezone) { yield }
  end

  def set_locale
    I18n.locale = current_user.locale || I18n.default_locale
  end

  def set_paper_trail_whodunnit
    PaperTrail.whodunnit = current_user
  end
end
