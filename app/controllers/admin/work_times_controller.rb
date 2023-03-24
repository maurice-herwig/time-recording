class Admin::WorkTimesController <Admin::ApplicationController
  load_and_authorize_resource

  def edit
  end

  def update
    # Get the comment_text
    comment_text = params[:work_time][:comment][:comment_text] || ""

    # check if the comment text present
    unless comment_text != ""
      flash[:danger] = "The work_time cannot be updated"
      render 'edit'
    end

    # Create a new comment
    Comment.create!(comment: comment_text,
                    user: current_user,
                    work_time: @work_time)

    # If the work_time valid updated the work time
    if @work_time.valid?
      @work_time.update(work_time_params)
      flash[:success] = "The work_time was updated successfully."
      redirect_to work_time_path
    else
      flash[:danger] = "The work_time cannot be updated"
      render 'edit'
    end
  end

  private def work_time_params
    params.require(:work_time).permit(:start_time, :end_time, :striking, :workplace_id)
  end
end
