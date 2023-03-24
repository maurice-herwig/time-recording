require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "create comment" do
    # Get work_time and user
    user = users(:admin)
    work_time = work_times(:hard_work)

    # Create a new comment
    comment = Comment.new(comment: "Das ist ein Kommentar",
                          user: user,
                          work_time: work_time)

    # Assert that the comment is valid
    assert comment.save

    # Check the values
    assert_equal comment.comment, "Das ist ein Kommentar"
    assert_equal comment.user, user
    assert_equal comment.work_time, work_time
  end
end
