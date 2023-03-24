module PaginateConcern
  extend ActiveSupport::Concern

  class Pager < Struct.new(:page, :pagesize, :pages)
  end

  def paginate(object_list, order = nil, order_by = 'id', pages_size = nil)
    # Paginate the given object

    # If the page size is not given. Set the page size to 10 in computer mode and to 4 in mobil mode
    unless pages_size.present?
      if @mobile_mode
        pages_size = 4
      else
        pages_size = 10
      end
    end

    # Compute the number of pages and the current page
    page = params[:page].try(:to_i) || 1
    page = 1 if page < 1
    page_size = params[:pagesize].try(:to_i) || pages_size
    pages = (object_list.length + page_size - 1) / page_size
    page = [pages, page].min

    # possible reorder of the list
    if order.present?
      object_list = object_list.order(order_by => order)
    end

    # Create the pager object
    @pager = Pager.new(page, page_size, pages)

    # Return the currently objects of the currently page
    object_list.limit(page_size).offset((page - 1) * page_size)
  end
end