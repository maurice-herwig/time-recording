class CommentsController < ApplicationController
  include PaginateConcern
  load_and_authorize_resource

  def index
    # Get the work time for the showed comments
    @work_time = WorkTime.find(params[:work_time])

    # Paginate the selected comments
    @comments = paginate(@work_time.comments, 'desc', 'created_at')

    render layout: false
  end

  def create
    # Get the creator and the corresponding work time of the comment
    @comment.user = current_user
    @comment.work_time =  WorkTime.find(params[:comment][:work_time])

    # Save the comment if the comment valid
    if @comment.valid?
      @comment.save!
      flash[:success] = "Comment was successfully created."
      redirect_to comments_path(work_time: @comment.work_time)
    else
      flash[:danger] = "Comment can't created"
    end
  end

  private def comment_params
    params.require(:comment).permit(:comment)
  end

end