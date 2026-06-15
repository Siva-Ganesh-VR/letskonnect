class Admin::UsersController < Admin::BaseController
  def index
    @pagy, @users = pagy(User.order(created_at: :desc), items: 25)
  end

  def show
    @user = User.find_by!(id: params[:id])
    @registrations = @user.registrations.includes(:event, :ticket_tier)
  end

  def edit
    @user = User.find_by!(id: params[:id])
  end

  def update
    @user = User.find_by!(id: params[:id])
    if @user.update(params.require(:user).permit(:name, :role, :company, :title))
      redirect_to admin_user_path(@user), notice: "User updated."
    else
      render :edit
    end
  end

  def destroy
    @user = User.find_by!(id: params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: "User deleted."
  end
end
