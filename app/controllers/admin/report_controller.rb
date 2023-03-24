class Admin::ReportController < Admin::ApplicationController
  include PaginateConcern

  # Define constand
  TOTAL = 'total'
  DAYS = 'days'
  MONTHS = 'months'
  YEARS = 'years'
  REGULAR_EMPLOYEE = 'regular_worker'
  NON_REGULAR_EMPLOYEE = 'non_regular_worker'

  def user_report

    # Create a report for the given user
    def user_month_report(month, year)
      # auxiliary method to crate a month report
      this_month = {}
      total = 0

      monthly_works = MonthlyWork.find_or_create_by(month: month,
                                                    year: year,
                                                    user: @user)

      monthly_works.work_times.each { |work_time|
        worked_time = helpers.worked_time(work_time)
        total = total + worked_time

        @report[TOTAL][(work_time.workplace.name)] = @report[TOTAL][(work_time.workplace.name)] + worked_time
        if this_month.key?(work_time.workplace.name)
          this_month[work_time.workplace.name] = this_month[work_time.workplace.name] + worked_time
        else
          this_month[work_time.workplace.name] = worked_time
        end
      }

      this_month[TOTAL] = total
      this_month

    end

    def user_year_report(year)
      # auxiliary method to crate a year report
      this_year = {}
      total = 0

      (1..12).each { |month|
        monthly_works = MonthlyWork.find_or_create_by(month: month,
                                                      year: year,
                                                      user: @user)

        monthly_works.work_times.each { |work_time|
          worked_time = helpers.worked_time(work_time)
          total = total + worked_time

          @report[TOTAL][(work_time.workplace.name)] = @report[TOTAL][(work_time.workplace.name)] + worked_time
          if this_year.key?(work_time.workplace.name)
            this_year[work_time.workplace.name] = this_year[work_time.workplace.name] + worked_time
          else
            this_year[work_time.workplace.name] = worked_time
          end
        }
      }

      this_year[TOTAL] = total
      this_year
    end

    # Set the user of the report
    if params.key?(:user)
      @user = User.find(params[:user])
    else
      @user = current_user
    end

    # Set global variables
    @year = params[:year].try(:to_i) || 0
    @month = params[:month].try(:to_i) || 0
    @workplaces = paginate(Workplace.all, nil, 'id', 4)
    @report = {}
    @report[TOTAL] = {}

    # Init the total work for every workplace
    Workplace.all.each { |workplace|
      @report[TOTAL][workplace.name] = 0
    }

    # Check if report type day
    if @year != 0 && @month != 0

      # Set the days in the report
      (1..(Time.days_in_month(@month, @year))).each { |day|
        @report[day] = {}
        @report[day][TOTAL] = 0
      }

      # Get the monthly work object
      monthly_works = MonthlyWork.find_or_create_by(month: @month,
                                                    year: @year,
                                                    user: @user)

      # Iterate over all work times of this sorted by their start time
      monthly_works.work_times.sort_by { |work_time| work_time.start_time }.each { |work_time|
        worked_time = helpers.worked_time(work_time)
        day = work_time.start_time.day

        # Add the worked time to the report
        @report[day][TOTAL] = @report[day][TOTAL] + worked_time
        @report[TOTAL][(work_time.workplace.name)] = @report[TOTAL][(work_time.workplace.name)] + worked_time

        if @report[day].key?(work_time.workplace.name)
          @report[day][work_time.workplace.name] = @report[day][work_time.workplace.name] + worked_time
        else
          @report[day][work_time.workplace.name] = worked_time
        end
      }

      puts @report

      # Set the report type
      @report_type = DAYS

    elsif @year != 0
      # Check if report type month

      # Set the number of months
      if @year == Time.current.year
        months = (1..Time.current.month)
      else
        months = (1..12)
      end

      # Use the auxiliary method to crate a month report
      months.each.each { |month|
        @report[month] = user_month_report(month, @year)
      }

      # Set the report type
      @report_type = MONTHS

    else
      # The default report type is year
      # Use the auxiliary method to crate a month report
      (2020..Time.current.year).each.each { |year|
        @report[year] = user_year_report(year)
      }

      # Set the report type
      @report_type = YEARS

    end

    # Compute the total work time
    @report[TOTAL][TOTAL] = 0
    Workplace.all.each { |workplace|
      @report[TOTAL][TOTAL] = @report[TOTAL][TOTAL] + @report[TOTAL][workplace.name]
    }

    # Choose the format
    respond_to do |format|
      format.html { render }
      format.json { render json: { report: @report } }
      format.xml { render xml: @report }
    end

  end

  def workplace_report
    def workplace_month_report(month)
      # auxiliary method to crate a month report
      this_month = {}
      this_month[REGULAR_EMPLOYEE] = 0
      this_month[NON_REGULAR_EMPLOYEE] = 0

      # Iterate ove all users
      for user in User.all

        # Determine the type of the user
        worker_type = NON_REGULAR_EMPLOYEE
        if user.workplace == @workplace
          worker_type = REGULAR_EMPLOYEE
        end

        # Get the monthly works object
        monthly_works = MonthlyWork.find_or_create_by(month: month,
                                                      year: @year,
                                                      user: user)

        # Iterate over all work times an add the work time if the work was on this workplace
        monthly_works.work_times.each { |work_time|
          if work_time.workplace == @workplace
            worked_time = helpers.worked_time(work_time)
            this_month[worker_type] = this_month[worker_type] + worked_time
            @report[TOTAL][worker_type] = @report[TOTAL][worker_type] + worked_time
          end
        }
      end

      # Compute the total work time for this month on the workplace
      this_month[TOTAL] = this_month[REGULAR_EMPLOYEE] + this_month[NON_REGULAR_EMPLOYEE]
      this_month
    end

    # Get the workplace
    @workplace = Workplace.find(params[:workplace])

    # Set global variables
    @year = params[:year].try(:to_i) || 0
    @month = params[:month].try(:to_i) || 0
    @report = {}

    # Init total
    @report[TOTAL] = {}
    @report[TOTAL][REGULAR_EMPLOYEE] = 0
    @report[TOTAL][NON_REGULAR_EMPLOYEE] = 0

    # Check if report type day
    if @year != 0 && @month != 0

      (1..(Time.days_in_month(@month, @year))).each { |day|
        @report[day] = {}
        @report[day][TOTAL] = 0
        @report[day][REGULAR_EMPLOYEE] = 0
        @report[day][NON_REGULAR_EMPLOYEE] = 0
      }

      User.all.each { |user|
        # Get the monthly works object
        monthly_works = MonthlyWork.find_or_create_by(month: @month,
                                                      year: @year,
                                                      user: user)

        # Determine the type of the user
        worker_type = NON_REGULAR_EMPLOYEE
        if user.workplace == @workplace
          worker_type = REGULAR_EMPLOYEE
        end

        monthly_works.work_times.each { |work_time|
          if work_time.workplace == @workplace
            worked_time = helpers.worked_time(work_time)
            day = work_time.start_time.day

            @report[day][worker_type] = @report[day][worker_type] + worked_time
            @report[day][TOTAL] = @report[day][TOTAL] + worked_time
            @report[TOTAL][worker_type] = @report[TOTAL][worker_type] + worked_time
          end
        }
      }


      # Set the report type
      @report_type = DAYS

    elsif @year != 0
      # Check if report type month

      # Set the number of months
      if @year == Time.current.year
        months = (1..Time.current.month)
      else
        months = (1..12)
      end

      # Use the auxiliary method to crate a month report
      months.each.each { |month|
        @report[month] = workplace_month_report(month)
      }

      @report_type = MONTHS
    else
      # The default report type is year

      # Init for all year the report
      (2020..Time.current.year).each.each { |year|
        @report[year] = {}
        @report[year][REGULAR_EMPLOYEE] = 0
        @report[year][NON_REGULAR_EMPLOYEE] = 0
      }

      # Add for every work time the worked tome
      @workplace.work_times.each { |work_time|

        year = work_time.monthly_work.year
        worked_time = helpers.worked_time(work_time)

        if work_time.monthly_work.user.workplace == @workplace
          @report[year][REGULAR_EMPLOYEE] = @report[year][REGULAR_EMPLOYEE] + worked_time
          @report[TOTAL][REGULAR_EMPLOYEE] = @report[TOTAL][REGULAR_EMPLOYEE] + worked_time
        else
          @report[year][NON_REGULAR_EMPLOYEE] = @report[year][NON_REGULAR_EMPLOYEE] + worked_time
          @report[TOTAL][NON_REGULAR_EMPLOYEE] = @report[TOTAL][NON_REGULAR_EMPLOYEE] + worked_time
        end
      }

      # Compute for every year the total worked time
      (2020..Time.current.year).each.each { |year|
        @report[year][TOTAL] = @report[year][REGULAR_EMPLOYEE] + @report[year][NON_REGULAR_EMPLOYEE]
      }

      # Set the report type
      @report_type = YEARS
    end

    @report[TOTAL][TOTAL] = @report[TOTAL][REGULAR_EMPLOYEE] + @report[TOTAL][NON_REGULAR_EMPLOYEE]

    # Choose the format
    respond_to do |format|
      format.html { render }
      format.json { render json: { report: @report } }
      format.xml { render xml: @report }
    end

  end

  def download_excel
    # Get the params
    @report = params[:report]
    @report_type = params[:report_type]

    # Create a result variable
    @sheet = []

    # Compute the header
    header = []
    header << "#{t(@report_type)}"
    for head in @report[TOTAL].keys
      if head != TOTAL
        header << head
      end
    end
    header << TOTAL
    @sheet << header

    # Compute the body of the excel sheet
    @report.keys.each { |i|
      if i != TOTAL
        row = [i.to_s]
        header.slice(1, header.length).each { |j|
          if @report[i][j].present?

            minutes = @report[i][j].try(:to_i) || 0
            row << helpers.minutes_to_str(minutes)
          else
            row << 0
          end
        }
        @sheet << row
      end
    }

    # Add the total row
    row = ["#{t(TOTAL)}"]
    header.slice(1, header.length).each { |j|
      if j != "#{t(TOTAL)}"
        minutes = @report[TOTAL][j].try(:to_i) || 0
      else
        minutes = @report[TOTAL][TOTAL].try(:to_i) || 0
      end
      row << helpers.minutes_to_str(minutes)
    }

    @sheet << row

    # Render the excel file
    respond_to do |format|
      format.xlsx { render }
    end

  end

end