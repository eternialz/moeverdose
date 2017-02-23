class CommentCell < Cell::ViewModel

  def show
    if model.report
      render :reported
    else
      render :comment
    end
  end
end
