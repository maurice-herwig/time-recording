module MonthlyWorkHelper

  def worked_time_this_moth(monthly_work)
    # compute the worked time for the given monthly work
    work_this_month = 0
    monthly_work.work_times.each do |work_time|
      work_this_month += worked_time(work_time)
    end
    work_this_month
  end

  def get_or_crate_monthly_work(user)
    # Get or create the monthly work object for the given user
    MonthlyWork.find_or_create_by(month: Time.current.month,
                                  year: Time.current.year,
                                  user: user)

  end

end