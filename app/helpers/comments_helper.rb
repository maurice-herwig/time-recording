module CommentsHelper

  def comment_to_string(comment)
    # convert a comment to a string
    res = comment.comment
    if res.length > 20
      res = res[0..18] + '...'
    end

    res = res + ' by ' + comment.user.name
    res
  end


end