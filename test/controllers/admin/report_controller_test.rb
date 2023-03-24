class ReportControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    # Login the admin user
    login_as(users(:admin))
  end

  test "user report test" do
    # Assert that we can create a new admin user report for current user
    get admin_user_report_path
    assert_response :success
  end

  test "workplace test" do
    # Get the test workplace
    workplace = workplaces(:test_workplace)

    # Assert that we can create a workplace report
    get admin_workplace_report_path(workplace: workplace)
    assert_response :success
  end

end