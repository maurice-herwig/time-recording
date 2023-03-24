require "test_helper"

class WorkTimeTest < ActiveSupport::TestCase
  test "create a new start time" do
    # Get the monthly work and workplace
    workplace = workplaces(:test_workplace)
    monthly_work = monthly_works(:test_month)

    # Create a new work_time
    work_time = WorkTime.new(workplace: workplace,
                             monthly_work: monthly_work,
                             striking: false)

    # Assert that work_time is valid
    assert work_time.save

    # Check the values
    assert_equal work_time.monthly_work, monthly_work
    assert_equal work_time.workplace, workplace
    assert_equal work_time.striking, false

    # Add start and end time to the work_time
    start_time = Time.new(2022, 2, 1, 8, 0, 0)
    end_time = Time.new(2022, 2, 1, 12, 30, 0)

    # Assert that the work time updated correct
    assert work_time.update(start_time: start_time, end_time: end_time)
    assert_equal work_time.start_time, start_time
    assert_equal work_time.end_time, end_time
  end
end
