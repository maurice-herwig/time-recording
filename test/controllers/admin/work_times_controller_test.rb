class WorkTimesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    # Login the admin user
    login_as(users(:admin))
  end

  test "admin update work time test" do
    # Get the work timme and a workplace
    work_time = work_times(:hard_work)
    workplace = workplaces(:test_workplace)

    # Asset
    put admin_work_time_path(work_time), params: {work_time: {start_time: Time.current,
                                                              end_time: Time.current,
                                                              striking: true,
                                                              workplace_id: workplace.id,
                                                              comment: {
                                                                comment_text: "change"
                                                              }}}
    assert_equal flash[:success], "The work_time was updated successfully."
    assert_redirected_to work_time_path

  end

end