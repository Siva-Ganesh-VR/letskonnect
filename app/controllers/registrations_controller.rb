class RegistrationsController < ApplicationController
  layout false

  def new; end

  def create
    @user = User.new(
      name: params[:name], email: params[:email],
      password: params[:password], password_confirmation: params[:password_confirmation],
      role: %w[organizer attendee].include?(params[:role]) ? params[:role] : "attendee"
    )
    if @user.save
      session[:user_id] = @user.id
      redirect_to after_role_path(@user.role), notice: "Account created! Welcome to LetsKonnect."
    else
      flash.now[:alert] = @user.errors.full_messages.first
      render :new, status: :unprocessable_content
    end
  end

  private
  def after_role_path(role)
    role == "organizer" ? organizer_root_path : attendee_root_path
  end
end
