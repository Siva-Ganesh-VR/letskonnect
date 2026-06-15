class SessionsController < ApplicationController
  layout false

  def new
    redirect_to organizer_root_path if signed_in? && current_user.organizer?
    redirect_to attendee_root_path  if signed_in? && current_user.attendee?
    redirect_to admin_root_path     if signed_in? && current_user.admin?
  end

  def create
    user = User.find_by(
      email: params[:email]&.downcase,
      role: (%w[organizer attendee admin].include?(params[:role]) ? params[:role] : nil)
    )
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to after_login_path(user), notice: "Welcome back, #{user.name}!"
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_content
    end
  end

  def demo
    role = %w[organizer attendee admin].include?(params[:role]) ? params[:role] : "attendee"
    user = User.where(role: role).order(:created_at).first
    if user
      session[:user_id] = user.id
      redirect_to after_login_path(user), notice: "Signed in as demo #{role}."
    else
      redirect_to login_path, alert: "No demo #{role} found."
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: "Signed out."
  end

  def switch_role
    target = params[:target_role]
    if current_user && %w[organizer attendee].include?(target) &&
       (current_user.organizer? || current_user.attendee?)
      current_user.update!(role: target)
      redirect_to target == "organizer" ? organizer_root_path : attendee_root_path,
                  notice: "Switched to #{target} mode."
    else
      redirect_back fallback_location: root_path
    end
  end

  private

  def after_login_path(user)
    stored = session.delete(:return_to)
    case user.role
    when "organizer" then stored || organizer_root_path
    when "admin"     then stored || admin_root_path
    else                  stored || attendee_root_path
    end
  end
end
