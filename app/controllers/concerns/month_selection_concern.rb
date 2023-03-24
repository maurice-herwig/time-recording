module MonthSelectionConcern
  extend ActiveSupport::Concern

  class MonthPager < Struct.new(:month, :year, :user)
  end

  def month_selection(user)
    # select with the given params the current monthly work object for the given user

    # Get the month and year
    month = params[:month].try(:to_i) || Time.current.month
    year = params[:year].try(:to_i) || Time.current.year

    # Convert month and year
    month, year = helpers.convert_month_year(month, year)

    # Create a new MonthPager object
    @month_pager = MonthPager.new(month, year, user)

    # Find or create the corresponding monthly work object
    MonthlyWork.find_or_create_by(month: month,
                                  year: year,
                                  user: user)
  end
end
