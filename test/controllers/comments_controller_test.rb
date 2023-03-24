class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    # Login the user
    user = users(:normal)
    login_as(user)
  end

  test "index comment test" do
    # Get the work_time
    work_time = work_times(:hard_work)

    # Assert that we can visit the comments path
    get comments_path(work_time: work_time)
    assert_response :success
  end

  test "create comment test" do
    # Get the work_time
    work_time = work_times(:hard_work)

    # Assert that we can creat a new comment
    post comments_path, params: {comment: {comment: "hello",
                                           work_time: work_time.id}}

    assert_equal flash[:success], "Comment was successfully created."
    assert_redirected_to comments_path(work_time: work_time)
  end


end
