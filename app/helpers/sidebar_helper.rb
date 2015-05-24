module SidebarHelper
  
  def sidebar_item(link_text, link_path, icon_name, options = {})
    options ||= {}
    
    if available?(options)
      @@available = true
      if active?(options)
        options[:class] = "active"
        @@active        = true
      end
      content_tag(:li) do
        link_text = icon icon_name, link_text, class: "fa-fw" if icon_name
        link_to(link_path, options.slice(:class)) { link_text }
      end
    end
  end
  
  def sidebar_group(link_text, icon_name, group_name, &block)
    content     = ""
    items       = ""
    @@available = false
    @@active    = false
    items       = capture &block
    return unless @@available
    collapse_classes  = "list-group-submenu sidebar-child collapse"
    collapse_classes  << " in" if @@active
    content_tag(:li) do
      content << icon(icon_name, link_text, class: "fa-fw")
      content << "&nbsp;"
      content << tag(:span, class: "caret")
      content = link_to("#", data: { toggle: "collapse", target: "##{group_name}" }, aria: { expanded: "false", controls: group_name }) do
        content.html_safe
      end
      content << content_tag(:div, class: collapse_classes, id: group_name) do
        content_tag :ul, items, class: "nav nav-sidebar"
      end
      content.html_safe
    end
  end
  
  private
  
  def available?(options)
    options[:available_for_roles].nil? || current_role_include?(*options[:available_for_roles])
  end
  
  def active?(options)
    (options[:active_controllers].nil?  || options[:active_controllers].include?(controller_name)) &&
    (options[:active_actions].nil?      || options[:active_actions].include?(action_name)) &&
    (options[:active_paths].nil?        || options[:active_paths].include?(controller_name))
  end  
end