module WorkTimeHelper

  def worked_time(work_time)
    # Computes the worked time in minutes.
    if work_time.end_time && work_time.start_time
      time_diff = (work_time.end_time - work_time.start_time)
    elsif work_time.start_time
      time_diff = Time.current - work_time.start_time
    else
      time_diff = 0
    end

    # round to minutes
    (time_diff / 1.minute).round
  end

  def minutes_to_str(minutes)
    # Returns minutes time as str
    hours = (minutes / 60).round
    minutes = (minutes -hours * 60)

    "#{hours} #{t('hours')} #{minutes} #{t('minutes')} "
  end

  def convert_month_year(month = Time.current.month, year = Time.current.year)
    # Convert month and year. e.x. -1.2022 => 12.2021
    if month == 0
      month = 12
      year = year -1
    end

    if month > 12
      year = year + (month / 12).to_i
      month = (month % 12)
    elsif month < 1
      year = year - ((-1 * month) / 12).to_i - 1
      month = (month % 12)
    end

    # Set bounds of month and year
    if year < 2020
      year = 2020
    elsif year >= Time.current.year
      year = Time.current.year
      if month > Time.current.month
        month = Time.current.month
      end
    end

    [month, year]

  end

  def get_current_monthly_work(user = current_user)
    # Returns the currently monthly work object for a user. If the user have not finished the last work time,
    # return the monthly work object of the current work time, else the monthly work of the current month.
    monthly_work = MonthlyWork.find_or_create_by(month: Time.current.month,
                                                 year: Time.current.year,
                                                 user: user)

    if monthly_work.work_times.last.present?
      monthly_work
    else

      month, year = convert_month_year(Time.current.month - 1.month, Time.current.year)

      last_monthly_work = MonthlyWork.find_or_create_by(month: month,
                                                        year: year,
                                                        user: current_user)

      if have_finished_last_work_time?(last_monthly_work)
        monthly_work
      else
        last_monthly_work
      end
    end
  end

  def have_finished_last_work_time?(monthly_work)
    # Return true if the for the monthly work object, exists no not finished work time
    if monthly_work.work_times.last.present?
      work_time = monthly_work.work_times.last

      if work_time.start_time.present?
        work_time.end_time.present?
      else
        raise "The start time of the last work time is not set"
      end

    else
      true
    end

  end

  def is_at_work?(user = current_user)
    # Check if the user have finished the last work time => he is at work

    monthly_work = get_current_monthly_work(user)
    (not have_finished_last_work_time?(monthly_work))

  end

end