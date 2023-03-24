class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    # Login the user
    user = users(:normal)
    login_as(user)

  end

  test "home test" do
    # Assert that we can visit the home view
    get root_path
    assert_response :success
  end

  test "switch local" do
    # Assert that we can switch to german language
    get switch_locale_path('de')
    assert_equal :de, I18n.locale

    # Assert that we can switch to english language
    get switch_locale_path('en')
    assert_equal :en, I18n.locale
  end

  test "switch mobile mode" do
    # Assert that we can switch to german language
    get switch_mode_path('phone')
    assert_redirected_to root_path

    # Assert that we can switch to english language
    get switch_mode_path('pc')
    assert_redirected_to root_path
  end
end