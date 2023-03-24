require "application_system_test_case"

class LoginsTest < ApplicationSystemTestCase
  setup do

  end

  test "register new user" do
    # Setup
    email = "test@test.de"
    password = "password"
    personal_secret = "secret"

    # Visit the root page
    visit "/"

    # Assert that you are redirect to the log in page
    assert_selector "h2", text: "Log in"

    # Try to log in
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_on "Log in"

    # Assert that the login was unsuccessful
    assert_selector "h2", text: "Log in"

    # Go to Sign up
    click_on "Sign up"

    # Assert that you are on the sign up page
    assert_selector "h2", text: "Sign up"

    # Fill the form
    fill_in "Firstname", with: "Test"
    fill_in "Lastname", with: "Testmann"
    fill_in "Email", with: email
    fill_in "Password", with: password
    fill_in "Password confirmation", with: password
    fill_in "Personal secret", with: personal_secret

    # Register the new user
    click_on "Sign up"

    # Check that the registration was successfully
    assert_selector "p", text: "Hello Test Testmann"

    # Check that the new user exists
    user = User.find_by_email(email)
    assert user.present?

    # Assert the workplace of the user and the status
    assert_not user.is_admin?
    assert user.is_personal_secret_valid?(personal_secret)
    assert_equal user.workplace.name, "Users without workplaces"

    # Logout
    click_on "Logout"

    # Check that we on the login page
    assert_selector "h2", text: "Log in"

    # Login the user
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_on "Log in"

    # Check that the login was successfully
    assert_selector "p", text: "Hello Test Testmann"
  end

  test "login admin user" do
    # Setup
    email = "admin@test.de"
    password = "password"
    user = User.new(email: email,
                    firstname: 'first',
                    lastname: 'last',
                    password: password,
                    personal_secret: 'secret',
                    is_admin: true)
    user.save

    # Visit the root page
    visit "/"

    # Assert that you are redirect to the login page
    assert_selector "h2", text: "Log in"

    # Login
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_on "Log in"

    # Check that we are now on the home screen
    assert_selector "p", text: "Hello first last"

    # check that we can visit the admin page
    click_on "Admin"

    # Assert that we are on the admin page
    assert_selector "h3", text: "Working hours marked as striking"

    # check that we can visit the admin workplace page
    click_on "Workplace"

    # Assert that we are on the admin page
    assert_selector "h3", text: "Workplaces"

    # check that we can visit the admin users page
    click_on "Employees"

    # Assert that we are on the admin page
    assert_selector "h3", text: "Employees"

    # Logout
    click_on "Logout"

    # Check that we on the login page
    assert_selector "h2", text: "Log in"
  end

end
