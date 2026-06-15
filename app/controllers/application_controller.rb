class ApplicationController < ActionController::Base
  include Pagy::Backend if defined?(Pagy::Backend)

  helper_method :current_user, :signed_in?, :require_role
  before_action :set_cache_headers
  before_action :set_current_user

  private

  def set_current_user
    return unless session[:user_id]
    @current_user = User.find_by(id: session[:user_id])
    session.delete(:user_id) unless @current_user
  end

  def current_user = @current_user

  def signed_in? = current_user.present?

  def require_login
    unless signed_in?
      session[:return_to] = request.url
      redirect_to(login_path, alert: "Please sign in to continue.") and return
    end
  end

  def require_role(*roles)
    require_login
    return unless current_user

    redirect_to(root_path, alert: "You don't have access to that area.") and return unless roles.map(&:to_s).include?(current_user.role)
  end

  def require_organizer = require_role("organizer", "admin")
  def require_attendee  = require_role("attendee",  "admin")
  def require_admin     = require_role("admin")

  def set_cache_headers
    response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
