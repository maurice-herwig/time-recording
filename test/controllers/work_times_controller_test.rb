class WorkTimeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    # Login the user
    user = users(:admin)
    user.personal_secret = "secret"
    login_as(user)
  end

  test "show work time test" do
    # Get the work time
    work_time = work_times(:hard_work)

    # Assert that we can visit show work time
    get work_time_path(work_time)
    assert_response :success
  end

  test "create work time test" do
    # Create a new monthly work object for the work time and get the workplace
    monthly_work = MonthlyWork.new(user: users(:admin), year: Time.current.year, month:Time.current.month)
    monthly_work.save
    workplace = workplaces(:test_workplace)

    # Assert that we can create a new work time object
    post work_times_path, params: {work_time: {personal_secret: {secret: "secret"},
                                               monthly_work: monthly_work.id,
                                               workplace_id: workplace.id
    }}
    assert_equal flash[:success], "Work time was successfully created"
    assert_redirected_to root_path
  end

  test "new work time test" do
    # Create a new monthly work object
    monthly_work = MonthlyWork.new(user: users(:admin), year: Time.current.year, month:Time.current.month)
    monthly_work.save

    # Assert that we can visit the new work time view
    get new_work_time_path, params: {monthly_work: monthly_work.id}
    assert_response :success
  end

  test "edit work time test" do
    # Get the workplace
    workplace = workplaces(:test_workplace)

    # Create a new monthly work object and a new work time object
    monthly_work = MonthlyWork.new(user: users(:admin), year: Time.current.year, month:Time.current.month)
    monthly_work.save
    work_time = WorkTime.new(monthly_work: monthly_work, workplace: workplace, start_time: Time.current, striking: false )
    work_time.save

    # Assert that we can visit the edit view
    get edit_work_time_path(work_time.id)
    assert_response :success
  end

  test "update work time test" do
    # Get the workplace
    workplace = workplaces(:test_workplace)

    # Create a new monthly work object and a new work time object
    monthly_work = MonthlyWork.new(user: users(:admin), year: Time.current.year, month:Time.current.month)
    monthly_work.save
    work_time = WorkTime.new(monthly_work: monthly_work, workplace: workplace, start_time: Time.current, striking: false )
    work_time.save

    # Assert
    put work_time_path(work_time), params: {work_time: {personal_secret: {secret: "secret"}}}
    assert_equal flash[:success], "Finished the work time"
    assert_redirected_to root_path(thank: true)

  end
end