module ApplicationHelper
  
  LOCALE_LIST = { en: "English", ru: "Русский" }
  
  def current_locale_name
    LOCALE_LIST[I18n.locale]
  end
  
  def locale_list
    LOCALE_LIST
  end
  
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Banks base"
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

  # Return HTML code with 
  def time_ago_tag(from_time, options = {})
    content_tag(:span, "#{time_ago_in_words(from_time)} #{t('ago')}", "data-toggle": "tooltip", "data-placement": "bottom", title: l(from_time, format: :long)) if from_time
  end
  
  def not_found
    raise ActionController::RoutingError.new "Not Found"
  end
  
  def default_grid_system
    "md"
  end

  def default_col_class
    "col-#{default_grid_system}-12"
  end
  
  def default_left_col_class
    "col-#{default_grid_system}-3"
  end

  def default_right_col_class
    "col-#{default_grid_system}-9"
  end
  
  def default_right_col_offset_class
    "col-#{default_grid_system}-offset-3"
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
    options[:class] = "active" if request.path == link_path.split("?")[0]

    content_tag(:li, options) { link_to link_text, link_path }
  end
  
  def dashboard_root_path
    case current_role
    when "admin" then dashboard_users_path
    when "bank_user" then dashboard_users_path
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
