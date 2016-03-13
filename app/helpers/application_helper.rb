module ApplicationHelper
  
  LOCALE_LIST = { en: "English", ru: "Русский" }
  BANKS_BASE_NAME = "Banks Base"
  
  def current_locale_name
    LOCALE_LIST[I18n.locale]
  end
  
  def locale_list
    LOCALE_LIST
  end
  
  # Returns the company name.
  def banks_base_name
    BANKS_BASE_NAME
  end
  
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = banks_base_name
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  # Uri redirections form http to https
  def process_uri(uri)
     avatar_url = URI.parse(uri)
     avatar_url.scheme = 'https'
     avatar_url.to_s
  end

  # Return time ago with full date time tooltip
  def time_ago_tag(from_time, options = {})
    return unless from_time
    
    options                   ||= {}
    options["data-toggle"]    ||= "tooltip"
    options["data-placement"] ||= "top"
    options[:title]           ||= l(from_time, format: :long)
    
    content_tag(:span, "#{time_ago_in_words(from_time)} #{t('ago')}", options) 
  end
  
  def not_found
    raise ActionController::RoutingError.new "Not Found"
  end
  
  def default_grid_system
    "xl"
  end

  def default_col_class
    "col-#{default_grid_system}-12"
  end
  
  def default_small_col_class
    "col-#{default_grid_system}-3"
  end

  def default_large_col_class
    "col-#{default_grid_system}-9"
  end
  
  def default_large_col_offset_class
    "col-#{default_grid_system}-offset-3"
  end
  
  def default_mix_small_col_class
    "col-lg-3 col-xl-3"
  end
  
  def default_mix_large_col_class
    "col-lg-9 col-xl-9"
  end
  
  def error_messages(object, method = nil)
    if method
      each_error object.errors[method]
    else
      each_error object.errors.full_messages
    end
  end
  
  def each_error(error_arr)
    if error_arr.any?
      error_content = String.new
      content_tag(:ui) do
        error_arr.each { |msg| error_content << content_tag(:li, msg, class: "text-danger") }
      end
      error_content.html_safe
    end
  end
  
  def nav_link_to(link_text, link_path)
    options = {}
    options[:class] = "nav-item" 
    if request.path == link_path.split("?")[0]
      options[:class] << " active" 
      link_text << " <span class=""sr-only"">(current)</span>"
    end
    content_tag(:li, options) { link_to link_text.html_safe, link_path, class: "nav-link" }
  end
  
  def settings_root_path
    case current_role
    when "admin"      then settings_users_path
    when "bank_user"  then settings_users_path
    else my_profile_path(current_user)
    end
  end
  
  def user_label(user)
    role        = user.role
    label_style = case role
    when "admin"      then "default"
    when "bank_user"  then "success"
    when "user"       then "warning"
    end
    content_tag :span, role, class: "label label-#{label_style}"
  end
end
