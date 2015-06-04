module FilterHelper
  
  def current_filter
    params[:filter]
  end
  
  def current_filter?(filter_option)
    current_filter == filter_option[1]
  end
  
  def current_filter_icon(filter_option)
    "check" if current_filter?(filter_option[1])
  end
  
  def filter_link_to(filter_option)
    check_icon = current_filter_icon(filter_option)
    link_to icon(check_icon, filter_option[0], class: "fa-fw"), params.merge({ filter: filter_option[1] })
  end
end