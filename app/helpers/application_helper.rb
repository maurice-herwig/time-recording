module ApplicationHelper
  def pager(path_name=nil)
    unless path_name
      path_name = "#{controller_name}_path"
    end
    render('application/pager',
           path_name: path_name,
           )
  end

  def month_pager(path_name=nil)
    unless path_name
      path_name = "#{controller_name}_path"
    end
    render('application/month_pager',
           path_name: path_name
    )
  end

  def comments_pager(path_name=nil)
    unless path_name
      path_name = "#{controller_name}_path"
    end
    render('application/comment_pager',
           path_name: path_name
    )
  end

end
