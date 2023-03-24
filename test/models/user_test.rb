require "test_helper"

class UserTest < ActiveSupport::TestCase

  test "crate new user" do
    # Crate a new user
    user = User.new(firstname: 'Test',
                    lastname: 'Testmann',
                    personal_secret: 'secret',
                    email: 'test@test.de',
                    monthly_hours: 10,
                    password: 'password')

    # Assert that the user is valid
    assert user.save

    # assert the values
    assert_equal user.firstname, 'Test'
    assert_equal user.lastname, 'Testmann'
    assert_equal user.name, 'Test Testmann'
    assert_equal user.email, 'test@test.de'
    assert_equal user.monthly_hours, 10

    # assert the new workplace
    assert user.workplace, Workplace.all.last

    # assert the personal secret
    assert user.is_personal_secret_valid?('secret')
    assert_not user.is_personal_secret_valid?('false')

    # assert is no admin
    assert_not user.is_admin?
  end

  test "admin user" do
    # Get the admin user
    admin_user = users(:admin)

    # check that the admin is a admin
    assert admin_user.is_admin?
  end

  test "normal user" do
    # Get the admin user
    normal_user = users(:normal)

    # check that the admin is a admin
    assert_not normal_user.is_admin?
  end

  test 'email unique' do
    # Setup
    user = users(:admin)
    user1 = User.new(email: user.email,
                     firstname: 'first',
                     lastname: 'last',
                     password: 'password',
                     personal_secret: 'secret')

    # Assert that user email is unique
    assert_not user1.save
    assert_equal user1.errors.map(&:attribute), [:email]
  end

end
