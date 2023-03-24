class MonthlyWorksController <ApplicationController
  include MonthSelectionConcern
  include PaginateConcern
  load_and_authorize_resource

  def index
    # Get the given user or if no user given set the user to the current user
    user = params[:user].present? ? User.find(params[:user]) : current_user

    # Get the current chosen monthly work object
    @monthly_work = month_selection(user)
    render layout: false
  end

  def show
    # Get the paginated work times of the give monthly work
    @work_times = paginate(@monthly_work.work_times, 'desc', 'end_time')
    render layout: false
  end

end