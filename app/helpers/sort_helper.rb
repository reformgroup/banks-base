module SortHelper
  
  def sortable(sort_params)
    unless sort_params.nil?
      if sort_params.is_a?(Array)
        sort_params.each do |item|
          sort_params item
        end
      end
    end
  end
  
  private
  
  def sort_item(item_options)
    raise ArgumentError, "Required parameter missing." if item_options[:column].nil?
    
    column    = item_options[:title] || item_options[:column].titleize
    direction = column == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
    css_class = "dropdown-item"
    css_class << " current #{params[:direction]}" if column == params[:sort]
    link_to title, { sort: column, direction: direction }, { class: css_class }
  end
  
  #def current_filter
  #  params[:filter]
  #end
  
  #def current_filter?(filter_option)
  #  current_filter == filter_option[1]
  #end
  
  #def current_filter_icon(filter_option)
  #  "check" if current_filter?(filter_option[1])
  #end
  
  #def filter_link_to(filter_option)
  #  check_icon = current_filter_icon(filter_option)
  #  link_to icon(check_icon, filter_option[0], class: "fa-fw"), params.merge({ filter: filter_option[1] })
  #end
end