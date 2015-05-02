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
    base_title = "About bank"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
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
    when "superadmin", "admin", "bank_admin", "bank_user" then users_path
    else user_path(current_user)
    end
  end
  
  def user_label(user)
    role = user.role
    case role
    when "superadmin", "admin" then content_tag(:span, role, class: "label label-default")
    when "bank_admin", "bank_user" then content_tag(:span, role, class: "label label-success")
    when "user" then content_tag(:span, role, class: "label label-warning")
    end
  end
  
  def sidebar_item(link_text, link_path, icon_name, options)
    options[:available_for_roles] ||= []
    options[:active_controllers]  ||= []
    options[:active_paths]        ||= []
    
    if current_role_include?(*options[:available_for_roles]) || options[:available_for_roles].empty?
      if (options[:active_controllers].include?(controller_name) || options[:active_paths].include?(request.path)) && (options[:active_actions].empty? ||  options[:active_actions].include?(action_name))
        options[:class] = "active"
      end
      link_to(link_path, options.slice(:class)) do
        icon icon_name, link_text, class: "fa-fw"
      end
    end
  end
end
