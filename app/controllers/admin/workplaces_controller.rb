class Admin::WorkplacesController <Admin::ApplicationController
  include PaginateConcern
  load_and_authorize_resource

  def index
    @workplaces = paginate(Workplace.all)
  end

  def create
    if @workplace.valid?
      @workplace.save!
      flash[:success] = "The workplace was created successfully."
      redirect_to admin_workplaces_path
    else
      flash[:danger] = "The workplace cannot be created."
      render 'new'
    end
  end

  def new
  end

  def edit
  end

  def show
    @users = paginate(@workplace.user)
  end

  def update
    if @workplace.update(workplace_params)
      flash[:success] = "The workplace was updated successfully."
      redirect_to admin_workplaces_path
    else
      flash[:danger] = "The workplace cannot be edit."
      render 'edit'
    end
  end

  def destroy
    @workplace.destroy
    flash[:success] = "The workplace was delete successfully!"
    redirect_to admin_workplaces_path
  end

  private def workplace_params
    params.require(:workplace).permit(:name, :street_name, :street_number, :city, :zip_code)
  end
end