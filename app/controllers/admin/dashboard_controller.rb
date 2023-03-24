class Admin::DashboardController <Admin::ApplicationController
  include PaginateConcern
  def index
    # Filters for all times marked as striking
    @work_times = paginate(WorkTime.where(striking: true ), 'desc', 'end_time')

    # Select all users that are current at work
    @users = User.select{|user| helpers.is_at_work?(user)}

  end
end