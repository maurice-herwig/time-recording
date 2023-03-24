class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    # Login the admin user
    login_as(users(:admin))
  end

  test "admin index admin users test" do
    # Assert index
    get admin_users_path
    assert_response :success
  end

  test "admin show user test" do
    # Assert show
    get admin_user_path(users(:normal))
    assert_response :success
  end

end