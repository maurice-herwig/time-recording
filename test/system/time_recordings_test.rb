require "application_system_test_case"

class TimeRecordingsTest < ApplicationSystemTestCase

  test "time recording" do
    # Setup
    email = "admin@test.de"
    password = "password"
    is_admin = true
    secret = 'secret'

    # Get the workplace
    workplace = workplaces(:test_workplace)

    # Create the new user
    user = User.new(email: email,
                    firstname: 'first',
                    lastname: 'last',
                    password: password,
                    personal_secret: secret,
                    is_admin: is_admin,
                    workplace: workplace)
    user.save

    # Login the new user
    visit "/users/sign_in"
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_on "Log in"

    # Assert that we can start our working time
    assert_selector "h5", text: "Please enter your current workplace and your personal secret to start your working time."
    fill_in "work_time_personal_secret_secret", with: secret
    click_on "Start working time"

  end
end
