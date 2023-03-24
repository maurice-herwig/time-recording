class WorkplacesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    # Login the admin user
    login_as(users(:admin))
  end

  test "admin workplaces test" do
    # Assert
    get admin_workplaces_path
    assert_response :success
  end

  test "admin new workplace test" do
    # Assert
    get new_admin_workplace_path
    assert_response :success
  end

  test "admin edit workplace test" do
    # Get the workplace
    workplace = workplaces(:test_workplace)

    # Assert
    get edit_admin_workplace_path(workplace)
    assert_response :success
  end

  test "admin show workplace test" do
    # Get the workplace
    workplace = workplaces(:test_workplace)

    # Assert
    get admin_workplace_path(workplace)
    assert_response :success
  end

  test "admin create workplace test" do
    # Assert
    post admin_workplaces_path, params: {workplace: {name: "Place to test",
                                                     street_name: "Teststraße",
                                                     street_number: "number",
                                                     city: "Testhausen",
                                                     zip_code: 54321
    }}
    assert_equal flash[:success], "The workplace was created successfully."
    assert_redirected_to admin_workplaces_path
  end

  test "admin delete workplace test" do
    # Get the workplace
    workplace = workplaces(:second_workplace)

    # Assert
    delete admin_workplace_path(workplace.id)
    assert_equal flash[:success], "The workplace was delete successfully!"
    assert_redirected_to admin_workplaces_path
  end
end