class WorkTimesController < ApplicationController
  include PaginateConcern
  load_and_authorize_resource

  def show
    # Check if the the current user the user of the work time or a admin user
    unless is_own_work_time_or_admin_user?(@work_time)
      return
    end
    @comments = paginate(@work_time.comments, 'desc', 'created_at')
  end

  def create
    # Get personal secret
    personal_secret = params[:work_time][:personal_secret][:secret] || ""

    # Check if personal secret valid
    unless current_user.is_personal_secret_valid?(personal_secret)
      return
    end

    # Set the monthly work object
    @work_time.monthly_work = MonthlyWork.find(params[:work_time][:monthly_work])

    unless is_work_time_from_current_user?(@work_time)
      return
    end

    # Set the workplace id
    @work_time.workplace = Workplace.find(params[:work_time][:workplace_id])

    # Check if for the monthly work the last work time is already finished yet
    unless helpers.have_finished_last_work_time?(@work_time.monthly_work)
      raise "Punching in not possible because the user is already logged in"
    end

    # Set the monthly work association, start_time and striking
    @work_time.start_time = Time.current
    @work_time.striking = false

    # Check if work time valid and save
    if @work_time.valid?
      @work_time.save!
      flash[:success] = "Work time was successfully created"
      redirect_to root_path
    else
      flash[:error] = "Cannot crate a new work time"
    end
  end

  def new

    # Check if the employee already logged in
    @monthly_work = MonthlyWork.find(params[:monthly_work])
    unless helpers.have_finished_last_work_time?(@monthly_work)
      raise "Punching in not possible because the user is already logged in"
    end

    render layout: false
  end

  def edit
    # Check if the the current user the user of the work time
    unless is_work_time_from_current_user?(@work_time)
      return
    end

    # Check if the user have start this work time
    if helpers.have_finished_last_work_time?(@work_time.monthly_work)
      raise "Punching out is not possible because the user has not yet punched in."
    end

    render layout: false
  end

  def update
    # Check if the user have start this work time
    unless is_work_time_from_current_user?(@work_time)
      return
    end

    # Get personal secret
    personal_secret = params[:work_time][:personal_secret][:secret] || ""

    # Check if personal secret valid
    unless current_user.is_personal_secret_valid?(personal_secret)
      return
    end

    # Set the end time of the work
    @work_time.end_time = Time.current

    # Check if the work time is longer than 8 hours
    if helpers.worked_time(@work_time) > 480
      @work_time.striking = true
    else
      @work_time.striking = false
    end

    # Check if work time valid and save
    if @work_time.valid?
      @work_time.save!
      flash[:success] = "Finished the work time"
      redirect_to root_path(thank: true)
    else
      flash[:error] = "Cannot finish the working time"
    end

  end

  private def is_work_time_from_current_user?(work_time)
    # Check that a user only change his own work time
    (work_time.monthly_work.user == current_user)
  end

  private def is_own_work_time_or_admin_user?(work_time)
    # check that a user have access to the work time if he is a admin or is it his own work time
    (current_user.is_admin || is_work_time_from_current_user?(work_time))
  end

  private def work_time_params
    params.require(:work_time).permit(:workplace)
  end
end