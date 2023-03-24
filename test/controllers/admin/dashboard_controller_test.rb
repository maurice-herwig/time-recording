class DashboardControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    # Login the admin user
    login_as(users(:admin))
  end

  test "admin dashboard test" do

    get admin_root_path
    assert_response :success
  end

end
