class Admin::UsersController <Admin::ApplicationController
  include PaginateConcern
  load_and_authorize_resource

  def index
    @users = paginate(User.all)
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "The user was updated successfully."
      redirect_to admin_users_path
    else
      flash[:danger] = "The user cannot be updated"
      render 'admin/users/edit'
    end
  end

  private def user_params
    params.require(:user).permit(:firstname, :lastname, :monthly_hours, :is_admin, :workplace_id, :avatar)
  end

end