require "test_helper"

class MonthlyWorkTest < ActiveSupport::TestCase
  test "create new monthly work" do
    # Get a user
    user = users(:admin)

    # Create a new monthly work object
    monthly_work = MonthlyWork.new(month: 3,
                                   year: 2022,
                                   user: user)

    # Assert that the workplace is valid
    assert monthly_work.save

    # Assert the values
    assert_equal monthly_work.user, user
    assert_equal monthly_work.date, "3. 2022"
  end
end
