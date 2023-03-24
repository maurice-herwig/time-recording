class MonthlyWorkControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    # Login the user
    user = users(:normal)
    login_as(user)
  end

  test "index monthly work test" do
    # Assert that we can visit the monthly works path
    get monthly_works_path
    assert_response :success
  end

  test "show monthly work test" do
    # Get the monthly work
    monthly_work = monthly_works(:test_month)

    # Assert that we can visit the monthly work path
    get monthly_work_path(monthly_work)
    assert_response :success
  end
end