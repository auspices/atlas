module ApiPaginationHelper
  def paginate(collection, options = {})
    current_page_num = collection.current_page
    last_page_num = collection.total_pages
    {
      first: first_page(options),
      previous: previous_page(current_page_num, options),
      self: current_page(current_page_num, options),
      next: next_page(current_page_num, last_page_num, options),
      last: last_page(last_page_num, options)
    }
  end

  def first_page(options = {})
    { href: url_for(options.merge(page: 1, only_path: false)) }
  end

  def previous_page(current_page_num, options)
    return nil if current_page_num <= 1
    { href: url_for(options.merge(page: current_page_num - 1, only_path: false)) }
  end

  def current_page(current_page_num, options)
    { href: url_for(options.merge(page: current_page_num, only_path: false)) }
  end

  def next_page(current_page_num, last_page_num, options)
    return nil if current_page_num >= last_page_num
    { href: url_for(options.merge(page: current_page_num + 1, only_path: false)) }
  end

  def last_page(last_page_num, options)
    { href: url_for(options.merge(page: last_page_num, only_path: false)) }
  end
end
